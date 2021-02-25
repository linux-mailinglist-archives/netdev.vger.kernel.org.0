Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC53324FCC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhBYMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhBYMTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:19:40 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77A4C061788
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:59 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id p1so2053106edy.2
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vX6Zg59YNlFpdKeQjTl4TDQ74EezT+nfmo/ntrby46Y=;
        b=pJYLl2qKEosKzBeKvPMhpxDR0TjyFgG84dV+D2BNTFOz3Eozln3GRpuN7N/HXUfwZ1
         ATH7MoWHOVFUXNk4fVnMP6GkXoCRk1YTFuuHsumJrDxYN/RLhk3VC/DzgSd3HQqKBPqy
         0Q0PJJOz0zfav3l/D/IzoKoru8jVD0P44L/TjUZSkbPwFSeDmiSJlt/PjilWEcbJw5uP
         ZLC0p46NKUDp11EmwoAPZU9kbaYhNtDwtBLVlqSW42qaJ91SxdbdZSR++qCwRbMRZGXn
         Oi2aM8vX+6Kq1qGjNeg5DoQGuX+4GtbSAHVvnJm4hM1h7KkHIQ70LV8osePXTGDgbolc
         i/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vX6Zg59YNlFpdKeQjTl4TDQ74EezT+nfmo/ntrby46Y=;
        b=LDjAdSFpcmcWulTvuk3Adrc83w4fPHjRuzOeCxncTyJiFumSt2UXl3+ALO+V63KoGQ
         M7rZjqclUorTYoRjNxzpXPQ8t3exMvncJZFecWHw6dQiL4oA6YQ2xDsF9onJwKjwILCX
         HF9aLKNkIDVgw4/URZHCZMYlQ/sP0btwFvgPBcyGr3Tr4o95CLaA7wDndYKJCAGa3ei8
         ssHzGemH1XAwi75BeroFo9QfygTPc8w5JW2f88qq/de9aARLEhmwtg14LjuZZHJs2vgD
         ZFb6QS5RUO9t1r0CMeSXPDNU1L+7sXCV1GtOwxNBB87Zq/mv8FVm/2BhVHlYYBssmaqZ
         2fcw==
X-Gm-Message-State: AOAM5333AU8J1K7kU3WS4AhIqIdMdraShQaLEQlabqR/USXmRByrqGNN
        Fomb7dLlIq7gbGBIWGyQh6U=
X-Google-Smtp-Source: ABdhPJylt7/C6ki5D0ViEGl1cLPYsr2qW1FR0xrNLL4Tj2C3vGYbwO/cBsom3ucUsy9EJkRWxbfYRg==
X-Received: by 2002:a50:cf4e:: with SMTP id d14mr1134939edk.16.1614255538561;
        Thu, 25 Feb 2021 04:18:58 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:58 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 4/6] net: enetc: fix incorrect TPID when receiving 802.1ad tagged packets
Date:   Thu, 25 Feb 2021 14:18:33 +0200
Message-Id: <20210225121835.3864036-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
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
Changes in v2:
The "priv" variable needs to be used regardless of CONFIG_FSL_ENETC_PTP_CLOCK
now.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 34 ++++++++++++++-----
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index eebe08a99270..0064cfe5438e 100644
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

