Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0722CA80B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392141AbgLAQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:18:49 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:38162 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390841AbgLAQSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:18:49 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4ClnMH0NpfzRm4R;
        Tue,  1 Dec 2020 17:18:03 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4ClnKk0z7Yz2xbg;
        Tue,  1 Dec 2020 17:16:42 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:10:21 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 7/9] net: dsa: microchip: ksz9477: initial hardware time stamping support
Date:   Tue, 1 Dec 2020 17:06:09 +0100
Message-ID: <20201201160611.22129-8-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201160611.22129-1-ceggers@arri.de>
References: <20201201160611.22129-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-171650-4ClnKk0z7Yz2xbg-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control routines required for TX hardware time stamping.

The KSZ9563 only supports one step time stamping
(HWTSTAMP_TX_ONESTEP_P2P), which requires linuxptp-2.0 or later.

Currently, only P2P delay measurement is supported. See patchwork
discussion and comments in ksz9477_ptp_init() for details:
https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/

Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:
--------------
- Remove useless case statement
- Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

 drivers/net/dsa/microchip/ksz9477_main.c |   6 +
 drivers/net/dsa/microchip/ksz9477_ptp.c  | 186 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_ptp.h  |  21 +++
 drivers/net/dsa/microchip/ksz_common.h   |   4 +
 4 files changed, 217 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index b13e6129322b..b164605d1563 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -1389,6 +1389,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
+	.get_ts_info		= ksz9477_ptp_get_ts_info,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz9477_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
@@ -1409,6 +1410,11 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
+	.port_hwtstamp_get      = ksz9477_ptp_port_hwtstamp_get,
+	.port_hwtstamp_set      = ksz9477_ptp_port_hwtstamp_set,
+	.port_txtstamp          = NULL,
+	/* never defer rx delivery, tstamping is done via tail tagging */
+	.port_rxtstamp          = NULL,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index 0ffc4504a290..a1ca1923ec0c 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -218,6 +218,18 @@ static int ksz9477_ptp_enable(struct ptp_clock_info *ptp,
 	return -EOPNOTSUPP;
 }
 
+static long ksz9477_ptp_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct timespec64 ts;
+
+	mutex_lock(&dev->ptp_mutex);
+	_ksz9477_ptp_gettime(dev, &ts);
+	mutex_unlock(&dev->ptp_mutex);
+
+	return HZ;  /* reschedule in 1 second */
+}
+
 static int ksz9477_ptp_start_clock(struct ksz_device *dev)
 {
 	u16 data;
@@ -257,6 +269,54 @@ static int ksz9477_ptp_stop_clock(struct ksz_device *dev)
 	return ksz_write16(dev, REG_PTP_CLK_CTRL, data);
 }
 
+/* device attributes */
+
+enum ksz9477_ptp_tcmode {
+	KSZ9477_PTP_TCMODE_E2E,
+	KSZ9477_PTP_TCMODE_P2P,
+};
+
+static int ksz9477_ptp_tcmode_set(struct ksz_device *dev,
+				  enum ksz9477_ptp_tcmode tcmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	if (tcmode == KSZ9477_PTP_TCMODE_P2P)
+		data |= PTP_TC_P2P;
+	else
+		data &= ~PTP_TC_P2P;
+
+	return ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+}
+
+enum ksz9477_ptp_ocmode {
+	KSZ9477_PTP_OCMODE_SLAVE,
+	KSZ9477_PTP_OCMODE_MASTER,
+};
+
+static int ksz9477_ptp_ocmode_set(struct ksz_device *dev,
+				  enum ksz9477_ptp_ocmode ocmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	if (ocmode == KSZ9477_PTP_OCMODE_MASTER)
+		data |= PTP_MASTER;
+	else
+		data &= ~PTP_MASTER;
+
+	return ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+}
+
 int ksz9477_ptp_init(struct ksz_device *dev)
 {
 	int ret;
@@ -282,6 +342,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.gettime64   = ksz9477_ptp_gettime;
 	dev->ptp_caps.settime64   = ksz9477_ptp_settime;
 	dev->ptp_caps.enable      = ksz9477_ptp_enable;
+	dev->ptp_caps.do_aux_work = ksz9477_ptp_do_aux_work;
 
 	/* Start hardware counter (will overflow after 136 years) */
 	ret = ksz9477_ptp_start_clock(dev);
@@ -294,8 +355,31 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 		goto error_stop_clock;
 	}
 
+	/* Currently, only P2P delay measurement is supported.  Setting ocmode
+	 * to slave will work independently of actually being master or slave.
+	 * For E2E delay measurement, switching between master and slave would
+	 * be required, as the KSZ devices filters out PTP messages depending on
+	 * the ocmode setting:
+	 * - in slave mode, DelayReq messages are filtered out
+	 * - in master mode, Sync messages are filtered out
+	 * Currently (and probably also in future) there is no interface in the
+	 * kernel which allows switching between master and slave mode.  For
+	 * this reason, E2E cannot be supported. See patchwork for full
+	 * discussion:
+	 * https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/
+	 */
+	ksz9477_ptp_tcmode_set(dev, KSZ9477_PTP_TCMODE_P2P);
+	ksz9477_ptp_ocmode_set(dev, KSZ9477_PTP_OCMODE_SLAVE);
+
+	/* Schedule cyclic call of ksz_ptp_do_aux_work() */
+	ret = ptp_schedule_worker(dev->ptp_clock, 0);
+	if (ret)
+		goto error_unregister_clock;
+
 	return 0;
 
+error_unregister_clock:
+	ptp_clock_unregister(dev->ptp_clock);
 error_stop_clock:
 	ksz9477_ptp_stop_clock(dev);
 	return ret;
@@ -306,3 +390,105 @@ void ksz9477_ptp_deinit(struct ksz_device *dev)
 	ptp_clock_unregister(dev->ptp_clock);
 	ksz9477_ptp_stop_clock(dev);
 }
+
+/* DSA PTP operations */
+
+int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
+			    struct ethtool_ts_info *ts)
+{
+	struct ksz_device *dev = ds->priv;
+
+	ts->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+			      SOF_TIMESTAMPING_RX_HARDWARE |
+			      SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	ts->phc_index = ptp_clock_index(dev->ptp_clock);
+
+	ts->tx_types = BIT(HWTSTAMP_TX_OFF) |
+		       BIT(HWTSTAMP_TX_ONESTEP_P2P);
+
+	ts->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			 BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
+				       struct hwtstamp_config *config)
+{
+	struct ksz_port *prt = &dev->ports[port];
+
+	/* reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		prt->hwts_tx_en = false;
+		break;
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		prt->hwts_tx_en = true;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		config->rx_filter = HWTSTAMP_FILTER_NONE;
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
+				  struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	unsigned long bytes_copied;
+
+	bytes_copied = copy_to_user(ifr->ifr_data,
+				    &dev->ports[port].tstamp_config,
+				    sizeof(dev->ports[port].tstamp_config));
+
+	return bytes_copied ? -EFAULT : 0;
+}
+
+int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
+				  struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config config;
+	unsigned long bytes_copied;
+	int err;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = ksz9477_set_hwtstamp_config(dev, port, &config);
+	if (err)
+		return err;
+
+	/* Save the chosen configuration to be returned later. */
+	memcpy(&dev->ports[port].tstamp_config, &config, sizeof(config));
+	bytes_copied = copy_to_user(ifr->ifr_data, &config, sizeof(config));
+
+	return bytes_copied ? -EFAULT : 0;
+}
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
index 0076538419fa..b599401812ae 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.h
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -10,6 +10,8 @@
 #ifndef DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 #define DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 
+#include <linux/types.h>
+
 #include "ksz_common.h"
 
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
@@ -17,11 +19,30 @@
 int ksz9477_ptp_init(struct ksz_device *dev);
 void ksz9477_ptp_deinit(struct ksz_device *dev);
 
+int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
+			    struct ethtool_ts_info *ts);
+int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
+				  struct ifreq *ifr);
+int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
+				  struct ifreq *ifr);
+
 #else
 
 static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
 static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
 
+static inline int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
+					  struct ethtool_ts_info *ts)
+{ return -EOPNOTSUPP; }
+
+static inline int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
+						struct ifreq *ifr)
+{ return -EOPNOTSUPP; }
+
+static inline int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
+						struct ifreq *ifr)
+{ return -EOPNOTSUPP; }
+
 #endif
 
 #endif /* DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_ */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 43dd66009482..139e9b84290b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -41,6 +41,10 @@ struct ksz_port {
 
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
+	struct hwtstamp_config tstamp_config;
+	bool hwts_tx_en;
+#endif
 };
 
 struct ksz_device {
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

