Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2043EB4CF
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbhHMLum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240415AbhHMLui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FF23610FD;
        Fri, 13 Aug 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855410;
        bh=ACcW26uL/GGe4tcVIm+QQbimasEGQ3c/a4KnZDOy5p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxOVFP+33P+LJR97EyuW2dhWpjP9vcm2VEFItYcwjD9y4SNRMelf8GSlUsk4xy0vW
         2rGjRK5kv0Xdb8LgGEy2pq2Q9eIHrB7cbHflfHP7oScgXglWgU6vNdUgDn9tepk80J
         dmjWhOexZ8YjqpSNwbn+u2zMLs4Nm71K3vhbQx1ceJKyBnzM6ygxSm2SoP4kXXyYQl
         jwCPdG/u7Ye4WBd6OV3yVs78cb09C9o2ZytQ1GwR9eXvkOWJM3sgtyf49PQVo5vmAs
         nRpheiYgNb+nvdm10S4aTzcoHqmaFDrn7mHmIl6VcIlKyvKqH9/9kdrwGvz4E+4DWs
         t0k5AVW3Cfg8g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 14/18] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Fri, 13 Aug 2021 13:47:55 +0200
Message-Id: <74135fd5e7ecfafba00224f2cc0df59b25fff784.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
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
index 362e020631b3..1833b863c185 100644
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
 
 	if (prog->expected_attach_type == BPF_XDP_DEVMAP ||
 	    prog->expected_attach_type == BPF_XDP_CPUMAP)
@@ -778,11 +778,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -792,11 +791,45 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -807,10 +840,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -820,6 +850,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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

