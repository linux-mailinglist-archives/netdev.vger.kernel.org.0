Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E365C63C3B1
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiK2P0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiK2P0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:26:49 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B2040935
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 07:26:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so12622509pjo.3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 07:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gNzXEWYgSCgbFmF4O13Nk37/2uAd+fKcWVUjkhvINl8=;
        b=YwkPYobvZsaf6iB/06su3X2cyO2Ytkoih6TR+jJsC2Ot9IQqUeTaMemF8V8FV8mO6Z
         4qCgP99ngeo82Y2qbH0QyX7Q1Q4bGbr7mMbakzJx8IB0FZCzYenCgXACnMILvb8iXgtX
         Jpcx7N1P77hRRdufEwotaOt11uyEMW1VCTdW24w5aUu37NIN6qRKXQCJRA/if+nnqwN5
         faRgMhFuKKiwABs600xME11D7MT/HFVhgSIcnvW1J+Ug1ULCe2Ze5YAfTWqftDX50a8W
         KS6fmcLCHwmfv4gIO84kafRsERWyjwxWwDWWMby/JltT8NzKHpkXao7+Pq7MOofSjetd
         N4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNzXEWYgSCgbFmF4O13Nk37/2uAd+fKcWVUjkhvINl8=;
        b=2FB4Cp6rREJAfRWgMDve1uFYPDno4vLXmSJ1eyHySFj2NBlCGsClsGIxLyziT0NAiL
         zzGFoWEPrjCtjy/bi+sXHv0tq4xzNsYiEy8xGxie8mO7NRvNWSscKhV9wF8GnZjBTYGO
         QMLNz70nvZOhHxwXpxKp/ygwg9wE4BQNkgctxJAnDG9jraxUXnGX8Lg/2lExZuJAjWpJ
         ybnWJn8HuYM964Hg8LvqExrP/bAyuFHPzlDjQF//ce9l46qXbexTC9L1PMGPs0aQ7Id/
         paFT52/KmV8S0SFGSEmdcpzdkK4c72ecsPbU1xpKSdhcO/Vf95ddAStofdaiBgT+LoKi
         sfTw==
X-Gm-Message-State: ANoB5pl4xTM4Z0vEeysRc8TUbG48c/+H9PHlb6kl1ptmjqiGQbK+WLoW
        wo4r11BOP0gxhz7TSMAtGhDDpo/6xBMCeA==
X-Google-Smtp-Source: AA0mqf7c3n0ku5vPcRG+ob4hq9kKcgZZhuF3E8Jn9MuuNQoYJwvo97PxinMuEU2B3xCvwssT/DlaMQ==
X-Received: by 2002:a17:903:c5:b0:187:4467:7aba with SMTP id x5-20020a17090300c500b0018744677abamr49617127plc.61.1669735607753;
        Tue, 29 Nov 2022 07:26:47 -0800 (PST)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id pm9-20020a17090b3c4900b00210c84b8ae5sm1501112pjb.35.2022.11.29.07.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 07:26:47 -0800 (PST)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net] net: microchip: sparx5: correctly free skb in xmit
Date:   Tue, 29 Nov 2022 16:26:35 +0100
Message-Id: <20221129152635.15362-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

consume_skb on transmitted, kfree_skb on dropped, do not free on
TX_BUSY.

Previously the xmit function could return -EBUSY without freeing, which
supposedly is interpreted as a drop. And was using kfree on successfully
transmitted packets.

sparx5_fdma_xmit and sparx5_inject returns error code, where -EBUSY
indicates TX_BUSY and any other error code indicates dropped.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_packet.c | 41 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..141897dfe388 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -317,7 +317,7 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 	next_dcb_hw = sparx5_fdma_next_dcb(tx, tx->curr_entry);
 	db_hw = &next_dcb_hw->db[0];
 	if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
-		tx->dropped++;
+		return -EINVAL;
 	db = list_first_entry(&tx->db_list, struct sparx5_db, list);
 	list_move_tail(&db->list, &tx->db_list);
 	next_dcb_hw->nextptr = FDMA_DCB_INVALID_DATA;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 83c16ca5b30f..6db6ac6a3bbc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	sparx5_set_port_ifh(ifh, port->portno);
 
 	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		ret = sparx5_ptp_txtstamp_request(port, skb);
-		if (ret)
-			return ret;
+		if (sparx5_ptp_txtstamp_request(port, skb) < 0)
+			return NETDEV_TX_BUSY;
 
 		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
 		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
@@ -250,23 +249,31 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
-	if (ret == NETDEV_TX_OK) {
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+	if (ret == -EBUSY)
+		goto busy;
+	if (ret < 0)
+		goto drop;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			return ret;
+	stats->tx_bytes += skb->len;
+	stats->tx_packets++;
+	sparx5->tx.packets++;
 
-		dev_kfree_skb_any(skb);
-	} else {
-		stats->tx_dropped++;
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		return NETDEV_TX_OK;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			sparx5_ptp_txtstamp_release(port, skb);
-	}
-	return ret;
+	dev_consume_skb_any(skb);
+	return NETDEV_TX_OK;
+drop:
+	stats->tx_dropped++;
+	sparx5->tx.dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+busy:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		sparx5_ptp_txtstamp_release(port, skb);
+	return NETDEV_TX_BUSY;
 }
 
 static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
-- 
2.34.1

