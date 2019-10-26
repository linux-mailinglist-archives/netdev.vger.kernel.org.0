Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AC9E5A22
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfJZLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:59 -0400
Received: from correo.us.es ([193.147.175.20]:46456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfJZLr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F8CD8C3C6A
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 623E221FFA
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 57EBDCA0F2; Sat, 26 Oct 2019 13:47:53 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70A69A7E18;
        Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3EDEA42EE393;
        Sat, 26 Oct 2019 13:47:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 23/31] netfilter: nf_tables_offload: add nft_flow_block_chain()
Date:   Sat, 26 Oct 2019 13:47:25 +0200
Message-Id: <20191026114733.28111-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add nft_flow_block_chain() helper function to reuse this function from
netdev event handler.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e546f759b7a7..4554bc661817 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -294,6 +294,16 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
+static int nft_flow_block_chain(struct nft_base_chain *basechain,
+				struct net_device *dev,
+				enum flow_block_command cmd)
+{
+	if (dev->netdev_ops->ndo_setup_tc)
+		return nft_block_offload_cmd(basechain, dev, cmd);
+
+	return nft_indr_block_offload_cmd(basechain, dev, cmd);
+}
+
 static int nft_flow_offload_chain(struct nft_chain *chain,
 				  u8 *ppolicy,
 				  enum flow_block_command cmd)
@@ -316,10 +326,7 @@ static int nft_flow_offload_chain(struct nft_chain *chain,
 	if (cmd == FLOW_BLOCK_BIND && policy == NF_DROP)
 		return -EOPNOTSUPP;
 
-	if (dev->netdev_ops->ndo_setup_tc)
-		return nft_block_offload_cmd(basechain, dev, cmd);
-	else
-		return nft_indr_block_offload_cmd(basechain, dev, cmd);
+	return nft_flow_block_chain(basechain, dev, cmd);
 }
 
 int nft_flow_rule_offload_commit(struct net *net)
-- 
2.11.0

