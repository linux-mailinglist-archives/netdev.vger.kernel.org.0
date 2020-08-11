Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E19242248
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHKWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:05:09 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DF1C06174A;
        Tue, 11 Aug 2020 15:05:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so7342052pgl.11;
        Tue, 11 Aug 2020 15:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Sy6hc4d69FHZj4Y8QtKCdUHMRPl7YPruS+rAB2afZRo=;
        b=Eq2sz+WBGSHzPNrVGYA3C+oHprPywi9CQcFXbf0Q2aRAW0FbwEYE8F2DiWpLXwif//
         SJgBmvV7Z0hicg02GyUI+KazVFi2ZfdPh7Uvix0tlUNTyo5aYVucuIxbrVF5UMZRkT5v
         R36zADZW9Bywabol1DNiJcJuVWsImoBrxq2r7B+ESVmUwDvXvbDTcdx9Tlgd4jznH9Au
         gJNaEjxdrfoFidYxQtMTUMPds/D2ucLKvOYOi8rMiOXXASYygCEVfOYFruGfk9wmunRb
         E1IV2Z0dVNR+wQQsX71EaRdNvuaFtXNRDEo0hzt6D+08T77mINq0Bzx47swPdkgibHXT
         Ij8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Sy6hc4d69FHZj4Y8QtKCdUHMRPl7YPruS+rAB2afZRo=;
        b=X576Cz60CtiZ7Hcsk6QhCwLn5nCFDqXPTqvec+pJIplmA2zb/6ydwEeBl4WvsvXrtt
         Ynq5dKT/4cwdcKigcFMXZmCUXQZi23aiEdc0xqB78epBLAhXmFz5hj2oJ3F9ceyAa+uC
         7hYs5KM/IPkv3lvgTVj9DdGww52t8zUKBkonKObCGWDzOzUvdsYuA9jFk0/XovZGcPec
         5x9JI3JPCoGOZRJm6TYPlcGLm2bANiS10H46qmWIAWJ4LoFNt6PVOW2FEhPNFBVZdxIO
         gcY5pNIF/gxxvHMiGq7ZZczlfHvlT9x9ziBCA2X/1fuOLLKhCMhAZr8WvD+2v0U2rzth
         37Jw==
X-Gm-Message-State: AOAM530bhKM5rvJtxtjcSzEbd8R8KEuY4f+pIfun3idCloj736nLQr/X
        DwnHYagvLtV2y1ZLnIGKs1Y=
X-Google-Smtp-Source: ABdhPJzp45X2g7VwTUHsZd/OvJ9yHjTGie5kcJmbHRzwH3xDfB83wKLy365wI/KZvHFfZDwbpUE8DA==
X-Received: by 2002:a63:6c0a:: with SMTP id h10mr2479996pgc.11.1597183508597;
        Tue, 11 Aug 2020 15:05:08 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w23sm145711pgj.5.2020.08.11.15.05.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 15:05:07 -0700 (PDT)
Subject: [bpf PATCH v3 2/5] bpf: sock_ops sk access may stomp registers when
 dst_reg = src_reg
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 11 Aug 2020 15:04:56 -0700
Message-ID: <159718349653.4728.6559437186853473612.stgit@john-Precision-5820-Tower>
In-Reply-To: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
References: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
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
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1baeeff..b2df520 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8358,6 +8358,43 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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
 
@@ -8642,17 +8679,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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

