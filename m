Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69F943AA8A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbhJZC5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbhJZC5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 22:57:15 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB81C061745;
        Mon, 25 Oct 2021 19:54:52 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id r17so12191159qtx.10;
        Mon, 25 Oct 2021 19:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tkzNHgBhfoN1mN/bXgW3MkB27AZfqmaYrRvjImCn3wA=;
        b=fjCVH2KPY/mOAid4lHIsGk80qGZe30oFxUXZMY6H8BI1NPpfz1H7r97F4+u6+k31yg
         XryUZ5iJTS0menFBaz8G/X0/x71oUEWhb2XKfy4L63t5PRcBboHIJSYDpcsU/calqj7w
         /xamMaezkiK9JyR9DavPcNl1V/T6S0i3uPsr07Vc/6M1q04LocQutxVNe10VkkPJc0fU
         +cLN6Y30I76ymGcpkbmxFXY+PlLj9sjm7aMHlmdQHDviQT+0dSomZY80Q+qXs4yq1rWN
         wA2A2SqcD8V3Hwhdk++g7kX8XRcecg2LszFyi5wdkY7YecZYkA07iJ95uGxBh3t3RK8H
         ul2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkzNHgBhfoN1mN/bXgW3MkB27AZfqmaYrRvjImCn3wA=;
        b=lQJxcN5ckFoqLNhCwsqrWzdnH3dsYvDVsSEjFyp00tCoFLkFJ1OnzzfEBBe6Ann7CI
         VsRa2Xln8oDQrLLhqbGVzW+DVYq0czor7sR0yw/1e9jUlgBpR7+jPOynWMd1pE5NUb4h
         RrUM+a7Y/ront96r57imSiQjopEq+XmvQ9VWydOGh0T99eAdyzbqcznjT7aDIOGH9JTp
         uuKKhqfs9o1erwMGCr6cNVCnUd0FQf4r9CFzkQlFa3ZUdNDWUMkHk5572Dcbswk25zip
         66xrRVsguiM4EsHvIB6jpMMiALqwdYNdIjcIxyQTQoixeBSb98m5PctIbmVFLdPRs7gU
         9blw==
X-Gm-Message-State: AOAM531ZsbyeYKhTBKJ5KYd0BNuj5tD4l/ZUIsLsrXZJIZSUxuYs1ay5
        Nnves9Qjxk3VXiKGEQgKv71l3Nx8/aLH19Q8b1jmFse7iTziqw==
X-Google-Smtp-Source: ABdhPJw3JwJbWZw56oelucSpMM5M8gmCdguOUx+CVabxorwtsOFgtyp4lRdNV3fGm7s/OcBmgax57e8YWA+HUsA5OIs=
X-Received: by 2002:ac8:7d47:: with SMTP id h7mr21574977qtb.92.1635216891902;
 Mon, 25 Oct 2021 19:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211025115910.2595-1-xingwu.yang@gmail.com> <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
In-Reply-To: <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Tue, 26 Oct 2021 10:54:40 +0800
Message-ID: <CA+7U5JsSuwqP7eHj1tMHfsb+EemwrhZEJ2b944LFWTroxAnQRQ@mail.gmail.com>
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        kadlec@netfilter.org, fw@strlen.de,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks julian

What happens in this situation is that if we set the wait of the
realserver to 0 and do NOT remove the weight zero realserver with
sysctl settings (conn_reuse_mode == 0 && expire_nodest_conn == 1), and
the client reuses its source ports, the kernel will constantly
reuse connections and send the traffic to the weight 0 realserver.

you may check the details from
https://github.com/kubernetes/kubernetes/issues/81775

On Tue, Oct 26, 2021 at 2:12 AM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Mon, 25 Oct 2021, yangxingwu wrote:
>
> > Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
> > dead"), new connections to dead servers are redistributed immediately to
> > new servers.
> >
> > Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
> > port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
> > 0. And new connection may be distributed to a real server with weight 0.
>
>         Your change does not look correct to me. At the time
> expire_nodest_conn was created, it was not checked when
> weight is 0. At different places different terms are used
> but in short, we have two independent states for real server:
>
> - inhibited: weight=0 and no new connections should be served,
>         packets for existing connections can be routed to server
>         if it is still available and packets are not dropped
>         by expire_nodest_conn.
>         The new feature is that port reuse detection can
>         redirect the new TCP connection into a new IPVS conn and
>         to expire the existing cp/ct.
>
> - unavailable (!IP_VS_DEST_F_AVAILABLE): server is removed,
>         can be temporary, drop traffic for existing connections
>         but on expire_nodest_conn we can select different server
>
>         The new conn_reuse_mode flag allows port reuse to
> be detected. Only then expire_nodest_conn has the
> opportunity with commit dc7b3eb900aa to check weight=0
> and to consider the old traffic as finished. If a new
> server is selected, any retrans from previous connection
> would be considered as part from the new connection. It
> is a rapid way to switch server without checking with
> is_new_conn_expected() because we can not have many
> conns/conntracks to different servers.
>
> > Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> > ---
> >  Documentation/networking/ipvs-sysctl.rst | 3 +--
> >  net/netfilter/ipvs/ip_vs_core.c          | 5 +++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
> > index 2afccc63856e..1cfbf1add2fc 100644
> > --- a/Documentation/networking/ipvs-sysctl.rst
> > +++ b/Documentation/networking/ipvs-sysctl.rst
> > @@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
> >
> >       0: disable any special handling on port reuse. The new
> >       connection will be delivered to the same real server that was
> > -     servicing the previous connection. This will effectively
> > -     disable expire_nodest_conn.
> > +     servicing the previous connection.
> >
> >       bit 1: enable rescheduling of new connections when it is safe.
> >       That is, whenever expire_nodest_conn and for TCP sockets, when
> > diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> > index 128690c512df..9279aed69e23 100644
> > --- a/net/netfilter/ipvs/ip_vs_core.c
> > +++ b/net/netfilter/ipvs/ip_vs_core.c
> > @@ -2042,14 +2042,15 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
> >                            ipvs, af, skb, &iph);
> >
> >       conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> > -     if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> > +     if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> >               bool old_ct = false, resched = false;
> >
> >               if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
> >                   unlikely(!atomic_read(&cp->dest->weight))) {
> >                       resched = true;
> >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> > -             } else if (is_new_conn_expected(cp, conn_reuse_mode)) {
> > +             } else if (conn_reuse_mode &&
> > +                        is_new_conn_expected(cp, conn_reuse_mode)) {
> >                       old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> >                       if (!atomic_read(&cp->n_control)) {
> >                               resched = true;
> > --
> > 2.30.2
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
