Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC2129677
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLWN3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:04 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43017 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfLWN3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C4ACF21BBA;
        Mon, 23 Dec 2019 08:28:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:28:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ka56UIaZ2c29QTHRBQWvkWSodGaLodu/2i/tO6dP7uQ=; b=tXmzFM+v
        onoctCy3eS6WG6GFi168NoMAYVMT8YhXmqGNZlw9s7c5Lb7jLgPqC0YY/XrNvHs6
        zF0Fueh+5j13UskrwxjmukGs2uAA3JJwqlNkXwOUIL4K9YPpMGhEla14DnMwtpEb
        exdwOAurP8gtlm8bhzSKdTOo+zMCawnDLPwd5WQln+S331Y70Aae6KGDi9q3SobN
        /9lGoWgr4HTBbr3nyezi8Ye5dCMpy68MQw23AIoD3plm8FIUkL3b80m43cV2wSOV
        frwGJmGSZv3vYmpKtidlwCxBQw2RLuU2mbqzLnqX4WeHmSM67WFgi1ZKR6sW1L6h
        1JyXXOjFOM4HXQ==
X-ME-Sender: <xms:G8EAXqJCgqXpsARnc7kXwmlZW46KjU8gSYBT_AUvAXVe7WbMaNjVRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:G8EAXh2tJvNLOw8ZpqF215iPgPLkDM-n7I0nSOohxpFL8-NmdOdZlg>
    <xmx:G8EAXmVJNGZmkFkOLXneYuzaCy5YoLW5aNKdLP24KxPx7wPat-iHmw>
    <xmx:G8EAXrNBnrRRBkBjXJLaJZRNlpRhpQ7MaRz4rLYocwZrDbqw8_-5_g>
    <xmx:G8EAXnNFwVbZM25x9W5674OPRkZqFMsnhpKCpquwHohGnv_5nq2x9w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D04D3060A88;
        Mon, 23 Dec 2019 08:28:58 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] ipv6: Notify multipath route if should be offloaded
Date:   Mon, 23 Dec 2019 15:28:15 +0200
Message-Id: <20191223132820.888247-5-idosch@idosch.org>
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

In a similar fashion to previous patches, only notify the new multipath
route if it is the first route in the node or if it was appended to such
route.

The type of the notification (replace vs. append) is determined based on
the number of routes added ('nhn') and the number of sibling routes. If
the two do not match, then an append notification should be sent.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/route.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b59940416cb5..c0809f52f9ef 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5017,6 +5017,32 @@ static void ip6_route_mpath_notify(struct fib6_info *rt,
 		inet6_rt_notify(RTM_NEWROUTE, rt, info, nlflags);
 }
 
+static bool ip6_route_mpath_should_notify(const struct fib6_info *rt)
+{
+	bool rt_can_ecmp = rt6_qualify_for_ecmp(rt);
+	bool should_notify = false;
+	struct fib6_info *leaf;
+	struct fib6_node *fn;
+
+	rcu_read_lock();
+	fn = rcu_dereference(rt->fib6_node);
+	if (!fn)
+		goto out;
+
+	leaf = rcu_dereference(fn->leaf);
+	if (!leaf)
+		goto out;
+
+	if (rt == leaf ||
+	    (rt_can_ecmp && rt->fib6_metric == leaf->fib6_metric &&
+	     rt6_qualify_for_ecmp(leaf)))
+		should_notify = true;
+out:
+	rcu_read_unlock();
+
+	return should_notify;
+}
+
 static int ip6_route_multipath_add(struct fib6_config *cfg,
 				   struct netlink_ext_ack *extack)
 {
@@ -5147,6 +5173,28 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 		nhn++;
 	}
 
+	/* An in-kernel notification should only be sent in case the new
+	 * multipath route is added as the first route in the node, or if
+	 * it was appended to it. We pass 'rt_notif' since it is the first
+	 * sibling and might allow us to skip some checks in the replace case.
+	 */
+	if (ip6_route_mpath_should_notify(rt_notif)) {
+		enum fib_event_type fib_event;
+
+		if (rt_notif->fib6_nsiblings != nhn - 1)
+			fib_event = FIB_EVENT_ENTRY_APPEND;
+		else
+			fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+
+		err = call_fib6_multipath_entry_notifiers(info->nl_net,
+							  fib_event, rt_notif,
+							  nhn - 1, extack);
+		if (err) {
+			/* Delete all the siblings that were just added */
+			err_nh = NULL;
+			goto add_errout;
+		}
+	}
 	event_type = replace ? FIB_EVENT_ENTRY_REPLACE : FIB_EVENT_ENTRY_ADD;
 	err = call_fib6_multipath_entry_notifiers(info->nl_net, event_type,
 						  rt_notif, nhn - 1, extack);
-- 
2.24.1

