Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AE474D12
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhLNVLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237843AbhLNVKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:41 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13882C061574;
        Tue, 14 Dec 2021 13:10:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v1so67916444edx.2;
        Tue, 14 Dec 2021 13:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KraBUxmwzKBk99kKfxjTaNY5CNXTiEhl3Z5ebF3cRVg=;
        b=DdXt3L2kzGF/rp6e4C0rgCE8UTsEqHWKsvwday/9E+WReYmBxfuYirdCn1sLRKODI1
         SsiGT4B01r6tfv5yteDaBts8HbvHczOFuHUOiwaImClIm4rflWVpLCKHqOCeQOEWdj7w
         k8p1e2QaAaU+7YMUquThih7LYhGgyP0u5VjnQyyjNwrAP48acTauFzzrb8S3WITbE9Xq
         IJWi/jwA+GQM4cZMdCbhE76zMX+d6RikeA+lP0iBRNhr40q4jENDaF4nrM64tP65MCy2
         PXG3yLLMHzhAjYrtmfEUi+zwLROVsdh35CHvWLzQxeLGluwJHTbtd1mH1/0uq9gGFKW4
         C1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KraBUxmwzKBk99kKfxjTaNY5CNXTiEhl3Z5ebF3cRVg=;
        b=UoxU0J5NzvK7PsE7cFFHvNePKmjPU3rbXHRZKz+YKVfA6tJJUo+pZEJi0UeWW1SFYJ
         jPOUDH+Ow6gl1Jw8V4QyXv/461nTuSUgqt0aWGD8iBY0lhryaobmFBe1nS9YLAuFXen5
         CPVur+gObHmZQSn/mAZB3AhGYt2+WCzeKciTZhvpMlbl1rmgcN1k38E/yF/BAjOKMxKl
         6Qq+UD0J+0QJ8x3EfOdOcHhm3gQ0k4k/ncQAsdwNn6sz/Xf9ouzWOA7OyRLw4F3dGFXq
         cYbmrpKGtvmC1sD70uXOdC7Tl6vpgiZc4OgIZ15djysJ10m8H4GbIrizaE3b6BRpu0U3
         8ZCw==
X-Gm-Message-State: AOAM5321waxISkkUpMOmnOe714LP7K7+sCLquWmrF6Dy4fzHzgjStL5U
        PUJ5XdbTj4op6SLdygbBMYI=
X-Google-Smtp-Source: ABdhPJzi2r8NOzGExaDnMSMKoNueAiJUxAcEu4g1U9KptpqCYVlFBsKPL8k9HT6q2ERrYne4qhJaEQ==
X-Received: by 2002:a17:907:2089:: with SMTP id pv9mr8000964ejb.621.1639516239479;
        Tue, 14 Dec 2021 13:10:39 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:39 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 13/16] net: dsa: qca8k: add support for mib autocast in Ethernet packet
Date:   Tue, 14 Dec 2021 22:10:08 +0100
Message-Id: <20211214211011.24850-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch can autocast MIB counter using Ethernet packet.
Add support for this and provide a handler for the tagger.
The switch will send packet with MIB counter for each port, the switch
will use completion API to wait for the correct packet to be received
and will complete the task only when each packet is received.
Although the handler will drop all the other packet, we still have to
consume each MIB packet to complete the request. This is done to prevent
mixed data with concurrent ethtool request.

connect_tag_protocol() is used to add the handler to the tag_qca tagger,
master_state_change() use the MIB lock to make sure no MIB Ethernet is
in progress.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 103 +++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h |  17 ++++++-
 2 files changed, 118 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b35ba26a0696..429a1a2caede 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -795,7 +795,10 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
 	if (ret)
 		goto exit;
 
@@ -1866,6 +1869,97 @@ qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
 			ETH_GSTRING_LEN);
 }
 
+static void qca8k_mib_autocast_handler(struct dsa_port *dp, struct sk_buff *skb)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = dp->ds->priv;
+	const struct qca8k_mib_desc *mib;
+	struct mib_ethhdr *mib_ethhdr;
+	int i, mib_len, offset = 0;
+	u64 *data;
+	u8 port;
+
+	mib_ethhdr = (struct mib_ethhdr *)skb_mac_header(skb);
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	/* The switch autocast every port. Ignore other packet and
+	 * parse only the requested one.
+	 */
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
+	if (port != mib_hdr_data->req_port)
+		goto exit;
+
+	match_data = device_get_match_data(priv->dev);
+	data = mib_hdr_data->data;
+
+	for (i = 0; i < match_data->mib_count; i++) {
+		mib = &ar8327_mib[i];
+
+		/* First 3 mib are present in the skb head */
+		if (i < 3) {
+			data[i] = mib_ethhdr->data[i];
+			continue;
+		}
+
+		mib_len = sizeof(uint32_t);
+
+		/* Some mib are 64 bit wide */
+		if (mib->size == 2)
+			mib_len = sizeof(uint64_t);
+
+		/* Copy the mib value from packet to the */
+		memcpy(data + i, skb->data + offset, mib_len);
+
+		/* Set the offset for the next mib */
+		offset += mib_len;
+	}
+
+exit:
+	/* Complete on receiving all the mib packet */
+	if (refcount_dec_and_test(&mib_hdr_data->port_parsed))
+		complete(&mib_hdr_data->rw_done);
+}
+
+static int
+qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct qca8k_mib_hdr_data *mib_hdr_data;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	mib_hdr_data = &priv->mib_hdr_data;
+
+	mutex_lock(&mib_hdr_data->mutex);
+
+	reinit_completion(&mib_hdr_data->rw_done);
+
+	mib_hdr_data->req_port = dp->index;
+	mib_hdr_data->data = data;
+	refcount_set(&mib_hdr_data->port_parsed, QCA8K_NUM_PORTS);
+
+	mutex_lock(&priv->reg_mutex);
+
+	/* Send mib autocast request */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_CAST) |
+				 QCA8K_MIB_BUSY);
+
+	mutex_unlock(&priv->reg_mutex);
+
+	if (ret)
+		goto exit;
+
+	ret = wait_for_completion_timeout(&mib_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+
+	mutex_unlock(&mib_hdr_data->mutex);
+
+exit:
+	return ret;
+}
+
 static void
 qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			uint64_t *data)
@@ -1877,6 +1971,10 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	u32 hi = 0;
 	int ret;
 
+	if (priv->master &&
+	    qca8k_get_ethtool_stats_eth(ds, port, data) > 0)
+		return;
+
 	match_data = of_device_get_match_data(priv->dev);
 
 	for (i = 0; i < match_data->mib_count; i++) {
@@ -2558,6 +2656,7 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		return;
 
 	mutex_lock(&priv->mdio_hdr_data.mutex);
+	mutex_lock(&priv->mib_hdr_data.mutex);
 
 	if (operational)
 		priv->master = master;
@@ -2565,6 +2664,7 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		priv->master = NULL;
 
 	mutex_unlock(&priv->mdio_hdr_data.mutex);
+	mutex_unlock(&priv->mib_hdr_data.mutex);
 }
 
 static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
@@ -2582,6 +2682,7 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
 		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);
 
 		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
+		priv->mib_autocast_handler = qca8k_mib_autocast_handler;
 
 		break;
 	default:
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index dbe8c74c9793..4aca07db0192 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -67,7 +67,7 @@
 #define QCA8K_REG_MODULE_EN				0x030
 #define   QCA8K_MODULE_EN_MIB				BIT(0)
 #define QCA8K_REG_MIB					0x034
-#define   QCA8K_MIB_FLUSH				BIT(24)
+#define   QCA8K_MIB_FUNC				GENMASK(26, 24)
 #define   QCA8K_MIB_CPU_KEEP				BIT(20)
 #define   QCA8K_MIB_BUSY				BIT(17)
 #define QCA8K_MDIO_MASTER_CTRL				0x3c
@@ -317,6 +317,12 @@ enum qca8k_vlan_cmd {
 	QCA8K_VLAN_READ = 6,
 };
 
+enum qca8k_mid_cmd {
+	QCA8K_MIB_FLUSH = 1,
+	QCA8K_MIB_FLUSH_PORT = 2,
+	QCA8K_MIB_CAST = 3,
+};
+
 struct ar8xxx_port_status {
 	int enabled;
 };
@@ -340,6 +346,14 @@ struct qca8k_mdio_hdr_data {
 	u32 data[4];
 };
 
+struct qca8k_mib_hdr_data {
+	struct completion rw_done;
+	struct mutex mutex; /* Process one command at time */
+	refcount_t port_parsed; /* Counter to track parsed port */
+	u8 req_port;
+	u64 *data; /* pointer to ethtool data */
+};
+
 struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
@@ -367,6 +381,7 @@ struct qca8k_priv {
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
 	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mdio_hdr_data mdio_hdr_data;
+	struct qca8k_mib_hdr_data mib_hdr_data;
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

