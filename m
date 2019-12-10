Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8CD117F4D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfLJFEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:04:14 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39565 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJFEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:04:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id e10so18292608ljj.6
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 21:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/Nz55cJ3ezfSOObCld3JOoRirganwhxNqtfahwSkWc=;
        b=LrKZqRmLMbbBJ37CSG5Njvkr/QSWpalWFaPHohuG1udSrz3UWFYcbgSEmPstje2f02
         n1sr3ja4TM6sBAZjJ1AaZxIgnkq2ixboZhslPbY1EFlgl4AO13MpcF5wX6mynwiCyQcF
         JMWUDYSBqwwl39RDYEvgM18La6J28/fX2GRfkC9SuUaorxpwkP0QJF/c3+a2pgnGXOQM
         Bqx61ZZzqkeNbGaTSh8U3rSqZzX2Co3nylZTrSuAcjxvwiQoZ/LU7cOR2u65fthOGw0f
         8v9gS0Lro65GWgq6t9CgpUJybydIHiKhqgrcnffF2ORNR8B+l/pt8NHnGmeIMN8nuv9O
         fsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/Nz55cJ3ezfSOObCld3JOoRirganwhxNqtfahwSkWc=;
        b=frYcNG6Fwlx2Jmksj2HOn0wvbtTpU4cHF10TNFLwAUYpFAoUw3Y0eLvCqxDEW/wA3d
         9aTIOLSmPuI31vpJn2aXAfSFeCgGQ44NriqafZ/u33uy4V+ZwS1EnQkwOgqI57yMqe2z
         2YMH57UgOcayg6TREG5ZtPqr7Ar9i+MReRLqiJaTMMxB3McRLSc6rTftNMonjcuOYWgw
         7Xplo09pl3rpaSZJC94gZDrZ3gxdbGXjws5neyjgBrzTWHTNm1AvWhuTe/HgKh+jZgVg
         UsS2LMXBW1o/G23vWHK5NMH942SC1P6ocQaFUY2muFikOeAjBmn7u4o7GIkV8oZ+nXQj
         ZEVA==
X-Gm-Message-State: APjAAAWujob/tP07pvJUeYPT05HX74RMdestvDjnQnvyjYKwItwel7oo
        lxLkW3L5g2jaGI4Sl1WpwyEwWKKV6xM=
X-Google-Smtp-Source: APXvYqx3dvabA3EK8p6xuZgNhP+942SqYcXgpJCkkybnAsmnoqpNM/7W9UCqwwy8L4NBhUKOFPqZ6Q==
X-Received: by 2002:a2e:144b:: with SMTP id 11mr19036432lju.216.1575954250192;
        Mon, 09 Dec 2019 21:04:10 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r125sm737119lff.70.2019.12.09.21.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 21:04:09 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next] nfp: add support for TLV device stats
Date:   Mon,  9 Dec 2019 21:04:01 -0800
Message-Id: <20191210050401.20000-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device stats are currently hard coded in the PCI BAR0 layout.
Add a ability to read them from the TLV area instead.
Names for the stats are maintained by the driver, and their
meaning documented. This allows us to more easily add and
remove device stats.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../device_drivers/netronome/nfp.rst          | 116 ++++++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |   9 ++
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  16 +++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 108 ++++++++++++++--
 4 files changed, 242 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/device_drivers/netronome/nfp.rst b/Documentation/networking/device_drivers/netronome/nfp.rst
index 6c08ac8b5147..ada611fb427c 100644
--- a/Documentation/networking/device_drivers/netronome/nfp.rst
+++ b/Documentation/networking/device_drivers/netronome/nfp.rst
@@ -131,3 +131,119 @@ abi_drv_reset
 abi_drv_load_ifc
     Defines a list of PF devices allowed to load FW on the device.
     This variable is not currently user configurable.
+
+Statistics
+==========
+
+Following device statistics are available through the ``ethtool -S`` interface:
+
+.. flat-table:: NFP device statistics
+   :header-rows: 1
+   :widths: 3 1 11
+
+   * - Name
+     - ID
+     - Meaning
+
+   * - dev_rx_discards
+     - 1
+     - Packet can be discarded on the RX path for one of the following reasons:
+
+        * The NIC is not in promisc mode, and the destination MAC address
+          doesn't match the interfaces' MAC address.
+        * The received packet is larger than the max buffer size on the host.
+          I.e. it exceeds the Layer 3 MRU.
+        * There is no freelist descriptor available on the host for the packet.
+          It is likely that the NIC couldn't cache one in time.
+        * A BPF program discarded the packet.
+        * The datapath drop action was executed.
+        * The MAC discarded the packet due to lack of ingress buffer space
+          on the NIC.
+
+   * - dev_rx_errors
+     - 2
+     - A packet can be counted (and dropped) as RX error for the following
+       reasons:
+
+       * A problem with the VEB lookup (only when SR-IOV is used).
+       * A physical layer problem that causes Ethernet errors, like FCS or
+         alignment errors. The cause is usually faulty cables or SFPs.
+
+   * - dev_rx_bytes
+     - 3
+     - Total number of bytes received.
+
+   * - dev_rx_uc_bytes
+     - 4
+     - Unicast bytes received.
+
+   * - dev_rx_mc_bytes
+     - 5
+     - Multicast bytes received.
+
+   * - dev_rx_bc_bytes
+     - 6
+     - Broadcast bytes received.
+
+   * - dev_rx_pkts
+     - 7
+     - Total number of packets received.
+
+   * - dev_rx_mc_pkts
+     - 8
+     - Multicast packets received.
+
+   * - dev_rx_bc_pkts
+     - 9
+     - Broadcast packets received.
+
+   * - dev_tx_discards
+     - 10
+     - A packet can be discarded in the TX direction if the MAC is
+       being flow controlled and the NIC runs out of TX queue space.
+
+   * - dev_tx_errors
+     - 11
+     - A packet can be counted as TX error (and dropped) for one for the
+       following reasons:
+
+       * The packet is an LSO segment, but the Layer 3 or Layer 4 offset
+         could not be determined. Therefore LSO could not continue.
+       * An invalid packet descriptor was received over PCIe.
+       * The packet Layer 3 length exceeds the device MTU.
+       * An error on the MAC/physical layer. Usually due to faulty cables or
+         SFPs.
+       * A CTM buffer could not be allocated.
+       * The packet offset was incorrect and could not be fixed by the NIC.
+
+   * - dev_tx_bytes
+     - 12
+     - Total number of bytes transmitted.
+
+   * - dev_tx_uc_bytes
+     - 13
+     - Unicast bytes transmitted.
+
+   * - dev_tx_mc_bytes
+     - 14
+     - Multicast bytes transmitted.
+
+   * - dev_tx_bc_bytes
+     - 15
+     - Broadcast bytes transmitted.
+
+   * - dev_tx_pkts
+     - 16
+     - Total number of packets transmitted.
+
+   * - dev_tx_mc_pkts
+     - 17
+     - Multicast packets transmitted.
+
+   * - dev_tx_bc_pkts
+     - 18
+     - Broadcast packets transmitted.
+
+Note that statistics unknown to the driver will be displayed as
+``dev_unknown_stat$ID``, where ``$ID`` refers to the second column
+above.
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
index d835c14b7257..45756648a85c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.c
@@ -114,6 +114,15 @@ int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
 			caps->crypto_ops = readl(data);
 			caps->crypto_enable_off = data - ctrl_mem + 16;
 			break;
+		case NFP_NET_CFG_TLV_TYPE_VNIC_STATS:
+			if ((data - ctrl_mem) % 8) {
+				dev_warn(dev, "VNIC STATS TLV misaligned, ignoring offset:%u len:%u\n",
+					 offset, length);
+				break;
+			}
+			caps->vnic_stats_off = data - ctrl_mem;
+			caps->vnic_stats_cnt = length / 10;
+			break;
 		default:
 			if (!FIELD_GET(NFP_NET_CFG_TLV_HEADER_REQUIRED, hdr))
 				break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index ee6b24e4eacd..c38cc36a2a70 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -479,6 +479,17 @@
  * 8 words, bitmaps of supported and enabled crypto operations.
  * First 16B (4 words) contains a bitmap of supported crypto operations,
  * and next 16B contain the enabled operations.
+ *
+ * %NFP_NET_CFG_TLV_TYPE_VNIC_STATS:
+ * Variable, per-vNIC statistics, data should be 8B aligned (FW should insert
+ * zero-length RESERVED TLV to pad).
+ * TLV data has two sections.  First is an array of statistics' IDs (2B each).
+ * Second 8B statistics themselves.  Statistics are 8B aligned, meaning there
+ * may be a padding between sections.
+ * Number of statistics can be determined as floor(tlv.length / (2 + 8)).
+ * This TLV overwrites %NFP_NET_CFG_STATS_* values (statistics in this TLV
+ * duplicate the old ones, so driver should be careful not to unnecessarily
+ * render both).
  */
 #define NFP_NET_CFG_TLV_TYPE_UNKNOWN		0
 #define NFP_NET_CFG_TLV_TYPE_RESERVED		1
@@ -490,6 +501,7 @@
 #define NFP_NET_CFG_TLV_TYPE_REPR_CAP		7
 #define NFP_NET_CFG_TLV_TYPE_MBOX_CMSG_TYPES	10
 #define NFP_NET_CFG_TLV_TYPE_CRYPTO_OPS		11 /* see crypto/fw.h */
+#define NFP_NET_CFG_TLV_TYPE_VNIC_STATS		12
 
 struct device;
 
@@ -502,6 +514,8 @@ struct device;
  * @mbox_cmsg_types:	cmsgs which can be passed through the mailbox
  * @crypto_ops:		supported crypto operations
  * @crypto_enable_off:	offset of crypto ops enable region
+ * @vnic_stats_off:	offset of vNIC stats area
+ * @vnic_stats_cnt:	number of vNIC stats
  */
 struct nfp_net_tlv_caps {
 	u32 me_freq_mhz;
@@ -511,6 +525,8 @@ struct nfp_net_tlv_caps {
 	u32 mbox_cmsg_types;
 	u32 crypto_ops;
 	unsigned int crypto_enable_off;
+	unsigned int vnic_stats_off;
+	unsigned int vnic_stats_cnt;
 };
 
 int nfp_net_tlv_caps_parse(struct device *dev, u8 __iomem *ctrl_mem,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b840ee47339..b386a221c599 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -148,6 +148,28 @@ static const struct nfp_et_stat nfp_mac_et_stats[] = {
 	{ "tx_pause_frames_class7",	NFP_MAC_STATS_TX_PAUSE_FRAMES_CLASS7, },
 };
 
+static const char nfp_tlv_stat_names[][ETH_GSTRING_LEN] = {
+	[1]	= "dev_rx_discards",
+	[2]	= "dev_rx_errors",
+	[3]	= "dev_rx_bytes",
+	[4]	= "dev_rx_uc_bytes",
+	[5]	= "dev_rx_mc_bytes",
+	[6]	= "dev_rx_bc_bytes",
+	[7]	= "dev_rx_pkts",
+	[8]	= "dev_rx_mc_pkts",
+	[9]	= "dev_rx_bc_pkts",
+
+	[10]	= "dev_tx_discards",
+	[11]	= "dev_tx_errors",
+	[12]	= "dev_tx_bytes",
+	[13]	= "dev_tx_uc_bytes",
+	[14]	= "dev_tx_mc_bytes",
+	[15]	= "dev_tx_bc_bytes",
+	[16]	= "dev_tx_pkts",
+	[17]	= "dev_tx_mc_pkts",
+	[18]	= "dev_tx_bc_pkts",
+};
+
 #define NN_ET_GLOBAL_STATS_LEN ARRAY_SIZE(nfp_net_et_stats)
 #define NN_ET_SWITCH_STATS_LEN 9
 #define NN_RVEC_GATHER_STATS	13
@@ -560,6 +582,65 @@ nfp_vnic_get_hw_stats(u64 *data, u8 __iomem *mem, unsigned int num_vecs)
 	return data;
 }
 
+static unsigned int nfp_vnic_get_tlv_stats_count(struct nfp_net *nn)
+{
+	return nn->tlv_caps.vnic_stats_cnt + nn->max_r_vecs * 4;
+}
+
+static u8 *nfp_vnic_get_tlv_stats_strings(struct nfp_net *nn, u8 *data)
+{
+	unsigned int i, id;
+	u8 __iomem *mem;
+	u64 id_word = 0;
+
+	mem = nn->dp.ctrl_bar + nn->tlv_caps.vnic_stats_off;
+	for (i = 0; i < nn->tlv_caps.vnic_stats_cnt; i++) {
+		if (!(i % 4))
+			id_word = readq(mem + i * 2);
+
+		id = (u16)id_word;
+		id_word >>= 16;
+
+		if (id < ARRAY_SIZE(nfp_tlv_stat_names) &&
+		    nfp_tlv_stat_names[id][0]) {
+			memcpy(data, nfp_tlv_stat_names[id], ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		} else {
+			data = nfp_pr_et(data, "dev_unknown_stat%u", id);
+		}
+	}
+
+	for (i = 0; i < nn->max_r_vecs; i++) {
+		data = nfp_pr_et(data, "rxq_%u_pkts", i);
+		data = nfp_pr_et(data, "rxq_%u_bytes", i);
+		data = nfp_pr_et(data, "txq_%u_pkts", i);
+		data = nfp_pr_et(data, "txq_%u_bytes", i);
+	}
+
+	return data;
+}
+
+static u64 *nfp_vnic_get_tlv_stats(struct nfp_net *nn, u64 *data)
+{
+	u8 __iomem *mem;
+	unsigned int i;
+
+	mem = nn->dp.ctrl_bar + nn->tlv_caps.vnic_stats_off;
+	mem += roundup(2 * nn->tlv_caps.vnic_stats_cnt, 8);
+	for (i = 0; i < nn->tlv_caps.vnic_stats_cnt; i++)
+		*data++ = readq(mem + i * 8);
+
+	mem = nn->dp.ctrl_bar;
+	for (i = 0; i < nn->max_r_vecs; i++) {
+		*data++ = readq(mem + NFP_NET_CFG_RXR_STATS(i));
+		*data++ = readq(mem + NFP_NET_CFG_RXR_STATS(i) + 8);
+		*data++ = readq(mem + NFP_NET_CFG_TXR_STATS(i));
+		*data++ = readq(mem + NFP_NET_CFG_TXR_STATS(i) + 8);
+	}
+
+	return data;
+}
+
 static unsigned int nfp_mac_get_stats_count(struct net_device *netdev)
 {
 	struct nfp_port *port;
@@ -609,8 +690,12 @@ static void nfp_net_get_strings(struct net_device *netdev,
 	switch (stringset) {
 	case ETH_SS_STATS:
 		data = nfp_vnic_get_sw_stats_strings(netdev, data);
-		data = nfp_vnic_get_hw_stats_strings(data, nn->max_r_vecs,
-						     false);
+		if (!nn->tlv_caps.vnic_stats_off)
+			data = nfp_vnic_get_hw_stats_strings(data,
+							     nn->max_r_vecs,
+							     false);
+		else
+			data = nfp_vnic_get_tlv_stats_strings(nn, data);
 		data = nfp_mac_get_stats_strings(netdev, data);
 		data = nfp_app_port_get_stats_strings(nn->port, data);
 		break;
@@ -624,7 +709,11 @@ nfp_net_get_stats(struct net_device *netdev, struct ethtool_stats *stats,
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	data = nfp_vnic_get_sw_stats(netdev, data);
-	data = nfp_vnic_get_hw_stats(data, nn->dp.ctrl_bar, nn->max_r_vecs);
+	if (!nn->tlv_caps.vnic_stats_off)
+		data = nfp_vnic_get_hw_stats(data, nn->dp.ctrl_bar,
+					     nn->max_r_vecs);
+	else
+		data = nfp_vnic_get_tlv_stats(nn, data);
 	data = nfp_mac_get_stats(netdev, data);
 	data = nfp_app_port_get_stats(nn->port, data);
 }
@@ -632,13 +721,18 @@ nfp_net_get_stats(struct net_device *netdev, struct ethtool_stats *stats,
 static int nfp_net_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
+	unsigned int cnt;
 
 	switch (sset) {
 	case ETH_SS_STATS:
-		return nfp_vnic_get_sw_stats_count(netdev) +
-		       nfp_vnic_get_hw_stats_count(nn->max_r_vecs) +
-		       nfp_mac_get_stats_count(netdev) +
-		       nfp_app_port_get_stats_count(nn->port);
+		cnt = nfp_vnic_get_sw_stats_count(netdev);
+		if (!nn->tlv_caps.vnic_stats_off)
+			cnt += nfp_vnic_get_hw_stats_count(nn->max_r_vecs);
+		else
+			cnt += nfp_vnic_get_tlv_stats_count(nn);
+		cnt += nfp_mac_get_stats_count(netdev);
+		cnt += nfp_app_port_get_stats_count(nn->port);
+		return cnt;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.23.0

