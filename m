Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79933F2FD9
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhHTPoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241361AbhHTPoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 469796113B;
        Fri, 20 Aug 2021 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629474212;
        bh=b422b59o2/iuBngCOgl0Qhixz3jPfHhFSWjOLX53WBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jusAcCR0UY5d7E9GKVxCbr/CJ9dmz9N1jCvQp0bnarClFjPhyAIJjd5nxxOZM1QR/
         w3cWu/d+dvp87KBxKbh2MAAslrTiWIve5aMLLH9ty5QeJA07fHdSqHswAxKBhh5t1z
         GQ5HOIpfE27ExF6KdsRbOmUZOL7x9hk+/fI7eEsFatjM1yVOP2URDlB1ArMdgt8cTG
         p92/nWncPZx+vAACgVXPK5cjRmUE6wmkn0Cw0qL28inLWQ7Lr4VZyijxvpOfOHqeNa
         gQog4fJYvHsLuJt9EASoH8olXSuA2Mjx/fYrM5QJq3FLAYwwBe0SnxhUhdkdI+3A5M
         ms66E+OljGeKw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v12 bpf-next 13/18] bpf: move user_size out of bpf_test_init
Date:   Fri, 20 Aug 2021 17:40:26 +0200
Message-Id: <51b2927711a6285d0e077ed3ee4ffe24ac5a7d7d.1629473234.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
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

