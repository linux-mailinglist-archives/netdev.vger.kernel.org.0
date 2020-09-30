Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E85827EDA5
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgI3PnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgI3PnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:43:01 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586F620789;
        Wed, 30 Sep 2020 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601480580;
        bh=vYgd691/f2R93zk0OZ9nK+DU0fxoqA1IhJBq2Qqet6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyl8UXdFD9vGlpLK1t0375IE2pg5VNugOVqovM+ZwaiSasMgNL19iEYCV+K169w0w
         nsS3vQ5uaREkkMAkygvuy1hJS0aVduJqHDVr2fv1VoC7YIs9/40y4qJVJY30cKEakH
         c0mfPoq/3dV5/Pw8QdapzQGnY3jg8X4K+WcTUaRg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 net-next 09/12] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Wed, 30 Sep 2020 17:42:00 +0200
Message-Id: <0f8afde24d12b1ee556cb74badd5aced0a185343.1601478613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
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
 net/bpf/test_run.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 5608d5a902ff..7268542b0f3c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -532,23 +532,22 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
 	void *data;
-	int ret;
+	int i, ret;
 
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
 
@@ -558,6 +557,28 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	xdp.data_end = xdp.data + size;
 	xdp.frame_sz = headroom + max_data_sz + tailroom;
 
+	sinfo = xdp_get_shared_info_from_buff(&xdp);
+	if (unlikely(kattr->test.data_size_in > size)) {
+		for (; size < kattr->test.data_size_in; size += PAGE_SIZE) {
+			skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags];
+			struct page *page;
+			int data_len;
+
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			__skb_frag_set_page(frag, page);
+			data_len = min_t(int, kattr->test.data_size_in - size,
+					 PAGE_SIZE);
+			skb_frag_size_set(frag, data_len);
+			sinfo->nr_frags++;
+		}
+		xdp.mb = 1;
+	}
+
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp.rxq = &rxqueue->xdp_rxq;
 	bpf_prog_change_xdp(NULL, prog);
@@ -569,7 +590,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
 out:
 	bpf_prog_change_xdp(prog, NULL);
+	for (i = 0; i < sinfo->nr_frags; i++)
+		__free_page(skb_frag_page(&sinfo->frags[i]));
 	kfree(data);
+
 	return ret;
 }
 
-- 
2.26.2

