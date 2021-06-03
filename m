Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994C939A670
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFCQ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:58:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:13147 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhFCQ6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:58:43 -0400
IronPort-SDR: QfMRBIANIL5loOs7+y4qsfOo8+HG5/xaDQ9+bvk9iIYPD3MHLsaPfI6j7pRY8G9NHPs2KpcxhZ
 /bBCq2hReHUw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="265260918"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="265260918"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 09:56:55 -0700
IronPort-SDR: RCd+H+s7haCwJMpvnAicjSRgV47PvtXR4eNT0HWDKbRTiVapgEs6oT/qfNLzLT+bl7JVW7qHBm
 bYgvgs5wwHnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="550239154"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 09:56:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 7/8] igc: add correct exception tracing for XDP
Date:   Thu,  3 Jun 2021 09:59:22 -0700
Message-Id: <20210603165923.1918030-8-anthony.l.nguyen@intel.com>
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

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Fixes: 4ff320361092 ("igc: Add support for XDP_REDIRECT action")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 069471b7ffb0..f1adf154ec4a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2047,20 +2047,19 @@ static struct sk_buff *igc_xdp_run_prog(struct igc_adapter *adapter,
 		break;
 	case XDP_TX:
 		if (igc_xdp_xmit_back(adapter, xdp) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_TX;
+			goto out_failure;
+		res = IGC_XDP_TX;
 		break;
 	case XDP_REDIRECT:
 		if (xdp_do_redirect(adapter->netdev, xdp, prog) < 0)
-			res = IGC_XDP_CONSUMED;
-		else
-			res = IGC_XDP_REDIRECT;
+			goto out_failure;
+		res = IGC_XDP_REDIRECT;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(adapter->netdev, prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.26.2

