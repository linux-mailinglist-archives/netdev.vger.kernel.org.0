Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E504446DA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 18:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhKCRTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 13:19:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35546 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKCRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 13:19:36 -0400
Received: from madeliefje.horms.nl (ip-80-113-23-202.ip.prioritytelecom.net [80.113.23.202])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 7104C25AD6B;
        Thu,  4 Nov 2021 04:16:57 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 4F72D27B0; Wed,  3 Nov 2021 18:16:55 +0100 (CET)
Date:   Wed, 3 Nov 2021 18:16:55 +0100
From:   Simon Horman <horms@verge.net.au>
To:     yangxingwu <xingwu.yang@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Chuanqi Liu <legend050709@qq.com>
Subject: Re: [PATCH nf-next v5] netfilter: ipvs: Fix reuse connection if RS
 weight is 0
Message-ID: <20211103171652.GA12763@vergenet.net>
References: <20211101020416.31402-1-xingwu.yang@gmail.com>
 <ae67eb7b-a25f-57d3-195f-cdbd9247ef5b@ssi.bg>
 <CA+7U5Jumj_MwMZBmDTCvWLnvmfX28d==dbkLTq+6cOz+32GCvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+7U5Jumj_MwMZBmDTCvWLnvmfX28d==dbkLTq+6cOz+32GCvw@mail.gmail.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 07:40:46PM +0800, yangxingwu wrote:
> hello Simon
> 
> I delete the "This will effectively disable expire_nodest_conn" section
> from doc, and the others remain untouched. The following is how it looks
> like after modification:
> 
> 0: disable any special handling on port reuse. The new
> connection will be delivered to the same real server that was
> servicing the previous connection.
> 
> Simon, pls help to check if it's necessary to replace servicing with
> service.

Sorry, my mistake. No need to replace servicing with service.

> And I will move the conn_reuse_mode line above the bool line
> 
> On Tue, Nov 2, 2021 at 2:21 AM Julian Anastasov <ja@ssi.bg> wrote:
> 
> >
> >         Hello,
> >
> > On Mon, 1 Nov 2021, yangxingwu wrote:
> >
> > > We are changing expire_nodest_conn to work even for reused connections
> > when
> > > conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
> > > Fix reuse connection if real server is dead").
> > >
> > > For controlled and persistent connections, the new connection will get
> > the
> > > needed real server depending on the rules in ip_vs_check_template().
> > >
> > > Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when
> > port reuse is detected")
> > > Co-developed-by: Chuanqi Liu <legend050709@qq.com>
> > > Signed-off-by: Chuanqi Liu <legend050709@qq.com>
> > > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> >
> >         Looks good to me, thanks!
> >
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> >
> > > ---
> > >  Documentation/networking/ipvs-sysctl.rst | 3 +--
> > >  net/netfilter/ipvs/ip_vs_core.c          | 8 ++++----
> > >  2 files changed, 5 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/Documentation/networking/ipvs-sysctl.rst
> > b/Documentation/networking/ipvs-sysctl.rst
> > > index 2afccc63856e..1cfbf1add2fc 100644
> > > --- a/Documentation/networking/ipvs-sysctl.rst
> > > +++ b/Documentation/networking/ipvs-sysctl.rst
> > > @@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
> > >
> > >       0: disable any special handling on port reuse. The new
> > >       connection will be delivered to the same real server that was
> > > -     servicing the previous connection. This will effectively
> > > -     disable expire_nodest_conn.
> > > +     servicing the previous connection.
> > >
> > >       bit 1: enable rescheduling of new connections when it is safe.
> > >       That is, whenever expire_nodest_conn and for TCP sockets, when
> > > diff --git a/net/netfilter/ipvs/ip_vs_core.c
> > b/net/netfilter/ipvs/ip_vs_core.c
> > > index 128690c512df..f9d65d2c8da8 100644
> > > --- a/net/netfilter/ipvs/ip_vs_core.c
> > > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > > @@ -1964,7 +1964,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int
> > hooknum, struct sk_buff *skb, int
> > >       struct ip_vs_proto_data *pd;
> > >       struct ip_vs_conn *cp;
> > >       int ret, pkts;
> > > -     int conn_reuse_mode;
> > >       struct sock *sk;
> > >
> > >       /* Already marked as IPVS request or reply? */
> > > @@ -2041,15 +2040,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int
> > hooknum, struct sk_buff *skb, int
> > >       cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
> > >                            ipvs, af, skb, &iph);
> > >
> > > -     conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > > -     if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) &&
> > cp) {
> > > +     if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> > >               bool old_ct = false, resched = false;
> > > +             int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > >
> > >               if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest
> > &&
> > >                   unlikely(!atomic_read(&cp->dest->weight))) {
> > >                       resched = true;
> > >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > > -             } else if (is_new_conn_expected(cp, conn_reuse_mode)) {
> > > +             } else if (conn_reuse_mode &&
> > > +                        is_new_conn_expected(cp, conn_reuse_mode)) {
> > >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > >                       if (!atomic_read(&cp->n_control)) {
> > >                               resched = true;
> > > --
> > > 2.30.2
> >
> > Regards
> >
> > --
> > Julian Anastasov <ja@ssi.bg>
> >
