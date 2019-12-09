Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1241170EA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLIPzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:55:42 -0500
Received: from correo.us.es ([193.147.175.20]:47576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfLIPzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 10:55:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 81570C04FD
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 16:55:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 728D2DA70F
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 16:55:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67D8FDA70B; Mon,  9 Dec 2019 16:55:38 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36755DA709;
        Mon,  9 Dec 2019 16:55:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 16:55:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E76544265A5A;
        Mon,  9 Dec 2019 16:55:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        geert@linux-m68k.org, jiri@mellanox.com
Subject: [PATCH net] net: flow_dissector: fix tcp flags dissection on big-endian
Date:   Mon,  9 Dec 2019 16:55:30 +0100
Message-Id: <20191209155530.3050-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    net/netfilter/nf_flow_table_offload.c: In function 'nf_flow_rule_match':
    net/netfilter/nf_flow_table_offload.c:80:21: warning: unsigned conversion from 'int' to '__be16' {aka 'short unsigned int'} changes value from '327680' to '0' [-Woverflow]
       80 |   mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
          |                     ^~~~~~~~~~~~

Fixes: ac4bb5de2701 ("net: flow_dissector: add support for dissection of tcp flags")
Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Geert: I have removed the pad field and included the nitpick fix on the
        comment, given I have slightly updated this patch, I would prefer
        if you can provide a fresh Reviewed-by tag. Thanks.

 include/net/flow_dissector.h          | 8 ++++++--
 net/core/flow_dissector.c             | 2 +-
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index b8c20e9f343e..9ff8dac9d5ec 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -189,10 +189,14 @@ struct flow_dissector_key_eth_addrs {
 
 /**
  * struct flow_dissector_key_tcp:
- * @flags: flags
+ * @flags: TCP flags, including the initial Data offset field bits (16-bits)
+ * @flag_word: Data offset + reserved bits + TCP flags + window (32-bits)
  */
 struct flow_dissector_key_tcp {
-	__be16 flags;
+	union {
+		__be16 flags;
+		__be32 flag_word;
+	};
 };
 
 /**
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ca871657a4c4..83af4633f306 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -756,7 +756,7 @@ __skb_flow_dissect_tcp(const struct sk_buff *skb,
 	key_tcp = skb_flow_dissector_target(flow_dissector,
 					    FLOW_DISSECTOR_KEY_TCP,
 					    target_container);
-	key_tcp->flags = (*(__be16 *) &tcp_flag_word(th) & htons(0x0FFF));
+	key_tcp->flag_word = tcp_flag_word(th);
 }
 
 static void
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c94ebad78c5c..30205d57226d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -87,8 +87,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 
 	switch (tuple->l4proto) {
 	case IPPROTO_TCP:
-		key->tcp.flags = 0;
-		mask->tcp.flags = TCP_FLAG_RST | TCP_FLAG_FIN;
+		key->tcp.flag_word = 0;
+		mask->tcp.flag_word = TCP_FLAG_RST | TCP_FLAG_FIN;
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
-- 
2.11.0

