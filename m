Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B23281582
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388223AbgJBOnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:43:00 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A92A207DE;
        Fri,  2 Oct 2020 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649780;
        bh=dB1yq4ULn7DJ3/BsHkzrZDjsyKFHyuueOGwuTCFAzbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIo4UkQHYEYVzKGSbQnmudflyrfXBDH6cpRDxP6IN4AQCiHmdomA3peLotqpqicD7
         X0YSEXZeeM2gVNFKY/BllxOduYuYlEVufy/p7OQIbV7ie6/X3b6KaYVFcPy5NMQ0Iq
         dGx9xTWKSw54/AFaAi9oGlEMw6dIrGUfJVtfJ1fI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 08/13] bpf: move user_size out of bpf_test_init
Date:   Fri,  2 Oct 2020 16:42:06 +0200
Message-Id: <4f633a8510040b7bc9b7fc680a33b86654396e51.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
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
index c1c30a9f76f3..bd291f5f539c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -171,11 +171,10 @@ __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
 
-static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
-			   u32 headroom, u32 tailroom)
+static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
+			   u32 size, u32 headroom, u32 tailroom)
 {
 	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
-	u32 user_size = kattr->test.data_size_in;
 	void *data;
 
 	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
@@ -495,7 +494,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags || kattr->test.cpu)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -632,7 +632,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -698,7 +699,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.26.2

