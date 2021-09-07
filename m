Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE171402903
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbhIGMia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344365AbhIGMiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 08:38:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D0560F92;
        Tue,  7 Sep 2021 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631018217;
        bh=b422b59o2/iuBngCOgl0Qhixz3jPfHhFSWjOLX53WBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYtmRD6AkZMbx+6hWokIMP1dYWWEr/7cYmckVm6TB+iU/hrRkY46yvp1tYV2LPczU
         DKe/oOl8Zxt0/pDgYgNgKgon+28HQYIzpmQp3bX7MjsGSewK7LNsUBnBe3bX+04lr2
         1cAsNRJ9iK/Ngyx57+3N3y2lkD2qirmABOMhA1F4hHJB4dXEILMw6ImpQlbh1+vl11
         MGTFaj00jeampU/Ch7MZ+R6Mn1W3WA4J1PEuS10YF+Q5yr6C1uqELSkG81VPJTfKFx
         Xyo00PttNf5kjNqE6wz8L9tDnRWktsxFWYoEscfgp8TFt8SNZs0yDgenJhJ9IOTg4K
         aXNg424urXYQQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v13 bpf-next 13/18] bpf: move user_size out of bpf_test_init
Date:   Tue,  7 Sep 2021 14:35:17 +0200
Message-Id: <9c076e8b4efb2de9a17a6fdd01c0d4f85e8c210a.1631007211.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631007211.git.lorenzo@kernel.org>
References: <cover.1631007211.git.lorenzo@kernel.org>
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
index 2eb0e55ef54d..1013fafb9275 100644
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
@@ -571,7 +570,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags || kattr->test.cpu)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -782,7 +782,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
@@ -866,7 +867,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.31.1

