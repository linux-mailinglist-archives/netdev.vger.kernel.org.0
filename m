Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B84470A23
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343574AbhLJTTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:19:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59910 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbhLJTTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:19:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C0EBCE2D2D;
        Fri, 10 Dec 2021 19:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB926C341C7;
        Fri, 10 Dec 2021 19:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163774;
        bh=5LcvuBtdI0wsm5ybLavIkYnHCPNphpXClaTP6ycgOss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLPE+G53rXoxRarGj2lZvqJ135XJmqh6+USTss6z6JGMzavWRdwWXVKcl02LYSESJ
         C34f1TD0z6cgQhcj2b3HkQkyt9wcbvicr4zKJacrth64BkHNn/rjwl7kWr5ytDz5cP
         cKBIoORwg3O+DQWwZ1lDDX1hJXMaX5exuJAW7JMhGwm3h2/THbTVwUCy7hNHZpzLkT
         vuoKwY3xSMnmu9GnJH+WBkqFsAac277DVffsjdai1DjnBJoyr7DOyTqMHI/zK6lQXX
         DqJrYctetY0vkxj5DD1dnUMPkLRimjfbY9idd34otfA2BBkCS/jx0BxeQfDi59jlfS
         +fZhWgq/ZU+Hg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 15/23] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Fri, 10 Dec 2021 20:14:22 +0100
Message-Id: <0ba9a98254044d098cada894a06fa706e29d1005.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
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
 net/bpf/test_run.c | 58 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index dbf1227f437c..9cb5d5eced9a 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -758,16 +758,16 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -787,27 +787,60 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
 	}
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
-	xdp_init_buff(&xdp, headroom + max_data_sz + tailroom,
-		      &rxqueue->xdp_rxq);
+	rxqueue->xdp_rxq.frag_size = headroom + max_data_sz + tailroom;
+	xdp_init_buff(&xdp, rxqueue->xdp_rxq.frag_size, &rxqueue->xdp_rxq);
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
+			sinfo->xdp_frags_size += data_len;
+			size += data_len;
+		}
+		xdp_buff_set_mb(&xdp);
+	}
+
 	if (repeat > 1)
 		bpf_prog_change_xdp(NULL, prog);
+
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
@@ -817,10 +850,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -831,6 +861,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (repeat > 1)
 		bpf_prog_change_xdp(prog, NULL);
 free_data:
+	for (i = 0; i < sinfo->nr_frags; i++)
+		__free_page(skb_frag_page(&sinfo->frags[i]));
 	kfree(data);
 free_ctx:
 	kfree(ctx);
-- 
2.33.1

