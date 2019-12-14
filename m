Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0535C11F2A6
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLNPzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:55:08 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37121 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbfLNPzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:55:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 13AC222618;
        Sat, 14 Dec 2019 10:55:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=cJP6J0fqqg37G2QFoG/ZCUADbWu/eie8YAii1dBTSaY=; b=pcAjrLU0
        G4UXuLC9IDbGsC7ESsLlMF5DC6ZOeCuSpetBoQoKtC3maEVjGxWlbG7aKMeLP/5P
        K3hLmMhxeAeFNFAZt8H74UCcrV6Tip8mtANKNSu+reAurb5WXbME/W0ZyvE2Ffiy
        7Am7ZDmkUOvERg3nHbMtmlDXkqctHYdEUmk/Of9r4YFtriWsTg3N4M0QciUmbpSg
        vqF5V7UddjBaWyDRiTxQn3KfetCB3G+MihVYOm4PVMPoaqLjIulpZjOQdYpIYX07
        ItQVi58jQ41m/wGgwpmnLQBGxb4vVd+dGYWef6BkACCDByBVOxExVYtrzyYdudsC
        7YoT+gkSOMYA2w==
X-ME-Sender: <xms:2AX1XeYUWw327fsT0G6g-6onXCmjrKEBnrknQI67nJVj_VldiXDfdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:2AX1XXhmadqoe0-IxuDBjiebKriSp_fOu6gVenBVnJzTgPtBd-d6-A>
    <xmx:2AX1XVsg3hxrFwA_m9UqwTVf_ky0M5zOX2Zm0y_6-_1qraehvb82XQ>
    <xmx:2AX1XWguFAnjR4dRjI0XsTZHzSF1KUVODBcirafSgItBoikNq1gYcw>
    <xmx:2QX1XaPERLtEcvfV2NrqSr8ZrQ86weTqaZNF6nrhOmR6jtX2-PfiVw>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88F058005B;
        Sat, 14 Dec 2019 10:55:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/10] ipv4: Handle route deletion notification during flush
Date:   Sat, 14 Dec 2019 17:53:12 +0200
Message-Id: <20191214155315.613186-8-idosch@idosch.org>
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

In a similar fashion to previous patch, when a route is deleted as part
of table flushing, promote the next route in the list, if exists.
Otherwise, simply emit a delete notification.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_trie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 012aca433a91..c23be49ca51c 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1979,6 +1979,8 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 				continue;
 			}
 
+			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
+						NULL);
 			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
 						 n->key,
 						 KEYLENGTH - fa->fa_slen, fa,
-- 
2.23.0

