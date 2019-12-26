Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560E712AD83
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfLZQkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:40:10 -0500
Received: from correo.us.es ([193.147.175.20]:54762 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfLZQkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 11:40:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BDEBE34EA
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C583DA718
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 015A6DA713; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0B61DA703;
        Thu, 26 Dec 2019 17:40:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Dec 2019 17:40:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D07FB4251481;
        Thu, 26 Dec 2019 17:40:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/4] netfilter: nf_flow_table: fix big-endian integer overflow
Date:   Thu, 26 Dec 2019 17:39:53 +0100
Message-Id: <20191226163956.672174-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191226163956.672174-1-pablo@netfilter.org>
References: <20191226163956.672174-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

In some configurations, gcc reports an integer overflow:

net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
net/netfilter/nf_flow_table_offload.c:80:21: error: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Werror=overflow]
   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
                     ^~~~~~~~~~~~

From what I can tell, we want the upper 16 bits of these constants,
so they need to be shifted in cpu-endian mode.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index de7a0d1e15c8..0d72e5ccb47b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -88,7 +88,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	switch (tuple->l4proto) {
 	case IPPROTO_TCP:
 		key->tcp.flags = 0;
-		mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
+		mask->tcp.flags = cpu_to_be16(be32_to_cpu(TCP_FLAG_RST | TCP_FLAG_FIN) >> 16);
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
-- 
2.11.0

