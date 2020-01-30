Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9214DB20
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 14:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgA3M76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 07:59:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgA3M76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 07:59:58 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A4320702;
        Thu, 30 Jan 2020 12:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580389197;
        bh=JNIF4xcLS3EAgcYhSNk8/FL+grLMS1nHKvBUas/mkUg=;
        h=From:To:Cc:Subject:Date:From;
        b=puhLDowyJtgsIqAaqATZn1NpW4QsZ7JLcN28ekoCeyYQhw97oUMwKAdDLTt4gmcIP
         jLlxh4qIiySpPwxLQBjZr53K6JaVfwczd3DMGsDSHvqSBi//O7/3DG0Ju5RSDUT3YH
         R+AprRJ9JJrfFOn6jt6uX32vwiF6z49EEdWHdP1o=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Adrian Chiris <adrianc@mellanox.com>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net] net/core: Do not clear VF index for node/port GUIDs query
Date:   Thu, 30 Jan 2020 14:59:49 +0200
Message-Id: <20200130125949.409354-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

VF numbers were assigned to node_guid and port_guid, but cleared
right before such query calls were issued. It caused to return
node/port GUIDs of VF index 0 for all VFs.

Fixes: 30aad41721e0 ("net/core: Add support for getting VF GUIDs")
Reported-by: Adrian Chiris <adrianc@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cdad6ed532c4..09c44bf2e1d2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1242,6 +1242,8 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		return 0;

 	memset(&vf_vlan_info, 0, sizeof(vf_vlan_info));
+	memset(&node_guid, 0, sizeof(node_guid));
+	memset(&port_guid, 0, sizeof(port_guid));

 	vf_mac.vf =
 		vf_vlan.vf =
@@ -1290,8 +1292,6 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		    sizeof(vf_trust), &vf_trust))
 		goto nla_put_vf_failure;

-	memset(&node_guid, 0, sizeof(node_guid));
-	memset(&port_guid, 0, sizeof(port_guid));
 	if (dev->netdev_ops->ndo_get_vf_guid &&
 	    !dev->netdev_ops->ndo_get_vf_guid(dev, vfs_num, &node_guid,
 					      &port_guid)) {
--
2.24.1

