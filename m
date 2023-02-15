Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD86697F75
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjBOPXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBOPXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:23:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C0935B5;
        Wed, 15 Feb 2023 07:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676474596; x=1708010596;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m8EMtoD14NwkJn06REtE9Nx60Y3UrEzaAcB+87TD0Mg=;
  b=XGPEetV6wDc5XqnTmOxusBpjVuURqGkA5QF2Ng4AsCTDa3mkXQszYbjh
   Xv4zOzwjSEum9wGX/Bfs7N/JNWVRPeikrXd1N4PJeW0R662gH+JOGOX/l
   VRRa0lg9gGmU4b9M12XOA+SKsBnsPsodOgJhq9I7jTCqm6li3FG9jkGFK
   4kltGRDnallANbKcKwuGRU3Ya/VG6RZQcVbD7kaFDjtj/5VuEnGJF9o62
   LWR8670WT4NJIIhwxKZN+PIhUcE2NSY7n+ScVwzw7zvYSCMJ7kWoPAYT4
   NwrgONHbw6fjoFAQsT0xwXfVUbjx8US8uup9sBZIZXavjshDXNJUz7TMw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="358876929"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="358876929"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:23:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="738370620"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="738370620"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2023 07:23:13 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 9F515381BC;
        Wed, 15 Feb 2023 15:23:11 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 bpf] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
Date:   Wed, 15 Feb 2023 16:21:41 +0100
Message-Id: <20230215152141.3753548-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
hardcoded for 64 bit && 64-byte cacheline && 4k pages, it can be made
more flexible later on.

Minor: align `&head->data` with how `head->frm` is assigned for
consistency.
Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
clarity.

(was found while testing XDP traffic generator on ice, which calls
 xdp_convert_frame_to_buff() for each XDP frame)

Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
From v2[0]:
- update %MAX_PKT_SIZE in the selftests (Daniel, CI bots);
- add conditional static assert to avoid facing the same issue in future;
- pick one Acked-by (Toke).

From v1[1]:
- align `&head->data` with how `head->frm` is assigned for consistency
  (Toke);
- rename 'frm' to 'frame' in &xdp_page_head (Jakub);
- no functional changes.

[0] https://lore.kernel.org/bpf/20230213142747.3225479-1-alexandr.lobakin@intel.com
[1] https://lore.kernel.org/bpf/20230209172827.874728-1-alexandr.lobakin@intel.com
---
 net/bpf/test_run.c                            | 23 ++++++++++++++-----
 .../bpf/prog_tests/xdp_do_redirect.c          |  4 ++--
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac..b9e77ab94b03 100644
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
@@ -116,6 +119,14 @@ struct xdp_test_data {
 #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
+#if BITS_PER_LONG == 64 && SMP_CACHE_BYTES == 64 && PAGE_SIZE == SZ_4K
+/* tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
+ * must be updated accordingly when any of these changes.
+ */
+static_assert(TEST_XDP_FRAME_SIZE - XDP_PACKET_HEADROOM -
+	      SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) == 3408);
+#endif
+
 static void xdp_test_run_init_page(struct page *page, void *arg)
 {
 	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
@@ -132,8 +143,8 @@ static void xdp_test_run_init_page(struct page *page, void *arg)
 	headroom -= meta_len;
 
 	new_ctx = &head->ctx;
-	frm = &head->frm;
-	data = &head->data;
+	frm = head->frame;
+	data = head->data;
 	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
 
 	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
@@ -223,7 +234,7 @@ static void reset_ctx(struct xdp_page_head *head)
 	head->ctx.data = head->orig_ctx.data;
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+	xdp_update_frame_from_buff(&head->ctx, head->frame);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
@@ -285,7 +296,7 @@ static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
 		head = phys_to_virt(page_to_phys(page));
 		reset_ctx(head);
 		ctx = &head->ctx;
-		frm = &head->frm;
+		frm = head->frame;
 		xdp->frame_cnt++;
 
 		act = bpf_prog_run_xdp(prog, ctx);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index a50971c6cf4a..0253070138b1 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -63,9 +63,9 @@ static int attach_tc_prog(struct bpf_tc_hook *hook, int fd)
 }
 
 /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
- * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
+ * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3408 bytes
  */
-#define MAX_PKT_SIZE 3368
+#define MAX_PKT_SIZE 3408
 static void test_max_pkt_size(int fd)
 {
 	char data[MAX_PKT_SIZE + 1] = {};
-- 
2.39.1

