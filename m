Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67776A800A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjCBKir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBKip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:38:45 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDC110AA4;
        Thu,  2 Mar 2023 02:38:42 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4PS6yn1MxLz501Ql;
        Thu,  2 Mar 2023 18:38:41 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl1.zte.com.cn with SMTP id 322AcWuY047569;
        Thu, 2 Mar 2023 18:38:32 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 2 Mar 2023 18:38:35 +0800 (CST)
Date:   Thu, 2 Mar 2023 18:38:35 +0800 (CST)
X-Zmail-TransId: 2b0364007cab2e9c168d
X-Mailer: Zmail v1.0
Message-ID: <202303021838359696196@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <davem@davemloft.net>
Cc:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.yunkai@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <jiang.xuexin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjJdIHNlbGZ0ZXN0czogbmV0OiB1ZHBnc29fYmVuY2hfdHg6IEFkZCB0ZXN0IGZvciBJUCBmcmFnbWVudGF0aW9uIG9mIFVEUCBwYWNrZXRz?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 322AcWuY047569
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 64007CB1.000/4PS6yn1MxLz501Ql
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>

The UDP GSO bench only tests the performance of userspace payload splitting
and UDP GSO. But we are also concerned about the performance comparing with
IP fragmentation and UDP GSO. In other words comparing IP fragmentation and
segmentation.

So we add testcase of IP fragmentation of UDP packets, then user would easy
to get to know the performance promotion of UDP GSO compared with IP
fragmentation. We add a new option "-f", which is to send big data using
IP fragmentation instead of using UDP GSO or userspace payload splitting.

In the QEMU environment we could see obvious promotion of UDP GSO.
The first test is to get the performance of userspace payload splitting.
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
udp tx:     21 MB/s    15162 calls/s    361 msg/s
udp tx:     21 MB/s    15498 calls/s    369 msg/s
udp tx:     18 MB/s    13440 calls/s    320 msg/s
udp tx:     19 MB/s    13776 calls/s    328 msg/s

The second test is to get the performance of IP fragmentation.
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -f
udp tx:     41 MB/s      711 calls/s    711 msg/s
udp tx:     41 MB/s      700 calls/s    700 msg/s
udp tx:     43 MB/s      738 calls/s    738 msg/s
udp tx:     40 MB/s      693 calls/s    693 msg/s

The third test is to get the performance of UDP GSO.
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
udp tx:     45 MB/s      775 calls/s    775 msg/s
udp tx:     47 MB/s      800 calls/s    800 msg/s
udp tx:     47 MB/s      814 calls/s    814 msg/s
udp tx:     47 MB/s      812 calls/s    812 msg/s

v2: Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
- Use IP_PMTUDISC_OMIT to disable PMTU discovery and to avoid send
  returning with error after ICMP destination unreachable messages if MTU
  is exceeded in the path.

Signed-off-by: zhang yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 49 ++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 477392715a9a..b3333b39bb87 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -64,6 +64,7 @@ static int	cfg_runtime_ms	= -1;
 static bool	cfg_poll;
 static int	cfg_poll_loop_timeout_ms = 2000;
 static bool	cfg_segment;
+static bool	cfg_fragment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
 static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
@@ -375,6 +376,21 @@ static int send_udp_sendmmsg(int fd, char *data)
 	return ret;
 }

+static int send_udp_fragment(int fd, char *data)
+{
+	int ret;
+
+	ret = sendto(fd, data, cfg_payload_len, cfg_zerocopy ? MSG_ZEROCOPY : 0,
+			cfg_connected ? NULL : (void *)&cfg_dst_addr,
+			cfg_connected ? 0 : cfg_alen);
+	if (ret == -1)
+		error(1, errno, "write");
+	if (ret != cfg_payload_len)
+		error(1, errno, "write: %uB != %uB\n", ret, cfg_payload_len);
+
+	return 1;
+}
+
 static void send_udp_segment_cmsg(struct cmsghdr *cm)
 {
 	uint16_t *valp;
@@ -429,7 +445,7 @@ static int send_udp_segment(int fd, char *data)

 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
+	error(1, 0, "Usage: %s [-46acfmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
 		    "[-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
 		    filepath);
 }
@@ -440,7 +456,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;

-	while ((c = getopt(argc, argv, "46acC:D:Hl:L:mM:p:s:PS:tTuvz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:D:fHl:L:mM:p:s:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -469,6 +485,9 @@ static void parse_opts(int argc, char **argv)
 		case 'l':
 			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
 			break;
+		case 'f':
+			cfg_fragment = true;
+			break;
 		case 'L':
 			cfg_poll_loop_timeout_ms = strtoul(optarg, NULL, 10) * 1000;
 			break;
@@ -527,10 +546,10 @@ static void parse_opts(int argc, char **argv)
 		error(1, 0, "must pass one of -4 or -6");
 	if (cfg_tcp && !cfg_connected)
 		error(1, 0, "connectionless tcp makes no sense");
-	if (cfg_segment && cfg_sendmmsg)
-		error(1, 0, "cannot combine segment offload and sendmmsg");
-	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg))
-		error(1, 0, "Options -T and -H require either -S or -m option");
+	if ((cfg_segment + cfg_sendmmsg + cfg_fragment) > 1)
+		error(1, 0, "cannot combine segment offload, fragment and sendmmsg");
+	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg || cfg_fragment))
+		error(1, 0, "Options -T and -H require either -S or -m or -f option");

 	if (cfg_family == PF_INET)
 		hdrlen = sizeof(struct iphdr) + sizeof(struct udphdr);
@@ -551,14 +570,24 @@ static void set_pmtu_discover(int fd, bool is_ipv4)
 {
 	int level, name, val;

+	/* IP fragmentation test uses IP_PMTUDISC_OMIT to disable PMTU discovery and
+	 * to avoid send returning with error after ICMP destination unreachable
+	 * messages if MTU is exceeded in the path.
+	 */
 	if (is_ipv4) {
 		level	= SOL_IP;
 		name	= IP_MTU_DISCOVER;
-		val	= IP_PMTUDISC_DO;
+		if (cfg_segment)
+			val	= IP_PMTUDISC_DO;
+		else if (cfg_fragment)
+			val	= IP_PMTUDISC_OMIT;
 	} else {
 		level	= SOL_IPV6;
 		name	= IPV6_MTU_DISCOVER;
-		val	= IPV6_PMTUDISC_DO;
+		if (cfg_segment)
+			val	= IPV6_PMTUDISC_DO;
+		else if (cfg_fragment)
+			val	= IPV6_PMTUDISC_OMIT;
 	}

 	if (setsockopt(fd, level, name, &val, sizeof(val)))
@@ -674,7 +703,7 @@ int main(int argc, char **argv)
 	    connect(fd, (void *)&cfg_dst_addr, cfg_alen))
 		error(1, errno, "connect");

-	if (cfg_segment)
+	if (cfg_segment || cfg_fragment)
 		set_pmtu_discover(fd, cfg_family == PF_INET);

 	if (cfg_tx_tstamp)
@@ -695,6 +724,8 @@ int main(int argc, char **argv)
 			num_sends += send_udp_segment(fd, buf[i]);
 		else if (cfg_sendmmsg)
 			num_sends += send_udp_sendmmsg(fd, buf[i]);
+		else if (cfg_fragment)
+			num_sends += send_udp_fragment(fd, buf[i]);
 		else
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
-- 
2.15.2
