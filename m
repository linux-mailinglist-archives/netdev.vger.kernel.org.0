Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A944453F3
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhKDNg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhKDNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:36:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126E8C06120F;
        Thu,  4 Nov 2021 06:33:21 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636032799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8E3fvjFKnDBYd2+65CP3heOPFlbdWmN958LUv+wcGo=;
        b=oNr/SmqNmKhLad2blKhLeSYxXroK6FOB8nq8xMP0FQoPz0lt2wmRjtvAyf8ClwbSfmnsXf
        zxr7jIuRmniqXWANERlKE263M6mZgH6NEzSvBHSY5goG5yJORZpWzpRGSJEiPNHUlm6lLy
        OApvg24SHQxZRI5XF99XdmnYelQ3azbqqGmZf5MJfxapsnoaITybHNjz4wc7s3RmUV3ynw
        U0iZyoxi9ANpk1qDJeNpdYr/SLBgtddOH0Ux7zhE1je3UtEeR7lz0LR+eRb9+U8NYo8iT/
        QkV+int4APuWUFWH6kCj8siJ3DoRspxWaCpLsXDueyuyIsTD/EI0sG6PF5CG+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636032799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8E3fvjFKnDBYd2+65CP3heOPFlbdWmN958LUv+wcGo=;
        b=6z4L1JBqLXZfMfQEYxwHQsWyMEE701JYdmoYy16JhKiPryeoWvFDtf1oeuy0xB7urMNoiz
        N74e+pSCjpcSmnCg==
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
Subject: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to userspace
Date:   Thu,  4 Nov 2021 14:32:01 +0100
Message-Id: <20211104133204.19757-8-martin.kaistra@linutronix.de>
In-Reply-To: <20211104133204.19757-1-martin.kaistra@linutronix.de>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
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
 drivers/net/dsa/b53/b53_ptp.c    | 92 +++++++++++++++++++++++++++++++-
 drivers/net/dsa/b53/b53_ptp.h    | 14 +++++
 3 files changed, 106 insertions(+), 2 deletions(-)

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
index 7cb4d1c9d6f7..a0a91134d2d8 100644
--- a/drivers/net/dsa/b53/b53_ptp.c
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -263,12 +263,100 @@ int b53_get_ts_info(struct dsa_switch *ds, int port,
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = BIT(HWTSTAMP_TX_OFF);
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+	info->tx_types = BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT);
 
 	return 0;
 }
 
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
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_ALL:
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
+
 void b53_ptp_exit(struct b53_device *dev)
 {
 	cancel_delayed_work_sync(&dev->overflow_work);
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
index c76e3f4018d0..51146d451361 100644
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

