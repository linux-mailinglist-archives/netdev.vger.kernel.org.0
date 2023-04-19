Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B436E75E2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjDSJAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjDSJAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:00:07 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0C1113;
        Wed, 19 Apr 2023 02:00:02 -0700 (PDT)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Q1ZVm2gSBz8RTWb;
        Wed, 19 Apr 2023 17:00:00 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl2.zte.com.cn with SMTP id 33J8xpBp035307;
        Wed, 19 Apr 2023 16:59:51 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 19 Apr 2023 16:59:54 +0800 (CST)
Date:   Wed, 19 Apr 2023 16:59:54 +0800 (CST)
X-Zmail-TransId: 2b03643fad8affffffffe42-6b32d
X-Mailer: Zmail v1.0
Message-ID: <202304191659543403931@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <edumazet@google.com>
Cc:     <kuba@kernel.org>, <pabeni@redhat.com>, <shuah@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <zhang.yunkai@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjJdIHNlbGZ0ZXN0czogbmV0OiB1ZHBnc29fYmVuY2hfcng6IEZpeCB2ZXJpZnR5IGV4Y2VwdGlvbnM=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 33J8xpBp035307
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 643FAD90.000/4Q1ZVm2gSBz8RTWb
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>

The verification function of this test case is likely to encounter the
following error, which may confuse users. The problem is easily
reproducible in the latest kernel.

Environment A, the sender:
bash# udpgso_bench_tx -l 4 -4 -D "$IP_B"
udpgso_bench_tx: write: Connection refused

Environment B, the receiver:
bash# udpgso_bench_rx -4 -G -S 1472 -v
udpgso_bench_rx: data[1472]: len 17664, a(97) != q(113)

If the packet is captured, you will see:
Environment A, the sender:
bash# tcpdump -i eth0 host "$IP_B" &
IP $IP_A.41025 > $IP_B.8000: UDP, length 1472
IP $IP_A.41025 > $IP_B.8000: UDP, length 1472
IP $IP_B > $IP_A: ICMP $IP_B udp port 8000 unreachable, length 556

Environment B, the receiver:
bash# tcpdump -i eth0 host "$IP_B" &
IP $IP_A.41025 > $IP_B.8000: UDP, length 7360
IP $IP_A.41025 > $IP_B.8000: UDP, length 14720
IP $IP_B > $IP_A: ICMP $IP_B udp port 8000 unreachable, length 556

In one test, the verification data is printed as follows:
abcd...xyz           | 1...
..                  |
abcd...xyz           |
abcd...opabcd...xyz  | ...1472... Not xyzabcd, messages are merged
..                  |

This is because the sending buffer is buf[64K], and its content is a
loop of A-Z. But maybe only 1472 bytes per send, or more if UDP GSO is
used. The message content does not necessarily end with XYZ, but GRO
will merge these packets, and the -v parameter directly verifies the
entire GRO receive buffer. So we do the validation after the data is split
at the receiving end, just as the application actually uses this feature.

If the sender does not use GSO, each individual segment starts at A,
end at somewhere. Using GSO also has the same problem, and. The data
between each segment during transmission is continuous, but GRO is merged
in the order received, which is not necessarily the order of transmission.

Execution in the same environment does not cause problems, because the
lo device is not NAPI, and does not perform GRO processing. Perhaps it
could be worth supporting to reduce system calls.
bash# tcpdump -i lo host "$IP_self" &
bash# echo udp_gro_receive > /sys/kernel/debug/tracing/set_ftrace_filter
bash# echo function > /sys/kernel/debug/tracing/current_tracer
bash# udpgso_bench_rx -4 -G -S 1472 -v &
bash# udpgso_bench_tx -l 4 -4 -D "$IP_self"

The issue still exists when using the GRO with -G, but not using the -S
to obtain gsosize. Therefore, a print has been added to remind users.

After this issue is resolved, another issue will be encountered and will
be resolved in the next patch.
Environment A, the sender:
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
udpgso_bench_tx: write: Connection refused

Environment B, the receiver:
bash# udpgso_bench_rx -4 -G -S 1472
udp rx:     15 MB/s      256 calls/s
udp rx:     30 MB/s      512 calls/s
udpgso_bench_rx: recv: bad gso size, got -1, expected 1472
(-1 == no gso cmsg))

v2:
- Fix confusing descriptions

Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: Xu Xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 40 +++++++++++++++++++++------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index f35a924d4a30..6a2026494cdb 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -189,26 +189,44 @@ static char sanitized_char(char val)
 	return (val >= 'a' && val <= 'z') ? val : '.';
 }

-static void do_verify_udp(const char *data, int len)
+static void do_verify_udp(const char *data, int start, int len)
 {
-	char cur = data[0];
+	char cur = data[start];
 	int i;

 	/* verify contents */
 	if (cur < 'a' || cur > 'z')
 		error(1, 0, "data initial byte out of range");

-	for (i = 1; i < len; i++) {
+	for (i = start + 1; i < start + len; i++) {
 		if (cur == 'z')
 			cur = 'a';
 		else
 			cur++;

-		if (data[i] != cur)
+		if (data[i] != cur) {
+			if (cfg_gro_segment && !cfg_expected_gso_size)
+				error(0, 0, "Use -S to obtain gsosize, to %s"
+					, "help guide split and verification.");
+
 			error(1, 0, "data[%d]: len %d, %c(%hhu) != %c(%hhu)\n",
 			      i, len,
 			      sanitized_char(data[i]), data[i],
 			      sanitized_char(cur), cur);
+		}
+	}
+}
+
+static void do_verify_udp_gro(const char *data, int len, int gso_size)
+{
+	int start = 0;
+
+	while (len - start > 0) {
+		if (len - start > gso_size)
+			do_verify_udp(data, start, gso_size);
+		else
+			do_verify_udp(data, start, len - start);
+		start += gso_size;
 	}
 }

@@ -264,16 +282,20 @@ static void do_flush_udp(int fd)
 		if (cfg_expected_pkt_len && ret != cfg_expected_pkt_len)
 			error(1, 0, "recv: bad packet len, got %d,"
 			      " expected %d\n", ret, cfg_expected_pkt_len);
+		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
+			error(1, 0, "recv: bad gso size, got %d, expected %d %s",
+				gso_size, cfg_expected_gso_size, "(-1 == no gso cmsg))\n");
 		if (len && cfg_verify) {
 			if (ret == 0)
 				error(1, errno, "recv: 0 byte datagram\n");

-			do_verify_udp(rbuf, ret);
+			if (!cfg_gro_segment)
+				do_verify_udp(rbuf, 0, ret);
+			else if (gso_size > 0)
+				do_verify_udp_gro(rbuf, ret, gso_size);
+			else
+				do_verify_udp_gro(rbuf, ret, ret);
 		}
-		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
-			error(1, 0, "recv: bad gso size, got %d, expected %d "
-			      "(-1 == no gso cmsg))\n", gso_size,
-			      cfg_expected_gso_size);

 		packets++;
 		bytes += ret;
-- 
2.15.2
