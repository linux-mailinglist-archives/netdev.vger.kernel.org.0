Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC639F7A
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfFHMF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53481 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfFHMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so4441128wmj.3;
        Sat, 08 Jun 2019 05:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eIJopOpfrf71xA2uHWpcqD8vKfMEYZecNggwM1ZBWGU=;
        b=oqjhI5rWf+bPhXvTQB+NqWLgFo2CjniRUMCCG8tsgaLoEO4TXuOkS3pzyAnG0XO1Uu
         eHffXNtDMnGStI+4T9v5s4PZShq1UGkcwjBhZq50oiphAhKIz43IS3WwChTtWV6Eh5Rb
         yvgFGWKpkwEhMS+zqjwBx3x5Hb8TFFD9huyQgJYjrPK6ft4vzWm4MWASPDhUCBLIe/Hw
         H+Qx308TKadnr379nNFKtn+A/WVeMOZfbWj/kFj+MYlmbMGlozxxmHmn4JLpK+y6mo92
         /XxRSwLeGkjEI/0498LN9YnQDsguSjCEfUUXZfitiESzqtt0RlM5gDUdVR0yX89XWvJk
         zphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eIJopOpfrf71xA2uHWpcqD8vKfMEYZecNggwM1ZBWGU=;
        b=NBwxSy2kA06cEBKDSUyfU5cJzyCT6ZRMdCz9GBi8UHfxhkJzq6QsLcxq8aGZ1EFhIa
         tZAm60qv+wNa4rvUH8hWey2wtJYw1xPlaBEkEuh3+53HGGJL+mu9gsJ/pnJzoFOxomDU
         QsdvAm1r4Zx5NYSG2VY2CjcR5ZXIjA58tEuYAmqHFrq8K4yP2kc2LMwX2Tf6gXbkapYu
         a3dT2bErg0Vg4MSWeQbUxK+mxjbaA2XO8xQGl4/FSiiLd7ZAGXRNh6/aGa94yut0auia
         OrnH6WfkgIRV94vWl08sEaBRvrXnQxF3fy3/cBFRNmcL11bZr1tDNNvYTzkwrfcxOwYq
         s5Ng==
X-Gm-Message-State: APjAAAX3Rv5U80iYqTbaKbly11++0Lyi3is0amiIw09CUkRrkx5Qhj/I
        oj6FyWn02x9HAfRCujlQj3o=
X-Google-Smtp-Source: APXvYqxqH1mHW/Hi0WNYKxireMYM3t6A7+dGSf4siC/tgy2PNWol8WUOAkVLn+x1DHWolEFeDC8saA==
X-Received: by 2002:a1c:6c0a:: with SMTP id h10mr5045951wmc.40.1559995553796;
        Sat, 08 Jun 2019 05:05:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 17/17] net: dsa: sja1105: Expose PTP timestamping ioctls to userspace
Date:   Sat,  8 Jun 2019 15:04:43 +0300
Message-Id: <20190608120443.21889-18-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables the PTP support towards userspace applications such as
linuxptp.

The switches can timestamp only trapped multicast MAC frames, and
therefore only the profiles of 1588 over L2 are supported.

TX timestamping can be enabled per port, but RX timestamping is enabled
globally. As long as RX timestamping is enabled, the switch will emit
metadata follow-up frames that will be processed by the tagger. It may
be a problem that linuxptp does not restore the RX timestamping settings
when exiting.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

None.

Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 drivers/net/dsa/sja1105/sja1105_main.c | 96 ++++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  6 +-
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8963b21b3061..0db30e2da903 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1755,6 +1755,100 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 	return sja1105_static_config_reload(priv);
 }
 
+/* Caller must hold priv->tagger_data.meta_lock */
+static int sja1105_change_rxtstamping(struct sja1105_private *priv,
+				      bool on)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+	int rc;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	general_params->send_meta1 = on;
+	general_params->send_meta0 = on;
+
+	rc = sja1105_init_avb_params(priv, on);
+	if (rc < 0)
+		return rc;
+
+	/* Initialize the meta state machine to a known state */
+	if (priv->tagger_data.stampable_skb) {
+		kfree_skb(priv->tagger_data.stampable_skb);
+		priv->tagger_data.stampable_skb = NULL;
+	}
+
+	return sja1105_static_config_reload(priv);
+}
+
+static int sja1105_hwtstamp_set(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct hwtstamp_config config;
+	bool rx_on;
+	int rc;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		priv->ports[port].hwts_tx_en = false;
+		break;
+	case HWTSTAMP_TX_ON:
+		priv->ports[port].hwts_tx_en = true;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		rx_on = false;
+		break;
+	default:
+		rx_on = true;
+		break;
+	}
+
+	if (rx_on != priv->tagger_data.hwts_rx_en) {
+		spin_lock(&priv->tagger_data.meta_lock);
+		rc = sja1105_change_rxtstamping(priv, rx_on);
+		spin_unlock(&priv->tagger_data.meta_lock);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to change RX timestamping: %d\n", rc);
+			return -EFAULT;
+		}
+		priv->tagger_data.hwts_rx_en = rx_on;
+	}
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
+}
+
+static int sja1105_hwtstamp_get(struct dsa_switch *ds, int port,
+				struct ifreq *ifr)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct hwtstamp_config config;
+
+	config.flags = 0;
+	if (priv->ports[port].hwts_tx_en)
+		config.tx_type = HWTSTAMP_TX_ON;
+	else
+		config.tx_type = HWTSTAMP_TX_OFF;
+	if (priv->tagger_data.hwts_rx_en)
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
 #define to_tagger(d) \
 	container_of((d), struct sja1105_tagger_data, rxtstamp_work)
 #define to_sja1105(d) \
@@ -1847,6 +1941,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_deferred_xmit	= sja1105_port_deferred_xmit,
+	.port_hwtstamp_get	= sja1105_hwtstamp_get,
+	.port_hwtstamp_set	= sja1105_hwtstamp_set,
 	.port_rxtstamp		= sja1105_port_rxtstamp,
 	.port_txtstamp		= sja1105_port_txtstamp,
 };
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 01ecc8fb1b30..3041cf9d5856 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -70,8 +70,10 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = (1 << HWTSTAMP_TX_OFF);
-	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE);
+	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
+			 (1 << HWTSTAMP_TX_ON);
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
 	info->phc_index = ptp_clock_index(priv->clock);
 	return 0;
 }
-- 
2.17.1

