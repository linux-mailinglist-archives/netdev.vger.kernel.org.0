Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1A69D0E5
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjBTPra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjBTPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:47:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62051ADDD;
        Mon, 20 Feb 2023 07:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676908047; x=1708444047;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KyQHPhhLwjCGfbAVCMQ6vPm6Y6uusFqb2Ch94Y3sMwg=;
  b=V+vRxvC0W6aI73pmevryyMfMXQZX8OXM3Bg2V8h3KlZXg2mhhJqpLE+x
   0ebFgItZGJQ9e5ap8vE5VKeqQNoCrbfAko3mwajYv0AN2Xwu8hrUuyRFI
   /B6RbqJIxnQTYr3HdoZ4rbP8yzV4yBZTPX20x3vdswkEDjk4zkBcJh7om
   0FYJeO6SCrlfFEW2Q+MuMx1yBhLrfqZOzP6W0zqlXn7TmBxP3hwXbUdIX
   xJ8IFJhCWXTQPvfX+bt92KceJsTm12UpGyZ2g94je9pw+zVLvyeaQgUKl
   gROHhUev7Ub7L1UXWC1oZdK4tosz4xg78US1E8Vx8ffDHXHwsgcdgqkqT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="332433662"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="332433662"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 07:47:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="701711283"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="701711283"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga008.jf.intel.com with ESMTP; 20 Feb 2023 07:47:22 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 6DCE635CC4;
        Mon, 20 Feb 2023 15:47:21 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH bpf-next v5] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
Date:   Mon, 20 Feb 2023 16:46:27 +0100
Message-Id: <20230220154627.72267-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Also update %MAX_PKT_SIZE accordingly in the selftests code. Leave it
hardcoded for 64 bit && 4k pages, it can be made more flexible later on.

Minor: align `&head->data` with how `head->frm` is assigned for
consistency.
Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
clarity.

(was found while testing XDP traffic generator on ice, which calls
 xdp_convert_frame_to_buff() for each XDP frame)

Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://lore.kernel.org/r/20230215185440.4126672-1-aleksander.lobakin@intel.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/bpf/test_run.c                            | 19 +++++++++++++------
 .../bpf/prog_tests/xdp_do_redirect.c          |  7 ++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 6f3d654b3339..f81b24320a36 100644
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
@@ -113,6 +116,10 @@ struct xdp_test_data {
 	u32 frame_cnt;
 };
 
+/* tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
+ * must be updated accordingly this gets changed, otherwise BPF selftests
+ * will fail.
+ */
 #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
@@ -132,8 +139,8 @@ static void xdp_test_run_init_page(struct page *page, void *arg)
 	headroom -= meta_len;
 
 	new_ctx = &head->ctx;
-	frm = &head->frm;
-	data = &head->data;
+	frm = head->frame;
+	data = head->data;
 	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
 
 	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
@@ -223,7 +230,7 @@ static void reset_ctx(struct xdp_page_head *head)
 	head->ctx.data = head->orig_ctx.data;
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+	xdp_update_frame_from_buff(&head->ctx, head->frame);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
@@ -285,7 +292,7 @@ static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
 		head = phys_to_virt(page_to_phys(page));
 		reset_ctx(head);
 		ctx = &head->ctx;
-		frm = &head->frm;
+		frm = head->frame;
 		xdp->frame_cnt++;
 
 		act = bpf_prog_run_xdp(prog, ctx);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 2666c84dbd01..7271a18ab3e2 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -65,12 +65,13 @@ static int attach_tc_prog(struct bpf_tc_hook *hook, int fd)
 }
 
 /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
- * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
+ * SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - XDP_PACKET_HEADROOM =
+ * 3408 bytes for 64-byte cacheline and 3216 for 256-byte one.
  */
 #if defined(__s390x__)
-#define MAX_PKT_SIZE 3176
+#define MAX_PKT_SIZE 3216
 #else
-#define MAX_PKT_SIZE 3368
+#define MAX_PKT_SIZE 3408
 #endif
 static void test_max_pkt_size(int fd)
 {
-- 
2.39.1

