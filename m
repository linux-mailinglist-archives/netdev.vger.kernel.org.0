Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5004C2A653E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKDNcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:10 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45909 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730125AbgKDNcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:32:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 441965C0058;
        Wed,  4 Nov 2020 08:31:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UUmYXqgVefVNVdc/JcOR+tKEA/KTMfshEPVxIsL8yRc=; b=FdHs7sj6
        brAS7+q9B3SDnfBhYAn7FDKjZa77DuiPxpv0zETZSw3o7nUQ6N/oqmOZjVHmPl/X
        xiSDOnxCSTHq7rmRliCL2v8u/QIJTzaaW09sI5Vbw1qSRgbNOQNDQ4TlOxb1jJ85
        fnHhe+wLgWo4YVioxvVXgMTmECQRu8b9jKwJC6RTykHKa2i+TetOFjMZnJ1zRZ85
        ePtt9yAnNxZEClIoLNU4zaYyR/TANCTpIxPZjArSrW1NGqXVlsB4QOyFRwRhBhxo
        esFjRyQ4F1jKXksJyE4fNGqJ2hW15vk6AzSKIUNw0k/dOVE6R9E8hwEpSH+mv0Jm
        r8lba5Ylu2u8tA==
X-ME-Sender: <xms:T62iX1n_tbxZN7UJ_ViGmQRHMwcJ5LUPr_sQbKEF6WpFMuJ5u9ziUA>
    <xme:T62iXw3L6bg7d5r9BQZSeH3L98CF4BSRqXeVgD_5O-FxBQkpoF7lGkc5-DFNoc3T1
    4tLl8YzcYSrojU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:T62iX7p6VTXVvTqZb9vDqaNxGYlXSrkgdSsHi0SAvz85KtnSvIzUjQ>
    <xmx:T62iX1nJAzZBAeK1eFYbLgLndqLSnEsBxRfAikVV2M3X0344Mfjnow>
    <xmx:T62iXz110m7DN6pmRijstFrV1REsFzTp3N9J3PXlXVrr7tJQ7Byppg>
    <xmx:T62iX0z59pI8hST8DwsTQC9e_M1FZcVkk0TAkVoDOE_h89wvhQSnlg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id D480E3064610;
        Wed,  4 Nov 2020 08:31:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/18] nexthop: Replay nexthops when registering a notifier
Date:   Wed,  4 Nov 2020 15:30:35 +0200
Message-Id: <20201104133040.1125369-14-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 9a235d5c5670..5e1b22d4f939 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -157,6 +157,27 @@ static int call_nexthop_notifiers(struct net *net,
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
@@ -2118,11 +2139,40 @@ static struct notifier_block nh_netdev_notifier = {
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

