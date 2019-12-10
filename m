Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793A1118EEE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfLJRY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:59 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40493 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbfLJRY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 54DCE2232A;
        Tue, 10 Dec 2019 12:24:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=YPXNac4fp71aDfq5eNTVlHrgh56gIoT9O0TtDOP6jsE=; b=Dshz/T+V
        pgnZ0Mv1wM338Z0FNcMj3LsBBIoZU2nfuPDywaviucGQMxRrj5n08NeUMJmYlGFg
        duiK99qFjxpXFZX4RMGPoZ/pmxtPj7O5bQjeRkOBw7wyx7MQrnwfrtAUj+olIVH+
        VaEQpO3LK9u2KLiUToSUiJ+MOpLOzkj9tttCBS9XsaJegngV6KJjJyv/IyEUmrhJ
        aqLalSSWGK3B5O2/G7rhCUdyh6OOMcO+TuZtsTrEK3Qt7Ms6iE7L+SR1BE+NBcwb
        tpb2efP8Gj45a8ze8vCCMEMnWVJHm63Ws/9nx/XGMpsa+ol+Yhea2i1xfJalFSS/
        DYlUkntf28VB+w==
X-ME-Sender: <xms:6tTvXV-gfgiZPAJ8B_vJK3H7s50WAr2A-r4Zx20bj-0kZzDBX5uLjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:6tTvXQbZTj5TkVBktUMK-YuG3F-F4DgOcfVkFIDlRRcHVpIS2oeE8Q>
    <xmx:6tTvXUXXm1BR17bFT3ug2LCAyTx0A3q_5znjNZ3IKtHjeSKOeI6eWg>
    <xmx:6tTvXfV1Zk8_iDVLubYjJQmn4dUkJ6yDQdbPIICkUOfC8eM8OxecsQ>
    <xmx:6tTvXdzSVxafi0alzybjUteBGyeYp2hYbuR47wEk8S2IFSl1Bxbhsg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECEDD8005B;
        Tue, 10 Dec 2019 12:24:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] ipv4: Only Replay routes of interest to new listeners
Date:   Tue, 10 Dec 2019 19:24:00 +0200
Message-Id: <20191210172402.463397-8-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191210172402.463397-1-idosch@idosch.org>
References: <20191210172402.463397-1-idosch@idosch.org>
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
---
 net/ipv4/fib_trie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 60947a44d363..eff45e7795ba 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2096,6 +2096,7 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 			   struct netlink_ext_ack *extack)
 {
 	struct fib_alias *fa;
+	int last_slen = -1;
 	int err;
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
@@ -2115,6 +2116,16 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
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

