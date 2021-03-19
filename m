Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A46A342819
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCSVtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhCSVsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F8D61956;
        Fri, 19 Mar 2021 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190523;
        bh=HThzNHtvOrTetLhTi8bziyUenmjjOc+AEVfJYuhOOWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaWR3zlj8j9nzc53T7rGVRnE71hUbqanTtI8/3D+xzyoBIn0rJboBaqWi0o5u50xy
         jLxyNp+1U8Cc9KYmhTHUF/ua39H1DAHrfabEZVPnVKPA/cD7/B0Jz7eC/H4JPbAU5f
         XVnrIpaIutoV9V03pri5hBUufRXb8SY8tzWX3+DQKBpBrBzCduSCLWlPyTfYyeGIhm
         iKMjpEBSIbRd9bN8O1VMspDhOJih0LJ55G24rMPMNvT2o9KF0dvI8WypoqaEHq1Mip
         8tBDEeRyiBRolZyysGhOLcn4dlEFPbuBEBjOrNtRNg9hfpnLE6vmYfl8uK66+y6nS2
         eXDZswDbSRWeA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 12/14] bpf: introduce multibuff support to bpf_prog_test_run_xdp()
Date:   Fri, 19 Mar 2021 22:47:26 +0100
Message-Id: <e10fac63358b4a0b8c8cf73119bfcb4267989d40.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616179034.git.lorenzo@kernel.org>
References: <cover.1616179034.git.lorenzo@kernel.org>
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
index 6c3516555757..8a4cc15b89b7 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -660,23 +660,22 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 {
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 headroom = XDP_PACKET_HEADROOM;
-	u32 size = kattr->test.data_size_in;
+	struct xdp_shared_info *xdp_sinfo;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
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
 
@@ -685,16 +684,53 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		      &rxqueue->xdp_rxq);
 	xdp_prepare_buff(&xdp, data, headroom, size, true);
 
+	xdp_sinfo = xdp_get_shared_info_from_buff(&xdp);
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
+			frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
+			xdp_set_frag_page(frag, page);
+
+			data_len = min_t(int, kattr->test.data_size_in - size,
+					 PAGE_SIZE);
+			xdp_set_frag_size(frag, data_len);
+
+			if (copy_from_user(page_address(page), data_in + size,
+					   data_len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			xdp_sinfo->data_length += data_len;
+			size += data_len;
+		}
+		xdp.mb = 1;
+	}
+
 	bpf_prog_change_xdp(NULL, prog);
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
-	if (xdp.data != data + headroom || xdp.data_end != xdp.data + size)
-		size = xdp.data_end - xdp.data;
+
+	size = xdp.data_end - xdp.data + xdp_sinfo->data_length;
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
+
 out:
 	bpf_prog_change_xdp(prog, NULL);
+	for (i = 0; i < xdp_sinfo->nr_frags; i++)
+		__free_page(xdp_get_frag_page(&xdp_sinfo->frags[i]));
 	kfree(data);
+
 	return ret;
 }
 
-- 
2.30.2

