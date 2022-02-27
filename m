Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94C4C5E99
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 21:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiB0U2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 15:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiB0U2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 15:28:40 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC49545515
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:28:02 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id y24so18106603lfg.1
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 12:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8zVHv/5X9Y6MXMK9tQyqtUsITKzj6rXRl92iXL6AqQ4=;
        b=s5u2K6lsRN6HqtnlQkDcwnc5DiTw+2CzBEGwj8yiyCAv80seyb3Hz+SZ5qdB9/Grmh
         umbF77DDVfQebCjsblX4uvb0T/bE5bROlUZjEyAR8XA1lQfk6hdZwkL1atTUc7fLjy13
         OPUie4vvQ62ROcAaaZAnct/yLWv5GIYx3J/DA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8zVHv/5X9Y6MXMK9tQyqtUsITKzj6rXRl92iXL6AqQ4=;
        b=3jMi9qkjvde+1O33UPYqQFl/Nss1hEtW5KxMJyxswRS1Yc0Qnq18OhCfJh7ZJAhI4B
         rZ/8X5LtSD5ZLt23c9BmGeL7Vg4vqCUGpkPBqvjFH73PiQ6l8nECVMXyOzFOaPfsDYQ4
         OZCG3ddibeKmrs9U8Lx+ZBfBps2pjC48RQT7UXj7TW1afp0cLEN2NmCTiRquBzjOxDmv
         owXUB7KWvz69CvphDPtb8KCc6z2x8HNYaTg22g/kR7HGEShKew1+UwYVplhWa5FpZE8O
         3GFuz6n6oJRbJ5dfbfa5/3AYf45bkQp+brAO4t9SNRJ6sATWzsCfJ/NO30GC1OXmsKrY
         wnXg==
X-Gm-Message-State: AOAM533NMKJLyNIZ488cjk9WQ+CrxxgzT7VipP9P8hK1Pmfw78RWOQkv
        XDE3LYIaOr7gSVrVoHgnKa07C7WpuOMuQg==
X-Google-Smtp-Source: ABdhPJx/EiKXwyh5Rfmi4LFfeySH8NWbyZFSf5hpTvxAn6ICm4V3FpLGfApoo4U3WaqUNrQtDU1Z7Q==
X-Received: by 2002:a05:6512:a8b:b0:43c:81fb:8b26 with SMTP id m11-20020a0565120a8b00b0043c81fb8b26mr10822124lfu.479.1645993681129;
        Sun, 27 Feb 2022 12:28:01 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0f9c.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id v9-20020a2e9909000000b00245f269061esm1040422lji.33.2022.02.27.12.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 12:28:00 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Fix test for 4-byte load from dst_port on big-endian
Date:   Sun, 27 Feb 2022 21:27:57 +0100
Message-Id: <20220227202757.519015-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220227202757.519015-1-jakub@cloudflare.com>
References: <20220227202757.519015-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for 4-byte load from dst_port offset into bpf_sock is failing on
big-endian architecture - s390. The bpf access converter rewrites the
4-byte load to a 2-byte load from sock_common at skc_dport offset, as shown
below.

  * s390 / llvm-objdump -S --no-show-raw-insn

  00000000000002a0 <sk_dst_port__load_word>:
        84:       r1 = *(u32 *)(r1 + 48)
        85:       w0 = 1
        86:       if w1 == 51966 goto +1 <LBB5_2>
        87:       w0 = 0
  00000000000002c0 <LBB5_2>:
        88:       exit

  * s390 / bpftool prog dump xlated

  _Bool sk_dst_port__load_word(struct bpf_sock * sk):
    35: (69) r1 = *(u16 *)(r1 +12)
    36: (bc) w1 = w1
    37: (b4) w0 = 1
    38: (16) if w1 == 0xcafe goto pc+1
    39: (b4) w0 = 0
    40: (95) exit

  * s390 / llvm-objdump -S --no-show-raw-insn

  00000000000002a0 <sk_dst_port__load_word>:
        84:       r1 = *(u32 *)(r1 + 48)
        85:       w0 = 1
        86:       if w1 == 65226 goto +1 <LBB5_2>
        87:       w0 = 0
  00000000000002c0 <LBB5_2>:
        88:       exit

  * x86_64 / bpftool prog dump xlated

  _Bool sk_dst_port__load_word(struct bpf_sock * sk):
    33: (69) r1 = *(u16 *)(r1 +12)
    34: (b4) w0 = 1
    35: (16) if w1 == 0xfeca goto pc+1
    36: (b4) w0 = 0
    37: (95) exit

This leads to surprisings results. On big-endian platforms, the loaded
value is as expected. The user observes no difference between a 4-byte load
and 2-byte load. However, on little-endian platforms, the access conversion
is not what would be expected, that is the result is left shifted after
converting the value to the native byte order.

That said, 4-byte loads in BPF from sk->dst_port are not a use case we
expect to see, now that the dst_port field is clearly declared as a u16.

Account for the quirky behavior of the access converter in the test case,
so that the check passes on both endian variants.

Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/progs/test_sock_fields.c        | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools/testing/selftests/bpf/progs/test_sock_fields.c
index 186fed1deaab..3dddc173070c 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -256,10 +256,23 @@ int ingress_read_sock_fields(struct __sk_buff *skb)
 	return CG_OK;
 }
 
+/*
+ * NOTE: 4-byte load from bpf_sock at dst_port offset is quirky. The
+ * result is left shifted on little-endian architectures because the
+ * access is converted to a 2-byte load. The quirky behavior is kept
+ * for backward compatibility.
+ */
 static __noinline bool sk_dst_port__load_word(struct bpf_sock *sk)
 {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	const __u8 SHIFT = 16;
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	const __u8 SHIFT = 0;
+#else
+#error "Unrecognized __BYTE_ORDER__"
+#endif
 	__u32 *word = (__u32 *)&sk->dst_port;
-	return word[0] == bpf_htonl(0xcafe0000);
+	return word[0] == bpf_htonl(0xcafe << SHIFT);
 }
 
 static __noinline bool sk_dst_port__load_half(struct bpf_sock *sk)
-- 
2.35.1

