Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2C23D8AE4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhG1JkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235785AbhG1Jj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:39:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EEC360FC4;
        Wed, 28 Jul 2021 09:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465197;
        bh=6wI9QopYFGN/7pouTeoe8Ek4JZPQdQ4Pa3lrnggRabA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQckAmIAkkjWZMaHW51rCVPNAq9iJ3/LWjL6mwKCBA6nRPmpbZPp+YE76gA1Hu+tF
         xd3aXPTpWDjy+6sJER+2xLKRLnnZPlX3/Dc0f4Ay7/RLl0YyLRCY/B1iZpldrjj6HS
         3ze855uJdh6FtRghrmG2NuaAixs6TlkS54fZczop/83g2g8O7ZjwC0kcoo4osQ2Jro
         ff+pY/kwyljoBddcQIRJGkpYnCmFgdOeJ+qku+bQtfPSy6MJJIOAZ+PPkmA+yZYwzb
         wVXYAdohNCvL6VrDFMRbrkKLXjWeOV4aBXCqovHBrU0KKWH8S0YMua9B90TBKvp9HK
         IPRDnXiU0OwdA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 14/18] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Wed, 28 Jul 2021 11:38:19 +0200
Message-Id: <b7681a1d7153cbceba8a26bb434948a457f1b5e6.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the capability to allocate a xdp multi-buff in
bpf_prog_test_run_xdp routine. This is a preliminary patch to introduce
the selftests for new xdp multi-buff ebpf helpers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 54 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f514bfe9837b..529c9d9ae702 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -749,16 +749,16 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 size = kattr->test.data_size_in;
+	u32 headroom = XDP_PACKET_HEADROOM;
+	u32 retval, duration, max_data_sz;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
+	struct skb_shared_info *sinfo;
 	struct xdp_buff xdp = {};
-	u32 retval, duration;
+	int i, ret = -EINVAL;
 	struct xdp_md *ctx;
-	u32 max_data_sz;
 	void *data;
-	int ret = -EINVAL;
 
 	ctx = bpf_ctx_init(kattr, sizeof(struct xdp_md));
 	if (IS_ERR(ctx))
@@ -774,11 +774,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		headroom -= ctx->data;
 	}
 
-	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
+	size = min_t(u32, size, max_data_sz);
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
@@ -788,11 +787,45 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
 		      &rxqueue->xdp_rxq);
 	xdp_prepare_buff(&xdp, data, headroom, size, true);
+	sinfo = xdp_get_shared_info_from_buff(&xdp);
 
 	ret = xdp_convert_md_to_buff(ctx, &xdp);
 	if (ret)
 		goto free_data;
 
+	if (unlikely(kattr->test.data_size_in > size)) {
+		void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
+
+		while (size < kattr->test.data_size_in) {
+			struct page *page;
+			skb_frag_t *frag;
+			int data_len;
+
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			frag = &sinfo->frags[sinfo->nr_frags++];
+			__skb_frag_set_page(frag, page);
+
+			data_len = min_t(int, kattr->test.data_size_in - size,
+					 PAGE_SIZE);
+			skb_frag_size_set(frag, data_len);
+
+			if (copy_from_user(page_address(page), data_in + size,
+					   data_len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			sinfo->xdp_frags_tsize += PAGE_SIZE;
+			sinfo->xdp_frags_size += data_len;
+			size += data_len;
+		}
+		xdp_buff_set_mb(&xdp);
+	}
+
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	/* We convert the xdp_buff back to an xdp_md before checking the return
@@ -803,10 +836,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (ret)
 		goto out;
 
-	if (xdp.data_meta != data + headroom ||
-	    xdp.data_end != xdp.data_meta + size)
-		size = xdp.data_end - xdp.data_meta;
-
+	size = xdp.data_end - xdp.data_meta + sinfo->xdp_frags_size;
 	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, size, retval,
 			      duration);
 	if (!ret)
@@ -816,6 +846,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 out:
 	bpf_prog_change_xdp(prog, NULL);
 free_data:
+	for (i = 0; i < sinfo->nr_frags; i++)
+		__free_page(skb_frag_page(&sinfo->frags[i]));
 	kfree(data);
 free_ctx:
 	kfree(ctx);
-- 
2.31.1

