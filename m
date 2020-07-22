Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FC9228D96
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbgGVB1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731647AbgGVB11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 21:27:27 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4438206F5;
        Wed, 22 Jul 2020 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595381247;
        bh=gCBaNpelK/DmFJNIyGTV4tF3eNwE+WbFXDoLS6rSeUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vesBwc1m7D9zR2Q0+mYjJ6UVXnPmtrJdDLd4fHX5UxnITEHzcySQ1HislVEeX+nZf
         kdDH04p47hnaowzcAApnN051KfH8a15pVZmwnZF03XD7DsXOrY5XA6gpsASMSbye8H
         6EH5JCNJAn3BVrfvyUzks5qFW8v/gMRcqI5OmEXY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v1 6/7] ice: remove unused args from ice_get_open_tunnel_port()
Date:   Tue, 21 Jul 2020 18:27:15 -0700
Message-Id: <20200722012716.2814777-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722012716.2814777-1-kuba@kernel.org>
References: <20200722012716.2814777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_get_open_tunnel_port() is always passed TNL_ALL
as the second parameter.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 6 ++----
 drivers/net/ethernet/intel/ice/ice_fdir.c         | 2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c    | 7 ++-----
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h    | 3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index d7430ce6af26..2d27f66ac853 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1268,8 +1268,7 @@ ice_fdir_write_all_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input,
 		bool is_tun = tun == ICE_FD_HW_SEG_TUN;
 		int err;
 
-		if (is_tun && !ice_get_open_tunnel_port(&pf->hw, TNL_ALL,
-							&port_num))
+		if (is_tun && !ice_get_open_tunnel_port(&pf->hw, &port_num))
 			continue;
 		err = ice_fdir_write_fltr(pf, input, add, is_tun);
 		if (err)
@@ -1647,8 +1646,7 @@ int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	}
 
 	/* return error if not an update and no available filters */
-	fltrs_needed = ice_get_open_tunnel_port(hw, TNL_ALL, &tunnel_port) ?
-		2 : 1;
+	fltrs_needed = ice_get_open_tunnel_port(hw, &tunnel_port) ? 2 : 1;
 	if (!ice_fdir_find_fltr_by_idx(hw, fsp->location) &&
 	    ice_fdir_num_avail_fltr(hw, pf->vsi[vsi->idx]) < fltrs_needed) {
 		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 6834df14332f..59c0c6a0f8c5 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -556,7 +556,7 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		memcpy(pkt, ice_fdir_pkt[idx].pkt, ice_fdir_pkt[idx].pkt_len);
 		loc = pkt;
 	} else {
-		if (!ice_get_open_tunnel_port(hw, TNL_ALL, &tnl_port))
+		if (!ice_get_open_tunnel_port(hw, &tnl_port))
 			return ICE_ERR_DOES_NOT_EXIST;
 		if (!ice_fdir_pkt[idx].tun_pkt)
 			return ICE_ERR_PARAM;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 3c217e51b27e..a60c5b2a0aed 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1696,12 +1696,10 @@ ice_find_free_tunnel_entry(struct ice_hw *hw, enum ice_tunnel_type type,
 /**
  * ice_get_open_tunnel_port - retrieve an open tunnel port
  * @hw: pointer to the HW structure
- * @type: tunnel type (TNL_ALL will return any open port)
  * @port: returns open port
  */
 bool
-ice_get_open_tunnel_port(struct ice_hw *hw, enum ice_tunnel_type type,
-			 u16 *port)
+ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
 {
 	bool res = false;
 	u16 i;
@@ -1709,8 +1707,7 @@ ice_get_open_tunnel_port(struct ice_hw *hw, enum ice_tunnel_type type,
 	mutex_lock(&hw->tnl_lock);
 
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use &&
-		    (type == TNL_ALL || hw->tnl.tbl[i].type == type)) {
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].in_use) {
 			*port = hw->tnl.tbl[i].port;
 			res = true;
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 568ea519af51..a18c87d9d9b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -19,8 +19,7 @@
 #define ICE_PKG_CNT 4
 
 bool
-ice_get_open_tunnel_port(struct ice_hw *hw, enum ice_tunnel_type type,
-			 u16 *port);
+ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port);
 enum ice_status
 ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port);
 enum ice_status ice_destroy_tunnel(struct ice_hw *hw, u16 port, bool all);
-- 
2.26.2

