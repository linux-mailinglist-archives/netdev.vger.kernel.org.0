Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FB5C218
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfGARis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:38:48 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40591 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfGARir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:38:47 -0400
Received: by mail-pl1-f201.google.com with SMTP id 91so7626731pla.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 10:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LuA5/ZzaFRvCrMv8h/GWULJQIiv6PMuzB4YrBHKvmDg=;
        b=XPjWxcbjt+1M7BigI9mdLIaLUNs5k73XfEpIFKv82/ZK6m6kXh0QS4NVugfJQ/MdmP
         Wh2xUzIGP4V++aeAAb+A6n6rnvF25/SC695jU1QBAcLvHcW1p0RP+BTXVPKHQwwJzZjS
         o622YxGTeAG4GCBcBR5I+zMkePztaY++dOqzTXC1vWdsNrhkB1Q0AZzxZToRui6VjZPX
         /H4XI9mTcOIqfLmM1W1D5Lj7SBrMgetXsYdYCquxcUnoNfSQ0TIc3/us4SDmUGQ86bnR
         Y/dy2QnemEFBZFm95tu4bze/OBsZVbf+9kCEUX70haugxsSWwZ2IJ7w4MuJqiuIK6Uq3
         Pn3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LuA5/ZzaFRvCrMv8h/GWULJQIiv6PMuzB4YrBHKvmDg=;
        b=c/saQtij0qG4uBg3nEPT0pT7aka1SZI8oNbL6Ie7EXKdOGLXfGw7sdzDEY9utjWfxn
         EFXkwV3l1v0gFXgrAl+ylY/NTM3FqD4LNho1vjjtSdWhtE3k/fX5mOatOXlyAlc/VhmC
         q2XNGKIKJg+z1pp4aPgCsYNwhydOgZZhP5n+QIm10/Bf3rnx+ixWrQW7S/wyVP0gZOiQ
         lzQ2s2fANLXuq8RyOdJkLlxqdBOezaFx5WjY8BH0mkTop0t6oFFEhYaOl2b4WaMaOeuh
         Ci1FQFRnCA8nsNX9udnnOsd935HfKYAFA8Iku2O3OaqOhCEpJQYU3ou1hQFfZHq2ASgZ
         VgxQ==
X-Gm-Message-State: APjAAAWnYCbrCLicVa1IEPrdYg6vvk64VoYo8CsWXDIX7Zw1JGh9adKj
        esteerEyaPXQMLLvo4xPsA5Kjc6KJbCRjA8Vk+bWfA5qsDgXYPGcaWXTezTJD7cJaOZMYwdF+l5
        k5ktef/PLa4arDQC1HWZTwToqV6UOQjAm9MrA/Yn2s4FXtCSY/PIIFw==
X-Google-Smtp-Source: APXvYqxOo4BnqXg6L2bQyvUaAQXaVM215HW/11c/JpdlnecYaZda0I/b0jjRLCCs/4CHPxbDXcTW6Ig=
X-Received: by 2002:a63:60c8:: with SMTP id u191mr24307007pgb.401.1562002726488;
 Mon, 01 Jul 2019 10:38:46 -0700 (PDT)
Date:   Mon,  1 Jul 2019 10:38:39 -0700
In-Reply-To: <20190701173841.32249-1-sdf@google.com>
Message-Id: <20190701173841.32249-2-sdf@google.com>
Mime-Version: 1.0
References: <20190701173841.32249-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v3 1/3] bpf: allow wide (u64) aligned stores for some
 fields of bpf_sock_addr
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        kernel test robot <rong.a.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit cd17d7770578 ("bpf/tools: sync bpf.h") clang decided
that it can do a single u64 store into user_ip6[2] instead of two
separate u32 ones:

 #  17: (18) r2 = 0x100000000000000
 #  ; ctx->user_ip6[2] = bpf_htonl(DST_REWRITE_IP6_2);
 #  19: (7b) *(u64 *)(r1 +16) = r2
 #  invalid bpf_context access off=16 size=8

From the compiler point of view it does look like a correct thing
to do, so let's support it on the kernel side.

Credit to Andrii Nakryiko for a proper implementation of
bpf_ctx_wide_store_ok.

Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Fixes: cd17d7770578 ("bpf/tools: sync bpf.h")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/filter.h   |  6 ++++++
 include/uapi/linux/bpf.h |  6 +++---
 net/core/filter.c        | 22 ++++++++++++++--------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1fe53e78c7e3..6d944369ca87 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -747,6 +747,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
 	return size <= size_default && (size & (size - 1)) == 0;
 }
 
+#define bpf_ctx_wide_store_ok(off, size, type, field)			\
+	(size == sizeof(__u64) &&					\
+	off >= offsetof(type, field) &&					\
+	off + sizeof(__u64) <= offsetofend(type, field) &&		\
+	off % sizeof(__u64) == 0)
+
 #define bpf_classic_proglen(fprog) (fprog->len * sizeof(fprog->filter[0]))
 
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index cffea1826a1f..dcdc606e57d6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3240,7 +3240,7 @@ struct bpf_sock_addr {
 	__u32 user_ip4;		/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 user_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 user_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__u32 user_port;	/* Allows 4-byte read and write.
@@ -3249,10 +3249,10 @@ struct bpf_sock_addr {
 	__u32 family;		/* Allows 4-byte read, but no write */
 	__u32 type;		/* Allows 4-byte read, but no write */
 	__u32 protocol;		/* Allows 4-byte read, but no write */
-	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 msg_src_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
 				 * Stored in network byte order.
 				 */
-	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read an 4-byte write.
+	__u32 msg_src_ip6[4];	/* Allows 1,2,4-byte read and 4,8-byte write.
 				 * Stored in network byte order.
 				 */
 	__bpf_md_ptr(struct bpf_sock *, sk);
diff --git a/net/core/filter.c b/net/core/filter.c
index 4836264f82ee..2520dbc539fc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6851,6 +6851,16 @@ static bool sock_addr_is_valid_access(int off, int size,
 			if (!bpf_ctx_narrow_access_ok(off, size, size_default))
 				return false;
 		} else {
+			if (bpf_ctx_wide_store_ok(off, size,
+						  struct bpf_sock_addr,
+						  user_ip6))
+				return true;
+
+			if (bpf_ctx_wide_store_ok(off, size,
+						  struct bpf_sock_addr,
+						  msg_src_ip6))
+				return true;
+
 			if (size != size_default)
 				return false;
 		}
@@ -7691,9 +7701,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
  * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
  *
- * It doesn't support SIZE argument though since narrow stores are not
- * supported for now.
- *
  * In addition it uses Temporary Field TF (member of struct S) as the 3rd
  * "register" since two registers available in convert_ctx_access are not
  * enough: we can't override neither SRC, since it contains value to store, nor
@@ -7701,7 +7708,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
  * instructions. But we need a temporary place to save pointer to nested
  * structure whose field we want to store to.
  */
-#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)		       \
+#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)	       \
 	do {								       \
 		int tmp_reg = BPF_REG_9;				       \
 		if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)	       \
@@ -7712,8 +7719,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(S, TF));			       \
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,	       \
 				      si->dst_reg, offsetof(S, F));	       \
-		*insn++ = BPF_STX_MEM(					       \
-			BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,	       \
+		*insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,	       \
 			bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),	       \
 				       target_size)			       \
 				+ OFF);					       \
@@ -7725,8 +7731,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 						      TF)		       \
 	do {								       \
 		if (type == BPF_WRITE) {				       \
-			SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF,    \
-							 TF);		       \
+			SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE,   \
+							 OFF, TF);	       \
 		} else {						       \
 			SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF(		       \
 				S, NS, F, NF, SIZE, OFF);  \
-- 
2.22.0.410.gd8fdbe21b5-goog

