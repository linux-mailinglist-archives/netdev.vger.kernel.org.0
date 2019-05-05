Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609BD14314
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfEEXdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:43 -0400
Received: from mail.us.es ([193.147.175.20]:34106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbfEEXdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48FC811ED96
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36748DA70B
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2BFE9DA703; Mon,  6 May 2019 01:33:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28FA8DA703;
        Mon,  6 May 2019 01:33:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F2C864265A31;
        Mon,  6 May 2019 01:33:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/12] netfilter: nft_ct: Add ct id support
Date:   Mon,  6 May 2019 01:33:02 +0200
Message-Id: <20190505233305.13650-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Mastbergen <bmastbergen@untangle.com>

The 'id' key returns the unique id of the conntrack entry as returned
by nf_ct_get_id().

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_ct.c                   | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 061bb3eb20c3..f0cf7b0f4f35 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -967,6 +967,7 @@ enum nft_socket_keys {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
+ * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -993,6 +994,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_TIMEOUT,
+	NFT_CT_ID,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b422b74bfe08..f043936763f3 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -178,6 +178,11 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 	}
 #endif
+	case NFT_CT_ID:
+		if (!nf_ct_is_confirmed(ct))
+			goto err;
+		*dest = nf_ct_get_id(ct);
+		return;
 	default:
 		break;
 	}
@@ -479,6 +484,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u16);
 		break;
 #endif
+	case NFT_CT_ID:
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.11.0

