Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FC811F2A5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfLNPzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:55:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34567 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbfLNPzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:55:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D62ED225A0;
        Sat, 14 Dec 2019 10:55:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0QDWfEgLt1z8RX2J91LINH87MArPddL6pN3t1IL/MyY=; b=v7d6qt3R
        /1m7QTx0R8/kOpfGfJJ+O32lTnQ354lLJUp2VReTgnytm7rG74Ju3ZLjPzGTxA8E
        Fu3K//b6V302KFKCPNX5yyns1Csc8NFobrvmEaS0XPpjJ0U0nWuk8wB2vVMeqYkj
        R2+rRM2vTMWuRRgxbjfvkzn6VHfCTn14vxgFXNnGHm+Tr8mvQYfONaiqs7ArLI5F
        szrmTrYaUftTuH7fBvnAy5fou0vE/TtzCUzX1d3MNCyOEa6fIz8o3xPvPq27zu07
        DSUhxMs+j1XYQpj+cwbjO/vltIXUVAwQVTLeIiriyXYvO5DDaMr2/swoCSbIeKSv
        0yH6bVVJrHksQw==
X-ME-Sender: <xms:2wX1XfWLoJqTiRp_A0Yw_uJ1pA_BoRta160Fd7yV71rDtbWNFE-0_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:2wX1XWUa2eMvoZZBxBrRwW3J927ba95Ta1Ekab6wouxxuYvlCPfLSA>
    <xmx:2wX1Xf_xwlLeHenLL9uZh84pcBr8Z3VECCkvAjk3nrnodX1nkbCwpw>
    <xmx:2wX1XWYYYnBEPt8WRCAGBpHj8sLaEwd_nOIdWzzS0VDo5bx0AyTJUQ>
    <xmx:2wX1XW7Myks68wVtBltEII2omyg3vAj13OpOcoBJVxFTVxbc3iK7ug>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B84C8005B;
        Sat, 14 Dec 2019 10:55:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/10] ipv4: Only Replay routes of interest to new listeners
Date:   Sat, 14 Dec 2019 17:53:13 +0200
Message-Id: <20191214155315.613186-9-idosch@idosch.org>
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

When a new listener is registered to the FIB notification chain it
receives a dump of all the available routes in the system. Instead, make
sure to only replay the IPv4 routes that are actually used in the data
path and are of any interest to the new listener.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index c23be49ca51c..3f2ff97618ec 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2080,6 +2080,7 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 			   struct netlink_ext_ack *extack)
 {
 	struct fib_alias *fa;
+	int last_slen = -1;
 	int err;
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
@@ -2099,6 +2100,16 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 					      fa, extack);
 		if (err)
 			return err;
+
+		if (fa->fa_slen == last_slen)
+			continue;
+
+		last_slen = fa->fa_slen;
+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
+					      l->key, KEYLENGTH - fa->fa_slen,
+					      fa, extack);
+		if (err)
+			return err;
 	}
 	return 0;
 }
-- 
2.23.0

