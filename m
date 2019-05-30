Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2522FD48
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfE3OQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfE3OQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:16:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56DA73082A98;
        Thu, 30 May 2019 14:16:09 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DE937AB52;
        Thu, 30 May 2019 14:15:58 +0000 (UTC)
Date:   Thu, 30 May 2019 10:15:55 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 09/10] audit: add support for containerid to
 network namespaces
Message-ID: <20190530141555.qqcbasvyp7eokwjz@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <423ed5e5c5e4ed7c3e26ac7d2bd7c267aaae777c.1554732921.git.rgb@redhat.com>
 <CAHC9VhQ9t-mvJGNCzArjg+MTGNXcZbVrWV4=RUD5ML_bHqua1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ9t-mvJGNCzArjg+MTGNXcZbVrWV4=RUD5ML_bHqua1Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 30 May 2019 14:16:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-29 18:17, Paul Moore wrote:
> On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Audit events could happen in a network namespace outside of a task
> > context due to packets received from the net that trigger an auditing
> > rule prior to being associated with a running task.  The network
> > namespace could be in use by multiple containers by association to the
> > tasks in that network namespace.  We still want a way to attribute
> > these events to any potential containers.  Keep a list per network
> > namespace to track these audit container identifiiers.
> >
> > Add/increment the audit container identifier on:
> > - initial setting of the audit container identifier via /proc
> > - clone/fork call that inherits an audit container identifier
> > - unshare call that inherits an audit container identifier
> > - setns call that inherits an audit container identifier
> > Delete/decrement the audit container identifier on:
> > - an inherited audit container identifier dropped when child set
> > - process exit
> > - unshare call that drops a net namespace
> > - setns call that drops a net namespace
> >
> > Please see the github audit kernel issue for contid net support:
> >   https://github.com/linux-audit/audit-kernel/issues/92
> > Please see the github audit testsuiite issue for the test case:
> >   https://github.com/linux-audit/audit-testsuite/issues/64
> > Please see the github audit wiki for the feature overview:
> >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  include/linux/audit.h | 19 +++++++++++
> >  kernel/audit.c        | 88 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  kernel/nsproxy.c      |  4 +++
> >  3 files changed, 108 insertions(+), 3 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 6c742da66b32..996213591617 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -376,6 +384,75 @@ static struct sock *audit_get_sk(const struct net *net)
> >         return aunet->sk;
> >  }
> >
> > +void audit_netns_contid_add(struct net *net, u64 contid)
> > +{
> > +       struct audit_net *aunet;
> > +       struct list_head *contid_list;
> > +       struct audit_contid *cont;
> > +
> > +       if (!net)
> > +               return;
> > +       if (!audit_contid_valid(contid))
> > +               return;
> > +       aunet = net_generic(net, audit_net_id);
> > +       if (!aunet)
> > +               return;
> > +       contid_list = &aunet->contid_list;
> > +       spin_lock(&aunet->contid_list_lock);
> > +       list_for_each_entry_rcu(cont, contid_list, list)
> > +               if (cont->id == contid) {
> > +                       refcount_inc(&cont->refcount);
> > +                       goto out;
> > +               }
> > +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> > +       if (cont) {
> > +               INIT_LIST_HEAD(&cont->list);
> 
> I thought you were going to get rid of this INIT_LIST_HEAD() call?

I was intending to, and then Neil weighed in with this opinion:

	https://www.redhat.com/archives/linux-audit/2019-April/msg00014.html

If you feel that isn't important, please remove it.

> > +               cont->id = contid;
> > +               refcount_set(&cont->refcount, 1);
> > +               list_add_rcu(&cont->list, contid_list);
> > +       }
> > +out:
> > +       spin_unlock(&aunet->contid_list_lock);
> > +}
> 
> --
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
