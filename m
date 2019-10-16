Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD46DA26D
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406882AbfJPXrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:47:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:41139 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406803AbfJPXrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 19:47:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 16:47:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="202220678"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Oct 2019 16:47:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Robert Beckett <bob.beckett@collabora.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/7] igb: add rx drop enable attribute
Date:   Wed, 16 Oct 2019 16:47:06 -0700
Message-Id: <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

To allow userland to enable or disable dropping packets when descriptor
ring is exhausted, add RX_DROP_EN private flag.

This can be used in conjunction with flow control to mitigate packet storms
(e.g. due to network loop or DoS) by forcing the network adapter to send
pause frames whenever the ring is close to exhaustion.

By default this will maintain previous behaviour of enabling dropping of
packets during ring buffer exhaustion.
Some use cases prefer to not drop packets upon exhaustion, but instead
use flow control to limit ingress rates and ensure no dropped packets.
This is useful when the host CPU cannot keep up with packet delivery,
but data delivery is more important than throughput via multiple queues.

Userland can set this flag to 0 via ethtool to disable packet dropping.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h         |  1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  8 ++++++++
 drivers/net/ethernet/intel/igb/igb_main.c    | 11 +++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index ca54e268d157..ff4a61218e3e 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -617,6 +617,7 @@ struct igb_adapter {
 #define IGB_FLAG_VLAN_PROMISC		BIT(15)
 #define IGB_FLAG_RX_LEGACY		BIT(16)
 #define IGB_FLAG_FQTSS			BIT(17)
+#define IGB_FLAG_RX_DROP_EN		BIT(18)
 
 /* Media Auto Sense */
 #define IGB_MAS_ENABLE_0		0X0001
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 3182b059bf55..b584fa1f0e14 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -128,6 +128,8 @@ static const char igb_gstrings_test[][ETH_GSTRING_LEN] = {
 static const char igb_priv_flags_strings[][ETH_GSTRING_LEN] = {
 #define IGB_PRIV_FLAGS_LEGACY_RX	BIT(0)
 	"legacy-rx",
+#define IGB_PRIV_FLAGS_RX_DROP_EN	BIT(1)
+	"rx-drop-en",
 };
 
 #define IGB_PRIV_FLAGS_STR_LEN ARRAY_SIZE(igb_priv_flags_strings)
@@ -3444,6 +3446,8 @@ static u32 igb_get_priv_flags(struct net_device *netdev)
 
 	if (adapter->flags & IGB_FLAG_RX_LEGACY)
 		priv_flags |= IGB_PRIV_FLAGS_LEGACY_RX;
+	if (adapter->flags & IGB_FLAG_RX_DROP_EN)
+		priv_flags |= IGB_PRIV_FLAGS_RX_DROP_EN;
 
 	return priv_flags;
 }
@@ -3457,6 +3461,10 @@ static int igb_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	if (priv_flags & IGB_PRIV_FLAGS_LEGACY_RX)
 		flags |= IGB_FLAG_RX_LEGACY;
 
+	flags &= ~IGB_FLAG_RX_DROP_EN;
+	if (priv_flags & IGB_PRIV_FLAGS_RX_DROP_EN)
+		flags |= IGB_FLAG_RX_DROP_EN;
+
 	if (flags != adapter->flags) {
 		adapter->flags = flags;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 31b9e02875cc..5dae45bb3578 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3237,6 +3237,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	igb_validate_mdi_setting(hw);
 
+	/* By default, support dropping packets due to ring exhaustion */
+	adapter->flags |= IGB_FLAG_RX_DROP_EN;
+
 	/* By default, support wake on port A */
 	if (hw->bus.func == 0)
 		adapter->flags |= IGB_FLAG_WOL_SUPPORTED;
@@ -4504,8 +4507,12 @@ void igb_configure_rx_ring(struct igb_adapter *adapter,
 	srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
 	if (hw->mac.type >= e1000_82580)
 		srrctl |= E1000_SRRCTL_TIMESTAMP;
-	/* Only set Drop Enable if we are supporting multiple queues */
-	if (adapter->vfs_allocated_count || adapter->num_rx_queues > 1)
+	/*
+	 * Only set Drop Enable if we are supporting multiple queues and
+	 * allowed by flags
+	 */
+	if ((adapter->flags & IGB_FLAG_RX_DROP_EN) &&
+		(adapter->vfs_allocated_count || adapter->num_rx_queues > 1))
 		srrctl |= E1000_SRRCTL_DROP_EN;
 
 	wr32(E1000_SRRCTL(reg_idx), srrctl);
-- 
2.21.0

