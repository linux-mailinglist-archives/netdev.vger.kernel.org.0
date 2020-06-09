Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577931F3DA4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgFIOKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbgFIOJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:44 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE1DC08C5C3
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id k22so17649866qtm.6
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0vpwP6IeZfDbQBpfV09JHGW4dMXztVH+dxa86rL+Dw=;
        b=LGtAmNllhWSoTSncmayu896La+ADwtiOJS/PSwgQfiZvGZl9WwPxSJYjqgzqawjq+I
         k9qAJRFQwtJm7D7MP5XiF+XCd694LIULSYbNSA7avUiu9UGloDUl/7ChVrq+q2L/jQwd
         +SQ+/i74jw2/V3mWhYWY+h1glmTNO20TNRkuonEEwRsSeJNc4mg7l41kzquZCJUmDGLi
         9JHtWgmecbo3EsC+jZNqfJudQrhk3kiH2hmq62sZq2D2tMnBx4zox2OmD5VsL+duB2bL
         5S4n5yxVXyWjGULc213WoiAlkjWNauCtS+sv8sPT8ugKSoAXM35OR/aQQpPKKomUftzT
         7zLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0vpwP6IeZfDbQBpfV09JHGW4dMXztVH+dxa86rL+Dw=;
        b=uEOssJOpzoEPkkIq48uJsEJB+mftagcAZJ5emrvkS9/imDnAnEtFcsrcKlDB2NJWqm
         I3faP6eT49h0oxeTRXNyPaOvWo643eOJ6CP0AyzpxZ2QHflw1Nmh6yxqtykf0gXaFhyb
         s9Njoj5wDk57yrpMUKOGGwiQr/mmvhF5+Vk6ND2JjOM2QnuWOv8SO0C2HQWiE5h2NARe
         xmuaWFbb35Pt9RF4cDWsTcXsHtUFQ8+XEhTcbw5lnsyBRPBujBA3tun5pb809SzFJMIv
         BVCuVARZPc6jdlVIrDmnwwOiENg6I/Ril1j6mCKAOurNcCuBCjjeaLvCGKpOCTyCpbUD
         eLFQ==
X-Gm-Message-State: AOAM530aKRyCEPDElNUlS5KilhhChAlfEk6v8ayuWvTeTt51DTnI4cqk
        9pDrEfvOF8apDkzVRNngBVrqBtQv
X-Google-Smtp-Source: ABdhPJxuRAAF2i8uws3H3XSSjNC5dRLDMD1ZGk8je8S5IoYodiDjqzMcyU4nPPdwIwGulZASTUxj4Q==
X-Received: by 2002:ac8:6882:: with SMTP id m2mr28756776qtq.231.1591711782463;
        Tue, 09 Jun 2020 07:09:42 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:41 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 4/6] selftests/net: so_txtime: support txonly/rxonly modes
Date:   Tue,  9 Jun 2020 10:09:32 -0400
Message-Id: <20200609140934.110785-5-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
In-Reply-To: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Allow running the test across two machines, to test nic hw offload.

Add options
-A: receiver address
-r: receive only
-t: transmit only
-T: SO_RCVTIMEO value

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/so_txtime.c | 60 ++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index 383bac05ac32..fa748e4209c0 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -28,9 +28,13 @@
 #include <time.h>
 #include <unistd.h>
 
+static const char *cfg_addr;
 static int	cfg_clockid	= CLOCK_TAI;
 static bool	cfg_do_ipv4;
 static bool	cfg_do_ipv6;
+static bool	cfg_rxonly;
+static int	cfg_timeout_sec;
+static bool	cfg_txonly;
 static uint16_t	cfg_port	= 8000;
 static int	cfg_variance_us	= 4000;
 
@@ -238,8 +242,12 @@ static int setup_rx(struct sockaddr *addr, socklen_t alen)
 	if (fd == -1)
 		error(1, errno, "socket r");
 
-	if (bind(fd, addr, alen))
-		error(1, errno, "bind");
+	if (!cfg_txonly)
+		if (bind(fd, addr, alen))
+			error(1, errno, "bind");
+
+	if (cfg_timeout_sec)
+		tv.tv_sec = cfg_timeout_sec;
 
 	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)))
 		error(1, errno, "setsockopt rcv timeout");
@@ -260,13 +268,18 @@ static void do_test(struct sockaddr *addr, socklen_t alen)
 
 	glob_tstart = gettime_ns();
 
-	for (i = 0; i < cfg_num_pkt; i++)
-		do_send_one(fdt, &cfg_in[i]);
-	for (i = 0; i < cfg_num_pkt; i++)
-		if (do_recv_one(fdr, &cfg_out[i]))
-			do_recv_errqueue_timeout(fdt);
+	if (!cfg_rxonly) {
+		for (i = 0; i < cfg_num_pkt; i++)
+			do_send_one(fdt, &cfg_in[i]);
+	}
 
-	do_recv_verify_empty(fdr);
+	if (!cfg_txonly) {
+		for (i = 0; i < cfg_num_pkt; i++)
+			if (do_recv_one(fdr, &cfg_out[i]))
+				do_recv_errqueue_timeout(fdt);
+
+		do_recv_verify_empty(fdr);
+	}
 
 	if (close(fdr))
 		error(1, errno, "close r");
@@ -308,7 +321,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c, ilen, olen;
 
-	while ((c = getopt(argc, argv, "46c:")) != -1) {
+	while ((c = getopt(argc, argv, "46A:c:rtT:")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_do_ipv4 = true;
@@ -316,6 +329,9 @@ static void parse_opts(int argc, char **argv)
 		case '6':
 			cfg_do_ipv6 = true;
 			break;
+		case 'A':
+			cfg_addr = optarg;
+			break;
 		case 'c':
 			if (!strcmp(optarg, "tai"))
 				cfg_clockid = CLOCK_TAI;
@@ -325,13 +341,27 @@ static void parse_opts(int argc, char **argv)
 			else
 				error(1, 0, "unknown clock id %s", optarg);
 			break;
+		case 'r':
+			cfg_rxonly = true;
+			break;
+		case 't':
+			cfg_txonly = true;
+			break;
+		case 'T':
+			cfg_timeout_sec = strtol(optarg, NULL, 0);
+			break;
 		default:
 			error(1, 0, "parse error at %d", optind);
 		}
 	}
 
 	if (argc - optind != 2)
-		error(1, 0, "Usage: %s [-46] -c <clock> <in> <out>", argv[0]);
+		error(1, 0, "Usage: %s [-46rt] [-A addr] [-c clock] [-T timeout] <in> <out>", argv[0]);
+
+	if (cfg_rxonly && cfg_txonly)
+		error(1, 0, "Select rx-only or tx-only, not both");
+	if (cfg_addr && cfg_do_ipv4 && cfg_do_ipv6)
+		error(1, 0, "Cannot run both IPv4 and IPv6 when passing address");
 
 	ilen = parse_io(argv[optind], cfg_in);
 	olen = parse_io(argv[optind + 1], cfg_out);
@@ -349,7 +379,10 @@ int main(int argc, char **argv)
 
 		addr6.sin6_family = AF_INET6;
 		addr6.sin6_port = htons(cfg_port);
-		addr6.sin6_addr = in6addr_loopback;
+		if (!cfg_addr)
+			addr6.sin6_addr = in6addr_loopback;
+		else if (inet_pton(AF_INET6, cfg_addr, &addr6.sin6_addr) != 1)
+			error(1, 0, "ipv6 parse error: %s", cfg_addr);
 
 		cfg_errq_level = SOL_IPV6;
 		cfg_errq_type = IPV6_RECVERR;
@@ -362,7 +395,10 @@ int main(int argc, char **argv)
 
 		addr4.sin_family = AF_INET;
 		addr4.sin_port = htons(cfg_port);
-		addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		if (!cfg_addr)
+			addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		else if (inet_pton(AF_INET, cfg_addr, &addr4.sin_addr) != 1)
+			error(1, 0, "ipv4 parse error: %s", cfg_addr);
 
 		cfg_errq_level = SOL_IP;
 		cfg_errq_type = IP_RECVERR;
-- 
2.27.0.278.ge193c7cf3a9-goog

