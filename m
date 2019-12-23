Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BCB129676
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfLWN3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:29:03 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48591 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbfLWN3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:29:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D24921C57;
        Mon, 23 Dec 2019 08:29:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8hACKGIjLK5OjYiqNuSwwSyw5hX1OzeS0u//9sTPoKk=; b=lhbKFnqu
        pRWt7CrJgBv4XN9jfy6JM+uLmeeN8N8NlvsEvAcOkkNAjFtfhdgBT4v9yeyhpWX1
        vtw6I7XSlElNbnraIbCeKS9yTV5MGOLL7eNsZfuIsm+jsbnZTREC7T6yN69h8rbs
        YqPlPUU5RJV5KWi0tJlHF4Z9+BLPOKw3FrnQd7wBv3FG97tcoZgDO261rdI28GWm
        zhFDeecb9Jg9kjMk40RvDqpKlRdFeqaXiBNUC+07jSGrgKpY3IXcxAX1ibgnF9VH
        5W7ufdAFIg0Ki8tcEiaTtqKw5g4fF+vWudtCgF1aCf0M3+23JmEMImeqMrNTuL5v
        RusOHp4JXs7eDQ==
X-ME-Sender: <xms:HcEAXgPE84xkTJW_eUn-6n9JywIMve6lujNLUCnjgnNd8TQMpazzgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:HcEAXkrgFM59I03kNDefpFycqFWSPoBbnSz-2v9CLZILD-AG5Fy5dA>
    <xmx:HcEAXhuS-TA4jlxBWMPgbVUXaz1kKmxjQOyOxj5p-3fOJK23zq1pXQ>
    <xmx:HcEAXg6ZNTjwhWU4mxai8BYeAO75FWOXVOgQgeVwy5v0-lhTExnjPg>
    <xmx:HcEAXlfOxs3bL61Id2ef32R9Of5qUAyb8zkTOSjpdmhunE5iC8bfsA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAFEA3060802;
        Mon, 23 Dec 2019 08:28:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] ipv6: Only Replay routes of interest to new listeners
Date:   Mon, 23 Dec 2019 15:28:16 +0200
Message-Id: <20191223132820.888247-6-idosch@idosch.org>
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

When a new listener is registered to the FIB notification chain it
receives a dump of all the available routes in the system. Instead, make
sure to only replay the IPv6 routes that are actually used in the data
path and are of any interest to the new listener.

This is done by iterating over all the routing tables in the given
namespace, but from each traversed node only the first route ('leaf') is
notified. Multipath routes are notified in a single notification instead
of one for each nexthop.

Add fib6_rt_dump_tmp() to do that. Later on in the patch set it will be
renamed to fib6_rt_dump() instead of the existing one.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/ip6_fib.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 7cf9554888b0..51cf848e38f0 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -370,6 +370,21 @@ static int call_fib6_entry_notifier(struct notifier_block *nb,
 	return call_fib6_notifier(nb, event_type, &info.info);
 }
 
+static int call_fib6_multipath_entry_notifier(struct notifier_block *nb,
+					      enum fib_event_type event_type,
+					      struct fib6_info *rt,
+					      unsigned int nsiblings,
+					      struct netlink_ext_ack *extack)
+{
+	struct fib6_entry_notifier_info info = {
+		.info.extack = extack,
+		.rt = rt,
+		.nsiblings = nsiblings,
+	};
+
+	return call_fib6_notifier(nb, event_type, &info.info);
+}
+
 int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
 			      struct fib6_info *rt,
@@ -414,16 +429,41 @@ static int fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 					rt, arg->extack);
 }
 
+static int fib6_rt_dump_tmp(struct fib6_info *rt, struct fib6_dump_arg *arg)
+{
+	enum fib_event_type fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+	int err;
+
+	if (!rt || rt == arg->net->ipv6.fib6_null_entry)
+		return 0;
+
+	if (rt->fib6_nsiblings)
+		err = call_fib6_multipath_entry_notifier(arg->nb, fib_event,
+							 rt,
+							 rt->fib6_nsiblings,
+							 arg->extack);
+	else
+		err = call_fib6_entry_notifier(arg->nb, fib_event, rt,
+					       arg->extack);
+
+	return err;
+}
+
 static int fib6_node_dump(struct fib6_walker *w)
 {
 	struct fib6_info *rt;
 	int err = 0;
 
+	err = fib6_rt_dump_tmp(w->leaf, w->args);
+	if (err)
+		goto out;
+
 	for_each_fib6_walker_rt(w) {
 		err = fib6_rt_dump(rt, w->args);
 		if (err)
 			break;
 	}
+out:
 	w->leaf = NULL;
 	return err;
 }
-- 
2.24.1

