Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6CF2CCB28
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgLCApi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:45:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgLCApi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:45:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606956251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EDCn101SFARHTTM1x2YExb2aB0Hg6FLAdBXqacqkCk=;
        b=RBvEf7s/PrSRXt2ZI4gThx59rigaUBPcT5DEaTAjGcu9h2Re/kD0c99GYk+bybxbq2gAlo
        URPeQL02MLJfjVUuvQPm5e4OkSKyq6cOa8Xzg5RnT2kRVtPHXQwQg5h40e9SA11kr0J8bo
        3drx5FWlwdWQR9meURS0f4Jb2svn7Uo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-v018RCeoPrS-9pv7ITQBjQ-1; Wed, 02 Dec 2020 19:44:07 -0500
X-MC-Unique: v018RCeoPrS-9pv7ITQBjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA6751007463;
        Thu,  3 Dec 2020 00:44:05 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A36F810013C0;
        Thu,  3 Dec 2020 00:44:00 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net v3] bonding: fix feature flag setting at init time
Date:   Wed,  2 Dec 2020 19:43:57 -0500
Message-Id: <20201203004357.3125-1-jarod@redhat.com>
In-Reply-To: <20201202173053.13800-1-jarod@redhat.com>
References: <20201202173053.13800-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't try to adjust XFRM support flags if the bond device isn't yet
registered. Bad things can currently happen when netdev_change_features()
is called without having wanted_features fully filled in yet. This code
runs on post-module-load mode changes, as well as at module init time
and new bond creation time, and in the latter two scenarios, it is
running prior to register_netdevice() having been called and
subsequently filling in wanted_features. The empty wanted_features led
to features also getting emptied out, which was definitely not the
intended behavior, so prevent that from happening.

Originally, I'd hoped to stop adjusting wanted_features at all in the
bonding driver, as it's documented as being something only the network
core should touch, but we actually do need to do this to properly update
both the features and wanted_features fields when changing the bond type,
or we get to a situation where ethtool sees:

    esp-hw-offload: off [requested on]

I do think we should be using netdev_update_features instead of
netdev_change_features here though, so we only send notifiers when the
features actually changed.

v2: rework based on further testing and suggestions from ivecera
v3: add helper function, remove goto, fix problem description

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Suggested-by: Ivan Vecera <ivecera@redhat.com>
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
 drivers/net/bonding/bond_options.c | 19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 47afc5938c26..7905534a763b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4747,15 +4747,13 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
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
index 9abfaae1c6f7..1ae0e5ab8c67 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -745,6 +745,18 @@ const struct bond_option *bond_opt_get(unsigned int option)
 	return &bond_opts[option];
 }
 
+#ifdef CONFIG_XFRM_OFFLOAD
+static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+{
+	if (mode == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	else
+		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+
+	netdev_update_features(bond_dev);
+}
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
@@ -768,11 +780,8 @@ static int bond_option_mode_set(struct bonding *bond,
 		bond->params.tlb_dynamic_lb = 1;
 
 #ifdef CONFIG_XFRM_OFFLOAD
-	if (newval->value == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
-	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		bond_set_xfrm_features(bond->dev, newval->value);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't cache arp_validate between modes */
-- 
2.28.0

