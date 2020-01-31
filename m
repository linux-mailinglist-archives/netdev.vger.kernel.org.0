Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD4E14EEC7
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgAaOug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:50:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729099AbgAaOuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580482233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G5qtNmF55up9PuW19M9ztod4mbJlD+L5BOsXwBxDWkA=;
        b=VoRDqFTLJZgJXBI1N7//RAwLAXChtLAdO/cWTyLZGki5XpufhK6sdIAJJqRSn9kgn3cAK3
        RcErm38V27df5crbqS6q1Sr5EknYLyryJ19ix3e/0oXT0jWIQ8lLiWEMdQAR1nzBqzR99W
        E/0s2bqexIGoXCdWP5zVsD3zaVk3iWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-I55GL5ZpPoKvKnwr-qcgbg-1; Fri, 31 Jan 2020 09:50:23 -0500
X-MC-Unique: I55GL5ZpPoKvKnwr-qcgbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFCB118C35A0;
        Fri, 31 Jan 2020 14:50:20 +0000 (UTC)
Received: from x2.localnet (ovpn-117-67.phx2.redhat.com [10.3.117.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B23C55C54A;
        Fri, 31 Jan 2020 14:50:09 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
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
Date:   Fri, 31 Jan 2020 09:50:08 -0500
Message-ID: <5238532.OiMyN8JqPO@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com> <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, January 22, 2020 4:29:12 PM EST Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
> 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > 
> >  include/linux/audit.h |  1 +
> >  kernel/audit.c        | 53
> >  +++++++++++++++++++++++++++++++++++++++++++-------- kernel/audit.h     
> >    |  1 +
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
> > 
> > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns,
> > struct task_struct *p)> 
> >                 audit_netns_contid_add(new->net_ns, contid);
> >  
> >  }
> > 
> > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> 
> If we need a forward declaration, might as well just move it up near
> the top of the file with the rest of the declarations.
> 
> > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > +{
> > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > +       int h;
> 
> It seems safer to pass the audit container ID object and not the u64.
> 
> > +       if (!audit_contid_valid(contid)) {
> > +               audit_log_format(ab, "%llu", contid);
> 
> Do we really want to print (u64)-1 here?  Since this is a known
> invalid number, would "?" be a better choice?

The established pattern is that we print -1 when its unset and "?" when its 
totalling missing. So, how could this be invalid? It should be set or not. 
That is unless its totally missing just like when we do not run with selinux 
enabled and a context just doesn't exist.

-Steve


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
> 
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
> 
> > +       }
> > +out:
> > +       rcu_read_unlock();
> > +}
> > +
> > 
> >  /*
> >  
> >   * audit_log_container_id - report container info
> >   * @context: task or local context for record
> 
> ...
> 
> > @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64
> > contid)> 
> >         if (!ab)
> >         
> >                 return rc;
> > 
> > -       audit_log_format(ab,
> > -                        "op=set opid=%d contid=%llu old-contid=%llu",
> > -                        task_tgid_nr(task), contid, oldcontid);
> > +       audit_log_format(ab, "op=set opid=%d contid=",
> > task_tgid_nr(task)); +       audit_log_contid(ab, contid);
> > +       audit_log_format(ab, " old-contid=");
> > +       audit_log_contid(ab, oldcontid);
> 
> This is an interesting case where contid and old-contid are going to
> be largely the same, only the first (current) ID is going to be
> different; do we want to duplicate all of those IDs?
> 
> >         audit_log_end(ab);
> >         return rc;
> >  
> >  }
> > 
> > @@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)
> 
> --
> paul moore
> www.paul-moore.com




