Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17249228BCA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgGUWGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:06:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31247 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726686AbgGUWGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595369175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1drX5k7wXxd1OloGATtvbnUdSqXmULd42swYuvS87G0=;
        b=gXIRjvrQ8kd+bEN7VqyQTuj1s2A8uCiP/tMzpkUSTlbJb/8MBNt///HWJoivxUTEMqHWCS
        nyb0l3MsgElGMtJjLm5DPmIdpUgZoTVLIdpinaTdWuQmyNldooHeAjSmedPCSqpG1q0weD
        BFMchIJGf7QKpiYO2d80UMqiNN0ezSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-6FgYG1FjNjm6A49AzP2VsA-1; Tue, 21 Jul 2020 18:06:10 -0400
X-MC-Unique: 6FgYG1FjNjm6A49AzP2VsA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8198E1005510;
        Tue, 21 Jul 2020 22:06:07 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9220872FB;
        Tue, 21 Jul 2020 22:05:51 +0000 (UTC)
Date:   Tue, 21 Jul 2020 18:05:48 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V9 10/13] audit: add support for containerid to
 network namespaces
Message-ID: <20200721220548.oy5iwquoohevlgbi@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <e9c1216a361c38ebc9cb4089922c259e2cfd5013.1593198710.git.rgb@redhat.com>
 <CAHC9VhSRRN+Qq5dNx6Q5cG_TrXgbBMR0PNUYvf+Haf2na5wCfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSRRN+Qq5dNx6Q5cG_TrXgbBMR0PNUYvf+Haf2na5wCfg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-05 11:11, Paul Moore wrote:
> On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > This also adds support to qualify NETFILTER_PKT records.
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
> > Add audit container identifier auxiliary record(s) to NETFILTER_PKT
> > event standalone records.  Iterate through all potential audit container
> > identifiers associated with a network namespace.
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
> >  include/linux/audit.h    |  20 ++++++
> >  kernel/audit.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  kernel/nsproxy.c         |   4 ++
> >  net/netfilter/nft_log.c  |  11 +++-
> >  net/netfilter/xt_AUDIT.c |  11 +++-
> >  5 files changed, 195 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index c4a755ae0d61..304fbb7c3c5b 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -128,6 +128,13 @@ struct audit_task_info {
> >
> >  extern struct audit_task_info init_struct_audit;
> >
> > +struct audit_contobj_netns {
> > +       struct list_head        list;
> > +       struct audit_contobj    *obj;
> > +       int                     count;
> 
> This seems like it might be a good candidate for refcount_t, yes?

I considered this before when converting the struct audit_contobj to
refcount_t, but decided against it since any updates are in the context
of a list traversal where it could be added to the list and so the
spinlock is already held anyways.

Is there a more efficent or elegant way of doing the locking around the
two list traversals below (_add and _del)?

I wonder about converting the count to refcount_t and only holding the
spinlock for the list_add_rcu() in the _add case.  And for the _del case
holding the spinlock only for the list_del_rcu().

These are the only two locations items are added or deleted from the
lists.

Somewhat related to this is does the list order matter?  Items are
currently added at the end of the list which likely makes locking
simpler, though the start of the list is a simple change.  However,
unless we understand the profile of read use of these lists for
reporting contid use in audit_log_netns_contid_list() I don't think
order matters significantly.  It could be that reporting of a contid
goes down in frequency over the lifetime of a contid that inserting them
at the beginning of the list would be best.  This is not a visible
implementation detail so later optimization should pose no problem.

> > +       struct rcu_head         rcu;
> > +};
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 997c34178ee8..a862721dfd9b 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -437,6 +452,136 @@ static struct sock *audit_get_sk(const struct net *net)
> >         return aunet->sk;
> >  }
> >
> > +void audit_netns_contid_add(struct net *net, struct audit_contobj *cont)
> > +{
> > +       struct audit_net *aunet;
> > +       struct list_head *contobj_list;
> > +       struct audit_contobj_netns *contns;
> > +
> > +       if (!net)
> > +               return;
> > +       if (!cont)
> > +               return;
> > +       aunet = net_generic(net, audit_net_id);
> > +       if (!aunet)
> > +               return;
> > +       contobj_list = &aunet->contobj_list;
> > +       rcu_read_lock();
> > +       spin_lock(&aunet->contobj_list_lock);
> > +       list_for_each_entry_rcu(contns, contobj_list, list)
> > +               if (contns->obj == cont) {
> > +                       contns->count++;
> > +                       goto out;
> > +               }
> > +       contns = kmalloc(sizeof(*contns), GFP_ATOMIC);
> > +       if (contns) {
> > +               INIT_LIST_HEAD(&contns->list);
> > +               contns->obj = cont;
> > +               contns->count = 1;
> > +               list_add_rcu(&contns->list, contobj_list);
> > +       }
> > +out:
> > +       spin_unlock(&aunet->contobj_list_lock);
> > +       rcu_read_unlock();
> > +}
> > +
> > +void audit_netns_contid_del(struct net *net, struct audit_contobj *cont)
> > +{
> > +       struct audit_net *aunet;
> > +       struct list_head *contobj_list;
> > +       struct audit_contobj_netns *contns = NULL;
> > +
> > +       if (!net)
> > +               return;
> > +       if (!cont)
> > +               return;
> > +       aunet = net_generic(net, audit_net_id);
> > +       if (!aunet)
> > +               return;
> > +       contobj_list = &aunet->contobj_list;
> > +       rcu_read_lock();
> > +       spin_lock(&aunet->contobj_list_lock);
> > +       list_for_each_entry_rcu(contns, contobj_list, list)
> > +               if (contns->obj == cont) {
> > +                       contns->count--;
> > +                       if (contns->count < 1) {
> 
> One could simplify this with "(--countns->count) < 1", although if it
> is changed to a refcount_t (which seems like a smart thing), the
> normal decrement/test would be the best choice.

Agreed.

> > +                               list_del_rcu(&contns->list);
> > +                               kfree_rcu(contns, rcu);
> > +                       }
> > +                       break;
> > +               }
> > +       spin_unlock(&aunet->contobj_list_lock);
> > +       rcu_read_unlock();
> > +}
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

