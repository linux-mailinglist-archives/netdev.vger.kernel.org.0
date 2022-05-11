Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8616B522A9B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiEKDzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241197AbiEKDzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:55:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343521719C
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e24so1061625pjt.2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aZBrMhde8FpEVWkUnj31KTacbZRR8gMfK1YB4YXQ0jc=;
        b=h83XAA98G4q5ePsZrIsLvPfnCfnbTjI1gSU8AzJSpPDJntT477r7QuDZCMsCDJKWG9
         TqetClC0MszlVLsO1ojgFUTsLAAGc1OgU2jb+FQKxhxP0S81l5KGJ6eWfk7b45R21mEG
         Eq2ntBM7BWiZhqRxdb4HIcuGcH1vbYaRo55F4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aZBrMhde8FpEVWkUnj31KTacbZRR8gMfK1YB4YXQ0jc=;
        b=1Ho6oKirBAJyeb1PbGakwR4zHRLdgJdt1RXqSS7ybs4YTQIyOCGEhtx4pghMLrI/qE
         lCYf7DkkkajFHvAvkBSCoAfIit++oAZ08e6AzGWABftnExZMqr/p1Jz3NOeFBg8sPwOg
         HJmtE13Mujs4Miree5jtUbiirgO/SQfummc6JIrU8GM6oeYgS7OlWscw60ZTZFAV443c
         EF7B64JOAFot4OPGxaHOtu/Y5exgbeBz2wafBHu4KfqVuhGElXF4kqERsydzhF914aW7
         8AL5aA7fnJawBaquCOmKO/GW7QX2xo/szIPKZFG8UvaHiJAG3WpZZKC4lgrRyH9WJ5ao
         xETw==
X-Gm-Message-State: AOAM531JGfhm9Fx615j4ihtoArgTFa5A/LDc45e58cab2xwnMnqcLH7k
        A788B9P4ep92UgqibEbllFrMkPHFbtSBR9JHiDAfyIRhgYFvVO/6GBvnGGYMwhaHVPL6N3dHVfb
        A3Xfxx7LK7rJcfO3/C5UZqaAZ0LBeHuVCgODovPXHHFIaDTG9kv7mPtTMFUrXEYvK8j4V
X-Google-Smtp-Source: ABdhPJxhMetGgdMphFhnMhts3MbZSr4+18d+mQckIRBqUPMXsNdPRazRpLHEHvEAaWw9V+TQ0BG9Vg==
X-Received: by 2002:a17:902:ecca:b0:15e:8971:4540 with SMTP id a10-20020a170902ecca00b0015e89714540mr23357838plh.43.1652241334487;
        Tue, 10 May 2022 20:55:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d7-20020a170903230700b0015e8d4eb1f7sm442789plh.65.2022.05.10.20.55.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 20:55:33 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next 4/6] net: Add a struct for managing copy functions
Date:   Tue, 10 May 2022 20:54:25 -0700
Message-Id: <1652241268-46732-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add struct skb_copier which encapsulates two functions for copying data,
and provide a default copier, skb_copier.

Separate skb_copy_datagram_from_iter into a a helper function,
do_skb_copy_datagram, which takes a struct skb_copier.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/core/datagram.c | 49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4fae..a87c41b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -532,18 +532,19 @@ int skb_copy_datagram_iter(const struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_iter);
 
-/**
- *	skb_copy_datagram_from_iter - Copy a datagram from an iov_iter.
- *	@skb: buffer to copy
- *	@offset: offset in the buffer to start copying to
- *	@from: the copy source
- *	@len: amount of data to copy to buffer from iovec
- *
- *	Returns 0 or -EFAULT.
- */
-int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
-				 struct iov_iter *from,
-				 int len)
+struct skb_copier {
+	size_t (*copy_from_iter)(void *addr, size_t bytes, struct iov_iter *i);
+	size_t (*copy_page_from_iter)(struct page *page, size_t offset, size_t bytes,
+				      struct iov_iter *i);
+};
+
+struct skb_copier skb_copier = {
+	.copy_from_iter = copy_from_iter,
+	.copy_page_from_iter = copy_page_from_iter
+};
+
+static int do_skb_copy_datagram(struct sk_buff *skb, int offset,
+				struct iov_iter *from, int len, struct skb_copier copier)
 {
 	int start = skb_headlen(skb);
 	int i, copy = start - offset;
@@ -553,7 +554,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		if (copy_from_iter(skb->data + offset, copy, from) != copy)
+		if (copier.copy_from_iter(skb->data + offset, copy, from) != copy)
 			goto fault;
 		if ((len -= copy) == 0)
 			return 0;
@@ -573,7 +574,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 
 			if (copy > len)
 				copy = len;
-			copied = copy_page_from_iter(skb_frag_page(frag),
+			copied = copier.copy_page_from_iter(skb_frag_page(frag),
 					  skb_frag_off(frag) + offset - start,
 					  copy, from);
 			if (copied != copy)
@@ -595,9 +596,7 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 		if ((copy = end - offset) > 0) {
 			if (copy > len)
 				copy = len;
-			if (skb_copy_datagram_from_iter(frag_iter,
-							offset - start,
-							from, copy))
+			if (do_skb_copy_datagram(frag_iter, offset - start, from, copy, copier))
 				goto fault;
 			if ((len -= copy) == 0)
 				return 0;
@@ -611,6 +610,22 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 fault:
 	return -EFAULT;
 }
+
+/**
+ *	skb_copy_datagram_from_iter - Copy a datagram from an iov_iter.
+ *	@skb: buffer to copy
+ *	@offset: offset in the buffer to start copying to
+ *	@from: the copy source
+ *	@len: amount of data to copy to buffer from iovec
+ *
+ *	Returns 0 or -EFAULT.
+ */
+int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
+				struct iov_iter *from,
+				 int len)
+{
+	return do_skb_copy_datagram(skb, offset, from, len, skb_copier);
+}
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
-- 
2.7.4

