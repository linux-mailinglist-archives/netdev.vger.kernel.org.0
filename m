Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABC1D8888
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgERTyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgERTyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:54:43 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8EFC061A0C;
        Mon, 18 May 2020 12:54:43 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l5so3076587edn.7;
        Mon, 18 May 2020 12:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/s33/VvXYGOPrAm8r0pCzT0GNMPPVkhgGa11qWBep6g=;
        b=q4COzxuc6flvPfQ7Crk9oiFTtCqk4q6pYceNjhtyzBY2b/tzAoQKnXgt7+aQUfbc/W
         ojDgtYBtUDoSUg/vQ5Qk+1/RBB5swNARUbTJumOU6slx5dC2o1KTeFJkn6z07efBnBXr
         KxP06lQVdRPYtNrTZjWZqjECATRM1XFZhfQiXCDuArOGDJpf+sTEkoi45rxYxmucal6Z
         rOpTQt4jW7LQA7WHcLUknh/EkfcjWhXB57gz+CYFvhD0CK2jFqVvJGDTuol1CLosyl5n
         PzQOMM47ExzalqvaSiGZPmhtUPTMxH7LnhheGpj4TD46V2GKvb+3JBxKNW/YkY6t2z5w
         JApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/s33/VvXYGOPrAm8r0pCzT0GNMPPVkhgGa11qWBep6g=;
        b=msYBcN+9Ft2a8/bvmKWEkvVNJEz2FTjDDhHixxjhbzUWMUwk4308UaT8gt5szpHT2M
         5mozwoUpCpDSsf2VTQ3uYuanKNcCPlGUFDdR5w8hLc4OFLq1gCaRMhAKK2DA/es7fji3
         TvicrjRYb2LKYK5l+8xv0PRK9YBv3kmoY/hmUuH/OMtEskat6iaOus8JBUl0bzAylXwR
         Ria98fN0qdudrFmnkCDhmlSEI772OsyCd2wucaTD/l9AMglJ41sMtrQOYUYJNnUrOa6u
         lLMEuS6VDpU2slbyquK/b52qvFRUC3m+LKPBqtM/jTbjCtwMMBC2h/k/Mm0uuzvCYJhB
         u0lw==
X-Gm-Message-State: AOAM533SYKljFVJcv7z2ZH6FBRB57LgbsqbVyYleG2PdE3H90K1nd2im
        c55w9jd5ehORvrUUV/GzHcyRkKPYfHHeO63WbCs=
X-Google-Smtp-Source: ABdhPJyuUmiJ9daRIL60EFvhWnqZ4xns4kX/SorOJMxCWXj78jxGrxNseGdt5d+cgR5YxvNusMUaYdGsL8GboHwmrH8=
X-Received: by 2002:aa7:c6c6:: with SMTP id b6mr11008427eds.53.1589831681502;
 Mon, 18 May 2020 12:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200515013556.5582-1-kim.andrewsy@gmail.com> <20200517171654.8194-1-kim.andrewsy@gmail.com>
 <alpine.LFD.2.21.2005182027460.4524@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.21.2005182027460.4524@ja.home.ssi.bg>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Mon, 18 May 2020 15:54:30 -0400
Message-ID: <CABc050G-yW-frv0mCmg=hMnC4iOx9Ht2Zv8eoS1cxQ8uKX6NQw@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: immediately expire UDP connections
 matching unavailable destination if expire_nodest_conn=1
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julian,

Thank you for getting back to me. I will update the patch based on
your feedback shortly.

Regards,

Andrew

On Mon, May 18, 2020 at 3:10 PM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Sun, 17 May 2020, Andrew Sy Kim wrote:
>
> > If expire_nodest_conn=1 and a UDP destination is deleted, IPVS should
> > also expire all matching connections immiediately instead of waiting for
> > the next matching packet. This is particulary useful when there are a
> > lot of packets coming from a few number of clients. Those clients are
> > likely to match against existing entries if a source port in the
> > connection hash is reused. When the number of entries in the connection
> > tracker is large, we can significantly reduce the number of dropped
> > packets by expiring all connections upon deletion.
> >
> > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > ---
> >  include/net/ip_vs.h             |  7 ++++++
> >  net/netfilter/ipvs/ip_vs_conn.c | 38 +++++++++++++++++++++++++++++++++
> >  net/netfilter/ipvs/ip_vs_core.c |  5 -----
> >  net/netfilter/ipvs/ip_vs_ctl.c  |  9 ++++++++
> >  4 files changed, 54 insertions(+), 5 deletions(-)
> >
>
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 02f2f636798d..c69dfbbc3416 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1366,6 +1366,44 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
> >               goto flush_again;
> >       }
> >  }
> > +
> > +/*   Flush all the connection entries in the ip_vs_conn_tab with a
> > + *   matching destination.
> > + */
> > +void ip_vs_conn_flush_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
> > +{
> > +     int idx;
> > +     struct ip_vs_conn *cp, *cp_c;
> > +
> > +     rcu_read_lock();
> > +     for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> > +             hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> > +                     if (cp->ipvs != ipvs)
> > +                             continue;
> > +
> > +                     if (cp->dest != dest)
> > +                             continue;
> > +
> > +                     /* As timers are expired in LIFO order, restart
> > +                      * the timer of controlling connection first, so
> > +                      * that it is expired after us.
> > +                      */
> > +                     cp_c = cp->control;
> > +                     /* cp->control is valid only with reference to cp */
> > +                     if (cp_c && __ip_vs_conn_get(cp)) {
> > +                             IP_VS_DBG(4, "del controlling connection\n");
> > +                             ip_vs_conn_expire_now(cp_c);
> > +                             __ip_vs_conn_put(cp);
> > +                     }
> > +                     IP_VS_DBG(4, "del connection\n");
> > +                     ip_vs_conn_expire_now(cp);
> > +             }
> > +             cond_resched_rcu();
>
>         Such kind of loop is correct if done in another context:
>
> 1. kthread
> or
> 2. delayed work: mod_delayed_work(system_long_wq, ...)
>
>         Otherwise cond_resched_rcu() can schedule() while holding
> __ip_vs_mutex. Also, it will add long delay if many dests are
> removed.
>
>         If such loop analyzes instead all cp->dest for
> IP_VS_DEST_F_AVAILABLE, it should be done after calling
> __ip_vs_conn_get().
>
> >  static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
> > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> > index 8d14a1acbc37..f87c03622874 100644
> > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > @@ -1225,6 +1225,15 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
> >        */
> >       __ip_vs_del_dest(svc->ipvs, dest, false);
> >
> > +     /*      If expire_nodest_conn is enabled and protocol is UDP,
> > +      *      attempt best effort flush of all connections with this
> > +      *      destination.
> > +      */
> > +     if (sysctl_expire_nodest_conn(svc->ipvs) &&
> > +         dest->protocol == IPPROTO_UDP) {
> > +             ip_vs_conn_flush_dest(svc->ipvs, dest);
>
>         Above work should be scheduled from __ip_vs_del_dest().
> Check for UDP is not needed, sysctl_expire_nodest_conn() is for
> all protocols.
>
>         If the flushing is complex to implement, we can still allow
> rescheduling for unavailable dests:
>
> - first we should move this block above the ip_vs_try_to_schedule()
> block because:
>
>         1. the scheduling does not return unavailabel dests, even
>         for persistence, so no need to check new connections for
>         the flag
>
>         2. it will allow to create new connection if dest for
>         existing connection is unavailable
>
>         if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
>                 /* the destination server is not available */
>
>                 if (sysctl_expire_nodest_conn(ipvs)) {
>                         bool uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
>
>                         ip_vs_conn_expire_now(cp);
>                         __ip_vs_conn_put(cp);
>                         if (uses_ct)
>                                 return NF_DROP;
>                         cp = NULL;
>                 } else {
>                         __ip_vs_conn_put(cp);
>                         return NF_DROP;
>                 }
>         }
>
>         if (unlikely(!cp)) {
>                 int v;
>
>                 if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
>                         return v;
>         }
>
>         Before now, we always waited one jiffie connection to expire,
> now one packet will:
>
> - schedule expiration for existing connection with unavailable dest,
> as before
>
> - create new connection to available destination that will be found
> first in lists. But it can work only when sysctl var "conntrack" is 0,
> we do not want to create two netfilter conntracks to different
> real servers.
>
>         Note that we intentionally removed the timer_pending() check
> because we can not see existing ONE_PACKET connections in table.
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
