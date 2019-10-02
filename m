Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966CCC49C3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfJBIlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55611 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 322D62071B;
        Wed,  2 Oct 2019 04:41:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=2Z9sA0nkZlXc+zR9KCPyEKa47IuMW3mWcyjqw3366XE=; b=gVlEVc8k
        xgIpsyWeZaKhin1ItrEAs4nkoY+VhgyQh+4QHyQSqKMj2EoqUfInWYd7o/38eTOr
        ekm4hmm4YKZ0JYgGDqDljsOwnZwlQ5o3X0TNhNZ+VaF7x5xcKceq8CizMl77a0UI
        vF/ClP5/Iclvb5QW1wwF2caR42pBcN1i+lJOld/wve4cy14XoiN9tU6hoGG1xO8+
        +Yns1gw01EeGaETRZDK9pANoJKTESL0XhK9klpiTviqFGapg+yNeVdjNB8VgnL3b
        NxPK0f0Mx89+pXKM8e3Yv4ShlHqmKPJBwXbHxz8JgH/yvvBKAQUMxn0iW6rAYaQC
        DZ3eWfGl9Zq6Hw==
X-ME-Sender: <xms:v2KUXZo9HIdksmRaHLMoa3AarsTFAJwDLdyRm_o5s48kKoKmARWxZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:wGKUXYemBJ_wE5te5dZ-gYDqKs_-3ZhZVTIn8cwpv2b5PWZbyuq6Eg>
    <xmx:wGKUXaa2tUFwPV5aH-qk5jtmDV2jkLT7N6ehIjyrcBplZyFwTVyU4g>
    <xmx:wGKUXTBSH76TyFwdoPoFB4d8rBtire248JIGKJ2CW5NEcPF_fs3J4A>
    <xmx:wGKUXZW_EltaScbdd1dzECAqiiUYFWazDZ3I5S_jyoqOzFh5r6ckDA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93311D60065;
        Wed,  2 Oct 2019 04:41:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 04/15] ipv4: Notify newly added route if should be offloaded
Date:   Wed,  2 Oct 2019 11:40:52 +0300
Message-Id: <20191002084103.12138-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a route is added, it should only be notified in case it is the
first route in the FIB alias list with the given {prefix, prefix length,
table ID}. Otherwise, it is not used in the data path and should not be
considered by switch drivers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8387b275721c..e5896729dcb9 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1311,6 +1311,16 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	if (WARN_ON_ONCE(!l))
 		goto out_free_new_fa;
 
+	if (fib_find_first_alias(&l->leaf, new_fa->fa_slen, tb->tb_id) ==
+	    new_fa) {
+		enum fib_event_type fib_event;
+
+		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		err = call_fib_entry_notifiers(net, fib_event, key, plen,
+					       new_fa, extack);
+		if (err)
+			goto out_remove_new_fa;
+	}
 	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
 	if (err)
 		goto out_remove_new_fa;
-- 
2.21.0

