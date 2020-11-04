Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806382A653A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgKDNcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45185 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730115AbgKDNb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C1B445C0046;
        Wed,  4 Nov 2020 08:31:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Cxck7dWikpSknh4+UznGOZqgkAAKanpNBw10M8kH7Wo=; b=nYtIPCkE
        9I6Vc/lJo2Ch6PZ4QsX/iIryqIES2JjL+B0SR9YER30KnUBO2FBLPeHp+YELY5JA
        xR8JlUBCAuNWhh0NpB+wYraN4trvyMXaUEMpJ/t4Zodlhafc0h9LT9uJW4oxCGAZ
        o9uKHlwYeLFWLghqfMCyS4QheKD/LqSdRGPhaXLNeQY4wRtQisN1ArvmLfndpV9J
        QaiiwiZaE1V0V3VJM6bCrYrIcXh+v8ONlA1BK8C+sbiv824v8IGHv1askVrR3A0C
        9a8oFyQPLgHKj92Tt7szPCEo8cf4gsz78VduoAoAbaplEt4XUiwkj7b/HfV/021L
        CwjIMLFORC3prg==
X-ME-Sender: <xms:Ta2iX4EbNaOe-pzCGiVVGlMBvpNxhxeViE-p6DO3Pp9n4q7Au91StQ>
    <xme:Ta2iXxW4NLXuG3cuqQlUTJajgxZH7f6g_iqLONOZq1ssH5_7ZA_kWQQjVZgOO24BW
    cbBiRquTqYVM0Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedutdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ta2iXyKXkWX7Tz88PmKLRCc7uQ_vb1OI4lYiN1wDHwnKlURxKm3V6Q>
    <xmx:Ta2iX6FRASGeDWe2raxefiOf9JA5LLrymqwXApsVrmcJaP11wHOpRQ>
    <xmx:Ta2iX-UrllfqWl-JAaF77QRZGAril7CmzUoGt11Hjwm3yONGCMm0lw>
    <xmx:Ta2iX9TXpFcXLBexx4_6vATb2Mdx6aoMpWmOFbnpNHypPpSFz0H-ug>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BA1D3064610;
        Wed,  4 Nov 2020 08:31:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/18] nexthop: Pass extack to register_nexthop_notifier()
Date:   Wed,  4 Nov 2020 15:30:34 +0200
Message-Id: <20201104133040.1125369-13-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This will be used by the next patch which extends the function to replay
all the existing nexthops to the notifier block being registered.

Device drivers will be able to pass extack to the function since it is
passed to them upon reload from devlink.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/vxlan.c   | 3 ++-
 include/net/nexthop.h | 3 ++-
 net/ipv4/nexthop.c    | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9db20b4ebfd..183e708dc6cb 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4711,7 +4711,8 @@ static __net_init int vxlan_init_net(struct net *net)
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return register_nexthop_notifier(net, &vn->nexthop_notifier_block);
+	return register_nexthop_notifier(net, &vn->nexthop_notifier_block,
+					 NULL);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 9c85199b826e..226930d66b63 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -144,7 +144,8 @@ struct nh_notifier_info {
 	};
 };
 
-int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
+			      struct netlink_ext_ack *extack);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d5a2c28bea49..9a235d5c5670 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2118,7 +2118,8 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
-int register_nexthop_notifier(struct net *net, struct notifier_block *nb)
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
+			      struct netlink_ext_ack *extack)
 {
 	return blocking_notifier_chain_register(&net->nexthop.notifier_chain,
 						nb);
-- 
2.26.2

