Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48EC4449C0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhKCUvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhKCUvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:51:04 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AAAC061714;
        Wed,  3 Nov 2021 13:48:27 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y73so4439000iof.4;
        Wed, 03 Nov 2021 13:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S8mjFs7ebR+xEuiRShrGc07G4jO+Mgiscghvbj0Cekg=;
        b=qAifksKhf+PCp2Wis/FyVi5D9BeFB8Ovz9JcZ46aTsSl9CW3Aag0k1ph4qpzJ1KJNG
         rNlp+jUmd2qTgS265tCU6bX7+AuWEjdEQWift+7z7BpwbDCf5F/cb15Sakb7HCYC48XP
         4JQSte6oPR9qW4cw44DFnSaAy1O5L9QNOKx1VBmGl8Zg0Zq+OhV4wN6Kd22d/1eXJc1m
         RPP1Qv8n94B1Qx6BBDmja6YbjFAETHGs47x3UBTrDX/1nlCmrppdIIByncJbhwSa3PjY
         N1J0y5R4KywZ2KIbx+sH9shjPgqGp9x1YjD9I2hpQ9487SHlTNN+NmXYl6OsjstkR9YZ
         Ww8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S8mjFs7ebR+xEuiRShrGc07G4jO+Mgiscghvbj0Cekg=;
        b=00qYwHjZ50vBaqb4ggps0c7jstffV5a0Bqa7o3QaGKKmtFTlgBBgPus11PEAIuq/kE
         e63Wc3UFNdns07bajichhw4D6K9xyVOfzhcOOZy8mOniBqUS1D0zX6L78StXD26PIyJm
         KrkPV8fO5d6kzpjY7TZxmGHORLrrkC8r0oXXzTPh7c5qdxAJh0MKsmJP4oh5dqCUEUHo
         KTfx8rdvsEtW6Ze4U3jG78xNUWjamwRzdbS0WbQauAKjYuqnPpiydxXm5TiFWYbWBrcs
         vzVvcuVIF0F1u32AHZBSACSzJNfmaTdSv5z2Vi5Kjxvisr1KpRzMpROcmWfJll3qTEsA
         yD4g==
X-Gm-Message-State: AOAM530keE56Kfb0SfT+g8sD3Z7eVq+RX99YrswpssoH+i7/+OPYsGjN
        EsLOaedasKXUi3DsYR9dNnd5CnEHrLb/ow==
X-Google-Smtp-Source: ABdhPJyh6NCUjTbEroXGOFjb6/MV9AohF3QdEc3iKXYJrS9QRqAZNlK80oIMLtFZPJgb0oo1Pg03Rg==
X-Received: by 2002:a02:5b82:: with SMTP id g124mr598217jab.89.1635972507050;
        Wed, 03 Nov 2021 13:48:27 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:48:26 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 4/5] bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding
Date:   Wed,  3 Nov 2021 13:47:35 -0700
Message-Id: <20211103204736.248403-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103204736.248403-1-john.fastabend@gmail.com>
References: <20211103204736.248403-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Strparser is reusing the qdisc_skb_cb struct to stash the skb message
handling progress, e.g. offset and length of the skb. First this is
poorly named and inherits a struct from qdisc that doesn't reflect the
actual usage of cb[] at this layer.

But, more importantly strparser is using the following to access its
metadata.

(struct _strp_msg *)((void *)skb->cb + offsetof(struct qdisc_skb_cb, data))

Where _strp_msg is defined as,

 struct _strp_msg {
        struct strp_msg            strp;                 /*     0     8 */
        int                        accum_len;            /*     8     4 */

        /* size: 12, cachelines: 1, members: 2 */
        /* last cacheline: 12 bytes */
 };

So we use 12 bytes of ->data[] in struct. However in BPF code running
parser and verdict the user has read capabilities into the data[]
array as well. Its not too problematic, but we should not be
exposing internal state to BPF program. If its really needed then we can
use the probe_read() APIs which allow reading kernel memory. And I don't
believe cb[] layer poses any API breakage by moving this around because
programs can't depend on cb[] across layers.

In order to fix another issue with a ctx rewrite we need to stash a temp
variable somewhere. To make this work cleanly this patch builds a cb
struct for sk_skb types called sk_skb_cb struct. Then we can use this
consistently in the strparser, sockmap space. Additionally we can
start allowing ->cb[] write access after this.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface"
Tested-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/strparser.h   | 16 +++++++++++++++-
 net/core/filter.c         | 22 ++++++++++++++++++++++
 net/strparser/strparser.c | 10 +---------
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index 1d20b98493a1..bec1439bd3be 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -54,10 +54,24 @@ struct strp_msg {
 	int offset;
 };
 
+struct _strp_msg {
+	/* Internal cb structure. struct strp_msg must be first for passing
+	 * to upper layer.
+	 */
+	struct strp_msg strp;
+	int accum_len;
+};
+
+struct sk_skb_cb {
+#define SK_SKB_CB_PRIV_LEN 20
+	unsigned char data[SK_SKB_CB_PRIV_LEN];
+	struct _strp_msg strp;
+};
+
 static inline struct strp_msg *strp_msg(struct sk_buff *skb)
 {
 	return (struct strp_msg *)((void *)skb->cb +
-		offsetof(struct qdisc_skb_cb, data));
+		offsetof(struct sk_skb_cb, strp));
 }
 
 /* Structure for an attached lower socket */
diff --git a/net/core/filter.c b/net/core/filter.c
index a68418268e92..c3936d0724b8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9782,11 +9782,33 @@ static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
 				     struct bpf_prog *prog, u32 *target_size)
 {
 	struct bpf_insn *insn = insn_buf;
+	int off;
 
 	switch (si->off) {
 	case offsetof(struct __sk_buff, data_end):
 		insn = bpf_convert_data_end_access(si, insn);
 		break;
+	case offsetof(struct __sk_buff, cb[0]) ...
+	     offsetofend(struct __sk_buff, cb[4]) - 1:
+		BUILD_BUG_ON(sizeof_field(struct sk_skb_cb, data) < 20);
+		BUILD_BUG_ON((offsetof(struct sk_buff, cb) +
+			      offsetof(struct sk_skb_cb, data)) %
+			     sizeof(__u64));
+
+		prog->cb_access = 1;
+		off  = si->off;
+		off -= offsetof(struct __sk_buff, cb[0]);
+		off += offsetof(struct sk_buff, cb);
+		off += offsetof(struct sk_skb_cb, data);
+		if (type == BPF_WRITE)
+			*insn++ = BPF_STX_MEM(BPF_SIZE(si->code), si->dst_reg,
+					      si->src_reg, off);
+		else
+			*insn++ = BPF_LDX_MEM(BPF_SIZE(si->code), si->dst_reg,
+					      si->src_reg, off);
+		break;
+
+
 	default:
 		return bpf_convert_ctx_access(type, si, insn_buf, prog,
 					      target_size);
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index 9c0343568d2a..1a72c67afed5 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -27,18 +27,10 @@
 
 static struct workqueue_struct *strp_wq;
 
-struct _strp_msg {
-	/* Internal cb structure. struct strp_msg must be first for passing
-	 * to upper layer.
-	 */
-	struct strp_msg strp;
-	int accum_len;
-};
-
 static inline struct _strp_msg *_strp_msg(struct sk_buff *skb)
 {
 	return (struct _strp_msg *)((void *)skb->cb +
-		offsetof(struct qdisc_skb_cb, data));
+		offsetof(struct sk_skb_cb, strp));
 }
 
 /* Lower lock held */
-- 
2.33.0

