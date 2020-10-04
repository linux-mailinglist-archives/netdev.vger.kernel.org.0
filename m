Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1F282D61
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgJDTuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:15 -0400
Received: from correo.us.es ([193.147.175.20]:34954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgJDTuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21F69EF43A
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08767DA73F
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F253FDA722; Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFEC4DA789;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B861E42EF9E2;
        Sun,  4 Oct 2020 21:50:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 04/11] netfilter: nf_tables: fix userdata memleak
Date:   Sun,  4 Oct 2020 21:49:33 +0200
Message-Id: <20201004194940.7368-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

When userdata was introduced for tables and objects its allocation was
only freed inside the error path of the new{table, object} functions.

Free user data inside corresponding destroy functions for tables and
objects.

Fixes: b131c96496b3 ("netfilter: nf_tables: add userdata support for nft_object")
Fixes: 7a81575b806e ("netfilter: nf_tables: add userdata attributes to nft_table")
Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 84c0c1aaae99..b3c3c3fc1969 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1211,6 +1211,7 @@ static void nf_tables_table_destroy(struct nft_ctx *ctx)
 
 	rhltable_destroy(&ctx->table->chains_ht);
 	kfree(ctx->table->name);
+	kfree(ctx->table->udata);
 	kfree(ctx->table);
 }
 
@@ -6231,6 +6232,7 @@ static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 
 	module_put(obj->ops->type->owner);
 	kfree(obj->key.name);
+	kfree(obj->udata);
 	kfree(obj);
 }
 
-- 
2.20.1

