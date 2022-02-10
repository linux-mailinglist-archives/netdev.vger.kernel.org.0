Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619FD4B02D5
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiBJCAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:00:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiBJB7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247E62AA;
        Wed,  9 Feb 2022 17:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AF3D616CF;
        Thu, 10 Feb 2022 00:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57228C340F1;
        Thu, 10 Feb 2022 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644453419;
        bh=OFLPfECKoCbM5N076ZRdl3KrdynP19NRiTzMU8d/alU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOqJ3IS/BmX4miVMn0i6NCNgILKCLdTbzpJ2mV3QGk4/mYQVnNvXlzsXcODqOcNF/
         75YXhobGGgFYh5s8GAzfPkWoZLBMGYKkYw3jeFLFkDMZdqifAB1eHIBj/YP7NCLJ1O
         CIRbOTB0CMF3F4aUqXzDDjoNX46jZqrZSbMRjFZjREVwPSO77wKINbe/F+Q1eK8PY5
         20Wl9lhm5nSkbcGbcKPXiBwxQbsRWs4ig3XFSLGgh58mYeK6CR84E6289jdFqvYJlb
         xfCmYcTOoNifbd2Bp8qxwTGTwcBrFhvRIXas+XAmLQvgyigoVNNuiLfmq+cZXksul/
         wtKF7XNNmTUmA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, lorenzo@google.com,
        maze@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/11] selftests: net: cmsg_sender: support Tx timestamping
Date:   Wed,  9 Feb 2022 16:36:48 -0800
Message-Id: <20220210003649.3120861-11-kuba@kernel.org>
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

Support requesting Tx timestamps:

 $ ./cmsg_sender -p i -t -4 $tgt 123 -d 1000
 SCHED ts0 61us
   SND ts0 1071us

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/cmsg_sender.c | 123 +++++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 5a722baa108b..24444dc72543 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -8,6 +8,7 @@
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
+#include <linux/errqueue.h>
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>
 #include <linux/net_tstamp.h>
@@ -27,6 +28,9 @@ enum {
 	ERN_CMSG_WR,
 	ERN_SOCKOPT,
 	ERN_GETTIME,
+	ERN_RECVERR,
+	ERN_CMSG_RD,
+	ERN_CMSG_RCV,
 };
 
 struct options {
@@ -49,6 +53,9 @@ struct options {
 		bool ena;
 		unsigned int delay;
 	} txtime;
+	struct {
+		bool ena;
+	} ts;
 } opt = {
 	.sock = {
 		.family	= AF_UNSPEC,
@@ -57,6 +64,7 @@ struct options {
 	},
 };
 
+static struct timespec time_start_real;
 static struct timespec time_start_mono;
 
 static void __attribute__((noreturn)) cs_usage(const char *bin)
@@ -71,6 +79,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 	       "\t\t-m val  Set SO_MARK with given value\n"
 	       "\t\t-M val  Set SO_MARK via setsockopt\n"
 	       "\t\t-d val  Set SO_TXTIME with given delay (usec)\n"
+	       "\t\t-t      Enable time stamp reporting\n"
 	       "");
 	exit(ERN_HELP);
 }
@@ -79,7 +88,7 @@ static void cs_parse_args(int argc, char *argv[])
 {
 	char o;
 
-	while ((o = getopt(argc, argv, "46sp:m:M:d:")) != -1) {
+	while ((o = getopt(argc, argv, "46sp:m:M:d:t")) != -1) {
 		switch (o) {
 		case 's':
 			opt.silent_send = true;
@@ -114,6 +123,9 @@ static void cs_parse_args(int argc, char *argv[])
 			opt.txtime.ena = true;
 			opt.txtime.delay = atoi(optarg);
 			break;
+		case 't':
+			opt.ts.ena = true;
+			break;
 		}
 	}
 
@@ -168,6 +180,25 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 		cmsg->cmsg_len = CMSG_LEN(sizeof(txtime));
 		memcpy(CMSG_DATA(cmsg), &txtime, sizeof(txtime));
 	}
+	if (opt.ts.ena) {
+		__u32 val = SOF_TIMESTAMPING_SOFTWARE |
+			    SOF_TIMESTAMPING_OPT_TSONLY;
+
+		if (setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING,
+			       &val, sizeof(val)))
+			error(ERN_SOCKOPT, errno, "setsockopt TIMESTAMPING");
+
+		cmsg = (struct cmsghdr *)(cbuf + cmsg_len);
+		cmsg_len += CMSG_SPACE(sizeof(__u32));
+		if (cbuf_sz < cmsg_len)
+			error(ERN_CMSG_WR, EFAULT, "cmsg buffer too small");
+
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SO_TIMESTAMPING;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(__u32));
+		*(__u32 *)CMSG_DATA(cmsg) = SOF_TIMESTAMPING_TX_SCHED |
+					    SOF_TIMESTAMPING_TX_SOFTWARE;
+	}
 
 	if (cmsg_len)
 		msg->msg_controllen = cmsg_len;
@@ -175,6 +206,86 @@ cs_write_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
 		msg->msg_control = NULL;
 }
 
+static const char *cs_ts_info2str(unsigned int info)
+{
+	static const char *names[] = {
+		[SCM_TSTAMP_SND]	= "SND",
+		[SCM_TSTAMP_SCHED]	= "SCHED",
+		[SCM_TSTAMP_ACK]	= "ACK",
+	};
+
+	if (info < sizeof(names) / sizeof(names[0]))
+		return names[info];
+	return "unknown";
+}
+
+static void
+cs_read_cmsg(int fd, struct msghdr *msg, char *cbuf, size_t cbuf_sz)
+{
+	struct sock_extended_err *see;
+	struct scm_timestamping *ts;
+	struct cmsghdr *cmsg;
+	int i, err;
+
+	if (!opt.ts.ena)
+		return;
+	msg->msg_control = cbuf;
+	msg->msg_controllen = cbuf_sz;
+
+	while (true) {
+		ts = NULL;
+		see = NULL;
+		memset(cbuf, 0, cbuf_sz);
+
+		err = recvmsg(fd, msg, MSG_ERRQUEUE);
+		if (err < 0) {
+			if (errno == EAGAIN)
+				break;
+			error(ERN_RECVERR, errno, "recvmsg ERRQ");
+		}
+
+		for (cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
+		     cmsg = CMSG_NXTHDR(msg, cmsg)) {
+			if (cmsg->cmsg_level == SOL_SOCKET &&
+			    cmsg->cmsg_type == SO_TIMESTAMPING_OLD) {
+				if (cmsg->cmsg_len < sizeof(*ts))
+					error(ERN_CMSG_RD, EINVAL, "TS cmsg");
+
+				ts = (void *)CMSG_DATA(cmsg);
+			}
+			if ((cmsg->cmsg_level == SOL_IP &&
+			     cmsg->cmsg_type == IP_RECVERR) ||
+			    (cmsg->cmsg_level == SOL_IPV6 &&
+			     cmsg->cmsg_type == IPV6_RECVERR)) {
+				if (cmsg->cmsg_len < sizeof(*see))
+					error(ERN_CMSG_RD, EINVAL, "sock_err cmsg");
+
+				see = (void *)CMSG_DATA(cmsg);
+			}
+		}
+
+		if (!ts)
+			error(ERN_CMSG_RCV, ENOENT, "TS cmsg not found");
+		if (!see)
+			error(ERN_CMSG_RCV, ENOENT, "sock_err cmsg not found");
+
+		for (i = 0; i < 3; i++) {
+			unsigned long long rel_time;
+
+			if (!ts->ts[i].tv_sec && !ts->ts[i].tv_nsec)
+				continue;
+
+			rel_time = (ts->ts[i].tv_sec - time_start_real.tv_sec) *
+				(1000ULL * 1000) +
+				(ts->ts[i].tv_nsec - time_start_real.tv_nsec) /
+				1000;
+			printf(" %5s ts%d %lluus\n",
+			       cs_ts_info2str(see->ee_info),
+			       i, rel_time);
+		}
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	char buf[] = "blablablabla";
@@ -227,6 +338,8 @@ int main(int argc, char *argv[])
 		       &opt.sockopt.mark, sizeof(opt.sockopt.mark)))
 		error(ERN_SOCKOPT, errno, "setsockopt SO_MARK");
 
+	if (clock_gettime(CLOCK_REALTIME, &time_start_real))
+		error(ERN_GETTIME, errno, "gettime REALTIME");
 	if (clock_gettime(CLOCK_MONOTONIC, &time_start_mono))
 		error(ERN_GETTIME, errno, "gettime MONOTINIC");
 
@@ -246,13 +359,21 @@ int main(int argc, char *argv[])
 		if (!opt.silent_send)
 			fprintf(stderr, "send failed: %s\n", strerror(errno));
 		err = ERN_SEND;
+		goto err_out;
 	} else if (err != sizeof(buf)) {
 		fprintf(stderr, "short send\n");
 		err = ERN_SEND_SHORT;
+		goto err_out;
 	} else {
 		err = ERN_SUCCESS;
 	}
 
+	/* Make sure all timestamps have time to loop back */
+	usleep(opt.txtime.delay);
+
+	cs_read_cmsg(fd, &msg, cbuf, sizeof(cbuf));
+
+err_out:
 	close(fd);
 	freeaddrinfo(ai);
 	return err;
-- 
2.34.1

