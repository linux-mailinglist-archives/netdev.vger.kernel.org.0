Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F3B510842
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353859AbiDZTGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353862AbiDZTGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB6919AD9B;
        Tue, 26 Apr 2022 12:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E9CB8224F;
        Tue, 26 Apr 2022 19:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94812C385AF;
        Tue, 26 Apr 2022 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999772;
        bh=jxEYhLXnDhoasLkMPJ3FCn7DdkdeY51RCTlf2BMdVK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAPW0gWisLTfRwFazXhZo9BdJ5sk+de29UX+g8dmg6pX5FvU6VYfEVPCL64bAqu39
         OGR8AQn4gNqjGVWnt20Mtm4jpKiF5ctCoYgSBTNaL6FejO4gbRL0r2tJqdOPlO1ssR
         ZqjwGALSk2ET/0ghqyJK0eJiHdWr5qlRq08ykpfqu5EVxeMLlSIL4KZI5Egxfucc/s
         8SVyKfZZIYEwEYin0cQS/58Dc1W1dpYw4bQogReKVn+GWqRrKy2EKFqunw/IO3mhQy
         YQRyx5i0JQcgKZywYovDJhoJZe1rCjp6xR7W62mWLYGo8oCKG0t2mtl0woSF/blZIe
         sbdd1xs+wlgxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/6] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
Date:   Tue, 26 Apr 2022 15:02:45 -0400
Message-Id: <20220426190251.2351817-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190251.2351817-1-sashal@kernel.org>
References: <20220426190251.2351817-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

[ Upstream commit f40c064e933d7787ca7411b699504d7a2664c1f5 ]

Do not update tunnel->tun_hlen in data plane code.  Use a local variable
instead, just like "tunnel_hlen" in net/ipv4/ip_gre.c:gre_fb_xmit().

Co-developed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 043e57d08a3e..4fd6c0929b14 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -750,6 +750,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
 		__be16 flags;
+		int tun_hlen;
 
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info ||
@@ -767,9 +768,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		dsfield = key->tos;
 		flags = key->tun_flags &
 			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
-		tunnel->tun_hlen = gre_calc_hlen(flags);
+		tun_hlen = gre_calc_hlen(flags);
 
-		gre_build_header(skb, tunnel->tun_hlen,
+		gre_build_header(skb, tun_hlen,
 				 flags, protocol,
 				 tunnel_id_to_key32(tun_info->key.tun_id),
 				 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++)
-- 
2.35.1

