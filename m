Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E720A3649
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfH3MHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:07:17 -0400
Received: from correo.us.es ([193.147.175.20]:36332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbfH3MHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:07:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9460CD2B00
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C229B7FFE
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71ABBB7FF9; Fri, 30 Aug 2019 14:07:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65A25FB362;
        Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 32B694251481;
        Fri, 30 Aug 2019 14:07:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/5] netfilter: nft_meta_bridge: Fix get NFT_META_BRI_IIFVPROTO in network byteorder
Date:   Fri, 30 Aug 2019 14:07:04 +0200
Message-Id: <20190830120704.6147-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190830120704.6147-1-pablo@netfilter.org>
References: <20190830120704.6147-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Get the vlan_proto of ingress bridge in network byteorder as userspace
expects. Otherwise this is inconsistent with NFT_META_PROTOCOL.

Fixes: 2a3a93ef0ba5 ("netfilter: nft_meta_bridge: Add NFT_META_BRI_IIFVPROTO support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 1804e867f715..7c9e92b2f806 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -53,7 +53,7 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 			goto err;
 
 		br_vlan_get_proto(br_dev, &p_proto);
-		nft_reg_store16(dest, p_proto);
+		nft_reg_store16(dest, htons(p_proto));
 		return;
 	}
 	default:
-- 
2.11.0

