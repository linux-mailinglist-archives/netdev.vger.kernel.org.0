Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5809F5A76A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF1XKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:10:53 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45195 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:10:53 -0400
Received: by mail-pg1-f202.google.com with SMTP id n7so3900836pgr.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H1uw8GNHqdne1YqmW30hQmg7ehvjJ07bgavin0v97FA=;
        b=G1HGo98N06/C96ASXTRQ8Z8DwfpQ4rC88TZvh6R7AuL8Bb0uMCA64FgFwfWI2OrlW/
         5ZYxVu3fBdgzsYk082oSaxiDQ7WI6m7GR2IhKVgd296VQNlZa+BcFhDzjqyLQLnd0w+L
         M57d/1psVlxo/oszPG70J9CMX+jmcJJ2gLUQvTiB6ip2Q+CvmJTQGqXLGB1ixAhRqUKT
         F3Mr4ZAHddLFcizilTx9AAtfz2fjcweEKNNWvgfpTQFGZe7ni46zS41PKUYchuqyinH6
         pRRYoYS+1iYxRq1UBr2W3VIwYAixrTKZoj1rPtrdgkeHvlKwALMvpzQHM+axZXLsgE9q
         U8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H1uw8GNHqdne1YqmW30hQmg7ehvjJ07bgavin0v97FA=;
        b=fiepx2xy9OHibjsygJj2kmd3eD9eMjbv9v8hxfCsoBdtfA52iKDDY5IlKELQORkz9u
         Ex47FBcg1+M8BBBhV2uJa6SBChri2Rg7F3PgrrygQUOXKHIqjwGPxxcgAES+vHUPxFNe
         wfk1SiF30KEh7JuDlEty4QTERkx/qhe/d/dZPhRfX3Q89hbO6MVlPfGliGUIKha059Np
         q1UadxxWBmjfp/7Q707pGmyWRFjOSM10eIthasXND6Yh9teYqzO0rwBr+vdoXVfef3EG
         x3sz8hDkpAZDWGTMSHCqHxLWyKXEu24yUuXD78QRvDddrntmV0WN8h/LxVG3Pcij7nnm
         dT0g==
X-Gm-Message-State: APjAAAXSc4uPs5au0QqKC2DsxXAg1KMBv+ZMWCbpk36cwSyOxFGN/WyM
        mWcJOIQt9di2LKsVJHO9+RiOKYv/WDSBvoR8/IAAcGuOrOSiTE05nLL/YcY/CTj/6oOd1b39flL
        zyfEPZYAWO0SopxZCv3B28jWYoR9Uk7RMs8ql3ZVdOn3Qfn/4GuImgQ==
X-Google-Smtp-Source: APXvYqzn1y/EUNmYcU6bEtZmjhaAhzm9/gCbpGaC5ql1JodiKRqRZXv/A3SZQLptiFW84eM3ykNpngA=
X-Received: by 2002:a63:a61:: with SMTP id z33mr11668815pgk.154.1561763451833;
 Fri, 28 Jun 2019 16:10:51 -0700 (PDT)
Date:   Fri, 28 Jun 2019 16:10:48 -0700
Message-Id: <20190628231049.22149-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next 1/2] bpf: allow wide (u64) aligned stores for some
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/filter.h |  6 ++++++
 net/core/filter.c      | 22 ++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 340f7d648974..3901007e36f1 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -746,6 +746,12 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
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
diff --git a/net/core/filter.c b/net/core/filter.c
index dc8534be12fc..5d33f2146dab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6849,6 +6849,16 @@ static bool sock_addr_is_valid_access(int off, int size,
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
@@ -7689,9 +7699,6 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 /* SOCK_ADDR_STORE_NESTED_FIELD_OFF() has semantic similar to
  * SOCK_ADDR_LOAD_NESTED_FIELD_SIZE_OFF() but for store operation.
  *
- * It doesn't support SIZE argument though since narrow stores are not
- * supported for now.
- *
  * In addition it uses Temporary Field TF (member of struct S) as the 3rd
  * "register" since two registers available in convert_ctx_access are not
  * enough: we can't override neither SRC, since it contains value to store, nor
@@ -7699,7 +7706,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
  * instructions. But we need a temporary place to save pointer to nested
  * structure whose field we want to store to.
  */
-#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, OFF, TF)		       \
+#define SOCK_ADDR_STORE_NESTED_FIELD_OFF(S, NS, F, NF, SIZE, OFF, TF)	       \
 	do {								       \
 		int tmp_reg = BPF_REG_9;				       \
 		if (si->src_reg == tmp_reg || si->dst_reg == tmp_reg)	       \
@@ -7710,8 +7717,7 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(S, TF));			       \
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(S, F), tmp_reg,	       \
 				      si->dst_reg, offsetof(S, F));	       \
-		*insn++ = BPF_STX_MEM(					       \
-			BPF_FIELD_SIZEOF(NS, NF), tmp_reg, si->src_reg,	       \
+		*insn++ = BPF_STX_MEM(SIZE, tmp_reg, si->src_reg,	       \
 			bpf_target_off(NS, NF, FIELD_SIZEOF(NS, NF),	       \
 				       target_size)			       \
 				+ OFF);					       \
@@ -7723,8 +7729,8 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
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

