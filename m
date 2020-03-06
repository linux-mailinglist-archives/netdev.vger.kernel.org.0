Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168E617C526
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCFSPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:15:24 -0500
Received: from correo.us.es ([193.147.175.20]:40758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgCFSPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:15:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E56E815AEA5
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF3A2DA72F
        for <netdev@vger.kernel.org>; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4A5EDA7B2; Fri,  6 Mar 2020 19:15:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3F01DA72F;
        Fri,  6 Mar 2020 19:15:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Mar 2020 19:15:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C6AD34301DE0;
        Fri,  6 Mar 2020 19:15:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/11] netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
Date:   Fri,  6 Mar 2020 19:15:11 +0100
Message-Id: <20200306181513.656594-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200306181513.656594-1-pablo@netfilter.org>
References: <20200306181513.656594-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Missing NFTA_CHAIN_FLAGS netlink attribute when dumping basechain
definitions.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bb064aa4154b..f9e60981bd36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1405,6 +1405,11 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 					      lockdep_commit_lock_is_held(net));
 		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
+
+		if ((chain->flags & NFT_CHAIN_HW_OFFLOAD) &&
+		    nla_put_be32(skb, NFTA_CHAIN_FLAGS,
+				 htonl(NFT_CHAIN_HW_OFFLOAD)))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
-- 
2.11.0

