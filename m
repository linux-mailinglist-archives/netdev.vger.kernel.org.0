Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACF12795BF
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgIZA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgIZA46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 20:56:58 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3BAA23772;
        Sat, 26 Sep 2020 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601081818;
        bh=kejfQeUelg3z0XWnuU2PVqy4x+dsv/AMTw+kL6i2jcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmJzaHDFj70XkMYl9kpBhe1ifEPcih1Jbnzx4K496VU0zo0deugBNgqNzmR9stFoe
         uaCBKF14gBqT3wIDiFYpaumWmYj/FqBv/f3IGNpOS1vmVR0+TbEB1Y+heXTY95wCNk
         kUUCNHd0QTosmUMaq/J0E5f0ewo1+3xdHG898CzE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net-next v2 06/10] ice: remove unused args from ice_get_open_tunnel_port()
Date:   Fri, 25 Sep 2020 17:56:45 -0700
Message-Id: <20200926005649.3285089-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
References: <20200926005649.3285089-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_get_open_tunnel_port() is always passed TNL_ALL
as the second parameter.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
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
index b17ae3e20157..a90be061e552 100644
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

