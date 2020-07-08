Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFAD218ED3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGHRq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41926 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgGHRqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594230413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Os4K120anUXrDwQjbfDJHVlMkw60r/Vo+SDW/vSPhzg=;
        b=Uypg84ExSNf9ILLZcFZaCt8Qaq0l+sqjM3fpsz//Ucxwt/8LpRBFLJdfVyezVUlEx//pBT
        tc6WKHRpulqFHAqIZ03EEucc/r07g+auoOzcUVFrBJsDxmvkqkH2lF5GuvTPwLRt5A/2cN
        FIrp5K89D0awsDR2GtK9HzozVXAlHz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-xdu2Hyo9OcK0JA85iGKAOg-1; Wed, 08 Jul 2020 13:46:49 -0400
X-MC-Unique: xdu2Hyo9OcK0JA85iGKAOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F7B988C799;
        Wed,  8 Jul 2020 17:46:47 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0391C5C1B2;
        Wed,  8 Jul 2020 17:46:42 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next] bonding: deal with xfrm state in all modes and add more error-checking
Date:   Wed,  8 Jul 2020 13:46:31 -0400
Message-Id: <20200708174631.15286-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that device removal happens when the bond is in non-AB mode,
and addition happens in AB mode, so bond_ipsec_del_sa() never gets called,
which leaves security associations in an odd state if bond_ipsec_add_sa()
then gets called after switching the bond into AB. Just call add and
delete universally for all modes to keep things consistent.

However, it's also possible that this code gets called when the system is
shutting down, and the xfrm subsystem has already been disconnected from
the bond device, so we need to do some error-checking and bail, lest we
hit a null ptr deref.

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
CC: Huy Nguyen <huyn@mellanox.com>
CC: Saeed Mahameed <saeedm@mellanox.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 39 +++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2adf6ce20a38..f886d97c4359 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -383,9 +383,14 @@ static int bond_vlan_rx_kill_vid(struct net_device *bond_dev,
 static int bond_ipsec_add_sa(struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
-	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = rtnl_dereference(bond->curr_active_slave);
+	struct bonding *bond;
+	struct slave *slave;
 
+	if (!bond_dev)
+		return -EINVAL;
+
+	bond = netdev_priv(bond_dev);
+	slave = rtnl_dereference(bond->curr_active_slave);
 	xs->xso.real_dev = slave->dev;
 	bond->xs = xs;
 
@@ -405,8 +410,14 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 static void bond_ipsec_del_sa(struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
-	struct bonding *bond = netdev_priv(bond_dev);
-	struct slave *slave = rtnl_dereference(bond->curr_active_slave);
+	struct bonding *bond;
+	struct slave *slave;
+
+	if (!bond_dev)
+		return;
+
+	bond = netdev_priv(bond_dev);
+	slave = rtnl_dereference(bond->curr_active_slave);
 
 	if (!slave)
 		return;
@@ -960,12 +971,12 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 	if (old_active == new_active)
 		return;
 
-	if (new_active) {
 #ifdef CONFIG_XFRM_OFFLOAD
-		if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) && bond->xs)
-			bond_ipsec_del_sa(bond->xs);
+	if (old_active && bond->xs)
+		bond_ipsec_del_sa(bond->xs);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
+	if (new_active) {
 		new_active->last_link_up = jiffies;
 
 		if (new_active->link == BOND_LINK_BACK) {
@@ -1028,13 +1039,6 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 					bond_should_notify_peers(bond);
 			}
 
-#ifdef CONFIG_XFRM_OFFLOAD
-			if (old_active && bond->xs) {
-				xfrm_dev_state_flush(dev_net(bond->dev), bond->dev, true);
-				bond_ipsec_add_sa(bond->xs);
-			}
-#endif /* CONFIG_XFRM_OFFLOAD */
-
 			call_netdevice_notifiers(NETDEV_BONDING_FAILOVER, bond->dev);
 			if (should_notify_peers) {
 				bond->send_peer_notif--;
@@ -1044,6 +1048,13 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 		}
 	}
 
+#ifdef CONFIG_XFRM_OFFLOAD
+	if (new_active && bond->xs) {
+		xfrm_dev_state_flush(dev_net(bond->dev), bond->dev, true);
+		bond_ipsec_add_sa(bond->xs);
+	}
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 	/* resend IGMP joins since active slave has changed or
 	 * all were sent on curr_active_slave.
 	 * resend only if bond is brought up with the affected
-- 
2.20.1

