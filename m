Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6AF327D00
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhCALUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhCALTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:19:19 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305C9C0617AA
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p1so15656156edy.2
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sULpWLe+NRtZFEp300sV7rIrU+posp1UnSxEOcxGHBo=;
        b=nNT3M0nlveqdqQcsCkwxQB1CBWBgrPTrlASo96B+xrFkm8X6/GCuLcjwptxXq+cN9K
         YUc4vNeNqvhmX/9FiEXhyVZTpstQKulZ9VUitw6GKqkJZObqfvusdnDdOPiLk8S4tQon
         0AFHSyz47c3GseI/FvW6m0AOmXoIpOIBqNGeGuClp3jy2vO4mEJvqZFf+a9VnVluW4IZ
         w0SJZVN/7n7cYnHcgQ/N6x4FHqOwJ2q2Z0bEIUWQeSd4qcHffKHcDhrMWlTMvjaD6IiS
         t1dEoIj4Pd4UvGxevKroI2hFNwNfz9J2LLF2xpuD8NTn/M5MTXyoQyvPwIFJUmPaxTIL
         CmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sULpWLe+NRtZFEp300sV7rIrU+posp1UnSxEOcxGHBo=;
        b=O7UVObDmxTGJyB0sYywCvTbO9pJXdWxjOvrZl2Zp+dIvHAX2cIvA5ulx5mt3ozjPpF
         cb/WGM/scz9NM1djJVsTiXbXj6qrYYciVb1XY4vQ2SzrnucGHqFx0VF9N+aGct6Kls/E
         LftCQZSGHhW2+WyZSC9CWDXIxpimhTbf/ep8847jwzc6g+wNUbpRn/flpbVPe3ncnmrN
         /6EBx7NT4JS4YtAdVxkEXjzXHZ0OxxK33at2nd710dnDVSYP/gSQfUk3VNrq6KcEtGz0
         S7g8kksXHFStuZViyAa/gbYZE1jxUmw17s7NcJoDXrw6WxfttU12Zkc2uqzMU3B/1/OL
         OkIw==
X-Gm-Message-State: AOAM532bXp7CCdG5I8/p2v0+weYvRyXCv8h1LrJfgb0qAuSu36XLQMlA
        IDS9LxVD0Lcc3uQZXY7gOQ8=
X-Google-Smtp-Source: ABdhPJwpCSQB8GfQnkAx4Ws/o+6P0H9lVUoGv5KjrX18Yd5IxzDHAvIUGLVE4tMD5KFHesFLo2cJpQ==
X-Received: by 2002:aa7:c456:: with SMTP id n22mr15685253edr.277.1614597518000;
        Mon, 01 Mar 2021 03:18:38 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net 4/8] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
Date:   Mon,  1 Mar 2021 13:18:14 +0200
Message-Id: <20210301111818.2081582-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When the enetc ports have rx-vlan-offload enabled, they report a TPID of
ETH_P_8021Q regardless of what was actually in the packet. When
rx-vlan-offload is disabled, packets have the proper TPID. Fix this
inconsistency by finishing the TODO left in the code.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
The "priv" variable needs to be used regardless of CONFIG_FSL_ENETC_PTP_CLOCK
now.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 34 ++++++++++++++-----
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9bcceb74fb9c..8ddf0cdc37a5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -523,9 +523,8 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 			       union enetc_rx_bd *rxbd, struct sk_buff *skb)
 {
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	struct enetc_ndev_priv *priv = netdev_priv(rx_ring->ndev);
-#endif
+
 	/* TODO: hashing */
 	if (rx_ring->ndev->features & NETIF_F_RXCSUM) {
 		u16 inet_csum = le16_to_cpu(rxbd->r.inet_csum);
@@ -534,12 +533,31 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 		skb->ip_summed = CHECKSUM_COMPLETE;
 	}
 
-	/* copy VLAN to skb, if one is extracted, for now we assume it's a
-	 * standard TPID, but HW also supports custom values
-	 */
-	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN)
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
-				       le16_to_cpu(rxbd->r.vlan_opt));
+	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_VLAN) {
+		__be16 tpid = 0;
+
+		switch (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TPID) {
+		case 0:
+			tpid = htons(ETH_P_8021Q);
+			break;
+		case 1:
+			tpid = htons(ETH_P_8021AD);
+			break;
+		case 2:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR1));
+			break;
+		case 3:
+			tpid = htons(enetc_port_rd(&priv->si->hw,
+						   ENETC_PCVLANR2));
+			break;
+		default:
+			break;
+		}
+
+		__vlan_hwaccel_put_tag(skb, tpid, le16_to_cpu(rxbd->r.vlan_opt));
+	}
+
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	if (priv->active_offloads & ENETC_F_RX_TSTAMP)
 		enetc_get_rx_tstamp(rx_ring->ndev, rxbd, skb);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 8b54562f5da6..a62604a1e54e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -172,6 +172,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIPMAR0(n)	(0x0100 + (n) * 0x8) /* n = SI index */
 #define ENETC_PSIPMAR1(n)	(0x0104 + (n) * 0x8)
 #define ENETC_PVCLCTR		0x0208
+#define ENETC_PCVLANR1		0x0210
+#define ENETC_PCVLANR2		0x0214
 #define ENETC_VLAN_TYPE_C	BIT(0)
 #define ENETC_VLAN_TYPE_S	BIT(1)
 #define ENETC_PVCLCTR_OVTPIDL(bmp)	((bmp) & 0xff) /* VLAN_TYPE */
@@ -570,6 +572,7 @@ union enetc_rx_bd {
 #define ENETC_RXBD_LSTATUS(flags)	((flags) << 16)
 #define ENETC_RXBD_FLAG_VLAN	BIT(9)
 #define ENETC_RXBD_FLAG_TSTMP	BIT(10)
+#define ENETC_RXBD_FLAG_TPID	GENMASK(1, 0)
 
 #define ENETC_MAC_ADDR_FILT_CNT	8 /* # of supported entries per port */
 #define EMETC_MAC_ADDR_FILT_RES	3 /* # of reserved entries at the beginning */
-- 
2.25.1

