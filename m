Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3568A33D9B0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhCPQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:42:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:7047 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238798AbhCPQlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 12:41:37 -0400
IronPort-SDR: PxPMCs5qCq9RplNbw4UoE65NTgXTKi6pOPwVxpm9WiOh/QG4AZajcazgg1Ip+AyDbNfhaMgdlS
 RkOPCkNXK/vA==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="176890024"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="176890024"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 09:41:34 -0700
IronPort-SDR: AjRXu+C+jPZnVyfnKav9xeGoDpu13eEYOmisYNfPFZOVA+4DHEScQ24t490NEQSRTuJg7QKp+o
 RjQfAZVlRfZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="440138173"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2021 09:41:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com,
        Vishakha Jambekar <vishakha.jambekar@intel.com>
Subject: [PATCH net-next 2/3] ixgbe: optimize for XDP_REDIRECT in xsk path
Date:   Tue, 16 Mar 2021 09:42:53 -0700
Message-Id: <20210316164254.3744059-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
References: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Optimize ixgbe_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the xsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little under 100k extra
packets in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..91ad5b902673 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -104,6 +104,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -115,10 +122,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		}
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.26.2

