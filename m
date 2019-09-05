Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88F5AA7ED
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390835AbfIEQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:19 -0400
Received: from correo.us.es ([193.147.175.20]:53058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390809AbfIEQEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A16C1228C3
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BA3CFF6DE
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51954FF2C8; Thu,  5 Sep 2019 18:04:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4797EB7FF6;
        Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1265642EE38E;
        Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/8] netfilter: nf_tables: fix possible null-pointer dereference in object update
Date:   Thu,  5 Sep 2019 18:04:00 +0200
Message-Id: <20190905160400.25399-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Not all objects have an update operation. If the object type doesn't
implement an update operation and the user tries to update it will hit
EOPNOTSUPP.

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf767bc58e18..013d28899cab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5140,6 +5140,9 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
+	if (!obj->ops->update)
+		return -EOPNOTSUPP;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
-- 
2.11.0

