Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8633A3233
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFJRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhFJRhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C60C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t3so34005695edc.7
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxLh/WF1huv8WI/G2nthBCTAxv11ECLDRHuW5UnGaRA=;
        b=Ncob5lI6TYWLVyXsAM/FTJBcmF3MTO8vfPdHoyLYJpv+L0/WlFMcCF56D2kdJbMaAi
         +XLHeFN8/gyokwTvi+RPtB0BrDvQsATNEh4GL1O7MHkkQr3vfUklb/wAY7U34m0S8DiE
         ObKO2vqrrf6QQ6lMNnqMwzOEGlM2NVOV+JrvzpjjAedOYk7UeERXenl/mEB+AxekPVe/
         onNMvsrGPBfHW5Ll9hlERmk/zzKcQFw2Jzt7LJe97iVl+HfpxTpxQaqJDZSqGbgoC8zh
         gRItBCKTQ7nhxLYpFbAoJwsVVukIeFVbWtLFvlP0TYcEq3c17ssky/N8tksg6i9TAfOC
         P/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jxLh/WF1huv8WI/G2nthBCTAxv11ECLDRHuW5UnGaRA=;
        b=sVPOAZb7ndrnRKibQBkXqQwpFmdA3PfeFbCzAXAPVzR+A9gcEUGKJaHxwtYke0+i5i
         t8VHgjiLLUBKZTKpmBX3v+qoLFrt+7zHVYyTRlmtGCV6iak/m+M5cqpIuEHJ4e6vVkp0
         8z1oK4c5qyk7+dlaKXEvpgWQWkpnsNgx2ZbyRAMyZA8vWMGQkQ1+1H0gL9FBKCczheDo
         dRCaxZnVJJVLthNliznfqv04l5Z+V+b11FUhM5iKYevmYqw5AZcsvHla05OOZwDgeTaL
         Bc9YKWTCDea0C94FCTK4HdbIX3a1KALgst3PqyPeqnI1d/8ucmy6BbpIGvr8Kds/OAMI
         vIqQ==
X-Gm-Message-State: AOAM533fzZVt3B7Ny8BvuApWIirsw06DvMlxpT0D0as88H9zgt5Jr4sK
        4eZE9w+ZEAJiAJI4EPElToEkWsYxveg=
X-Google-Smtp-Source: ABdhPJwlIykHa3//My9eAw7WPnqktxWupGNvlJtxZV0yproPCbTJ/tC04yGAT+0mAOeXkc0or5Q36g==
X-Received: by 2002:a05:6402:157:: with SMTP id s23mr638494edu.282.1623346508617;
        Thu, 10 Jun 2021 10:35:08 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/10] net: dsa: sja1105: add the RX timestamping procedure for SJA1110
Date:   Thu, 10 Jun 2021 20:34:24 +0300
Message-Id: <20210610173425.1791379-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is really easy, since the full RX timestamp is in the DSA trailer
and the tagger code transfers it to SJA1105_SKB_CB(skb)->tstamp, we just
need to move it to the skb shared info region. This is as opposed to
SJA1105, where the RX timestamp was received in a meta frame (so there
needed to be a state machine to pair the 2 packets) and the timestamp
was partial (so the packet, once matched with its timestamp, needed to
be added to an RX timestamping queue where the PTP aux worker would
reconstruct that timestamp).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h     |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 26 +++++++++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_spi.c | 10 ++++++++++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a6d64b27e6a9..201bca282884 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -130,6 +130,7 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
+	bool (*rxtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	const char *name;
 	bool supports_mii[SJA1105_MAX_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index dea82f8a40c4..62fe05b4cb60 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -413,9 +413,7 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 	return -1;
 }
 
-/* Called from dsa_skb_defer_rx_timestamp */
-bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
-			   struct sk_buff *skb, unsigned int type)
+bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
@@ -431,6 +429,28 @@ bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
 	return true;
 }
 
+bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *shwt = skb_hwtstamps(skb);
+	u64 ts = SJA1105_SKB_CB(skb)->tstamp;
+
+	*shwt = (struct skb_shared_hwtstamps) {0};
+
+	shwt->hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
+
+	/* Don't defer */
+	return false;
+}
+
+/* Called from dsa_skb_defer_rx_timestamp */
+bool sja1105_port_rxtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *skb, unsigned int type)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->info->rxtstamp(ds, port, skb);
+}
+
 /* Called from dsa_skb_tx_timestamp. This callback is just to clone
  * the skb and have it available in SJA1105_SKB_CB in the .port_deferred_xmit
  * callback, where we will timestamp it synchronously.
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 34f97f58a355..bf0c4f1dfed7 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -122,6 +122,9 @@ int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta);
 int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
 		       sja1105_spi_rw_mode_t rw);
 
+bool sja1105_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+bool sja1110_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+
 #else
 
 struct sja1105_ptp_cmd;
@@ -184,6 +187,9 @@ static inline int sja1105_ptp_commit(struct dsa_switch *ds,
 
 #define sja1105_hwtstamp_set NULL
 
+#define sja1105_rxtstamp NULL
+#define sja1110_rxtstamp NULL
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
 #endif /* _SJA1105_PTP_H */
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 9156f4cc11f2..f7dd86271891 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -580,6 +580,7 @@ const struct sja1105_info sja1105e_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -612,6 +613,7 @@ const struct sja1105_info sja1105t_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -645,6 +647,7 @@ const struct sja1105_info sja1105p_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -678,6 +681,7 @@ const struct sja1105_info sja1105q_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -711,6 +715,7 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -746,6 +751,7 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -781,6 +787,7 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -828,6 +835,7 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -875,6 +883,7 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
@@ -922,6 +931,7 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
-- 
2.25.1

