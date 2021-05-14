Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08338024D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhENDM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbhENDMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:12:23 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F3C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 20:11:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l19so1615534plk.11
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 20:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZuTSOJlblrWDdFXXxKbZF33cwXnjLYMm1bx5N6UaJY=;
        b=euLx44kAocpA9F27kAeHV1ZdQ+WhiUYkgWJK2fOpw+HIpVljr7bTfmfvvDlQn2KbR4
         +jakUOwtL5mwNTGLVyA3mFlgITmMYSqe7t1vAbJaeZfumcLE8dOZoOLzqAs437+yB4qi
         bA0wypmbIt/r4Rk3MXK9WQHkEZHrotKOjYYutcVbiX9K8vMze6WqYdEZd83hU6on6NFG
         2DM33pWJrc+FWGyjToB0SQLYSU55lZROtqNFMs66cF6MNYTCHdTMo4uSV0mTMjnCIOMG
         23HXNKgDNZW0R6N8hvCgPstiR8h4tn25B1Mya5pHqhVRg6cOtRyNWMdaRUXdibKFIuC2
         Xp1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZuTSOJlblrWDdFXXxKbZF33cwXnjLYMm1bx5N6UaJY=;
        b=PDo5ZfIN/gfAnRKuRTkrN6wZVXPoiynFvlYCSzpyiv2gAuKHcRcM9CfXzyEv1/rcCw
         uErnyOGxMRyvneGBSfCrU1nSzJ5PHHk/ryFnBCP5wGbjaEj1ZiH5UJ9yWMpoSgkFOfX6
         Gtkz+G75dwcs228n51hwkRq3x5DbgDoLQw3ReXhJDmtRxh94TJ90CyAMBxWmm6EwOsix
         bt1guNl4snccddMwvNYq87ixo0t67l8TCfqa7vY9ycdRL+6Cksk29RaTyEbSxaGe1f2n
         CUP997m9vtDuziwZx2HP83olLRom97WdIAn4lQ2Ojc2AwBsV9llIOZqN+UP4Tb5mJDYd
         wq9g==
X-Gm-Message-State: AOAM533+N2nCkJnCv/rdqSZxw4y8YniAe+Hf/5ZZKdFwohwvf13V0CJ0
        jFoIuMWMY2TJegdO4m6f1jE=
X-Google-Smtp-Source: ABdhPJy+vTyVui09cn3ib4V0SJFh8iqk/1Oa6cbMQJtOWLorzQ69yHpj30wZzc4JiiyFr0Fhi/0jjA==
X-Received: by 2002:a17:90a:ba07:: with SMTP id s7mr7441240pjr.129.1620961870245;
        Thu, 13 May 2021 20:11:10 -0700 (PDT)
Received: from fedora.localdomain (ec2-18-163-7-246.ap-east-1.compute.amazonaws.com. [18.163.7.246])
        by smtp.gmail.com with ESMTPSA id o9sm3228554pfh.217.2021.05.13.20.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 20:11:09 -0700 (PDT)
From:   Jim Ma <majinjing3@gmail.com>
To:     kuba@kernel.org, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, Jim Ma <majinjing3@gmail.com>
Subject: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT
Date:   Fri, 14 May 2021 11:11:02 +0800
Message-Id: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tls_sw_splice_read, checkout MSG_* is inappropriate, should use
SPLICE_*, update tls_wait_data to accept nonblock arguments instead
of flags for recvmsg and splice.

Signed-off-by: Jim Ma <majinjing3@gmail.com>
---
 net/tls/tls_sw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 1dcb34dfd56b..694de024d0ee 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -37,6 +37,7 @@
 
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/splice.h>
 #include <crypto/aead.h>
 
 #include <net/strparser.h>
@@ -1281,7 +1282,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 }
 
 static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
-				     int flags, long timeo, int *err)
+				     bool nonblock, long timeo, int *err)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1306,7 +1307,7 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 		if (sock_flag(sk, SOCK_DONE))
 			return NULL;
 
-		if ((flags & MSG_DONTWAIT) || !timeo) {
+		if (nonblock || !timeo) {
 			*err = -EAGAIN;
 			return NULL;
 		}
@@ -1786,7 +1787,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		bool async_capable;
 		bool async = false;
 
-		skb = tls_wait_data(sk, psock, flags, timeo, &err);
+		skb = tls_wait_data(sk, psock, flags & MSG_DONTWAIT, timeo, &err);
 		if (!skb) {
 			if (psock) {
 				int ret = sk_msg_recvmsg(sk, psock, msg, len,
@@ -1990,9 +1991,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	lock_sock(sk);
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags, timeo, &err);
+	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
 	if (!skb)
 		goto splice_read_end;
 
-- 
2.31.1

