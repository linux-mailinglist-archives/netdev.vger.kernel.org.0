Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4587E28C72
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfEWVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:10 -0400
Received: from mail.us.es ([193.147.175.20]:46954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388318AbfEWVgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:36:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE1C4C1A7D
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDB8EDA70D
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B37E3DA70B; Thu, 23 May 2019 23:35:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2A30DA705;
        Thu, 23 May 2019 23:35:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8ACDF4265A32;
        Thu, 23 May 2019 23:35:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/11] netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
Date:   Thu, 23 May 2019 23:35:45 +0200
Message-Id: <20190523213547.15523-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can't deal with tcp sequence number rewrite in flow_offload.
While at it, simplify helper check, we only need to know if the extension
is present, we don't need the helper data.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index bde63d9c3c4e..c97c03c3939a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -12,7 +12,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
@@ -67,7 +66,6 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
-	const struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -93,8 +91,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	help = nfct_help(ct);
-	if (help)
+	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
+	    ct->status & IPS_SEQ_ADJUST)
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct))
-- 
2.11.0

