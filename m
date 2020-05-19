Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94721D9585
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgESLrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbgESLrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:47:00 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6AC08C5C0;
        Tue, 19 May 2020 04:46:59 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 79so14170600iou.2;
        Tue, 19 May 2020 04:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vfcVnsyh74MxoB6IcL7pKDcNiYmTgj0OJ1KhYiQo3Ns=;
        b=qFZKCnBBQ8YbvNvH6egICaSDY3n+2TGLLEcgC0nmA6fKAVT+V4G3gUHfUaKYlSDtXT
         ugavvS6/xr+pgwlwOaHQqPRoH3APlAyPgp5rVG1NIrh9E/HZYp2DQKtCPAx8B6tfABzn
         V9EO4TCxj7YYcSHI8Q7luu36+7zm7tsHUlO3A3AEgBQNCVv6OBpxUkJXDE/5WQ//asPp
         hJw1j422+c6t2xmIDqgFzo3TO0fRbeIucz4y6Cw9VEoQb9HbDAGYWQxWYwuSLPuO05IS
         dntJ+7/O7En4KehKWfQ1cUgvr+d16KNuePj1G4gUg5iQMedoD3pMr1VA9VWTtxODmPlR
         7DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vfcVnsyh74MxoB6IcL7pKDcNiYmTgj0OJ1KhYiQo3Ns=;
        b=qtUHcZI/P86jKypAA1rembUo6ipamEmMMLiciMNB4fzzZcE1NvCFhjPHydRQZBV3Ir
         GdZkh8i/mmZ33IHIWKz0TbWHqz5H/jzKV6AWllskeS1f2KbJRMDPPG/W673glXUNKy+l
         7ZIhWE1uRh/Dw+unV88x+kvBs7/gfJ94zjHvnMymHkxbgovutSf2IPTfj2p0rGboznou
         cCNo99X2PTXX/lh3v7UodLJSzhQJblf/vLfS8IilD0ov9CXiY9kBn3m8pJ22RnE0ZHIX
         uaE08j1JWzw2pKnBNcnt1EW40+X3sztavZ9cNVFreE7cZ0ciHW8bdak7qGfifzerklYL
         N8Fw==
X-Gm-Message-State: AOAM533ySI1dxFYekCzPEud+rO3qHIK3VGXdnw6+nJpCwvaKAI2nIZth
        NXBqHMjkt2dcHDRmDeLrOt+RXupJxZTVdTmT5g==
X-Google-Smtp-Source: ABdhPJzvUmrcreU0QKiAmeoCn6It7PqTS9p5iMZP+CatLHKZxehtEdEOtfB3aOfiza9+ptf7TK5gyleMsaOUrpsWjP4=
X-Received: by 2002:a6b:e006:: with SMTP id z6mr18712798iog.138.1589888818117;
 Tue, 19 May 2020 04:46:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200515013556.5582-1-kim.andrewsy@gmail.com> <20200517171654.8194-1-kim.andrewsy@gmail.com>
 <alpine.LFD.2.21.2005182027460.4524@ja.home.ssi.bg> <CABc050G-yW-frv0mCmg=hMnC4iOx9Ht2Zv8eoS1cxQ8uKX6NQw@mail.gmail.com>
In-Reply-To: <CABc050G-yW-frv0mCmg=hMnC4iOx9Ht2Zv8eoS1cxQ8uKX6NQw@mail.gmail.com>
From:   Marco Angaroni <marcoangaroni@gmail.com>
Date:   Tue, 19 May 2020 13:46:46 +0200
Message-ID: <CANHHuCW6i0BjLRMYkfY8eZGZJZTnE-NO9EH+-gfH94cc6yYn1A@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: immediately expire UDP connections
 matching unavailable destination if expire_nodest_conn=1
To:     Andrew Kim <kim.andrewsy@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Julian,

could you please confirm if/how this patch is changing any of the
following behaviours, which I=E2=80=99m listing below as per my understandi=
ng
?

When expire_nodest is set and real-server is unavailable, at the
moment the following happens to a packet going through IPVS:

a) TCP (or other connection-oriented protocols):
   the packet is silently dropped, then the following retransmission
causes the generation of a RST from the load-balancer to the client,
which will then re-open a new TCP connection
b) UDP:
   the packet is silently dropped, then the following retransmission
is rescheduled to a new real-server
c) UDP in OPS mode:
   the packet is rescheduled to a new real-server, as no previous
connection exists in IPVS connection table, and a new OPS connection
is created (but it lasts only the time to transmit the packet)
d) UDP in OPS mode + persistent-template:
   the packet is rescheduled to a new real-server, as previous
template-connection is invalidated, a new template-connection is
created, and a new OPS connection is created (but it lasts only the
time to transmit the packet)

It seems to me that you are trying to optimize case a) and b),
avoiding the first step where the packet is silently dropped and
consequently avoiding the retransmission.
And contextually expire also all the other connections pointing to the
unavailable real-sever.

However I'm confused about the references to OPS mode.
And why you need to expire all the connections at once: if you expire
on a per connection basis, the client experiences the same behaviour
(no more re-transmissions), but you avoid the complexities of a new
thread.

Maybe also the documentation of expire_nodest_conn sysctl should be updated=
.
When it's stated:

        If this feature is enabled, the load balancer will expire the
        connection immediately when a packet arrives and its
        destination server is not available, then the client program
        will be notified that the connection is closed

I think it should be at least "and the client program" instead of
"then the client program".
Or a more detailed explanation.

Thanks
Marco Angaroni


Il giorno lun 18 mag 2020 alle ore 22:06 Andrew Kim
<kim.andrewsy@gmail.com> ha scritto:
>
> Hi Julian,
>
> Thank you for getting back to me. I will update the patch based on
> your feedback shortly.
>
> Regards,
>
> Andrew
>
> On Mon, May 18, 2020 at 3:10 PM Julian Anastasov <ja@ssi.bg> wrote:
> >
> >
> >         Hello,
> >
> > On Sun, 17 May 2020, Andrew Sy Kim wrote:
> >
> > > If expire_nodest_conn=3D1 and a UDP destination is deleted, IPVS shou=
ld
> > > also expire all matching connections immiediately instead of waiting =
for
> > > the next matching packet. This is particulary useful when there are a
> > > lot of packets coming from a few number of clients. Those clients are
> > > likely to match against existing entries if a source port in the
> > > connection hash is reused. When the number of entries in the connecti=
on
> > > tracker is large, we can significantly reduce the number of dropped
> > > packets by expiring all connections upon deletion.
> > >
> > > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > > ---
> > >  include/net/ip_vs.h             |  7 ++++++
> > >  net/netfilter/ipvs/ip_vs_conn.c | 38 +++++++++++++++++++++++++++++++=
++
> > >  net/netfilter/ipvs/ip_vs_core.c |  5 -----
> > >  net/netfilter/ipvs/ip_vs_ctl.c  |  9 ++++++++
> > >  4 files changed, 54 insertions(+), 5 deletions(-)
> > >
> >
> > > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_=
vs_conn.c
> > > index 02f2f636798d..c69dfbbc3416 100644
> > > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > > @@ -1366,6 +1366,44 @@ static void ip_vs_conn_flush(struct netns_ipvs=
 *ipvs)
> > >               goto flush_again;
> > >       }
> > >  }
> > > +
> > > +/*   Flush all the connection entries in the ip_vs_conn_tab with a
> > > + *   matching destination.
> > > + */
> > > +void ip_vs_conn_flush_dest(struct netns_ipvs *ipvs, struct ip_vs_des=
t *dest)
> > > +{
> > > +     int idx;
> > > +     struct ip_vs_conn *cp, *cp_c;
> > > +
> > > +     rcu_read_lock();
> > > +     for (idx =3D 0; idx < ip_vs_conn_tab_size; idx++) {
> > > +             hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_li=
st) {
> > > +                     if (cp->ipvs !=3D ipvs)
> > > +                             continue;
> > > +
> > > +                     if (cp->dest !=3D dest)
> > > +                             continue;
> > > +
> > > +                     /* As timers are expired in LIFO order, restart
> > > +                      * the timer of controlling connection first, s=
o
> > > +                      * that it is expired after us.
> > > +                      */
> > > +                     cp_c =3D cp->control;
> > > +                     /* cp->control is valid only with reference to =
cp */
> > > +                     if (cp_c && __ip_vs_conn_get(cp)) {
> > > +                             IP_VS_DBG(4, "del controlling connectio=
n\n");
> > > +                             ip_vs_conn_expire_now(cp_c);
> > > +                             __ip_vs_conn_put(cp);
> > > +                     }
> > > +                     IP_VS_DBG(4, "del connection\n");
> > > +                     ip_vs_conn_expire_now(cp);
> > > +             }
> > > +             cond_resched_rcu();
> >
> >         Such kind of loop is correct if done in another context:
> >
> > 1. kthread
> > or
> > 2. delayed work: mod_delayed_work(system_long_wq, ...)
> >
> >         Otherwise cond_resched_rcu() can schedule() while holding
> > __ip_vs_mutex. Also, it will add long delay if many dests are
> > removed.
> >
> >         If such loop analyzes instead all cp->dest for
> > IP_VS_DEST_F_AVAILABLE, it should be done after calling
> > __ip_vs_conn_get().
> >
> > >  static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; =
}
> > > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_v=
s_ctl.c
> > > index 8d14a1acbc37..f87c03622874 100644
> > > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > > @@ -1225,6 +1225,15 @@ ip_vs_del_dest(struct ip_vs_service *svc, stru=
ct ip_vs_dest_user_kern *udest)
> > >        */
> > >       __ip_vs_del_dest(svc->ipvs, dest, false);
> > >
> > > +     /*      If expire_nodest_conn is enabled and protocol is UDP,
> > > +      *      attempt best effort flush of all connections with this
> > > +      *      destination.
> > > +      */
> > > +     if (sysctl_expire_nodest_conn(svc->ipvs) &&
> > > +         dest->protocol =3D=3D IPPROTO_UDP) {
> > > +             ip_vs_conn_flush_dest(svc->ipvs, dest);
> >
> >         Above work should be scheduled from __ip_vs_del_dest().
> > Check for UDP is not needed, sysctl_expire_nodest_conn() is for
> > all protocols.
> >
> >         If the flushing is complex to implement, we can still allow
> > rescheduling for unavailable dests:
> >
> > - first we should move this block above the ip_vs_try_to_schedule()
> > block because:
> >
> >         1. the scheduling does not return unavailabel dests, even
> >         for persistence, so no need to check new connections for
> >         the flag
> >
> >         2. it will allow to create new connection if dest for
> >         existing connection is unavailable
> >
> >         if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABL=
E)) {
> >                 /* the destination server is not available */
> >
> >                 if (sysctl_expire_nodest_conn(ipvs)) {
> >                         bool uses_ct =3D ip_vs_conn_uses_conntrack(cp, =
skb);
> >
> >                         ip_vs_conn_expire_now(cp);
> >                         __ip_vs_conn_put(cp);
> >                         if (uses_ct)
> >                                 return NF_DROP;
> >                         cp =3D NULL;
> >                 } else {
> >                         __ip_vs_conn_put(cp);
> >                         return NF_DROP;
> >                 }
> >         }
> >
> >         if (unlikely(!cp)) {
> >                 int v;
> >
> >                 if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, =
&iph))
> >                         return v;
> >         }
> >
> >         Before now, we always waited one jiffie connection to expire,
> > now one packet will:
> >
> > - schedule expiration for existing connection with unavailable dest,
> > as before
> >
> > - create new connection to available destination that will be found
> > first in lists. But it can work only when sysctl var "conntrack" is 0,
> > we do not want to create two netfilter conntracks to different
> > real servers.
> >
> >         Note that we intentionally removed the timer_pending() check
> > because we can not see existing ONE_PACKET connections in table.
> >
> > Regards
> >
> > --
> > Julian Anastasov <ja@ssi.bg>
