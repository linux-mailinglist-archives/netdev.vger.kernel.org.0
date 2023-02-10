Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F869242A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbjBJRLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjBJRLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:11:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D44661D00;
        Fri, 10 Feb 2023 09:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676049067; x=1707585067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0dcojjiE789BDMJg+GPh0TiqtbrZeBsVGaGIrqQQlIk=;
  b=bxfURKlIlSISWVxfzFRUr2HFurlEis2tvm5g7dvbSP5m8JVm559abx0D
   wGmBosoISKEXZZ6JQOAP+heBLor+T84eYSjACytFzcckK2qKTlFtNAS5G
   3DwHfez4WZ/5QNc3Wh+P1aTJy1dtPhQG/FYaakrxgrzomQG1ZRYWtPViU
   vBZ+MIZJ9ykbLJwLFI0ipFKzHg3fZlBc9OCtQ/ugX8y2WY0ucHrAxNgbT
   Lj3kQCZxyXtk+HOlVTN/eYV5tO8i+S0JTnWBrxMC4nx1V5fUmQZ9vLUL8
   ZCa1X6JmBQioNH/K/rt7t0FNxDUNntG2NHT2aFH9j1nOZJLCPdWIdgue2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="395076740"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="395076740"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:07:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="668107556"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="668107556"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga002.jf.intel.com with ESMTP; 10 Feb 2023 09:07:28 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 6A9CE3C624;
        Fri, 10 Feb 2023 17:07:27 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 6/6] ice: micro-optimize .ndo_xdp_xmit() path
Date:   Fri, 10 Feb 2023 18:06:18 +0100
Message-Id: <20230210170618.1973430-7-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
References: <20230210170618.1973430-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the recent mbuf changes, ice_xmit_xdp_ring() became a 3-liner.
It makes no sense to keep it global in a different file than its caller.
Move it just next to the sole call site and mark static. Also, it
doesn't need a full xdp_convert_frame_to_buff(). Save several cycles
and fill only the fields used by __ice_xmit_xdp_ring() later on.
Finally, since it doesn't modify @xdpf anyhow, mark the argument const
to save some more (whole -11 bytes of .text! :D).

Thanks to 1 jump less and less calcs as well, this yields as many as
6.7 Mpps per queue. `xdp.data_hard_start = xdpf` is fully intentional
again (see xdp_convert_buff_to_frame()) and just works when there are
no source device's driver issues.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 21 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 13 ------------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  1 -
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e451276a37b6..aaf313a95368 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -605,6 +605,25 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		ice_set_rx_bufs_act(xdp, rx_ring, ret);
 }
 
+/**
+ * ice_xmit_xdp_ring - submit frame to XDP ring for transmission
+ * @xdpf: XDP frame that will be converted to XDP buff
+ * @xdp_ring: XDP ring for transmission
+ */
+static int ice_xmit_xdp_ring(const struct xdp_frame *xdpf,
+			     struct ice_tx_ring *xdp_ring)
+{
+	struct xdp_buff xdp;
+
+	xdp.data_hard_start = (void *)xdpf;
+	xdp.data = xdpf->data;
+	xdp.data_end = xdp.data + xdpf->len;
+	xdp.frame_sz = xdpf->frame_sz;
+	xdp.flags = xdpf->flags;
+
+	return __ice_xmit_xdp_ring(&xdp, xdp_ring, true);
+}
+
 /**
  * ice_xdp_xmit - submit packets to XDP ring for transmission
  * @dev: netdev
@@ -650,7 +669,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 	tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
 	for (i = 0; i < n; i++) {
-		struct xdp_frame *xdpf = frames[i];
+		const struct xdp_frame *xdpf = frames[i];
 		int err;
 
 		err = ice_xmit_xdp_ring(xdpf, xdp_ring);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 6d98c34d99fc..7bc5aa340c7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -434,19 +434,6 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
 	return ICE_XDP_CONSUMED;
 }
 
-/**
- * ice_xmit_xdp_ring - submit frame to XDP ring for transmission
- * @xdpf: XDP frame that will be converted to XDP buff
- * @xdp_ring: XDP ring for transmission
- */
-int ice_xmit_xdp_ring(struct xdp_frame *xdpf, struct ice_tx_ring *xdp_ring)
-{
-	struct xdp_buff xdp;
-
-	xdp_convert_frame_to_buff(xdpf, &xdp);
-	return __ice_xmit_xdp_ring(&xdp, xdp_ring, true);
-}
-
 /**
  * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
  * @xdp_ring: XDP ring
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 79efc20c46d9..115969ecdf7b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -142,7 +142,6 @@ static inline u32 ice_set_rs_bit(const struct ice_tx_ring *xdp_ring)
 
 void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res, u32 first_idx);
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
-int ice_xmit_xdp_ring(struct xdp_frame *xdpf, struct ice_tx_ring *xdp_ring);
 int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
 			bool frame);
 void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
-- 
2.39.1

