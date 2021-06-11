Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA73A4922
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhFKTFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:05:04 -0400
Received: from mail-ej1-f53.google.com ([209.85.218.53]:35458 "EHLO
        mail-ej1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhFKTFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:05:00 -0400
Received: by mail-ej1-f53.google.com with SMTP id h24so6042519ejy.2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vr3lB4Fs4zQjUJs8HCsD/VqHxaDJTu4TXGWvUHLk92o=;
        b=VFQG26oFQrDfindFHzE9OFhrxfI6Y71bgNG4NBHE08VR1bIZJbLJtskwiINIY6NUG6
         6QU1bpz+Fsq4gMeNirwtm517Sg8RUXENeK5TfDsT1zenMjzJi/jeRcc6i5udef8PUHYV
         duXCBXKjb7FsX+4RoSqvTayAwbAozKHqKcaq54YVIihhQXsT8u5kPqrNeYxv91vUW9Vo
         jhjJQcr6Zk/qa25TxLVTaR65Kw1rx2xZWX9V8B1vpckOJIinwoTv4WA6ZXI50ccOb8Tg
         OkmYAJ30dsC/WAmGBjr74x4ao4lfqr08YSgNm1B0n40MSKtRX9uBS69eaHCuqthOAVk1
         JAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vr3lB4Fs4zQjUJs8HCsD/VqHxaDJTu4TXGWvUHLk92o=;
        b=O5P9hr4e1KkLbBD99zTJ8I6T4V/QS/P+4XAmgtsAXmia61L4QW0IKkfZIIzmoC+i1E
         bbwAnQu51ulvh3YuJnJpkhEVEyj9SXlNrQnugaHev3OD0RFQHdE9BulGys+aOisRmvSg
         /x/WmHVNWmICLkiESbKSNnEqv1izP08AEBG2XeGsAPv0gzbgB4gSqwygWXWNh69e/alb
         paPBbBcadv/mjX6zTLhq3Ya8BfIFCu6XW6Zzh5IGjYk3OFvxw97Ie3op0aWVNb4I1iJN
         jdWt0BQxcbN49l9NA8waw9FULrd21OnA7W4OhEPFBz7j8Y3ieOfjAnZLxywI440nkJrH
         zSBQ==
X-Gm-Message-State: AOAM532SUwn8RTrKLGUlkfExqaWv/+Aob5+G75Gi2N4sUs9TvCwOro9N
        F5eDkoiLKWiHDsy8/fWEeKs=
X-Google-Smtp-Source: ABdhPJygCi+7NsELMN7wxcH7WWScSTwDxeNFxegM9IzIOZqndhNMnNLnZz4BNDqsFKOAU5zcMW/AeA==
X-Received: by 2002:a17:906:af95:: with SMTP id mj21mr5024795ejb.25.1623438105726;
        Fri, 11 Jun 2021 12:01:45 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 02/10] net: dsa: sja1105: allow RX timestamps to be taken on all ports for SJA1110
Date:   Fri, 11 Jun 2021 22:01:23 +0300
Message-Id: <20210611190131.2362911-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On SJA1105, there is support for a cascade port which is presumably
connected to a downstream SJA1105 switch. The upstream one does not take
PTP timestamps for packets received on this port, presumably because the
downstream switch already did (and for PTP, it only makes sense for the
leaf nodes in a DSA switch tree to do that).

I haven't been able to validate that feature in a fully assembled setup,
so I am disabling the feature by setting the cascade port to an unused
port value (ds->num_ports).

In SJA1110, multiple cascade ports are supported, and CASC_PORT became
a bit mask from a port number. So when CASC_PORT is set to ds->num_ports
(which is 11 on SJA1110), it is actually set to 0b1011, so ports 3, 1
and 0 are configured as cascade ports and we cannot take RX timestamps
on them.

So we need to introduce a check for SJA1110 and set things differently
(to zero there), so that the cascading feature is properly disabled and
RX timestamps can be taken on all ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 27 ++++++++++++++++----------
 drivers/net/dsa/sja1105/sja1105_spi.c  |  4 ++++
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f762f5488a76..4d192331754c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -109,6 +109,7 @@ struct sja1105_info {
 	int num_cbs_shapers;
 	int max_frame_mem;
 	int num_ports;
+	bool multiple_cascade_ports;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index de132a7a4a7a..850bbc793369 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -654,14 +654,6 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.host_port = priv->ds->num_ports,
 		/* Default to an invalid value */
 		.mirr_port = priv->ds->num_ports,
-		/* Link-local traffic received on casc_port will be forwarded
-		 * to host_port without embedding the source port and device ID
-		 * info in the destination MAC address (presumably because it
-		 * is a cascaded port and a downstream SJA switch already did
-		 * that). Default to an invalid port (to disable the feature)
-		 * and overwrite this if we find any DSA (cascaded) ports.
-		 */
-		.casc_port = priv->ds->num_ports,
 		/* No TTEthernet */
 		.vllupformat = SJA1105_VL_FORMAT_PSFP,
 		.vlmarker = 0,
@@ -676,6 +668,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Enable the TTEthernet engine on SJA1110 */
 		.tte_en = true,
 	};
+	struct sja1105_general_params_entry *general_params;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int port;
@@ -701,12 +694,26 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 
 	table->entry_count = table->ops->max_entry_count;
 
+	general_params = table->entries;
+
 	/* This table only has a single entry */
-	((struct sja1105_general_params_entry *)table->entries)[0] =
-				default_general_params;
+	general_params[0] = default_general_params;
 
 	sja1110_select_tdmaconfigidx(priv);
 
+	/* Link-local traffic received on casc_port will be forwarded
+	 * to host_port without embedding the source port and device ID
+	 * info in the destination MAC address, and no RX timestamps will be
+	 * taken either (presumably because it is a cascaded port and a
+	 * downstream SJA switch already did that).
+	 * To disable the feature, we need to do different things depending on
+	 * switch generation. On SJA1105 we need to set an invalid port, while
+	 * on SJA1110 which support multiple cascaded ports, this field is a
+	 * bitmask so it must be left zero.
+	 */
+	if (!priv->info->multiple_cascade_ports)
+		general_params->casc_port = ds->num_ports;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 54ecb5565761..e6c2a37aa617 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -763,6 +763,7 @@ const struct sja1105_info sja1110a_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -808,6 +809,7 @@ const struct sja1105_info sja1110b_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -853,6 +855,7 @@ const struct sja1105_info sja1110c_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -898,6 +901,7 @@ const struct sja1105_info sja1110d_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
-- 
2.25.1

