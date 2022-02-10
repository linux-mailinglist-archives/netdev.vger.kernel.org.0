Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD624B02AB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiBJCAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiBJB7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCAE2E5;
        Wed,  9 Feb 2022 17:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F01E0616C3;
        Thu, 10 Feb 2022 00:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD76C340E7;
        Thu, 10 Feb 2022 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453417;
        bh=2SvHZYRR65DIv1Zb5FCUXhwtTEIYSUhSB5LAaN4fb0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVMc7GQfM3146+LNlTxpyFuqXql/8zTV8/pO7N1APzDn8ocXIZ2pUFzqh2ODyrC+6
         WgagjoqTpOqZ29vPblLyVCq1wggIPwHqii+tynKqnKV+1xu90wEJjiYGfIUbk71oDq
         +E7oFecSu4/0AyidH/qPEDH9ohVLce5we6sBatHMB6FxnUTYGPtQqj0n22j5FHAxGr
         MmIx1CUeZimQucaC4gF4fbFZRsrd+VRGLTw/XFhYrodZRiutCYyt4wz5kmMnZEB+6t
         8J6zbvpVGfWBWv7kwMaZrb11iCZXtjaLqHc45pmtMBbPnbGJrvMKjY+cr+4yNc5/BI
         ei9rYJQ/jdFdQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/11] selftests: net: cmsg_sender: support icmp and raw sockets
Date:   Wed,  9 Feb 2022 16:36:44 -0800
Message-Id: <20220210003649.3120861-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
References: <20220210003649.3120861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support sending fake ICMP(v6) messages and UDP via RAW sockets.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 64 +++++++++++++++++++----
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 4528ae638aea..edb8c427c7cb 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -7,7 +7,10 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
 #include <linux/types.h>
+#include <linux/udp.h>
 #include <sys/socket.h>
 
 enum {
@@ -27,7 +30,9 @@ struct options {
 	const char *host;
 	const char *service;
 	struct {
+		unsigned int family;
 		unsigned int type;
+		unsigned int proto;
 	} sock;
 	struct {
 		bool ena;
@@ -35,7 +40,9 @@ struct options {
 	} mark;
 } opt = {
 	.sock = {
+		.family	= AF_UNSPEC,
 		.type	= SOCK_DGRAM,
+		.proto	= IPPROTO_UDP,
 	},
 };
 
@@ -44,6 +51,10 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	printf("Usage: %s [opts] <dst host> <dst port / service>\n", bin);
 	printf("Options:\n"
 	       "\t\t-s      Silent send() failures\n"
+	       "\t\t-4/-6   Force IPv4 / IPv6 only\n"
+	       "\t\t-p prot Socket protocol\n"
+	       "\t\t        (u = UDP (default); i = ICMP; r = RAW)\n"
+	       "\n"
 	       "\t\t-m val  Set SO_MARK with given value\n"
 	       "");
 	exit(ERN_HELP);
@@ -53,11 +64,29 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "sm:")) != -1) {
+	while ((o = getopt(argc, argv, "46sp:m:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
 			break;
+		case '4':
+			opt.sock.family = AF_INET;
+			break;
+		case '6':
+			opt.sock.family = AF_INET6;
+			break;
+		case 'p':
+			if (*optarg == 'u' || *optarg == 'U') {
+				opt.sock.proto = IPPROTO_UDP;
+			} else if (*optarg == 'i' || *optarg == 'I') {
+				opt.sock.proto = IPPROTO_ICMP;
+			} else if (*optarg == 'r') {
+				opt.sock.type = SOCK_RAW;
+			} else {
+				printf("Error: unknown protocol: %s\n", optarg);
+				cs_usage(argv[0]);
+			}
+			break;
 		case 'm':
 			opt.mark.ena = true;
 			opt.mark.val = atoi(optarg);
@@ -101,6 +130,7 @@ cs_write_cmsg(struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 
 int main(int argc, char *argv[])
 {
+	char buf[] = "blablablabla";
 	struct addrinfo hints, *ai;
 	struct iovec iov[1];
 	struct msghdr msg;
@@ -111,26 +141,42 @@ int main(int argc, char *argv[])
 	cs_parse_args(argc, argv);
 
 	memset(&hints, 0, sizeof(hints));
-	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = opt.sock.type;
+	hints.ai_family = opt.sock.family;
 
 	ai = NULL;
 	err = getaddrinfo(opt.host, opt.service, &hints, &ai);
 	if (err) {
-		fprintf(stderr, "Can't resolve address [%s]:%s: %s\n",
-			opt.host, opt.service, strerror(errno));
+		fprintf(stderr, "Can't resolve address [%s]:%s\n",
+			opt.host, opt.service);
 		return ERN_SOCK_CREATE;
 	}
 
-	fd = socket(ai->ai_family, SOCK_DGRAM, IPPROTO_UDP);
+	if (ai->ai_family == AF_INET6 && opt.sock.proto == IPPROTO_ICMP)
+		opt.sock.proto = IPPROTO_ICMPV6;
+
+	fd = socket(ai->ai_family, opt.sock.type, opt.sock.proto);
 	if (fd < 0) {
 		fprintf(stderr, "Can't open socket: %s\n", strerror(errno));
 		freeaddrinfo(ai);
 		return ERN_RESOLVE;
 	}
 
-	iov[0].iov_base = "bla";
-	iov[0].iov_len = 4;
+	if (opt.sock.proto == IPPROTO_ICMP) {
+		buf[0] = ICMP_ECHO;
+		buf[1] = 0;
+	} else if (opt.sock.proto == IPPROTO_ICMPV6) {
+		buf[0] = ICMPV6_ECHO_REQUEST;
+		buf[1] = 0;
+	} else if (opt.sock.type == SOCK_RAW) {
+		struct udphdr hdr = { 1, 2, htons(sizeof(buf)), 0 };
+		struct sockaddr_in6 *sin6 = (void *)ai->ai_addr;;
+
+		memcpy(buf, &hdr, sizeof(hdr));
+		sin6->sin6_port = htons(opt.sock.proto);
+	}
+
+	iov[0].iov_base = buf;
+	iov[0].iov_len = sizeof(buf);
 
 	memset(&msg, 0, sizeof(msg));
 	msg.msg_name = ai->ai_addr;
@@ -145,7 +191,7 @@ int main(int argc, char *argv[])
 		if (!opt.silent_send)
 			fprintf(stderr, "send failed: %s\n", strerror(errno));
 		err = ERN_SEND;
-	} else if (err != 4) {
+	} else if (err != sizeof(buf)) {
 		fprintf(stderr, "short send\n");
 		err = ERN_SEND_SHORT;
 	} else {
-- 
2.34.1

