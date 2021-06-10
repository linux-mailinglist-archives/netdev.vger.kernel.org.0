Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C963A37D4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhFJX3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:29:49 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:37794 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFJX3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:29:48 -0400
Received: by mail-ed1-f41.google.com with SMTP id b11so35047172edy.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vWXHntt6+SuAHiwSo1bFtrEltaRyItVNgpxN5V2EuXM=;
        b=Zj3PkZRA5pWYRF6SK8sXvu+rIIPJUqXWTiEEYg0ujr5yH3SGgy92aoC+f4gvkBO4x8
         jgrSCcD1ACXPN+yMVw64kQgV2DtG5iywUyZ76r8MoeMRbJy5/TYbo4ICOMa2JEFh461R
         ucKh9pxry3k+MvW4GWzbHHLnUvKnDw64LB2KScnorwYwSFmjHZbT+TfGL6kbHI8HSfUk
         BIVCATXcD+KyJAqcRTpuaaK0/fANNWJR7s9T52e4UrAMM42nlM6jNFVNmY+XyS04gHal
         ZMkkYnTyl26rKOHy6tXGysRzlHQn/2iwkMz0ZBL7MddBojj5jYJbQSjwCRR+kKjAbhw6
         dZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vWXHntt6+SuAHiwSo1bFtrEltaRyItVNgpxN5V2EuXM=;
        b=kyQQG7pwM7EOoNqng44kx3s+WS1zuM+dQ19hdkjsLd/AJmX8w2vQcCZKlO+F8P6k1J
         WlMKUSAFra67upPYezOuKnAbAGmJgycL+IGmZo1Tz8FTKbc1zeE22TcFn9+naPy6MO5g
         J3vwK1NsepyKrDEpQXadokx0LnvFAW2eHZymLmFOaWScHJsfstz2VBGShxA6oDSeNcsg
         Tm+sxV5phvJU6lxicE7dGnzJdg2rdRoNgWuRrmKzpFo1mvyVogs/5rMXawtYlW+D7tsS
         YlnnJl2+mtL7yMsDo7sg56R7YAC3CFyD/3UPV+/0rMkD1anOU5KtjQLhSfcbov3AGFq8
         NoHQ==
X-Gm-Message-State: AOAM530FfTitlG4lCccKVlJ3Xq+hkc1eH4NQSpIprSuyQExXiQ6jUBF/
        KdYt88sjZZ2AgPytXk1GaFU=
X-Google-Smtp-Source: ABdhPJxe80ST95R7vhULrWRZGhtaqaT9Lqu7NciK8ZkrzEh/MntNXnIJDY8ZSYmeYjWobpIBy3FbNA==
X-Received: by 2002:aa7:dd14:: with SMTP id i20mr881740edv.110.1623367611240;
        Thu, 10 Jun 2021 16:26:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 09/10] net: dsa: sja1105: add the RX timestamping procedure for SJA1110
Date:   Fri, 11 Jun 2021 02:26:28 +0300
Message-Id: <20210610232629.1948053-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
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
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h     |  1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 26 +++++++++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.h |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_spi.c | 10 ++++++++++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index fcba65719267..f1bf290cc8a4 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -131,6 +131,7 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
 				enum packing_op op);
+	bool (*rxtstamp)(struct dsa_switch *ds, int port, struct sk_buff *skb);
 	int (*clocking_setup)(struct sja1105_private *priv);
 	int (*pcs_mdio_read)(struct mii_bus *bus, int phy, int reg);
 	int (*pcs_mdio_write)(struct mii_bus *bus, int phy, int reg, u16 val);
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
index 0d4158fdeec0..47b2b5451ba0 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -583,6 +583,7 @@ const struct sja1105_info sja1105e_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -615,6 +616,7 @@ const struct sja1105_info sja1105t_info = {
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
 	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105et_regs,
 	.port_speed		= {
@@ -648,6 +650,7 @@ const struct sja1105_info sja1105p_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -681,6 +684,7 @@ const struct sja1105_info sja1105q_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.regs			= &sja1105pqrs_regs,
 	.port_speed		= {
@@ -714,6 +718,7 @@ const struct sja1105_info sja1105r_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.pcs_mdio_read		= sja1105_pcs_mdio_read,
 	.pcs_mdio_write		= sja1105_pcs_mdio_write,
@@ -751,6 +756,7 @@ const struct sja1105_info sja1105s_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1105_rxtstamp,
 	.clocking_setup		= sja1105_clocking_setup,
 	.pcs_mdio_read		= sja1105_pcs_mdio_read,
 	.pcs_mdio_write		= sja1105_pcs_mdio_write,
@@ -788,6 +794,7 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -837,6 +844,7 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -886,6 +894,7 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
@@ -935,6 +944,7 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
+	.rxtstamp		= sja1110_rxtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
 	.pcs_mdio_read		= sja1110_pcs_mdio_read,
 	.pcs_mdio_write		= sja1110_pcs_mdio_write,
-- 
2.25.1

