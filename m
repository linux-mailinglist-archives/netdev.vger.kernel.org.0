Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1404E3A322B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFJRg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFJRg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:36:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28DFC061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:01 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ba2so32252501edb.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R35MWfVdpbq1gHwH4NrQr70JsgBdse7X0L8WNH74fR4=;
        b=TLeVPCko9Pcc8BW18fmIiVPyKe3HrA7/YFXCWDKuZALz99PvbjrOiincZcD6RlwYZG
         s6+rK7az1EsJbPMpCnejEti/z5hm2yf5rPr2Q+h6GJnyvxJhN5+d78AjKkBt0lUOnCGB
         DdxM8fgdB95tBZPDLirZISOrqP3nfS6EkrU2mQYFm2xnk/dwnrH8DHgYCWSYh3TtlYRv
         NCDLka0zR40WsDkWxz71f+LcNCtTfkTH3dDTyTx15DcB5Ki47uVarIV8duc5907MzHUH
         JxmblPuZBAmM0XFS90O/84uLfxjpISUzhnaJMF/5zAIEYOK/v/DQAUiE8ac1ht8KgBiO
         J9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R35MWfVdpbq1gHwH4NrQr70JsgBdse7X0L8WNH74fR4=;
        b=lPWWLvWHwP/To9FOy154n8RXk5NK8Fsqij+rh9clOL5rOB9pCM2QC/mP25mogTWlbx
         576CEXlllrduDt7AxNLDSTkMA23t38uGjNnhzCLc3sYnQ+7+C8wTGSlNreXSIs6+PgT5
         AGlc/1aGAUQ1gl9rihFWUUPCjDsUY6j+q3J4IwDV8et7GJZkxiZvarcfyny+yPbvcBEm
         fvTWkdD08kl90dDAlONbfbAil7nRm92zWBYM08eX4i4JNCgifuAyCKl+5y8yxMrr8A2F
         dCXH1qI+HHBC45oHTW095kwr4kW7Hn24QFX2hnkFXbHASMQ9+NnzXPLuhXeieLJ+YXPE
         SY3Q==
X-Gm-Message-State: AOAM532ghgop56pGy22xarIljkmZGv/l7C4tu3L8khjHM6kHkrbIIkkW
        loDzw435R4lDyzshEbgI5YmqRK2HP0M=
X-Google-Smtp-Source: ABdhPJz+YGiRLh3gyzLCvlpaaW4GKuz8zqGvmzGvKxN0qhV1VCkmXVRjQvRpFr0xyDhD23w3+99zsQ==
X-Received: by 2002:aa7:c445:: with SMTP id n5mr657185edr.64.1623346500227;
        Thu, 10 Jun 2021 10:35:00 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:34:59 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/10] net: dsa: sja1105: allow RX timestamps to be taken on all ports for SJA1110
Date:   Thu, 10 Jun 2021 20:34:17 +0300
Message-Id: <20210610173425.1791379-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
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

