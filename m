Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15740490F8A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiAQRa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41290 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbiAQRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ED65B81055;
        Mon, 17 Jan 2022 17:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CED8C36AE3;
        Mon, 17 Jan 2022 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440612;
        bh=ALlmLWG7y6o1KL3DqZ4DcCT7gCP/u3UdMa+44/8OeOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZUXxdmh/r5+ML0UQB1zxAo+ZCF7jKEasRQJuE6ZIrME9340lve+GChlYp0+DXyZ4
         WKCCdwIVPNLftV0uafjSP0sHjhj791Rcw6LTJ5UT6StI3DinmBElp1ddLnSN/eUuPt
         gl22DPatWKXfeCJCxoieQSZv5NwXas5FNroFMuOBSllZxl7cxqSCaxdAhlJeiLiMnD
         MamhfJb/JIRgiGRlhuwVLA9NW3LrrC/RysMHYbyMR24L+q8wT4fEwD7t6Rjiju00Xs
         Gfi8ZZhuV79uTVuFaASINlYaQeCMdq6fSObNI9ihkn/iJVXuqLZLX4rx2SUTvGwbCr
         w1zXZBrdrRMSw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 14/23] bpf: move user_size out of bpf_test_init
Date:   Mon, 17 Jan 2022 18:28:26 +0100
Message-Id: <d4675a3dfe10b6c4dd2407e189717162605eafff.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on data_size_in in bpf_test_init routine signature. This is a
preliminary patch to introduce xdp multi-frags selftest

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 46dd95755967..dbf1227f437c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -249,11 +249,10 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
-static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
-			   u32 headroom, u32 tailroom)
+static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
+			   u32 size, u32 headroom, u32 tailroom)
 {
 	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
-	u32 user_size = kattr->test.data_size_in;
 	void *data;
 
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
@@ -581,7 +580,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags || kattr->test.cpu)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -790,7 +790,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
@@ -876,7 +877,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.34.1

