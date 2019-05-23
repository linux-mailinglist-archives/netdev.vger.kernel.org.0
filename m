Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5FB28C27
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbfEWVJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:09:12 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33877 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388051AbfEWVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:09:11 -0400
Received: by mail-pl1-f174.google.com with SMTP id w7so3236483plz.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RCXeXtcdVlCP2tOKGACJwp5GAYj8S8Fm5f8s+vnAbY0=;
        b=rncy5zT8+EuumP6mfRdOY9iVaiEo8dWuUPE4fgXORdIOlStzrCccyPo7oUJWAmPOdx
         od7gB7vDPWx8tgaiAnT0MYeyZE8pjd8BDGkn54AG4qoBbOwHBAVTRa63MtHGiBUvkiVe
         a9L4BPlI6bgxMlikRxTinETqEbRfe5zc8zBCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RCXeXtcdVlCP2tOKGACJwp5GAYj8S8Fm5f8s+vnAbY0=;
        b=QKc9kXe+SCLo6VehYYHMzQ3Sv0Fka9sU8nqmMdz2YJ7y36s44y+Oqu8Hf3REHEJe0E
         RDJLvq+/5CeZglEGQv9mDWdLNbcKzE0uwS7Tm5/n8tL3JmQsvQomCTH+R81fzIZWXFTI
         MZI1Bv3xWvQGD5waDaO43WzHstPsOy1wtH/eeivtpMCHl0avjJ8n5e6/e1S9MZApzC9K
         HbEWG1dWgWCw/1YCAjtcFFk+54hLHSMypPr1mE49DPshpu4bwSmGYBhjidBeJIupRJh9
         jdIy+ZKBlcR/HKwkZkQdJmYXVNveH9YMRoABEyshkWluYfYCce2XPaYxbLmXdB7FPl71
         JF7w==
X-Gm-Message-State: APjAAAXkXKwSDloca6uYSCuWAV5bFNQMrPne8nNlOlYov/Pphby8ahl1
        A9fl1+DI3GUM35QL67LQtUmozQ==
X-Google-Smtp-Source: APXvYqzWMGvE0A7QISQUsEscQjaeLmFJhDnD/dwIDKIXocQweuxRy3fqFwufRlQVHShGV1gfhUVEHQ==
X-Received: by 2002:a17:902:b095:: with SMTP id p21mr49653947plr.270.1558645750010;
        Thu, 23 May 2019 14:09:10 -0700 (PDT)
Received: from localhost.localdomain (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.googlemail.com with ESMTPSA id y17sm333481pfn.79.2019.05.23.14.09.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:09:09 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net 2/4] net/udpgso_bench_tx: options to exercise TX CMSG
Date:   Thu, 23 May 2019 14:06:49 -0700
Message-Id: <20190523210651.80902-3-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523210651.80902-1-fklassen@appneta.com>
References: <20190523210651.80902-1-fklassen@appneta.com>
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

    -T - add TX CMSG that requests TX software timestamps
    -H - similar to -T except request TX hardware timestamps
    -q - add IP_TOS/IPV6_TCLASS TX CMSG
    -P - call poll() before reading error queue
    -v - print detailed results

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 290 ++++++++++++++++++++++++--
 1 file changed, 273 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 4074538b5df5..a900f016b9e7 100644
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
@@ -48,9 +55,14 @@ static uint16_t	cfg_mss;
 static int	cfg_payload_len	= (1472 * 42);
 static int	cfg_port	= 8000;
 static int	cfg_runtime_ms	= -1;
+static bool	cfg_poll;
 static bool	cfg_segment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
+static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
+static bool	cfg_tx_tstamp;
+static uint32_t	cfg_tos;
+static bool	cfg_verbose;
 static bool	cfg_zerocopy;
 static int	cfg_msg_nr;
 static uint16_t	cfg_gso_size;
@@ -58,6 +70,10 @@ static uint16_t	cfg_gso_size;
 static socklen_t cfg_alen;
 static struct sockaddr_storage cfg_dst_addr;
 
+struct my_scm_timestamping {
+	struct timespec ts[3];
+};
+
 static bool interrupted;
 static char buf[NUM_PKT][ETH_MAX_MTU];
 
@@ -89,20 +105,20 @@ static int set_cpu(int cpu)
 
 static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
 {
-	struct sockaddr_in6 *addr6 = (void *) sockaddr;
-	struct sockaddr_in *addr4 = (void *) sockaddr;
+	struct sockaddr_in6 *addr6 = (void *)sockaddr;
+	struct sockaddr_in *addr4 = (void *)sockaddr;
 
 	switch (domain) {
 	case PF_INET:
 		addr4->sin_family = AF_INET;
 		addr4->sin_port = htons(cfg_port);
-		if (inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
+		if (inet_pton(AF_INET, str_addr, &addr4->sin_addr) != 1)
 			error(1, 0, "ipv4 parse error: %s", str_addr);
 		break;
 	case PF_INET6:
 		addr6->sin6_family = AF_INET6;
 		addr6->sin6_port = htons(cfg_port);
-		if (inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
+		if (inet_pton(AF_INET6, str_addr, &addr6->sin6_addr) != 1)
 			error(1, 0, "ipv6 parse error: %s", str_addr);
 		break;
 	default:
@@ -110,23 +126,143 @@ static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
 	}
 }
 
-static void flush_zerocopy(int fd)
+static void flush_cmsg(struct cmsghdr *cmsg)
+{
+	int i;
+
+	switch (cmsg->cmsg_level) {
+	case SOL_SOCKET:
+		if (cmsg->cmsg_type == SO_TIMESTAMPING) {
+			i = (cfg_tx_ts == SOF_TIMESTAMPING_TX_HARDWARE) ? 2 : 0;
+			struct my_scm_timestamping *tss;
+
+			tss = (struct my_scm_timestamping *)CMSG_DATA(cmsg);
+			fprintf(stderr, "tx timestamp = %lu.%09lu\n",
+				tss->ts[i].tv_sec, tss->ts[i].tv_nsec);
+		} else {
+			error(1, 0,
+			      "unknown SOL_SOCKET cmsg type=%u level=%u\n",
+			      cmsg->cmsg_type, cmsg->cmsg_level);
+		}
+		break;
+	case SOL_IP:
+	case SOL_IPV6:
+		switch (cmsg->cmsg_type) {
+		case IP_RECVERR:
+		case IPV6_RECVERR:
+		{
+			struct sock_extended_err *err;
+
+			err = (struct sock_extended_err *)CMSG_DATA(cmsg);
+			switch (err->ee_origin) {
+			case SO_EE_ORIGIN_TIMESTAMPING:
+				// Got a TX timestamp from error queue
+				fprintf(stderr,
+					"got SO_EE_ORIGIN_TIMESTAMPING\n");
+				break;
+			case SO_EE_ORIGIN_ICMP:
+			case SO_EE_ORIGIN_ICMP6:
+				fprintf(stderr,
+					"received ICMP error: type=%u, code=%u\n",
+					err->ee_type, err->ee_code);
+				break;
+			case SO_EE_ORIGIN_ZEROCOPY:
+			{
+				__u32 lo = err->ee_info;
+				__u32 hi = err->ee_data;
+
+				if (hi == lo - 1)
+					// TX was aborted
+					fprintf(stderr,
+						"Zerocopy TX aborted: lo=%u hi=%u\n",
+						lo, hi);
+				if (hi == lo)
+					// single ID acknowledged
+					fprintf(stderr,
+						"Zerocopy TX ack ID: %u\n",
+						lo);
+				else
+					// range of IDs acknowledged
+					fprintf(stderr,
+						"Zerocopy TX ack %u IDs %u to %u\n",
+						hi - lo + 1, lo, hi);
+				break;
+			}
+			case SO_EE_ORIGIN_LOCAL:
+				fprintf(stderr,
+					"received packet with local origin: %u\n",
+					err->ee_origin);
+				break;
+			default:
+				error(0, 1,
+				      "received packet with origin: %u\n",
+				      err->ee_origin);
+			}
+
+			break;
+		}
+		default:
+			error(0, 1, "unknown IP msg type=%u level=%u\n",
+			      cmsg->cmsg_type, cmsg->cmsg_level);
+			break;
+		}
+		break;
+	default:
+		error(0, 1, "unknown cmsg type=%u level=%u\n",
+		      cmsg->cmsg_type, cmsg->cmsg_level);
+	}
+}
+
+static void flush_errqueue_recv(int fd)
 {
 	struct msghdr msg = {0};	/* flush */
+	struct cmsghdr *cmsg;
+	struct iovec entry;
+	char control[1024];
+	char buf[1500];
 	int ret;
 
+	entry.iov_base = buf;
+	entry.iov_len = sizeof(buf);
+	msg.msg_iovlen = 1;
+	msg.msg_iov = &entry;
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
 	while (1) {
 		ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
 		if (ret == -1 && errno == EAGAIN)
 			break;
 		if (ret == -1)
 			error(1, errno, "errqueue");
-		if (msg.msg_flags != (MSG_ERRQUEUE | MSG_CTRUNC))
-			error(1, 0, "errqueue: flags 0x%x\n", msg.msg_flags);
 		msg.msg_flags = 0;
+		if (cfg_verbose) {
+			for (cmsg = CMSG_FIRSTHDR(&msg);
+					cmsg;
+					cmsg = CMSG_NXTHDR(&msg, cmsg))
+				flush_cmsg(cmsg);
+		}
 	}
 }
 
+static void flush_errqueue(int fd)
+{
+	if (cfg_poll) {
+		struct pollfd fds = { 0 };
+		int ret;
+
+		fds.fd = fd;
+		fds.events = POLLERR;
+		ret = poll(&fds, 1, 1000);
+		if (ret == 0)
+			error(1, 0, "poll timeout");
+		else if (ret < 0)
+			error(1, errno, "poll");
+	}
+
+	flush_errqueue_recv(fd);
+}
+
 static int send_tcp(int fd, char *data)
 {
 	int ret, done = 0, count = 0;
@@ -168,16 +304,70 @@ static int send_udp(int fd, char *data)
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
+static void send_tos_cmsg(struct cmsghdr *cm)
+{
+	uint32_t *valp;
+	int level, type;
+
+	if (cfg_family == PF_INET) {
+		level = SOL_IP;
+		type  = IP_TOS;
+	} else {
+		level = SOL_IPV6;
+		type  = IPV6_TCLASS;
+	}
+
+	cm->cmsg_level = level;
+	cm->cmsg_type = type;
+	cm->cmsg_len = CMSG_LEN(sizeof(cfg_tos));
+	valp = (void *)CMSG_DATA(cm);
+	*valp = cfg_tos;
+}
+
 static int send_udp_sendmmsg(int fd, char *data)
 {
+	char control[CMSG_SPACE(sizeof(cfg_tos)) +
+		     CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
 	const int max_nr_msg = ETH_MAX_MTU / ETH_DATA_LEN;
 	struct mmsghdr mmsgs[max_nr_msg];
 	struct iovec iov[max_nr_msg];
 	unsigned int off = 0, left;
+	size_t msg_controllen = 0;
 	int i = 0, ret;
 
 	memset(mmsgs, 0, sizeof(mmsgs));
 
+	if (cfg_tx_tstamp || cfg_tos) {
+		struct msghdr msg = {0};
+		struct cmsghdr *cmsg;
+
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+		cmsg = CMSG_FIRSTHDR(&msg);
+		if (cfg_tos) {
+			send_tos_cmsg(cmsg);
+			msg_controllen += CMSG_SPACE(sizeof(cfg_tos));
+		}
+
+		if (cfg_tx_tstamp) {
+			if (msg_controllen)
+				cmsg = CMSG_NXTHDR(&msg, cmsg);
+			send_ts_cmsg(cmsg);
+			msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
+		}
+	}
+
 	left = cfg_payload_len;
 	while (left) {
 		if (i == max_nr_msg)
@@ -188,6 +378,10 @@ static int send_udp_sendmmsg(int fd, char *data)
 
 		mmsgs[i].msg_hdr.msg_iov = iov + i;
 		mmsgs[i].msg_hdr.msg_iovlen = 1;
+		if (msg_controllen) {
+			mmsgs[i].msg_hdr.msg_control = control;
+			mmsgs[i].msg_hdr.msg_controllen = msg_controllen;
+		}
 
 		off += iov[i].iov_len;
 		left -= iov[i].iov_len;
@@ -214,9 +408,13 @@ static void send_udp_segment_cmsg(struct cmsghdr *cm)
 
 static int send_udp_segment(int fd, char *data)
 {
-	char control[CMSG_SPACE(sizeof(cfg_gso_size))] = {0};
+	char control[CMSG_SPACE(sizeof(cfg_gso_size)) +
+		     CMSG_SPACE(sizeof(cfg_tos)) +
+		     CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
+	size_t msg_controllen;
+	struct cmsghdr *cmsg;
 	int ret;
 
 	iov.iov_base = data;
@@ -227,8 +425,22 @@ static int send_udp_segment(int fd, char *data)
 
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
 
+	if (cfg_tos) {
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+		send_tos_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_tos));
+	}
+
+	msg.msg_controllen = msg_controllen;
 	msg.msg_name = (void *)&cfg_dst_addr;
 	msg.msg_namelen = cfg_alen;
 
@@ -236,15 +448,16 @@ static int send_udp_segment(int fd, char *data)
 	if (ret == -1)
 		error(1, errno, "sendmsg");
 	if (ret != iov.iov_len)
-		error(1, 0, "sendmsg: %u != %lu\n", ret, iov.iov_len);
+		error(1, 0, "sendmsg: %u != %lu", ret, iov.iov_len);
 
 	return 1;
 }
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46cmtuz] [-C cpu] [-D dst ip] [-l secs] [-m messagenr] [-p port] [-s sendsize] [-S gsosize]",
-		    filepath);
+	error(1, 0,
+	      "Usage: %s [-46cmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-q tos] [-s sendsize] [-S gsosize]",
+	      filepath);
 }
 
 static void parse_opts(int argc, char **argv)
@@ -252,7 +465,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46cC:D:l:mM:p:s:S:tuz")) != -1) {
+	while ((c = getopt(argc, argv, "46cC:D:Hl:mM:p:s:q:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -287,19 +500,35 @@ static void parse_opts(int argc, char **argv)
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
 			break;
+		case 'P':
+			cfg_poll = true;
+			break;
 		case 's':
 			cfg_payload_len = strtoul(optarg, NULL, 0);
 			break;
+		case 'q':
+			cfg_tos = strtoul(optarg, NULL, 0);
+			break;
 		case 'S':
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
@@ -315,6 +544,12 @@ static void parse_opts(int argc, char **argv)
 		error(1, 0, "connectionless tcp makes no sense");
 	if (cfg_segment && cfg_sendmmsg)
 		error(1, 0, "cannot combine segment offload and sendmmsg");
+	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg))
+		error(1, 0, "Options -T and -H require either -S or -m option");
+	if (cfg_tos && !(cfg_segment || cfg_sendmmsg))
+		error(1, 0, "Option -q requires either -S or -m option");
+	if (cfg_poll && !(cfg_segment || cfg_sendmmsg))
+		error(1, 0, "Poll option -P requires either -S or -m option");
 
 	if (cfg_family == PF_INET)
 		hdrlen = sizeof(struct iphdr) + sizeof(struct udphdr);
@@ -349,6 +584,19 @@ static void set_pmtu_discover(int fd, bool is_ipv4)
 		error(1, errno, "setsockopt path mtu");
 }
 
+static void set_tx_timestamping(int fd)
+{
+	int val = SOF_TIMESTAMPING_OPT_CMSG | SOF_TIMESTAMPING_OPT_ID;
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
 int main(int argc, char **argv)
 {
 	unsigned long num_msgs, num_sends;
@@ -384,7 +632,11 @@ int main(int argc, char **argv)
 	if (cfg_segment)
 		set_pmtu_discover(fd, cfg_family == PF_INET);
 
-	num_msgs = num_sends = 0;
+	if (cfg_tx_tstamp)
+		set_tx_timestamping(fd);
+
+	num_msgs = 0;
+	num_sends = 0;
 	tnow = gettimeofday_ms();
 	tstop = tnow + cfg_runtime_ms;
 	treport = tnow + 1000;
@@ -400,8 +652,8 @@ int main(int argc, char **argv)
 		else
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
-		if (cfg_zerocopy && ((num_msgs & 0xF) == 0))
-			flush_zerocopy(fd);
+		if ((cfg_zerocopy && (num_msgs & 0xF) == 0) || cfg_tx_tstamp)
+			flush_errqueue(fd);
 
 		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
 			break;
@@ -413,7 +665,8 @@ int main(int argc, char **argv)
 				cfg_tcp ? "tcp" : "udp",
 				(num_msgs * cfg_payload_len) >> 20,
 				num_sends, num_msgs);
-			num_msgs = num_sends = 0;
+			num_msgs = 0;
+			num_sends = 0;
 			treport = tnow + 1000;
 		}
 
@@ -423,6 +676,9 @@ int main(int argc, char **argv)
 
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
+	if (cfg_zerocopy || cfg_tx_tstamp)
+		flush_errqueue(fd);
+
 	if (close(fd))
 		error(1, errno, "close");
 
-- 
2.11.0

