Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B26118EF0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfLJRY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:57 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58715 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727837AbfLJRYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EB7762231C;
        Tue, 10 Dec 2019 12:24:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=fQrw1k00Bl9jpXQA/mHR5iMkeeTf5DunsuxLEa9igNw=; b=BOL9bAFe
        IPaY6bT+2K8wY3BTP+SmoBGbW4BSXDf8IolIrqt2t0pzs+jQxrACANWxDXEGzowu
        5uSHXj6ynVydaLughBg8xsfAUXo23Vz2k2V/Co5883J+LJI45Qd4OSd6R8bJvWq+
        XqP/llzCWEVNL+OvMK/3xgqI+KcXNVhLnSdQSGPbgWPIsY+jKhSh05PDSVdRNM4m
        txGRnm50mDQD24m7fbA716+cHpZdc6i4EULDPLVC2Zq7wyROdqGhqkLEeyP0jp/r
        DxAJhRqRsqDtfC3amhgaKv09mDnQqc091+yr9ddZ5lDnVac/FDzOEFZ3+8fr595o
        mNdXYgb2VesPvw==
X-ME-Sender: <xms:5dTvXTVNChiNwNoXbFkjsJxYHwvLeFgTMCL8H6G6DtU44v_UOXHRZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:5dTvXV-S0Sc0UDrihgvODHnCK4lREyCwWsy4zm5qq79tKLmaAGMN8A>
    <xmx:5dTvXVhMFzy_JlUqg4RQrREcO69NdzPyYaxWegXXAyQiC7QHzMklFA>
    <xmx:5dTvXZe1CVFu20XGKviq8Ar49x8kYoY3e1z9Z_NkxWnj4U7AdPPUUQ>
    <xmx:5dTvXVooMNpOzHSVxW8iqrMcGdbzqKK8Lr3p8-G3NW9cZsiMtxjsQw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CFBA8005A;
        Tue, 10 Dec 2019 12:24:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] ipv4: Notify newly added route if should be offloaded
Date:   Tue, 10 Dec 2019 19:23:57 +0200
Message-Id: <20191210172402.463397-5-idosch@idosch.org>
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

When a route is added, it should only be notified in case it is the
first route in the FIB alias list with the given {prefix, prefix length,
table ID}. Otherwise, it is not used in the data path and should not be
considered by switch drivers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_trie.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 6822aa90657a..66c7926d027d 100644
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
2.23.0

