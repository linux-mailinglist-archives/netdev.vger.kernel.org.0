Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E902D1623
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgLGQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgLGQeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:34:25 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 09/14] bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature
Date:   Mon,  7 Dec 2020 17:32:38 +0100
Message-Id: <f0451f61c70435237f5d7a407b40398f21c4350e.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

introduce xdp_shared_info pointer in bpf_test_finish signature in order
to copy back paged data from a xdp multi-buff frame to userspace buffer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/bpf/test_run.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index e4b7b749184d..32cda04ac7fb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -81,7 +81,8 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 
 static int bpf_test_finish(const union bpf_attr *kattr,
 			   union bpf_attr __user *uattr, const void *data,
-			   u32 size, u32 retval, u32 duration)
+			   struct xdp_shared_info *xdp_sinfo, u32 size,
+			   u32 retval, u32 duration)
 {
 	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
 	int err = -EFAULT;
@@ -96,8 +97,37 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 		err = -ENOSPC;
 	}
 
-	if (data_out && copy_to_user(data_out, data, copy_size))
-		goto out;
+	if (data_out) {
+		int len = xdp_sinfo ? copy_size - xdp_sinfo->data_length
+				    : copy_size;
+
+		if (copy_to_user(data_out, data, len))
+			goto out;
+
+		if (xdp_sinfo) {
+			int i, offset = len, data_len;
+
+			for (i = 0; i < xdp_sinfo->nr_frags; i++) {
+				skb_frag_t *frag = &xdp_sinfo->frags[i];
+
+				if (offset >= copy_size) {
+					err = -ENOSPC;
+					break;
+				}
+
+				data_len = min_t(int, copy_size - offset,
+						 xdp_get_frag_size(frag));
+
+				if (copy_to_user(data_out + offset,
+						 xdp_get_frag_address(frag),
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
@@ -598,7 +628,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	/* bpf program can never convert linear skb to non-linear */
 	if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
 		size = skb_headlen(skb);
-	ret = bpf_test_finish(kattr, uattr, skb->data, size, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, skb->data, NULL, size, retval,
+			      duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
 				     sizeof(struct __sk_buff));
@@ -683,7 +714,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		goto out;
 
 	size = xdp.data_end - xdp.data + xdp_sinfo->data_length;
-	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, xdp.data, xdp_sinfo, size, retval,
+			      duration);
 
 out:
 	bpf_prog_change_xdp(prog, NULL);
@@ -794,8 +826,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	do_div(time_spent, repeat);
 	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
 
-	ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
-			      retval, duration);
+	ret = bpf_test_finish(kattr, uattr, &flow_keys, NULL,
+			      sizeof(flow_keys), retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx,
 				     sizeof(struct bpf_flow_keys));
-- 
2.28.0

