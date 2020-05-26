Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673EE1DF562
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387645AbgEWHGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:06:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:52997 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387681AbgEWHGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 03:06:02 -0400
IronPort-SDR: mGFcMo73zSEGrdH9wY0Z/hGBPOFduGjCmLMOsqCRdUuZ8hPmS7cDiYUVBLh1Dp+oehb28XcF7s
 IKWrofvaIDRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:49 -0700
IronPort-SDR: vTMbUi4hCIWHg6kdExlfhLD8ySU3rBxwNvsL59pwTt0PAvfn3C+SS/ka2B3t8UmKXKiBt1sDAG
 EECRrgFL4uaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966883"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/16] ice: Support IPv4 Flow Director filters
Date:   Fri, 22 May 2020 23:48:35 -0700
Message-Id: <20200523064847.3972158-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Support the addition and deletion of IPv4 filters.

Supported fields are: src-ip, dst-ip, src-port, and dst-port
Supported flow-types are: tcp4, udp4, sctp4, ip4

Example usage:

ethtool -N eth0 flow-type tcp4 src-ip 192.168.0.55 dst-ip 172.16.0.55 \
src-port 16 dst-port 12 action 32

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   4 +
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 658 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.c     | 513 ++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  79 +++
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  34 +
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   6 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 101 +++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  82 +++
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   6 +
 12 files changed, 1493 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e0c9e4a30d82..298a65a3799c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -96,6 +96,7 @@ extern const char ice_drv_ver[];
 #define ICE_TX_DESC(R, i) (&(((struct ice_tx_desc *)((R)->desc))[i]))
 #define ICE_RX_DESC(R, i) (&(((union ice_32b_rx_flex_desc *)((R)->desc))[i]))
 #define ICE_TX_CTX_DESC(R, i) (&(((struct ice_tx_ctx_desc *)((R)->desc))[i]))
+#define ICE_TX_FDIRDESC(R, i) (&(((struct ice_fltr_desc *)((R)->desc))[i]))
 
 /* Macro for each VSI in a PF */
 #define ice_for_each_vsi(pf, i) \
@@ -216,6 +217,7 @@ enum ice_state {
 	__ICE_CFG_BUSY,
 	__ICE_SERVICE_SCHED,
 	__ICE_SERVICE_DIS,
+	__ICE_FD_FLUSH_REQ,
 	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
 	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
 	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
@@ -557,6 +559,8 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena);
+int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
+int ice_del_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd);
 int
 ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f77db28e1e4c..72105d70cead 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2537,6 +2537,10 @@ static int ice_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 	struct ice_vsi *vsi = np->vsi;
 
 	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		return ice_add_fdir_ethtool(vsi, cmd);
+	case ETHTOOL_SRXCLSRLDEL:
+		return ice_del_fdir_ethtool(vsi, cmd);
 	case ETHTOOL_SRXFH:
 		return ice_set_rss_hash_opt(vsi, cmd);
 	default:
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 9276ebf96d28..6badf2ef2255 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -265,6 +265,43 @@ void ice_fdir_release_flows(struct ice_hw *hw)
 		ice_fdir_erase_flow_from_hw(hw, ICE_BLK_FD, flow);
 }
 
+/**
+ * ice_fdir_num_avail_fltr - return the number of unused flow director filters
+ * @hw: pointer to hardware structure
+ * @vsi: software VSI structure
+ *
+ * There are 2 filter pools: guaranteed and best effort(shared). Each VSI can
+ * use filters from either pool. The guaranteed pool is divided between VSIs.
+ * The best effort filter pool is common to all VSIs and is a device shared
+ * resource pool. The number of filters available to this VSI is the sum of
+ * the VSIs guaranteed filter pool and the global available best effort
+ * filter pool.
+ *
+ * Returns the number of available flow director filters to this VSI
+ */
+static int ice_fdir_num_avail_fltr(struct ice_hw *hw, struct ice_vsi *vsi)
+{
+	u16 vsi_num = ice_get_hw_vsi_num(hw, vsi->idx);
+	u16 num_guar;
+	u16 num_be;
+
+	/* total guaranteed filters assigned to this VSI */
+	num_guar = vsi->num_gfltr;
+
+	/* minus the guaranteed filters programed by this VSI */
+	num_guar -= (rd32(hw, VSIQF_FD_CNT(vsi_num)) &
+		     VSIQF_FD_CNT_FD_GCNT_M) >> VSIQF_FD_CNT_FD_GCNT_S;
+
+	/* total global best effort filters */
+	num_be = hw->func_caps.fd_fltr_best_effort;
+
+	/* minus the global best effort filters programmed */
+	num_be -= (rd32(hw, GLQF_FD_CNT) & GLQF_FD_CNT_FD_BCNT_M) >>
+		   GLQF_FD_CNT_FD_BCNT_S;
+
+	return num_guar + num_be;
+}
+
 /**
  * ice_fdir_alloc_flow_prof - allocate FDir flow profile structure(s)
  * @hw: HW structure containing the FDir flow profile structure(s)
@@ -344,6 +381,14 @@ ice_fdir_set_hw_fltr_rule(struct ice_pf *pf, struct ice_flow_seg_info *seg,
 		if (!memcmp(old_seg, seg, sizeof(*seg)))
 			return -EEXIST;
 
+		/* if there are FDir filters using this flow,
+		 * then return error.
+		 */
+		if (hw->fdir_fltr_cnt[flow]) {
+			dev_err(dev, "Failed to add filter.  Flow director filters on each port must have the same input set.\n");
+			return -EINVAL;
+		}
+
 		/* remove HW filter definition */
 		ice_fdir_rem_flow(hw, ICE_BLK_FD, flow);
 	}
@@ -508,6 +553,347 @@ ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
 	return -EOPNOTSUPP;
 }
 
+/**
+ * ice_set_fdir_ip4_seg
+ * @seg: flow segment for programming
+ * @tcp_ip4_spec: mask data from ethtool
+ * @l4_proto: Layer 4 protocol to program
+ * @perfect_fltr: only valid on success; returns true if perfect filter,
+ *		  false if not
+ *
+ * Set the mask data into the flow segment to be used to program HW
+ * table based on provided L4 protocol for IPv4
+ */
+static int
+ice_set_fdir_ip4_seg(struct ice_flow_seg_info *seg,
+		     struct ethtool_tcpip4_spec *tcp_ip4_spec,
+		     enum ice_flow_seg_hdr l4_proto, bool *perfect_fltr)
+{
+	enum ice_flow_field src_port, dst_port;
+
+	/* make sure we don't have any empty rule */
+	if (!tcp_ip4_spec->psrc && !tcp_ip4_spec->ip4src &&
+	    !tcp_ip4_spec->pdst && !tcp_ip4_spec->ip4dst)
+		return -EINVAL;
+
+	/* filtering on TOS not supported */
+	if (tcp_ip4_spec->tos)
+		return -EOPNOTSUPP;
+
+	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
+		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
+		src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_SCTP) {
+		src_port = ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_SCTP_DST_PORT;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	*perfect_fltr = true;
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 | l4_proto);
+
+	/* IP source address */
+	if (tcp_ip4_spec->ip4src == htonl(0xFFFFFFFF))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_SA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!tcp_ip4_spec->ip4src)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* IP destination address */
+	if (tcp_ip4_spec->ip4dst == htonl(0xFFFFFFFF))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_DA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!tcp_ip4_spec->ip4dst)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* Layer 4 source port */
+	if (tcp_ip4_spec->psrc == htons(0xFFFF))
+		ice_flow_set_fld(seg, src_port, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 false);
+	else if (!tcp_ip4_spec->psrc)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* Layer 4 destination port */
+	if (tcp_ip4_spec->pdst == htons(0xFFFF))
+		ice_flow_set_fld(seg, dst_port, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 false);
+	else if (!tcp_ip4_spec->pdst)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * ice_set_fdir_ip4_usr_seg
+ * @seg: flow segment for programming
+ * @usr_ip4_spec: ethtool userdef packet offset
+ * @perfect_fltr: only valid on success; returns true if perfect filter,
+ *		  false if not
+ *
+ * Set the offset data into the flow segment to be used to program HW
+ * table for IPv4
+ */
+static int
+ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
+			 struct ethtool_usrip4_spec *usr_ip4_spec,
+			 bool *perfect_fltr)
+{
+	/* first 4 bytes of Layer 4 header */
+	if (usr_ip4_spec->l4_4_bytes)
+		return -EINVAL;
+	if (usr_ip4_spec->tos)
+		return -EINVAL;
+	if (usr_ip4_spec->ip_ver)
+		return -EINVAL;
+	/* Filtering on Layer 4 protocol not supported */
+	if (usr_ip4_spec->proto)
+		return -EOPNOTSUPP;
+	/* empty rules are not valid */
+	if (!usr_ip4_spec->ip4src && !usr_ip4_spec->ip4dst)
+		return -EINVAL;
+
+	*perfect_fltr = true;
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4);
+
+	/* IP source address */
+	if (usr_ip4_spec->ip4src == htonl(0xFFFFFFFF))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_SA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!usr_ip4_spec->ip4src)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* IP destination address */
+	if (usr_ip4_spec->ip4dst == htonl(0xFFFFFFFF))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_DA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!usr_ip4_spec->ip4dst)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * ice_cfg_fdir_xtrct_seq - Configure extraction sequence for the given filter
+ * @pf: PF structure
+ * @fsp: pointer to ethtool Rx flow specification
+ *
+ * Returns 0 on success.
+ */
+static int
+ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
+{
+	struct ice_flow_seg_info *seg, *tun_seg;
+	struct device *dev = ice_pf_to_dev(pf);
+	enum ice_fltr_ptype fltr_idx;
+	struct ice_hw *hw = &pf->hw;
+	bool perfect_filter;
+	int ret;
+
+	seg = devm_kzalloc(dev, sizeof(*seg), GFP_KERNEL);
+	if (!seg)
+		return -ENOMEM;
+
+	tun_seg = devm_kzalloc(dev, sizeof(*seg) * ICE_FD_HW_SEG_MAX,
+			       GFP_KERNEL);
+	if (!tun_seg) {
+		devm_kfree(dev, seg);
+		return -ENOMEM;
+	}
+
+	switch (fsp->flow_type & ~FLOW_EXT) {
+	case TCP_V4_FLOW:
+		ret = ice_set_fdir_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					   ICE_FLOW_SEG_HDR_TCP,
+					   &perfect_filter);
+		break;
+	case UDP_V4_FLOW:
+		ret = ice_set_fdir_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					   ICE_FLOW_SEG_HDR_UDP,
+					   &perfect_filter);
+		break;
+	case SCTP_V4_FLOW:
+		ret = ice_set_fdir_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					   ICE_FLOW_SEG_HDR_SCTP,
+					   &perfect_filter);
+		break;
+	case IPV4_USER_FLOW:
+		ret = ice_set_fdir_ip4_usr_seg(seg, &fsp->m_u.usr_ip4_spec,
+					       &perfect_filter);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (ret)
+		goto err_exit;
+
+	/* tunnel segments are shifted up one. */
+	memcpy(&tun_seg[1], seg, sizeof(*seg));
+
+	/* add filter for outer headers */
+	fltr_idx = ice_ethtool_flow_to_fltr(fsp->flow_type & ~FLOW_EXT);
+	ret = ice_fdir_set_hw_fltr_rule(pf, seg, fltr_idx,
+					ICE_FD_HW_SEG_NON_TUN);
+	if (ret == -EEXIST)
+		/* Rule already exists, free memory and continue */
+		devm_kfree(dev, seg);
+	else if (ret)
+		/* could not write filter, free memory */
+		goto err_exit;
+
+	/* make tunneled filter HW entries if possible */
+	memcpy(&tun_seg[1], seg, sizeof(*seg));
+	ret = ice_fdir_set_hw_fltr_rule(pf, tun_seg, fltr_idx,
+					ICE_FD_HW_SEG_TUN);
+	if (ret == -EEXIST) {
+		/* Rule already exists, free memory and count as success */
+		devm_kfree(dev, tun_seg);
+		ret = 0;
+	} else if (ret) {
+		/* could not write tunnel filter, but outer filter exists */
+		devm_kfree(dev, tun_seg);
+	}
+
+	if (perfect_filter)
+		set_bit(fltr_idx, hw->fdir_perfect_fltr);
+	else
+		clear_bit(fltr_idx, hw->fdir_perfect_fltr);
+
+	return ret;
+
+err_exit:
+	devm_kfree(dev, tun_seg);
+	devm_kfree(dev, seg);
+
+	return -EOPNOTSUPP;
+}
+
+/**
+ * ice_fdir_write_fltr - send a flow director filter to the hardware
+ * @pf: PF data structure
+ * @input: filter structure
+ * @add: true adds filter and false removed filter
+ * @is_tun: true adds inner filter on tunnel and false outer headers
+ *
+ * returns 0 on success and negative value on error
+ */
+static int
+ice_fdir_write_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input, bool add,
+		    bool is_tun)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	struct ice_fltr_desc desc;
+	struct ice_vsi *ctrl_vsi;
+	enum ice_status status;
+	u8 *pkt, *frag_pkt;
+	bool has_frag;
+	int err;
+
+	ctrl_vsi = ice_get_ctrl_vsi(pf);
+	if (!ctrl_vsi)
+		return -EINVAL;
+
+	pkt = devm_kzalloc(dev, ICE_FDIR_MAX_RAW_PKT_SIZE, GFP_KERNEL);
+	if (!pkt)
+		return -ENOMEM;
+	frag_pkt = devm_kzalloc(dev, ICE_FDIR_MAX_RAW_PKT_SIZE, GFP_KERNEL);
+	if (!frag_pkt) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	ice_fdir_get_prgm_desc(hw, input, &desc, add);
+	status = ice_fdir_get_gen_prgm_pkt(hw, input, pkt, false, is_tun);
+	if (status) {
+		err = ice_status_to_errno(status);
+		goto err_free_all;
+	}
+	err = ice_prgm_fdir_fltr(ctrl_vsi, &desc, pkt);
+	if (err)
+		goto err_free_all;
+
+	/* repeat for fragment packet */
+	has_frag = ice_fdir_has_frag(input->flow_type);
+	if (has_frag) {
+		/* does not return error */
+		ice_fdir_get_prgm_desc(hw, input, &desc, add);
+		status = ice_fdir_get_gen_prgm_pkt(hw, input, frag_pkt, true,
+						   is_tun);
+		if (status) {
+			err = ice_status_to_errno(status);
+			goto err_frag;
+		}
+		err = ice_prgm_fdir_fltr(ctrl_vsi, &desc, frag_pkt);
+		if (err)
+			goto err_frag;
+	} else {
+		devm_kfree(dev, frag_pkt);
+	}
+
+	return 0;
+
+err_free_all:
+	devm_kfree(dev, frag_pkt);
+err_free:
+	devm_kfree(dev, pkt);
+	return err;
+
+err_frag:
+	devm_kfree(dev, frag_pkt);
+	return err;
+}
+
+/**
+ * ice_fdir_write_all_fltr - send a flow director filter to the hardware
+ * @pf: PF data structure
+ * @input: filter structure
+ * @add: true adds filter and false removed filter
+ *
+ * returns 0 on success and negative value on error
+ */
+static int
+ice_fdir_write_all_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input,
+			bool add)
+{
+	u16 port_num;
+	int tun;
+
+	for (tun = 0; tun < ICE_FD_HW_SEG_MAX; tun++) {
+		bool is_tun = tun == ICE_FD_HW_SEG_TUN;
+		int err;
+
+		if (is_tun && !ice_get_open_tunnel_port(&pf->hw, TNL_ALL,
+							&port_num))
+			continue;
+		err = ice_fdir_write_fltr(pf, input, add, is_tun);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * ice_fdir_create_dflt_rules - create default perfect filters
  * @pf: PF data structure
@@ -535,6 +921,7 @@ int ice_fdir_create_dflt_rules(struct ice_pf *pf)
  */
 void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 {
+	struct ice_fdir_fltr *f_rule, *tmp;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_fltr_ptype flow;
@@ -548,6 +935,13 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 	mutex_lock(&hw->fdir_fltr_lock);
 	if (!test_and_clear_bit(ICE_FLAG_FD_ENA, pf->flags))
 		goto release_lock;
+	list_for_each_entry_safe(f_rule, tmp, &hw->fdir_list_head, fltr_node) {
+		/* ignore return value */
+		ice_fdir_write_all_fltr(pf, f_rule, false);
+		ice_fdir_update_cntrs(hw, f_rule->flow_type, false);
+		list_del(&f_rule->fltr_node);
+		devm_kfree(ice_hw_to_dev(hw), f_rule);
+	}
 
 	if (hw->fdir_prof)
 		for (flow = ICE_FLTR_PTYPE_NONF_NONE; flow < ICE_FLTR_PTYPE_MAX;
@@ -558,3 +952,267 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 release_lock:
 	mutex_unlock(&hw->fdir_fltr_lock);
 }
+
+/**
+ * ice_fdir_update_list_entry - add or delete a filter from the filter list
+ * @pf: PF structure
+ * @input: filter structure
+ * @fltr_idx: ethtool index of filter to modify
+ *
+ * returns 0 on success and negative on errors
+ */
+static int
+ice_fdir_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
+			   int fltr_idx)
+{
+	struct ice_fdir_fltr *old_fltr;
+	struct ice_hw *hw = &pf->hw;
+	int err = -ENOENT;
+
+	/* Do not update filters during reset */
+	if (ice_is_reset_in_progress(pf->state))
+		return -EBUSY;
+
+	old_fltr = ice_fdir_find_fltr_by_idx(hw, fltr_idx);
+	if (old_fltr) {
+		err = ice_fdir_write_all_fltr(pf, old_fltr, false);
+		if (err)
+			return err;
+		ice_fdir_update_cntrs(hw, old_fltr->flow_type, false);
+		if (!input && !hw->fdir_fltr_cnt[old_fltr->flow_type])
+			/* we just deleted the last filter of flow_type so we
+			 * should also delete the HW filter info.
+			 */
+			ice_fdir_rem_flow(hw, ICE_BLK_FD, old_fltr->flow_type);
+		list_del(&old_fltr->fltr_node);
+		devm_kfree(ice_hw_to_dev(hw), old_fltr);
+	}
+	if (!input)
+		return err;
+	ice_fdir_list_add_fltr(hw, input);
+	ice_fdir_update_cntrs(hw, input->flow_type, true);
+	return 0;
+}
+
+/**
+ * ice_del_fdir_ethtool - delete Flow Director filter
+ * @vsi: pointer to target VSI
+ * @cmd: command to add or delete Flow Director filter
+ *
+ * Returns 0 on success and negative values for failure
+ */
+int ice_del_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int val;
+
+	if (!test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		return -EOPNOTSUPP;
+
+	/* Do not delete filters during reset */
+	if (ice_is_reset_in_progress(pf->state)) {
+		dev_err(ice_pf_to_dev(pf), "Device is resetting - deleting Flow Director filters not supported during reset\n");
+		return -EBUSY;
+	}
+
+	if (test_bit(__ICE_FD_FLUSH_REQ, pf->state))
+		return -EBUSY;
+
+	mutex_lock(&hw->fdir_fltr_lock);
+	val = ice_fdir_update_list_entry(pf, NULL, fsp->location);
+	mutex_unlock(&hw->fdir_fltr_lock);
+
+	return val;
+}
+
+/**
+ * ice_set_fdir_input_set - Set the input set for Flow Director
+ * @vsi: pointer to target VSI
+ * @fsp: pointer to ethtool Rx flow specification
+ * @input: filter structure
+ */
+static int
+ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
+		       struct ice_fdir_fltr *input)
+{
+	u16 dest_vsi, q_index = 0;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	int flow_type;
+	u8 dest_ctl;
+
+	if (!vsi || !fsp || !input)
+		return -EINVAL;
+
+	pf = vsi->back;
+	hw = &pf->hw;
+
+	dest_vsi = vsi->idx;
+	if (fsp->ring_cookie == RX_CLS_FLOW_DISC) {
+		dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DROP_PKT;
+	} else {
+		u32 ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
+		u8 vf = ethtool_get_flow_spec_ring_vf(fsp->ring_cookie);
+
+		if (vf) {
+			dev_err(ice_pf_to_dev(pf), "Failed to add filter. Flow director filters are not supported on VF queues.\n");
+			return -EINVAL;
+		}
+
+		if (ring >= vsi->num_rxq)
+			return -EINVAL;
+
+		dest_ctl = ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX;
+		q_index = ring;
+	}
+
+	input->fltr_id = fsp->location;
+	input->q_index = q_index;
+	flow_type = fsp->flow_type & ~FLOW_EXT;
+
+	input->dest_vsi = dest_vsi;
+	input->dest_ctl = dest_ctl;
+	input->fltr_status = ICE_FLTR_PRGM_DESC_FD_STATUS_FD_ID;
+	input->cnt_index = ICE_FD_SB_STAT_IDX(hw->fd_ctr_base);
+	input->flow_type = ice_ethtool_flow_to_fltr(flow_type);
+
+	if (fsp->flow_type & FLOW_EXT) {
+		memcpy(input->ext_data.usr_def, fsp->h_ext.data,
+		       sizeof(input->ext_data.usr_def));
+		input->ext_data.vlan_type = fsp->h_ext.vlan_etype;
+		input->ext_data.vlan_tag = fsp->h_ext.vlan_tci;
+		memcpy(input->ext_mask.usr_def, fsp->m_ext.data,
+		       sizeof(input->ext_mask.usr_def));
+		input->ext_mask.vlan_type = fsp->m_ext.vlan_etype;
+		input->ext_mask.vlan_tag = fsp->m_ext.vlan_tci;
+	}
+
+	switch (flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		input->ip.dst_port = fsp->h_u.tcp_ip4_spec.pdst;
+		input->ip.src_port = fsp->h_u.tcp_ip4_spec.psrc;
+		input->ip.dst_ip = fsp->h_u.tcp_ip4_spec.ip4dst;
+		input->ip.src_ip = fsp->h_u.tcp_ip4_spec.ip4src;
+		input->mask.dst_port = fsp->m_u.tcp_ip4_spec.pdst;
+		input->mask.src_port = fsp->m_u.tcp_ip4_spec.psrc;
+		input->mask.dst_ip = fsp->m_u.tcp_ip4_spec.ip4dst;
+		input->mask.src_ip = fsp->m_u.tcp_ip4_spec.ip4src;
+		break;
+	case IPV4_USER_FLOW:
+		input->ip.dst_ip = fsp->h_u.usr_ip4_spec.ip4dst;
+		input->ip.src_ip = fsp->h_u.usr_ip4_spec.ip4src;
+		input->ip.l4_header = fsp->h_u.usr_ip4_spec.l4_4_bytes;
+		input->ip.proto = fsp->h_u.usr_ip4_spec.proto;
+		input->ip.ip_ver = fsp->h_u.usr_ip4_spec.ip_ver;
+		input->ip.tos = fsp->h_u.usr_ip4_spec.tos;
+		input->mask.dst_ip = fsp->m_u.usr_ip4_spec.ip4dst;
+		input->mask.src_ip = fsp->m_u.usr_ip4_spec.ip4src;
+		input->mask.l4_header = fsp->m_u.usr_ip4_spec.l4_4_bytes;
+		input->mask.proto = fsp->m_u.usr_ip4_spec.proto;
+		input->mask.ip_ver = fsp->m_u.usr_ip4_spec.ip_ver;
+		input->mask.tos = fsp->m_u.usr_ip4_spec.tos;
+		break;
+	default:
+		/* not doing un-parsed flow types */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_add_fdir_ethtool - Add/Remove Flow Director filter
+ * @vsi: pointer to target VSI
+ * @cmd: command to add or delete Flow Director filter
+ *
+ * Returns 0 on success and negative values for failure
+ */
+int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp;
+	struct ice_fdir_fltr *input;
+	struct device *dev;
+	struct ice_pf *pf;
+	struct ice_hw *hw;
+	int fltrs_needed;
+	u16 tunnel_port;
+	int ret;
+
+	if (!vsi)
+		return -EINVAL;
+
+	pf = vsi->back;
+	hw = &pf->hw;
+	dev = ice_pf_to_dev(pf);
+
+	if (!test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		return -EOPNOTSUPP;
+
+	/* Do not program filters during reset */
+	if (ice_is_reset_in_progress(pf->state)) {
+		dev_err(dev, "Device is resetting - adding Flow Director filters not supported during reset\n");
+		return -EBUSY;
+	}
+
+	fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
+
+	if (fsp->flow_type & FLOW_MAC_EXT)
+		return -EINVAL;
+
+	ret = ice_cfg_fdir_xtrct_seq(pf, fsp);
+	if (ret)
+		return ret;
+
+	if (fsp->location >= ice_get_fdir_cnt_all(hw)) {
+		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
+		return -ENOSPC;
+	}
+
+	/* return error if not an update and no available filters */
+	fltrs_needed = ice_get_open_tunnel_port(hw, TNL_ALL, &tunnel_port) ?
+		2 : 1;
+	if (!ice_fdir_find_fltr_by_idx(hw, fsp->location) &&
+	    ice_fdir_num_avail_fltr(hw, pf->vsi[vsi->idx]) < fltrs_needed) {
+		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
+		return -ENOSPC;
+	}
+
+	input = devm_kzalloc(dev, sizeof(*input), GFP_KERNEL);
+	if (!input)
+		return -ENOMEM;
+
+	ret = ice_set_fdir_input_set(vsi, fsp, input);
+	if (ret)
+		goto free_input;
+
+	mutex_lock(&hw->fdir_fltr_lock);
+	if (ice_fdir_is_dup_fltr(hw, input)) {
+		ret = -EINVAL;
+		goto release_lock;
+	}
+
+	/* input struct is added to the HW filter list */
+	ice_fdir_update_list_entry(pf, input, fsp->location);
+
+	ret = ice_fdir_write_all_fltr(pf, input, true);
+	if (ret)
+		goto remove_sw_rule;
+
+	goto release_lock;
+
+remove_sw_rule:
+	ice_fdir_update_cntrs(hw, input->flow_type, false);
+	list_del(&input->fltr_node);
+release_lock:
+	mutex_unlock(&hw->fdir_fltr_lock);
+free_input:
+	if (ret)
+		devm_kfree(dev, input);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 1f423e50182c..60a824363f06 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -3,6 +3,261 @@
 
 #include "ice_common.h"
 
+/* These are training packet headers used to program flow director filters. */
+static const u8 ice_fdir_tcpv4_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x28, 0x00, 0x01, 0x00, 0x00, 0x40, 0x06,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x50, 0x00,
+	0x20, 0x00, 0x00, 0x00, 0x00, 0x00
+};
+
+static const u8 ice_fdir_udpv4_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x1C, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_sctpv4_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x20, 0x00, 0x00, 0x40, 0x00, 0x40, 0x84,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv4_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x14, 0x00, 0x00, 0x40, 0x00, 0x40, 0x10,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00
+};
+
+static const u8 ice_fdir_tcp4_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x5a, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00,
+	0x45, 0x00, 0x00, 0x28, 0x00, 0x00, 0x40, 0x00,
+	0x40, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x50, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_udp4_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x4e, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00,
+	0x45, 0x00, 0x00, 0x1c, 0x00, 0x00, 0x40, 0x00,
+	0x40, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_sctp4_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x52, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00,
+	0x45, 0x00, 0x00, 0x20, 0x00, 0x01, 0x00, 0x00,
+	0x40, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ip4_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x46, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00,
+	0x45, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00,
+	0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+};
+
+/* Flow Director no-op training packet table */
+static const struct ice_fdir_base_pkt ice_fdir_pkt[] = {
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_TCP,
+		sizeof(ice_fdir_tcpv4_pkt), ice_fdir_tcpv4_pkt,
+		sizeof(ice_fdir_tcp4_tun_pkt), ice_fdir_tcp4_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_UDP,
+		sizeof(ice_fdir_udpv4_pkt), ice_fdir_udpv4_pkt,
+		sizeof(ice_fdir_udp4_tun_pkt), ice_fdir_udp4_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_SCTP,
+		sizeof(ice_fdir_sctpv4_pkt), ice_fdir_sctpv4_pkt,
+		sizeof(ice_fdir_sctp4_tun_pkt), ice_fdir_sctp4_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV4_OTHER,
+		sizeof(ice_fdir_ipv4_pkt), ice_fdir_ipv4_pkt,
+		sizeof(ice_fdir_ip4_tun_pkt), ice_fdir_ip4_tun_pkt,
+	},
+};
+
+#define ICE_FDIR_NUM_PKT ARRAY_SIZE(ice_fdir_pkt)
+
+/**
+ * ice_set_dflt_val_fd_desc
+ * @fd_fltr_ctx: pointer to fd filter descriptor
+ */
+static void ice_set_dflt_val_fd_desc(struct ice_fd_fltr_desc_ctx *fd_fltr_ctx)
+{
+	fd_fltr_ctx->comp_q = ICE_FXD_FLTR_QW0_COMP_Q_ZERO;
+	fd_fltr_ctx->comp_report = ICE_FXD_FLTR_QW0_COMP_REPORT_SW_FAIL;
+	fd_fltr_ctx->fd_space = ICE_FXD_FLTR_QW0_FD_SPACE_GUAR_BEST;
+	fd_fltr_ctx->cnt_ena = ICE_FXD_FLTR_QW0_STAT_ENA_PKTS;
+	fd_fltr_ctx->evict_ena = ICE_FXD_FLTR_QW0_EVICT_ENA_TRUE;
+	fd_fltr_ctx->toq = ICE_FXD_FLTR_QW0_TO_Q_EQUALS_QINDEX;
+	fd_fltr_ctx->toq_prio = ICE_FXD_FLTR_QW0_TO_Q_PRIO1;
+	fd_fltr_ctx->dpu_recipe = ICE_FXD_FLTR_QW0_DPU_RECIPE_DFLT;
+	fd_fltr_ctx->drop = ICE_FXD_FLTR_QW0_DROP_NO;
+	fd_fltr_ctx->flex_prio = ICE_FXD_FLTR_QW0_FLEX_PRI_NONE;
+	fd_fltr_ctx->flex_mdid = ICE_FXD_FLTR_QW0_FLEX_MDID0;
+	fd_fltr_ctx->flex_val = ICE_FXD_FLTR_QW0_FLEX_VAL0;
+	fd_fltr_ctx->dtype = ICE_TX_DESC_DTYPE_FLTR_PROG;
+	fd_fltr_ctx->desc_prof_prio = ICE_FXD_FLTR_QW1_PROF_PRIO_ZERO;
+	fd_fltr_ctx->desc_prof = ICE_FXD_FLTR_QW1_PROF_ZERO;
+	fd_fltr_ctx->swap = ICE_FXD_FLTR_QW1_SWAP_SET;
+	fd_fltr_ctx->fdid_prio = ICE_FXD_FLTR_QW1_FDID_PRI_ONE;
+	fd_fltr_ctx->fdid_mdid = ICE_FXD_FLTR_QW1_FDID_MDID_FD;
+	fd_fltr_ctx->fdid = ICE_FXD_FLTR_QW1_FDID_ZERO;
+}
+
+/**
+ * ice_set_fd_desc_val
+ * @ctx: pointer to fd filter descriptor context
+ * @fdir_desc: populated with fd filter descriptor values
+ */
+static void
+ice_set_fd_desc_val(struct ice_fd_fltr_desc_ctx *ctx,
+		    struct ice_fltr_desc *fdir_desc)
+{
+	u64 qword;
+
+	/* prep QW0 of FD filter programming desc */
+	qword = ((u64)ctx->qindex << ICE_FXD_FLTR_QW0_QINDEX_S) &
+		ICE_FXD_FLTR_QW0_QINDEX_M;
+	qword |= ((u64)ctx->comp_q << ICE_FXD_FLTR_QW0_COMP_Q_S) &
+		 ICE_FXD_FLTR_QW0_COMP_Q_M;
+	qword |= ((u64)ctx->comp_report << ICE_FXD_FLTR_QW0_COMP_REPORT_S) &
+		 ICE_FXD_FLTR_QW0_COMP_REPORT_M;
+	qword |= ((u64)ctx->fd_space << ICE_FXD_FLTR_QW0_FD_SPACE_S) &
+		 ICE_FXD_FLTR_QW0_FD_SPACE_M;
+	qword |= ((u64)ctx->cnt_index << ICE_FXD_FLTR_QW0_STAT_CNT_S) &
+		 ICE_FXD_FLTR_QW0_STAT_CNT_M;
+	qword |= ((u64)ctx->cnt_ena << ICE_FXD_FLTR_QW0_STAT_ENA_S) &
+		 ICE_FXD_FLTR_QW0_STAT_ENA_M;
+	qword |= ((u64)ctx->evict_ena << ICE_FXD_FLTR_QW0_EVICT_ENA_S) &
+		 ICE_FXD_FLTR_QW0_EVICT_ENA_M;
+	qword |= ((u64)ctx->toq << ICE_FXD_FLTR_QW0_TO_Q_S) &
+		 ICE_FXD_FLTR_QW0_TO_Q_M;
+	qword |= ((u64)ctx->toq_prio << ICE_FXD_FLTR_QW0_TO_Q_PRI_S) &
+		 ICE_FXD_FLTR_QW0_TO_Q_PRI_M;
+	qword |= ((u64)ctx->dpu_recipe << ICE_FXD_FLTR_QW0_DPU_RECIPE_S) &
+		 ICE_FXD_FLTR_QW0_DPU_RECIPE_M;
+	qword |= ((u64)ctx->drop << ICE_FXD_FLTR_QW0_DROP_S) &
+		 ICE_FXD_FLTR_QW0_DROP_M;
+	qword |= ((u64)ctx->flex_prio << ICE_FXD_FLTR_QW0_FLEX_PRI_S) &
+		 ICE_FXD_FLTR_QW0_FLEX_PRI_M;
+	qword |= ((u64)ctx->flex_mdid << ICE_FXD_FLTR_QW0_FLEX_MDID_S) &
+		 ICE_FXD_FLTR_QW0_FLEX_MDID_M;
+	qword |= ((u64)ctx->flex_val << ICE_FXD_FLTR_QW0_FLEX_VAL_S) &
+		 ICE_FXD_FLTR_QW0_FLEX_VAL_M;
+	fdir_desc->qidx_compq_space_stat = cpu_to_le64(qword);
+
+	/* prep QW1 of FD filter programming desc */
+	qword = ((u64)ctx->dtype << ICE_FXD_FLTR_QW1_DTYPE_S) &
+		ICE_FXD_FLTR_QW1_DTYPE_M;
+	qword |= ((u64)ctx->pcmd << ICE_FXD_FLTR_QW1_PCMD_S) &
+		 ICE_FXD_FLTR_QW1_PCMD_M;
+	qword |= ((u64)ctx->desc_prof_prio << ICE_FXD_FLTR_QW1_PROF_PRI_S) &
+		 ICE_FXD_FLTR_QW1_PROF_PRI_M;
+	qword |= ((u64)ctx->desc_prof << ICE_FXD_FLTR_QW1_PROF_S) &
+		 ICE_FXD_FLTR_QW1_PROF_M;
+	qword |= ((u64)ctx->fd_vsi << ICE_FXD_FLTR_QW1_FD_VSI_S) &
+		 ICE_FXD_FLTR_QW1_FD_VSI_M;
+	qword |= ((u64)ctx->swap << ICE_FXD_FLTR_QW1_SWAP_S) &
+		 ICE_FXD_FLTR_QW1_SWAP_M;
+	qword |= ((u64)ctx->fdid_prio << ICE_FXD_FLTR_QW1_FDID_PRI_S) &
+		 ICE_FXD_FLTR_QW1_FDID_PRI_M;
+	qword |= ((u64)ctx->fdid_mdid << ICE_FXD_FLTR_QW1_FDID_MDID_S) &
+		 ICE_FXD_FLTR_QW1_FDID_MDID_M;
+	qword |= ((u64)ctx->fdid << ICE_FXD_FLTR_QW1_FDID_S) &
+		 ICE_FXD_FLTR_QW1_FDID_M;
+	fdir_desc->dtype_cmd_vsi_fdid = cpu_to_le64(qword);
+}
+
+/**
+ * ice_fdir_get_prgm_desc - set a fdir descriptor from a fdir filter struct
+ * @hw: pointer to the hardware structure
+ * @input: filter
+ * @fdesc: filter descriptor
+ * @add: if add is true, this is an add operation, false implies delete
+ */
+void
+ice_fdir_get_prgm_desc(struct ice_hw *hw, struct ice_fdir_fltr *input,
+		       struct ice_fltr_desc *fdesc, bool add)
+{
+	struct ice_fd_fltr_desc_ctx fdir_fltr_ctx = { 0 };
+
+	/* set default context info */
+	ice_set_dflt_val_fd_desc(&fdir_fltr_ctx);
+
+	/* change sideband filtering values */
+	fdir_fltr_ctx.fdid = input->fltr_id;
+	if (input->dest_ctl == ICE_FLTR_PRGM_DESC_DEST_DROP_PKT) {
+		fdir_fltr_ctx.drop = ICE_FXD_FLTR_QW0_DROP_YES;
+		fdir_fltr_ctx.qindex = 0;
+	} else {
+		fdir_fltr_ctx.drop = ICE_FXD_FLTR_QW0_DROP_NO;
+		fdir_fltr_ctx.qindex = input->q_index;
+	}
+	fdir_fltr_ctx.cnt_ena = ICE_FXD_FLTR_QW0_STAT_ENA_PKTS;
+	fdir_fltr_ctx.cnt_index = input->cnt_index;
+	fdir_fltr_ctx.fd_vsi = ice_get_hw_vsi_num(hw, input->dest_vsi);
+	fdir_fltr_ctx.evict_ena = ICE_FXD_FLTR_QW0_EVICT_ENA_FALSE;
+	fdir_fltr_ctx.toq_prio = 3;
+	fdir_fltr_ctx.pcmd = add ? ICE_FXD_FLTR_QW1_PCMD_ADD :
+		ICE_FXD_FLTR_QW1_PCMD_REMOVE;
+	fdir_fltr_ctx.swap = ICE_FXD_FLTR_QW1_SWAP_NOT_SET;
+	fdir_fltr_ctx.comp_q = ICE_FXD_FLTR_QW0_COMP_Q_ZERO;
+	fdir_fltr_ctx.comp_report = ICE_FXD_FLTR_QW0_COMP_REPORT_SW_FAIL;
+	fdir_fltr_ctx.fdid_prio = 3;
+	fdir_fltr_ctx.desc_prof = 1;
+	fdir_fltr_ctx.desc_prof_prio = 3;
+	ice_set_fd_desc_val(&fdir_fltr_ctx, fdesc);
+}
+
 /**
  * ice_alloc_fd_res_cntr - obtain counter resource for FD type
  * @hw: pointer to the hardware structure
@@ -64,6 +319,150 @@ int ice_get_fdir_cnt_all(struct ice_hw *hw)
 	return hw->func_caps.fd_fltr_guar + hw->func_caps.fd_fltr_best_effort;
 }
 
+/**
+ * ice_pkt_insert_u16 - insert a be16 value into a memory buffer
+ * @pkt: packet buffer
+ * @offset: offset into buffer
+ * @data: 16 bit value to convert and insert into pkt at offset
+ */
+static void ice_pkt_insert_u16(u8 *pkt, int offset, __be16 data)
+{
+	memcpy(pkt + offset, &data, sizeof(data));
+}
+
+/**
+ * ice_pkt_insert_u32 - insert a be32 value into a memory buffer
+ * @pkt: packet buffer
+ * @offset: offset into buffer
+ * @data: 32 bit value to convert and insert into pkt at offset
+ */
+static void ice_pkt_insert_u32(u8 *pkt, int offset, __be32 data)
+{
+	memcpy(pkt + offset, &data, sizeof(data));
+}
+
+/**
+ * ice_fdir_get_gen_prgm_pkt - generate a training packet
+ * @hw: pointer to the hardware structure
+ * @input: flow director filter data structure
+ * @pkt: pointer to return filter packet
+ * @frag: generate a fragment packet
+ * @tun: true implies generate a tunnel packet
+ */
+enum ice_status
+ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
+			  u8 *pkt, bool frag, bool tun)
+{
+	enum ice_fltr_ptype flow;
+	u16 tnl_port;
+	u8 *loc;
+	u16 idx;
+
+	if (input->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER) {
+		switch (input->ip.proto) {
+		case IPPROTO_TCP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV4_TCP;
+			break;
+		case IPPROTO_UDP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV4_UDP;
+			break;
+		case IPPROTO_SCTP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV4_SCTP;
+			break;
+		case IPPROTO_IP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV4_OTHER;
+			break;
+		default:
+			return ICE_ERR_PARAM;
+		}
+	} else {
+		flow = input->flow_type;
+	}
+
+	for (idx = 0; idx < ICE_FDIR_NUM_PKT; idx++)
+		if (ice_fdir_pkt[idx].flow == flow)
+			break;
+	if (idx == ICE_FDIR_NUM_PKT)
+		return ICE_ERR_PARAM;
+	if (!tun) {
+		memcpy(pkt, ice_fdir_pkt[idx].pkt, ice_fdir_pkt[idx].pkt_len);
+		loc = pkt;
+	} else {
+		if (!ice_get_open_tunnel_port(hw, TNL_ALL, &tnl_port))
+			return ICE_ERR_DOES_NOT_EXIST;
+		if (!ice_fdir_pkt[idx].tun_pkt)
+			return ICE_ERR_PARAM;
+		memcpy(pkt, ice_fdir_pkt[idx].tun_pkt,
+		       ice_fdir_pkt[idx].tun_pkt_len);
+		ice_pkt_insert_u16(pkt, ICE_IPV4_UDP_DST_PORT_OFFSET,
+				   htons(tnl_port));
+		loc = &pkt[ICE_FDIR_TUN_PKT_OFF];
+	}
+
+	/* Reverse the src and dst, since the HW expects them to be from Tx
+	 * perspective. The input from user is from Rx filter perspective.
+	 */
+	switch (flow) {
+	case ICE_FLTR_PTYPE_NONF_IPV4_TCP:
+		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
+				   input->ip.src_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_TCP_DST_PORT_OFFSET,
+				   input->ip.src_port);
+		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
+				   input->ip.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_TCP_SRC_PORT_OFFSET,
+				   input->ip.dst_port);
+		if (frag)
+			loc[20] = ICE_FDIR_IPV4_PKT_FLAG_DF;
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_UDP:
+		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
+				   input->ip.src_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_UDP_DST_PORT_OFFSET,
+				   input->ip.src_port);
+		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
+				   input->ip.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_UDP_SRC_PORT_OFFSET,
+				   input->ip.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_SCTP:
+		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
+				   input->ip.src_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_SCTP_DST_PORT_OFFSET,
+				   input->ip.src_port);
+		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
+				   input->ip.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_SCTP_SRC_PORT_OFFSET,
+				   input->ip.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
+		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
+				   input->ip.src_ip);
+		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
+				   input->ip.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV4_PROTO_OFFSET, 0);
+		break;
+	default:
+		return ICE_ERR_PARAM;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_fdir_has_frag - does flow type have 2 ptypes
+ * @flow: flow ptype
+ *
+ * returns true is there is a fragment packet for this ptype
+ */
+bool ice_fdir_has_frag(enum ice_fltr_ptype flow)
+{
+	if (flow == ICE_FLTR_PTYPE_NONF_IPV4_OTHER)
+		return true;
+	else
+		return false;
+}
+
 /**
  * ice_fdir_find_by_idx - find filter with idx
  * @hw: pointer to hardware structure
@@ -85,3 +484,117 @@ ice_fdir_find_fltr_by_idx(struct ice_hw *hw, u32 fltr_idx)
 	}
 	return NULL;
 }
+
+/**
+ * ice_fdir_list_add_fltr - add a new node to the flow director filter list
+ * @hw: hardware structure
+ * @fltr: filter node to add to structure
+ */
+void ice_fdir_list_add_fltr(struct ice_hw *hw, struct ice_fdir_fltr *fltr)
+{
+	struct ice_fdir_fltr *rule, *parent = NULL;
+
+	list_for_each_entry(rule, &hw->fdir_list_head, fltr_node) {
+		/* rule ID found or pass its spot in the list */
+		if (rule->fltr_id >= fltr->fltr_id)
+			break;
+		parent = rule;
+	}
+
+	if (parent)
+		list_add(&fltr->fltr_node, &parent->fltr_node);
+	else
+		list_add(&fltr->fltr_node, &hw->fdir_list_head);
+}
+
+/**
+ * ice_fdir_update_cntrs - increment / decrement filter counter
+ * @hw: pointer to hardware structure
+ * @flow: filter flow type
+ * @add: true implies filters added
+ */
+void
+ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow, bool add)
+{
+	int incr;
+
+	incr = add ? 1 : -1;
+	hw->fdir_active_fltr += incr;
+
+	if (flow == ICE_FLTR_PTYPE_NONF_NONE || flow >= ICE_FLTR_PTYPE_MAX)
+		ice_debug(hw, ICE_DBG_SW, "Unknown filter type %d\n", flow);
+	else
+		hw->fdir_fltr_cnt[flow] += incr;
+}
+
+/**
+ * ice_fdir_comp_rules - compare 2 filters
+ * @a: a Flow Director filter data structure
+ * @b: a Flow Director filter data structure
+ *
+ * Returns true if the filters match
+ */
+static bool
+ice_fdir_comp_rules(struct ice_fdir_fltr *a,  struct ice_fdir_fltr *b)
+{
+	enum ice_fltr_ptype flow_type = a->flow_type;
+
+	/* The calling function already checks that the two filters have the
+	 * same flow_type.
+	 */
+	if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+	    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+	    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_SCTP) {
+		if (a->ip.dst_ip == b->ip.dst_ip &&
+		    a->ip.src_ip == b->ip.src_ip &&
+		    a->ip.dst_port == b->ip.dst_port &&
+		    a->ip.src_port == b->ip.src_port)
+			return true;
+	} else if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER) {
+		if (a->ip.dst_ip == b->ip.dst_ip &&
+		    a->ip.src_ip == b->ip.src_ip &&
+		    a->ip.l4_header == b->ip.l4_header &&
+		    a->ip.proto == b->ip.proto &&
+		    a->ip.ip_ver == b->ip.ip_ver &&
+		    a->ip.tos == b->ip.tos)
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_fdir_is_dup_fltr - test if filter is already in list for PF
+ * @hw: hardware data structure
+ * @input: Flow Director filter data structure
+ *
+ * Returns true if the filter is found in the list
+ */
+bool ice_fdir_is_dup_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input)
+{
+	struct ice_fdir_fltr *rule;
+	bool ret = false;
+
+	list_for_each_entry(rule, &hw->fdir_list_head, fltr_node) {
+		enum ice_fltr_ptype flow_type;
+
+		if (rule->flow_type != input->flow_type)
+			continue;
+
+		flow_type = input->flow_type;
+		if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_SCTP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER)
+			ret = ice_fdir_comp_rules(rule, input);
+		if (ret) {
+			if (rule->fltr_id == input->fltr_id &&
+			    rule->q_index != input->q_index)
+				ret = false;
+			else
+				break;
+		}
+	}
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 1b69249b40c1..1a13c80e1eac 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -4,11 +4,70 @@
 #ifndef _ICE_FDIR_H_
 #define _ICE_FDIR_H_
 
+#define ICE_FDIR_TUN_PKT_OFF		50
+#define ICE_FDIR_MAX_RAW_PKT_SIZE	(512 + ICE_FDIR_TUN_PKT_OFF)
+
+/* macros for offsets into packets for flow director programming */
+#define ICE_IPV4_SRC_ADDR_OFFSET	26
+#define ICE_IPV4_DST_ADDR_OFFSET	30
+#define ICE_IPV4_TCP_SRC_PORT_OFFSET	34
+#define ICE_IPV4_TCP_DST_PORT_OFFSET	36
+#define ICE_IPV4_UDP_SRC_PORT_OFFSET	34
+#define ICE_IPV4_UDP_DST_PORT_OFFSET	36
+#define ICE_IPV4_SCTP_SRC_PORT_OFFSET	34
+#define ICE_IPV4_SCTP_DST_PORT_OFFSET	36
+#define ICE_IPV4_PROTO_OFFSET		23
+#define ICE_IPV6_SRC_ADDR_OFFSET	22
+#define ICE_IPV6_DST_ADDR_OFFSET	38
+#define ICE_IPV6_TCP_SRC_PORT_OFFSET	54
+#define ICE_IPV6_TCP_DST_PORT_OFFSET	56
+#define ICE_IPV6_UDP_SRC_PORT_OFFSET	54
+#define ICE_IPV6_UDP_DST_PORT_OFFSET	56
+#define ICE_IPV6_SCTP_SRC_PORT_OFFSET	54
+#define ICE_IPV6_SCTP_DST_PORT_OFFSET	56
+/* IP v4 has 2 flag bits that enable fragment processing: DF and MF. DF
+ * requests that the packet not be fragmented. MF indicates that a packet has
+ * been fragmented.
+ */
+#define ICE_FDIR_IPV4_PKT_FLAG_DF		0x20
+
 enum ice_fltr_prgm_desc_dest {
 	ICE_FLTR_PRGM_DESC_DEST_DROP_PKT,
 	ICE_FLTR_PRGM_DESC_DEST_DIRECT_PKT_QINDEX,
 };
 
+enum ice_fltr_prgm_desc_fd_status {
+	ICE_FLTR_PRGM_DESC_FD_STATUS_NONE,
+	ICE_FLTR_PRGM_DESC_FD_STATUS_FD_ID,
+};
+
+/* Flow Director (FD) Filter Programming descriptor */
+struct ice_fd_fltr_desc_ctx {
+	u32 fdid;
+	u16 qindex;
+	u16 cnt_index;
+	u16 fd_vsi;
+	u16 flex_val;
+	u8 comp_q;
+	u8 comp_report;
+	u8 fd_space;
+	u8 cnt_ena;
+	u8 evict_ena;
+	u8 toq;
+	u8 toq_prio;
+	u8 dpu_recipe;
+	u8 drop;
+	u8 flex_prio;
+	u8 flex_mdid;
+	u8 dtype;
+	u8 pcmd;
+	u8 desc_prof_prio;
+	u8 desc_prof;
+	u8 swap;
+	u8 fdid_prio;
+	u8 fdid_mdid;
+};
+
 struct ice_fdir_v4 {
 	__be32 dst_ip;
 	__be32 src_ip;
@@ -47,13 +106,33 @@ struct ice_fdir_fltr {
 	u32 fltr_id;
 };
 
+/* Dummy packet filter definition structure */
+struct ice_fdir_base_pkt {
+	enum ice_fltr_ptype flow;
+	u16 pkt_len;
+	const u8 *pkt;
+	u16 tun_pkt_len;
+	const u8 *tun_pkt;
+};
+
 enum ice_status ice_alloc_fd_res_cntr(struct ice_hw *hw, u16 *cntr_id);
 enum ice_status ice_free_fd_res_cntr(struct ice_hw *hw, u16 cntr_id);
 enum ice_status
 ice_alloc_fd_guar_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr);
 enum ice_status
 ice_alloc_fd_shrd_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr);
+void
+ice_fdir_get_prgm_desc(struct ice_hw *hw, struct ice_fdir_fltr *input,
+		       struct ice_fltr_desc *fdesc, bool add);
+enum ice_status
+ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
+			  u8 *pkt, bool frag, bool tun);
 int ice_get_fdir_cnt_all(struct ice_hw *hw);
+bool ice_fdir_is_dup_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input);
+bool ice_fdir_has_frag(enum ice_fltr_ptype flow);
 struct ice_fdir_fltr *
 ice_fdir_find_fltr_by_idx(struct ice_hw *hw, u32 fltr_idx);
+void
+ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow, bool add);
+void ice_fdir_list_add_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input);
 #endif /* _ICE_FDIR_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index fe2f04f706e7..16d2f599bd70 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1632,6 +1632,34 @@ ice_find_free_tunnel_entry(struct ice_hw *hw, enum ice_tunnel_type type,
 	return false;
 }
 
+/**
+ * ice_get_open_tunnel_port - retrieve an open tunnel port
+ * @hw: pointer to the HW structure
+ * @type: tunnel type (TNL_ALL will return any open port)
+ * @port: returns open port
+ */
+bool
+ice_get_open_tunnel_port(struct ice_hw *hw, enum ice_tunnel_type type,
+			 u16 *port)
+{
+	bool res = false;
+	u16 i;
+
+	mutex_lock(&hw->tnl_lock);
+
+	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
+		    (type == TNL_ALL || hw->tnl.tbl[i].type == type)) {
+			*port = hw->tnl.tbl[i].port;
+			res = true;
+			break;
+		}
+
+	mutex_unlock(&hw->tnl_lock);
+
+	return res;
+}
+
 /**
  * ice_create_tunnel
  * @hw: pointer to the HW structure
@@ -2332,6 +2360,12 @@ ice_find_prof_id(struct ice_hw *hw, enum ice_block blk,
 	u16 off;
 	u8 i;
 
+	/* For FD, we don't want to re-use a existed profile with the same
+	 * field vector and mask. This will cause rule interference.
+	 */
+	if (blk == ICE_BLK_FD)
+		return ICE_ERR_DOES_NOT_EXIST;
+
 	for (i = 0; i < (u8)es->count; i++) {
 		off = i * es->fvw;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 70db213c9fe3..568ea519af51 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -18,6 +18,9 @@
 
 #define ICE_PKG_CNT 4
 
+bool
+ice_get_open_tunnel_port(struct ice_hw *hw, enum ice_tunnel_type type,
+			 u16 *port);
 enum ice_status
 ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port);
 enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all);
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 3376cdf5667f..c8b037d25053 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -290,6 +290,9 @@
 #define GL_PWR_MODE_CTL				0x000B820C
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_S		30
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_M		ICE_M(0x3, 30)
+#define GLQF_FD_CNT				0x00460018
+#define GLQF_FD_CNT_FD_BCNT_S			16
+#define GLQF_FD_CNT_FD_BCNT_M			ICE_M(0x7FFF, 16)
 #define GLQF_FD_SIZE				0x00460010
 #define GLQF_FD_SIZE_FD_GSIZE_S			0
 #define GLQF_FD_SIZE_FD_GSIZE_M			ICE_M(0x7FFF, 0)
@@ -355,6 +358,9 @@
 #define GLV_TEPC(_VSI)				(0x00312000 + ((_VSI) * 4))
 #define GLV_UPRCL(_i)				(0x003B2000 + ((_i) * 8))
 #define GLV_UPTCL(_i)				(0x0030A000 + ((_i) * 8))
+#define VSIQF_FD_CNT(_VSI)			(0x00464000 + ((_VSI) * 4))
+#define VSIQF_FD_CNT_FD_GCNT_S			0
+#define VSIQF_FD_CNT_FD_GCNT_M			ICE_M(0x3FFF, 0)
 #define VSIQF_HKEY_MAX_INDEX			12
 #define VSIQF_HLUT_MAX_INDEX			15
 #define VFINT_DYN_CTLN(_i)			(0x00003800 + ((_i) * 4))
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 5d61acdec7ed..bd2cd3435768 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -40,6 +40,104 @@ union ice_32byte_rx_desc {
 	} wb; /* writeback */
 };
 
+struct ice_fltr_desc {
+	__le64 qidx_compq_space_stat;
+	__le64 dtype_cmd_vsi_fdid;
+};
+
+#define ICE_FXD_FLTR_QW0_QINDEX_S	0
+#define ICE_FXD_FLTR_QW0_QINDEX_M	(0x7FFULL << ICE_FXD_FLTR_QW0_QINDEX_S)
+#define ICE_FXD_FLTR_QW0_COMP_Q_S	11
+#define ICE_FXD_FLTR_QW0_COMP_Q_M	BIT_ULL(ICE_FXD_FLTR_QW0_COMP_Q_S)
+#define ICE_FXD_FLTR_QW0_COMP_Q_ZERO	0x0ULL
+
+#define ICE_FXD_FLTR_QW0_COMP_REPORT_S	12
+#define ICE_FXD_FLTR_QW0_COMP_REPORT_M	\
+				(0x3ULL << ICE_FXD_FLTR_QW0_COMP_REPORT_S)
+#define ICE_FXD_FLTR_QW0_COMP_REPORT_SW_FAIL	0x1ULL
+
+#define ICE_FXD_FLTR_QW0_FD_SPACE_S	14
+#define ICE_FXD_FLTR_QW0_FD_SPACE_M	(0x3ULL << ICE_FXD_FLTR_QW0_FD_SPACE_S)
+#define ICE_FXD_FLTR_QW0_FD_SPACE_GUAR_BEST		0x2ULL
+
+#define ICE_FXD_FLTR_QW0_STAT_CNT_S	16
+#define ICE_FXD_FLTR_QW0_STAT_CNT_M	\
+				(0x1FFFULL << ICE_FXD_FLTR_QW0_STAT_CNT_S)
+#define ICE_FXD_FLTR_QW0_STAT_ENA_S	29
+#define ICE_FXD_FLTR_QW0_STAT_ENA_M	(0x3ULL << ICE_FXD_FLTR_QW0_STAT_ENA_S)
+#define ICE_FXD_FLTR_QW0_STAT_ENA_PKTS		0x1ULL
+
+#define ICE_FXD_FLTR_QW0_EVICT_ENA_S	31
+#define ICE_FXD_FLTR_QW0_EVICT_ENA_M	BIT_ULL(ICE_FXD_FLTR_QW0_EVICT_ENA_S)
+#define ICE_FXD_FLTR_QW0_EVICT_ENA_FALSE	0x0ULL
+#define ICE_FXD_FLTR_QW0_EVICT_ENA_TRUE		0x1ULL
+
+#define ICE_FXD_FLTR_QW0_TO_Q_S		32
+#define ICE_FXD_FLTR_QW0_TO_Q_M		(0x7ULL << ICE_FXD_FLTR_QW0_TO_Q_S)
+#define ICE_FXD_FLTR_QW0_TO_Q_EQUALS_QINDEX	0x0ULL
+
+#define ICE_FXD_FLTR_QW0_TO_Q_PRI_S	35
+#define ICE_FXD_FLTR_QW0_TO_Q_PRI_M	(0x7ULL << ICE_FXD_FLTR_QW0_TO_Q_PRI_S)
+#define ICE_FXD_FLTR_QW0_TO_Q_PRIO1	0x1ULL
+
+#define ICE_FXD_FLTR_QW0_DPU_RECIPE_S	38
+#define ICE_FXD_FLTR_QW0_DPU_RECIPE_M	\
+			(0x3ULL << ICE_FXD_FLTR_QW0_DPU_RECIPE_S)
+#define ICE_FXD_FLTR_QW0_DPU_RECIPE_DFLT	0x0ULL
+
+#define ICE_FXD_FLTR_QW0_DROP_S		40
+#define ICE_FXD_FLTR_QW0_DROP_M		BIT_ULL(ICE_FXD_FLTR_QW0_DROP_S)
+#define ICE_FXD_FLTR_QW0_DROP_NO	0x0ULL
+#define ICE_FXD_FLTR_QW0_DROP_YES	0x1ULL
+
+#define ICE_FXD_FLTR_QW0_FLEX_PRI_S	41
+#define ICE_FXD_FLTR_QW0_FLEX_PRI_M	(0x7ULL << ICE_FXD_FLTR_QW0_FLEX_PRI_S)
+#define ICE_FXD_FLTR_QW0_FLEX_PRI_NONE	0x0ULL
+
+#define ICE_FXD_FLTR_QW0_FLEX_MDID_S	44
+#define ICE_FXD_FLTR_QW0_FLEX_MDID_M	(0xFULL << ICE_FXD_FLTR_QW0_FLEX_MDID_S)
+#define ICE_FXD_FLTR_QW0_FLEX_MDID0	0x0ULL
+
+#define ICE_FXD_FLTR_QW0_FLEX_VAL_S	48
+#define ICE_FXD_FLTR_QW0_FLEX_VAL_M	\
+				(0xFFFFULL << ICE_FXD_FLTR_QW0_FLEX_VAL_S)
+#define ICE_FXD_FLTR_QW0_FLEX_VAL0	0x0ULL
+
+#define ICE_FXD_FLTR_QW1_DTYPE_S	0
+#define ICE_FXD_FLTR_QW1_DTYPE_M	(0xFULL << ICE_FXD_FLTR_QW1_DTYPE_S)
+#define ICE_FXD_FLTR_QW1_PCMD_S		4
+#define ICE_FXD_FLTR_QW1_PCMD_M		BIT_ULL(ICE_FXD_FLTR_QW1_PCMD_S)
+#define ICE_FXD_FLTR_QW1_PCMD_ADD	0x0ULL
+#define ICE_FXD_FLTR_QW1_PCMD_REMOVE	0x1ULL
+
+#define ICE_FXD_FLTR_QW1_PROF_PRI_S	5
+#define ICE_FXD_FLTR_QW1_PROF_PRI_M	(0x7ULL << ICE_FXD_FLTR_QW1_PROF_PRI_S)
+#define ICE_FXD_FLTR_QW1_PROF_PRIO_ZERO	0x0ULL
+
+#define ICE_FXD_FLTR_QW1_PROF_S		8
+#define ICE_FXD_FLTR_QW1_PROF_M		(0x3FULL << ICE_FXD_FLTR_QW1_PROF_S)
+#define ICE_FXD_FLTR_QW1_PROF_ZERO	0x0ULL
+
+#define ICE_FXD_FLTR_QW1_FD_VSI_S	14
+#define ICE_FXD_FLTR_QW1_FD_VSI_M	(0x3FFULL << ICE_FXD_FLTR_QW1_FD_VSI_S)
+#define ICE_FXD_FLTR_QW1_SWAP_S		24
+#define ICE_FXD_FLTR_QW1_SWAP_M		BIT_ULL(ICE_FXD_FLTR_QW1_SWAP_S)
+#define ICE_FXD_FLTR_QW1_SWAP_NOT_SET	0x0ULL
+#define ICE_FXD_FLTR_QW1_SWAP_SET	0x1ULL
+
+#define ICE_FXD_FLTR_QW1_FDID_PRI_S	25
+#define ICE_FXD_FLTR_QW1_FDID_PRI_M	(0x7ULL << ICE_FXD_FLTR_QW1_FDID_PRI_S)
+#define ICE_FXD_FLTR_QW1_FDID_PRI_ONE	0x1ULL
+
+#define ICE_FXD_FLTR_QW1_FDID_MDID_S	28
+#define ICE_FXD_FLTR_QW1_FDID_MDID_M	(0xFULL << ICE_FXD_FLTR_QW1_FDID_MDID_S)
+#define ICE_FXD_FLTR_QW1_FDID_MDID_FD	0x05ULL
+
+#define ICE_FXD_FLTR_QW1_FDID_S		32
+#define ICE_FXD_FLTR_QW1_FDID_M		\
+			(0xFFFFFFFFULL << ICE_FXD_FLTR_QW1_FDID_S)
+#define ICE_FXD_FLTR_QW1_FDID_ZERO	0x0ULL
+
 struct ice_rx_ptype_decoded {
 	u32 ptype:10;
 	u32 known:1;
@@ -346,6 +444,7 @@ struct ice_tx_desc {
 enum ice_tx_desc_dtype_value {
 	ICE_TX_DESC_DTYPE_DATA		= 0x0,
 	ICE_TX_DESC_DTYPE_CTX		= 0x1,
+	ICE_TX_DESC_DTYPE_FLTR_PROG	= 0x8,
 	/* DESC_DONE - HW has completed write-back of descriptor */
 	ICE_TX_DESC_DTYPE_DESC_DONE	= 0xF,
 };
@@ -357,12 +456,14 @@ enum ice_tx_desc_cmd_bits {
 	ICE_TX_DESC_CMD_EOP			= 0x0001,
 	ICE_TX_DESC_CMD_RS			= 0x0002,
 	ICE_TX_DESC_CMD_IL2TAG1			= 0x0008,
+	ICE_TX_DESC_CMD_DUMMY			= 0x0010,
 	ICE_TX_DESC_CMD_IIPT_IPV6		= 0x0020,
 	ICE_TX_DESC_CMD_IIPT_IPV4		= 0x0040,
 	ICE_TX_DESC_CMD_IIPT_IPV4_CSUM		= 0x0060,
 	ICE_TX_DESC_CMD_L4T_EOFT_TCP		= 0x0100,
 	ICE_TX_DESC_CMD_L4T_EOFT_SCTP		= 0x0200,
 	ICE_TX_DESC_CMD_L4T_EOFT_UDP		= 0x0300,
+	ICE_TX_DESC_CMD_RE			= 0x0400,
 };
 
 #define ICE_TXD_QW1_OFFSET_S	16
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 173a167c96d9..cda7e05bd8ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -16,6 +16,88 @@
 #define ICE_RX_HDR_SIZE		256
 
 #define FDIR_DESC_RXDID 0x40
+#define ICE_FDIR_CLEAN_DELAY 10
+
+/**
+ * ice_prgm_fdir_fltr - Program a Flow Director filter
+ * @vsi: VSI to send dummy packet
+ * @fdir_desc: flow director descriptor
+ * @raw_packet: allocated buffer for flow director
+ */
+int
+ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
+		   u8 *raw_packet)
+{
+	struct ice_tx_buf *tx_buf, *first;
+	struct ice_fltr_desc *f_desc;
+	struct ice_tx_desc *tx_desc;
+	struct ice_ring *tx_ring;
+	struct device *dev;
+	dma_addr_t dma;
+	u32 td_cmd;
+	u16 i;
+
+	/* VSI and Tx ring */
+	if (!vsi)
+		return -ENOENT;
+	tx_ring = vsi->tx_rings[0];
+	if (!tx_ring || !tx_ring->desc)
+		return -ENOENT;
+	dev = tx_ring->dev;
+
+	/* we are using two descriptors to add/del a filter and we can wait */
+	for (i = ICE_FDIR_CLEAN_DELAY; ICE_DESC_UNUSED(tx_ring) < 2; i--) {
+		if (!i)
+			return -EAGAIN;
+		msleep_interruptible(1);
+	}
+
+	dma = dma_map_single(dev, raw_packet, ICE_FDIR_MAX_RAW_PKT_SIZE,
+			     DMA_TO_DEVICE);
+
+	if (dma_mapping_error(dev, dma))
+		return -EINVAL;
+
+	/* grab the next descriptor */
+	i = tx_ring->next_to_use;
+	first = &tx_ring->tx_buf[i];
+	f_desc = ICE_TX_FDIRDESC(tx_ring, i);
+	memcpy(f_desc, fdir_desc, sizeof(*f_desc));
+
+	i++;
+	i = (i < tx_ring->count) ? i : 0;
+	tx_desc = ICE_TX_DESC(tx_ring, i);
+	tx_buf = &tx_ring->tx_buf[i];
+
+	i++;
+	tx_ring->next_to_use = (i < tx_ring->count) ? i : 0;
+
+	memset(tx_buf, 0, sizeof(*tx_buf));
+	dma_unmap_len_set(tx_buf, len, ICE_FDIR_MAX_RAW_PKT_SIZE);
+	dma_unmap_addr_set(tx_buf, dma, dma);
+
+	tx_desc->buf_addr = cpu_to_le64(dma);
+	td_cmd = ICE_TXD_LAST_DESC_CMD | ICE_TX_DESC_CMD_DUMMY |
+		 ICE_TX_DESC_CMD_RE;
+
+	tx_buf->tx_flags = ICE_TX_FLAGS_DUMMY_PKT;
+	tx_buf->raw_buf = raw_packet;
+
+	tx_desc->cmd_type_offset_bsz =
+		ice_build_ctob(td_cmd, 0, ICE_FDIR_MAX_RAW_PKT_SIZE, 0);
+
+	/* Force memory write to complete before letting h/w know
+	 * there are new descriptors to fetch.
+	 */
+	wmb();
+
+	/* mark the data descriptor to be watched */
+	first->next_to_watch = tx_desc;
+
+	writel(tx_ring->next_to_use, tx_ring->tail);
+
+	return 0;
+}
 
 /**
  * ice_unmap_and_free_tx_buf - Release a Tx buffer
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 2209583c993e..7c4030caeea4 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -380,6 +380,9 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring);
 void ice_free_tx_ring(struct ice_ring *tx_ring);
 void ice_free_rx_ring(struct ice_ring *rx_ring);
 int ice_napi_poll(struct napi_struct *napi, int budget);
+int
+ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc *fdir_desc,
+		   u8 *raw_packet);
 int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget);
 void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring);
 #endif /* _ICE_TXRX_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 0c14d89f7be9..fcf1f7853a41 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -628,6 +628,12 @@ struct ice_hw {
 	struct mutex fdir_fltr_lock;	/* protect Flow Director */
 	struct list_head fdir_list_head;
 
+	/* Book-keeping of side-band filter count per flow-type.
+	 * This is used to detect and handle input set changes for
+	 * respective flow-type.
+	 */
+	u16 fdir_fltr_cnt[ICE_FLTR_PTYPE_MAX];
+
 	struct ice_fd_hw_prof **fdir_prof;
 	DECLARE_BITMAP(fdir_perfect_fltr, ICE_FLTR_PTYPE_MAX);
 	struct mutex rss_locks;	/* protect RSS configuration */
-- 
2.26.2

