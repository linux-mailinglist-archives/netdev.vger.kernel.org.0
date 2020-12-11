Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D602D7BDD
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392519AbgLKRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:01:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:8167 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732919AbgLKRAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:22 -0500
IronPort-SDR: QPlo1bfbmQqMJVplGl1KroOBENp015rNVgsUSSq+KFI9OoCuKgCgb+K67+D2xY1C4Ck6QHWCzB
 8r+r/4wR8g4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055088"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055088"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:33 -0800
IronPort-SDR: Iou2Q7yI/EV3Qetc1xbiY9EdU2I5jCy9+4XCwqYDv0H1npUanUSZ4cgjuSdxerWzZVwMy+DfOc
 WbSvpEqhk91Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497531"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:31 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 4/8] ice: simplify ice_run_xdp
Date:   Fri, 11 Dec 2020 17:49:52 +0100
Message-Id: <20201211164956.59628-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for 'result' variable, we can directly return the
internal status based on action returned by xdp prog.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 77d5eae6b4c2..8b5d23436904 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -537,22 +537,20 @@ static int
 ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	    struct bpf_prog *xdp_prog)
 {
-	int err, result = ICE_XDP_PASS;
 	struct ice_ring *xdp_ring;
+	int err;
 	u32 act;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
-		break;
+		return ICE_XDP_PASS;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		result = ice_xmit_xdp_buff(xdp, xdp_ring);
-		break;
+		return ice_xmit_xdp_buff(xdp, xdp_ring);
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
-		break;
+		return !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
@@ -560,11 +558,8 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		result = ICE_XDP_CONSUMED;
-		break;
+		return ICE_XDP_CONSUMED;
 	}
-
-	return result;
 }
 
 /**
-- 
2.20.1

