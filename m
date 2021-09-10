Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A87406F79
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhIJQRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhIJQQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DBF61251;
        Fri, 10 Sep 2021 16:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290538;
        bh=jXRJohW49aOvCJRKXGIZOWo0KIPLrWPndf9PLtC2uik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLZ+VFpnDIf2Mrr4mq6potALSbeZBftwAcohuIp9MHUox8zyxpzDAT9yO3AgqjDRr
         a1AbCszC2zsNgqU9IVjfB9Pq7zt011Q4wzV8WzwpsL9sL7nrxbhQUVNwnRpQdrnRsn
         vnlIQ1wARwpm9jz33s0ep9kkNQR2+ORkuqmJt5Gc0gnJsO4yeUdnbC9Hx4Fh4JJ6so
         1GvLOiTCajUb9qLulBhYas1bcNRwQhQkpjznNQJLK9+mzTUaCk69i/9tXKR97gDdEx
         Onl7Fx7OH2g5bm+t4r3bz+k/+wn8epaTKC7y1xx6zCGs1PVsi8p/0O4v0V3h5oj2VS
         zb9sXfbZ8MZVw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 13/18] bpf: move user_size out of bpf_test_init
Date:   Fri, 10 Sep 2021 18:14:19 +0200
Message-Id: <868c7ba063d5d1a2da4dc572643c3ad1acb47f3b.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rely on data_size_in in bpf_test_init routine signature. This is a
preliminary patch to introduce xdp multi-buff selftest

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 1153b89c9d93..82b34632a66c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -246,11 +246,10 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
 	return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
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
@@ -569,7 +568,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags || kattr->test.cpu)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -780,7 +780,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
@@ -864,7 +865,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.31.1

