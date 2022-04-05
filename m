Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563F54F3C42
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiDEMG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380453AbiDELmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F9E10C512;
        Tue,  5 Apr 2022 04:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156815; x=1680692815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mbtWIU5wzG0po2smPXKlILYR/oBKbFqXLGuHuFvUTgM=;
  b=cHR4hZmT99KbF9XXzi9DuemjfMJBhttkGiSuLorqCX60ot2TUMPPV7Ls
   q1TGZyePW4GlD/BSXBncjQIbjlUEc+e7eq6JK4YTWAJjZK2fM5AwMO+WC
   l/OvtIH1EABsouFQokgWim+q7x6/CY0FSc3ML6xOQFRcW1cwukbQdQj6o
   m7gs9l/Day2X7G8Yl2mpJSxPyZMXFMN5TYUAaGT+UOM1dFC5OoTeYmjLD
   jnxca1UcXGQa1IO0modNVSDD2234atopYSyqkp3ohlNytRQTQspwHlF6H
   EOEcnsBU0EnMoTel/7VStQAwlPLR0C3FgQDYBfVCH477zsaH5J1/KHHC7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241307978"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241307978"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:06:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570830"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:52 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 05/10] ixgbe: xsk: terminate NAPI when XSK Rx queue gets full
Date:   Tue,  5 Apr 2022 13:06:26 +0200
Message-Id: <20220405110631.404427-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
Rx queue being full. In such case, terminate the softirq processing and
let the user space to consume descriptors from XSK Rx queue so that
there is room that driver can use later on.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 23 ++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index bba3feaf3318..f1f69ce67420 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -8,6 +8,7 @@
 #define IXGBE_XDP_CONSUMED	BIT(0)
 #define IXGBE_XDP_TX		BIT(1)
 #define IXGBE_XDP_REDIR		BIT(2)
+#define IXGBE_XDP_EXIT		BIT(3)
 
 #define IXGBE_TXD_CMD (IXGBE_TXD_CMD_EOP | \
 		       IXGBE_TXD_CMD_RS)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index dd7ff66d422f..475244a2c6e4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -109,9 +109,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 
 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
-			goto out_failure;
-		return IXGBE_XDP_REDIR;
+		if (!err)
+			return IXGBE_XDP_REDIR;
+		result = (err == -ENOBUFS) ? IXGBE_XDP_EXIT : IXGBE_XDP_CONSUMED;
+		goto out_failure;
 	}
 
 	switch (act) {
@@ -130,6 +131,9 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		if (result == IXGBE_XDP_CONSUMED)
 			goto out_failure;
 		break;
+	case XDP_DROP:
+		result = IXGBE_XDP_CONSUMED;
+		break;
 	default:
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
@@ -137,9 +141,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough; /* handle aborts by dropping packet */
-	case XDP_DROP:
-		result = IXGBE_XDP_CONSUMED;
-		break;
 	}
 	return result;
 }
@@ -304,10 +305,16 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
 
 		if (xdp_res) {
-			if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))
+			if (xdp_res == IXGBE_XDP_EXIT) {
+				failure = true;
+				xsk_buff_free(bi->xdp);
+				ixgbe_inc_ntc(rx_ring);
+				break;
+			} else if (xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
-			else
+			} else {
 				xsk_buff_free(bi->xdp);
+			}
 
 			bi->xdp = NULL;
 			total_rx_packets++;
-- 
2.33.1

