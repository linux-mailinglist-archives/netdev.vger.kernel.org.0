Return-Path: <netdev+bounces-2208-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE17700BD7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C39E11C21337
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85991426F;
	Fri, 12 May 2023 15:29:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B4F24155;
	Fri, 12 May 2023 15:29:03 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A39465A4;
	Fri, 12 May 2023 08:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905334; x=1715441334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxAZyfKvmCeKRbEnyC2VNCiFTtwsPxlmLEsjOF/q5aQ=;
  b=cTqdVinm6D3WGx5gq8iC1lnhVgPUOVIltAyChg7dHlNhenUONyW5zebA
   dYNHDHgCB4snLzo/60v25ASISSFZ1/r6amTLMGFP0pPhn5YI3dAIuarYO
   r1KVBd//aqh6ajE7sP6aUSvHxui3svZtXt8xRIEMt5oslkzykH9D461sf
   4nPlblrUpxsrXlkPppnriASCC1/HqMbX4+3PCIyPB4yxLFpgeSmLk8UAh
   hdH8NXJZ3uQTTOrLwaqL/gOLjQlplxy7YZynKEK01sI66pPLjA9shojX9
   2/IIM+isGFi5w1SNDLie81EBB+QVgF4MdSJFfrmwj+ds9/gckYDVEi8mv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="349653364"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="349653364"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:28:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="1030124549"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="1030124549"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2023 08:28:49 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 32DB8369FF;
	Fri, 12 May 2023 16:28:48 +0100 (IST)
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
Subject: [PATCH RESEND bpf-next 08/15] ice: Support XDP hints in AF_XDP ZC mode
Date: Fri, 12 May 2023 17:26:00 +0200
Message-Id: <20230512152607.992209-9-larysa.zaremba@intel.com>
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

In AF_XDP ZC, xdp_buff is not stored on ring,
instead it is provided by xsk_pool.
Space for metadata sources right after such buffers was already reserved
in commit 94ecc5ca4dbf ("xsk: Add cb area to struct xdp_buff_xsk").
This makes the implementation rather straightforward.

Update AF_XDP ZC packet processing to support XDP hints.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 3b80aed5d47a..7f5ce3529666 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -708,16 +708,25 @@ static int ice_xmit_xdp_tx_zc(struct xdp_buff *xdp,
  * @xdp: xdp_buff used as input to the XDP program
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
+ * @rx_desc: packet descriptor
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
 ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
+	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
+	       union ice_32b_rx_flex_desc *rx_desc)
 {
 	int err, result = ICE_XDP_PASS;
 	u32 act;
 
+	/* We can safely convert xdp_buff_xsk to ice_xdp_buff,
+	 * because there are XSK_PRIV_MAX bytes reserved in xdp_buff_xsk
+	 * right after xdp_buff, for our private use.
+	 * Macro insures we do not go above the limit.
+	 */
+	XSK_CHECK_PRIV_TYPE(struct ice_xdp_buff);
+	ice_xdp_set_meta_srcs(xdp, rx_desc, rx_ring);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (likely(act == XDP_REDIRECT)) {
@@ -816,7 +825,8 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		xsk_buff_set_size(xdp, size);
 		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring,
+					 rx_desc);
 		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))) {
 			xdp_xmit |= xdp_res;
 		} else if (xdp_res == ICE_XDP_EXIT) {
-- 
2.35.3


