Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D064F099D
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiDCNKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358532AbiDCNK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:28 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29CB13B
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:22 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d7so10624152wrb.7
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mqCJk3Tcq92QKRFxYlavWwmlfxI03jKy0XINWiL2FrI=;
        b=ODZ2mADnavhrYfzE4peIovQEBGpbGp0Zxz8mZTXMXjYBfcq8Lt9Ms/WrRbsqJQECli
         RT/Ish8qaFIP40Bqj2MqG7C+zNQkDZDX7We6ZejACxeY4RnnAfrXU1gO3Psm/f0WMBBN
         /AY9X96CPkt4sgyBF4u5uB9XCVKGDEaDTGujnrjrLFq1pOfnLzNncj5+C68mcm6Tp79B
         UNYvYi8Z8pqVV5reHIeqNv0tBf07L/jeLvLYo/zo6OVrzpuMxCzDIChpxbX1RkRjLb5j
         7BB88ZMlOQ/2cBsZMkZowOeyT8cMCRlgseX/5Fdvmh1xPir0Dw6YVBz2++YIiIpxNRKu
         KKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mqCJk3Tcq92QKRFxYlavWwmlfxI03jKy0XINWiL2FrI=;
        b=vRDGjf4E1MvHhwIJFC7m/v8d1/5ediBuoD1G4aVHPsFVn0FXt3alZ75x1xSIuHXmhh
         R7GYnOiiHAwtpiy1I6cUBGxE8u8EuV+pQKJW9CrCHgmpW1QF7TpnuXm7sJpv1ITK9ZC7
         GF7es4JFQXmLdoGFoC4H1GxVf5sCoUDG/3RlatUTj9rf/8YrF2YyQLw6ti0GaV9la4Kp
         yH59HgcTL/jkAqnRXDchhQ2YnKHsCjBAphqm/18kLE+nQICrXspzLCNFqEQr6A3qsZ3V
         +VB4XlG1owscbQaUnAhkwMZcG2KzF/rCBxTLMIMS/zr8LVv2uazhFEYbRVWZEG7PbBUH
         eAZQ==
X-Gm-Message-State: AOAM531bkXPHVmxSnNvB9IL6Qy+qJbqyqN3AqCWCRsSi0nf9grWFcoHY
        vbATKgWA56oiTAdO52dKCbN36LLbhyc=
X-Google-Smtp-Source: ABdhPJzPtZMFtKNp1/YY5bwirlHKXf5w7ygwPDf8Qn4vpsNiRJ/FeTbu5IvDw95vQCJfrVn2cxFrtg==
X-Received: by 2002:adf:fa09:0:b0:206:10e7:c7d9 with SMTP id m9-20020adffa09000000b0020610e7c7d9mr766779wrr.549.1648991301342;
        Sun, 03 Apr 2022 06:08:21 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 09/27] net: inline sock_alloc_send_skb
Date:   Sun,  3 Apr 2022 14:06:21 +0100
Message-Id: <02d5e2ea08dc28f3e22245c6c1110a108e576abc.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_alloc_send_skb() is simple and just proxying to another function,
so we can inline it and cut associated overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h | 10 ++++++++--
 net/core/sock.c    |  7 -------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..9dab633c3caf 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1825,11 +1825,17 @@ int sock_getsockopt(struct socket *sock, int level, int op,
 		    char __user *optval, int __user *optlen);
 int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode);
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
+
+static inline struct sk_buff *sock_alloc_send_skb(struct sock *sk,
+						  unsigned long size,
+						  int noblock, int *errcode)
+{
+	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
+}
+
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index b1a8f47fda55..77e37556e0c3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2626,13 +2626,6 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 }
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode)
-{
-	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
-}
-EXPORT_SYMBOL(sock_alloc_send_skb);
-
 int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 		     struct sockcm_cookie *sockc)
 {
-- 
2.35.1

