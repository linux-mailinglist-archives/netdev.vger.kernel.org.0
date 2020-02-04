Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C6151B19
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgBDNUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:20:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727279AbgBDNUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 08:20:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580822403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DiCDr9VOMNIOGlerAt3rk5gsTcg7CmFEgtEnbuSq7k8=;
        b=W0cRHz6MEySCD75UlhTV5sELbv7zUOqFCgnqWlFSfCIgz9CHKlidY/t/lqN4MajjGpntXT
        GlV8mtP1I5AjXQE061CaXcgzIMpCD05VxzKePghdZOEHUVNM/8UL//rZs0J8K9SvqzYNee
        YNExsKNcICcMzQ7T6jAwNJQAGe+yt6A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-CabuI7ORPYG9_kFSuyn87w-1; Tue, 04 Feb 2020 08:20:01 -0500
X-MC-Unique: CabuI7ORPYG9_kFSuyn87w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815E38C8800;
        Tue,  4 Feb 2020 13:19:59 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F8A9811F8;
        Tue,  4 Feb 2020 13:19:47 +0000 (UTC)
Date:   Tue, 4 Feb 2020 08:19:44 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Message-ID: <20200204131944.esnzcqvnecfnqgbi@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
 <5238532.OiMyN8JqPO@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5238532.OiMyN8JqPO@x2>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-31 09:50, Steve Grubb wrote:
> On Wednesday, January 22, 2020 4:29:12 PM EST Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Track the parent container of a container to be able to filter and
> > > report nesting.
> > > 
> > > Now that we have a way to track and check the parent container of a
> > > container, modify the contid field format to be able to report that
> > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > original field format was "contid=<contid>" for task-associated records
> > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > records.  The new field format is
> > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> > 
> > Let's make sure we always use a comma as a separator, even when
> > recording the parent information, for example:
> > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
> > 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > > 
> > >  include/linux/audit.h |  1 +
> > >  kernel/audit.c        | 53
> > >  +++++++++++++++++++++++++++++++++++++++++++-------- kernel/audit.h     
> > >    |  1 +
> > >  kernel/auditfilter.c  | 17 ++++++++++++++++-
> > >  kernel/auditsc.c      |  2 +-
> > >  5 files changed, 64 insertions(+), 10 deletions(-)
> > 
> > ...
> > 
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index ef8e07524c46..68be59d1a89b 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > 
> > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns,
> > > struct task_struct *p)> 
> > >                 audit_netns_contid_add(new->net_ns, contid);
> > >  
> > >  }
> > > 
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> > 
> > If we need a forward declaration, might as well just move it up near
> > the top of the file with the rest of the declarations.
> > 
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > +{
> > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > +       int h;
> > 
> > It seems safer to pass the audit container ID object and not the u64.
> > 
> > > +       if (!audit_contid_valid(contid)) {
> > > +               audit_log_format(ab, "%llu", contid);
> > 
> > Do we really want to print (u64)-1 here?  Since this is a known
> > invalid number, would "?" be a better choice?
> 
> The established pattern is that we print -1 when its unset and "?" when its 
> totalling missing. So, how could this be invalid? It should be set or not. 
> That is unless its totally missing just like when we do not run with selinux 
> enabled and a context just doesn't exist.

Ok, so in this case it is clearly unset, so should be -1, which will be a
20-digit number when represented as an unsigned long long int.

Thank you for that clarification Steve.

> -Steve
> 
> > > +               return;
> > > +       }
> > > +       h = audit_hash_contid(contid);
> > > +       rcu_read_lock();
> > > +       list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > > +               if (cont->id == contid) {
> > > +                       prcont = cont;
> > 
> > Why not just pull the code below into the body of this if statement?
> > It all needs to be done under the RCU read lock anyway and the code
> > would read much better this way.
> > 
> > > +                       break;
> > > +               }
> > > +       if (!prcont) {
> > > +               audit_log_format(ab, "%llu", contid);
> > > +               goto out;
> > > +       }
> > > +       while (prcont) {
> > > +               audit_log_format(ab, "%llu", prcont->id);
> > > +               prcont = prcont->parent;
> > > +               if (prcont)
> > > +                       audit_log_format(ab, "^");
> > 
> > In the interest of limiting the number of calls to audit_log_format(),
> > how about something like the following:
> > 
> >   audit_log_format("%llu", cont);
> >   iter = cont->parent;
> >   while (iter) {
> >     if (iter->parent)
> >       audit_log_format("^%llu,", iter);
> >     else
> >       audit_log_format("^%llu", iter);
> >     iter = iter->parent;
> >   }
> > 
> > > +       }
> > > +out:
> > > +       rcu_read_unlock();
> > > +}
> > > +
> > > 
> > >  /*
> > >  
> > >   * audit_log_container_id - report container info
> > >   * @context: task or local context for record
> > 
> > ...
> > 
> > > @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64
> > > contid)> 
> > >         if (!ab)
> > >         
> > >                 return rc;
> > > 
> > > -       audit_log_format(ab,
> > > -                        "op=set opid=%d contid=%llu old-contid=%llu",
> > > -                        task_tgid_nr(task), contid, oldcontid);
> > > +       audit_log_format(ab, "op=set opid=%d contid=",
> > > task_tgid_nr(task)); +       audit_log_contid(ab, contid);
> > > +       audit_log_format(ab, " old-contid=");
> > > +       audit_log_contid(ab, oldcontid);
> > 
> > This is an interesting case where contid and old-contid are going to
> > be largely the same, only the first (current) ID is going to be
> > different; do we want to duplicate all of those IDs?
> > 
> > >         audit_log_end(ab);
> > >         return rc;
> > >  
> > >  }
> > > 
> > > @@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)
> > 
> > paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

