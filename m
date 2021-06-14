Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4583A6723
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhFNMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233891AbhFNMx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB64613CC;
        Mon, 14 Jun 2021 12:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675086;
        bh=brAq3Odxa6VtHUUCbhQeAN1XnvB54uYZHLTUxmz6VWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU6EARrnsIJTXS2+UH8KEFedo2ziR31ZUsC5LwgRPyh1d0nS3Er3vK5tx4a+VRu2v
         Uv0TziB9ubd/p4avxO3lr0xtGJaBDJszSqBjTXbkIkhVPWnLezhPB7e/5XfWNKeLcf
         qauUC5TgI2g+6e62xZEz2szsNwkCzkYOeRvH91ZEkt2CTcW95ZO5qJ6VfWFHBsRwbb
         GJPkXLa3FFphFzUsFR1eutbCE9GIi56001GAcjzJmcgnwbgJNmrEsBPyasB3/u5Pa5
         yKfOKv9zrb7PZZyZ/stll7HOUxX5+lRZnsCYFQFH17BB1m3SdJFuI8v8sFaVQn2HOC
         Oy6Muam9k9A8Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 12/14] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Mon, 14 Jun 2021 14:49:50 +0200
Message-Id: <88626eaaf04448077be9d2599eae526df37290aa.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
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
 net/bpf/test_run.c | 52 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d3252a234678..5e2c8478ae18 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -692,23 +692,22 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 {
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 headroom = XDP_PACKET_HEADROOM;
-	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
+	struct skb_shared_info *sinfo;
 	struct xdp_buff xdp = {};
+	u32 max_data_sz, size;
 	u32 retval, duration;
-	u32 max_data_sz;
+	int i, ret;
 	void *data;
-	int ret;
 
 	if (kattr->test.ctx_in || kattr->test.ctx_out)
 		return -EINVAL;
 
-	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
+	size = min_t(u32, kattr->test.data_size_in, max_data_sz);
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -717,16 +716,53 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		      &rxqueue->xdp_rxq);
 	xdp_prepare_buff(&xdp, data, headroom, size, true);
 
+	sinfo = xdp_get_shared_info_from_buff(&xdp);
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
+			sinfo->data_len += data_len;
+			size += data_len;
+		}
+		xdp_buff_set_mb(&xdp);
+	}
+
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
-	if (xdp.data != data + headroom || xdp.data_end != xdp.data + size)
-		size = xdp.data_end - xdp.data;
+
+	size = xdp.data_end - xdp.data + sinfo->data_len;
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
+
 out:
 	bpf_prog_change_xdp(prog, NULL);
+	for (i = 0; i < sinfo->nr_frags; i++)
+		__free_page(skb_frag_page(&sinfo->frags[i]));
 	kfree(data);
+
 	return ret;
 }
 
-- 
2.31.1

