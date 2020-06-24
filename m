Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6484207BB7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406167AbgFXSoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405581AbgFXSoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:44:15 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91188C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:44:15 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so2266954edb.3
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=rLip5LNdMEXXPdX0dxHw9y7eAQVZjhbbLRDJcidzBtI=;
        b=QXZJJrqMnw1meliO3k/FYEXaL5x2egF1c44le58Ut0TBxv6SE4AVrO378mXlHv91ew
         KqO7P+ivJNVTtqX+nQR62DGqjE7eL0IVrFLaWbiVq1kQBeS4LNJNRvFbWW4sgh9NbCCp
         hRXlH4QnJoogc59jCbSHQvjqytt8EqImKWonTiDZ7JCUgJOQvF74C15gnfzh1ouyRnQx
         UdaemecjsybVWaV8hkdWYrFxqXmHO3SiTf8xSupK2+nui0PXp4xTNLnL68/rtC03S/US
         P1wH19YWmVnOmBFWfrBrBspcI8bS06nO7gOqM9gJ8Hu45HdRQWRuxA8yO0TJUysITJe2
         mDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rLip5LNdMEXXPdX0dxHw9y7eAQVZjhbbLRDJcidzBtI=;
        b=erjM9MwyNAMBSfKsvHBdttlHEDuNAeKY+zY1DeytpDl1EG2mblFUtiVSyiuD2aIGpK
         FhIILA0HumrYwyQOZ5DvyE7E4QpeE4kN0A9WovLlCdkZAaXdQwQBvJR33WniwTfexnFC
         EbCJ4ivLAk+4ndAJ6RmCdk0LQJtQH35OK+86HtfyxEppI33lX8ZtLRnZfFDzREFhxX+2
         6lzVC3o9MVOyOBbBClGmbsxhRxLkiic1f+p3KmtdpvgiYG3moigPRQnSYkygOVaN380c
         hnjs/kkncCtzkl0DPxbWu7CxXyNwBDbQ0gjyKJRvmgILociFQeb1gy942FCnX+sqp1wb
         G7vw==
X-Gm-Message-State: AOAM530lJXg2V9F9/joMYPGd1GFIYclWDnnxhWV5cRLjS7bDLkZNgalz
        HMkz6Ub45ErEUpb0mvGZZKnD6XGzOeyuCg==
X-Google-Smtp-Source: ABdhPJz2/fWNQJsfgMwNfpRzm2fYGrULj3ye7vTupATrf1nnRLDa2MlkLFqkZKqkomHZ4fM/ajijeQ==
X-Received: by 2002:a05:6402:b23:: with SMTP id bo3mr2895812edb.331.1593024254142;
        Wed, 24 Jun 2020 11:44:14 -0700 (PDT)
Received: from tws ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id v11sm5754899eja.113.2020.06.24.11.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 11:44:13 -0700 (PDT)
Date:   Wed, 24 Jun 2020 20:44:12 +0200
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200624184412.GA1371075@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation of the effective tunnel mtu, that is used to create
mtu exceptions if necessary, is currently not done correctly. This
leads to unnecessary entires in the IPv6 route cache for any
packet send through the tunnel.

The root cause is, that "dev->hard_header_len" is subtracted from the
tunnel destionations path mtu. Thus subtracting too much, if
dev->hard_header_len is filled in. This is that case for SIT tunnels
where hard_header_len is the underlyings dev hard_header_len (e.g. 14
for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).

However, the MTU of the path is exclusive of the ethernet header
and the 20 bytes for the IP header are being subtracted separately
already. Thus hard_header_len is removed from this calculation.

For IPIP and GRE tunnels this doesn't change anything as hard_header_len
is zero in those cases anyways.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/ip_tunnel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..871d28bd29fa 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -495,8 +495,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr) - tunnel_hlen;
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
-- 
2.25.1

