Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A711E5A25
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfJZLsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:07 -0400
Received: from correo.us.es ([193.147.175.20]:46624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfJZLsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:48:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 24FD28C3C45
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18FFCA7E9C
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0ECC0A7E99; Sat, 26 Oct 2019 13:47:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46D7DA7EC8;
        Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1811B42EE393;
        Sat, 26 Oct 2019 13:47:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 29/31] netfilter: nf_tables_offload: add nft_chain_offload_cmd()
Date:   Sat, 26 Oct 2019 13:47:31 +0200
Message-Id: <20191026114733.28111-30-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the nft_chain_offload_cmd() helper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index beeb74f2b47d..70f50d306799 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -316,6 +316,20 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *chain,
 
 #define FLOW_SETUP_BLOCK TC_SETUP_BLOCK
 
+static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
+				 struct net_device *dev,
+				 enum flow_block_command cmd)
+{
+	int err;
+
+	if (dev->netdev_ops->ndo_setup_tc)
+		err = nft_block_offload_cmd(basechain, dev, cmd);
+	else
+		err = nft_indr_block_offload_cmd(basechain, dev, cmd);
+
+	return err;
+}
+
 static int nft_flow_block_chain(struct nft_base_chain *basechain,
 				const struct net_device *this_dev,
 				enum flow_block_command cmd)
@@ -329,11 +343,7 @@ static int nft_flow_block_chain(struct nft_base_chain *basechain,
 		if (this_dev && this_dev != dev)
 			continue;
 
-		if (dev->netdev_ops->ndo_setup_tc)
-			err = nft_block_offload_cmd(basechain, dev, cmd);
-		else
-			err = nft_indr_block_offload_cmd(basechain, dev, cmd);
-
+		err = nft_chain_offload_cmd(basechain, dev, cmd);
 		if (err < 0)
 			return err;
 	}
-- 
2.11.0

