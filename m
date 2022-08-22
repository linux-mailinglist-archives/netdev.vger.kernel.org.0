Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A28F59BDA2
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 12:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiHVKdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 06:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbiHVKdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 06:33:51 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58147B4A7;
        Mon, 22 Aug 2022 03:33:42 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:40060.967873379
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.8.199 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id C78612800A3;
        Mon, 22 Aug 2022 18:33:31 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id d3193f7cfc9d430590909a27ad267485 for j.vosburgh@gmail.com;
        Mon, 22 Aug 2022 18:33:37 CST
X-Transaction-ID: d3193f7cfc9d430590909a27ad267485
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: [PATCH] bonding: Remove unnecessary check
Date:   Mon, 22 Aug 2022 03:31:29 -0700
Message-Id: <20220822103130.3466-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This check is not necessary since the commit d5410ac7b0ba
("net:bonding:support balance-alb interface with vlan to bridge").

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/bonding/bond_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 50e60843020c..6b0f0ce9b9a1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1578,19 +1578,6 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 
 	skb->dev = bond->dev;
 
-	if (BOND_MODE(bond) == BOND_MODE_ALB &&
-	    netif_is_bridge_port(bond->dev) &&
-	    skb->pkt_type == PACKET_HOST) {
-
-		if (unlikely(skb_cow_head(skb,
-					  skb->data - skb_mac_header(skb)))) {
-			kfree_skb(skb);
-			return RX_HANDLER_CONSUMED;
-		}
-		bond_hw_addr_copy(eth_hdr(skb)->h_dest, bond->dev->dev_addr,
-				  bond->dev->addr_len);
-	}
-
 	return ret;
 }
 
-- 
2.27.0

