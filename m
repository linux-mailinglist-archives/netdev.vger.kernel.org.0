Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7A894D5E
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfHSS7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:59:38 -0400
Received: from correo.us.es ([193.147.175.20]:37884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728352AbfHSS7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16B57F262A
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06640B7FFB
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F01B8B7FF6; Mon, 19 Aug 2019 20:50:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7ED6DA72F;
        Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 72C864265A32;
        Mon, 19 Aug 2019 20:50:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info
Date:   Mon, 19 Aug 2019 20:49:10 +0200
Message-Id: <20190819184911.15263-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>

When running a 64-bit kernel with a 32-bit iptables binary, the size of
the xt_nfacct_match_info struct diverges.

    kernel: sizeof(struct xt_nfacct_match_info) : 40
    iptables: sizeof(struct xt_nfacct_match_info)) : 36

Trying to append nfacct related rules results in an unhelpful message.
Although it is suggested to look for more information in dmesg, nothing
can be found there.

    # iptables -A <chain> -m nfacct --nfacct-name <acct-object>
    iptables: Invalid argument. Run `dmesg' for more information.

This patch fixes the memory misalignment by enforcing 8-byte alignment
within the struct's first revision. This solution is often used in many
other uapi netfilter headers.

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_nfacct.h |  5 +++++
 net/netfilter/xt_nfacct.c                | 36 ++++++++++++++++++++++----------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
index 5c8a4d760ee3..b5123ab8d54a 100644
--- a/include/uapi/linux/netfilter/xt_nfacct.h
+++ b/include/uapi/linux/netfilter/xt_nfacct.h
@@ -11,4 +11,9 @@ struct xt_nfacct_match_info {
 	struct nf_acct	*nfacct;
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct __attribute__((aligned(8)));
+};
+
 #endif /* _XT_NFACCT_MATCH_H */
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index d0ab1adf5bff..5aab6df74e0f 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -54,25 +54,39 @@ nfacct_mt_destroy(const struct xt_mtdtor_param *par)
 	nfnl_acct_put(info->nfacct);
 }
 
-static struct xt_match nfacct_mt_reg __read_mostly = {
-	.name       = "nfacct",
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nfacct_mt_checkentry,
-	.match      = nfacct_mt,
-	.destroy    = nfacct_mt_destroy,
-	.matchsize  = sizeof(struct xt_nfacct_match_info),
-	.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
-	.me         = THIS_MODULE,
+static struct xt_match nfacct_mt_reg[] __read_mostly = {
+	{
+		.name       = "nfacct",
+		.revision   = 0,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info),
+		.usersize   = offsetof(struct xt_nfacct_match_info, nfacct),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "nfacct",
+		.revision   = 1,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nfacct_mt_checkentry,
+		.match      = nfacct_mt,
+		.destroy    = nfacct_mt_destroy,
+		.matchsize  = sizeof(struct xt_nfacct_match_info_v1),
+		.usersize   = offsetof(struct xt_nfacct_match_info_v1, nfacct),
+		.me         = THIS_MODULE,
+	},
 };
 
 static int __init nfacct_mt_init(void)
 {
-	return xt_register_match(&nfacct_mt_reg);
+	return xt_register_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 static void __exit nfacct_mt_exit(void)
 {
-	xt_unregister_match(&nfacct_mt_reg);
+	xt_unregister_matches(nfacct_mt_reg, ARRAY_SIZE(nfacct_mt_reg));
 }
 
 module_init(nfacct_mt_init);
-- 
2.11.0


