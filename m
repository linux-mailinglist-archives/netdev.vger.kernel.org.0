Return-Path: <netdev+bounces-2207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47664700BCC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13B311C21313
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21801EA9D;
	Fri, 12 May 2023 15:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932E11EA88;
	Fri, 12 May 2023 15:28:53 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A692D64;
	Fri, 12 May 2023 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905329; x=1715441329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cqKMx2oSgYgFjniI/xbMp1UqCMkQn2DYgiq9853O1hY=;
  b=Sfs7PH/MrYQXgCopvZzxr2OfSnFH2LOIfhDWP5JljiX9FikjfLzar3J6
   F9mwbyEwuOVj/cqe0XgkW6Njypzwu5VnSxaw3DpOgf9e/xAG0Ci/bgvI0
   zov2jvUq+7uG6ULlsECY/yPAyHLs6QJmmGzjpjwk5J4GPolMPvDdZ/dyX
   nVToJtV1Gf1sNr7do1vb8S7DhAx8Noy7C3ukgXc4jz43KVQkyk8eKnbsN
   cBV0cYwHeZNsJrJ3KUeJqG6XP/6egX0sVuFEUuuLpIt5lq6Nso+oU7hTq
   ts8l+QAN0XN3KeipveBxyF72BzEFDHeKV/CWN0KyA4ZBD9breylk8pi45
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349653320"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349653320"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:28:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030124517"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030124517"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2023 08:28:44 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 21092365B4;
	Fri, 12 May 2023 16:28:43 +0100 (IST)
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
Subject: [PATCH RESEND bpf-next 06/15] ice: Support HW timestamp hint
Date: Fri, 12 May 2023 17:25:58 +0200
Message-Id: <20230512152607.992209-7-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512152607.992209-1-larysa.zaremba@intel.com>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use previously refactored code and create a function
that allows XDP code to read HW timestamp.

HW timestamp is the first supported hint in the driver,
so also add xdp_metadata_ops.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 22 +++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index aa32111afd6e..ba1bb8392db1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -962,4 +962,6 @@ static inline void ice_clear_rdma_cap(struct ice_pf *pf)
 	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
 	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
 }
+
+extern const struct xdp_metadata_ops ice_xdp_md_ops;
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..cda6c4a80737 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3378,6 +3378,7 @@ static void ice_set_ops(struct ice_vsi *vsi)
 
 	netdev->netdev_ops = &ice_netdev_ops;
 	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
+	netdev->xdp_metadata_ops = &ice_xdp_md_ops;
 	ice_set_ethtool_ops(netdev);
 
 	if (vsi->type != ICE_VSI_PF)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 2515f5f7a2b6..e9589cadf811 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -537,3 +537,25 @@ void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res,
 			spin_unlock(&xdp_ring->tx_lock);
 	}
 }
+
+/**
+ * ice_xdp_rx_hw_ts - HW timestamp XDP hint handler
+ * @ctx: XDP buff pointer
+ * @ts_ns: destination address
+ *
+ * Copy HW timestamp (if available) to the destination address.
+ */
+static int ice_xdp_rx_hw_ts(const struct xdp_md *ctx, u64 *ts_ns)
+{
+	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
+
+	if (!ice_ptp_copy_rx_hwts_from_desc(xdp_ext->rx_ring,
+					    xdp_ext->eop_desc, ts_ns))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+const struct xdp_metadata_ops ice_xdp_md_ops = {
+	.xmo_rx_timestamp		= ice_xdp_rx_hw_ts,
+};
-- 
2.35.3


