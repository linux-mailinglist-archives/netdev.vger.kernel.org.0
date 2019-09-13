Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42AB1C62
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbfIMLbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:18 -0400
Received: from correo.us.es ([193.147.175.20]:42518 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387431AbfIMLbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4647F4FFE20
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3109EA7DCD
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24496A7DBD; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E937A7E23;
        Fri, 13 Sep 2019 13:31:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 46B3242EE396;
        Fri, 13 Sep 2019 13:31:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/27] netfilter: nf_tables: Fix an Oops in nf_tables_updobj() error handling
Date:   Fri, 13 Sep 2019 13:30:36 +0200
Message-Id: <20190913113102.15776-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The "newobj" is an error pointer so we can't pass it to kfree().  It
doesn't need to be freed so we can remove that and I also renamed the
error label.

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 013d28899cab..7def31ae3022 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5151,7 +5151,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
 		err = PTR_ERR(newobj);
-		goto err1;
+		goto err_free_trans;
 	}
 
 	nft_trans_obj(trans) = obj;
@@ -5160,9 +5160,9 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
-err1:
+
+err_free_trans:
 	kfree(trans);
-	kfree(newobj);
 	return err;
 }
 
-- 
2.11.0

