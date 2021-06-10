Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D473A37CF
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFJX24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJX24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:28:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8ECC0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id r11so34992642edt.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZCDcKl+1WwOP0AVAhsZWP5RDajFfbeXgqpQnTG4wPs=;
        b=c71tk3Z3mBs1oMffG/pTjrcshtngVZoeQ8Byl9l2GWpdO1npj6YJ37JiJkMv4Ob3dl
         WwLv1uLlTDFEI593n8H9IQRSLfGsC7btQljreLNd6m6vKNY0ZGnxW88H9WSM5s8aeS0i
         TO70lyI3qB32UhIVMw81/Ryq3cNZeE05mdrLbOjgXdRYFarO5CoEV28AmP0/eT7lop/t
         0vjPVhfiwKeNc3KFOWO9yyjoVal3EsrPveDGYscLMuhMUoYfHHXCysV2KnIF7Wb+eNKk
         Db3+wEhUpcRWuUSsZsA2uPtGmZzB7G28HqluPCVzYjvCm6XnCtugBKxl2IT6s+yBzzij
         t5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZCDcKl+1WwOP0AVAhsZWP5RDajFfbeXgqpQnTG4wPs=;
        b=G/uIB9KaU3F8ZgqcYbOuCs+yYIK3q6s0n0LMlIfckcbK4+TDHvw8WZEerSNm8uYVbE
         BwpfSKq+SSlM7I7J8KlQF9zicTDZ/h6gDn2lBMcJvYw93LNf7DNhvcYricX5YxQU1gBq
         pdaOSjMCLNezMi1w+kqbiaty3SLoPD5xH0F/9dFQDd2SdfjkrSSyR0WUsMkFg3bkYASZ
         gHbujMWJ5WtlqHhIJkYCI38Um4U49u2xdY6jOvTnuDhqqzHxQTzcvl0dLRKnQ5cHD8+8
         s26spr0bsUbPlCA38FwL9G723zZ0m7+ISfEz4kVkwxDQePcDH3qqijs4WovSuc70wgwZ
         4ewA==
X-Gm-Message-State: AOAM533EhzLVtaVIlMnkuLAt7M0negDS3LUvaU8e+RndplBpxutoMT8l
        sSq6vEWRukMVGBaU1sjLASw=
X-Google-Smtp-Source: ABdhPJzTOa7PHM15lS7g7lSWwJL3TvZkdtdaCo4f+C2v+Mfio4cA1vHNKNzva7e0S4c+/sZ3xVcSEw==
X-Received: by 2002:aa7:c68f:: with SMTP id n15mr825372edq.145.1623367604902;
        Thu, 10 Jun 2021 16:26:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 02/10] net: dsa: sja1105: allow RX timestamps to be taken on all ports for SJA1110
Date:   Fri, 11 Jun 2021 02:26:21 +0300
Message-Id: <20210610232629.1948053-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
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
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 27 ++++++++++++++++----------
 drivers/net/dsa/sja1105/sja1105_spi.c  |  4 ++++
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 03750e9f5a4e..cd45e9558425 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -110,6 +110,7 @@ struct sja1105_info {
 	int num_cbs_shapers;
 	int max_frame_mem;
 	int num_ports;
+	bool multiple_cascade_ports;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 86563e6fd85f..4e73a4abb09a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -656,14 +656,6 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
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
@@ -678,6 +670,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		/* Enable the TTEthernet engine on SJA1110 */
 		.tte_en = true,
 	};
+	struct sja1105_general_params_entry *general_params;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int port;
@@ -703,12 +696,26 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 
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
index 53c2213660a3..1eae25007167 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -770,6 +770,7 @@ const struct sja1105_info sja1110a_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -817,6 +818,7 @@ const struct sja1105_info sja1110b_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -864,6 +866,7 @@ const struct sja1105_info sja1110c_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
@@ -911,6 +914,7 @@ const struct sja1105_info sja1110d_info = {
 	.regs			= &sja1110_regs,
 	.qinq_tpid		= ETH_P_8021AD,
 	.can_limit_mcast_flood	= true,
+	.multiple_cascade_ports	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.max_frame_mem		= SJA1110_MAX_FRAME_MEMORY,
-- 
2.25.1

