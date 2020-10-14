Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7608528E75F
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390401AbgJNTfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 15:35:19 -0400
Received: from correo.us.es ([193.147.175.20]:33768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbgJNTfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 15:35:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C2886D4F9
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 21:35:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D17FDA78E
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 21:35:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 428C9DA789; Wed, 14 Oct 2020 21:35:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDE9ADA78A;
        Wed, 14 Oct 2020 21:35:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 21:35:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C11C84301DE0;
        Wed, 14 Oct 2020 21:35:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next] netfilter: restore NF_INET_NUMHOOKS
Date:   Wed, 14 Oct 2020 21:34:32 +0200
Message-Id: <20201014193432.3446-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This definition is used by the iptables legacy UAPI, restore it.

Fixes: d3519cb89f6d ("netfilter: nf_tables: add inet ingress support")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Jakub: if you please can take this into net-next, it is fixing fallout
        from the inet ingress support. Thank you.

 include/net/netfilter/nf_tables.h | 4 +++-
 include/uapi/linux/netfilter.h    | 4 ++--
 net/netfilter/nf_tables_api.c     | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3965ce18226f..3f7e56b1171e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -14,6 +14,8 @@
 #include <net/netlink.h>
 #include <net/flow_offload.h>
 
+#define NFT_MAX_HOOKS	(NF_INET_INGRESS + 1)
+
 struct module;
 
 #define NFT_JUMP_STACK_SIZE	16
@@ -979,7 +981,7 @@ struct nft_chain_type {
 	int				family;
 	struct module			*owner;
 	unsigned int			hook_mask;
-	nf_hookfn			*hooks[NF_MAX_HOOKS];
+	nf_hookfn			*hooks[NFT_MAX_HOOKS];
 	int				(*ops_register)(struct net *net, const struct nf_hook_ops *ops);
 	void				(*ops_unregister)(struct net *net, const struct nf_hook_ops *ops);
 };
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index 6a6179af0d7c..ef9a44286e23 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -45,8 +45,8 @@ enum nf_inet_hooks {
 	NF_INET_FORWARD,
 	NF_INET_LOCAL_OUT,
 	NF_INET_POST_ROUTING,
-	NF_INET_INGRESS,
-	NF_INET_NUMHOOKS
+	NF_INET_NUMHOOKS,
+	NF_INET_INGRESS = NF_INET_NUMHOOKS,
 };
 
 enum nf_dev_hooks {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f22ad21d0230..7f1c184c00d2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1864,7 +1864,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
+	if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.20.1

