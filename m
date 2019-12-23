Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919B5129679
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfLWN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:06 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49269 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfLWN3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 205DE21C28;
        Mon, 23 Dec 2019 08:29:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=AFbA98WguS1HU76+Xp+GKZinqJmO84AoYzOiS0u1lpA=; b=Wj6/wwSx
        SkUULMXjnoPjBLNYqBF8DhGsvHlfMeWsRv7BIC9/Cm4hbQyuhJOV/EpoXQMvn7sU
        yu5z1eUFrkp6njt8M9Czv35XvN4xD+3YTI6uJzE+jSHs2tcfxW6wTQ6Th4DXnpYD
        FfB24WwilhOQeG4i0Z623gmSpwN6P0+MTqSDJ/bpHLuCaQWTiTyKiqhXTTRRtwq5
        TxBEpMs8z5mnJepFVafeLisgh6jEq7e7VSw7QaRwo4Q/5p8qiwEAuc5VhY0B/FKS
        kf05/ysRkQ1UCW+YpcJSNuTNTg9n0g/lRFFF80ZY/xxyP72IJSbC0NQMaYFgM9d9
        iDHiSawPWMwRPg==
X-ME-Sender: <xms:IMEAXiZ6AnnA5iJecCGtYeq7a7sfnc26bQnlLReD377FgE9-YR_7Ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:IMEAXqko2CqqrjJWXpsXaxQzsOZ_BFYx_Fg7CGWoVKyNefq6k-G2rg>
    <xmx:IMEAXtWwJL98fbuvfaf1x-HvLyRfXGWLXpAqxlIYGaTpRTiH_Wlz5Q>
    <xmx:IMEAXtv3_Hb4QDUzVxUBKAcrLu4yc29K5wccB1hiJhNcaRjPsqp4_A>
    <xmx:IMEAXg_3eVD_dCHWAFd4dmf0dhrIcJV94F8PGQI4LIQmu3_jTWWjUg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE4373060802;
        Mon, 23 Dec 2019 08:29:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] ipv6: Handle multipath route deletion notification
Date:   Mon, 23 Dec 2019 15:28:18 +0200
Message-Id: <20191223132820.888247-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223132820.888247-1-idosch@idosch.org>
References: <20191223132820.888247-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When an entire multipath route is deleted, only emit a notification if
it is the first route in the node. Emit a replace notification in case
the last sibling is followed by another route. Otherwise, emit a delete
notification.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/route.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c0809f52f9ef..646716a47cc9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3749,6 +3749,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 
 	if (rt->fib6_nsiblings && cfg->fc_delete_all_nh) {
 		struct fib6_info *sibling, *next_sibling;
+		struct fib6_node *fn;
 
 		/* prefer to send a single notification with all hops */
 		skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
@@ -3764,7 +3765,32 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 				info->skip_notify = 1;
 		}
 
+		/* 'rt' points to the first sibling route. If it is not the
+		 * leaf, then we do not need to send a notification. Otherwise,
+		 * we need to check if the last sibling has a next route or not
+		 * and emit a replace or delete notification, respectively.
+		 */
 		info->skip_notify_kernel = 1;
+		fn = rcu_dereference_protected(rt->fib6_node,
+					    lockdep_is_held(&table->tb6_lock));
+		if (rcu_access_pointer(fn->leaf) == rt) {
+			struct fib6_info *last_sibling, *replace_rt;
+
+			last_sibling = list_last_entry(&rt->fib6_siblings,
+						       struct fib6_info,
+						       fib6_siblings);
+			replace_rt = rcu_dereference_protected(
+					    last_sibling->fib6_next,
+					    lockdep_is_held(&table->tb6_lock));
+			if (replace_rt)
+				call_fib6_entry_notifiers_replace(net,
+								  replace_rt);
+			else
+				call_fib6_multipath_entry_notifiers(net,
+						       FIB_EVENT_ENTRY_DEL_TMP,
+						       rt, rt->fib6_nsiblings,
+						       NULL);
+		}
 		call_fib6_multipath_entry_notifiers(net,
 						    FIB_EVENT_ENTRY_DEL,
 						    rt,
-- 
2.24.1

