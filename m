Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89F281584
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgJBOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:43:04 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2ED72085B;
        Fri,  2 Oct 2020 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649784;
        bh=f8ZZJ5+Q+i60RqTkYKstoG1GgUDRCcWa4fDxO6qFmUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/LHN+Xq6SI/snyEz261dAtXpELklHCRaH/kT6MggUrm+gKBHwKu8MuwfzeEwRxih
         Kxf6v9nvIc8ufBYjwoFXUiGQhkMVbWGAtokWsfc5pfQnRa39lM1HM12DNCd4X3flTH
         g7BbOvkPNcAMEW1fmUmHSDqnmfgKA7KaE8rQN3iE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 09/13] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Fri,  2 Oct 2020 16:42:07 +0200
Message-Id: <d6ed575afaf89fc35e233af5ccd063da944b4a3a.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
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
 net/bpf/test_run.c | 51 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index bd291f5f539c..ec7286cd051b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -617,44 +617,79 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
+	int i, ret, data_len;
 	void *data;
-	int ret;
 
 	if (kattr->test.ctx_in || kattr->test.ctx_out)
 		return -EINVAL;
 
-	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
+	size = min_t(u32, kattr->test.data_size_in, max_data_sz);
+	data_len = size;
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	xdp.data_hard_start = data;
 	xdp.data = data + headroom;
 	xdp.data_meta = xdp.data;
-	xdp.data_end = xdp.data + size;
+	xdp.data_end = xdp.data + data_len;
 	xdp.frame_sz = headroom + max_data_sz + tailroom;
 
+	sinfo = xdp_get_shared_info_from_buff(&xdp);
+	if (unlikely(kattr->test.data_size_in > size)) {
+		void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
+
+		while (size < kattr->test.data_size_in) {
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
+			if (copy_from_user(page_address(page), data_in + size,
+					   data_len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			sinfo->nr_frags++;
+			size += data_len;
+		}
+		xdp.mb = 1;
+	}
+
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp.rxq = &rxqueue->xdp_rxq;
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
+
 	if (xdp.data != data + headroom || xdp.data_end != xdp.data + size)
-		size = xdp.data_end - xdp.data;
+		size += xdp.data_end - xdp.data - data_len;
+
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

