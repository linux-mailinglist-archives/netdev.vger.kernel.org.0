Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25869480F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBMO3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBMO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:29:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D22A868D;
        Mon, 13 Feb 2023 06:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676298537; x=1707834537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Oa3/nxJAEcBg6F6vIFpqBHc553r2YQokvLiMYc/F20=;
  b=cjhOgZOJRk8CK5zRNuwbBi8AHVtNd697WE/OqxfRlD7DslH6fCZmI42W
   OSElHhotUncXvRiBncReJB9+pM1uxtBWOUYp1Brxu3OaIk6t6M5b2B506
   RpERrSoe8suWDLP1glvYEpSO8QGVpounbS8l9VfxdG1OW9Q6r+K7Q4dXl
   nBmsUp2TyqnCZUhfFNtQNaxOEAMlaR+YAWtRfF3m5mKnedMLdpdebl8No
   /RblFek+JqiicYB+Q3rZJhukPF4tWWUa1IoXaOMWNhl7ao6fqWKidQlQk
   kFU5Nk+4keRX5CGATdbfmtvF9Ekzvd2PloV9JO+DV1COybgphVjN74byu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310531575"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310531575"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 06:28:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="777862265"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="777862265"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga002.fm.intel.com with ESMTP; 13 Feb 2023 06:28:54 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id D420C3D2E7;
        Mon, 13 Feb 2023 14:28:52 +0000 (GMT)
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 bpf] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
Date:   Mon, 13 Feb 2023 15:27:47 +0100
Message-Id: <20230213142747.3225479-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

&xdp_buff and &xdp_frame are bound in a way that

xdp_buff->data_hard_start == xdp_frame

It's always the case and e.g. xdp_convert_buff_to_frame() relies on
this.
IOW, the following:

	for (u32 i = 0; i < 0xdead; i++) {
		xdpf = xdp_convert_buff_to_frame(&xdp);
		xdp_convert_frame_to_buff(xdpf, &xdp);
	}

shouldn't ever modify @xdpf's contents or the pointer itself.
However, "live packet" code wrongly treats &xdp_frame as part of its
context placed *before* the data_hard_start. With such flow,
data_hard_start is sizeof(*xdpf) off to the right and no longer points
to the XDP frame.

Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
places and praying that there are no more miscalcs left somewhere in the
code, unionize ::frm with ::data in a flex array, so that both starts
pointing to the actual data_hard_start and the XDP frame actually starts
being a part of it, i.e. a part of the headroom, not the context.
A nice side effect is that the maximum frame size for this mode gets
increased by 40 bytes, as xdp_buff::frame_sz includes everything from
data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
info.

Minor: align `&head->data` with how `head->frm` is assigned for
consistency.
Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
clarity.

(was found while testing XDP traffic generator on ice, which calls
 xdp_convert_frame_to_buff() for each XDP frame)

Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
From v1[0]:
- align `&head->data` with how `head->frm` is assigned for consistency
  (Toke);
- rename 'frm' to 'frame' in &xdp_page_head (Jakub);
- no functional changes.

[0] https://lore.kernel.org/bpf/20230209172827.874728-1-alexandr.lobakin@intel.com
---
 net/bpf/test_run.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac..522869ccc007 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
 struct xdp_page_head {
 	struct xdp_buff orig_ctx;
 	struct xdp_buff ctx;
-	struct xdp_frame frm;
-	u8 data[];
+	union {
+		/* ::data_hard_start starts here */
+		DECLARE_FLEX_ARRAY(struct xdp_frame, frame);
+		DECLARE_FLEX_ARRAY(u8, data);
+	};
 };
 
 struct xdp_test_data {
@@ -132,8 +135,8 @@ static void xdp_test_run_init_page(struct page *page, void *arg)
 	headroom -= meta_len;
 
 	new_ctx = &head->ctx;
-	frm = &head->frm;
-	data = &head->data;
+	frm = head->frame;
+	data = head->data;
 	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
 
 	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
@@ -223,7 +226,7 @@ static void reset_ctx(struct xdp_page_head *head)
 	head->ctx.data = head->orig_ctx.data;
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+	xdp_update_frame_from_buff(&head->ctx, head->frame);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
@@ -285,7 +288,7 @@ static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
 		head = phys_to_virt(page_to_phys(page));
 		reset_ctx(head);
 		ctx = &head->ctx;
-		frm = &head->frm;
+		frm = head->frame;
 		xdp->frame_cnt++;
 
 		act = bpf_prog_run_xdp(prog, ctx);
-- 
2.39.1

