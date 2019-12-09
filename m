Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6E1175B4
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfLIT07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:26:59 -0500
Received: from correo.us.es ([193.147.175.20]:58512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbfLIT06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B725B12083D
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB70DDA711
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A0B4DDA70F; Mon,  9 Dec 2019 20:26:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2CF6DA70C;
        Mon,  9 Dec 2019 20:26:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 688F04265A5A;
        Mon,  9 Dec 2019 20:26:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/17] netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions
Date:   Mon,  9 Dec 2019 20:26:36 +0100
Message-Id: <20191209192638.71184-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the rule only specifies the matching side, return EOPNOTSUPP.
Otherwise, the front-end relies on the drivers to reject this rule.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index d7a35da008ef..22fb18906ccf 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -44,6 +44,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 		expr = nft_expr_next(expr);
 	}
 
+	if (num_actions == 0)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	flow = nft_flow_rule_alloc(num_actions);
 	if (!flow)
 		return ERR_PTR(-ENOMEM);
-- 
2.11.0

