Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087E9C05BD
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfI0MwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:52:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43340 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0MwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 08:52:02 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iDpiu-0003PC-9y; Fri, 27 Sep 2019 08:51:55 -0400
Date:   Fri, 27 Sep 2019 08:51:42 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        dwalsh@redhat.com, mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
Message-ID: <20190927125142.GA25764@hmswarspite.think-freely.org>
References: <cover.1568834524.git.rgb@redhat.com>
 <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> Set an arbitrary limit on the number of audit container identifiers to
> limit abuse.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c | 8 ++++++++
>  kernel/audit.h | 4 ++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 53d13d638c63..329916534dd2 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -139,6 +139,7 @@ struct audit_net {
>  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
>  /* Hash for contid-based rules */
>  struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> +int audit_contid_count = 0;
>  
>  static struct kmem_cache *audit_buffer_cache;
>  
> @@ -2384,6 +2385,7 @@ void audit_cont_put(struct audit_cont *cont)
>  		put_task_struct(cont->owner);
>  		list_del_rcu(&cont->list);
>  		kfree_rcu(cont, rcu);
> +		audit_contid_count--;
>  	}
>  }
>  
> @@ -2456,6 +2458,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>  					goto conterror;
>  				}
>  			}
> +		/* Set max contids */
> +		if (audit_contid_count > AUDIT_CONTID_COUNT) {
> +			rc = -ENOSPC;
> +			goto conterror;
> +		}
You should check for audit_contid_count == AUDIT_CONTID_COUNT here, no?
or at least >=, since you increment it below.  Otherwise its possible
that you will exceed it by one in the full condition.

>  		if (!newcont) {
>  			newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
>  			if (newcont) {
> @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>  				newcont->owner = current;
>  				refcount_set(&newcont->refcount, 1);
>  				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> +				audit_contid_count++;
>  			} else {
>  				rc = -ENOMEM;
>  				goto conterror;
> diff --git a/kernel/audit.h b/kernel/audit.h
> index 162de8366b32..543f1334ba47 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
>  	return (contid & (AUDIT_CONTID_BUCKETS-1));
>  }
>  
> +extern int audit_contid_count;
> +
> +#define AUDIT_CONTID_COUNT	1 << 16
> +
Just to ask the question, since it wasn't clear in the changelog, what
abuse are you avoiding here?  Ostensibly you should be able to create as
many container ids as you have space for, and the simple creation of
container ids doesn't seem like the resource strain I would be concerned
about here, given that an orchestrator can still create as many
containers as the system will otherwise allow, which will consume
significantly more ram/disk/etc.

>  /* Indicates that audit should log the full pathname. */
>  #define AUDIT_NAME_FULL -1
>  
> -- 
> 1.8.3.1
> 
> 
