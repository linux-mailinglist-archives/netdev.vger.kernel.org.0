Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E91328C23
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfEWVJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:09:21 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:35525 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388240AbfEWVJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:09:18 -0400
Received: by mail-pg1-f171.google.com with SMTP id t1so3773259pgc.2
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SPWxLhLzjbcSJowkJYGTCbYUr1bDlyQ2z2VYymjpXdc=;
        b=LIzuQYIymhL4BYQ7NXL17oiKjJYJ6LSj5XTF9omLaTOTP5ITMuDiyETQelGrFRTYCC
         ZIkq0Td0lNyaoUx3Z5LO2dbyA8AUhcX8B9xlHfG26fl50HdaVL8wvqU7/Kx7GcgAVjHo
         3Kr76/Csstl8wF9wcwHqNMX9OJ5JGJCGOKPTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SPWxLhLzjbcSJowkJYGTCbYUr1bDlyQ2z2VYymjpXdc=;
        b=S0FjqKZjTW0bxt95gHATkiubep10Q34aLNPY++xrRt4cGvLb6ppkM4Pi4v9tSMnCq8
         /Np4OLvHCacyovRB1ZF8on4TobYMbB8XRgm3cSUOrFqET2y0PqLgN12K0NebXSdDA9OA
         J3kgbu0VD8ftw1DNewOSBWiPeZxtXI52Udv7WhKEcDPdyn9NJ6eSNHdg8NGy2ynYwvb6
         Gn5aXlBKfrzq/6YK4WJSxyC4aR8/7yjhpIMnHhsnDWSgnLfVWWpQRJfkb7eTVT5qyA8q
         3kQpEg0EPtlQJZ0HkvOgy37P4QtPtPh+jI+GuHu6qAT54wLOcyYluj+c6D3LEtsjrj2Z
         vDaQ==
X-Gm-Message-State: APjAAAXFai2SOvVIJ82tdFYr5SAcMI1KZhrC4QPSSzxNSJZRmNoI4kvu
        FeQKzUqC9NJTHjq4ozBQajN9PA==
X-Google-Smtp-Source: APXvYqyv/H/LE0IdZ5dA9QUiXGDqKw8CMr2yhtC8EeJRZLaWNM9khpAEKcsp666JxO3Q2EEDeik7IQ==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr4336027pjt.59.1558645757359;
        Thu, 23 May 2019 14:09:17 -0700 (PDT)
Received: from localhost.localdomain (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.googlemail.com with ESMTPSA id y17sm333481pfn.79.2019.05.23.14.09.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:09:16 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
Date:   Thu, 23 May 2019 14:06:51 -0700
Message-Id: <20190523210651.80902-5-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523210651.80902-1-fklassen@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enhancement adds the '-a' option, which will count all CMSG
messages on the error queue and print a summary report.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")

Example:

    # ./udpgso_bench_tx -4uT -a -l5 -S 1472 -D 172.16.120.189
    udp tx:    492 MB/s     8354 calls/s   8354 msg/s
    udp tx:    477 MB/s     8106 calls/s   8106 msg/s
    udp tx:    488 MB/s     8288 calls/s   8288 msg/s
    udp tx:    882 MB/s    14975 calls/s  14975 msg/s
    Summary over 5.000 seconds ...
    sum udp tx:    696 MB/s      57696 calls (11539/s)  57696 msgs (11539/s)
    Tx Timestamps: received:     57696   errors: 0

This can be useful in tracking loss of messages when under load. For example,
adding the '-z' option results in loss of TX timestamp messages:

    # ./udpgso_bench_tx -4ucT -a -l5 -S 1472 -D 172.16.120.189 -p 3239 -z
    udp tx:    490 MB/s     8325 calls/s   8325 msg/s
    udp tx:    500 MB/s     8492 calls/s   8492 msg/s
    udp tx:    883 MB/s    14985 calls/s  14985 msg/s
    udp tx:    756 MB/s    12823 calls/s  12823 msg/s
    Summary over 5.000 seconds ...
    sum udp tx:    657 MB/s      54429 calls (10885/s)  54429 msgs (10885/s)
    Tx Timestamps: received:     34046   errors: 0
    Zerocopy acks: received:     54422   errors: 0

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 152 +++++++++++++++++++-------
 1 file changed, 113 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 56e0d890b066..9924342a0b03 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -62,10 +62,19 @@ static bool	cfg_tcp;
 static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
 static bool	cfg_tx_tstamp;
 static uint32_t	cfg_tos;
+static bool	cfg_audit;
 static bool	cfg_verbose;
 static bool	cfg_zerocopy;
 static int	cfg_msg_nr;
 static uint16_t	cfg_gso_size;
+static unsigned long total_num_msgs;
+static unsigned long total_num_sends;
+static unsigned long stat_tx_ts;
+static unsigned long stat_tx_ts_errors;
+static unsigned long tstart;
+static unsigned long tend;
+static unsigned long stat_zcopies;
+static unsigned long stat_zcopy_errors;
 
 static socklen_t cfg_alen;
 static struct sockaddr_storage cfg_dst_addr;
@@ -137,8 +146,11 @@ static void flush_cmsg(struct cmsghdr *cmsg)
 			struct my_scm_timestamping *tss;
 
 			tss = (struct my_scm_timestamping *)CMSG_DATA(cmsg);
-			fprintf(stderr, "tx timestamp = %lu.%09lu\n",
-				tss->ts[i].tv_sec, tss->ts[i].tv_nsec);
+			if (tss->ts[i].tv_sec == 0)
+				stat_tx_ts_errors++;
+			if (cfg_verbose)
+				fprintf(stderr, "tx timestamp = %lu.%09lu\n",
+					tss->ts[i].tv_sec, tss->ts[i].tv_nsec);
 		} else {
 			error(1, 0,
 			      "unknown SOL_SOCKET cmsg type=%u level=%u\n",
@@ -157,41 +169,52 @@ static void flush_cmsg(struct cmsghdr *cmsg)
 			switch (err->ee_origin) {
 			case SO_EE_ORIGIN_TIMESTAMPING:
 				// Got a TX timestamp from error queue
-				fprintf(stderr,
-					"got SO_EE_ORIGIN_TIMESTAMPING\n");
+				stat_tx_ts++;
+				if (cfg_verbose)
+					fprintf(stderr,
+						"got SO_EE_ORIGIN_TIMESTAMPING\n");
 				break;
 			case SO_EE_ORIGIN_ICMP:
 			case SO_EE_ORIGIN_ICMP6:
-				fprintf(stderr,
-					"received ICMP error: type=%u, code=%u\n",
-					err->ee_type, err->ee_code);
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received ICMP error: type=%u, code=%u\n",
+						err->ee_type, err->ee_code);
 				break;
 			case SO_EE_ORIGIN_ZEROCOPY:
 			{
 				__u32 lo = err->ee_info;
 				__u32 hi = err->ee_data;
 
-				if (hi == lo - 1)
+				if (hi == lo - 1) {
 					// TX was aborted
-					fprintf(stderr,
-						"Zerocopy TX aborted: lo=%u hi=%u\n",
-						lo, hi);
-				if (hi == lo)
+					stat_zcopy_errors++;
+					if (cfg_verbose)
+						fprintf(stderr,
+							"Zerocopy TX aborted: lo=%u hi=%u\n",
+							lo, hi);
+				} else if (hi == lo) {
 					// single ID acknowledged
-					fprintf(stderr,
-						"Zerocopy TX ack ID: %u\n",
-						lo);
-				else
+					stat_zcopies++;
+					if (cfg_verbose)
+						fprintf(stderr,
+							"Zerocopy TX ack ID: %u\n",
+							lo);
+				} else {
 					// range of IDs acknowledged
-					fprintf(stderr,
-						"Zerocopy TX ack %u IDs %u to %u\n",
-						hi - lo + 1, lo, hi);
+					stat_zcopies += hi - lo + 1;
+					if (cfg_verbose)
+						fprintf(stderr,
+							"Zerocopy TX ack %u IDs %u to %u\n",
+							hi - lo + 1, lo, hi);
+				}
 				break;
 			}
 			case SO_EE_ORIGIN_LOCAL:
-				fprintf(stderr,
-					"received packet with local origin: %u\n",
-					err->ee_origin);
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received packet with local origin: %u\n",
+						err->ee_origin);
 				break;
 			default:
 				error(0, 1,
@@ -236,7 +259,7 @@ static void flush_errqueue_recv(int fd)
 		if (ret == -1)
 			error(1, errno, "errqueue");
 		msg.msg_flags = 0;
-		if (cfg_verbose) {
+		if (cfg_audit || cfg_verbose) {
 			for (cmsg = CMSG_FIRSTHDR(&msg);
 					cmsg;
 					cmsg = CMSG_NXTHDR(&msg, cmsg))
@@ -245,19 +268,21 @@ static void flush_errqueue_recv(int fd)
 	}
 }
 
-static void flush_errqueue(int fd)
+static void flush_errqueue(int fd, const bool do_poll)
 {
-	if (cfg_poll) {
+	if (do_poll) {
 		struct pollfd fds = { 0 };
 		int ret;
 
 		fds.fd = fd;
 		fds.events = POLLERR;
-		ret = poll(&fds, 1, 1000);
-		if (ret == 0)
-			error(1, 0, "poll timeout");
-		else if (ret < 0)
+		ret = poll(&fds, 1, 500);
+		if (ret == 0) {
+			if (cfg_verbose)
+				fprintf(stderr, "poll timeout\n");
+		} else if (ret < 0) {
 			error(1, errno, "poll");
+		}
 	}
 
 	flush_errqueue_recv(fd);
@@ -458,7 +483,7 @@ static int send_udp_segment(int fd, char *data)
 static void usage(const char *filepath)
 {
 	error(1, 0,
-	      "Usage: %s [-46cmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-q tos] [-s sendsize] [-S gsosize]",
+	      "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-q tos] [-s sendsize] [-S gsosize]",
 	      filepath);
 }
 
@@ -467,7 +492,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46cC:D:Hl:mM:p:s:q:PS:tTuvz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:q:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -481,6 +506,9 @@ static void parse_opts(int argc, char **argv)
 			cfg_family = PF_INET6;
 			cfg_alen = sizeof(struct sockaddr_in6);
 			break;
+		case 'a':
+			cfg_audit = true;
+			break;
 		case 'c':
 			cfg_cache_trash = true;
 			break;
@@ -599,6 +627,51 @@ static void set_tx_timestamping(int fd)
 		error(1, errno, "setsockopt tx timestamping");
 }
 
+static void print_final_report(unsigned long num_msgs, unsigned long num_sends)
+{
+	unsigned long tdelta;
+
+	tdelta = tend - tstart;
+	if (!tdelta)
+		return;
+
+	fprintf(stderr, "Summary over %lu.%03lu seconds ...\n", tdelta / 1000,
+		tdelta % 1000);
+	fprintf(stderr,
+		"sum %s tx: %6lu MB/s %10lu calls (%lu/s) %10lu msgs (%lu/s)\n",
+		cfg_tcp ? "tcp" : "udp",
+		((num_msgs * cfg_payload_len) >> 10) / tdelta,
+		num_sends, num_sends * 1000 / tdelta,
+		num_msgs, num_msgs * 1000 / tdelta);
+	if (cfg_tx_tstamp)
+		fprintf(stderr,
+			"Tx Timestamps: received: %9lu   errors: %lu\n",
+			stat_tx_ts, stat_tx_ts_errors);
+
+	if (cfg_zerocopy)
+		fprintf(stderr,
+			"Zerocopy acks: received: %9lu   errors: %lu\n",
+			stat_zcopies, stat_zcopy_errors);
+}
+
+static void print_report(unsigned long num_msgs, unsigned long num_sends,
+			 const bool final)
+{
+	if (!final)
+		fprintf(stderr,
+			"%s tx: %6lu MB/s %8lu calls/s %6lu msg/s\n",
+			cfg_tcp ? "tcp" : "udp",
+			(num_msgs * cfg_payload_len) >> 20,
+			num_sends, num_msgs);
+
+	if (cfg_audit) {
+		total_num_msgs += num_msgs;
+		total_num_sends += num_sends;
+		if (final)
+			print_final_report(total_num_msgs, total_num_sends);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	unsigned long num_msgs, num_sends;
@@ -640,6 +713,8 @@ int main(int argc, char **argv)
 	num_msgs = 0;
 	num_sends = 0;
 	tnow = gettimeofday_ms();
+	tstart = tnow;
+	tend = tnow;
 	tstop = tnow + cfg_runtime_ms;
 	treport = tnow + 1000;
 
@@ -654,19 +729,15 @@ int main(int argc, char **argv)
 		else
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
-		if ((cfg_zerocopy && (num_msgs & 0xF) == 0) || cfg_tx_tstamp)
-			flush_errqueue(fd);
+		if (cfg_tx_tstamp || (cfg_zerocopy && (num_msgs & 0xF) == 0))
+			flush_errqueue(fd, cfg_poll);
 
 		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
 			break;
 
 		tnow = gettimeofday_ms();
 		if (tnow > treport) {
-			fprintf(stderr,
-				"%s tx: %6lu MB/s %8lu calls/s %6lu msg/s\n",
-				cfg_tcp ? "tcp" : "udp",
-				(num_msgs * cfg_payload_len) >> 20,
-				num_sends, num_msgs);
+			print_report(num_msgs, num_sends, false);
 			num_msgs = 0;
 			num_sends = 0;
 			treport = tnow + 1000;
@@ -679,10 +750,13 @@ int main(int argc, char **argv)
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
 	if (cfg_zerocopy || cfg_tx_tstamp)
-		flush_errqueue(fd);
+		flush_errqueue(fd, true);
 
 	if (close(fd))
 		error(1, errno, "close");
 
+	tend = tnow;
+	print_report(num_msgs, num_sends, true);
+
 	return 0;
 }
-- 
2.11.0

