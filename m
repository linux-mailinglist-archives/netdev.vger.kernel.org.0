Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5653D8AE6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhG1JkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhG1JkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC3660FE3;
        Wed, 28 Jul 2021 09:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465201;
        bh=UHB58czNu4iRhtY8ZDyDcUV4RgVRb2Sw9kI0vXMJuTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8ClAdvIBUNj9W+SeKRkbOm+NU3OlpstP3GAdgF8zS+x/ncBiEuh9IgwYIJwLIfVG
         yP2WrAawzTRI/GTDft+pDmtIEH8m+zbDmLssZnwwUYRnNEmJdJIF2EZi5IabIeVVuZ
         dtuAJZ0JlRj+4+g37PGD3cVe7huzzMKHhAR6mUuvzRjUP7qwThf2V6qaJ3yVLeH+eV
         MgqHgX320WtTG7HDggPBYUf3KRGrzTUWLLcPBu+PWBzs7d87pbFQxmMHCDpnYax1oS
         MEV+SjKManA15f12CaSWM+WgpHq32dViyVBezXNkjcaT8Hc2MpPdVqlJ/z34Ov1TqE
         4o3RpL9TSSocA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 15/18] bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature
Date:   Wed, 28 Jul 2021 11:38:20 +0200
Message-Id: <18e45a83d018653e911ed5f89c49f3f170622a28.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

introduce xdp_shared_info pointer in bpf_test_finish signature in order
to copy back paged data from a xdp multi-buff frame to userspace buffer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 48 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 529c9d9ae702..1258a0a3f352 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -128,7 +128,8 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 
 static int bpf_test_finish(const union bpf_attr *kattr,
 			   union bpf_attr __user *uattr, const void *data,
-			   u32 size, u32 retval, u32 duration)
+			   struct skb_shared_info *sinfo, u32 size,
+			   u32 retval, u32 duration)
 {
 	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
 	int err = -EFAULT;
@@ -143,8 +144,36 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 		err = -ENOSPC;
 	}
 
-	if (data_out && copy_to_user(data_out, data, copy_size))
-		goto out;
+	if (data_out) {
+		int len = sinfo ? copy_size - sinfo->xdp_frags_size : copy_size;
+
+		if (copy_to_user(data_out, data, len))
+			goto out;
+
+		if (sinfo) {
+			int i, offset = len, data_len;
+
+			for (i = 0; i < sinfo->nr_frags; i++) {
+				skb_frag_t *frag = &sinfo->frags[i];
+
+				if (offset >= copy_size) {
+					err = -ENOSPC;
+					break;
+				}
+
+				data_len = min_t(int, copy_size - offset,
+						 skb_frag_size(frag));
+
+				if (copy_to_user(data_out + offset,
+						 skb_frag_address(frag),
+						 data_len))
+					goto out;
+
+				offset += data_len;
+			}
+		}
+	}
+
 	if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size)))
 		goto out;
 	if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)))
@@ -673,7 +702,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* bpf program can never convert linear skb to non-linear */
 	if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
 		size = skb_headlen(skb);
-	ret = bpf_test_finish(kattr, uattr, skb->data, size, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, skb->data, NULL, size, retval,
+			      duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
 				     sizeof(struct __sk_buff));
@@ -837,8 +867,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		goto out;
 
 	size = xdp.data_end - xdp.data_meta + sinfo->xdp_frags_size;
-	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, size, retval,
-			      duration);
+	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, sinfo, size,
+			      retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
 				     sizeof(struct xdp_md));
@@ -929,8 +959,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (ret < 0)
 		goto out;
 
-	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
-			      retval, duration);
+	ret = bpf_test_finish(kattr, uattr, &flow_keys, NULL,
+			      sizeof(flow_keys), retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx,
 				     sizeof(struct bpf_flow_keys));
@@ -1034,7 +1064,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
 	}
 
-	ret = bpf_test_finish(kattr, uattr, NULL, 0, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx, sizeof(*user_ctx));
 
-- 
2.31.1

