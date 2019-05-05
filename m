Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5FB14300
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfEEXdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:16 -0400
Received: from mail.us.es ([193.147.175.20]:34074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfEEXdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1578411ED85
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02C39DA706
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EC7C8DA703; Mon,  6 May 2019 01:33:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1E7ADA702;
        Mon,  6 May 2019 01:33:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B86C44265A31;
        Mon,  6 May 2019 01:33:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/12] netfilter: nf_tables: relocate header content to consumer
Date:   Mon,  6 May 2019 01:32:54 +0200
Message-Id: <20190505233305.13650-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

The nf_tables.h header is used in a lot of files, but it turns out
that there is only one actual user of nft_expr_clone().

Hence we relocate that function to be with the one consumer of it
and avoid having to process it with CPP for all the other files.

This will also enable a reduction in the other headers that the
nf_tables.h itself has to include just to be stand-alone, hence
a pending further significant reduction in the CPP content that
needs to get processed for each netfilter file.

Note that the explicit "inline" has been dropped as part of this
relocation.  In similar changes to this, I believe Dave has asked
this be done, so we free up gcc to make the choice of whether to
inline or not.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 17 -----------------
 net/netfilter/nft_dynset.c        | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2d5a0a1a87b8..706f744f7308 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -806,23 +806,6 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
 
-static inline int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
-{
-	int err;
-
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
-
-	__module_get(src->ops->type->owner);
-	return 0;
-}
-
 /**
  *	struct nft_rule - nf_tables rule
  *
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e461007558e8..8394560aa695 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -28,6 +28,23 @@ struct nft_dynset {
 	struct nft_set_binding		binding;
 };
 
+static int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
+{
+	int err;
+
+	if (src->ops->clone) {
+		dst->ops = src->ops;
+		err = src->ops->clone(dst, src);
+		if (err < 0)
+			return err;
+	} else {
+		memcpy(dst, src, src->ops->size);
+	}
+
+	__module_get(src->ops->type->owner);
+	return 0;
+}
+
 static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 			    struct nft_regs *regs)
 {
-- 
2.11.0

