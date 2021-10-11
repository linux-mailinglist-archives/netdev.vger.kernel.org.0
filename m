Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6819B429778
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhJKTTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbhJKTTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:19:36 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D938C061570;
        Mon, 11 Oct 2021 12:17:35 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id x1so17100665iof.7;
        Mon, 11 Oct 2021 12:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYUEbdtNkCcfmFfRaAYdRtS4aaNAG7Whfl52kUNJaQk=;
        b=HjKBQ+WlvArP/pQhk+qiaNqK+vMz5LBu8M0+3xjqOAKyNaE4SsmkSOK+uI+THRemGh
         GMldP6Crafz39toxasqp4JNCpbUxaPIeviif4hkJWam4HReNhLLfQX0d4gdkc0oTRSxF
         2CBfdoSfoquid5XJUD0lrg120NwZqJ57UseI4tl8BT0w35a+UGbCdvS0zt81AIjH8XUf
         vmygyjjBeeLeUXDdLw5zH7YgH/BJvZBlNXgw8+24tNxsvfcVk0OQXl/TH2rk4zT0CUj7
         Moz1HagrTqkctZ2QacoBzYiMSxlIviSRPx8sRRx0/zCdtpzs53lZIlY9LcO9VZgOafKT
         pMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYUEbdtNkCcfmFfRaAYdRtS4aaNAG7Whfl52kUNJaQk=;
        b=LBTaWytaCaNLLgmwIWzNAbsZZPBHpUZ0r0NAM1jmqfTqj5z1fny3OymOjyBa+6KDqr
         UHbmwpJLyWOz4LviJoiTg/I3OvzZGLb3v17rUgI9HeRTMW13rScJ33rma76Gl62oy8gw
         xZUMvHd3wIea93EvnUKgcTHyWrWnpWpuohGTQ5FrXzvlJIxYjSuTO27c2mhmyVNT7jW8
         qti94SQqQjnWqDGYD3iEJZ7Co8mKR2nSSKKpGD+cC7PMSBZ8hrcu3Zyvh0arkYcxsK7f
         aB/lQqou4p5f87ADMNEgpGK4xdw3fVUiC2yc99O/v9yMpM+2rQutM9c2GqFMuSysGhmY
         vI5A==
X-Gm-Message-State: AOAM5323kiy56YkL02spUbyFppHqbxBsGU8oru8WWiLr/ywlc6zUisUt
        THUGeL3zsOk2zKSN3SUuepVy4Dc+Q4jz5A==
X-Google-Smtp-Source: ABdhPJwz2mh1lO7r0y+bxtXIj5Riwhc9WRHxLXWOc2nNLlk32Xd6FrwYwPC+i7nGxmFRBRoTdBp5OQ==
X-Received: by 2002:a05:6602:487:: with SMTP id y7mr20308684iov.0.1633979853797;
        Mon, 11 Oct 2021 12:17:33 -0700 (PDT)
Received: from john.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n12sm4460077ilj.8.2021.10.11.12.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:17:33 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, joamaki@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH bpf 4/4] bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg
Date:   Mon, 11 Oct 2021 12:16:47 -0700
Message-Id: <20211011191647.418704-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011191647.418704-1-john.fastabend@gmail.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

The current conversion of skb->data_end reads like this,

  ; data_end = (void*)(long)skb->data_end;
   559: (79) r1 = *(u64 *)(r2 +200)   ; r1  = skb->data
   560: (61) r11 = *(u32 *)(r2 +112)  ; r11 = skb->len
   561: (0f) r1 += r11
   562: (61) r11 = *(u32 *)(r2 +116)
   563: (1f) r1 -= r11

But similar to the case

 ("bpf: sock_ops sk access may stomp registers when dst_reg = src_reg"),

the code will read an incorrect skb->len when src == dst. In this case we
end up generating this xlated code.

  ; data_end = (void*)(long)skb->data_end;
   559: (79) r1 = *(u64 *)(r1 +200)   ; r1  = skb->data
   560: (61) r11 = *(u32 *)(r1 +112)  ; r11 = (skb->data)->len
   561: (0f) r1 += r11
   562: (61) r11 = *(u32 *)(r1 +116)
   563: (1f) r1 -= r11

where line 560 is the reading 4B of (skb->data + 112) instead of the
intended skb->len Here the skb pointer in r1 gets set to skb->data and
the later deref for skb->len ends up following skb->data instead of skb.

This fixes the issue similarly to the patch mentioned above by creating
an additional temporary variable and using to store the register when
dst_reg = src_reg. We name the variable bpf_temp_reg and place it in the
cb context for sk_skb. Then we restore from the temp to ensure nothing
is lost.

Fixes: 16137b09a66f2 ("bpf: Compute data_end dynamically with JIT code")
Signed-off-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/strparser.h |  4 ++++
 net/core/filter.c       | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index bec1439bd3be..732b7097d78e 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -66,6 +66,10 @@ struct sk_skb_cb {
 #define SK_SKB_CB_PRIV_LEN 20
 	unsigned char data[SK_SKB_CB_PRIV_LEN];
 	struct _strp_msg strp;
+	/* temp_reg is a temporary register used for bpf_convert_data_end_access
+	 * when dst_reg == src_reg.
+	 */
+	u64 temp_reg;
 };
 
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
diff --git a/net/core/filter.c b/net/core/filter.c
index 23a9bf92b5bb..f4a63af45f00 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9735,22 +9735,46 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 static struct bpf_insn *bpf_convert_data_end_access(const struct bpf_insn *si,
 						    struct bpf_insn *insn)
 {
-	/* si->dst_reg = skb->data */
+	int reg;
+	int temp_reg_off = offsetof(struct sk_buff, cb) +
+			   offsetof(struct sk_skb_cb, temp_reg);
+
+	if (si->src_reg == si->dst_reg) {
+		/* We need an extra register, choose and save a register. */
+		reg = BPF_REG_9;
+		if (si->src_reg == reg || si->dst_reg == reg)
+			reg--;
+		if (si->src_reg == reg || si->dst_reg == reg)
+			reg--;
+		*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg, temp_reg_off);
+	} else {
+		reg = si->dst_reg;
+	}
+
+	/* reg = skb->data */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
-			      si->dst_reg, si->src_reg,
+			      reg, si->src_reg,
 			      offsetof(struct sk_buff, data));
 	/* AX = skb->len */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
 			      BPF_REG_AX, si->src_reg,
 			      offsetof(struct sk_buff, len));
-	/* si->dst_reg = skb->data + skb->len */
-	*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+	/* reg = skb->data + skb->len */
+	*insn++ = BPF_ALU64_REG(BPF_ADD, reg, BPF_REG_AX);
 	/* AX = skb->data_len */
 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data_len),
 			      BPF_REG_AX, si->src_reg,
 			      offsetof(struct sk_buff, data_len));
-	/* si->dst_reg = skb->data + skb->len - skb->data_len */
-	*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);
+
+	/* reg = skb->data + skb->len - skb->data_len */
+	*insn++ = BPF_ALU64_REG(BPF_SUB, reg, BPF_REG_AX);
+
+	if (si->src_reg == si->dst_reg) {
+		/* Restore the saved register */
+		*insn++ = BPF_MOV64_REG(BPF_REG_AX, si->src_reg);
+		*insn++ = BPF_MOV64_REG(si->dst_reg, reg);
+		*insn++ = BPF_LDX_MEM(BPF_DW, reg, BPF_REG_AX, temp_reg_off);
+	}
 
 	return insn;
 }
-- 
2.33.0

