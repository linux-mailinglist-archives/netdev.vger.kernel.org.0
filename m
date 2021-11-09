Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CFD44AAF4
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbhKIJyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:54:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35044 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244998AbhKIJx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:57 -0500
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tHBO2b/mRYqYaDxmJViJfyYebaSLivzcR+D3MQPfYI=;
        b=pIO4YMV7vjsKIUiMyfskBgshhCRgjBXAVW5BQsGFdKBssH/g6xEuRFeNOwSajPv/Y9lnR6
        Jk6e2lEpK6hzPEZmnoujPZgvnbHHchLRmSnbzeXbupwFhvkTDiEbNfd5x2N7FRDSn/meQT
        f7plRlTymJstIxhoxLbUAgX06GFtBgpkGgwxGNn2ICjyDKpMalqklKzrGGCIADtSRbD/Pk
        9gSDWSTXgpQhGdDmLq5RTSlaud0wA3hfBucB7dCHxwpkgZwbEPFbS2SgbPc0PZc4SYKhrz
        sQ0n45cIWsMjqNbQzVFf5NCRSsHYkAUgjUPc1CLb/WeO2ppEjHYJgQx+CSlAaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2tHBO2b/mRYqYaDxmJViJfyYebaSLivzcR+D3MQPfYI=;
        b=ghE+auZmb+06eJQ90iZy85RhAs34/Y0gR0NjNZ+1KDjFS5bX28Lir+LjJ/OgrFa7iHvoF/
        AfvfeKWw8x0icfDQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 7/7] net: dsa: b53: Expose PTP timestamping ioctls to userspace
Date:   Tue,  9 Nov 2021 10:50:09 +0100
Message-Id: <20211109095013.27829-8-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow userspace to use the PTP support. Currently only L2 is supported.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c |  2 +
 drivers/net/dsa/b53/b53_ptp.c    | 90 +++++++++++++++++++++++++++++++-
 drivers/net/dsa/b53/b53_ptp.h    | 14 +++++
 3 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 56a9de89b38b..3e7e5f83cc84 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2302,6 +2302,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.get_ts_info		= b53_get_ts_info,
 	.port_rxtstamp		= b53_port_rxtstamp,
 	.port_txtstamp		= b53_port_txtstamp,
+	.port_hwtstamp_set	= b53_port_hwtstamp_set,
+	.port_hwtstamp_get	= b53_port_hwtstamp_get,
 };
 
 struct b53_chip_data {
diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
index 5567135ba8b9..f611ac219fb5 100644
--- a/drivers/net/dsa/b53/b53_ptp.c
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -260,13 +260,99 @@ int b53_get_ts_info(struct dsa_switch *ds, int port,
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = BIT(HWTSTAMP_TX_OFF);
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+	info->tx_types = BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
 
 	return 0;
 }
 EXPORT_SYMBOL(b53_get_ts_info);
 
+static int b53_set_hwtstamp_config(struct b53_device *dev, int port,
+				   struct hwtstamp_config *config)
+{
+	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
+	bool tstamp_enable = false;
+
+	clear_bit_unlock(B53_HWTSTAMP_ENABLED, &ps->state);
+
+	/* Reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_ON:
+		tstamp_enable = true;
+		break;
+	case HWTSTAMP_TX_OFF:
+		tstamp_enable = false;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		tstamp_enable = false;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (ps->tx_skb) {
+		dev_kfree_skb_any(ps->tx_skb);
+		ps->tx_skb = NULL;
+	}
+	clear_bit(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
+
+	if (tstamp_enable)
+		set_bit(B53_HWTSTAMP_ENABLED, &ps->state);
+
+	return 0;
+}
+
+int b53_port_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct b53_device *dev = ds->priv;
+	struct b53_port_hwtstamp *ps;
+	struct hwtstamp_config config;
+	int err;
+
+	ps = &dev->ports[port].port_hwtstamp;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = b53_set_hwtstamp_config(dev, port, &config);
+	if (err)
+		return err;
+
+	/* Save the chosen configuration to be returned later */
+	memcpy(&ps->tstamp_config, &config, sizeof(config));
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT :
+								      0;
+}
+EXPORT_SYMBOL(b53_port_hwtstamp_set);
+
+int b53_port_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct b53_device *dev = ds->priv;
+	struct b53_port_hwtstamp *ps;
+	struct hwtstamp_config *config;
+
+	ps = &dev->ports[port].port_hwtstamp;
+	config = &ps->tstamp_config;
+
+	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ? -EFAULT :
+								      0;
+}
+EXPORT_SYMBOL(b53_port_hwtstamp_get);
+
 void b53_ptp_exit(struct b53_device *dev)
 {
 	if (dev->ptp_clock)
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
index f888f0a2022a..3a341f752e31 100644
--- a/drivers/net/dsa/b53/b53_ptp.h
+++ b/drivers/net/dsa/b53/b53_ptp.h
@@ -17,6 +17,8 @@ int b53_ptp_init(struct b53_device *dev);
 void b53_ptp_exit(struct b53_device *dev);
 int b53_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *info);
+int b53_port_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int b53_port_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
 		       unsigned int type);
 void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
@@ -38,6 +40,18 @@ static inline int b53_get_ts_info(struct dsa_switch *ds, int port,
 	return -EOPNOTSUPP;
 }
 
+static inline int b53_port_hwtstamp_set(struct dsa_switch *ds, int port,
+					struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int b53_port_hwtstamp_get(struct dsa_switch *ds, int port,
+					struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
 				     struct sk_buff *skb, unsigned int type)
 {
-- 
2.20.1

