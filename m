Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23C38C79F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhEUNR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhEUNRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:17:45 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D95DC061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:21 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id z12so28971842ejw.0
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bOtIjSpCbVgRUod0/Px+WJuHpLSVLKnMshqYP8gGEC8=;
        b=a5qTrVihXCC1p6SAJ6lSTsQG3YJc6O4cX+3yhbuTH1eh/OEdjgJmNefH89TEYiwgRy
         b/L0JyM7wGk8wv8vtKnI35X0I4Mkg8Z8oQk2Ux9WrDgkdy6gRJW2Vl7iUtFTob0bj9YV
         Q8Qh7efb0HHejYhE8nb9AO3MBRrAb48unGKU4cI9i3808eek16h/koSZYSGFLHW1U2vf
         sBNJ00wyaeA/YNakt0UGRPABx3V92a+z0bambVg0PaqjipNAFZL/O1CY+gMzEXUjZkMB
         Vkmm+A2ZSb1hN0OUd3x7ERCe4xXPNHkfNeQopH4hKZGO4M+xnXtNOFvNf7bQlbFchmRH
         mbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bOtIjSpCbVgRUod0/Px+WJuHpLSVLKnMshqYP8gGEC8=;
        b=ev9JsHOCdQ3m6tRi8GElVEFAskVwOfn5aElgllWh8BleMEYGgNqSoTf3QE0qD0t1d8
         kkknrzo3XEOvnL5iFkENW+94pXR1CtcxKU1h+fK2GZPyx+/0zE/eaMdrOnWY/gO7eWfv
         int/vc0M8kuBv1E1N46kntMr68F6QTRaZ3UviyVgD5LQTBU9ghLExegWKo8RAlEp2ihL
         A7RRZ52UwNd3kY73WyC0GvLuPXqymhFLWlDW4VjPEGKeBNvrU2FYwFEoaQEBl/ajByJT
         NoHY9Y4tdzdlMIIzKfAuZ1nqBlCwh4nPb+actIpbxlrpW9rGSdHaLlt4ksbQ2ht9zJrG
         4vWg==
X-Gm-Message-State: AOAM5332WeObteGRRC+RuumCN2Zuj1Nk8+e2vr76wN2sy+Y3fdkEyrnB
        LTnz860Mt7CZQzah1az0IL8=
X-Google-Smtp-Source: ABdhPJwaLoUBpTFGZL7PFQOgNAeeuDup899sNZZqaS0h4yJVjUp1K17/gHF5PgaXxkMqtbQ6uA3pXg==
X-Received: by 2002:a17:906:3016:: with SMTP id 22mr10193860ejz.28.1621602980261;
        Fri, 21 May 2021 06:16:20 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id bm24sm3959310edb.45.2021.05.21.06.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:16:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: dsa: sja1105: stop reporting the queue levels in ethtool port counters
Date:   Fri, 21 May 2021 16:16:07 +0300
Message-Id: <20210521131608.4018058-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521131608.4018058-1-olteanv@gmail.com>
References: <20210521131608.4018058-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The queue levels are not counters, but instead they represent the
occupancy of the MAC TX queues. Having these in ethtool port counters is
not helpful, so remove them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h         |  1 -
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 54 +----------------------
 drivers/net/dsa/sja1105/sja1105_spi.c     |  1 -
 3 files changed, 2 insertions(+), 54 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 7ec40c4b2d5a..6749dc21b589 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -65,7 +65,6 @@ struct sja1105_regs {
 	u64 mac_hl1[SJA1105_NUM_PORTS];
 	u64 mac_hl2[SJA1105_NUM_PORTS];
 	u64 ether_stats[SJA1105_NUM_PORTS];
-	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
 struct sja1105_info {
diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index 9133a831ec79..2d8e5399f698 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -6,7 +6,6 @@
 #define SJA1105_SIZE_MAC_AREA		(0x02 * 4)
 #define SJA1105_SIZE_HL1_AREA		(0x10 * 4)
 #define SJA1105_SIZE_HL2_AREA		(0x4 * 4)
-#define SJA1105_SIZE_QLEVEL_AREA	(0x8 * 4) /* 0x4 to 0xB */
 #define SJA1105_SIZE_ETHER_AREA		(0x17 * 4)
 
 struct sja1105_port_status_mac {
@@ -60,8 +59,6 @@ struct sja1105_port_status_hl2 {
 	u64 n_part_drop;
 	u64 n_egr_disabled;
 	u64 n_not_reach;
-	u64 qlevel_hwm[8]; /* Only for P/Q/R/S */
-	u64 qlevel[8];     /* Only for P/Q/R/S */
 };
 
 struct sja1105_port_status_ether {
@@ -172,20 +169,6 @@ sja1105_port_status_hl2_unpack(void *buf,
 	sja1105_unpack(p + 0x0, &status->n_not_reach,    31,  0, 4);
 }
 
-static void
-sja1105pqrs_port_status_qlevel_unpack(void *buf,
-				      struct sja1105_port_status_hl2 *status)
-{
-	/* Make pointer arithmetic work on 4 bytes */
-	u32 *p = buf;
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		sja1105_unpack(p + i, &status->qlevel_hwm[i], 24, 16, 4);
-		sja1105_unpack(p + i, &status->qlevel[i],      8,  0, 4);
-	}
-}
-
 static void
 sja1105pqrs_port_status_ether_unpack(void *buf,
 				     struct sja1105_port_status_ether *status)
@@ -280,7 +263,7 @@ static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
 				       int port)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
-	u8 packed_buf[SJA1105_SIZE_QLEVEL_AREA] = {0};
+	u8 packed_buf[SJA1105_SIZE_HL2_AREA] = {0};
 	int rc;
 
 	rc = sja1105_xfer_buf(priv, SPI_READ, regs->mac_hl2[port], packed_buf,
@@ -290,18 +273,6 @@ static int sja1105_port_status_get_hl2(struct sja1105_private *priv,
 
 	sja1105_port_status_hl2_unpack(packed_buf, status);
 
-	/* Code below is strictly P/Q/R/S specific. */
-	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
-	    priv->info->device_id == SJA1105T_DEVICE_ID)
-		return 0;
-
-	rc = sja1105_xfer_buf(priv, SPI_READ, regs->qlevel[port], packed_buf,
-			      SJA1105_SIZE_QLEVEL_AREA);
-	if (rc < 0)
-		return rc;
-
-	sja1105pqrs_port_status_qlevel_unpack(packed_buf, status);
-
 	return 0;
 }
 
@@ -375,23 +346,6 @@ static char sja1105_port_stats[][ETH_GSTRING_LEN] = {
 };
 
 static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
-	/* Queue Levels */
-	"qlevel_hwm_0",
-	"qlevel_hwm_1",
-	"qlevel_hwm_2",
-	"qlevel_hwm_3",
-	"qlevel_hwm_4",
-	"qlevel_hwm_5",
-	"qlevel_hwm_6",
-	"qlevel_hwm_7",
-	"qlevel_0",
-	"qlevel_1",
-	"qlevel_2",
-	"qlevel_3",
-	"qlevel_4",
-	"qlevel_5",
-	"qlevel_6",
-	"qlevel_7",
 	/* Ether Stats */
 	"n_drops_nolearn",
 	"n_drops_noroute",
@@ -422,7 +376,7 @@ void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_port_status *status;
-	int rc, i, k = 0;
+	int rc, k = 0;
 
 	status = kzalloc(sizeof(*status), GFP_KERNEL);
 	if (!status)
@@ -482,10 +436,6 @@ void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 
 	memset(data + k, 0, ARRAY_SIZE(sja1105pqrs_extra_port_stats) *
 			sizeof(u64));
-	for (i = 0; i < 8; i++) {
-		data[k++] = status->hl2.qlevel_hwm[i];
-		data[k++] = status->hl2.qlevel[i];
-	}
 	data[k++] = status->ether.n_drops_nolearn;
 	data[k++] = status->ether.n_drops_noroute;
 	data[k++] = status->ether.n_drops_ill_dtag;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 5a7b404bf3ce..52d53e737c68 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -464,7 +464,6 @@ static struct sja1105_regs sja1105pqrs_regs = {
 	.rgmii_tx_clk = {0x100016, 0x10001C, 0x100022, 0x100028, 0x10002E},
 	.rmii_ref_clk = {0x100015, 0x10001B, 0x100021, 0x100027, 0x10002D},
 	.rmii_ext_tx_clk = {0x100017, 0x10001D, 0x100023, 0x100029, 0x10002F},
-	.qlevel = {0x604, 0x614, 0x624, 0x634, 0x644},
 	.ptpegr_ts = {0xC0, 0xC4, 0xC8, 0xCC, 0xD0},
 	.ptpschtm = 0x13, /* Spans 0x13 to 0x14 */
 	.ptppinst = 0x15,
-- 
2.25.1

