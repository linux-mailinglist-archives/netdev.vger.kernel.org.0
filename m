Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED612E8DEA
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 20:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbhACTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 14:30:15 -0500
Received: from correo.us.es ([193.147.175.20]:40816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbhACTaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 14:30:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 670F911774F
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56A9EDA730
        for <netdev@vger.kernel.org>; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 49D5CDA722; Sun,  3 Jan 2021 20:28:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFDAADA73D;
        Sun,  3 Jan 2021 20:28:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:28:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9ED99426CC85;
        Sun,  3 Jan 2021 20:28:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
Date:   Sun,  3 Jan 2021 20:29:19 +0100
Message-Id: <20210103192920.18639-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210103192920.18639-1-pablo@netfilter.org>
References: <20210103192920.18639-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If userspace requests a feature which is not available the original set
definition, then bail out with EOPNOTSUPP. If userspace sends
unsupported dynset flags (new feature not supported by this kernel),
then report EOPNOTSUPP to userspace. EINVAL should be only used to
report malformed netlink messages from userspace.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 983a1d5ca3ab..f35df221a633 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -177,7 +177,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_DYNSET_FLAGS]));
 
 		if (flags & ~NFT_DYNSET_F_INV)
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (flags & NFT_DYNSET_F_INV)
 			priv->invert = true;
 	}
@@ -210,7 +210,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 
 		err = nf_msecs_to_jiffies64(tb[NFTA_DYNSET_TIMEOUT], &timeout);
 		if (err)
@@ -224,7 +224,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 	if (tb[NFTA_DYNSET_SREG_DATA] != NULL) {
 		if (!(set->flags & NFT_SET_MAP))
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		if (set->dtype == NFT_DATA_VERDICT)
 			return -EOPNOTSUPP;
 
-- 
2.20.1

