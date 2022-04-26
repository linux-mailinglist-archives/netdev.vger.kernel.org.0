Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEF51081D
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353890AbiDZTGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353790AbiDZTFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:05:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E884319A49F;
        Tue, 26 Apr 2022 12:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9808DB82249;
        Tue, 26 Apr 2022 19:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA14C385AA;
        Tue, 26 Apr 2022 19:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999756;
        bh=QBrksCVueVtqzTFMQ4iY1XT8DH2NawqzQlR0iIMujfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1M5kBL270xmJNp16Pnf7zukDRfYUFGKpbC5qx9iyIUIH4aPjidWp80PE19vOja6Q
         6zDzNl499XLzMrknDkC5AZo1/3MEJ+pPpdu3IERE3cqb/WCPixiD066Pj1W1ZvLypv
         IybXdyErOIIJ6Fx3r0QEMQx9SBkKWbKHcYj0FOCkUdtop/e+Gg2tWFqYR2r+3TRZKB
         4l8uG6VGLlz6l4QWwZR5CFZFoIbFjpCVEO0wyTm8F+zn7670YnZ/OXetiPUIfjruHa
         3vWRGkV/rCla8EF7AXbGSE1DMejDQYY+5Q9IL5Yi4239kEyGPF6TX9hBVf2zH2DTkQ
         VdcMhUqLd7RAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/9] ip6_gre: Avoid updating tunnel->tun_hlen in __gre6_xmit()
Date:   Tue, 26 Apr 2022 15:02:25 -0400
Message-Id: <20220426190232.2351606-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190232.2351606-1-sashal@kernel.org>
References: <20220426190232.2351606-1-sashal@kernel.org>
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
index 9a0263f25232..949d6fbc1ca0 100644
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

