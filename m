Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD251FF971
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgFRQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731986AbgFRQkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:40:47 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FEAC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:40:47 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g28so6207929qkl.0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poMdZ15VPp72dXTVgo6ypcGpfHImTCud9V9S4ktIEEA=;
        b=Y3xJOguyxzuATzad3kVwPEtW+qVP/ZYJZr71YSXIRbybldqSoGa4IL0MivgzJeuMa4
         8FL7uPtjLR09+k+ObmunBCCuxzBQh77plab3QdCpXsnCpZvFiaVxjY3qx0ZCuzz17U3Q
         1H/kDims/RDvZEL9dcMWoPRigRx3uRuv/XJgBpJLQ+otqPyMc+gGfyR0MTLTygbOTZa1
         5uCMDuHx84XHtsfCv441AmXm2SjsJFg35aNZ/2hk5DpeALw5e3jyWTAlt9V6cOriWoco
         MCNNQcL+/RUrn+tnITqE/Zg9kB2MxGffRh3px849FhpDGxI7IwCy3N2R45qlEnJtthkq
         HfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poMdZ15VPp72dXTVgo6ypcGpfHImTCud9V9S4ktIEEA=;
        b=JdwGitIgKOMuzxiFvPkfLHXMiK6IZJz/mCI8p2OZFtJ0IQAebviNNebK8Y5PpHQC5J
         LrkmWv0MlZuq8VhBi+rxAMXI4EiDasH8Z4z7yJF0QcAuw/WJVc51TfJOUC9HaGliRgUR
         s7bNklhfl9SIcj3JU2HcSy8vISE4R9kqfdlOyVc6987wXTy11lkDvwNiHIwE+Z+meHtk
         nivHcmIdX1cnMvGkf5/3hR5ZCgHKA1gtSqL3EZ42mkwFiLixHS0B2dQFRARgkhy+sLnC
         6Om+3Mf4nf/Gb9ygz8ORfLWTBoB7SN1J8D1rXPiWI6iNyLBgMqiPDVEu73QYt6pc0reN
         uz+A==
X-Gm-Message-State: AOAM531kJkm5iinW4Ms1QTkQGwIjEmTqE/gSa+ddwsMv+Wii2E0JSG0n
        mtM0k+o0FgVncKAtwuQuQotORjFM
X-Google-Smtp-Source: ABdhPJwWXza0i7qBTtAJT00o+CQNPc9bpXlKHce24SJW+2OxwbNwGkxovz8+5HPqM9AHpZFyz0yj8A==
X-Received: by 2002:a37:aa44:: with SMTP id t65mr4725745qke.81.1592498446598;
        Thu, 18 Jun 2020 09:40:46 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id a14sm3396831qkn.16.2020.06.18.09.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 09:40:45 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2] selftests/net: report etf errors correctly
Date:   Thu, 18 Jun 2020 12:40:43 -0400
Message-Id: <20200618164043.60618-1-willemdebruijn.kernel@gmail.com>
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
- missed invalid request error type

v2:
  - fix a few checkpatch --strict indentation warnings

Fixes: ea6a547669b3 ("selftests/net: make so_txtime more robust to timer variance")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c | 33 +++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 383bac05ac32..ceaad78e9667 100644
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
+				      err->ee_code);
+			reason = "missed txtime";
+		break;
+		case EINVAL:
+			if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
+				error(1, 0, "errqueue: unknown EINVAL %u\n",
+				      err->ee_code);
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
+			data[ret - 1], tstamp, reason);
 
 		msg.msg_flags = 0;
 		msg.msg_controllen = sizeof(control);
-- 
2.27.0.290.gba653c62da-goog

