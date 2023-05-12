Return-Path: <netdev+bounces-2196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7FC700B79
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45D802815AE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3AE1EA89;
	Fri, 12 May 2023 15:21:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720612414D;
	Fri, 12 May 2023 15:21:48 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF113AA5;
	Fri, 12 May 2023 08:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904877; x=1715440877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ca3C3CN5XD0jYqPpaEXrBQ6QBGcOSKPhdaJMaphgwXU=;
  b=YpCgaQwi9CMYhNmP/2C8eesAHsq2M3/nGleizp2kR9gs82tPALcw341C
   mpFlSM8oE69nNXon7ercLK0nhU5PLOCGg4GR0sZBBALf/zQ59ElJut0ob
   ZdHj04IiYKFqq1g68WG3ZCLFhr+1tUScYCGeBSYzYwUIoEnQPIRyTI61F
   Jut14U9myb0crkE7076Ald57tK6HPVCTx+c6Ap5FyEIwKB6RNN+3jItLB
   U38QmC1Urvd7zJsz5zyxMdTFaeloLEt7Z8dgOD62h3Fu8Am2FQnx4Xzw4
   ThZWF5sf+CSlYDzgfb9YjSFCOGhTM6j5I0Qf9m2c1jTBLY3bnIwmuBTI7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="353061184"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353061184"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:20:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="812114413"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="812114413"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga002.fm.intel.com with ESMTP; 12 May 2023 08:20:39 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id AD00735FB7;
	Fri, 12 May 2023 16:20:35 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] ice: Implement VLAN tag hint
Date: Fri, 12 May 2023 17:16:34 +0200
Message-Id: <20230512151639.992033-11-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512151639.992033-1-larysa.zaremba@intel.com>
References: <20230512151639.992033-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement .xmo_rx_vlan_tag callback to allow XDP code to read
packet's VLAN tag.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1caa73644e7b..39547feb6106 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -627,7 +627,51 @@ static int ice_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 	return 0;
 }
 
+/**
+ * ice_xdp_rx_ctag - VLAN tag XDP hint handler
+ * @ctx: XDP buff pointer
+ * @vlan_tag: destination address
+ *
+ * Copy VLAN tag (if was stripped) to the destination address.
+ */
+static int ice_xdp_rx_ctag(const struct xdp_md *ctx, u16 *vlan_tag)
+{
+	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
+	netdev_features_t features;
+
+	features = xdp_ext->rx_ring->netdev->features;
+
+	if (!(features & NETIF_F_HW_VLAN_CTAG_RX))
+		return -EINVAL;
+
+	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
+	return 0;
+}
+
+/**
+ * ice_xdp_rx_stag - VLAN s-tag XDP hint handler
+ * @ctx: XDP buff pointer
+ * @vlan_tag: destination address
+ *
+ * Copy VLAN s-tag (if was stripped) to the destination address.
+ */
+static int ice_xdp_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag)
+{
+	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
+	netdev_features_t features;
+
+	features = xdp_ext->rx_ring->netdev->features;
+
+	if (!(features & NETIF_F_HW_VLAN_STAG_RX))
+		return -EINVAL;
+
+	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
+	return 0;
+}
+
 const struct xdp_metadata_ops ice_xdp_md_ops = {
 	.xmo_rx_timestamp		= ice_xdp_rx_hw_ts,
 	.xmo_rx_hash			= ice_xdp_rx_hash,
+	.xmo_rx_ctag			= ice_xdp_rx_ctag,
+	.xmo_rx_stag			= ice_xdp_rx_stag,
 };
-- 
2.35.3


