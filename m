Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354652795BD
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgIZA5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgIZA47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416BD23730;
        Sat, 26 Sep 2020 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081818;
        bh=djZuKYLnvGrmdxCtp3pNYuordHJ09kSVX1sh9qDA3lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIHZDa6tDs6aOnXgEgzU7qB3P5UQABNTP7tggduBVDH61dGfzF172Y5EhYMwm8pnx
         tZs8xyTLaSBRNrBr5UpPzcRblWx38ItVAM6D+FVqDY22FU/MjZ9m57WcPpS4hruFve
         0RxFvf/Uq+ZnCHYIwmPLsIQ7kbVlgMCbT8MO6Ow4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net-next v2 07/10] ice: convert to new udp_tunnel infrastructure
Date:   Fri, 25 Sep 2020 17:56:46 -0700
Message-Id: <20200926005649.3285089-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert ice to the new infra, use share port tables.

Leave a tiny bit more error checking in place than usual,
because this driver really does quite a bit of magic.

We need to calculate the number of VxLAN and GENEVE entries
the firmware has reserved.

Thanks to the conversion the driver will no longer sleep in
an atomic section.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 228 ++++++++----------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   8 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  97 +++-----
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 5 files changed, 135 insertions(+), 206 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index a90be061e552..ac448d223e9a 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -489,8 +489,6 @@ static void ice_init_pkg_hints(struct ice_hw *hw, struct ice_seg *ice_seg)
 			if ((label_name[len] - '0') == hw->pf_id) {
 				hw->tnl.tbl[hw->tnl.count].type = tnls[i].type;
 				hw->tnl.tbl[hw->tnl.count].valid = false;
-				hw->tnl.tbl[hw->tnl.count].in_use = false;
-				hw->tnl.tbl[hw->tnl.count].marked = false;
 				hw->tnl.tbl[hw->tnl.count].boost_addr = val;
 				hw->tnl.tbl[hw->tnl.count].port = 0;
 				hw->tnl.count++;
@@ -505,8 +503,11 @@ static void ice_init_pkg_hints(struct ice_hw *hw, struct ice_seg *ice_seg)
 	for (i = 0; i < hw->tnl.count; i++) {
 		ice_find_boost_entry(ice_seg, hw->tnl.tbl[i].boost_addr,
 				     &hw->tnl.tbl[i].boost_entry);
-		if (hw->tnl.tbl[i].boost_entry)
+		if (hw->tnl.tbl[i].boost_entry) {
 			hw->tnl.tbl[i].valid = true;
+			if (hw->tnl.tbl[i].type < __TNL_TYPE_CNT)
+				hw->tnl.valid_count[hw->tnl.tbl[i].type]++;
+		}
 	}
 }
 
@@ -1626,101 +1627,59 @@ static struct ice_buf *ice_pkg_buf(struct ice_buf_build *bld)
 }
 
 /**
- * ice_tunnel_port_in_use_hlpr - helper function to determine tunnel usage
+ * ice_get_open_tunnel_port - retrieve an open tunnel port
  * @hw: pointer to the HW structure
- * @port: port to search for
- * @index: optionally returns index
- *
- * Returns whether a port is already in use as a tunnel, and optionally its
- * index
+ * @port: returns open port
  */
-static bool ice_tunnel_port_in_use_hlpr(struct ice_hw *hw, u16 port, u16 *index)
+bool
+ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
 {
+	bool res = false;
 	u16 i;
 
+	mutex_lock(&hw->tnl_lock);
+
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].in_use && hw->tnl.tbl[i].port == port) {
-			if (index)
-				*index = i;
-			return true;
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].port) {
+			*port = hw->tnl.tbl[i].port;
+			res = true;
+			break;
 		}
 
-	return false;
-}
-
-/**
- * ice_tunnel_port_in_use
- * @hw: pointer to the HW structure
- * @port: port to search for
- * @index: optionally returns index
- *
- * Returns whether a port is already in use as a tunnel, and optionally its
- * index
- */
-bool ice_tunnel_port_in_use(struct ice_hw *hw, u16 port, u16 *index)
-{
-	bool res;
-
-	mutex_lock(&hw->tnl_lock);
-	res = ice_tunnel_port_in_use_hlpr(hw, port, index);
 	mutex_unlock(&hw->tnl_lock);
 
 	return res;
 }
 
 /**
- * ice_find_free_tunnel_entry
+ * ice_tunnel_idx_to_entry - convert linear index to the sparse one
  * @hw: pointer to the HW structure
- * @type: tunnel type
- * @index: optionally returns index
+ * @type: type of tunnel
+ * @idx: linear index
  *
- * Returns whether there is a free tunnel entry, and optionally its index
- */
-static bool
-ice_find_free_tunnel_entry(struct ice_hw *hw, enum ice_tunnel_type type,
-			   u16 *index)
-{
-	u16 i;
-
-	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && !hw->tnl.tbl[i].in_use &&
-		    hw->tnl.tbl[i].type == type) {
-			if (index)
-				*index = i;
-			return true;
-		}
-
-	return false;
-}
-
-/**
- * ice_get_open_tunnel_port - retrieve an open tunnel port
- * @hw: pointer to the HW structure
- * @port: returns open port
+ * Stack assumes we have 2 linear tables with indexes [0, count_valid),
+ * but really the port table may be sprase, and types are mixed, so convert
+ * the stack index into the device index.
  */
-bool
-ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
+static u16 ice_tunnel_idx_to_entry(struct ice_hw *hw, enum ice_tunnel_type type,
+				   u16 idx)
 {
-	bool res = false;
 	u16 i;
 
-	mutex_lock(&hw->tnl_lock);
-
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use) {
-			*port = hw->tnl.tbl[i].port;
-			res = true;
-			break;
-		}
-
-	mutex_unlock(&hw->tnl_lock);
+		if (hw->tnl.tbl[i].valid &&
+		    hw->tnl.tbl[i].type == type &&
+		    idx--)
+			return i;
 
-	return res;
+	WARN_ON_ONCE(1);
+	return 0;
 }
 
 /**
  * ice_create_tunnel
  * @hw: pointer to the HW structure
+ * @index: device table entry
  * @type: type of tunnel
  * @port: port of tunnel to create
  *
@@ -1728,27 +1687,16 @@ ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
  * creating a package buffer with the tunnel info and issuing an update package
  * command.
  */
-enum ice_status
-ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
+static enum ice_status
+ice_create_tunnel(struct ice_hw *hw, u16 index,
+		  enum ice_tunnel_type type, u16 port)
 {
 	struct ice_boost_tcam_section *sect_rx, *sect_tx;
 	enum ice_status status = ICE_ERR_MAX_LIMIT;
 	struct ice_buf_build *bld;
-	u16 index;
 
 	mutex_lock(&hw->tnl_lock);
 
-	if (ice_tunnel_port_in_use_hlpr(hw, port, &index)) {
-		hw->tnl.tbl[index].ref++;
-		status = 0;
-		goto ice_create_tunnel_end;
-	}
-
-	if (!ice_find_free_tunnel_entry(hw, type, &index)) {
-		status = ICE_ERR_OUT_OF_RANGE;
-		goto ice_create_tunnel_end;
-	}
-
 	bld = ice_pkg_buf_alloc(hw);
 	if (!bld) {
 		status = ICE_ERR_NO_MEMORY;
@@ -1787,11 +1735,8 @@ ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
 	memcpy(sect_tx->tcam, sect_rx->tcam, sizeof(*sect_tx->tcam));
 
 	status = ice_update_pkg(hw, ice_pkg_buf(bld), 1);
-	if (!status) {
+	if (!status)
 		hw->tnl.tbl[index].port = port;
-		hw->tnl.tbl[index].in_use = true;
-		hw->tnl.tbl[index].ref = 1;
-	}
 
 ice_create_tunnel_err:
 	ice_pkg_buf_free(hw, bld);
@@ -1805,46 +1750,31 @@ ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
 /**
  * ice_destroy_tunnel
  * @hw: pointer to the HW structure
+ * @index: device table entry
+ * @type: type of tunnel
  * @port: port of tunnel to destroy (ignored if the all parameter is true)
- * @all: flag that states to destroy all tunnels
  *
  * Destroys a tunnel or all tunnels by creating an update package buffer
  * targeting the specific updates requested and then performing an update
  * package.
  */
-enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
+static enum ice_status
+ice_destroy_tunnel(struct ice_hw *hw, u16 index, enum ice_tunnel_type type,
+		   u16 port)
 {
 	struct ice_boost_tcam_section *sect_rx, *sect_tx;
 	enum ice_status status = ICE_ERR_MAX_LIMIT;
 	struct ice_buf_build *bld;
-	u16 count = 0;
-	u16 index;
-	u16 size;
-	u16 i;
 
 	mutex_lock(&hw->tnl_lock);
 
-	if (!all && ice_tunnel_port_in_use_hlpr(hw, port, &index))
-		if (hw->tnl.tbl[index].ref > 1) {
-			hw->tnl.tbl[index].ref--;
-			status = 0;
-			goto ice_destroy_tunnel_end;
-		}
-
-	/* determine count */
-	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
-		    (all || hw->tnl.tbl[i].port == port))
-			count++;
-
-	if (!count) {
-		status = ICE_ERR_PARAM;
+	if (WARN_ON(!hw->tnl.tbl[index].valid ||
+		    hw->tnl.tbl[index].type != type ||
+		    hw->tnl.tbl[index].port != port)) {
+		status = ICE_ERR_OUT_OF_RANGE;
 		goto ice_destroy_tunnel_end;
 	}
 
-	/* size of section - there is at least one entry */
-	size = struct_size(sect_rx, tcam, count);
-
 	bld = ice_pkg_buf_alloc(hw);
 	if (!bld) {
 		status = ICE_ERR_NO_MEMORY;
@@ -1856,13 +1786,13 @@ enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
 		goto ice_destroy_tunnel_err;
 
 	sect_rx = ice_pkg_buf_alloc_section(bld, ICE_SID_RXPARSER_BOOST_TCAM,
-					    size);
+					    struct_size(sect_rx, tcam, 1));
 	if (!sect_rx)
 		goto ice_destroy_tunnel_err;
 	sect_rx->count = cpu_to_le16(1);
 
 	sect_tx = ice_pkg_buf_alloc_section(bld, ICE_SID_TXPARSER_BOOST_TCAM,
-					    size);
+					    struct_size(sect_tx, tcam, 1));
 	if (!sect_tx)
 		goto ice_destroy_tunnel_err;
 	sect_tx->count = cpu_to_le16(1);
@@ -1870,26 +1800,14 @@ enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
 	/* copy original boost entry to update package buffer, one copy to Rx
 	 * section, another copy to the Tx section
 	 */
-	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
-		    (all || hw->tnl.tbl[i].port == port)) {
-			memcpy(sect_rx->tcam + i, hw->tnl.tbl[i].boost_entry,
-			       sizeof(*sect_rx->tcam));
-			memcpy(sect_tx->tcam + i, hw->tnl.tbl[i].boost_entry,
-			       sizeof(*sect_tx->tcam));
-			hw->tnl.tbl[i].marked = true;
-		}
+	memcpy(sect_rx->tcam, hw->tnl.tbl[index].boost_entry,
+	       sizeof(*sect_rx->tcam));
+	memcpy(sect_tx->tcam, hw->tnl.tbl[index].boost_entry,
+	       sizeof(*sect_tx->tcam));
 
 	status = ice_update_pkg(hw, ice_pkg_buf(bld), 1);
 	if (!status)
-		for (i = 0; i < hw->tnl.count &&
-		     i < ICE_TUNNEL_MAX_ENTRIES; i++)
-			if (hw->tnl.tbl[i].marked) {
-				hw->tnl.tbl[i].ref = 0;
-				hw->tnl.tbl[i].port = 0;
-				hw->tnl.tbl[i].in_use = false;
-				hw->tnl.tbl[i].marked = false;
-			}
+		hw->tnl.tbl[index].port = 0;
 
 ice_destroy_tunnel_err:
 	ice_pkg_buf_free(hw, bld);
@@ -1900,6 +1818,52 @@ enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
 	return status;
 }
 
+int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
+			    unsigned int idx, struct udp_tunnel_info *ti)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	enum ice_tunnel_type tnl_type;
+	enum ice_status status;
+	u16 index;
+
+	tnl_type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? TNL_VXLAN : TNL_GENEVE;
+	index = ice_tunnel_idx_to_entry(&pf->hw, idx, tnl_type);
+
+	status = ice_create_tunnel(&pf->hw, index, tnl_type, ntohs(ti->port));
+	if (status) {
+		netdev_err(netdev, "Error adding UDP tunnel - %s\n",
+			   ice_stat_str(status));
+		return -EIO;
+	}
+
+	udp_tunnel_nic_set_port_priv(netdev, table, idx, index);
+	return 0;
+}
+
+int ice_udp_tunnel_unset_port(struct net_device *netdev, unsigned int table,
+			      unsigned int idx, struct udp_tunnel_info *ti)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	enum ice_tunnel_type tnl_type;
+	enum ice_status status;
+
+	tnl_type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? TNL_VXLAN : TNL_GENEVE;
+
+	status = ice_destroy_tunnel(&pf->hw, ti->hw_priv, tnl_type,
+				    ntohs(ti->port));
+	if (status) {
+		netdev_err(netdev, "Error removing UDP tunnel - %s\n",
+			   ice_stat_str(status));
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /* PTG Management */
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index a18c87d9d9b1..20deddb807c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -20,10 +20,10 @@
 
 bool
 ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port);
-enum ice_status
-ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port);
-enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all);
-bool ice_tunnel_port_in_use(struct ice_hw *hw, u16 port, u16 *index);
+int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
+			    unsigned int idx, struct udp_tunnel_info *ti);
+int ice_udp_tunnel_unset_port(struct net_device *netdev, unsigned int table,
+			      unsigned int idx, struct udp_tunnel_info *ti);
 
 enum ice_status
 ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index c1c99a267a98..24063c1351b2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -298,6 +298,7 @@ struct ice_pkg_enum {
 enum ice_tunnel_type {
 	TNL_VXLAN = 0,
 	TNL_GENEVE,
+	__TNL_TYPE_CNT,
 	TNL_LAST = 0xFF,
 	TNL_ALL = 0xFF,
 };
@@ -311,11 +312,8 @@ struct ice_tunnel_entry {
 	enum ice_tunnel_type type;
 	u16 boost_addr;
 	u16 port;
-	u16 ref;
 	struct ice_boost_tcam_entry *boost_entry;
 	u8 valid;
-	u8 in_use;
-	u8 marked;
 };
 
 #define ICE_TUNNEL_MAX_ENTRIES	16
@@ -323,6 +321,7 @@ struct ice_tunnel_entry {
 struct ice_tunnel_table {
 	struct ice_tunnel_entry tbl[ICE_TUNNEL_MAX_ENTRIES];
 	u16 count;
+	u16 valid_count[__TNL_TYPE_CNT];
 };
 
 struct ice_pkg_es {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2297ee7dba26..ffef4c901ea2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2873,6 +2873,7 @@ static void ice_set_ops(struct net_device *netdev)
 	}
 
 	netdev->netdev_ops = &ice_netdev_ops;
+	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
 	ice_set_ethtool_ops(netdev);
 }
 
@@ -3978,7 +3979,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	struct device *dev = &pdev->dev;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
-	int err;
+	int i, err;
 
 	/* this driver uses devres, see
 	 * Documentation/driver-api/driver-model/devres.rst
@@ -4073,11 +4074,37 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_devlink_init_regions(pf);
 
+	pf->hw.udp_tunnel_nic.set_port = ice_udp_tunnel_set_port;
+	pf->hw.udp_tunnel_nic.unset_port = ice_udp_tunnel_unset_port;
+	pf->hw.udp_tunnel_nic.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
+	pf->hw.udp_tunnel_nic.shared = &pf->hw.udp_tunnel_shared;
+	i = 0;
+	if (pf->hw.tnl.valid_count[TNL_VXLAN]) {
+		pf->hw.udp_tunnel_nic.tables[i].n_entries =
+			pf->hw.tnl.valid_count[TNL_VXLAN];
+		pf->hw.udp_tunnel_nic.tables[i].tunnel_types =
+			UDP_TUNNEL_TYPE_VXLAN;
+		i++;
+	}
+	if (pf->hw.tnl.valid_count[TNL_GENEVE]) {
+		pf->hw.udp_tunnel_nic.tables[i].n_entries =
+			pf->hw.tnl.valid_count[TNL_GENEVE];
+		pf->hw.udp_tunnel_nic.tables[i].tunnel_types =
+			UDP_TUNNEL_TYPE_GENEVE;
+		i++;
+	}
+
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
 		goto err_init_pf_unroll;
 	}
+	if (pf->num_alloc_vsi > UDP_TUNNEL_NIC_MAX_SHARING_DEVICES) {
+		dev_warn(&pf->pdev->dev,
+			 "limiting the VSI count due to UDP tunnel limitation %d > %d\n",
+			 pf->num_alloc_vsi, UDP_TUNNEL_NIC_MAX_SHARING_DEVICES);
+		pf->num_alloc_vsi = UDP_TUNNEL_NIC_MAX_SHARING_DEVICES;
+	}
 
 	pf->vsi = devm_kcalloc(dev, pf->num_alloc_vsi, sizeof(*pf->vsi),
 			       GFP_KERNEL);
@@ -6574,70 +6601,6 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	pf->tx_timeout_recovery_level++;
 }
 
-/**
- * ice_udp_tunnel_add - Get notifications about UDP tunnel ports that come up
- * @netdev: This physical port's netdev
- * @ti: Tunnel endpoint information
- */
-static void
-ice_udp_tunnel_add(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
-	enum ice_tunnel_type tnl_type;
-	u16 port = ntohs(ti->port);
-	enum ice_status status;
-
-	switch (ti->type) {
-	case UDP_TUNNEL_TYPE_VXLAN:
-		tnl_type = TNL_VXLAN;
-		break;
-	case UDP_TUNNEL_TYPE_GENEVE:
-		tnl_type = TNL_GENEVE;
-		break;
-	default:
-		netdev_err(netdev, "Unknown tunnel type\n");
-		return;
-	}
-
-	status = ice_create_tunnel(&pf->hw, tnl_type, port);
-	if (status == ICE_ERR_OUT_OF_RANGE)
-		netdev_info(netdev, "Max tunneled UDP ports reached, port %d not added\n",
-			    port);
-	else if (status)
-		netdev_err(netdev, "Error adding UDP tunnel - %s\n",
-			   ice_stat_str(status));
-}
-
-/**
- * ice_udp_tunnel_del - Get notifications about UDP tunnel ports that go away
- * @netdev: This physical port's netdev
- * @ti: Tunnel endpoint information
- */
-static void
-ice_udp_tunnel_del(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
-	u16 port = ntohs(ti->port);
-	enum ice_status status;
-	bool retval;
-
-	retval = ice_tunnel_port_in_use(&pf->hw, port, NULL);
-	if (!retval) {
-		netdev_info(netdev, "port %d not found in UDP tunnels list\n",
-			    port);
-		return;
-	}
-
-	status = ice_destroy_tunnel(&pf->hw, port, false);
-	if (status)
-		netdev_err(netdev, "error deleting port %d from UDP tunnels list\n",
-			   port);
-}
-
 /**
  * ice_open - Called when a network interface becomes active
  * @netdev: network interface device structure
@@ -6830,6 +6793,6 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
-	.ndo_udp_tunnel_add = ice_udp_tunnel_add,
-	.ndo_udp_tunnel_del = ice_udp_tunnel_del,
+	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4cdccfadf274..2226a291a394 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -676,6 +676,9 @@ struct ice_hw {
 	struct mutex tnl_lock;
 	struct ice_tunnel_table tnl;
 
+	struct udp_tunnel_nic_shared udp_tunnel_shared;
+	struct udp_tunnel_nic_info udp_tunnel_nic;
+
 	/* HW block tables */
 	struct ice_blk_info blk[ICE_BLK_COUNT];
 	struct mutex fl_profs_locks[ICE_BLK_COUNT];	/* lock fltr profiles */
-- 
2.26.2

