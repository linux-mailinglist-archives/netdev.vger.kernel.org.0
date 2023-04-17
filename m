Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69486E4803
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjDQMkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjDQMkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:40:31 -0400
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Apr 2023 05:40:30 PDT
Received: from ubuntu20 (unknown [193.203.214.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC48E59EB;
        Mon, 17 Apr 2023 05:40:29 -0700 (PDT)
Received: by ubuntu20 (Postfix, from userid 1003)
        id BBF41E0C2F; Mon, 17 Apr 2023 12:24:25 +0000 (UTC)
From:   Yang Yang <yang.yang29@zte.com.cn>
To:     davem@davemloft.net, edumazet@google.com,
        willemdebruijn.kernel@gmail.com
Cc:     yang.yang29@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Subject: [PATCH linux-next 1/3] selftests: net: udpgso_bench_rx: Fix verifty exceptions
Date:   Mon, 17 Apr 2023 20:24:23 +0800
Message-Id: <20230417122423.193237-1-yang.yang29@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <202304172017351308785@zte.com.cn>
References: <202304172017351308785@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_NON_FQDN_1,
        HEADER_FROM_DIFFERENT_DOMAINS,HELO_NO_DOMAIN,NO_DNS_FOR_FROM,
        RCVD_IN_PBL,RDNS_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL_NO_RDNS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>

The verification function of this test case is likely to encounter the
following error, which may confuse users.

Executing the following command fails:
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
bash# udpgso_bench_rx -4 -G -S 1472 -v
udpgso_bench_rx: data[1472]: len 2944, a(97) != q(113)

This is because the sending buffers are not aligned by 26 bytes, and the
GRO is not merged sequentially, and the receiver does not judge this
situation. We do the validation after the data is split at the receiving
end, just as the application actually uses this feature.

Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 38 +++++++++++++++++++++------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index f35a924d4a30..a5b7f30659a5 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -189,16 +189,16 @@ static char sanitized_char(char val)
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
@@ -212,6 +212,24 @@ static void do_verify_udp(const char *data, int len)
 	}
 }
 
+static void do_verify_udp_gro(const char *data, int len, int gso_size)
+{
+	int remaining = len;
+	int start = 0;
+
+	while (remaining) {
+		if (remaining < 0)
+			break;
+
+		if (remaining > gso_size)
+			do_verify_udp(data, start, gso_size);
+		else
+			do_verify_udp(data, start, remaining);
+		start += gso_size;
+		remaining -= gso_size;
+	}
+}
+
 static int recv_msg(int fd, char *buf, int len, int *gso_size)
 {
 	char control[CMSG_SPACE(sizeof(int))] = {0};
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
