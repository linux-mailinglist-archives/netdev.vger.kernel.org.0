Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB046338B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhK3L6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:58:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58974 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhK3L6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22D76CE18BA;
        Tue, 30 Nov 2021 11:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F8C53FC1;
        Tue, 30 Nov 2021 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273297;
        bh=pnSvdfErzynX3h3b2YRGgJO3+uiLFoFMHub+K3pYA7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAqTZWummapSKpMHfo9q4FqzCypKisQw7jrT6ZN9BeO1s5fs+ldHI4S1awEQev2U9
         8M2R2IwC1+1Wdg1tUmQtyPa5TZZI/JsnuOGft/ZYYurWB0NQYkxNJLfex5la0KADQ2
         UKskA91fY38SIiAyRx3OJDDM3OCyCdyAVNMw+Nl0lxhDfV03HNyjPFdN8FeGYPaJuv
         d1tG3O0v4WmFc5uLA17rNEhHQCsEtATbfnK0N9JQONbAc4w+d3UOhlIR9A6ufzv69J
         i3cDsV+quzD49LzgA7Lq3KwknFuwSQBaGACKFL47C+hvnC3kX6XKPqLKuAB1UQM+kz
         ICILZF2KzzNQg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 14/23] bpf: move user_size out of bpf_test_init
Date:   Tue, 30 Nov 2021 12:52:58 +0100
Message-Id: <8f4f564e893232024bd6a127890143230378bfd0.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
2.31.1

