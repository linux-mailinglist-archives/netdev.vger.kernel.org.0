Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DB919841D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgC3TWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:08 -0400
Received: from correo.us.es ([193.147.175.20]:48520 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgC3TWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8204B508F
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7B3C12B68F
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:21:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 938E6114D66; Mon, 30 Mar 2020 21:21:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 599AA100A47;
        Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2033542EF4E0;
        Mon, 30 Mar 2020 21:21:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/28] netfilter: nf_tables: fix double-free on set expression from the error path
Date:   Mon, 30 Mar 2020 21:21:12 +0200
Message-Id: <20200330192136.230459-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After copying the expression to the set element extension, release the
expression and reset the pointer to avoid a double-free from the error
path.

Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f1910cd795fd..29ad33e52dbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5133,6 +5133,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (expr) {
 		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
 		kfree(expr);
+		expr = NULL;
 	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
-- 
2.11.0

