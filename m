Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E202CC3E5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgLBRcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:32:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgLBRce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:32:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606930267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5FSPKC1ngjC7N5DGE95mQkPM7FWBcgM6EQ44XfwWhw=;
        b=A9ITDFGlA6WIIF1lNUranTap1ihVnilB2rqFAZCY0fvi+RiSxo7+w+xfHO59O7t3Nc0KVn
        O6y7zFeZFxJMukseSUPOc90qXGBrBzOYVIUHydcZ5sgiSarTdaZdwRuLkA9EYNEhZYlDB8
        qRIJIZ3nQCqQYWBmHAdaYVTKmRxb/As=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-pRBQuf3cMHGxWLXE2YsINQ-1; Wed, 02 Dec 2020 12:31:05 -0500
X-MC-Unique: pRBQuf3cMHGxWLXE2YsINQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B46E805BE4;
        Wed,  2 Dec 2020 17:31:04 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D503010016FA;
        Wed,  2 Dec 2020 17:30:59 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net v2] bonding: fix feature flag setting at init time
Date:   Wed,  2 Dec 2020 12:30:53 -0500
Message-Id: <20201202173053.13800-1-jarod@redhat.com>
In-Reply-To: <20201123031716.6179-1-jarod@redhat.com>
References: <20201123031716.6179-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't try to adjust XFRM support flags if the bond device isn't yet
registered. Bad things can currently happen when netdev_change_features()
is called without having wanted_features fully filled in yet. Basically,
this code was racing against register_netdevice() filling in
wanted_features, and when it got there first, the empty wanted_features
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

v2: rework based on further testing and suggestions from ivecera

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
 drivers/net/bonding/bond_options.c |  6 +++++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e0880a3840d7..5fe5232cc3f3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4746,15 +4746,13 @@ void bond_setup(struct net_device *bond_dev)
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
index 9abfaae1c6f7..19205cfac751 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -768,11 +768,15 @@ static int bond_option_mode_set(struct bonding *bond,
 		bond->params.tlb_dynamic_lb = 1;
 
 #ifdef CONFIG_XFRM_OFFLOAD
+	if (bond->dev->reg_state != NETREG_REGISTERED)
+		goto noreg;
+
 	if (newval->value == BOND_MODE_ACTIVEBACKUP)
 		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
 	else
 		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
+	netdev_update_features(bond->dev);
+noreg:
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't cache arp_validate between modes */
-- 
2.28.0

