Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7A224789
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 02:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGRAoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 20:44:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726656AbgGRAoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 20:44:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595033042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4RDizrADsr1teVTJWa21lf+xcmimjV5s89rIjc/EFXo=;
        b=hQEI3Q3voHy/YXXh3+KwGXCt+H2lAktPNAB63uWRzXZAeIn8PFGhRK6Pc2b/bO9Lu+VLZN
        LFk5lSqbP4gmRouvY76aQmooFPsCH03/xaSPiUYNmwF12hjY9KbNJGqT/gFVA0wcajsmWx
        rrd8tT/HU3BTnYvJfe2dyK48LxgVr0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-VX9MMhEsMhm6M_EWCIB_HA-1; Fri, 17 Jul 2020 20:43:58 -0400
X-MC-Unique: VX9MMhEsMhm6M_EWCIB_HA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE7D2100A8E8;
        Sat, 18 Jul 2020 00:43:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD2427B42B;
        Sat, 18 Jul 2020 00:43:44 +0000 (UTC)
Date:   Fri, 17 Jul 2020 20:43:41 -0400
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
Subject: Re: [PATCH ghak90 V9 08/13] audit: add containerid support for user
 records
Message-ID: <20200718004341.ruyre5xhlu3ps2tr@madcap2.tricolour.ca>
References: <cover.1593198710.git.rgb@redhat.com>
 <4a5019ed3cfab416aeb6549b791ac6d8cc9fb8b7.1593198710.git.rgb@redhat.com>
 <CAHC9VhSwMEZrq0dnaXmPi=bu0NgUtWPuw-2UGDrQa6TwxWkZtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSwMEZrq0dnaXmPi=bu0NgUtWPuw-2UGDrQa6TwxWkZtw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-05 11:11, Paul Moore wrote:
> On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Add audit container identifier auxiliary record to user event standalone
> > records.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  kernel/audit.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 54dd2cb69402..997c34178ee8 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1507,6 +1504,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >                                 audit_log_n_untrustedstring(ab, str, data_len);
> >                         }
> >                         audit_log_end(ab);
> > +                       rcu_read_lock();
> > +                       cont = _audit_contobj_get(current);
> > +                       rcu_read_unlock();
> > +                       audit_log_container_id(context, cont);
> > +                       rcu_read_lock();
> > +                       _audit_contobj_put(cont);
> > +                       rcu_read_unlock();
> > +                       audit_free_context(context);
> 
> I haven't searched the entire patchset, but it seems like the pattern
> above happens a couple of times in this patchset, yes?  If so would it
> make sense to wrap the above get/log/put in a helper function?

I've redone the locking with an rcu lock around the get and a spinlock
around the put.  It occurs to me that putting an rcu lock around the
whole thing and doing a get without the refcount increment would save
us the spinlock and put and be fine since we'd be fine with stale but
consistent information traversing the contobj list from this point to
report it.  Problem with that is needing to use GFP_ATOMIC due to the
rcu lock.  If I stick with the spinlock around the put then I can use
GFP_KERNEL and just grab the spinlock while traversing the contobj list.

> Not a big deal either way, I'm pretty neutral on it at this point in
> the patchset but thought it might be worth mentioning in case you
> noticed the same and were on the fence.

There is only one other place this is used, in audit_log_exit in
auditsc.c.  I had noted the pattern but wasn't sure it was worth it.
Inline or not?  Should we just let the compiler decide?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

