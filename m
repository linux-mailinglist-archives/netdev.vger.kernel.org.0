Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE3C49C4
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfJBIll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55721 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbfJBIlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4962220A34;
        Wed,  2 Oct 2019 04:41:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ivvEYAQOIITobVxjARkfKZzgB4ZKHd6RIDohTRDr+a8=; b=DTZ6cASX
        9z0WRfun+mE9Ky28Q6XV3jhHMV03TyLvOxaPFmBZLIOHS2kBq7dZqLS9G5vF6Eh4
        aYeJAYJop4Uh0s5QrAb7nZSasT+7qzcvOpOq3QnC5oZNWCreU9V7DeB2RAFrOojU
        MS119PccEXAl0hEfQbeX8U5yHtJEO1gnODaIQmzu+40yQljBvxA4K+HOn+JLlfHt
        A9aesDt87XcrQR0s4U9MQYNXob6+mgHFw/JPKlisDPJyARMvc5AO4eI5poRJH9o7
        Dwy3YXunQAlvtguXvrCUBET9wfl5og5erLDqg7vsuYnAhnu+Ycr0xwowZgTP7cQ0
        6/huuFg+0UdFXQ==
X-ME-Sender: <xms:w2KUXUFGE800CmfvMH5WvAESTjj3ArSUWfJ6cM9KZPH9giIsBAhf4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:w2KUXf9vB2Bmr4Gx39_tkPUd08JKvEpqp24RGXIeASmR35ZhhK7GeQ>
    <xmx:w2KUXTGPMizq4_VaDMK2P3hXWGKG1th7q5mkdqq7ychkNwCEwUf5kw>
    <xmx:w2KUXZBLyC9LEpyw7FXh3PxAAJCeYCD5bLPlEGQBbqGb9lfTf9nUTQ>
    <xmx:w2KUXeHJn2GcqBdQerPkz2XU44slrnYHj2lRs1ERtAfNkcLU7po_pg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5DA6D6005E;
        Wed,  2 Oct 2019 04:41:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 06/15] ipv4: Handle route deletion notification during flush
Date:   Wed,  2 Oct 2019 11:40:54 +0300
Message-Id: <20191002084103.12138-7-idosch@idosch.org>
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

In a similar fashion to previous patch, when a route is deleted as part
of table flushing, promote the next route in the list, if exists.
Otherwise, simply emit a delete notification.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ba597dbe1cc5..dc4c4e2cb0b3 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1995,6 +1995,8 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 				continue;
 			}
 
+			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
+						NULL);
 			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
 						 n->key,
 						 KEYLENGTH - fa->fa_slen, fa,
-- 
2.21.0

