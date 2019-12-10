Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E934B118EEF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfLJRZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:25:02 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32857 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727882AbfLJRY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EF68020765;
        Tue, 10 Dec 2019 12:24:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=HvLIROF3WVQqKIjCtK1Vukx849K/qxU16qVb4Kyia28=; b=J+U58fmQ
        Z3x4PCUVD3VtZCwI0+q50HBvjnH51+8N68MS4BOSlAj8Cwv1M8+e80Lk5WsLsHNW
        HgYSSTjLsaF9tliGKpnlFGpk2MHJkbO84Y9F/gumND2TnwKFAVJ3yRd8quI53aqa
        kJA4I2f4XW/QOJ4hWQzj/4PMB1CSwqTzNup15qwanLdZnjAOUiO8SmQvhigAvpsZ
        dk6WkLuvMxoDRDiE4myaWaivWcJ8YXQGRmPxfuLYDnH+GYrtk1JxtaBzUigbl1dO
        TKdWUj+7SkCY8o8sBDD34kqkZi5XlXezeTNCW3LlBPq+mFjuCvKPATWsHQEPs7tN
        fUrBISSOhktMCg==
X-ME-Sender: <xms:6NTvXRGXrk_8QxXfx9a4apnI9nYol0beaAPiI6kuhDyj_19DdTkXCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:6NTvXR6QW19YT9KY_CSyJDeI0yg9hxrhQSNuZZftF-1PzwHUSnrkZg>
    <xmx:6NTvXUCvZeMU9F8_HKqv79zmsFp-AhQD2rlm4pwFRv4HYgLqJDKGJA>
    <xmx:6NTvXZ_S589UWJ9CMLeCdW5lL-K_e_QFVV9IT_Zrt6rnRkB8KyK0Yw>
    <xmx:6NTvXY1askzeaJ6F2f2d5RdZqF15QLB3h9OKHeqaFeAUp5xXOIZ3qw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77D8680059;
        Tue, 10 Dec 2019 12:24:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/9] ipv4: Handle route deletion notification during flush
Date:   Tue, 10 Dec 2019 19:23:59 +0200
Message-Id: <20191210172402.463397-7-idosch@idosch.org>
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

In a similar fashion to previous patch, when a route is deleted as part
of table flushing, promote the next route in the list, if exists.
Otherwise, simply emit a delete notification.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2d338469d4f2..60947a44d363 100644
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
2.23.0

