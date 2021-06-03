Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7413F39A672
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFCQ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:58:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:13150 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhFCQ6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:58:42 -0400
IronPort-SDR: R94ko7mM2z3UhID/QOSkX0aMV/eqUBEyiA8z4kI2JrTYqlfoJDmtreABf3NPqhgGXLrhdJFRmi
 fcOLuxNLEZGw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="265260917"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="265260917"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 09:56:55 -0700
IronPort-SDR: IhbPyP1viKX6PGoauW54QKEfk0lTXXC/CEgKLZRlAa7eybvLtN4Uc49EbJsy0yvMru5uScIM8E
 B7/qJFax0BNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="550239152"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 09:56:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>
Subject: [PATCH net 6/8] ixgbevf: add correct exception tracing for XDP
Date:   Thu,  3 Jun 2021 09:59:21 -0700
Message-Id: <20210603165923.1918030-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
References: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 21092e9ce8b1 ("ixgbevf: Add support for XDP_TX action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ba2ed8a43d2d..0e733cc15c58 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1067,11 +1067,14 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 	case XDP_TX:
 		xdp_ring = adapter->xdp_ring[rx_ring->queue_index];
 		result = ixgbevf_xmit_xdp_ring(xdp_ring, xdp);
+		if (result == IXGBEVF_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
-- 
2.26.2

