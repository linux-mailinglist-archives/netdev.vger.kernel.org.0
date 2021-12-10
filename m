Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9687A470A21
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343570AbhLJTTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:19:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343563AbhLJTTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:19:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53F34B829CC;
        Fri, 10 Dec 2021 19:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F13C341CB;
        Fri, 10 Dec 2021 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163770;
        bh=FivTV4uZK1ijn/msAvIzP886sttcnnw0YEpYchZ/CaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARjLf147mEh889hFHDKcpTGEtd8Od2JLc/Qx6dIR8A6vWGv0x4rln/tSbZxmVcSFQ
         dhey5GaTxR5wERtGRm2M+Qkq3d6KKc/vUs+nCYjikaJSRu2kZhrcK1TMFvkYQuBSb8
         b4VVjgYoMDADPcExZj7tirwSJGuDa35Ui19SQaon+4P8UZIU8Pa9PkUDN0ZATr/+3B
         opibfLUYIX3s0pJYccJstg8KF8kFfvbtWZ4FhI0GccXwKhUsntjpv+kI7lvpdq7kfF
         vI7LLYgMajB6u72eRJeIF9Nug4hMnLnwiQVn5EovcGDKubHa2ERNK0bi201af/Zx2j
         D8uAwygBneLRg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 14/23] bpf: move user_size out of bpf_test_init
Date:   Fri, 10 Dec 2021 20:14:21 +0100
Message-Id: <90134f3703db19f2e7db6c037d054254cd9296aa.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
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
2.33.1

