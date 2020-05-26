Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E91DE03C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEVG4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:18660 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgEVG4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:11 -0400
IronPort-SDR: gRPeC0BOFcvkB2gEgcpCCKIsXgwHEmnZooQHbaVP7yxeeFy3CPgXllhPHM8rFUEiFExB701CMj
 WlNwM/SjGnbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:09 -0700
IronPort-SDR: HD0lBP/hj/NO1MHwY+UhjSPdU8gmfPeMZekHyfu4zZnaY9h/+40jYgnzJ1C9ufrChwx+hWmN+v
 3EvUtwx7L5mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017739"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/17] ice: Add support for tunnel offloads
Date:   Thu, 21 May 2020 23:55:52 -0700
Message-Id: <20200522065607.1680050-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Create a boost TCAM entry for each tunnel port in order to get a tunnel
PTYPE. Update netdev feature flags and implement the appropriate logic to
get and set values for hardware offloads.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 524 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   5 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  33 ++
 drivers/net/ethernet/intel/ice/ice_flow.c     |  36 +-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   3 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  25 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  94 +++-
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 126 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  21 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +
 14 files changed, 867 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5c11448bfbb3..43349eaa02b2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -37,6 +37,10 @@
 #include <net/devlink.h>
 #include <net/ipv6.h>
 #include <net/xdp_sock.h>
+#include <net/geneve.h>
+#include <net/gre.h>
+#include <net/udp_tunnel.h>
+#include <net/vxlan.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2c0d8fd3d5cd..1a613199d6cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -746,6 +746,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	status = ice_init_hw_tbls(hw);
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
+	mutex_init(&hw->tnl_lock);
 	return 0;
 
 err_unroll_fltr_mgmt_struct:
@@ -775,6 +776,7 @@ void ice_deinit_hw(struct ice_hw *hw)
 	ice_sched_clear_agg(hw);
 	ice_free_seg(hw);
 	ice_free_hw_tbls(hw);
+	mutex_destroy(&hw->tnl_lock);
 
 	if (hw->port_info) {
 		devm_kfree(ice_hw_to_dev(hw), hw->port_info);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index e7a2671222d2..62e305511c7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -5,6 +5,15 @@
 #include "ice_flex_pipe.h"
 #include "ice_flow.h"
 
+/* To support tunneling entries by PF, the package will append the PF number to
+ * the label; for example TNL_VXLAN_PF0, TNL_VXLAN_PF1, TNL_VXLAN_PF2, etc.
+ */
+static const struct ice_tunnel_type_scan tnls[] = {
+	{ TNL_VXLAN,		"TNL_VXLAN_PF" },
+	{ TNL_GENEVE,		"TNL_GENEVE_PF" },
+	{ TNL_LAST,		"" }
+};
+
 static const u32 ice_sect_lkup[ICE_BLK_COUNT][ICE_SECT_COUNT] = {
 	/* SWITCH */
 	{
@@ -239,6 +248,268 @@ ice_pkg_enum_section(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
 	return state->sect;
 }
 
+/**
+ * ice_pkg_enum_entry
+ * @ice_seg: pointer to the ice segment (or NULL on subsequent calls)
+ * @state: pointer to the enum state
+ * @sect_type: section type to enumerate
+ * @offset: pointer to variable that receives the offset in the table (optional)
+ * @handler: function that handles access to the entries into the section type
+ *
+ * This function will enumerate all the entries in particular section type in
+ * the ice segment. The first call is made with the ice_seg parameter non-NULL;
+ * on subsequent calls, ice_seg is set to NULL which continues the enumeration.
+ * When the function returns a NULL pointer, then the end of the entries has
+ * been reached.
+ *
+ * Since each section may have a different header and entry size, the handler
+ * function is needed to determine the number and location entries in each
+ * section.
+ *
+ * The offset parameter is optional, but should be used for sections that
+ * contain an offset for each section table. For such cases, the section handler
+ * function must return the appropriate offset + index to give the absolution
+ * offset for each entry. For example, if the base for a section's header
+ * indicates a base offset of 10, and the index for the entry is 2, then
+ * section handler function should set the offset to 10 + 2 = 12.
+ */
+static void *
+ice_pkg_enum_entry(struct ice_seg *ice_seg, struct ice_pkg_enum *state,
+		   u32 sect_type, u32 *offset,
+		   void *(*handler)(u32 sect_type, void *section,
+				    u32 index, u32 *offset))
+{
+	void *entry;
+
+	if (ice_seg) {
+		if (!handler)
+			return NULL;
+
+		if (!ice_pkg_enum_section(ice_seg, state, sect_type))
+			return NULL;
+
+		state->entry_idx = 0;
+		state->handler = handler;
+	} else {
+		state->entry_idx++;
+	}
+
+	if (!state->handler)
+		return NULL;
+
+	/* get entry */
+	entry = state->handler(state->sect_type, state->sect, state->entry_idx,
+			       offset);
+	if (!entry) {
+		/* end of a section, look for another section of this type */
+		if (!ice_pkg_enum_section(NULL, state, 0))
+			return NULL;
+
+		state->entry_idx = 0;
+		entry = state->handler(state->sect_type, state->sect,
+				       state->entry_idx, offset);
+	}
+
+	return entry;
+}
+
+/**
+ * ice_boost_tcam_handler
+ * @sect_type: section type
+ * @section: pointer to section
+ * @index: index of the boost TCAM entry to be returned
+ * @offset: pointer to receive absolute offset, always 0 for boost TCAM sections
+ *
+ * This is a callback function that can be passed to ice_pkg_enum_entry.
+ * Handles enumeration of individual boost TCAM entries.
+ */
+static void *
+ice_boost_tcam_handler(u32 sect_type, void *section, u32 index, u32 *offset)
+{
+	struct ice_boost_tcam_section *boost;
+
+	if (!section)
+		return NULL;
+
+	if (sect_type != ICE_SID_RXPARSER_BOOST_TCAM)
+		return NULL;
+
+	if (index > ICE_MAX_BST_TCAMS_IN_BUF)
+		return NULL;
+
+	if (offset)
+		*offset = 0;
+
+	boost = section;
+	if (index >= le16_to_cpu(boost->count))
+		return NULL;
+
+	return boost->tcam + index;
+}
+
+/**
+ * ice_find_boost_entry
+ * @ice_seg: pointer to the ice segment (non-NULL)
+ * @addr: Boost TCAM address of entry to search for
+ * @entry: returns pointer to the entry
+ *
+ * Finds a particular Boost TCAM entry and returns a pointer to that entry
+ * if it is found. The ice_seg parameter must not be NULL since the first call
+ * to ice_pkg_enum_entry requires a pointer to an actual ice_segment structure.
+ */
+static enum ice_status
+ice_find_boost_entry(struct ice_seg *ice_seg, u16 addr,
+		     struct ice_boost_tcam_entry **entry)
+{
+	struct ice_boost_tcam_entry *tcam;
+	struct ice_pkg_enum state;
+
+	memset(&state, 0, sizeof(state));
+
+	if (!ice_seg)
+		return ICE_ERR_PARAM;
+
+	do {
+		tcam = ice_pkg_enum_entry(ice_seg, &state,
+					  ICE_SID_RXPARSER_BOOST_TCAM, NULL,
+					  ice_boost_tcam_handler);
+		if (tcam && le16_to_cpu(tcam->addr) == addr) {
+			*entry = tcam;
+			return 0;
+		}
+
+		ice_seg = NULL;
+	} while (tcam);
+
+	*entry = NULL;
+	return ICE_ERR_CFG;
+}
+
+/**
+ * ice_label_enum_handler
+ * @sect_type: section type
+ * @section: pointer to section
+ * @index: index of the label entry to be returned
+ * @offset: pointer to receive absolute offset, always zero for label sections
+ *
+ * This is a callback function that can be passed to ice_pkg_enum_entry.
+ * Handles enumeration of individual label entries.
+ */
+static void *
+ice_label_enum_handler(u32 __always_unused sect_type, void *section, u32 index,
+		       u32 *offset)
+{
+	struct ice_label_section *labels;
+
+	if (!section)
+		return NULL;
+
+	if (index > ICE_MAX_LABELS_IN_BUF)
+		return NULL;
+
+	if (offset)
+		*offset = 0;
+
+	labels = section;
+	if (index >= le16_to_cpu(labels->count))
+		return NULL;
+
+	return labels->label + index;
+}
+
+/**
+ * ice_enum_labels
+ * @ice_seg: pointer to the ice segment (NULL on subsequent calls)
+ * @type: the section type that will contain the label (0 on subsequent calls)
+ * @state: ice_pkg_enum structure that will hold the state of the enumeration
+ * @value: pointer to a value that will return the label's value if found
+ *
+ * Enumerates a list of labels in the package. The caller will call
+ * ice_enum_labels(ice_seg, type, ...) to start the enumeration, then call
+ * ice_enum_labels(NULL, 0, ...) to continue. When the function returns a NULL
+ * the end of the list has been reached.
+ */
+static char *
+ice_enum_labels(struct ice_seg *ice_seg, u32 type, struct ice_pkg_enum *state,
+		u16 *value)
+{
+	struct ice_label *label;
+
+	/* Check for valid label section on first call */
+	if (type && !(type >= ICE_SID_LBL_FIRST && type <= ICE_SID_LBL_LAST))
+		return NULL;
+
+	label = ice_pkg_enum_entry(ice_seg, state, type, NULL,
+				   ice_label_enum_handler);
+	if (!label)
+		return NULL;
+
+	*value = le16_to_cpu(label->value);
+	return label->name;
+}
+
+/**
+ * ice_init_pkg_hints
+ * @hw: pointer to the HW structure
+ * @ice_seg: pointer to the segment of the package scan (non-NULL)
+ *
+ * This function will scan the package and save off relevant information
+ * (hints or metadata) for driver use. The ice_seg parameter must not be NULL
+ * since the first call to ice_enum_labels requires a pointer to an actual
+ * ice_seg structure.
+ */
+static void ice_init_pkg_hints(struct ice_hw *hw, struct ice_seg *ice_seg)
+{
+	struct ice_pkg_enum state;
+	char *label_name;
+	u16 val;
+	int i;
+
+	memset(&hw->tnl, 0, sizeof(hw->tnl));
+	memset(&state, 0, sizeof(state));
+
+	if (!ice_seg)
+		return;
+
+	label_name = ice_enum_labels(ice_seg, ICE_SID_LBL_RXPARSER_TMEM, &state,
+				     &val);
+
+	while (label_name && hw->tnl.count < ICE_TUNNEL_MAX_ENTRIES) {
+		for (i = 0; tnls[i].type != TNL_LAST; i++) {
+			size_t len = strlen(tnls[i].label_prefix);
+
+			/* Look for matching label start, before continuing */
+			if (strncmp(label_name, tnls[i].label_prefix, len))
+				continue;
+
+			/* Make sure this label matches our PF. Note that the PF
+			 * character ('0' - '7') will be located where our
+			 * prefix string's null terminator is located.
+			 */
+			if ((label_name[len] - '0') == hw->pf_id) {
+				hw->tnl.tbl[hw->tnl.count].type = tnls[i].type;
+				hw->tnl.tbl[hw->tnl.count].valid = false;
+				hw->tnl.tbl[hw->tnl.count].in_use = false;
+				hw->tnl.tbl[hw->tnl.count].marked = false;
+				hw->tnl.tbl[hw->tnl.count].boost_addr = val;
+				hw->tnl.tbl[hw->tnl.count].port = 0;
+				hw->tnl.count++;
+				break;
+			}
+		}
+
+		label_name = ice_enum_labels(NULL, 0, &state, &val);
+	}
+
+	/* Cache the appropriate boost TCAM entry pointers */
+	for (i = 0; i < hw->tnl.count; i++) {
+		ice_find_boost_entry(ice_seg, hw->tnl.tbl[i].boost_addr,
+				     &hw->tnl.tbl[i].boost_entry);
+		if (hw->tnl.tbl[i].boost_entry)
+			hw->tnl.tbl[i].valid = true;
+	}
+}
+
 /* Key creation */
 
 #define ICE_DC_KEY	0x1	/* don't care */
@@ -1050,7 +1321,8 @@ enum ice_status ice_init_pkg(struct ice_hw *hw, u8 *buf, u32 len)
 		return ICE_ERR_CFG;
 	}
 
-	/* download package */
+	/* initialize package hints and then download package */
+	ice_init_pkg_hints(hw, seg);
 	status = ice_download_pkg(hw, seg);
 	if (status == ICE_ERR_AQ_NO_WORK) {
 		ice_debug(hw, ICE_DBG_INIT,
@@ -1292,6 +1564,256 @@ static struct ice_buf *ice_pkg_buf(struct ice_buf_build *bld)
 	return &bld->buf;
 }
 
+/**
+ * ice_tunnel_port_in_use_hlpr - helper function to determine tunnel usage
+ * @hw: pointer to the HW structure
+ * @port: port to search for
+ * @index: optionally returns index
+ *
+ * Returns whether a port is already in use as a tunnel, and optionally its
+ * index
+ */
+static bool ice_tunnel_port_in_use_hlpr(struct ice_hw *hw, u16 port, u16 *index)
+{
+	u16 i;
+
+	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
+		if (hw->tnl.tbl[i].in_use && hw->tnl.tbl[i].port == port) {
+			if (index)
+				*index = i;
+			return true;
+		}
+
+	return false;
+}
+
+/**
+ * ice_tunnel_port_in_use
+ * @hw: pointer to the HW structure
+ * @port: port to search for
+ * @index: optionally returns index
+ *
+ * Returns whether a port is already in use as a tunnel, and optionally its
+ * index
+ */
+bool ice_tunnel_port_in_use(struct ice_hw *hw, u16 port, u16 *index)
+{
+	bool res;
+
+	mutex_lock(&hw->tnl_lock);
+	res = ice_tunnel_port_in_use_hlpr(hw, port, index);
+	mutex_unlock(&hw->tnl_lock);
+
+	return res;
+}
+
+/**
+ * ice_find_free_tunnel_entry
+ * @hw: pointer to the HW structure
+ * @type: tunnel type
+ * @index: optionally returns index
+ *
+ * Returns whether there is a free tunnel entry, and optionally its index
+ */
+static bool
+ice_find_free_tunnel_entry(struct ice_hw *hw, enum ice_tunnel_type type,
+			   u16 *index)
+{
+	u16 i;
+
+	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
+		if (hw->tnl.tbl[i].valid && !hw->tnl.tbl[i].in_use &&
+		    hw->tnl.tbl[i].type == type) {
+			if (index)
+				*index = i;
+			return true;
+		}
+
+	return false;
+}
+
+/**
+ * ice_create_tunnel
+ * @hw: pointer to the HW structure
+ * @type: type of tunnel
+ * @port: port of tunnel to create
+ *
+ * Create a tunnel by updating the parse graph in the parser. We do that by
+ * creating a package buffer with the tunnel info and issuing an update package
+ * command.
+ */
+enum ice_status
+ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
+{
+	struct ice_boost_tcam_section *sect_rx, *sect_tx;
+	enum ice_status status = ICE_ERR_MAX_LIMIT;
+	struct ice_buf_build *bld;
+	u16 index;
+
+	mutex_lock(&hw->tnl_lock);
+
+	if (ice_tunnel_port_in_use_hlpr(hw, port, &index)) {
+		hw->tnl.tbl[index].ref++;
+		status = 0;
+		goto ice_create_tunnel_end;
+	}
+
+	if (!ice_find_free_tunnel_entry(hw, type, &index)) {
+		status = ICE_ERR_OUT_OF_RANGE;
+		goto ice_create_tunnel_end;
+	}
+
+	bld = ice_pkg_buf_alloc(hw);
+	if (!bld) {
+		status = ICE_ERR_NO_MEMORY;
+		goto ice_create_tunnel_end;
+	}
+
+	/* allocate 2 sections, one for Rx parser, one for Tx parser */
+	if (ice_pkg_buf_reserve_section(bld, 2))
+		goto ice_create_tunnel_err;
+
+	sect_rx = ice_pkg_buf_alloc_section(bld, ICE_SID_RXPARSER_BOOST_TCAM,
+					    sizeof(*sect_rx));
+	if (!sect_rx)
+		goto ice_create_tunnel_err;
+	sect_rx->count = cpu_to_le16(1);
+
+	sect_tx = ice_pkg_buf_alloc_section(bld, ICE_SID_TXPARSER_BOOST_TCAM,
+					    sizeof(*sect_tx));
+	if (!sect_tx)
+		goto ice_create_tunnel_err;
+	sect_tx->count = cpu_to_le16(1);
+
+	/* copy original boost entry to update package buffer */
+	memcpy(sect_rx->tcam, hw->tnl.tbl[index].boost_entry,
+	       sizeof(*sect_rx->tcam));
+
+	/* over-write the never-match dest port key bits with the encoded port
+	 * bits
+	 */
+	ice_set_key((u8 *)&sect_rx->tcam[0].key, sizeof(sect_rx->tcam[0].key),
+		    (u8 *)&port, NULL, NULL, NULL,
+		    offsetof(struct ice_boost_key_value, hv_dst_port_key),
+		    sizeof(sect_rx->tcam[0].key.key.hv_dst_port_key));
+
+	/* exact copy of entry to Tx section entry */
+	memcpy(sect_tx->tcam, sect_rx->tcam, sizeof(*sect_tx->tcam));
+
+	status = ice_update_pkg(hw, ice_pkg_buf(bld), 1);
+	if (!status) {
+		hw->tnl.tbl[index].port = port;
+		hw->tnl.tbl[index].in_use = true;
+		hw->tnl.tbl[index].ref = 1;
+	}
+
+ice_create_tunnel_err:
+	ice_pkg_buf_free(hw, bld);
+
+ice_create_tunnel_end:
+	mutex_unlock(&hw->tnl_lock);
+
+	return status;
+}
+
+/**
+ * ice_destroy_tunnel
+ * @hw: pointer to the HW structure
+ * @port: port of tunnel to destroy (ignored if the all parameter is true)
+ * @all: flag that states to destroy all tunnels
+ *
+ * Destroys a tunnel or all tunnels by creating an update package buffer
+ * targeting the specific updates requested and then performing an update
+ * package.
+ */
+enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all)
+{
+	struct ice_boost_tcam_section *sect_rx, *sect_tx;
+	enum ice_status status = ICE_ERR_MAX_LIMIT;
+	struct ice_buf_build *bld;
+	u16 count = 0;
+	u16 index;
+	u16 size;
+	u16 i;
+
+	mutex_lock(&hw->tnl_lock);
+
+	if (!all && ice_tunnel_port_in_use_hlpr(hw, port, &index))
+		if (hw->tnl.tbl[index].ref > 1) {
+			hw->tnl.tbl[index].ref--;
+			status = 0;
+			goto ice_destroy_tunnel_end;
+		}
+
+	/* determine count */
+	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
+		    (all || hw->tnl.tbl[i].port == port))
+			count++;
+
+	if (!count) {
+		status = ICE_ERR_PARAM;
+		goto ice_destroy_tunnel_end;
+	}
+
+	/* size of section - there is at least one entry */
+	size = struct_size(sect_rx, tcam, count - 1);
+
+	bld = ice_pkg_buf_alloc(hw);
+	if (!bld) {
+		status = ICE_ERR_NO_MEMORY;
+		goto ice_destroy_tunnel_end;
+	}
+
+	/* allocate 2 sections, one for Rx parser, one for Tx parser */
+	if (ice_pkg_buf_reserve_section(bld, 2))
+		goto ice_destroy_tunnel_err;
+
+	sect_rx = ice_pkg_buf_alloc_section(bld, ICE_SID_RXPARSER_BOOST_TCAM,
+					    size);
+	if (!sect_rx)
+		goto ice_destroy_tunnel_err;
+	sect_rx->count = cpu_to_le16(1);
+
+	sect_tx = ice_pkg_buf_alloc_section(bld, ICE_SID_TXPARSER_BOOST_TCAM,
+					    size);
+	if (!sect_tx)
+		goto ice_destroy_tunnel_err;
+	sect_tx->count = cpu_to_le16(1);
+
+	/* copy original boost entry to update package buffer, one copy to Rx
+	 * section, another copy to the Tx section
+	 */
+	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
+		    (all || hw->tnl.tbl[i].port == port)) {
+			memcpy(sect_rx->tcam + i, hw->tnl.tbl[i].boost_entry,
+			       sizeof(*sect_rx->tcam));
+			memcpy(sect_tx->tcam + i, hw->tnl.tbl[i].boost_entry,
+			       sizeof(*sect_tx->tcam));
+			hw->tnl.tbl[i].marked = true;
+		}
+
+	status = ice_update_pkg(hw, ice_pkg_buf(bld), 1);
+	if (!status)
+		for (i = 0; i < hw->tnl.count &&
+		     i < ICE_TUNNEL_MAX_ENTRIES; i++)
+			if (hw->tnl.tbl[i].marked) {
+				hw->tnl.tbl[i].ref = 0;
+				hw->tnl.tbl[i].port = 0;
+				hw->tnl.tbl[i].in_use = false;
+				hw->tnl.tbl[i].marked = false;
+			}
+
+ice_destroy_tunnel_err:
+	ice_pkg_buf_free(hw, bld);
+
+ice_destroy_tunnel_end:
+	mutex_unlock(&hw->tnl_lock);
+
+	return status;
+}
+
 /* PTG Management */
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index c7b5e1a6ea2b..70db213c9fe3 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -18,6 +18,11 @@
 
 #define ICE_PKG_CNT 4
 
+enum ice_status
+ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port);
+enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all);
+bool ice_tunnel_port_in_use(struct ice_hw *hw, u16 port, u16 *index);
+
 enum ice_status
 ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 	     struct ice_fv_word *es);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index 0fb3fe3ff3ea..249fb66fc230 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -149,6 +149,7 @@ struct ice_buf_hdr {
 #define ICE_SID_CDID_REDIR_RSS		48
 
 #define ICE_SID_RXPARSER_BOOST_TCAM	56
+#define ICE_SID_TXPARSER_BOOST_TCAM	66
 
 #define ICE_SID_XLT0_PE			80
 #define ICE_SID_XLT_KEY_BUILDER_PE	81
@@ -291,6 +292,38 @@ struct ice_pkg_enum {
 	void *(*handler)(u32 sect_type, void *section, u32 index, u32 *offset);
 };
 
+/* Tunnel enabling */
+
+enum ice_tunnel_type {
+	TNL_VXLAN = 0,
+	TNL_GENEVE,
+	TNL_LAST = 0xFF,
+	TNL_ALL = 0xFF,
+};
+
+struct ice_tunnel_type_scan {
+	enum ice_tunnel_type type;
+	const char *label_prefix;
+};
+
+struct ice_tunnel_entry {
+	enum ice_tunnel_type type;
+	u16 boost_addr;
+	u16 port;
+	u16 ref;
+	struct ice_boost_tcam_entry *boost_entry;
+	u8 valid;
+	u8 in_use;
+	u8 marked;
+};
+
+#define ICE_TUNNEL_MAX_ENTRIES	16
+
+struct ice_tunnel_table {
+	struct ice_tunnel_entry tbl[ICE_TUNNEL_MAX_ENTRIES];
+	u16 count;
+};
+
 struct ice_pkg_es {
 	__le16 count;
 	__le16 offset;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 3de862a3c789..07875db08c3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -42,7 +42,10 @@ struct ice_flow_field_info ice_flds_info[ICE_FLOW_FIELD_IDX_MAX] = {
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_SCTP, 0, sizeof(__be16)),
 	/* ICE_FLOW_FIELD_IDX_SCTP_DST_PORT */
 	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_SCTP, 2, sizeof(__be16)),
-
+	/* GRE */
+	/* ICE_FLOW_FIELD_IDX_GRE_KEYID */
+	ICE_FLOW_FLD_INFO(ICE_FLOW_SEG_HDR_GRE, 12,
+			  sizeof_field(struct gre_full_hdr, key)),
 };
 
 /* Bitmaps indicating relevant packet types for a particular protocol header
@@ -134,6 +137,18 @@ static const u32 ice_ptypes_sctp_il[] = {
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 };
 
+/* Packet types for packets with an Outermost/First GRE header */
+static const u32 ice_ptypes_gre_of[] = {
+	0x00000000, 0xBFBF7800, 0x000001DF, 0xFEFDE000,
+	0x0000017E, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
 /* Manage parameters and info. used during the creation of a flow profile */
 struct ice_flow_prof_params {
 	enum ice_block blk;
@@ -225,6 +240,12 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 			src = (const unsigned long *)ice_ptypes_sctp_il;
 			bitmap_and(params->ptypes, params->ptypes, src,
 				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_GRE) {
+			if (!i) {
+				src = (const unsigned long *)ice_ptypes_gre_of;
+				bitmap_and(params->ptypes, params->ptypes,
+					   src, ICE_FLOW_PTYPE_MAX);
+			}
 		}
 	}
 
@@ -275,6 +296,9 @@ ice_flow_xtract_fld(struct ice_hw *hw, struct ice_flow_prof_params *params,
 	case ICE_FLOW_FIELD_IDX_SCTP_DST_PORT:
 		prot_id = ICE_PROT_SCTP_IL;
 		break;
+	case ICE_FLOW_FIELD_IDX_GRE_KEYID:
+		prot_id = ICE_PROT_GRE_OF;
+		break;
 	default:
 		return ICE_ERR_NOT_IMPL;
 	}
@@ -945,6 +969,7 @@ ice_add_rss_list(struct ice_hw *hw, u16 vsi_handle, struct ice_flow_prof *prof)
 #define ICE_FLOW_PROF_ENCAP_M	(BIT_ULL(ICE_FLOW_PROF_ENCAP_S))
 
 #define ICE_RSS_OUTER_HEADERS	1
+#define ICE_RSS_INNER_HEADERS	2
 
 /* Flow profile ID format:
  * [0:31] - Packet match fields
@@ -1085,6 +1110,9 @@ ice_add_rss_cfg(struct ice_hw *hw, u16 vsi_handle, u64 hashed_flds,
 	mutex_lock(&hw->rss_locks);
 	status = ice_add_rss_cfg_sync(hw, vsi_handle, hashed_flds, addl_hdrs,
 				      ICE_RSS_OUTER_HEADERS);
+	if (!status)
+		status = ice_add_rss_cfg_sync(hw, vsi_handle, hashed_flds,
+					      addl_hdrs, ICE_RSS_INNER_HEADERS);
 	mutex_unlock(&hw->rss_locks);
 
 	return status;
@@ -1238,6 +1266,12 @@ enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle)
 						      ICE_RSS_OUTER_HEADERS);
 			if (status)
 				break;
+			status = ice_add_rss_cfg_sync(hw, vsi_handle,
+						      r->hashed_flds,
+						      r->packet_hdr,
+						      ICE_RSS_INNER_HEADERS);
+			if (status)
+				break;
 		}
 	}
 	mutex_unlock(&hw->rss_locks);
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 5558627bd5eb..00f2b7a9feed 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -43,6 +43,7 @@ enum ice_flow_seg_hdr {
 	ICE_FLOW_SEG_HDR_TCP		= 0x00000040,
 	ICE_FLOW_SEG_HDR_UDP		= 0x00000080,
 	ICE_FLOW_SEG_HDR_SCTP		= 0x00000100,
+	ICE_FLOW_SEG_HDR_GRE		= 0x00000200,
 };
 
 enum ice_flow_field {
@@ -58,6 +59,8 @@ enum ice_flow_field {
 	ICE_FLOW_FIELD_IDX_UDP_DST_PORT,
 	ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT,
 	ICE_FLOW_FIELD_IDX_SCTP_DST_PORT,
+	/* GRE */
+	ICE_FLOW_FIELD_IDX_GRE_KEYID,
 	/* The total number of enums must not exceed 64 */
 	ICE_FLOW_FIELD_IDX_MAX
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 878e125d8b42..5d61acdec7ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -262,6 +262,12 @@ enum ice_rx_flex_desc_status_error_0_bits {
 	ICE_RX_FLEX_DESC_STATUS0_LAST /* this entry must be last!!! */
 };
 
+enum ice_rx_flex_desc_status_error_1_bits {
+	/* Note: These are predefined bit offsets */
+	ICE_RX_FLEX_DESC_STATUS1_NAT_S = 4,
+	ICE_RX_FLEX_DESC_STATUS1_LAST /* this entry must be last!!! */
+};
+
 #define ICE_RXQ_CTX_SIZE_DWORDS		8
 #define ICE_RXQ_CTX_SZ			(ICE_RXQ_CTX_SIZE_DWORDS * sizeof(u32))
 #define ICE_TX_CMPLTNQ_CTX_SIZE_DWORDS	22
@@ -413,6 +419,25 @@ enum ice_tx_ctx_desc_cmd_bits {
 	ICE_TX_CTX_DESC_RESERVED	= 0x40
 };
 
+enum ice_tx_ctx_desc_eipt_offload {
+	ICE_TX_CTX_EIPT_NONE		= 0x0,
+	ICE_TX_CTX_EIPT_IPV6		= 0x1,
+	ICE_TX_CTX_EIPT_IPV4_NO_CSUM	= 0x2,
+	ICE_TX_CTX_EIPT_IPV4		= 0x3
+};
+
+#define ICE_TXD_CTX_QW0_EIPLEN_S	2
+
+#define ICE_TXD_CTX_QW0_L4TUNT_S	9
+
+#define ICE_TXD_CTX_UDP_TUNNELING	BIT_ULL(ICE_TXD_CTX_QW0_L4TUNT_S)
+#define ICE_TXD_CTX_GRE_TUNNELING	(0x2ULL << ICE_TXD_CTX_QW0_L4TUNT_S)
+
+#define ICE_TXD_CTX_QW0_NATLEN_S	12
+
+#define ICE_TXD_CTX_QW0_L4T_CS_S	23
+#define ICE_TXD_CTX_QW0_L4T_CS_M	BIT_ULL(ICE_TXD_CTX_QW0_L4T_CS_S)
+
 #define ICE_LAN_TXQ_MAX_QGRPS	127
 #define ICE_LAN_TXQ_MAX_QDIS	1023
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5b190c257124..44ff4fe45a56 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2342,13 +2342,27 @@ static void ice_set_netdev_features(struct net_device *netdev)
 			 NETIF_F_HW_VLAN_CTAG_TX     |
 			 NETIF_F_HW_VLAN_CTAG_RX;
 
-	tso_features = NETIF_F_TSO		|
+	tso_features = NETIF_F_TSO			|
+		       NETIF_F_TSO_ECN			|
+		       NETIF_F_TSO6			|
+		       NETIF_F_GSO_GRE			|
+		       NETIF_F_GSO_UDP_TUNNEL		|
+		       NETIF_F_GSO_GRE_CSUM		|
+		       NETIF_F_GSO_UDP_TUNNEL_CSUM	|
+		       NETIF_F_GSO_PARTIAL		|
+		       NETIF_F_GSO_IPXIP4		|
+		       NETIF_F_GSO_IPXIP6		|
 		       NETIF_F_GSO_UDP_L4;
 
+	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_GRE_CSUM;
 	/* set features that user can change */
 	netdev->hw_features = dflt_features | csumo_features |
 			      vlano_features | tso_features;
 
+	/* add support for HW_CSUM on packets with MPLS header */
+	netdev->mpls_features =  NETIF_F_HW_CSUM;
+
 	/* enable features */
 	netdev->features |= netdev->hw_features;
 	/* encap and VLAN devices inherit default, csumo and tso features */
@@ -5157,6 +5171,70 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	pf->tx_timeout_recovery_level++;
 }
 
+/**
+ * ice_udp_tunnel_add - Get notifications about UDP tunnel ports that come up
+ * @netdev: This physical port's netdev
+ * @ti: Tunnel endpoint information
+ */
+static void
+ice_udp_tunnel_add(struct net_device *netdev, struct udp_tunnel_info *ti)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	enum ice_tunnel_type tnl_type;
+	u16 port = ntohs(ti->port);
+	enum ice_status status;
+
+	switch (ti->type) {
+	case UDP_TUNNEL_TYPE_VXLAN:
+		tnl_type = TNL_VXLAN;
+		break;
+	case UDP_TUNNEL_TYPE_GENEVE:
+		tnl_type = TNL_GENEVE;
+		break;
+	default:
+		netdev_err(netdev, "Unknown tunnel type\n");
+		return;
+	}
+
+	status = ice_create_tunnel(&pf->hw, tnl_type, port);
+	if (status == ICE_ERR_OUT_OF_RANGE)
+		netdev_info(netdev, "Max tunneled UDP ports reached, port %d not added\n",
+			    port);
+	else if (status)
+		netdev_err(netdev, "Error adding UDP tunnel - %d\n",
+			   status);
+}
+
+/**
+ * ice_udp_tunnel_del - Get notifications about UDP tunnel ports that go away
+ * @netdev: This physical port's netdev
+ * @ti: Tunnel endpoint information
+ */
+static void
+ice_udp_tunnel_del(struct net_device *netdev, struct udp_tunnel_info *ti)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+	u16 port = ntohs(ti->port);
+	enum ice_status status;
+	bool retval;
+
+	retval = ice_tunnel_port_in_use(&pf->hw, port, NULL);
+	if (!retval) {
+		netdev_info(netdev, "port %d not found in UDP tunnels list\n",
+			    port);
+		return;
+	}
+
+	status = ice_destroy_tunnel(&pf->hw, port, false);
+	if (status)
+		netdev_err(netdev, "error deleting port %d from UDP tunnels list\n",
+			   port);
+}
+
 /**
  * ice_open - Called when a network interface becomes active
  * @netdev: network interface device structure
@@ -5213,6 +5291,10 @@ int ice_open(struct net_device *netdev)
 	if (err)
 		netdev_err(netdev, "Failed to open VSI 0x%04X on switch 0x%04X\n",
 			   vsi->vsi_num, vsi->vsw->sw_id);
+
+	/* Update existing tunnels information */
+	udp_tunnel_get_rx_info(netdev);
+
 	return err;
 }
 
@@ -5263,21 +5345,21 @@ ice_features_check(struct sk_buff *skb,
 		features &= ~NETIF_F_GSO_MASK;
 
 	len = skb_network_header(skb) - skb->data;
-	if (len & ~(ICE_TXD_MACLEN_MAX))
+	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
 	len = skb_transport_header(skb) - skb_network_header(skb);
-	if (len & ~(ICE_TXD_IPLEN_MAX))
+	if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
 	if (skb->encapsulation) {
 		len = skb_inner_network_header(skb) - skb_transport_header(skb);
-		if (len & ~(ICE_TXD_L4LEN_MAX))
+		if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
 			goto out_rm_features;
 
 		len = skb_inner_transport_header(skb) -
 		      skb_inner_network_header(skb);
-		if (len & ~(ICE_TXD_IPLEN_MAX))
+		if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 			goto out_rm_features;
 	}
 
@@ -5326,4 +5408,6 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
+	.ndo_udp_tunnel_add = ice_udp_tunnel_add,
+	.ndo_udp_tunnel_del = ice_udp_tunnel_del,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 71647566964e..678db6bf7f57 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -18,6 +18,7 @@ enum ice_prot_id {
 	ICE_PROT_IPV6_IL	= 41,
 	ICE_PROT_TCP_IL		= 49,
 	ICE_PROT_UDP_IL_OR_S	= 53,
+	ICE_PROT_GRE_OF		= 64,
 	ICE_PROT_SCTP_IL	= 96,
 	ICE_PROT_META_ID	= 255, /* when offset == metadata */
 	ICE_PROT_INVALID	= 255  /* when offset == ICE_FV_OFFSET_INVAL */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 69b21b436f9a..4ba1fc8261d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1807,12 +1807,94 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	l2_len = ip.hdr - skb->data;
 	offset = (l2_len / 2) << ICE_TX_DESC_LEN_MACLEN_S;
 
-	if (skb->encapsulation)
-		return -1;
+	protocol = vlan_get_protocol(skb);
+
+	if (protocol == htons(ETH_P_IP))
+		first->tx_flags |= ICE_TX_FLAGS_IPV4;
+	else if (protocol == htons(ETH_P_IPV6))
+		first->tx_flags |= ICE_TX_FLAGS_IPV6;
+
+	if (skb->encapsulation) {
+		bool gso_ena = false;
+		u32 tunnel = 0;
+
+		/* define outer network header type */
+		if (first->tx_flags & ICE_TX_FLAGS_IPV4) {
+			tunnel |= (first->tx_flags & ICE_TX_FLAGS_TSO) ?
+				  ICE_TX_CTX_EIPT_IPV4 :
+				  ICE_TX_CTX_EIPT_IPV4_NO_CSUM;
+			l4_proto = ip.v4->protocol;
+		} else if (first->tx_flags & ICE_TX_FLAGS_IPV6) {
+			tunnel |= ICE_TX_CTX_EIPT_IPV6;
+			exthdr = ip.hdr + sizeof(*ip.v6);
+			l4_proto = ip.v6->nexthdr;
+			if (l4.hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data,
+						 &l4_proto, &frag_off);
+		}
+
+		/* define outer transport */
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			tunnel |= ICE_TXD_CTX_UDP_TUNNELING;
+			first->tx_flags |= ICE_TX_FLAGS_TUNNEL;
+			break;
+		case IPPROTO_GRE:
+			tunnel |= ICE_TXD_CTX_GRE_TUNNELING;
+			first->tx_flags |= ICE_TX_FLAGS_TUNNEL;
+			break;
+		case IPPROTO_IPIP:
+		case IPPROTO_IPV6:
+			first->tx_flags |= ICE_TX_FLAGS_TUNNEL;
+			l4.hdr = skb_inner_network_header(skb);
+			break;
+		default:
+			if (first->tx_flags & ICE_TX_FLAGS_TSO)
+				return -1;
+
+			skb_checksum_help(skb);
+			return 0;
+		}
+
+		/* compute outer L3 header size */
+		tunnel |= ((l4.hdr - ip.hdr) / 4) <<
+			  ICE_TXD_CTX_QW0_EIPLEN_S;
+
+		/* switch IP header pointer from outer to inner header */
+		ip.hdr = skb_inner_network_header(skb);
+
+		/* compute tunnel header size */
+		tunnel |= ((ip.hdr - l4.hdr) / 2) <<
+			   ICE_TXD_CTX_QW0_NATLEN_S;
+
+		gso_ena = skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL;
+		/* indicate if we need to offload outer UDP header */
+		if ((first->tx_flags & ICE_TX_FLAGS_TSO) && !gso_ena &&
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM))
+			tunnel |= ICE_TXD_CTX_QW0_L4T_CS_M;
+
+		/* record tunnel offload values */
+		off->cd_tunnel_params |= tunnel;
+
+		/* set DTYP=1 to indicate that it's an Tx context descriptor
+		 * in IPsec tunnel mode with Tx offloads in Quad word 1
+		 */
+		off->cd_qw1 |= (u64)ICE_TX_DESC_DTYPE_CTX;
+
+		/* switch L4 header pointer from outer to inner */
+		l4.hdr = skb_inner_transport_header(skb);
+		l4_proto = 0;
+
+		/* reset type as we transition from outer to inner headers */
+		first->tx_flags &= ~(ICE_TX_FLAGS_IPV4 | ICE_TX_FLAGS_IPV6);
+		if (ip.v4->version == 4)
+			first->tx_flags |= ICE_TX_FLAGS_IPV4;
+		if (ip.v6->version == 6)
+			first->tx_flags |= ICE_TX_FLAGS_IPV6;
+	}
 
 	/* Enable IP checksum offloads */
-	protocol = vlan_get_protocol(skb);
-	if (protocol == htons(ETH_P_IP)) {
+	if (first->tx_flags & ICE_TX_FLAGS_IPV4) {
 		l4_proto = ip.v4->protocol;
 		/* the stack computes the IP header already, the only time we
 		 * need the hardware to recompute it is in the case of TSO.
@@ -1822,7 +1904,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		else
 			cmd |= ICE_TX_DESC_CMD_IIPT_IPV4;
 
-	} else if (protocol == htons(ETH_P_IPV6)) {
+	} else if (first->tx_flags & ICE_TX_FLAGS_IPV6) {
 		cmd |= ICE_TX_DESC_CMD_IIPT_IPV6;
 		exthdr = ip.hdr + sizeof(*ip.v6);
 		l4_proto = ip.v6->nexthdr;
@@ -1969,6 +2051,40 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		ip.v6->payload_len = 0;
 	}
 
+	if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE |
+					 SKB_GSO_GRE_CSUM |
+					 SKB_GSO_IPXIP4 |
+					 SKB_GSO_IPXIP6 |
+					 SKB_GSO_UDP_TUNNEL |
+					 SKB_GSO_UDP_TUNNEL_CSUM)) {
+		if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL) &&
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)) {
+			l4.udp->len = 0;
+
+			/* determine offset of outer transport header */
+			l4_start = l4.hdr - skb->data;
+
+			/* remove payload length from outer checksum */
+			paylen = skb->len - l4_start;
+			csum_replace_by_diff(&l4.udp->check,
+					     (__force __wsum)htonl(paylen));
+		}
+
+		/* reset pointers to inner headers */
+
+		/* cppcheck-suppress unreadVariable */
+		ip.hdr = skb_inner_network_header(skb);
+		l4.hdr = skb_inner_transport_header(skb);
+
+		/* initialize inner IP header fields */
+		if (ip.v4->version == 4) {
+			ip.v4->tot_len = 0;
+			ip.v4->check = 0;
+		} else {
+			ip.v6->payload_len = 0;
+		}
+	}
+
 	/* determine offset of transport header */
 	l4_start = l4.hdr - skb->data;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 7ee00a128663..025dd642cf28 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -113,6 +113,9 @@ static inline int ice_skb_pad(void)
 #define ICE_TX_FLAGS_TSO	BIT(0)
 #define ICE_TX_FLAGS_HW_VLAN	BIT(1)
 #define ICE_TX_FLAGS_SW_VLAN	BIT(2)
+#define ICE_TX_FLAGS_IPV4	BIT(5)
+#define ICE_TX_FLAGS_IPV6	BIT(6)
+#define ICE_TX_FLAGS_TUNNEL	BIT(7)
 #define ICE_TX_FLAGS_VLAN_M	0xffff0000
 #define ICE_TX_FLAGS_VLAN_PR_M	0xe0000000
 #define ICE_TX_FLAGS_VLAN_PR_S	29
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 6da048a6ca7c..1f9c3d24cde7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -84,12 +84,17 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	    union ice_32b_rx_flex_desc *rx_desc, u8 ptype)
 {
 	struct ice_rx_ptype_decoded decoded;
-	u32 rx_error, rx_status;
+	u16 rx_error, rx_status;
+	u16 rx_stat_err1;
 	bool ipv4, ipv6;
 
 	rx_status = le16_to_cpu(rx_desc->wb.status_error0);
-	rx_error = rx_status;
+	rx_error = rx_status & (BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
+				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_L4E_S) |
+				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S) |
+				BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S));
 
+	rx_stat_err1 = le16_to_cpu(rx_desc->wb.status_error1);
 	decoded = ice_decode_rx_desc_ptype(ptype);
 
 	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
@@ -125,6 +130,18 @@ ice_rx_csum(struct ice_ring *ring, struct sk_buff *skb,
 	if (rx_error & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_L4E_S))
 		goto checksum_fail;
 
+	/* check for outer UDP checksum error in tunneled packets */
+	if ((rx_stat_err1 & BIT(ICE_RX_FLEX_DESC_STATUS1_NAT_S)) &&
+	    (rx_error & BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S)))
+		goto checksum_fail;
+
+	/* If there is an outer header present that might contain a checksum
+	 * we need to bump the checksum level by 1 to reflect the fact that
+	 * we are indicating we validated the inner checksum.
+	 */
+	if (decoded.tunnel_type >= ICE_RX_PTYPE_TUNNEL_IP_GRENAT)
+		skb->csum_level = 1;
+
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
 	switch (decoded.inner_prot) {
 	case ICE_RX_PTYPE_INNER_PROT_TCP:
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 35ea5adbb3e5..c56b2e77a48c 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -579,6 +579,10 @@ struct ice_hw {
 	u8 *pkg_copy;
 	u32 pkg_size;
 
+	/* tunneling info */
+	struct mutex tnl_lock;
+	struct ice_tunnel_table tnl;
+
 	/* HW block tables */
 	struct ice_blk_info blk[ICE_BLK_COUNT];
 	struct mutex fl_profs_locks[ICE_BLK_COUNT];	/* lock fltr profiles */
-- 
2.26.2

