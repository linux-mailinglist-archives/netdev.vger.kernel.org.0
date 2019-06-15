Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992AC4704C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfFOOJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48105 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 93FD221F41;
        Sat, 15 Jun 2019 10:09:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JJX5MAWwp6Er0wEvZXBmD9JuQSWfBKYhv8wUtOnu9mw=; b=I8Rf8Suo
        Fu8DxXMW4bls9wkPbXmo6V4MoDHRn2fJkIz0znNebACint07tJV9UoQS6D/lGfIm
        h56i9Qwectl/A7iAIts3XiiRtXoIeNIpTIe5ddEVQ5QLhRyWYZiO7hx/XniDoqw5
        xJneMcBH3AVUUvog0xscJAQ6Oq2RhFqO9FUAZ6LYNUWt5WJMcgOOjX/ZBTfPtEnD
        xdT8GTxlgdzengAIBDKiqfKCIksZKcdsLUPrXgtKu9rgZgw4DHriFenCR2+OeDhO
        1EXRmHeYXFcZrq07qFW/yyMo1koSr0elF/zn77DvnYt8aeTkLAjJYcrwURGzoVdx
        MRHPh0vgQFVzig==
X-ME-Sender: <xms:DPwEXcic1hb4gR4qECVJRJJZkZyRHEJIS62JIxehlhJE4ZSw5s_SuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:DPwEXR0YBKumXuJ0YRtNnt-cSY1d7MV2GNa4SAW-y--EHjF7k7SDVA>
    <xmx:DPwEXe82zIOzEw_0KikN9a8wcx59s4BXLTrN2nUuksyEvnAN2jp1Ag>
    <xmx:DPwEXYI_NayNcusYbmHZr-eSv6dM_40HoIkHtiZ9IrfHu7PmC0Zzmw>
    <xmx:DPwEXU7DVyG0oVwYlT8qbWXy-0SK8iXzPkAZUrzp5yBzjTnKt3TtyA>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77CB4380085;
        Sat, 15 Jun 2019 10:09:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/17] ipv6: Extend notifier info for multipath routes
Date:   Sat, 15 Jun 2019 17:07:37 +0300
Message-Id: <20190615140751.17661-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Extend the IPv6 FIB notifier info with number of sibling routes being
notified.

This will later allow listeners to process one notification for a
multipath routes instead of N, where N is the number of nexthops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip6_fib.h |  7 +++++++
 net/ipv6/ip6_fib.c    | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 1e92f1500b87..a0c91fc59eea 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -377,6 +377,8 @@ typedef struct rt6_info *(*pol_lookup_t)(struct net *,
 struct fib6_entry_notifier_info {
 	struct fib_notifier_info info; /* must be first */
 	struct fib6_info *rt;
+	unsigned int nsiblings;	/* Only valid when 'multipath_rt' is set */
+	bool multipath_rt;
 };
 
 /*
@@ -450,6 +452,11 @@ int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
 			      struct fib6_info *rt,
 			      struct netlink_ext_ack *extack);
+int call_fib6_multipath_entry_notifiers(struct net *net,
+					enum fib_event_type event_type,
+					struct fib6_info *rt,
+					unsigned int nsiblings,
+					struct netlink_ext_ack *extack);
 void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		    struct nl_info *info);
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1cce2082279c..df08ba8fe6fc 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -381,6 +381,23 @@ int call_fib6_entry_notifiers(struct net *net,
 	return call_fib6_notifiers(net, event_type, &info.info);
 }
 
+int call_fib6_multipath_entry_notifiers(struct net *net,
+					enum fib_event_type event_type,
+					struct fib6_info *rt,
+					unsigned int nsiblings,
+					struct netlink_ext_ack *extack)
+{
+	struct fib6_entry_notifier_info info = {
+		.info.extack = extack,
+		.rt = rt,
+		.nsiblings = nsiblings,
+		.multipath_rt = true,
+	};
+
+	rt->fib6_table->fib_seq++;
+	return call_fib6_notifiers(net, event_type, &info.info);
+}
+
 struct fib6_dump_arg {
 	struct net *net;
 	struct notifier_block *nb;
-- 
2.20.1

