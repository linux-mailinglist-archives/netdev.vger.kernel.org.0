Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBC411F2A1
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLNPy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:54:56 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47791 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfLNPyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:54:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0A8952255B;
        Sat, 14 Dec 2019 10:54:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=F9j9VDIjp93vbXX/gah9HFs1orZPCucsFV6Vb/G6ATQ=; b=DmUS4oRN
        ytNJNYe4Bb8OVfjvKaQYp1T3p+BJNmYbs3CqvOQXTaTzxsv4eRDAiOC+UBCdX5yU
        /lrF718gw1ljiJg8oHa9OYmMZwL6uAmDQD3TmDBxZkuc2HQnpyZly59s134CEaZX
        tj43TOSw+eqg0liF8Le98ntVcyPxKbSLF70tEMqDhtaG02NeevhrrR0b9/L4HRw6
        VSi1HyIhl5/ELP2Z6q7we/B1gWPDeILY0YZTsG2HU9hcHSAEy1sZ8P2A2nviw8w7
        iKg3bwNw/vG1Ot7ljxAMwN5b28sbOSm+CKijADlchu8lxZPemJZQHEACvlB5pTAc
        vQcHgaas9P6cGQ==
X-ME-Sender: <xms:zgX1XWcB-MN-iqjEgmqcIyAKrDKZquPnPSy8any1-YQLftE-XYmfsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:zgX1Xa17TC9vcoo2f0r8WAcXwc1ANpC-ZjsOQ9Cg2E3WLWkkczkJaA>
    <xmx:zgX1XbkBj60W2q62lXUSrGmz1EpJnGZpUHUBMuG6lweEz1sCFb9Pzw>
    <xmx:zgX1XZN2clo5IEoQu0XBGLO0eEX08Rk0N0WznMIzURed-0LP_0GfTg>
    <xmx:zwX1XbKd5_eIXClMwvO8ke06Xvmg72A2t6DC0296zsHh0xDmBwX2TA>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 082D58005A;
        Sat, 14 Dec 2019 10:54:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 03/10] ipv4: Extend FIB alias find function
Date:   Sat, 14 Dec 2019 17:53:08 +0200
Message-Id: <20191214155315.613186-4-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191214155315.613186-1-idosch@idosch.org>
References: <20191214155315.613186-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Extend the function with another argument, 'find_first'. When set, the
function returns the first FIB alias with the matching {prefix, prefix
length, table ID}. The TOS and priority parameters are ignored. Current
callers are converted to pass 'false' in order to maintain existing
behavior.

This will be used by subsequent patches in the series.

v2:
* New patch

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Suggested-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 9264d6628e9f..4c22e768a5b5 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -980,9 +980,12 @@ static struct key_vector *fib_find_node(struct trie *t,
 
 /* Return the first fib alias matching TOS with
  * priority less than or equal to PRIO.
+ * If 'find_first' is set, return the first matching
+ * fib alias, regardless of TOS and priority.
  */
 static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
-					u8 tos, u32 prio, u32 tb_id)
+					u8 tos, u32 prio, u32 tb_id,
+					bool find_first)
 {
 	struct fib_alias *fa;
 
@@ -998,6 +1001,8 @@ static struct fib_alias *fib_find_alias(struct hlist_head *fah, u8 slen,
 			continue;
 		if (fa->tb_id != tb_id)
 			break;
+		if (find_first)
+			return fa;
 		if (fa->fa_tos > tos)
 			continue;
 		if (fa->fa_info->fib_priority >= prio || fa->fa_tos < tos)
@@ -1149,7 +1154,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
 	l = fib_find_node(t, &tp, key);
 	fa = l ? fib_find_alias(&l->leaf, slen, tos, fi->fib_priority,
-				tb->tb_id) : NULL;
+				tb->tb_id, false) : NULL;
 
 	/* Now fa, if non-NULL, points to the first fib alias
 	 * with the same keys [prefix,tos,priority], if such key already
@@ -1565,7 +1570,7 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 	if (!l)
 		return -ESRCH;
 
-	fa = fib_find_alias(&l->leaf, slen, tos, 0, tb->tb_id);
+	fa = fib_find_alias(&l->leaf, slen, tos, 0, tb->tb_id, false);
 	if (!fa)
 		return -ESRCH;
 
-- 
2.23.0

