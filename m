Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B576188DF7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgCQT06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:26:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34918 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgCQT06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id u68so12498298pfb.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dgvl+d5OB6JH2bQkj3Pmn34fP6zWWhSechufApclfgc=;
        b=mjSk8MFDOFTXDiCOiwky6fP3o5wmdckp5icG7u9Si49zdeEW/mRK7/kYPMjWyuJ68Q
         4TTTNKHPlKD76Iv4NTVIcSHRXDJ8CSbTtHF0YEsC8rYFqRCjn8PG/ogzcXcGlEtYxU7n
         eusGgTfBfT/TYdaD+Pq8I6yjswUH2u458Qu/OOBUjmluDIdAZMUhJz1MdmJj3N5fZkaQ
         aaLN1KolDORZPBzAQeH61Qz2iDaqa7LvZVOuFwWJuOH9gHet5oTB/NRocsvi8H2ONuNG
         m0RCS0wWPMis15rR7FP8HBhaEimOOu4dG99haG6v0g4RVUlu38eegr0/texSiX7lC9TX
         7M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dgvl+d5OB6JH2bQkj3Pmn34fP6zWWhSechufApclfgc=;
        b=KDEJwrO6IxqiCAvLuU/W/eO+IPXn4jQmcjP/yKXrXcPtuhNDNVsCJx2QH/KEhX9FkO
         qespiJXVf6fwHefOtgqSQBNUiM7raA6t9pz9KQoCGrXOZ/DaU0PTskQf8WgCWYPSfGZU
         e2CQ5ydwAyJ11+pJ7TcP3Ix4PXb1nnuQY08cmy3lBNVlJt3OuMTMKffNQcIoAbUGo6NS
         Ug+4Q8IIB3+2sycfpHnJTYqdV1KNqjWW/johWyZxEsidhQNPy1vtsb/h+hMRMDNBDE1e
         0FCvFzOCmnsUTK3CmrE3E+upgEqdUWQogSjePAOgJ0ob0FSwRNwhznTyy9Nh7BC+XTts
         /i/A==
X-Gm-Message-State: ANhLgQ0jOjmkT7FNTCIeao1FEWGkqfQ8UaYm9f4rjt4XOk06FVc17Fsn
        Jt2u9Po2OXB4wJfkNpZ6C2I=
X-Google-Smtp-Source: ADFU+vtJO+pkRwNqZH5ETh1tP5SqF5/rfDG8JCn5ZQJGYKofNNk9CLbAekf7nT9CxuIQki9LIKGPEw==
X-Received: by 2002:a62:6dc2:: with SMTP id i185mr293508pfc.195.1584473216903;
        Tue, 17 Mar 2020 12:26:56 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:56 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 4/5] selftests: txtimestamp: add support for epoll().
Date:   Tue, 17 Mar 2020 12:25:08 -0700
Message-Id: <20200317192509.150725-5-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

Add the following new flags:
-e: use level-triggered epoll() instead of poll().
-E: use event-triggered epoll() instead of poll().

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 .../networking/timestamping/txtimestamp.c     | 53 +++++++++++++++++--
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/networking/timestamping/txtimestamp.c
index ee060ae3d44f..f915f24db3fa 100644
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.c
@@ -41,6 +41,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/epoll.h>
 #include <sys/ioctl.h>
 #include <sys/select.h>
 #include <sys/socket.h>
@@ -70,6 +71,8 @@ static int cfg_sleep_usec = 50 * 1000;
 static bool cfg_loop_nodata;
 static bool cfg_use_cmsg;
 static bool cfg_use_pf_packet;
+static bool cfg_use_epoll;
+static bool cfg_epollet;
 static bool cfg_do_listen;
 static uint16_t dest_port = 9000;
 static bool cfg_print_nsec;
@@ -227,6 +230,17 @@ static void print_pktinfo(int family, int ifindex, void *saddr, void *daddr)
 		daddr ? inet_ntop(family, daddr, da, sizeof(da)) : "unknown");
 }
 
+static void __epoll(int epfd)
+{
+	struct epoll_event events;
+	int ret;
+
+	memset(&events, 0, sizeof(events));
+	ret = epoll_wait(epfd, &events, 1, cfg_poll_timeout);
+	if (ret != 1)
+		error(1, errno, "epoll_wait");
+}
+
 static void __poll(int fd)
 {
 	struct pollfd pollfd;
@@ -420,7 +434,7 @@ static void do_test(int family, unsigned int report_opt)
 	struct msghdr msg;
 	struct iovec iov;
 	char *buf;
-	int fd, i, val = 1, total_len;
+	int fd, i, val = 1, total_len, epfd = 0;
 
 	total_len = cfg_payload_len;
 	if (cfg_use_pf_packet || cfg_proto == SOCK_RAW) {
@@ -447,6 +461,20 @@ static void do_test(int family, unsigned int report_opt)
 	if (fd < 0)
 		error(1, errno, "socket");
 
+	if (cfg_use_epoll) {
+		struct epoll_event ev;
+
+		memset(&ev, 0, sizeof(ev));
+		ev.data.fd = fd;
+		if (cfg_epollet)
+			ev.events |= EPOLLET;
+		epfd = epoll_create(1);
+		if (epfd <= 0)
+			error(1, errno, "epoll_create");
+		if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev))
+			error(1, errno, "epoll_ctl");
+	}
+
 	/* reset expected key on each new socket */
 	saved_tskey = -1;
 
@@ -557,8 +585,12 @@ static void do_test(int family, unsigned int report_opt)
 		if (cfg_sleep_usec)
 			usleep(cfg_sleep_usec);
 
-		if (!cfg_busy_poll)
-			__poll(fd);
+		if (!cfg_busy_poll) {
+			if (cfg_use_epoll)
+				__epoll(epfd);
+			else
+				__poll(fd);
+		}
 
 		while (!recv_errmsg(fd)) {}
 	}
@@ -580,7 +612,9 @@ static void __attribute__((noreturn)) usage(const char *filepath)
 			"  -b:   busy poll to read from error queue\n"
 			"  -c N: number of packets for each test\n"
 			"  -C:   use cmsg to set tstamp recording options\n"
-			"  -F:   poll() waits forever for an event\n"
+			"  -e:   use level-triggered epoll() instead of poll()\n"
+			"  -E:   use event-triggered epoll() instead of poll()\n"
+			"  -F:   poll()/epoll() waits forever for an event\n"
 			"  -I:   request PKTINFO\n"
 			"  -l N: send N bytes at a time\n"
 			"  -L    listen on hostname and port\n"
@@ -604,7 +638,8 @@ static void parse_opt(int argc, char **argv)
 	int proto_count = 0;
 	int c;
 
-	while ((c = getopt(argc, argv, "46bc:CFhIl:LnNp:PrRS:uv:V:x")) != -1) {
+	while ((c = getopt(argc, argv,
+				"46bc:CeEFhIl:LnNp:PrRS:uv:V:x")) != -1) {
 		switch (c) {
 		case '4':
 			do_ipv6 = 0;
@@ -621,6 +656,12 @@ static void parse_opt(int argc, char **argv)
 		case 'C':
 			cfg_use_cmsg = true;
 			break;
+		case 'e':
+			cfg_use_epoll = true;
+			break;
+		case 'E':
+			cfg_use_epoll = true;
+			cfg_epollet = true;
 		case 'F':
 			cfg_poll_timeout = -1;
 			break;
@@ -691,6 +732,8 @@ static void parse_opt(int argc, char **argv)
 		error(1, 0, "pass -P, -r, -R or -u, not multiple");
 	if (cfg_do_pktinfo && cfg_use_pf_packet)
 		error(1, 0, "cannot ask for pktinfo over pf_packet");
+	if (cfg_busy_poll && cfg_use_epoll)
+		error(1, 0, "pass epoll or busy_poll, not both");
 
 	if (optind != argc - 1)
 		error(1, 0, "missing required hostname argument");
-- 
2.25.1.481.gfbce0eb801-goog

