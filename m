Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88B280BDA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387553AbgJBBKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387511AbgJBBKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:10:03 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDAEC0613D0;
        Thu,  1 Oct 2020 18:10:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b12so270343ilh.12;
        Thu, 01 Oct 2020 18:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=M4aMGOrbLeQFVceqzMl75Ma/Bfw3CS7qVnZSFE8I8bc=;
        b=dwAOWYAVX+i4pxTdm1uHQBianbdBFULAc7EQ2Q1QD6OYH1p/PEz+eVlGPQ9yfbN2iM
         z3Fs5aKDv0HC8U7Sht819BzipG5EuI9+mBPIJChoCEXcu/BW20Arg+wPaXqFUIqv7h3D
         80W0O87h2kgUTypy55sZH8nWOSCeYDOAeGdJuFCsb8IICQKTkA40eII0jWNycqqqoBjC
         2hj9dzETgdGe4R1ZZPZke2fgQb//O4KTMuLKeE1tHQpPYVYhaCb1AysJyEDoBLHNb4Ev
         fr9/Tgat+9xWl1qUrfvyOwJrFKIU/jgJZmCinIStmZqCUDecEttRMg/4WeCTFNBz6RRE
         /EYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=M4aMGOrbLeQFVceqzMl75Ma/Bfw3CS7qVnZSFE8I8bc=;
        b=oXvmDwqfl5sm2kuE0ZcPBH6CV1DSmXow3XhmjN+2YE5ibhdpgZUa/fYo1mQ8ckhyyA
         RN4Wgdyw2zFygu1QOPFWUyBnIivqRG6ZkyzWDHTQgX+FN0uG6ZD3xuNmBEp8o1UX0Sha
         mJNhhCSl1wefHDur3Z+VNJTUH+x5DQE1busS1ltns/QhLYZO7sRIko26w16Fab3yDADz
         y08f9xyqy5m4qhiVC7OLo4xdqN9fxb22G7cpKrCxj6ZjZJT6thyzql8vzN1XV4yEFPj1
         SN7/YmdokKpySNa9pGXvO8xpS5D+M3cVLrpsBgMpQy8U/JyrYocFqwH9GqyUeG622TVu
         b4CQ==
X-Gm-Message-State: AOAM5315OQ8fhiyhdoWS8r4UaVHWABGhW/dNjy5bsraPpJG8wFFrge/O
        pAR0qxWXoEsls2w8ka6WwH0=
X-Google-Smtp-Source: ABdhPJyW1B+Yi+RSS+Nng6AYwkehTi3FO3NnO8ogpbQCzirgzLn0RmexAPokQp1afYAph9lcoAnJrQ==
X-Received: by 2002:a92:1504:: with SMTP id v4mr4936431ilk.26.1601601002747;
        Thu, 01 Oct 2020 18:10:02 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v17sm3677668ilj.58.2020.10.01.18.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 18:10:02 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/2] bpf,
 sockmap: add skb_adjust_room to pop bytes off ingress payload
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 01 Oct 2020 18:09:52 -0700
Message-ID: <160160099197.7052.8443193973242831692.stgit@john-Precision-5820-Tower>
In-Reply-To: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
References: <160160094764.7052.2711632803258461907.stgit@john-Precision-5820-Tower>
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
 net/core/filter.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index af88935e24b1..ad4d82a6a994 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -76,6 +76,7 @@
 #include <net/bpf_sk_storage.h>
 #include <net/transp_v6.h>
 #include <linux/btf_ids.h>
+#include <net/tls.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -3218,6 +3219,48 @@ static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 			  SKB_MAX_ALLOC;
 }
 
+BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
+	   u32, mode, u64, flags)
+{
+	u32 len_diff_abs = abs(len_diff);
+	bool shrink = len_diff < 0;
+	int ret = 0;
+
+	if (unlikely(flags || mode))
+		return -EINVAL;
+	if (unlikely(len_diff_abs > 0xfffU))
+		return -EFAULT;
+
+	if (!shrink) {
+		ret = skb_cow(skb, len_diff);
+		if (unlikely(ret < 0))
+			return ret;
+		__skb_push(skb, len_diff_abs);
+		memset(skb->data, 0, len_diff_abs);
+	} else {
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
@@ -6484,6 +6527,7 @@ bool bpf_helper_changes_pkt_data(void *func)
 	    func == bpf_skb_change_tail ||
 	    func == sk_skb_change_tail ||
 	    func == bpf_skb_adjust_room ||
+	    func == sk_skb_adjust_room ||
 	    func == bpf_skb_pull_data ||
 	    func == sk_skb_pull_data ||
 	    func == bpf_clone_redirect ||
@@ -6951,6 +6995,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &sk_skb_change_tail_proto;
 	case BPF_FUNC_skb_change_head:
 		return &sk_skb_change_head_proto;
+	case BPF_FUNC_skb_adjust_room:
+		return &sk_skb_adjust_room_proto;
 	case BPF_FUNC_get_socket_cookie:
 		return &bpf_get_socket_cookie_proto;
 	case BPF_FUNC_get_socket_uid:

