Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49F94704B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfFOOJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:14 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43939 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3226321F5A;
        Sat, 15 Jun 2019 10:09:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DH7X68ngI6xks2nnu3sPUf9diXViTKNF+4u9AskinXE=; b=S34Y6Q9P
        YdaCZe+Doys3wizHsdHwne/wXjSKMl93y0vZX+yrI8jcHKKfCc1LlZfxb0Lo9fwh
        ngWADm0vMSSvCNF7gevkwLynD4a/FHXYoTp8kV740xpaSKFv8/IGQRCR/BeCULIx
        5B1a+T6LxC/XWI72eNWGH+wfxuKorFaJ6HyBOpzTr5PzUlQdivmkTw3MZo9xL4uq
        dUbRfF+pySo5Wxn19WvTi2l2V5VZzuQcB8HHjt1jMxwRc+VCxAyxdpuv4pwRGpHp
        fp0RuvDTCRSNzm7cJC61z+6bkhbsM8hZdRuJeY4OLIlsUPhiLpeDHqNT4T050bYg
        5aMETUlVJikJUw==
X-ME-Sender: <xms:CfwEXeBQcZUbRhVAWPBD7F_z7DSxz7S7iteFbtGcB-OQ3ei_5eckMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:CfwEXaNetiMn3D9zEaRRznqVxFMQblNqRGMWK7yz_6EItLffE4nbuw>
    <xmx:CfwEXRBjexXwQCIW72yAdQybL56ulgkvL4ET4zScuD09yXN_GPJnDw>
    <xmx:CfwEXWZDqHh3dyo7p6H74EmqEo3ZXRI-YV4ga13r02WB5HCDOL2lEw>
    <xmx:CfwEXYsi_fzger2Wc-V4Mq3b82vzhBE5N8VXlGno38SIK_jMHmsm4w>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80A93380088;
        Sat, 15 Jun 2019 10:09:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/17] netlink: Add field to skip in-kernel notifications
Date:   Sat, 15 Jun 2019 17:07:36 +0300
Message-Id: <20190615140751.17661-3-idosch@idosch.org>
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

The struct includes a 'skip_notify' flag that indicates if netlink
notifications to user space should be suppressed. As explained in commit
3b1137fe7482 ("net: ipv6: Change notifications for multipath add to
RTA_MULTIPATH"), this is useful to suppress per-nexthop RTM_NEWROUTE
notifications when an IPv6 multipath route is added / deleted. Instead,
one notification is sent for the entire multipath route.

This concept is also useful for in-kernel notifications. Sending one
in-kernel notification for the addition / deletion of an IPv6 multipath
route - instead of one per-nexthop - provides a significant increase in
the insertion / deletion rate to underlying devices.

Add a 'skip_notify_kernel' flag to suppress in-kernel notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netlink.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index ce66e43b9b6a..e4650e5b64a1 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -381,12 +381,14 @@ struct nla_policy {
  * @nl_net: Network namespace
  * @portid: Netlink PORTID of requesting application
  * @skip_notify: Skip netlink notifications to user space
+ * @skip_notify_kernel: Skip selected in-kernel notifications
  */
 struct nl_info {
 	struct nlmsghdr		*nlh;
 	struct net		*nl_net;
 	u32			portid;
-	bool			skip_notify;
+	u8			skip_notify:1,
+				skip_notify_kernel:1;
 };
 
 /**
-- 
2.20.1

