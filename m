Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692E911F2A2
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLNPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:54:59 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43373 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfLNPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:54:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 622F522618;
        Sat, 14 Dec 2019 10:54:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JbXkSBcKMNd//gFs997K/QhD4Q7T11j95zNNyu4nYjg=; b=K8sk86uk
        zhRi26SlHKXD0t9o7FB6hb9ZZqRhKYrxvOZvutx/miGv5FRiv62/HgW0scSDAyr+
        I3SZ+rBvqkycZJqgy20Lv+O0ceKdkSiWWAd4X8I2UsZ4TyohrkR5VkEGb5jN6bql
        A0OSbYVXtkuespnEpNlu25KMhlDaBqktcdf96TbNvnaLF5gR0A5GVX8Zy5kVmdi2
        Syxj4sdg6Khr4X3NvcXV27YtVxxu28IFd268vaW/t3d40xerZ0CEwCWNcbZca3Jo
        /nHmReDTycUqdGDo2Ui/oii8v9shhpv1oG9s9Kz/9guXee95WDXn1YO1UaE7+rrH
        Y+GTFTDCFmNd2w==
X-ME-Sender: <xms:0QX1XW5AwHRLh9gWw483332ax4wEk8T5rdeCPRk5DBmCDJCOeqVoNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:0QX1XTJLpG18MyPNqfLIiUZu-X9ydDaKsmcW5f_SNqNh4NrpnwE6Lw>
    <xmx:0QX1Xe5zZeFBhPYFTnMTlX7dS1xipv41O9Y7afmtP-PAH_oVLsU-sA>
    <xmx:0QX1XeyrI8yu0iZnsIba59KfB9TuKTV3N6BePOYfxaHgUg6aU2HoZA>
    <xmx:0QX1XTzjwzKlUQPjp4P3ruXbPRzMpsB8gtELDNID18ENyqqHHcgu4A>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 404B88005A;
        Sat, 14 Dec 2019 10:54:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/10] ipv4: Notify route if replacing currently offloaded one
Date:   Sat, 14 Dec 2019 17:53:09 +0200
Message-Id: <20191214155315.613186-5-idosch@idosch.org>
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

When replacing a route, its replacement should only be notified in case
the replaced route is of any interest to listeners. In other words, if
the replaced route is currently used in the data path, which means it is
the first route in the FIB alias list with the given {prefix, prefix
length, table ID}.

v2:
* Convert to use fib_find_alias() instead of fib_find_first_alias()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4c22e768a5b5..4c80ac0344f4 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1222,6 +1222,17 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
 
+			if (fib_find_alias(&l->leaf, fa->fa_slen, 0, 0,
+					   tb->tb_id, true) == fa) {
+				enum fib_event_type fib_event;
+
+				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+				err = call_fib_entry_notifiers(net, fib_event,
+							       key, plen,
+							       new_fa, extack);
+				if (err)
+					goto out_free_new_fa;
+			}
 			err = call_fib_entry_notifiers(net,
 						       FIB_EVENT_ENTRY_REPLACE,
 						       key, plen, new_fa,
-- 
2.23.0

