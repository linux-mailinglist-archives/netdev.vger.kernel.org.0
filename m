Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FFE5A18
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJZLr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:57 -0400
Received: from correo.us.es ([193.147.175.20]:46422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfJZLr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28AB58C3C6E
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CEB4A7E28
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1152EA7E21; Sat, 26 Oct 2019 13:47:52 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29C96A7E9E;
        Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E0B5D42EE393;
        Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 21/31] netfilter: nf_tables: allow netdevice to be used only once per flowtable
Date:   Sat, 26 Oct 2019 13:47:23 +0200
Message-Id: <20191026114733.28111-22-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow netdevice only once per flowtable, otherwise hit EEXIST.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d6224c7b0e28..2664bc388db4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1538,6 +1538,19 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	return ERR_PTR(err);
 }
 
+static bool nft_hook_list_find(struct list_head *hook_list,
+			       const struct nft_hook *this)
+{
+	struct nft_hook *hook;
+
+	list_for_each_entry(hook, hook_list, list) {
+		if (this->ops.dev == hook->ops.dev)
+			return true;
+	}
+
+	return false;
+}
+
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
 					struct list_head *hook_list)
@@ -1557,6 +1570,10 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
+		if (nft_hook_list_find(hook_list, hook)) {
+			err = -EEXIST;
+			goto err_hook;
+		}
 		list_add_tail(&hook->list, hook_list);
 		n++;
 
-- 
2.11.0

