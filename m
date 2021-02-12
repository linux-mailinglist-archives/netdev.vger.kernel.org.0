Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94C731A7F9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhBLWpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:45:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:44414 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhBLWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:42:20 -0500
IronPort-SDR: 87dXojeOsKLCq3ua/kzy9F/yma2TpB1Y15IwyZ5hjo4Pg43WG7JxRbAHNQK4nZAJsZcsTEvzHj
 GliapYcaJ3Iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617159"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617159"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:00 -0800
IronPort-SDR: 4w94T3SaHDMkBc1NC87ikixQo2IWdcJNZBY5ngI8WSoZ+m0iBZVSlfaprGnyORcRRGRd8o7biG
 lBqf5sJqT8MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885359"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 04/11] ice: simplify ice_run_xdp
Date:   Fri, 12 Feb 2021 14:39:45 -0800
Message-Id: <20210212223952.1172568-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

There's no need for 'result' variable, we can directly return the
internal status based on action returned by xdp prog.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 580419813bb2..47d8100159c5 100644
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
2.26.2

