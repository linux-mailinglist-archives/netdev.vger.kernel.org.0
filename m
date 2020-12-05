Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7A2CFCF0
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgLEST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727858AbgLERra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 12:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607190361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/gLGPmePhuO2f+EARH9bT98ZpjrYraDFm24BynZYug=;
        b=Z2k7rQmlQZN5GfKq1fMxsOExRscmOPMzn59gKZ1uVAPioSxq9OdBnAEUb4zI4dHeV1WiIP
        LB9akMCltOAkBEKDv2WD7dG9WeHfIqGQ/buVCX4X2uCR+U+ofVwhtnwqwgeZVw8eoKnhYo
        czGOehuv+qCbbCzaQ3NqN7+vJatFGZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-7Uinrg3KOaSUE9_ZDuhMHQ-1; Sat, 05 Dec 2020 12:22:42 -0500
X-MC-Unique: 7Uinrg3KOaSUE9_ZDuhMHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10EA1107ACE4;
        Sat,  5 Dec 2020 17:22:41 +0000 (UTC)
Received: from f33vm.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46DE35D6D5;
        Sat,  5 Dec 2020 17:22:36 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net v4] bonding: fix feature flag setting at init time
Date:   Sat,  5 Dec 2020 12:22:29 -0500
Message-Id: <20201205172229.576587-1-jarod@redhat.com>
In-Reply-To: <20201203004357.3125-1-jarod@redhat.com>
References: <20201203004357.3125-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't try to adjust XFRM support flags if the bond device isn't yet
registered. Bad things can currently happen when netdev_change_features()
is called without having wanted_features fully filled in yet. This code
runs both on post-module-load mode changes, as well as at module init
time, and when run at module init time, it is before register_netdevice()
has been called and filled in wanted_features. The empty wanted_features
led to features also getting emptied out, which was definitely not the
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
v2: rework based on further testing and suggestions from ivecera
v3: add helper function, remove goto
v4: drop hunk not directly related to fix, clean up ifdeffery

 drivers/net/bonding/bond_options.c | 22 +++++++++++++++-------
 include/net/bonding.h              |  2 --
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..a4e4e15f574d 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -745,6 +745,19 @@ const struct bond_option *bond_opt_get(unsigned int option)
 	return &bond_opts[option];
 }
 
+static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+{
+	if (!IS_ENABLED(CONFIG_XFRM_OFFLOAD))
+		return;
+
+	if (mode == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	else
+		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+
+	netdev_update_features(bond_dev);
+}
+
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
@@ -767,13 +780,8 @@ static int bond_option_mode_set(struct bonding *bond,
 	if (newval->value == BOND_MODE_ALB)
 		bond->params.tlb_dynamic_lb = 1;
 
-#ifdef CONFIG_XFRM_OFFLOAD
-	if (newval->value == BOND_MODE_ACTIVEBACKUP)
-		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
-	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
-#endif /* CONFIG_XFRM_OFFLOAD */
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		bond_set_xfrm_features(bond->dev, newval->value);
 
 	/* don't cache arp_validate between modes */
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index d9d0ff3b0ad3..adc3da776970 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -86,10 +86,8 @@
 #define bond_for_each_slave_rcu(bond, pos, iter) \
 	netdev_for_each_lower_private_rcu((bond)->dev, pos, iter)
 
-#ifdef CONFIG_XFRM_OFFLOAD
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
-#endif /* CONFIG_XFRM_OFFLOAD */
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
-- 
2.28.0

