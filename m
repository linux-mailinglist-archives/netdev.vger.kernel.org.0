Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88CF214E338
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgA3T2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:28:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727551AbgA3T2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 14:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580412491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZRSoce4aDIhYGocvIcGv2HpCjE5w9Q4ooxBftKFFfE=;
        b=JBKTLWwKMBQLtVlNauUjcFfifrMl24vFZxaUQjN8lKQ3iHx8tF7o0efieRYnKJceOnaMcH
        cz3hBBVs4RANfcf+yKw6xa7EzZ16LL1+fm0aSIBJAJLY8p3cFtC+jzSUeb40g6/ZBGbVtK
        d+wcBh+aRhJc112TE9W1MYxAbHXweUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-1e8F8O_FMeypJ7O5vFx2sw-1; Thu, 30 Jan 2020 14:28:09 -0500
X-MC-Unique: 1e8F8O_FMeypJ7O5vFx2sw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9001413E5;
        Thu, 30 Jan 2020 19:28:07 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AC9219488;
        Thu, 30 Jan 2020 19:27:56 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:27:53 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
Message-ID: <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:29, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Track the parent container of a container to be able to filter and
> > report nesting.
> >
> > Now that we have a way to track and check the parent container of a
> > container, modify the contid field format to be able to report that
> > nesting using a carrat ("^") separator to indicate nesting.  The
> > original field format was "contid=<contid>" for task-associated records
> > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > records.  The new field format is
> > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> 
> Let's make sure we always use a comma as a separator, even when
> recording the parent information, for example:
> "contid=<contid>[,^<contid>[...]][,<contid>[...]]"

The intent here is to clearly indicate and separate nesting from
parallel use of several containers by one netns.  If we do away with
that distinction, then we lose that inheritance accountability and
should really run the list through a "uniq" function to remove the
produced redundancies.  This clear inheritance is something Steve was
looking for since tracking down individual events/records to show that
inheritance was not aways feasible due to rolled logs or search effort.

> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h |  1 +
> >  kernel/audit.c        | 53 +++++++++++++++++++++++++++++++++++++++++++--------
> >  kernel/audit.h        |  1 +
> >  kernel/auditfilter.c  | 17 ++++++++++++++++-
> >  kernel/auditsc.c      |  2 +-
> >  5 files changed, 64 insertions(+), 10 deletions(-)
> 
> ...
> 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index ef8e07524c46..68be59d1a89b 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> 
> > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> >                 audit_netns_contid_add(new->net_ns, contid);
> >  }
> >
> > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> 
> If we need a forward declaration, might as well just move it up near
> the top of the file with the rest of the declarations.

Ok.

> > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > +{
> > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > +       int h;
> 
> It seems safer to pass the audit container ID object and not the u64.

It would also be faster, but in some places it isn't available such as
for ptrace and signal targets.  This also links back to the drop record
refcounts to hold onto the contobj until process exit, or signal
delivery.

What we could do is to supply two potential parameters, a contobj and/or
a contid, and have it use the contobj if it is valid, otherwise, use the
contid, as is done for names and paths supplied to audit_log_name().

> > +       if (!audit_contid_valid(contid)) {
> > +               audit_log_format(ab, "%llu", contid);
> 
> Do we really want to print (u64)-1 here?  Since this is a known
> invalid number, would "?" be a better choice?

I'll defer to Steve here.  "?" would be one character vs 20 for (u64)-1.
I don't expect there to be that many records containing (u64)-1, but it
would also make them visually easier to pick out if that is a factor.

> > +               return;
> > +       }
> > +       h = audit_hash_contid(contid);
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > +               if (cont->id == contid) {
> > +                       prcont = cont;
> 
> Why not just pull the code below into the body of this if statement?
> It all needs to be done under the RCU read lock anyway and the code
> would read much better this way.

Ok.

> > +                       break;
> > +               }
> > +       if (!prcont) {
> > +               audit_log_format(ab, "%llu", contid);
> > +               goto out;
> > +       }
> > +       while (prcont) {
> > +               audit_log_format(ab, "%llu", prcont->id);
> > +               prcont = prcont->parent;
> > +               if (prcont)
> > +                       audit_log_format(ab, "^");
> 
> In the interest of limiting the number of calls to audit_log_format(),
> how about something like the following:
> 
>   audit_log_format("%llu", cont);
>   iter = cont->parent;
>   while (iter) {
>     if (iter->parent)
>       audit_log_format("^%llu,", iter);
>     else
>       audit_log_format("^%llu", iter);
>     iter = iter->parent;
>   }

Ok.

> > +       }
> > +out:
> > +       rcu_read_unlock();
> > +}
> > +
> >  /*
> >   * audit_log_container_id - report container info
> >   * @context: task or local context for record
> 
> ...
> 
> > @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >         if (!ab)
> >                 return rc;
> >
> > -       audit_log_format(ab,
> > -                        "op=set opid=%d contid=%llu old-contid=%llu",
> > -                        task_tgid_nr(task), contid, oldcontid);
> > +       audit_log_format(ab, "op=set opid=%d contid=", task_tgid_nr(task));
> > +       audit_log_contid(ab, contid);
> > +       audit_log_format(ab, " old-contid=");
> > +       audit_log_contid(ab, oldcontid);
> 
> This is an interesting case where contid and old-contid are going to
> be largely the same, only the first (current) ID is going to be
> different; do we want to duplicate all of those IDs?

At first when I read your comment, I thought we could just take contid
and drop oldcontid, but if it fails, we still want all the information,
so given the way I've set up the search code in userspace, listing only
the newest contid in the contid field and all the rest in oldcontid
could be a good compromise.

> >         audit_log_end(ab);
> >         return rc;
> >  }
> > @@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

