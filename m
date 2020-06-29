Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0BD20D33B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgF2S4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:56:54 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:16510 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729537AbgF2S4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:56:52 -0400
Received: from localhost ([10.193.187.21])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05TBtGTP010730;
        Mon, 29 Jun 2020 04:55:17 -0700
From:   Nirranjan Kirubaharan <nirranjan@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next] cxgb4vf: configure ports accessible by the VF
Date:   Mon, 29 Jun 2020 17:25:13 +0530
Message-Id: <20200629115513.537757-1-nirranjan@chelsio.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find ports accessible by the VF, based on the index of the
mac address stored for the VF in the adapter. If no mac address
is stored for the VF, use the port mask provided by firmware.

Signed-off-by: Nirranjan Kirubaharan <nirranjan@chelsio.com>
---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 47 +++++++++++++++----
 .../ethernet/chelsio/cxgb4vf/t4vf_common.h    |  2 +-
 .../net/ethernet/chelsio/cxgb4vf/t4vf_hw.c    |  6 +--
 3 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index a7641be9094f..dbe8ee7e0e21 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2916,6 +2916,39 @@ static const struct net_device_ops cxgb4vf_netdev_ops	= {
 #endif
 };
 
+/**
+ *	cxgb4vf_get_port_mask - Get port mask for the VF based on mac
+ *				address stored on the adapter
+ *	@adapter: The adapter
+ *
+ *	Find the the port mask for the VF based on the index of mac
+ *	address stored in the adapter. If no mac address is stored on
+ *	the adapter for the VF, use the port mask received from the
+ *	firmware.
+ */
+static unsigned int cxgb4vf_get_port_mask(struct adapter *adapter)
+{
+	unsigned int naddr = 1, pidx = 0;
+	unsigned int pmask, rmask = 0;
+	u8 mac[ETH_ALEN];
+	int err;
+
+	pmask = adapter->params.vfres.pmask;
+	while (pmask) {
+		if (pmask & 1) {
+			err = t4vf_get_vf_mac_acl(adapter, pidx, &naddr, mac);
+			if (!err && !is_zero_ether_addr(mac))
+				rmask |= (1 << pidx);
+		}
+		pmask >>= 1;
+		pidx++;
+	}
+	if (!rmask)
+		rmask = adapter->params.vfres.pmask;
+
+	return rmask;
+}
+
 /*
  * "Probe" a device: initialize a device and construct all kernel and driver
  * state needed to manage the device.  This routine is called "init_one" in
@@ -2924,13 +2957,12 @@ static const struct net_device_ops cxgb4vf_netdev_ops	= {
 static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *ent)
 {
-	int pci_using_dac;
-	int err, pidx;
-	unsigned int pmask;
 	struct adapter *adapter;
-	struct port_info *pi;
 	struct net_device *netdev;
-	unsigned int pf;
+	struct port_info *pi;
+	unsigned int pmask;
+	int pci_using_dac;
+	int err, pidx;
 
 	/*
 	 * Initialize generic PCI device state.
@@ -3073,8 +3105,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 	/*
 	 * Allocate our "adapter ports" and stitch everything together.
 	 */
-	pmask = adapter->params.vfres.pmask;
-	pf = t4vf_get_pf_from_vf(adapter);
+	pmask = cxgb4vf_get_port_mask(adapter);
 	for_each_port(adapter, pidx) {
 		int port_id, viid;
 		u8 mac[ETH_ALEN];
@@ -3157,7 +3188,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 			goto err_free_dev;
 		}
 
-		err = t4vf_get_vf_mac_acl(adapter, pf, &naddr, mac);
+		err = t4vf_get_vf_mac_acl(adapter, port_id, &naddr, mac);
 		if (err) {
 			dev_err(&pdev->dev,
 				"unable to determine MAC ACL address, "
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
index 57cfd10a99ec..03777145efec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
@@ -415,7 +415,7 @@ int t4vf_eth_eq_free(struct adapter *, unsigned int);
 int t4vf_update_port_info(struct port_info *pi);
 int t4vf_handle_fw_rpl(struct adapter *, const __be64 *);
 int t4vf_prep_adapter(struct adapter *);
-int t4vf_get_vf_mac_acl(struct adapter *adapter, unsigned int pf,
+int t4vf_get_vf_mac_acl(struct adapter *adapter, unsigned int port,
 			unsigned int *naddr, u8 *addr);
 int t4vf_get_vf_vlan_acl(struct adapter *adapter);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index a31b87390b50..cd8f9a481d73 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -2187,14 +2187,14 @@ int t4vf_prep_adapter(struct adapter *adapter)
  *	t4vf_get_vf_mac_acl - Get the MAC address to be set to
  *			      the VI of this VF.
  *	@adapter: The adapter
- *	@pf: The pf associated with vf
+ *	@port: The port associated with vf
  *	@naddr: the number of ACL MAC addresses returned in addr
  *	@addr: Placeholder for MAC addresses
  *
  *	Find the MAC address to be set to the VF's VI. The requested MAC address
  *	is from the host OS via callback in the PF driver.
  */
-int t4vf_get_vf_mac_acl(struct adapter *adapter, unsigned int pf,
+int t4vf_get_vf_mac_acl(struct adapter *adapter, unsigned int port,
 			unsigned int *naddr, u8 *addr)
 {
 	struct fw_acl_mac_cmd cmd;
@@ -2212,7 +2212,7 @@ int t4vf_get_vf_mac_acl(struct adapter *adapter, unsigned int pf,
 	if (cmd.nmac < *naddr)
 		*naddr = cmd.nmac;
 
-	switch (pf) {
+	switch (port) {
 	case 3:
 		memcpy(addr, cmd.macaddr3, sizeof(cmd.macaddr3));
 		break;
-- 
2.26.2

