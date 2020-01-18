Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F66141967
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgARUOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:38 -0500
Received: from correo.us.es ([193.147.175.20]:48466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgARUOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E4212EFEAB
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2354DA703
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7D19DA707; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E81A8DA703;
        Sat, 18 Jan 2020 21:14:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C1E8141E4800;
        Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/21] netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
Date:   Sat, 18 Jan 2020 21:14:16 +0100
Message-Id: <20200118201417.334111-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Add a new bitwise netlink attribute that will be used by shift
operations to store the size of the shift.  It is not used by boolean
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 3 +++
 net/netfilter/nft_bitwise.c              | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0cddf357281f..8bef0620bc4f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -503,6 +503,8 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
+ * @NFTA_BITWISE_DATA: argument for non-boolean operations
+ *                     (NLA_NESTED: nft_data_attributes)
  *
  * The bitwise expression performs the following operation:
  *
@@ -524,6 +526,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
+	NFTA_BITWISE_DATA,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index b4619d9989ea..744008a527fb 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -22,6 +22,7 @@ struct nft_bitwise {
 	u8			len;
 	struct nft_data		mask;
 	struct nft_data		xor;
+	struct nft_data		data;
 };
 
 static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
@@ -54,6 +55,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
 	[NFTA_BITWISE_MASK]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
 	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
+	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
 };
 
 static int nft_bitwise_init_bool(struct nft_bitwise *priv,
@@ -62,6 +64,9 @@ static int nft_bitwise_init_bool(struct nft_bitwise *priv,
 	struct nft_data_desc d1, d2;
 	int err;
 
+	if (tb[NFTA_BITWISE_DATA])
+		return -EINVAL;
+
 	if (!tb[NFTA_BITWISE_MASK] ||
 	    !tb[NFTA_BITWISE_XOR])
 		return -EINVAL;
-- 
2.11.0

