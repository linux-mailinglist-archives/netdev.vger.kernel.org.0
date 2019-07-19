Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677736E98E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfGSQqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:46:33 -0400
Received: from mail.us.es ([193.147.175.20]:50236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbfGSQqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:46:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 515BFBAEE3
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:46:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44605202B8
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:46:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3A2F1D190F; Fri, 19 Jul 2019 18:46:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 432701150B9;
        Fri, 19 Jul 2019 18:46:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:46:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A383E4265A2F;
        Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/14] netfilter: nft_meta: skip EAGAIN if nft_meta_bridge is not a module
Date:   Fri, 19 Jul 2019 18:46:16 +0200
Message-Id: <20190719164618.29581-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164618.29581-1-pablo@netfilter.org>
References: <20190719164618.29581-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If it is a module, request this module. Otherwise, if it is compiled
built-in or not selected, skip this.

Fixes: 0ef1efd1354d ("netfilter: nf_tables: force module load in case select_ops() returns -EAGAIN")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 76866f77e343..865888933a83 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -546,7 +546,7 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
 		return ERR_PTR(-EINVAL);
 
-#ifdef CONFIG_NF_TABLES_BRIDGE
+#if defined(CONFIG_NF_TABLES_BRIDGE) && IS_MODULE(CONFIG_NFT_BRIDGE_META)
 	if (ctx->family == NFPROTO_BRIDGE)
 		return ERR_PTR(-EAGAIN);
 #endif
-- 
2.11.0


