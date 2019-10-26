Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5F0E5A26
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfJZLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:08 -0400
Received: from correo.us.es ([193.147.175.20]:46456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfJZLsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:48:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C26C68C3C5F
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5847A7E9E
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AB175A7E9C; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9482CA7E62;
        Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6566642EE393;
        Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 31/31] netfilter: nf_tables_offload: unbind if multi-device binding fails
Date:   Sat, 26 Oct 2019 13:47:33 +0200
Message-Id: <20191026114733.28111-32-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_flow_block_chain() needs to unbind in case of error when performing
the multi-device binding.

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index d51728affa1c..4e0625cce647 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -336,7 +336,7 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 {
 	struct net_device *dev;
 	struct nft_hook *hook;
-	int err;
+	int err, i = 0;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		dev = hook->ops.dev;
@@ -344,11 +344,26 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 			continue;
 
 		err = nft_chain_offload_cmd(basechain, dev, cmd);
-		if (err < 0)
+		if (err < 0 && cmd == FLOW_BLOCK_BIND) {
+			if (!this_dev)
+				goto err_flow_block;
+
 			return err;
+		}
+		i++;
 	}
 
 	return 0;
+
+err_flow_block:
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (i-- <= 0)
+			break;
+
+		dev = hook->ops.dev;
+		nft_chain_offload_cmd(basechain, dev, FLOW_BLOCK_UNBIND);
+	}
+	return err;
 }
 
 static int nft_flow_offload_chain(struct nft_chain *chain, u8 *ppolicy,
-- 
2.11.0

