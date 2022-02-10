Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB094B02F1
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbiBJCCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:02:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiBJCAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9659D7C;
        Wed,  9 Feb 2022 17:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 894EAB823DF;
        Thu, 10 Feb 2022 00:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD293C340ED;
        Thu, 10 Feb 2022 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453419;
        bh=yt0tTgalQo0Mur9pMyFK1YDa1xPw+j60s2J7DiBzUqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3T1WwdspVCCzh81e2bOqpp7eovvx8IzdeqS9OspSm9DhEL6nBpb4/SGLhvbP8yT5
         PTKw1lZTpmVtAtqUeL0yoVTlVOBLMnegUHtq5mha1Y39yvBrulkN1G0V1PNPKkeMtw
         gYMpy3D1VqEJ6TlRy4wwxvPY3pyzbllbTdTxp+XdoyhMDvQCHfQgFd2BoAOvP5CnKq
         LMtqzWNavElZdfTkAKehGSMi1xg7t9jTgdKD7iHjvbh5exQKMDbPQDbpExKPa8g90y
         aU9BO/uWo3E4uK4D7yx4buBiTWIVih69Ms3TJAIHKIX01GqibPZfciPDhS+CSLEeS4
         1i397FZJQlPtA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/11] selftests: net: cmsg_sender: support setting SO_TXTIME
Date:   Wed,  9 Feb 2022 16:36:47 -0800
Message-Id: <20220210003649.3120861-10-kuba@kernel.org>
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

Add ability to send delayed packets.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 49 +++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index c7586a4b0361..5a722baa108b 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -6,9 +6,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <time.h>
 #include <unistd.h>
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
+#include <linux/net_tstamp.h>
 #include <linux/types.h>
 #include <linux/udp.h>
 #include <sys/socket.h>
@@ -23,6 +25,8 @@ enum {
 	ERN_SOCK_CREATE,
 	ERN_RESOLVE,
 	ERN_CMSG_WR,
+	ERN_SOCKOPT,
+	ERN_GETTIME,
 };
 
 struct options {
@@ -41,6 +45,10 @@ struct options {
 		bool ena;
 		unsigned int val;
 	} mark;
+	struct {
+		bool ena;
+		unsigned int delay;
+	} txtime;
 } opt = {
 	.sock = {
 		.family	= AF_UNSPEC,
@@ -49,6 +57,8 @@ struct options {
 	},
 };
 
+static struct timespec time_start_mono;
+
 static void __attribute__((noreturn)) cs_usage(const char *bin)
 {
 	printf("Usage: %s [opts] <dst host> <dst port / service>\n", bin);
@@ -60,6 +70,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\n"
 	       "\t\t-m val  Set SO_MARK with given value\n"
 	       "\t\t-M val  Set SO_MARK via setsockopt\n"
+	       "\t\t-d val  Set SO_TXTIME with given delay (usec)\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -68,7 +79,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sp:m:M:")) != -1) {
+	while ((o = getopt(argc, argv, "46sp:m:M:d:")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -91,6 +102,7 @@ static void cs_parse_args(int argc, char *argv[])
 				cs_usage(argv[0]);
 			}
 			break;
+
 		case 'm':
 			opt.mark.ena = true;
 			opt.mark.val = atoi(optarg);
@@ -98,6 +110,10 @@ static void cs_parse_args(int argc, char *argv[])
 		case 'M':
 			opt.sockopt.mark = atoi(optarg);
 			break;
+		case 'd':
+			opt.txtime.ena = true;
+			opt.txtime.delay = atoi(optarg);
+			break;
 		}
 	}
 
@@ -109,7 +125,7 @@ static void cs_parse_args(int argc, char *argv[])
 }
 
 static void
-cs_write_cmsg(struct msghdr *msg, char *cbuf, size_t cbuf_sz)
+cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 {
 	struct cmsghdr *cmsg;
 	size_t cmsg_len;
@@ -128,6 +144,30 @@ cs_write_cmsg(struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 		cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
 		*(__u32 *)CMSG_DATA(cmsg) = opt.mark.val;
 	}
+	if (opt.txtime.ena) {
+		struct sock_txtime so_txtime = {
+			.clockid = CLOCK_MONOTONIC,
+		};
+		__u64 txtime;
+
+		if (setsockopt(fd, SOL_SOCKET, SO_TXTIME,
+			       &so_txtime, sizeof(so_txtime)))
+			error(ERN_SOCKOPT, errno, "setsockopt TXTIME");
+
+		txtime = time_start_mono.tv_sec * (1000ULL * 1000 * 1000) +
+			 time_start_mono.tv_nsec +
+			 opt.txtime.delay * 1000;
+
+		cmsg = (struct cmsghdr *)(cbuf + cmsg_len);
+		cmsg_len += CMSG_SPACE(sizeof(txtime));
+		if (cbuf_sz < cmsg_len)
+			error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SCM_TXTIME;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(txtime));
+		memcpy(CMSG_DATA(cmsg), &txtime, sizeof(txtime));
+	}
 
 	if (cmsg_len)
 		msg->msg_controllen = cmsg_len;
@@ -187,6 +227,9 @@ int main(int argc, char *argv[])
 		       &opt.sockopt.mark, sizeof(opt.sockopt.mark)))
 		error(ERN_SOCKOPT, errno, "setsockopt SO_MARK");
 
+	if (clock_gettime(CLOCK_MONOTONIC, &time_start_mono))
+		error(ERN_GETTIME, errno, "gettime MONOTINIC");
+
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(buf);
 
@@ -196,7 +239,7 @@ int main(int argc, char *argv[])
 	msg.msg_iov = iov;
 	msg.msg_iovlen = 1;
 
-	cs_write_cmsg(&msg, cbuf, sizeof(cbuf));
+	cs_write_cmsg(fd, &msg, cbuf, sizeof(cbuf));
 
 	err = sendmsg(fd, &msg, 0);
 	if (err < 0) {
-- 
2.34.1

