Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EFD27EDA1
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgI3Pm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730567AbgI3Pm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:42:57 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB5EA20888;
        Wed, 30 Sep 2020 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601480577;
        bh=0MEVxFzNy4FeBuDJYmqZYu8vdEbCpyx2XH53dG7mD4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1XWIEfjqPB8NJgwQMF/wmxT2T8a+DSchF6dGvm41YyeR/fWRn7pFM0bAi+SThRzm
         +8pzzfNgpvpDTiFH7KvbFnMGVdzvabIyYKiuHwF1ga6+E1sJpuB2Lx8H/fGt0pILOz
         DAPlJkP6fJVktzL7nCLi49YQMZh/yy1e4/fQwIcc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, sameehj@amazon.com,
        kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 net-next 08/12] bpf: move user_size out of bpf_test_init
Date:   Wed, 30 Sep 2020 17:41:59 +0200
Message-Id: <acc0d09d273d42b57c51f00a725dd13bf8327049.1601478613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
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
index a66f211726e7..5608d5a902ff 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -170,11 +170,10 @@ __diag_pop();
 
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
@@ -410,7 +409,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	void *data;
 	int ret;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -547,7 +547,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -610,7 +611,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.26.2

