Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4506A1FC0
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjBXQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:37:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1822D17D;
        Fri, 24 Feb 2023 08:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677256633; x=1708792633;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aP/hWoH6vB24MHR+aO4zQbQ8AYftsgVDH9DlzaoCrUY=;
  b=I3yLZqxZZY7hHZcJoW+vZ06ZqI22TinxessI1dZt9dm4piWJ3XXMlgOK
   GAbRkCoOUoTECNhXNIWLBSYA3nOSJdnv6q2O5EY/tzM/NPvBKsZEKeBPj
   OawinGW0ZPXs9tM/hFPPNRRDmHyfsmP/4IZEJQCVx8L03jlFS8tlEtbaD
   fBa+90axdzaiMB3aX8jgIGsxPkGWfvgcMeSPxEQxMq/apmqj0OeS1c6nU
   COvYIyALgDMBjwOcdfzA/O9n0lKR9WxnME7Jq8v+wUEIcvEyHOHSOkJn3
   gFJL+iFwalmFcQOUqBwumLsZIY8/n5ltAUGaX/t6jSNF3KqrHoX56kWT3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="398250734"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="398250734"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 08:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="815804216"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="815804216"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 24 Feb 2023 08:37:09 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 9ED3B35458;
        Fri, 24 Feb 2023 16:37:08 +0000 (GMT)
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf v6] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
Date:   Fri, 24 Feb 2023 17:36:07 +0100
Message-Id: <20230224163607.2994755-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
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
---
From v5[0]:
* target bpf pulled to net-next-6.3 (Martin).

From v4[1]:
* drop static_assert() which caused build failures on 128-byte cacheline
  arches (Martin, kbuild bots).

From v3[2]:
* target bpf-next to account adding support for s390 (Martin);
* update both kernel and userspace %MAX_PKT_SIZE accordingly.

From v2[3]:
* update %MAX_PKT_SIZE in the selftests (Daniel, CI bots);
* add conditional static assert to avoid facing the same issue in future;
* pick one Acked-by (Toke).

From v1[4]:
* align `&head->data` with how `head->frm` is assigned for consistency
  (Toke);
* rename 'frm' to 'frame' in &xdp_page_head (Jakub);
* no functional changes.

[0] https://lore.kernel.org/bpf/20230220154627.72267-1-aleksander.lobakin@intel.com
[1] https://lore.kernel.org/bpf/20230215185440.4126672-1-aleksander.lobakin@intel.com
[2] https://lore.kernel.org/bpf/20230215152141.3753548-1-aleksander.lobakin@intel.com
[3] https://lore.kernel.org/bpf/20230213142747.3225479-1-alexandr.lobakin@intel.com
[4] https://lore.kernel.org/bpf/20230209172827.874728-1-alexandr.lobakin@intel.com
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

base-commit: 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
-- 
2.39.2

