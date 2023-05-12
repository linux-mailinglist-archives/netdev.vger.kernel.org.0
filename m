Return-Path: <netdev+bounces-2197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40853700B7F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F16BC281B58
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF8714283;
	Fri, 12 May 2023 15:22:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE10324146;
	Fri, 12 May 2023 15:22:08 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CF6E710;
	Fri, 12 May 2023 08:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904902; x=1715440902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKsK28rErg60/rNwLMPgryg9t46tucLmP+/ktIgM2XM=;
  b=K3Fq9O+jpuZQkL17P03ieaDtSDT7HXC3yjsJbfyxGpoTY3Q87wL3MNze
   zwqihvYYD2G0gXKsxNe+RJM6Putm87JCPwZdpiL24H1VCjm0veUI9JPIc
   J9+tmx4olu3ZPFXyfNmcEzt+Yoxwb5x9pWOou07JiQDiZaR2VMlbVHNd4
   6T+yF51/QEwoBFSjpid+Gnz7Ni4+xLJ22LJ2z/VmYkJWJ488XXSQ6I7IT
   9PqsUL4GpaEXdCy8JzsPdAXWw8joqzpzGD8RY7fut5bnt/0/fCtTtKmYK
   6t1e9E6VyrquYNQ9I3SQBBCni4EZCR+lsRKsXpH6Jmu+qjxL1vqkrrztE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="353061234"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353061234"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:20:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="812114571"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="812114571"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga002.fm.intel.com with ESMTP; 12 May 2023 08:20:44 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 0B2D43636E;
	Fri, 12 May 2023 16:20:40 +0100 (IST)
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
Subject: [PATCH 12/15] ice: Implement checksum level hint
Date: Fri, 12 May 2023 17:16:36 +0200
Message-Id: <20230512151639.992033-13-larysa.zaremba@intel.com>
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

Implement .xmo_rx_csum_lvl callback to allow XDP code to determine,
whether checksum was checked by hardware and on what level.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 39547feb6106..6a3ec925f20d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -161,6 +161,8 @@ ice_rx_csum_checked(union ice_32b_rx_flex_desc *rx_desc, u16 ptype,
 	 */
 	if (decoded.tunnel_type >= ICE_RX_PTYPE_TUNNEL_IP_GRENAT)
 		*csum_lvl_dst = 1;
+	else
+		*csum_lvl_dst = 0;
 
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
 	switch (decoded.inner_prot) {
@@ -190,7 +192,7 @@ static void
 ice_rx_csum_into_skb(struct ice_rx_ring *ring, struct sk_buff *skb,
 		     union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
 {
-	u8 csum_level = 0;
+	u8 csum_level;
 
 	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
 	skb->ip_summed = CHECKSUM_NONE;
@@ -669,9 +671,29 @@ static int ice_xdp_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag)
 	return 0;
 }
 
+/**
+ * ice_xdp_rx_csum_lvl - Get level, at which HW has checked the checksum
+ * @ctx: XDP buff pointer
+ * @csum_lvl: destination address
+ *
+ * Copy HW checksum level (if was checked) to the destination address.
+ */
+static int ice_xdp_rx_csum_lvl(const struct xdp_md *ctx, u8 *csum_lvl)
+{
+	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
+	u16 ptype = ice_get_ptype(xdp_ext->eop_desc);
+
+	if (!ice_rx_csum_checked(xdp_ext->eop_desc, ptype, csum_lvl,
+				 xdp_ext->rx_ring))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 const struct xdp_metadata_ops ice_xdp_md_ops = {
 	.xmo_rx_timestamp		= ice_xdp_rx_hw_ts,
 	.xmo_rx_hash			= ice_xdp_rx_hash,
 	.xmo_rx_ctag			= ice_xdp_rx_ctag,
 	.xmo_rx_stag			= ice_xdp_rx_stag,
+	.xmo_rx_csum_lvl		= ice_xdp_rx_csum_lvl,
 };
-- 
2.35.3


