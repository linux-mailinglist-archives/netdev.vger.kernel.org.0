Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752D5260E6C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgIHJMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:55 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:39565 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729108AbgIHJLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 888C0D4B;
        Tue,  8 Sep 2020 05:11:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=a6llLcEgfDDSCI8E6SFHTt6gsTKYtGrwHnssCYfTvyQ=; b=rpFbG8pQ
        UFg1kgABUIs8dWf5/gbVleoXvS+MtlFVqpLXkf0PA+N10xmmTq9ivqE6MqwE/htZ
        UDCMEK7RQHxHbX3ujMX2HOsB19d+K50C65N6N19Lkdzp3No3SYmGFqpet/QMRpeI
        Zjxb6G6ijRQxr+y1cKzwrdqfxyUrIiJWRrYg8ESr4ALYUpz46yI20ywGKa1AEpJE
        SHaw7nfFdD9pZncBCQV04k5YynwRWa/GhAOLI7tFMD8HuATkxR+Muf2t8dG9vGII
        kOU5RbHlFPZx/dUjW9PBFT204j+VmPIrDtllVEIn8fjjU21/vlcJ+mDb8Z+8dvpI
        iCyZRb0cIJxwEw==
X-ME-Sender: <xms:10pXXwFc2uccgKGB13_D_LTvRnZu54zfOWGtSQphIJlw8cLY98fTZQ>
    <xme:10pXX5UuhN0yKpnpGShf9yw02kPsDfgwNVo69y91tQlvE5R45VPXsDrMoWkxj7lWH
    62GeJSbkz3gthY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:10pXX6IL3jHv3uI2cvKtL6NgQf8Tw2bPFP_fD3WwGhaK3ZbfZbXszg>
    <xmx:10pXXyHsOTSYfxAMxbWwRZDYN84dHig9_cbr4gFsFA-kNIeU1_Rebg>
    <xmx:10pXX2X0fs-ZaSOZn6xUFLUbjHIfRa4YjY7fVSBlHwmAXWVlgE7fBA>
    <xmx:10pXX1SGIotaIIj7cnNwFxMLWKmQJOoIhls6IP8K7SOcNbIZIPnaSA>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD3E33064682;
        Tue,  8 Sep 2020 05:11:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 17/22] nexthop: Replay nexthops when registering a notifier
Date:   Tue,  8 Sep 2020 12:10:32 +0300
Message-Id: <20200908091037.2709823-18-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When registering a new notifier to the nexthop notification chain,
replay all the existing nexthops to the new notifier so that it will
have a complete picture of the available nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 54 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index b40c343ca969..6505a0a28df2 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -156,6 +156,27 @@ static int call_nexthop_notifiers(struct net *net,
 	return notifier_to_errno(err);
 }
 
+static int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
+				 enum nexthop_event_type event_type,
+				 struct nexthop *nh,
+				 struct netlink_ext_ack *extack)
+{
+	struct nh_notifier_info info = {
+		.net = net,
+		.extack = extack,
+	};
+	int err;
+
+	err = nh_notifier_info_init(&info, nh);
+	if (err)
+		return err;
+
+	err = nb->notifier_call(nb, event_type, &info);
+	nh_notifier_info_fini(&info);
+
+	return notifier_to_errno(err);
+}
+
 static unsigned int nh_dev_hashfn(unsigned int val)
 {
 	unsigned int mask = NH_DEV_HASHSIZE - 1;
@@ -2116,11 +2137,40 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
+static int nexthops_dump(struct net *net, struct notifier_block *nb,
+			 struct netlink_ext_ack *extack)
+{
+	struct rb_root *root = &net->nexthop.rb_root;
+	struct rb_node *node;
+	int err = 0;
+
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		struct nexthop *nh;
+
+		nh = rb_entry(node, struct nexthop, rb_node);
+		err = call_nexthop_notifier(nb, net, NEXTHOP_EVENT_REPLACE, nh,
+					    extack);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
 			      struct netlink_ext_ack *extack)
 {
-	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
-						nb);
+	int err;
+
+	rtnl_lock();
+	err = nexthops_dump(net, nb, extack);
+	if (err)
+		goto unlock;
+	err = blocking_notifier_chain_register(&net->nexthop.notifier_chain,
+					       nb);
+unlock:
+	rtnl_unlock();
+	return err;
 }
 EXPORT_SYMBOL(register_nexthop_notifier);
 
-- 
2.26.2

