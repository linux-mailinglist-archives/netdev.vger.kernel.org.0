Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6689D2BFE92
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 04:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgKWDRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 22:17:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727247AbgKWDRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 22:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606101452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IpGdwt8jdg4GGv7ektWNsDixKkYiXczr59YjdWQtig8=;
        b=daE1ic0khqWnU/GqClYCJExGKqWl0wFHvKNiq5jNXz2MEX1WiUHWl2yrXkf00HOWTfAw/F
        kzZA9yzlAh6/jGQtb95MZbBtLTquX+gaSLmC81Iep1sogpRd+AmPxrLDVnjx78Cfzo4vZX
        5OBECwzuC3noNZM7ao60E0n1SEXnO0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-s5HL3oc_O7K-W82RV-NkAQ-1; Sun, 22 Nov 2020 22:17:28 -0500
X-MC-Unique: s5HL3oc_O7K-W82RV-NkAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47B871005D71;
        Mon, 23 Nov 2020 03:17:26 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643F160BF3;
        Mon, 23 Nov 2020 03:17:21 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net] bonding: fix feature flag setting at init time
Date:   Sun, 22 Nov 2020 22:17:16 -0500
Message-Id: <20201123031716.6179-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have run into a case where bond_option_mode_set() gets called before
hw_features has been filled in, and very bad things happen when
netdev_change_features() then gets called, because the empty hw_features
wipes out almost all features. Further reading of netdev feature flag
documentation suggests drivers aren't supposed to touch wanted_features,
so this changes bond_option_mode_set() to use netdev_increment_features()
and &= ~BOND_XFRM_FEATURES on mode changes and then only calling
netdev_features_change() if there was actually a change of features. This
specifically fixes bonding on top of mlxsw interfaces, and has been
regression-tested with ixgbe interfaces. This change also simplifies the
xfrm-specific code in bond_setup() a little bit as well.

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c    | 10 ++++------
 drivers/net/bonding/bond_options.c | 14 +++++++++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 71c9677d135f..b8e0cb4f9480 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4721,15 +4721,13 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
-#ifdef CONFIG_XFRM_OFFLOAD
-	bond_dev->hw_features |= BOND_XFRM_FEATURES;
-#endif /* CONFIG_XFRM_OFFLOAD */
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 #ifdef CONFIG_XFRM_OFFLOAD
-	/* Disable XFRM features if this isn't an active-backup config */
-	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-		bond_dev->features &= ~BOND_XFRM_FEATURES;
+	bond_dev->hw_features |= BOND_XFRM_FEATURES;
+	/* Only enable XFRM features if this is an active-backup config */
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
 }
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..bce34648d97d 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -748,6 +748,9 @@ const struct bond_option *bond_opt_get(unsigned int option)
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
+	netdev_features_t features = bond->dev->features;
+	netdev_features_t mask = features & BOND_XFRM_FEATURES;
+
 	if (!bond_mode_uses_arp(newval->value)) {
 		if (bond->params.arp_interval) {
 			netdev_dbg(bond->dev, "%s mode is incompatible with arp monitoring, start mii monitoring\n",
@@ -769,10 +772,15 @@ static int bond_option_mode_set(struct bonding *bond,
 
 #ifdef CONFIG_XFRM_OFFLOAD
 	if (newval->value == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
+		features = netdev_increment_features(features,
+						     BOND_XFRM_FEATURES, mask);
 	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
+		features &= ~BOND_XFRM_FEATURES;
+
+	if (bond->dev->features != features) {
+		bond->dev->features = features;
+		netdev_features_change(bond->dev);
+	}
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't cache arp_validate between modes */
-- 
2.28.0

