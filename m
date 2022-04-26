Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970FF510854
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353769AbiDZTFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352919AbiDZTFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:05:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEDD1569F6;
        Tue, 26 Apr 2022 12:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD94619BD;
        Tue, 26 Apr 2022 19:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D870C385AA;
        Tue, 26 Apr 2022 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999743;
        bh=CNOrExejcAtrT2uI/EvTsxM/o0aOOv5V/6eM/dQIZFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9cGiYiZwBChnkJ3kOX/SI/zzzEVW15bkVo2Aod4gUlDgLioT+ttIsJbrmhsjMzRY
         QKRZGJe0NLBMCY4gRpSpt+AgHZkee7sUNPTXWPcnc7J0klLpEK2IOu4uZq3Aa42Riz
         gQ/h3nO2cEQqCIIoBljHyP+vxajmJ47bUjD2F0reUIwToFVa9f1VzvABa/1oY7oy2f
         X5H8DyxSCrgVAG4ZgfDNtv1usbIn4DEyUiZTKriYKrEKJXIkTmgGguhUewwh6/6VhH
         bbu9gtNoC7kYVVkrMPj9zyyRBEPFgsG/xSmRuvwH785WyoxbrlS9pTJ8f6wMezQCnf
         vg2AqAxAFGt1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/15] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
Date:   Tue, 26 Apr 2022 15:02:06 -0400
Message-Id: <20220426190216.2351413-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
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
index 466a5610e3ca..288720838329 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -743,6 +743,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		struct ip_tunnel_info *tun_info;
 		const struct ip_tunnel_key *key;
 		__be16 flags;
+		int tun_hlen;
 
 		tun_info = skb_tunnel_info_txcheck(skb);
 		if (IS_ERR(tun_info) ||
@@ -760,9 +761,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
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

