Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F064100E47
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfKRVtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:39 -0500
Received: from correo.us.es ([193.147.175.20]:45750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfKRVtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9299FEBAF4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85E12DA72F
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D748CE15C; Mon, 18 Nov 2019 22:49:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39E64A7EC1;
        Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 033BC42EE38F;
        Mon, 18 Nov 2019 22:49:30 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/18] netfilter: nf_tables: check if bind callback fails and unbind if hook registration fails
Date:   Mon, 18 Nov 2019 22:49:13 +0100
Message-Id: <20191118214914.142794-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Undo the callback binding before unregistering the existing hooks. This
should also check for error of the bind setup call.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4f0d880a8496..9340b976d85c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6006,12 +6006,20 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_BIND);
-		err = nf_register_net_hook(net, &hook->ops);
+		err = flowtable->data.type->setup(&flowtable->data,
+						  hook->ops.dev,
+						  FLOW_BLOCK_BIND);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
+		err = nf_register_net_hook(net, &hook->ops);
+		if (err < 0) {
+			flowtable->data.type->setup(&flowtable->data,
+						    hook->ops.dev,
+						    FLOW_BLOCK_UNBIND);
+			goto err_unregister_net_hooks;
+		}
+
 		i++;
 	}
 
-- 
2.11.0

