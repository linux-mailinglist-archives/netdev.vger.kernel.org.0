Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E966A4B02C1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiBJCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiBJB7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2476C2A8;
        Wed,  9 Feb 2022 17:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DD83616D4;
        Thu, 10 Feb 2022 00:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B855C340EF;
        Thu, 10 Feb 2022 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453416;
        bh=9L+Jycy6mn96LecQJZ1Jd8C7xFHvohWJDLkQzTeYdR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvJBzgLImCp+HCMs1WbL/16/PrfSpJHLKQSs+GS1R0oOywXTJZvDPgKzSdYKeXA/W
         0UuP86mYuHLLk2Uxkhi72sTXd+2ZSePx9uQxjwOcT3Jhvt3rA7RAl4yiwrRk5c+6Yt
         CDst3Y7hDA3dojrcZAZUZxEwuG8rA/9QUE32XhNA8ze3eJOX8RZrkTZu7pI2AexaQ4
         MSABOu4EcVbr8MGVnIGzlkP3hFJB2e60ggvbFTbjtmo8a/71q3YFtck3FobcWIyCOV
         DRVtFnpK/e6oX6W4xoN3N7P7jGDHLhp8cXxQlA32oD+aI7ikILhigFFE0JXNTSG7xa
         EoIuJDvkQoe0g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/11] selftests: net: make cmsg_so_mark ready for more options
Date:   Wed,  9 Feb 2022 16:36:43 -0800
Message-Id: <20220210003649.3120861-6-kuba@kernel.org>
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

Parametrize the code so that it can support UDP and ICMP
sockets in the future, and more cmsg types.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c   | 135 ++++++++++++++++----
 tools/testing/selftests/net/cmsg_so_mark.sh |   8 +-
 2 files changed, 117 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 27f2804892a7..4528ae638aea 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <errno.h>
+#include <error.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -8,60 +10,149 @@
 #include <linux/types.h>
 #include <sys/socket.h>
 
-int main(int argc, const char **argv)
+enum {
+	ERN_SUCCESS = 0,
+	/* Well defined errors, callers may depend on these */
+	ERN_SEND = 1,
+	/* Informational, can reorder */
+	ERN_HELP,
+	ERN_SEND_SHORT,
+	ERN_SOCK_CREATE,
+	ERN_RESOLVE,
+	ERN_CMSG_WR,
+};
+
+struct options {
+	bool silent_send;
+	const char *host;
+	const char *service;
+	struct {
+		unsigned int type;
+	} sock;
+	struct {
+		bool ena;
+		unsigned int val;
+	} mark;
+} opt = {
+	.sock = {
+		.type	= SOCK_DGRAM,
+	},
+};
+
+static void __attribute__((noreturn)) cs_usage(const char *bin)
+{
+	printf("Usage: %s [opts] <dst host> <dst port / service>\n", bin);
+	printf("Options:\n"
+	       "\t\t-s      Silent send() failures\n"
+	       "\t\t-m val  Set SO_MARK with given value\n"
+	       "");
+	exit(ERN_HELP);
+}
+
+static void cs_parse_args(int argc, char *argv[])
+{
+	char o;
+
+	while ((o = getopt(argc, argv, "sm:")) != -1) {
+		switch (o) {
+		case 's':
+			opt.silent_send = true;
+			break;
+		case 'm':
+			opt.mark.ena = true;
+			opt.mark.val = atoi(optarg);
+			break;
+		}
+	}
+
+	if (optind != argc - 2)
+		cs_usage(argv[0]);
+
+	opt.host = argv[optind];
+	opt.service = argv[optind + 1];
+}
+
+static void
+cs_write_cmsg(struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 {
-	char cbuf[CMSG_SPACE(sizeof(__u32))];
-	struct addrinfo hints, *ai;
 	struct cmsghdr *cmsg;
+	size_t cmsg_len;
+
+	msg->msg_control = cbuf;
+	cmsg_len = 0;
+
+	if (opt.mark.ena) {
+		cmsg = (struct cmsghdr *)(cbuf + cmsg_len);
+		cmsg_len += CMSG_SPACE(sizeof(__u32));
+		if (cbuf_sz < cmsg_len)
+			error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SO_MARK;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
+		*(__u32 *)CMSG_DATA(cmsg) = opt.mark.val;
+	}
+
+	if (cmsg_len)
+		msg->msg_controllen = cmsg_len;
+	else
+		msg->msg_control = NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	struct addrinfo hints, *ai;
 	struct iovec iov[1];
 	struct msghdr msg;
-	int mark;
+	char cbuf[1024];
 	int err;
 	int fd;
 
-	if (argc != 4) {
-		fprintf(stderr, "Usage: %s <dst_ip> <port> <mark>\n", argv[0]);
-		return 1;
-	}
-	mark = atoi(argv[3]);
+	cs_parse_args(argc, argv);
 
 	memset(&hints, 0, sizeof(hints));
 	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = SOCK_DGRAM;
+	hints.ai_socktype = opt.sock.type;
 
 	ai = NULL;
-	err = getaddrinfo(argv[1], argv[2], &hints, &ai);
+	err = getaddrinfo(opt.host, opt.service, &hints, &ai);
 	if (err) {
-		fprintf(stderr, "Can't resolve address: %s\n", strerror(errno));
-		return 1;
+		fprintf(stderr, "Can't resolve address [%s]:%s: %s\n",
+			opt.host, opt.service, strerror(errno));
+		return ERN_SOCK_CREATE;
 	}
 
 	fd = socket(ai->ai_family, SOCK_DGRAM, IPPROTO_UDP);
 	if (fd < 0) {
 		fprintf(stderr, "Can't open socket: %s\n", strerror(errno));
 		freeaddrinfo(ai);
-		return 1;
+		return ERN_RESOLVE;
 	}
 
 	iov[0].iov_base = "bla";
 	iov[0].iov_len = 4;
 
+	memset(&msg, 0, sizeof(msg));
 	msg.msg_name = ai->ai_addr;
 	msg.msg_namelen = ai->ai_addrlen;
 	msg.msg_iov = iov;
 	msg.msg_iovlen = 1;
-	msg.msg_control = cbuf;
-	msg.msg_controllen = sizeof(cbuf);
 
-	cmsg = CMSG_FIRSTHDR(&msg);
-	cmsg->cmsg_level = SOL_SOCKET;
-	cmsg->cmsg_type = SO_MARK;
-	cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
-	*(__u32 *)CMSG_DATA(cmsg) = mark;
+	cs_write_cmsg(&msg, cbuf, sizeof(cbuf));
 
 	err = sendmsg(fd, &msg, 0);
+	if (err < 0) {
+		if (!opt.silent_send)
+			fprintf(stderr, "send failed: %s\n", strerror(errno));
+		err = ERN_SEND;
+	} else if (err != 4) {
+		fprintf(stderr, "short send\n");
+		err = ERN_SEND_SHORT;
+	} else {
+		err = ERN_SUCCESS;
+	}
 
 	close(fd);
 	freeaddrinfo(ai);
-	return err != 4;
+	return err;
 }
diff --git a/tools/testing/selftests/net/cmsg_so_mark.sh b/tools/testing/selftests/net/cmsg_so_mark.sh
index 29a623aac74b..841d706dc91b 100755
--- a/tools/testing/selftests/net/cmsg_so_mark.sh
+++ b/tools/testing/selftests/net/cmsg_so_mark.sh
@@ -41,14 +41,14 @@ check_result() {
     fi
 }
 
-ip netns exec $NS ./cmsg_sender $TGT4 1234 $((MARK + 1))
+ip netns exec $NS ./cmsg_sender -m $((MARK + 1)) $TGT4 1234
 check_result $? 0 "IPv4 pass"
-ip netns exec $NS ./cmsg_sender $TGT6 1234 $((MARK + 1))
+ip netns exec $NS ./cmsg_sender -m $((MARK + 1)) $TGT6 1234
 check_result $? 0 "IPv6 pass"
 
-ip netns exec $NS ./cmsg_sender $TGT4 1234 $MARK
+ip netns exec $NS ./cmsg_sender -s -m $MARK $TGT4 1234
 check_result $? 1 "IPv4 rejection"
-ip netns exec $NS ./cmsg_sender $TGT6 1234 $MARK
+ip netns exec $NS ./cmsg_sender -s -m $MARK $TGT6 1234
 check_result $? 1 "IPv6 rejection"
 
 # Summary
-- 
2.34.1

