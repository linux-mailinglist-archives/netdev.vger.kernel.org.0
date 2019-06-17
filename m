Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE948D91
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfFQTI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:08:59 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33716 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfFQTI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:08:59 -0400
Received: by mail-pg1-f178.google.com with SMTP id k187so6328697pga.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AP/4pH3jlz3cI4zzX0zArm0dLh5w57/B9wwQxHwBU+M=;
        b=RitmM8gHH28a5ltUFCczfswEabXRZg8gBT4PVXCmRdSrIDRcvep8lg4GWWlD8gXQ7h
         1+IdhGor1BfnCcPkT/LS7S5ZEM4fgmAg0scI48kd3jdr+Rdxeki0UqiRUOg60dJWEV0I
         0eCNXF/q2/p4MowMo6iChUnRUDkhvGjEzx6+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AP/4pH3jlz3cI4zzX0zArm0dLh5w57/B9wwQxHwBU+M=;
        b=kclFXGvDrSWt8/8VHdeQgluf6iHjOXcFR7uHL9AwIOgpGLH/kIQoV7jTDWx/WXLmhO
         fSW1fveD7+ivw/cGSf0MHbd8dYYO9YrPpFkw5nVFDbMRELzhB5wVl/y3BmsldbisN7up
         e2WHuL3ssp2nmxUO1rGSXe7I454Bwr0TOU12oG8lfS+UTbgbFFMC4i/fdkPvQrP7guEx
         LKO+wcjV0B6mk4vLskrdZtv1LIaJDAwsi2l5svCePGbnluymF/fVToQO5N+zzQJRw75l
         xYCS5F7F+sGXAF8Lqblyf8SPrnLLPZf35gcm3vWcOg+eCaPXsxLCeyvj6ryZb5uJTtrP
         IC3A==
X-Gm-Message-State: APjAAAUjucKSgcMoJgK9+kHpx6tTwS3Lf8pp2dAAruwxJOej5z1vMyN6
        fwhagwyFPKNCrbLxYtcslgS9TYUpGCg=
X-Google-Smtp-Source: APXvYqxqExWzstaLoSJjD0W67kXvxUCFIXwt+/BwA746nyHKpHQjC/28PxXntYr1iWroJUhhGuMfMQ==
X-Received: by 2002:aa7:972a:: with SMTP id k10mr82116910pfg.116.1560798537880;
        Mon, 17 Jun 2019 12:08:57 -0700 (PDT)
Received: from linux-net-fred.jaalam.net ([2001:4958:15a0:24:5054:ff:fecb:7a95])
        by smtp.googlemail.com with ESMTPSA id p43sm111063pjp.4.2019.06.17.12.08.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 12:08:57 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net-next v3 1/3] net/udpgso_bench_tx: options to exercise TX CMSG
Date:   Mon, 17 Jun 2019 12:08:35 -0700
Message-Id: <20190617190837.13186-2-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190617190837.13186-1-fklassen@appneta.com>
References: <20190617190837.13186-1-fklassen@appneta.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enhancement adds options that facilitate load testing with
additional TX CMSG options, and to optionally print results of
various send CMSG operations.

These options are especially useful in isolating situations
where error-queue messages are lost when combined with other
CMSG operations (e.g. SO_ZEROCOPY).

New options:
    -a - count all CMSG messages and match to sent messages
    -T - add TX CMSG that requests TX software timestamps
    -H - similar to -T except request TX hardware timestamps
    -P - call poll() before reading error queue
    -v - print detailed results

v2: Enhancements as per Willem de Bruijn <willemb@google.com>
    - Updated control and buffer parameters for recvmsg
    - poll() parameter cleanup
    - fail on bad audit results
    - remove TOS options
    - improved reporting

v3: Enhancements as per Willem de Bruijn <willemb@google.com>
    - add SOF_TIMESTAMPING_OPT_TSONLY to eliminate MSG_TRUNC
    - general code cleanup

Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 291 ++++++++++++++++++++++++--
 1 file changed, 276 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 4074538b5df5..dfa83ad57206 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -5,6 +5,8 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <error.h>
+#include <linux/errqueue.h>
+#include <linux/net_tstamp.h>
 #include <netinet/if_ether.h>
 #include <netinet/in.h>
 #include <netinet/ip.h>
@@ -19,6 +21,7 @@
 #include <string.h>
 #include <sys/socket.h>
 #include <sys/time.h>
+#include <sys/poll.h>
 #include <sys/types.h>
 #include <unistd.h>
 
@@ -34,6 +37,10 @@
 #define SO_ZEROCOPY	60
 #endif
 
+#ifndef SO_EE_ORIGIN_ZEROCOPY
+#define SO_EE_ORIGIN_ZEROCOPY 5
+#endif
+
 #ifndef MSG_ZEROCOPY
 #define MSG_ZEROCOPY	0x4000000
 #endif
@@ -48,12 +55,24 @@ static uint16_t	cfg_mss;
 static int	cfg_payload_len	= (1472 * 42);
 static int	cfg_port	= 8000;
 static int	cfg_runtime_ms	= -1;
+static bool	cfg_poll;
 static bool	cfg_segment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
+static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
+static bool	cfg_tx_tstamp;
+static bool	cfg_audit;
+static bool	cfg_verbose;
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
 
 static socklen_t cfg_alen;
 static struct sockaddr_storage cfg_dst_addr;
@@ -110,23 +129,125 @@ static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
 	}
 }
 
-static void flush_zerocopy(int fd)
+static void flush_cmsg(struct cmsghdr *cmsg)
 {
-	struct msghdr msg = {0};	/* flush */
+	struct sock_extended_err *err;
+	struct scm_timestamping *tss;
+	__u32 lo;
+	__u32 hi;
+	int i;
+
+	switch (cmsg->cmsg_level) {
+	case SOL_SOCKET:
+		if (cmsg->cmsg_type == SO_TIMESTAMPING) {
+			i = (cfg_tx_ts == SOF_TIMESTAMPING_TX_HARDWARE) ? 2 : 0;
+			tss = (struct scm_timestamping *)CMSG_DATA(cmsg);
+			if (tss->ts[i].tv_sec == 0)
+				stat_tx_ts_errors++;
+		} else {
+			error(1, 0, "unknown SOL_SOCKET cmsg type=%u\n",
+			      cmsg->cmsg_type);
+		}
+		break;
+	case SOL_IP:
+	case SOL_IPV6:
+		switch (cmsg->cmsg_type) {
+		case IP_RECVERR:
+		case IPV6_RECVERR:
+		{
+			err = (struct sock_extended_err *)CMSG_DATA(cmsg);
+			switch (err->ee_origin) {
+			case SO_EE_ORIGIN_TIMESTAMPING:
+				/* Got a TX timestamp from error queue */
+				stat_tx_ts++;
+				break;
+			case SO_EE_ORIGIN_ICMP:
+			case SO_EE_ORIGIN_ICMP6:
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received ICMP error: type=%u, code=%u\n",
+						err->ee_type, err->ee_code);
+				break;
+			case SO_EE_ORIGIN_ZEROCOPY:
+			{
+				lo = err->ee_info;
+				hi = err->ee_data;
+				/* range of IDs acknowledged */
+				stat_zcopies += hi - lo + 1;
+				break;
+			}
+			case SO_EE_ORIGIN_LOCAL:
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received packet with local origin: %u\n",
+						err->ee_origin);
+				break;
+			default:
+				error(0, 1, "received packet with origin: %u",
+				      err->ee_origin);
+			}
+			break;
+		}
+		default:
+			error(0, 1, "unknown IP msg type=%u\n",
+			      cmsg->cmsg_type);
+			break;
+		}
+		break;
+	default:
+		error(0, 1, "unknown cmsg level=%u\n",
+		      cmsg->cmsg_level);
+	}
+}
+
+static void flush_errqueue_recv(int fd)
+{
+	char control[CMSG_SPACE(sizeof(struct scm_timestamping)) +
+		     CMSG_SPACE(sizeof(struct sock_extended_err)) +
+		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
+	struct msghdr msg = {0};
+	struct cmsghdr *cmsg;
 	int ret;
 
 	while (1) {
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
 		ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
 		if (ret == -1 && errno == EAGAIN)
 			break;
 		if (ret == -1)
 			error(1, errno, "errqueue");
-		if (msg.msg_flags != (MSG_ERRQUEUE | MSG_CTRUNC))
+		if (msg.msg_flags != MSG_ERRQUEUE)
 			error(1, 0, "errqueue: flags 0x%x\n", msg.msg_flags);
+		if (cfg_audit) {
+			for (cmsg = CMSG_FIRSTHDR(&msg);
+					cmsg;
+					cmsg = CMSG_NXTHDR(&msg, cmsg))
+				flush_cmsg(cmsg);
+		}
 		msg.msg_flags = 0;
 	}
 }
 
+static void flush_errqueue(int fd, const bool do_poll)
+{
+	if (do_poll) {
+		struct pollfd fds = {0};
+		int ret;
+
+		fds.fd = fd;
+		ret = poll(&fds, 1, 500);
+		if (ret == 0) {
+			if (cfg_verbose)
+				fprintf(stderr, "poll timeout\n");
+		} else if (ret < 0) {
+			error(1, errno, "poll");
+		}
+	}
+
+	flush_errqueue_recv(fd);
+}
+
 static int send_tcp(int fd, char *data)
 {
 	int ret, done = 0, count = 0;
@@ -168,16 +289,40 @@ static int send_udp(int fd, char *data)
 	return count;
 }
 
+static void send_ts_cmsg(struct cmsghdr *cm)
+{
+	uint32_t *valp;
+
+	cm->cmsg_level = SOL_SOCKET;
+	cm->cmsg_type = SO_TIMESTAMPING;
+	cm->cmsg_len = CMSG_LEN(sizeof(cfg_tx_ts));
+	valp = (void *)CMSG_DATA(cm);
+	*valp = cfg_tx_ts;
+}
+
 static int send_udp_sendmmsg(int fd, char *data)
 {
+	char control[CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
 	const int max_nr_msg = ETH_MAX_MTU / ETH_DATA_LEN;
 	struct mmsghdr mmsgs[max_nr_msg];
 	struct iovec iov[max_nr_msg];
 	unsigned int off = 0, left;
+	size_t msg_controllen = 0;
 	int i = 0, ret;
 
 	memset(mmsgs, 0, sizeof(mmsgs));
 
+	if (cfg_tx_tstamp) {
+		struct msghdr msg = {0};
+		struct cmsghdr *cmsg;
+
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+		cmsg = CMSG_FIRSTHDR(&msg);
+		send_ts_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
+	}
+
 	left = cfg_payload_len;
 	while (left) {
 		if (i == max_nr_msg)
@@ -189,6 +334,13 @@ static int send_udp_sendmmsg(int fd, char *data)
 		mmsgs[i].msg_hdr.msg_iov = iov + i;
 		mmsgs[i].msg_hdr.msg_iovlen = 1;
 
+		mmsgs[i].msg_hdr.msg_name = (void *)&cfg_dst_addr;
+		mmsgs[i].msg_hdr.msg_namelen = cfg_alen;
+		if (msg_controllen) {
+			mmsgs[i].msg_hdr.msg_control = control;
+			mmsgs[i].msg_hdr.msg_controllen = msg_controllen;
+		}
+
 		off += iov[i].iov_len;
 		left -= iov[i].iov_len;
 		i++;
@@ -214,9 +366,12 @@ static void send_udp_segment_cmsg(struct cmsghdr *cm)
 
 static int send_udp_segment(int fd, char *data)
 {
-	char control[CMSG_SPACE(sizeof(cfg_gso_size))] = {0};
+	char control[CMSG_SPACE(sizeof(cfg_gso_size)) +
+		     CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
+	size_t msg_controllen;
+	struct cmsghdr *cmsg;
 	int ret;
 
 	iov.iov_base = data;
@@ -227,8 +382,16 @@ static int send_udp_segment(int fd, char *data)
 
 	msg.msg_control = control;
 	msg.msg_controllen = sizeof(control);
-	send_udp_segment_cmsg(CMSG_FIRSTHDR(&msg));
+	cmsg = CMSG_FIRSTHDR(&msg);
+	send_udp_segment_cmsg(cmsg);
+	msg_controllen = CMSG_SPACE(sizeof(cfg_mss));
+	if (cfg_tx_tstamp) {
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+		send_ts_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
+	}
 
+	msg.msg_controllen = msg_controllen;
 	msg.msg_name = (void *)&cfg_dst_addr;
 	msg.msg_namelen = cfg_alen;
 
@@ -243,7 +406,7 @@ static int send_udp_segment(int fd, char *data)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46cmtuz] [-C cpu] [-D dst ip] [-l secs] [-m messagenr] [-p port] [-s sendsize] [-S gsosize]",
+	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
 		    filepath);
 }
 
@@ -252,7 +415,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46cC:D:l:mM:p:s:S:tuz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -266,6 +429,9 @@ static void parse_opts(int argc, char **argv)
 			cfg_family = PF_INET6;
 			cfg_alen = sizeof(struct sockaddr_in6);
 			break;
+		case 'a':
+			cfg_audit = true;
+			break;
 		case 'c':
 			cfg_cache_trash = true;
 			break;
@@ -287,6 +453,9 @@ static void parse_opts(int argc, char **argv)
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
 			break;
+		case 'P':
+			cfg_poll = true;
+			break;
 		case 's':
 			cfg_payload_len = strtoul(optarg, NULL, 0);
 			break;
@@ -294,12 +463,22 @@ static void parse_opts(int argc, char **argv)
 			cfg_gso_size = strtoul(optarg, NULL, 0);
 			cfg_segment = true;
 			break;
+		case 'H':
+			cfg_tx_ts = SOF_TIMESTAMPING_TX_HARDWARE;
+			cfg_tx_tstamp = true;
+			break;
 		case 't':
 			cfg_tcp = true;
 			break;
+		case 'T':
+			cfg_tx_tstamp = true;
+			break;
 		case 'u':
 			cfg_connected = false;
 			break;
+		case 'v':
+			cfg_verbose = true;
+			break;
 		case 'z':
 			cfg_zerocopy = true;
 			break;
@@ -315,6 +494,8 @@ static void parse_opts(int argc, char **argv)
 		error(1, 0, "connectionless tcp makes no sense");
 	if (cfg_segment && cfg_sendmmsg)
 		error(1, 0, "cannot combine segment offload and sendmmsg");
+	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg))
+		error(1, 0, "Options -T and -H require either -S or -m option");
 
 	if (cfg_family == PF_INET)
 		hdrlen = sizeof(struct iphdr) + sizeof(struct udphdr);
@@ -349,6 +530,75 @@ static void set_pmtu_discover(int fd, bool is_ipv4)
 		error(1, errno, "setsockopt path mtu");
 }
 
+static void set_tx_timestamping(int fd)
+{
+	int val = SOF_TIMESTAMPING_OPT_CMSG | SOF_TIMESTAMPING_OPT_ID |
+			SOF_TIMESTAMPING_OPT_TSONLY;
+
+	if (cfg_tx_ts == SOF_TIMESTAMPING_TX_SOFTWARE)
+		val |= SOF_TIMESTAMPING_SOFTWARE;
+	else
+		val |= SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val)))
+		error(1, errno, "setsockopt tx timestamping");
+}
+
+static void print_audit_report(unsigned long num_msgs, unsigned long num_sends)
+{
+	unsigned long tdelta;
+
+	tdelta = tend - tstart;
+	if (!tdelta)
+		return;
+
+	fprintf(stderr, "Summary over %lu.%03lu seconds...\n",
+			tdelta / 1000, tdelta % 1000);
+	fprintf(stderr,
+		"sum %s tx: %6lu MB/s %10lu calls (%lu/s) %10lu msgs (%lu/s)\n",
+		cfg_tcp ? "tcp" : "udp",
+		((num_msgs * cfg_payload_len) >> 10) / tdelta,
+		num_sends, num_sends * 1000 / tdelta,
+		num_msgs, num_msgs * 1000 / tdelta);
+
+	if (cfg_tx_tstamp) {
+		if (stat_tx_ts_errors)
+			error(1, 0,
+			      "Expected clean TX Timestamps: %9lu msgs received %6lu errors",
+			      stat_tx_ts, stat_tx_ts_errors);
+		if (stat_tx_ts != num_sends)
+			error(1, 0,
+			      "Unexpected number of TX Timestamps: %9lu expected %9lu received",
+			      num_sends, stat_tx_ts);
+		fprintf(stderr,
+			"Tx Timestamps: %19lu received %17lu errors\n",
+			stat_tx_ts, stat_tx_ts_errors);
+	}
+
+	if (cfg_zerocopy) {
+		if (stat_zcopies != num_sends)
+			error(1, 0, "Unexpected number of Zerocopy completions: %9lu expected %9lu received",
+			      num_sends, stat_zcopies);
+		fprintf(stderr,
+			"Zerocopy acks: %19lu\n",
+			stat_zcopies);
+	}
+}
+
+static void print_report(unsigned long num_msgs, unsigned long num_sends)
+{
+	fprintf(stderr,
+		"%s tx: %6lu MB/s %8lu calls/s %6lu msg/s\n",
+		cfg_tcp ? "tcp" : "udp",
+		(num_msgs * cfg_payload_len) >> 20,
+		num_sends, num_msgs);
+
+	if (cfg_audit) {
+		total_num_msgs += num_msgs;
+		total_num_sends += num_sends;
+	}
+}
+
 int main(int argc, char **argv)
 {
 	unsigned long num_msgs, num_sends;
@@ -384,8 +634,13 @@ int main(int argc, char **argv)
 	if (cfg_segment)
 		set_pmtu_discover(fd, cfg_family == PF_INET);
 
+	if (cfg_tx_tstamp)
+		set_tx_timestamping(fd);
+
 	num_msgs = num_sends = 0;
 	tnow = gettimeofday_ms();
+	tstart = tnow;
+	tend = tnow;
 	tstop = tnow + cfg_runtime_ms;
 	treport = tnow + 1000;
 
@@ -400,19 +655,15 @@ int main(int argc, char **argv)
 		else
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
-		if (cfg_zerocopy && ((num_msgs & 0xF) == 0))
-			flush_zerocopy(fd);
+		if ((cfg_zerocopy && ((num_msgs & 0xF) == 0)) || cfg_tx_tstamp)
+			flush_errqueue(fd, cfg_poll);
 
 		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
 			break;
 
 		tnow = gettimeofday_ms();
-		if (tnow > treport) {
-			fprintf(stderr,
-				"%s tx: %6lu MB/s %8lu calls/s %6lu msg/s\n",
-				cfg_tcp ? "tcp" : "udp",
-				(num_msgs * cfg_payload_len) >> 20,
-				num_sends, num_msgs);
+		if (tnow >= treport) {
+			print_report(num_msgs, num_sends);
 			num_msgs = num_sends = 0;
 			treport = tnow + 1000;
 		}
@@ -423,8 +674,18 @@ int main(int argc, char **argv)
 
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
+	if (cfg_zerocopy || cfg_tx_tstamp)
+		flush_errqueue(fd, true);
+
 	if (close(fd))
 		error(1, errno, "close");
 
+	if (cfg_audit) {
+		tend = tnow;
+		total_num_msgs += num_msgs;
+		total_num_sends += num_sends;
+		print_audit_report(total_num_msgs, total_num_sends);
+	}
+
 	return 0;
 }
-- 
2.11.0

