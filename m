Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76826E47FE
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjDQMkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjDQMkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:40:31 -0400
Received: from ubuntu20 (unknown [193.203.214.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0AB5267;
        Mon, 17 Apr 2023 05:40:29 -0700 (PDT)
Received: by ubuntu20 (Postfix, from userid 1003)
        id 21913E1A83; Mon, 17 Apr 2023 12:25:05 +0000 (UTC)
From:   Yang Yang <yang.yang29@zte.com.cn>
To:     davem@davemloft.net, edumazet@google.com,
        willemdebruijn.kernel@gmail.com
Cc:     yang.yang29@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Subject: [PATCH linux-next 3/3] selftests: net: udpgso_bench_rx: Fix packet number exceptions
Date:   Mon, 17 Apr 2023 20:25:04 +0800
Message-Id: <20230417122504.193350-1-yang.yang29@zte.com.cn>
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

The -n parameter is confusing and seems to only affect the frequency of
determining whether the time reaches 1s. However, the final print of the
program is the number of messages expected to be received, which is always
0.

bash# udpgso_bench_rx -4 -n 100
bash# udpgso_bench_tx -l 1 -4 -D "$DST"
udpgso_bench_rx: wrong packet number! got 0, expected 100

This is because the packets are always cleared after print.

Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 784e88b31f7d..b66bb53af19f 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -50,7 +50,7 @@ static int  cfg_rcv_timeout_ms;
 static struct sockaddr_storage cfg_bind_addr;
 
 static bool interrupted;
-static unsigned long packets, bytes;
+static unsigned long packets, total_packets, bytes;
 
 static void sigint_handler(int signum)
 {
@@ -405,6 +405,7 @@ static void do_recv(void)
 					"%s rx: %6lu MB/s %8lu calls/s\n",
 					cfg_tcp ? "tcp" : "udp",
 					bytes >> 20, packets);
+			total_packets += packets;
 			bytes = packets = 0;
 			treport = tnow + 1000;
 		}
@@ -415,7 +416,7 @@ static void do_recv(void)
 
 	if (cfg_expected_pkt_nr && (packets != cfg_expected_pkt_nr))
 		error(1, 0, "wrong packet number! got %ld, expected %d\n",
-		      packets, cfg_expected_pkt_nr);
+		      total_packets + packets, cfg_expected_pkt_nr);
 
 	if (close(fd))
 		error(1, errno, "close");
-- 
2.15.2
