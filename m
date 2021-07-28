Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D763D8AE2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhG1Jj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhG1Jjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF79F60FE5;
        Wed, 28 Jul 2021 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465193;
        bh=7tMnneihX83uYRbb4k8r7/oUvMkzQjKDPsHZ6e5TCtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXVm5PWnmjjRYy6c0p3awWCqstOSRW92SNRy+gyUGiBIVF8EiPfep0gOtQxAhMuQG
         pFUir+73NRsEW7guzSUOmIA+eQEfsHDqrG3y+IASv2kgV7+O1sdU+3pdu/zekTyA9r
         yAphsD46ARqhcwkzPauFBarOIm43xVneu9WZBTOlGFoQH7tQIZk54aK0JxSvYEJTdY
         VOihLIoRffvClBiK5bs+vSTAJusXRm4dyzd/cAqQq2x/B1meDGWqVsXOVywMsnF5NS
         QSbwqRepWiBStG9dHthEeuoE677W77h2miklySSL4Jq08Y4nLr73vVK545xcl2Kpxg
         iFVMKiQPI5k4w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 13/18] bpf: move user_size out of bpf_test_init
Date:   Wed, 28 Jul 2021 11:38:18 +0200
Message-Id: <cae7bd62f093a955a6b726e3f72b1f471ab552cd.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
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
index 8d46e2962786..f514bfe9837b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -245,11 +245,10 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
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
@@ -570,7 +569,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (kattr->test.flags || kattr->test.cpu)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, NET_SKB_PAD + NET_IP_ALIGN,
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -777,7 +777,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* XDP have extra tailroom as (most) drivers use full page */
 	max_data_sz = 4096 - headroom - tailroom;
 
-	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     max_data_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
@@ -861,7 +862,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, 0, 0);
+	data = bpf_test_init(kattr, kattr->test.data_size_in, size, 0, 0);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-- 
2.31.1

