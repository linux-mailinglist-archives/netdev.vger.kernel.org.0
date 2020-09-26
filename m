Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ACB2796E3
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 06:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgIZE1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 00:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZE1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 00:27:18 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9959DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:27:18 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a2so4281282otr.11
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 21:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=I64ATC64dCN3eds+XwzbuzVXVEJWGaENoiPsrteTT2o=;
        b=Nu4gw5eHNUc1Rn/rmZtosUga0gXWcn8svap6HOKJIDTrvSogeQFJwBrbxefijpTZSK
         Rn7k9L1gXT8ZcnyxSlETTK08QoW3BNulgBhh3MMYZPJvfce4/BBUEaFkeUrGuVti19hs
         dbl1KxXAWT36hUki10hPekJpHRmN27cnuFkrR11urJJoz05fm2yn6/ca+tWIVe2NpR4g
         FnfAvj16i8VYfPHta4C0rHgbAjtKBmnG2kPKuZaJP/S3cJkC5Ql3oFffcIxozLFFk/vL
         33pcQu/0zkEq4IPAxquDIXD9kNJO6H1N1AQulLbSUltZP+mvtyizkiOWkQlH+QASjrky
         COfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=I64ATC64dCN3eds+XwzbuzVXVEJWGaENoiPsrteTT2o=;
        b=E9+sehcpndeVM1Earki4ZrtP/GeU3w0FgRCVGq/BCnKVH4OUNH55euiqekuKjBRSOL
         Dclpunoehd0mi0O5Tlx7/CiMAsve/zWJ8XXIndD4BrHwHHc5VELdPCByi5zZ0hALDULq
         D/bh7mwnI/MKkKXSj0+qtgKOtMAn1/SHEg3VkeEelaiaNfG2abQdFdDFqwB8wpXV1pP2
         3u4q0ct/Uy+LQGbAynyOdLRCCGZ0pWDRJ4EF/t9xZ+YX3NgA4DZLzT9VUXcpB9+ztlVC
         Vchp/b4YMH+Zpm5cnDSW/JEbSTegNmP+ZwtxtariGYgqrmIyi11JEpg02nLVCPp+ciI3
         ++7g==
X-Gm-Message-State: AOAM530qd2FmEZq+a+aLjRZt+XX1BkMtdN3tQ6U9HN5kRWl/nfQpf9uv
        u/q6Z6rxdwLnnr+LIgHR2pg=
X-Google-Smtp-Source: ABdhPJw46xh4pkIu33w7Iup+PxZuPKzUXGaUg9vMVUpJZL1Tvgl00XvuBgB1j5dZtQhu0ycCK9y9hw==
X-Received: by 2002:a9d:5a8:: with SMTP id 37mr2378498otd.362.1601094438025;
        Fri, 25 Sep 2020 21:27:18 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g21sm372037oos.36.2020.09.25.21.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 21:27:17 -0700 (PDT)
Subject: [bpf-next PATCH 1/2] bpf,
 sockmap: add skb_adjust_room to pop bytes off ingress payload
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, lmb@cloudflare.com
Date:   Fri, 25 Sep 2020 21:27:05 -0700
Message-ID: <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
In-Reply-To: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements a new helper skb_adjust_room() so users can push/pop
extra bytes from a BPF_SK_SKB_STREAM_VERDICT program.

Some protocols may include headers and other information that we may
not want to include when doing a redirect from a BPF_SK_SKB_STREAM_VERDICT
program. One use case is to redirect TLS packets into a receive socket
that doesn't expect TLS data. In TLS case the first 13B or so contain the
protocol header. With KTLS the payload is decrypted so we should be able
to redirect this to a receiving socket, but the receiving socket may not
be expecting to receive a TLS header and discard the data. Using the
above helper we can pop the header off and put an appropriate header on
the payload. This allows for creating a proxy between protocols without
extra hops through the stack or userspace.

So in order to fix this case add skb_adjust_room() so users can strip the
header. After this the user can strip the header and an unmodified receiver
thread will work correctly when data is redirected into the ingress path
of a sock.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4d8dc7a31a78..d232358f1dcd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -76,6 +76,7 @@
 #include <net/bpf_sk_storage.h>
 #include <net/transp_v6.h>
 #include <linux/btf_ids.h>
+#include <net/tls.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -3218,6 +3219,53 @@ static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 			  SKB_MAX_ALLOC;
 }
 
+BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
+	   u32, mode, u64, flags)
+{
+	unsigned int len_diff_abs = abs(len_diff);
+	bool shrink = len_diff < 0;
+	int ret = 0;
+
+	if (unlikely(flags))
+		return -EINVAL;
+	if (unlikely(len_diff_abs > 0xfffU))
+		return -EFAULT;
+
+	if (!shrink) {
+		unsigned int grow = len_diff;
+
+		ret = skb_cow(skb, grow);
+		if (likely(!ret)) {
+			__skb_push(skb, len_diff_abs);
+			memset(skb->data, 0, len_diff_abs);
+		}
+	} else {
+		/* skb_ensure_writable() is not needed here, as we're
+		 * already working on an uncloned skb.
+		 */
+		if (unlikely(!pskb_may_pull(skb, len_diff_abs)))
+			return -ENOMEM;
+		__skb_pull(skb, len_diff_abs);
+	}
+	bpf_compute_data_end_sk_skb(skb);
+	if (tls_sw_has_ctx_rx(skb->sk)) {
+		struct strp_msg *rxm = strp_msg(skb);
+
+		rxm->full_len += len_diff;
+	}
+	return ret;
+}
+
+static const struct bpf_func_proto sk_skb_adjust_room_proto = {
+	.func		= sk_skb_adjust_room,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_ANYTHING,
+};
+
 BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
 	   u32, mode, u64, flags)
 {
@@ -6483,6 +6531,7 @@ bool bpf_helper_changes_pkt_data(void *func)
 	    func == bpf_skb_change_tail ||
 	    func == sk_skb_change_tail ||
 	    func == bpf_skb_adjust_room ||
+	    func == sk_skb_adjust_room ||
 	    func == bpf_skb_pull_data ||
 	    func == sk_skb_pull_data ||
 	    func == bpf_clone_redirect ||
@@ -6950,6 +6999,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &sk_skb_change_tail_proto;
 	case BPF_FUNC_skb_change_head:
 		return &sk_skb_change_head_proto;
+	case BPF_FUNC_skb_adjust_room:
+		return &sk_skb_adjust_room_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_cookie_proto;
 	case BPF_FUNC_get_socket_uid:

