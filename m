Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3145A6727
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiH3PVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiH3PVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:21:02 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF95467467
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:21:00 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id c2so2446526vkm.9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=EfJTQTESF2uI1hYPJYVrRsTpdvNGtMsJ3bP6OvjHJt8=;
        b=ZjzUvyf1diJJWp7JiGxnzr0H29KUh9ljGZZjVN/mGfuqRdnvGGLJlUdt1kXZuaxeQN
         NtTQL0hZtKzUR5RH0eXC7/3zhJwthiDKxHelDFWXcN5mYniqRrRXLjmPrzOT8bqdYKEk
         1GgUDu6l78qC9jQrkr4r5fPR5siqRmPFOJJXiDHxttFGGQ1MTLmglRIF7ivjqxgSpbo2
         t112h97+QGdmCDM2A8tilDIfIExpVZ4FdKCXr5i9JB+XRNnhvzZupHi1MWcZs20UQk/q
         e+Ux+16hOvIAAuM/mVk8duAiptnyfvSuZ+gsPIx11V+uGkKsfnMAdvGlwNRA0Y2+KFoL
         fffQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=EfJTQTESF2uI1hYPJYVrRsTpdvNGtMsJ3bP6OvjHJt8=;
        b=3GC3J0fLnH0tgyEuNhw7JwhKI06fN3Yh8m7eTgh1gOfS6XpowwmL91KI7/TUC5JhhH
         UWCWh9APiIUu2PxQKA3VPCy/VroS7UW43uAv6OW2Z3UF1RVHT7I0CXq3ZxQuh1NsuFXD
         dEaMwrm73fbjAiBoXSsiPFNdBt8OEwUWvd6fdtmBw8SwwM/VqacC8tGm/yxISdh6EJLU
         +xqaMuvq/8jWzrdx8pzRu9hWiEJpTxMkyWVCM4RK7AbYjZW4CQUqeYxKtSvXvp16Bg4S
         WlKjI7HllUXKDgBmCPIKCuO9AY819bTohTNtDrJPMMBv2TNmLQbF0T4k/JlBYHk3V/S3
         Y1yA==
X-Gm-Message-State: ACgBeo3NeaDNum0KhvDpyXvEfpA9P4Xc47o++368Xe53ASX7JfeRxInF
        poduT0lFOhmOhoS6xwuyZMp+XFVk50vy06J/tED+5jyVOsA=
X-Google-Smtp-Source: AA6agR4Wpbl3s4ou0QpwvqANMTyMkpsvS4kIlXlkgcovsTvPKuMhWBFYNhr2FHy2zaxVdKSoC+jJTw+Xz0/VQIOEgZQ=
X-Received: by 2002:a1f:23c1:0:b0:38c:5eed:c2b6 with SMTP id
 j184-20020a1f23c1000000b0038c5eedc2b6mr4951912vkj.26.1661872859781; Tue, 30
 Aug 2022 08:20:59 -0700 (PDT)
MIME-Version: 1.0
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Tue, 30 Aug 2022 18:20:48 +0300
Message-ID: <CAJGXZLhT3njx-Vvy=kK6WfD4BEmO=tWcASehpiZ18G-k7k++eg@mail.gmail.com>
Subject: [PATCH] net/ipv6/ip6_gre.c NBMA support
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, xeb@mail.ru,
        kuznet@ms2.inr.ac.ru, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Maintainers,

While I was studying the capabilities of the ip6_gre driver to support
NBMA networks, I found a bug:
When sending a packet over the NBMA network, the following sequence of
functions occurs:

ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap() ->
  ...
  if (ltype == IPV6_ADDR_ANY || rtype == IPV6_ADDR_ANY) {

      flags = IP6_TNL_F_CAP_PER_PACKET;
  ...

After that, the packages are dropped, but if skip ip6_tnl_xmit_ctl()

ip6gre_tunnel_xmit() -> ip6gre_xmit_ipv4() / ip6gre_xmit_ipv6() /
ip6gre_xmit_other() -> __gre6_xmit() -> ip6_tnl_xmit() ->
  ...
  /* NBMA tunnel */

  if (ipv6_addr_any(&t->parms.raddr)) {
  ...

It is strange that at first when checking addr_type == IPV6_ADDR_ANY
packages are dropped, but after that there is ipv6_addr_any(addr)
which leads to neigh_lookup() end etc.
It turns out that the same check leads to different actions. In
addition, due to the fact that the package is dropped, there is no
neighbor_lookup and the package will not be sent.
It looks like ip6_gre supports NBMA, but does not allow it to work,
because of this and other possible bugs.

This is most likely not the final patch, but for now I offer such a
patch to solve the problem.

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a9051df..34c6c5b 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -896,8 +896,14 @@ static netdev_tx_t ip6gre_tunnel_xmit(struct sk_buff *skb,
  if (!pskb_inet_may_pull(skb))
  goto tx_err;

- if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
- goto tx_err;
+ if (dev->header_ops) {
+ const struct ipv6hdr *ipv6h = (const struct ipv6hdr *)skb->data;
+ if (!ip6_tnl_xmit_ctl(t, &ipv6h->saddr, &ipv6h->daddr))
+ goto tx_err;
+ } else {
+ if (!ip6_tnl_xmit_ctl(t, &t->parms.laddr, &t->parms.raddr))
+ goto tx_err;
+ }

  switch (skb->protocol) {
  case htons(ETH_P_IP):

If the network is NBMA, then the remote address is not set in the
tunnel parameters, and then the packets will always drop on the
ip6_tnl_xmit_ctl() function, I propose a solution, if there is an ipv6
header in skb, then take the destination and source addresses from
skb, and not from the tunnel parameters.
