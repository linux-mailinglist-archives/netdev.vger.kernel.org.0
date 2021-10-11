Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B06429777
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhJKTTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhJKTT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:19:29 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D617C06161C;
        Mon, 11 Oct 2021 12:17:26 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id s17so15855692ioa.13;
        Mon, 11 Oct 2021 12:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8R7J7WwlVkvmd31lTevebFP8KXyHRvQbrT5FjNsptLE=;
        b=WZi8FMRsTDQeD8t1qv6pcfA/wlligT6nQGSYOUxkfG6rYKCkUVKXdFluVNRmxUHC6m
         B7M6eJb3+Iey/NniD5vYkgaFuew84fFbcMoFizbs9KxGiMzUotrgmQ1eLYVpPgBOcWcO
         FYaKvKv0koFthTrcBbqAktwiSaQ5ZqqVaOUq9+OZZw5DgWDqJvhCUkgfslHDQ5CJreaN
         qUy0vJuOcnLNvcad/+W7bZnK81pXoUY2J/vn3nTRfb6BgeMkU0FqLs26VS/ltN/5IaKW
         J5W/I9vvxO2tAFRjReP9WkfKGbnZyOEHGHbyzi0lNZh/dDgyks6YdQeNXWMpM9xomyy8
         XHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8R7J7WwlVkvmd31lTevebFP8KXyHRvQbrT5FjNsptLE=;
        b=rjOKWf6FYj6mg0xcBaltkqczi9ZCoFDaHFTn+TtmaU9MSwBxHEhn1OZK7zFBlyxIje
         kxod1bgEHyf1pwI2D/VSBAYP43/uQDRvn5xF3IC9cOnL5PAs2gviLmlC840d6jhZaJt9
         mCQea4622md2teF0u3mqCapu609ltagMFwSrj4NwtBC7OM+t/4BIJzrrrA4rawaocGQZ
         JNpSF+t3HnCwhoHt8OhtuKpv7195dyfk69oA6RqssIn5ME7pUp2PUwmz6mDXgBMXdswz
         iWg99XthEWF0t8+DCocIW/AGToZfqptrcDXWFXmmvK0wJgy4jx1QMKZzUpLZ4YxsHUf8
         +F6g==
X-Gm-Message-State: AOAM533YOv9Tg/FpkdZCktb3W9O2/LcrUwf7ooHKTtd/r2GUsOMwUKKl
        0cbDaMjTbIc0CfeGY2exDkeIAz78rAAoEQ==
X-Google-Smtp-Source: ABdhPJx2DuwoZ4gYJYKHc53dJuQKhPZFaLoEf4FEY89dWjcAn8Vs7pfXu/GIBeLPPLyGRYOC3J7g8w==
X-Received: by 2002:a05:6602:27c5:: with SMTP id l5mr7041541ios.60.1633979845397;
        Mon, 11 Oct 2021 12:17:25 -0700 (PDT)
Received: from john.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n12sm4460077ilj.8.2021.10.11.12.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:17:24 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, joamaki@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH bpf 3/4] bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and colliding
Date:   Mon, 11 Oct 2021 12:16:46 -0700
Message-Id: <20211011191647.418704-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011191647.418704-1-john.fastabend@gmail.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
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
index 2e32cee2c469..23a9bf92b5bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9761,11 +9761,33 @@ static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
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

