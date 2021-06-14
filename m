Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A47E3A6725
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhFNMyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhFNMxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0A2613B2;
        Mon, 14 Jun 2021 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675090;
        bh=Qot+eotTh2oiGlHvSN2SqVnGW+t603L5OMXwTJ6csiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fu4GG6XORvyK4H9VUSr+omdlezH4G3u+HvepVhYBaKHxzu06EnwkbRSX9k+leJWrX
         7UqkHSkMYxy4zSspNVXXGD4m7Tf3uvhtXbZRTDIUWJK/heFmgh79QZvFKujk5yDT1E
         1NVtSDDJzSbx2dZiJEoTmQHSSg1RLC9k8K03CYaQwKkghF2TwMNtWguxkHuPNQuNLz
         QQ9R7RlRCCg1aQPj7KyPV9+wr20x8ywbCAeOWJpXT/S4C3jTqab0ZoTy1xwA8gtulG
         jMX8RID3pSu88M4focJF7A4yuSw4mcJiQhKa18HHMAjTM/t1hmFVa7/tqFRZ7VjfVU
         4c9T3thjufdtQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 13/14] bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature
Date:   Mon, 14 Jun 2021 14:49:51 +0200
Message-Id: <38b246295b3fd18556f168434e7362182417f2ad.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

introduce xdp_shared_info pointer in bpf_test_finish signature in order
to copy back paged data from a xdp multi-buff frame to userspace buffer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 47 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 5e2c8478ae18..e6b15e3d2086 100644
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
+		int len = sinfo ? copy_size - sinfo->data_len : copy_size;
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
@@ -755,7 +785,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		goto out;
 
 	size = xdp.data_end - xdp.data + sinfo->data_len;
-	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, xdp.data, sinfo, size, retval,
+			      duration);
 
 out:
 	bpf_prog_change_xdp(prog, NULL);
@@ -841,8 +872,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	if (ret < 0)
 		goto out;
 
-	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
-			      retval, duration);
+	ret = bpf_test_finish(kattr, uattr, &flow_keys, NULL,
+			      sizeof(flow_keys), retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx,
 				     sizeof(struct bpf_flow_keys));
@@ -946,7 +977,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
 	}
 
-	ret = bpf_test_finish(kattr, uattr, NULL, 0, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx, sizeof(*user_ctx));
 
-- 
2.31.1

