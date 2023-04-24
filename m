Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886C16EC5C4
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 07:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjDXF5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 01:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjDXF5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 01:57:10 -0400
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC49B3599;
        Sun, 23 Apr 2023 22:56:35 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4Q4ZB038G5z4y3PL;
        Mon, 24 Apr 2023 13:55:52 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl1.zte.com.cn with SMTP id 33O5tib1097567;
        Mon, 24 Apr 2023 13:55:44 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Mon, 24 Apr 2023 13:55:46 +0800 (CST)
Date:   Mon, 24 Apr 2023 13:55:46 +0800 (CST)
X-Zmail-TransId: 2b03644619e25da-ae8a1
X-Mailer: Zmail v1.0
Message-ID: <202304241355464262541@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>
Cc:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.yunkai@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjNdIHNlbGZ0ZXN0czogbmV0OiB1ZHBnc29fYmVuY2hfcng6IEZpeCB2ZXJpZnR5IGV4Y2VwdGlvbnM=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 33O5tib1097567
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 644619E8.002/4Q4ZB038G5z4y3PL
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
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

The issue is that the test on receive for expected payload pattern 
{AB..Z}+ fail for GRO packets if segment payload does not end on a Z.

The issue still exists when using the GRO with -G, but not using the -S
to obtain gsosize. Therefore, a print has been added to remind users.

Changes in v3:
- Simplify description and adjust judgment order.

Changes in v2:
- Fix confusing descriptions.

Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: Xu Xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 34 +++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index f35a924d4a30..3ad18cbc570d 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -189,26 +189,45 @@ static char sanitized_char(char val)
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
+				error(0, 0, "Use -S to obtain gsosize to guide "
+					"splitting and verification.");
+
 			error(1, 0, "data[%d]: len %d, %c(%hhu) != %c(%hhu)\n",
 			      i, len,
 			      sanitized_char(data[i]), data[i],
 			      sanitized_char(cur), cur);
+		}
+	}
+}
+
+static void do_verify_udp_gro(const char *data, int len, int segment_size)
+{
+	int start = 0;
+
+	while (len - start > 0) {
+		if (len - start > segment_size)
+			do_verify_udp(data, start, segment_size);
+		else
+			do_verify_udp(data, start, len - start);
+
+		start += segment_size;
 	}
 }

@@ -268,7 +287,12 @@ static void do_flush_udp(int fd)
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
 		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
 			error(1, 0, "recv: bad gso size, got %d, expected %d "
-- 
2.15.2
