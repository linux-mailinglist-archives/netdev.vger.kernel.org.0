Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EDD30FA4B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhBDRxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:53:38 -0500
Received: from novek.ru ([213.148.174.62]:34312 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238763AbhBDRvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:51:46 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 408D2503356;
        Thu,  4 Feb 2021 20:51:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 408D2503356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612461064; bh=nI4XwOTBMvKXCnCLYIKzbedgxZZ+YOPun/c0F4fnnGg=;
        h=From:To:Cc:Subject:Date:From;
        b=BUvZvptVzQWH1ExIu4jqck4grxsj2JHvga0fT5mq747FfEVJ7yf2NDeF4cSe8bmw8
         d6YUXzV+XHetOq4Gmyi527Lbpek7saoHJZgyWGsai3LO3QnHCSAsZZYDrsfPHvUDu7
         2QsuxCSoGtgsYGYsXWWJCEINEo1mmCuSQ9msDgD8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net v4] selftests: txtimestamp: fix compilation issue
Date:   Thu,  4 Feb 2021 20:50:34 +0300
Message-Id: <1612461034-24524-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
test. Include it instead of <netpacket/packet.h> otherwise the error of
redefinition arrives.
Also fix the compiler warning about ambiguous control flow by adding
explicit braces.

Fixes: 8fe2f761cae9 ("net-timestamp: expand documentation")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/txtimestamp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index 490a8cc..fabb1d5 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -26,6 +26,7 @@
 #include <inttypes.h>
 #include <linux/errqueue.h>
 #include <linux/if_ether.h>
+#include <linux/if_packet.h>
 #include <linux/ipv6.h>
 #include <linux/net_tstamp.h>
 #include <netdb.h>
@@ -34,7 +35,6 @@
 #include <netinet/ip.h>
 #include <netinet/udp.h>
 #include <netinet/tcp.h>
-#include <netpacket/packet.h>
 #include <poll.h>
 #include <stdarg.h>
 #include <stdbool.h>
@@ -495,12 +495,12 @@ static void do_test(int family, unsigned int report_opt)
 	total_len = cfg_payload_len;
 	if (cfg_use_pf_packet || cfg_proto == SOCK_RAW) {
 		total_len += sizeof(struct udphdr);
-		if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW)
+		if (cfg_use_pf_packet || cfg_ipproto == IPPROTO_RAW) {
 			if (family == PF_INET)
 				total_len += sizeof(struct iphdr);
 			else
 				total_len += sizeof(struct ipv6hdr);
-
+		}
 		/* special case, only rawv6_sendmsg:
 		 * pass proto in sin6_port if not connected
 		 * also see ANK comment in net/ipv4/raw.c
-- 
1.8.3.1

