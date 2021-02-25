Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD9324F1D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhBYLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbhBYLY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:24:59 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFD1C061788
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:18 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id cf12so5543003edb.8
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TJYzUDWEHh/VBvv0PQomzAvKBuZ8csraIetX5d88KYM=;
        b=EhV7SGulAjnAZ4u3ejyIDTVtEDIT33KJdPIslbl8Wwrqz6VInJTmV4BDjdciQEf6nj
         ocG1TG/+JLnkiX/A7nkyIC79d+a1+npk9S3lMmDREwVqFSvzjPPiHYxWiu552V/7F1Ha
         ZMwsh2J0HjaJs8U4Y0TkPZkZmV3c4j9+Mf6hAIOka/xSfh480lJ8ryDelcJcJ7J3L7o1
         mmSHtU170zUFMJCYepRd5C1ml4uDIjFTbKyheMIkrkuBkPK1bzuYqbu8HdkO9EQLVo4P
         6Z//sX02cKZksfDkxKG+LtWi7+lCzTNl9eVrCcCVxoMTKHXdhMmhLvVpskoFSr/MZ7lQ
         JlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TJYzUDWEHh/VBvv0PQomzAvKBuZ8csraIetX5d88KYM=;
        b=CA4rtt6W8oF/rBtQnwcSV6g40PULEwLeZG3Q4P5yiS3BvrziFAZn/Ht5ILLOXLqAaE
         X9AEAmZv+dEeRzXzLFpoZQT8DIiTSINpdpb61pku+wAxinzYNhIdHqAXzaidzvkAVNBr
         8dxjq2gp5ff923ziNUPGaPdEsoo2HMGq0zsya8SnrXD3ewweA1aRO+07UsMkOG0YTNrL
         pdjymewcSe2+YxF0AK2D/DtrCNEiMwNK5p4s21YfQ4CAM2keWWPR2tMIR9Qhmp4kLOy3
         T2+api5H8qd+z9V5vQ3l7jhJhmNvw5Ck+n6UHEey61kymHTdNwbNJwUkYyH2nuFjmJgR
         tiwg==
X-Gm-Message-State: AOAM533a8/N4U7s1QGaLjr17czH7KBuEfrnJx21fYzknAzjLgvJmXYd6
        8WLCZ7GtqktwJSpLciPpjCc=
X-Google-Smtp-Source: ABdhPJxe9JktTaAcrn82NAE4FBsPMw2ko+G14RQGzAAv3Pt0XCa9yPauFtCelI29XWkhTsQQPHufxw==
X-Received: by 2002:a05:6402:304f:: with SMTP id bu15mr2427552edb.259.1614252257598;
        Thu, 25 Feb 2021 03:24:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id v12sm2977156ejh.94.2021.02.25.03.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 03:24:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 4/6] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
Date:   Thu, 25 Feb 2021 13:23:55 +0200
Message-Id: <20210225112357.3785911-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225112357.3785911-1-olteanv@gmail.com>
References: <20210225112357.3785911-1-olteanv@gmail.com>
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
 drivers/net/ethernet/freescale/enetc/enetc.c  | 31 +++++++++++++++----
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  3 ++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index eebe08a99270..25284bf01c16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -534,12 +534,31 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
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

