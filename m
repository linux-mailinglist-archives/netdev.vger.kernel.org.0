Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4531017B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 01:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhBEASW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 19:18:22 -0500
Received: from correo.us.es ([193.147.175.20]:40702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhBEASR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 19:18:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A03642A4704
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89971DA78E
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 01:17:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7EC53DA78A; Fri,  5 Feb 2021 01:17:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 405A7DA73D;
        Fri,  5 Feb 2021 01:17:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Feb 2021 01:17:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0EB8D42EF9E1;
        Fri,  5 Feb 2021 01:17:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: flowtable: fix tcp and udp header checksum update
Date:   Fri,  5 Feb 2021 01:17:27 +0100
Message-Id: <20210205001727.2125-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205001727.2125-1-pablo@netfilter.org>
References: <20210205001727.2125-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

When updating the tcp or udp header checksum on port nat the function
inet_proto_csum_replace2 with the last parameter pseudohdr as true.
This leads to an error in the case that GRO is used and packets are
split up in GSO. The tcp or udp checksum of all packets is incorrect.

The error is probably masked due to the fact the most network driver
implement tcp/udp checksum offloading. It also only happens when GRO is
applied and not on single packets.

The error is most visible when using a pppoe connection which is not
triggering the tcp/udp checksum offload.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 513f78db3cb2..4a4acbba78ff 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -399,7 +399,7 @@ static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 		return -1;
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
-	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, true);
+	inet_proto_csum_replace2(&tcph->check, skb, port, new_port, false);
 
 	return 0;
 }
@@ -415,7 +415,7 @@ static int nf_flow_nat_port_udp(struct sk_buff *skb, unsigned int thoff,
 	udph = (void *)(skb_network_header(skb) + thoff);
 	if (udph->check || skb->ip_summed == CHECKSUM_PARTIAL) {
 		inet_proto_csum_replace2(&udph->check, skb, port,
-					 new_port, true);
+					 new_port, false);
 		if (!udph->check)
 			udph->check = CSUM_MANGLED_0;
 	}
-- 
2.20.1

