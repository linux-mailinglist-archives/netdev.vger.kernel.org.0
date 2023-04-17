Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B13D6E4802
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjDQMko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjDQMkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:40:31 -0400
Received: from ubuntu20 (unknown [193.203.214.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1C65584;
        Mon, 17 Apr 2023 05:40:29 -0700 (PDT)
Received: by ubuntu20 (Postfix, from userid 1003)
        id 46D24E1A71; Mon, 17 Apr 2023 12:24:30 +0000 (UTC)
From:   Yang Yang <yang.yang29@zte.com.cn>
To:     davem@davemloft.net, edumazet@google.com,
        willemdebruijn.kernel@gmail.com
Cc:     yang.yang29@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Subject: [PATCH linux-next 2/3] selftests: net: udpgso_bench_rx: Fix gsosize exceptions
Date:   Mon, 17 Apr 2023 20:24:28 +0800
Message-Id: <20230417122428.193297-1-yang.yang29@zte.com.cn>
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

The -S parameter of the receiving terminal will most likely cause the
following error.

Executing the following command fails:
bash# udpgso_bench_tx -l 4 -4 -D "$DST"
bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
bash# udpgso_bench_rx -4 -G -S 1472
udp rx:     15 MB/s      256 calls/s
udp rx:     30 MB/s      512 calls/s
udpgso_bench_rx: recv: bad gso size, got -1, expected 1472
(-1 == no gso cmsg))

The actual message on the receiving end is as follows:
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 7360
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 1472
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 1472
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 4416
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 11776
 IP 192.168.2.199.55238 > 192.168.2.203.8000: UDP, length 20608
recv: got one message len:1472, probably not an error.
recv: got one message len:1472, probably not an error.

This is due to network, NAPI, timer, etc., only one message being received.
We believe that this situation should be normal. We add judgment to filter
out packets that are less than gso_size and do not contain CMSG
information.

Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index a5b7f30659a5..784e88b31f7d 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -282,7 +282,9 @@ static void do_flush_udp(int fd)
 		if (cfg_expected_pkt_len && ret != cfg_expected_pkt_len)
 			error(1, 0, "recv: bad packet len, got %d,"
 			      " expected %d\n", ret, cfg_expected_pkt_len);
-		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
+		/* For some network reasons, ret less than gso_size is not an error */
+		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size &&
+				ret > cfg_expected_gso_size)
 			error(1, 0, "recv: bad gso size, got %d, expected %d %s",
 				gso_size, cfg_expected_gso_size, "(-1 == no gso cmsg))\n");
 		if (len && cfg_verify) {
-- 
2.15.2
