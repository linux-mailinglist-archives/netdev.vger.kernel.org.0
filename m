Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3754449C2
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhKCUvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhKCUvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:51:12 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3436C061714;
        Wed,  3 Nov 2021 13:48:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r3so2967571iod.6;
        Wed, 03 Nov 2021 13:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RJWymqwchaNorQTo4g8giSsicFnOlZGInpHVyvA+Tg=;
        b=meKKx78Gx1hoCWIENP2RsNHnjEXMiQ4year86XQUuus9qfUmShJKhrmWsSK4DUCaiu
         uxWF0ge8fXAxYgpCRwBcW49utwEwDEuU5pby3KAgPZB/ArexBUpAn0AYvSU/T2FmFHgv
         3tB+2OmJkqxODtmUpVzpPUOXA5VodvFg776SB5loD4KYrW+YeBxMHmARPXa4D1vLGvfC
         0d7JjEigyaZhVsidkeBhq4Dzeau0c4K2oVQ/RJV6Rlmabb9or/+NTibxsp07//l9gd5q
         GM7sU2aGYC/t6d5qZf25Wuw6oIbTiYbzUj9OaRb0gYFS5oP0H205XWeb5XRwRSZq/BTX
         jaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RJWymqwchaNorQTo4g8giSsicFnOlZGInpHVyvA+Tg=;
        b=TCFI0QKbdcD5Hkw0o2T0Q2QASLi7Zc7cEQf0Qo0P8W+CZPXJ1UZN7Tr/gYJ1zpZQs8
         2bYdoIPGV0TLWFdrjNazwIRl0Ar5NHLxtu25MEJpFsnNVJ6JTLBc6FS6/st9Qgi8B8id
         EdRs3quben6LT1B3k6+F3Qmw3367fDGYTsTSrs+Nth28G2XXy/m+xDVFHwCVRr2Gzvae
         v5SX8alULJtA14bWNQn7lbRKnzLeFlw04fKPHYoQtOOBSKmX9ltS59Cu5ruBpUP7V57h
         fOQCT+xQQyPOf0zQ9m+kFAVMQ+1iZmYkJNm2d7gaVaEVlYwGEJGHR/7/6n3wiM3YPjWM
         DJKA==
X-Gm-Message-State: AOAM5326fyXJQSEF+9rAa7VXSYfl4c1OvN5+0DuV/+1zHO1GIPt6/asX
        dbTYgZQk98Kyu22VnhZjiD3JXXGmX5hFAA==
X-Google-Smtp-Source: ABdhPJxDKyctfIgafGan8+pIkxO9uOvgiU3fBh1Lhb1klvwqTXWl3mY6QH//PHtMyECt0vdYQSfwag==
X-Received: by 2002:a5d:8b94:: with SMTP id p20mr32081885iol.146.1635972514897;
        Wed, 03 Nov 2021 13:48:34 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:48:34 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 5/5] bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg
Date:   Wed,  3 Nov 2021 13:47:36 -0700
Message-Id: <20211103204736.248403-6-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
References: <20211103204736.248403-1-john.fastabend@gmail.com>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
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
index c3936d0724b8..e471c9b09670 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9756,22 +9756,46 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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

