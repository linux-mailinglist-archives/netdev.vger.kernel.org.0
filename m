Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F730FA0B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhBDRor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:44:47 -0500
Received: from novek.ru ([213.148.174.62]:34216 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238599AbhBDRog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:44:36 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 84E95503356;
        Thu,  4 Feb 2021 20:43:50 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 84E95503356
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612460632; bh=B+A360lxCikUuglRjqMa2pvztYPB1WgFIX9yI1XANvI=;
        h=From:To:Cc:Subject:Date:From;
        b=CUib10pNSIupeqLHWBKzyoOT6YtuKacLVOhiDW8v/atKsfwvn9e2NP0Dn9ICmh65G
         /yoNZQAGTN6ugKxZ5QUZ3KXyixKam0AmLaOo2EvS0KNBmlM4fpH01rMcDSAeZCjut3
         XDf0ub/D2q5gwFFvJrn+l6HGzEiC3l+phcEP0haE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net v3] selftests: txtimestamp: fix compilation issue
Date:   Thu,  4 Feb 2021 20:43:36 +0300
Message-Id: <1612460616-22552-1-git-send-email-vfedorenko@novek.ru>
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
 tools/testing/selftests/net/txtimestamp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index 490a8cc..3d6bf54 100644
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
@@ -53,6 +53,7 @@
 #define NSEC_PER_USEC	1000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000LL
+#define PACKET_TX_TIMESTAMP		16
 
 /* command line parameters */
 static int cfg_proto = SOCK_STREAM;
@@ -495,12 +496,12 @@ static void do_test(int family, unsigned int report_opt)
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

