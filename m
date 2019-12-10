Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1985118EEB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfLJRYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36401 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727803AbfLJRYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C69E22329;
        Tue, 10 Dec 2019 12:24:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=A3eUxKr6bxprcyjzlZCP6Qce/jTIJoX0D3u4UqIvhjc=; b=Pt4eWcTn
        wku3yajS8h4FyypqvIhtFkgVBE7CcvzzvIp9Uz5Xwr9BUyAHXiFZPPoa3zP5cZ+H
        ZbXaUNOihI+Klr135fczDPUZpdaNtuuYQjl2QzklZgmZT504p9o1Qf1Opt3Ljhqn
        e0BlqnQz0aE7hvgnAucU+wRDR2Ze7UhV+wlNTYTwchy37AWIxl2CnDoNVMsA6zvU
        hgtq+bCEVmSutCV5Qc6yo4D1Y+VGaHWXrwN+xMH+z55EdVn6LuoMzBMHnaM0ljG7
        bHyg357lgB0rDRljE2a7t6Bhw3/gROpJrihXOBelTMFoyXVdmKpkX7Gu+lKEJCDk
        mDJmNKVwHTzLFQ==
X-ME-Sender: <xms:5NTvXZGcayNXzcQQwrT6zn7rLPtb6Ogsf_fqTvrjBznzaseHneuuuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:5NTvXX99Ufuh_PMKu_FhrvCXwpzqBkhzZkUPp4qTQ78mtQIgEvoo5g>
    <xmx:5NTvXfigpIOx_gZ0nyDUzlXsPDOOaNU6KYtsR8u3GaBfv4CxkVXX8w>
    <xmx:5NTvXddf3WWFFZxhvfBi82ysI8pNX8fVIpeQdgnvE21WG9pGjPLDVg>
    <xmx:5NTvXblnwwOyni7FqlhuhM36Ah7SdUJcpLKeS__8HuoA6eAoyThtoA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B77480066;
        Tue, 10 Dec 2019 12:24:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] ipv4: Notify route if replacing currently offloaded one
Date:   Tue, 10 Dec 2019 19:23:56 +0200
Message-Id: <20191210172402.463397-4-idosch@idosch.org>
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

When replacing a route, its replacement should only be notified in case
the replaced route is of any interest to listeners. In other words, if
the replaced route is currently used in the data path, which means it is
the first route in the FIB alias list with the given {prefix, prefix
length, table ID}.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 9264d6628e9f..6822aa90657a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -978,6 +978,27 @@ static struct key_vector *fib_find_node(struct trie *t,
 	return n;
 }
 
+/* Return the first fib alias matching prefix length and table ID. */
+static struct fib_alias *fib_find_first_alias(struct hlist_head *fah, u8 slen,
+					      u32 tb_id)
+{
+	struct fib_alias *fa;
+
+	hlist_for_each_entry(fa, fah, fa_list) {
+		if (fa->fa_slen < slen)
+			continue;
+		if (fa->fa_slen != slen)
+			break;
+		if (fa->tb_id > tb_id)
+			continue;
+		if (fa->tb_id != tb_id)
+			break;
+		return fa;
+	}
+
+	return NULL;
+}
+
 /* Return the first fib alias matching TOS with
  * priority less than or equal to PRIO.
  */
@@ -1217,6 +1238,17 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 			new_fa->tb_id = tb->tb_id;
 			new_fa->fa_default = -1;
 
+			if (fib_find_first_alias(&l->leaf, fa->fa_slen,
+						 tb->tb_id) == fa) {
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

