Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF18A8CF8
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbfIDQTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731828AbfIDP6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF86D23401;
        Wed,  4 Sep 2019 15:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612696;
        bh=kjk+EoecReY9IsVOLIcpYHJWi8ERUAkv7rkSi+iBvn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvpVcIGINZxeYl0g8X4Myh0LTN4n5GAfjI2avWEMt4qObn+dh1H33+Ws32/b0PDj3
         B6vTjXDWpHUETYPcD37SFZ85ou/3yC5pMZnW4+FgNA3xSl36C9CkshiyYBpklcYvIj
         fUXcQrWTYGoj7q5v362Fm5iSaCMrJL9g2JplLm6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 24/94] netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info
Date:   Wed,  4 Sep 2019 11:56:29 -0400
Message-Id: <20190904155739.2816-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>

[ Upstream commit 89a26cd4b501e9511d3cd3d22327fc76a75a38b3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_nfacct.h |  5 ++++
 net/netfilter/xt_nfacct.c                | 36 ++++++++++++++++--------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
index 5c8a4d760ee34..b5123ab8d54a8 100644
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
index d0ab1adf5bff8..5aab6df74e0f2 100644
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
2.20.1

