Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EE31FF5E7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgFRO4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730972AbgFROzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 10:55:55 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D79C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 07:55:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id r22so4300996qke.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLpoSdhYjXHru0gzZEDch/mbnf7m1MsySykX8E7BcoQ=;
        b=oXAa27Dv2zul/QHkmSQZXjiQdp4u8sygXL0vbB4QfsVr1YTVXyDdKZU5IMxccG94VF
         QMcV29kmAGl/Q1b+iO3fdsnyJvPydRkTpQ7IR0oaVu8da3rtCn9aZbIfNlbzles+IrkR
         54r8pW8AEO9J4IEeu/BWlXCZ+1er5zKHjkgA9ux9QHRuG39zVgJV3Ua5Gwsf3gMrrMGS
         d4LxfmuZVhDOp1jLVfHz6CrrgVXPH5mBxHnQhhdvHBzlfnUCTZxsVAvdyRK0UC+RHykd
         x5+YRrNCX1c9ERjm5eMKstAXCPXhIDUNhJzM+RHPzHq3GxqLv6ydREKNj1LKBiLtbTDU
         auRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLpoSdhYjXHru0gzZEDch/mbnf7m1MsySykX8E7BcoQ=;
        b=iPjRQtncehVIvJll2wnut5TWaME/+YVBbtY+ZodeV7bUnmqe3/g+JIJ8unOmBMnPvO
         C/+m+vZV2C66Zv0nzMKpaw6RummKLphOSyrvfC32hOxORgV8mhwPiONQT4gvLKAdSMdn
         TcDig6/GhXDQYdhtjkDz8WRbFftOpWp7MoxQFxVcdAOL06v0XWtyLDDFQNLnPPevC0es
         Hkln0L3vLFVYXmvdbtlB7a41KzIeXvwUI0nE8QUiYanV0mQ4x9rSoNr1cmb+rRY58I4l
         okMw+I/SRLX1Klm1pnecmRcT06oRdj8wOHwK8dE7eht3Gt8FBblEkL8OSPoS4kzQzGR+
         GJXA==
X-Gm-Message-State: AOAM531NXqRIwyumru6/u8npYQouI2ppbpYKHIhdXsO4uB31iFXVMNs/
        r3iVDPSNvKqsGB7TmvHKo27gaYL1
X-Google-Smtp-Source: ABdhPJwBFUTeflXIEr516noISAg5D9aUKx3w/bw5/usHkSGB/eoOJORN2A1K93QAX7pDQOD64PcU3g==
X-Received: by 2002:a05:620a:150a:: with SMTP id i10mr3922423qkk.365.1592492152915;
        Thu, 18 Jun 2020 07:55:52 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id e7sm3332749qtd.83.2020.06.18.07.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:55:51 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: report etf errors correctly
Date:   Thu, 18 Jun 2020 10:55:49 -0400
Message-Id: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The ETF qdisc can queue skbs that it could not pace on the errqueue.

Address a few issues in the selftest

- recv buffer size was too small, and incorrectly calculated
- compared errno to ee_code instead of ee_errno
- missed error type invalid request

Fixes: ea6a547669b3 ("selftests/net: make so_txtime more robust to timer variance")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c | 33 +++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 383bac05ac32..3400afff0c3c 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -15,8 +15,9 @@
 #include <inttypes.h>
 #include <linux/net_tstamp.h>
 #include <linux/errqueue.h>
+#include <linux/if_ether.h>
 #include <linux/ipv6.h>
-#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -140,8 +141,8 @@ static void do_recv_errqueue_timeout(int fdt)
 {
 	char control[CMSG_SPACE(sizeof(struct sock_extended_err)) +
 		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
-	char data[sizeof(struct ipv6hdr) +
-		  sizeof(struct tcphdr) + 1];
+	char data[sizeof(struct ethhdr) + sizeof(struct ipv6hdr) +
+		  sizeof(struct udphdr) + 1];
 	struct sock_extended_err *err;
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
@@ -159,6 +160,8 @@ static void do_recv_errqueue_timeout(int fdt)
 	msg.msg_controllen = sizeof(control);
 
 	while (1) {
+		const char *reason;
+
 		ret = recvmsg(fdt, &msg, MSG_ERRQUEUE);
 		if (ret == -1 && errno == EAGAIN)
 			break;
@@ -176,14 +179,30 @@ static void do_recv_errqueue_timeout(int fdt)
 		err = (struct sock_extended_err *)CMSG_DATA(cm);
 		if (err->ee_origin != SO_EE_ORIGIN_TXTIME)
 			error(1, 0, "errqueue: origin 0x%x\n", err->ee_origin);
-		if (err->ee_code != ECANCELED)
-			error(1, 0, "errqueue: code 0x%x\n", err->ee_code);
+
+		switch (err->ee_errno) {
+		case ECANCELED:
+			if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
+				error(1, 0, "errqueue: unknown ECANCELED %u\n",
+					    err->ee_code);
+			reason = "missed txtime";
+		break;
+		case EINVAL:
+			if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
+				error(1, 0, "errqueue: unknown EINVAL %u\n",
+					    err->ee_code);
+			reason = "invalid txtime";
+		break;
+		default:
+			error(1, 0, "errqueue: errno %u code %u\n",
+			      err->ee_errno, err->ee_code);
+		};
 
 		tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
 		tstamp -= (int64_t) glob_tstart;
 		tstamp /= 1000 * 1000;
-		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
-				data[ret - 1], tstamp);
+		fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
+				data[ret - 1], tstamp, reason);
 
 		msg.msg_flags = 0;
 		msg.msg_controllen = sizeof(control);
-- 
2.27.0.290.gba653c62da-goog

