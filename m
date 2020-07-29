Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3B6232287
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgG2QX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:23:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F9EC061794;
        Wed, 29 Jul 2020 09:23:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q75so16994970iod.1;
        Wed, 29 Jul 2020 09:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/3TbGTueZcrqvdwrfCmEmLa+fDuDLnYsExrijNLgl5g=;
        b=fCtbUJ4kra/4nZGMl8lYZHk3mP3YjN5ak3yW1lW57bfZcCSzyCkeNA9zanDrh48mD8
         mvSQif9ZktO3nKINpxToy4dJLxVYGrrXNuqbv+n/zSHtsEkRhaHdc1XjtXfxSapjiF1b
         MHT2ODZ5bi7qnkmKZCfsXLxP4EG3v48ii71HXQQ4FQCv4VkOLfOa+9QUgh6zrgeIA1Wi
         rOHSqusCMzQPu28qZXBUAWGfFWiByoKU+SJWA5OklMSvK9bFUxKl6UC9eoWb8Rs8tiKd
         xvqdh/mjKlBvwuBvh26hJCAmdNta6s7GMAbwLCCMsIzDNxdyqyc6v0E3TvphhVQBR1hp
         DKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/3TbGTueZcrqvdwrfCmEmLa+fDuDLnYsExrijNLgl5g=;
        b=h1hZjqXa9UC6lNic5a7Y1TEzCPt5pqMFqbFoStxeHs7GWeYSEcHGNNc9p/SHWliw81
         ZFJjed6YYRiMCiO0QhBoYNEmFxVR2dzFi7wexP9keRDeyj0/2yyjI6P1m7M27l4ZhLSF
         gLflfR/gms1p3t1f7LZbB214hBk/PgHA7uvBJLbUJ8/v/4QpWq3k2OyMKtBB1FN4aUCR
         k/ldyFCNbtt3/afeyoH646bMG2woIg4OUKPEmTo5FXIByJyflKCY5s5WfLRyQV5pJnJZ
         2MoTMJpFu9cJ9RnG8fZICxf65LmlKN88K3asGgx/JXhOLW3gBfnLkdJ+TH9eMfuiFeYp
         LCVA==
X-Gm-Message-State: AOAM530aZiRnMMystbi4yuv5N3LdxGLnzQS2wnbPSpSurdcbFY+VJAoc
        Tj5WQ6h4ps3Zs2Wtzhsaps8=
X-Google-Smtp-Source: ABdhPJybIJh6xboMsHH0Cri1j/TG4YSmSqo7BHrm+GLrPEUb7dc9ap4tyuJclro2auZHWFJ1LGY78A==
X-Received: by 2002:a02:854a:: with SMTP id g68mr38976310jai.24.1596039806855;
        Wed, 29 Jul 2020 09:23:26 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t12sm1390574ilo.80.2020.07.29.09.23.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:23:26 -0700 (PDT)
Subject: [bpf PATCH v2 2/5] bpf: sock_ops sk access may stomp registers when
 dst_reg = src_reg
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:23:13 -0700
Message-ID: <159603979365.4454.14002555655802904027.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to patch ("bpf: sock_ops ctx access may stomp registers") if the
src_reg = dst_reg when reading the sk field of a sock_ops struct we
generate xlated code,

  53: (61) r9 = *(u32 *)(r9 +28)
  54: (15) if r9 == 0x0 goto pc+3
  56: (79) r9 = *(u64 *)(r9 +0)

This stomps on the r9 reg to do the sk_fullsock check and then when
reading the skops->sk field instead of the sk pointer we get the
sk_fullsock. To fix use similar pattern noted in the previous fix
and use the temp field to save/restore a register used to do
sk_fullsock check.

After the fix the generated xlated code reads,

  52: (7b) *(u64 *)(r9 +32) = r8
  53: (61) r8 = *(u32 *)(r9 +28)
  54: (15) if r9 == 0x0 goto pc+3
  55: (79) r8 = *(u64 *)(r9 +32)
  56: (79) r9 = *(u64 *)(r9 +0)
  57: (05) goto pc+1
  58: (79) r8 = *(u64 *)(r9 +32)

Here r9 register was in-use so r8 is chosen as the temporary register.
In line 52 r8 is saved in temp variable and at line 54 restored in case
fullsock != 0. Finally we handle fullsock == 0 case by restoring at
line 58.

This adds a new macro SOCK_OPS_GET_SK it is almost possible to merge
this with SOCK_OPS_GET_FIELD, but I found the extra branch logic a
bit more confusing than just adding a new macro despite a bit of
duplicating code.

Fixes: 1314ef561102e ("bpf: export bpf_sock for BPF_PROG_TYPE_SOCK_OPS prog type")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 15a0842..0ddaed3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8355,6 +8355,43 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		}							      \
 	} while (0)
 
+#define SOCK_OPS_GET_SK()							      \
+	do {								      \
+		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 1;     \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == si->src_reg) {			      \
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
+					  offsetof(struct bpf_sock_ops_kern,  \
+					  temp));			      \
+			fullsock_reg = reg;				      \
+			jmp += 2;					      \
+		}							      \
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
+						struct bpf_sock_ops_kern,     \
+						is_fullsock),		      \
+				      fullsock_reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+					       is_fullsock));		      \
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, fullsock_reg, 0, jmp);	      \
+		if (si->dst_reg == si->src_reg)				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
+						struct bpf_sock_ops_kern, sk),\
+				      si->dst_reg, si->src_reg,		      \
+				      offsetof(struct bpf_sock_ops_kern, sk));\
+		if (si->dst_reg == si->src_reg)	{			      \
+			*insn++ = BPF_JMP_A(1);				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
+		}							      \
+	} while (0)
+
 #define SOCK_OPS_GET_TCP_SOCK_FIELD(FIELD) \
 		SOCK_OPS_GET_FIELD(FIELD, FIELD, struct tcp_sock)
 
@@ -8639,17 +8676,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		SOCK_OPS_GET_TCP_SOCK_FIELD(bytes_acked);
 		break;
 	case offsetof(struct bpf_sock_ops, sk):
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
-						struct bpf_sock_ops_kern,
-						is_fullsock),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct bpf_sock_ops_kern,
-					       is_fullsock));
-		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 1);
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
-						struct bpf_sock_ops_kern, sk),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct bpf_sock_ops_kern, sk));
+		SOCK_OPS_GET_SK();
 		break;
 	}
 	return insn - insn_buf;

