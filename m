Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4977F2CFC5D
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgLERoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 12:44:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727496AbgLERmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 12:42:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607190017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i4l8pC0ZVpmyeGoUVE05XOBDw9b0P2zcxvMhFLJB3uQ=;
        b=PsNbkgzkVCZ9KdQgT9whbAiXpoT5mUbsjyepLDRPSEijitOZKhJmGyScE9Fp5eteA+AJFl
        WIbb84AhigTPbvLzdG9ODtH5UE49Ic8uGmyM4wTPgxNeQ9aNs0n2reg/xJqsmJ0Z6JhwyU
        B90BeViuHwZ5ET4RkvnAtI3G9pUYRwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-jRk5ZDi5OsSD9uHoc9ZX7g-1; Sat, 05 Dec 2020 12:40:14 -0500
X-MC-Unique: jRk5ZDi5OsSD9uHoc9ZX7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FA575189;
        Sat,  5 Dec 2020 17:40:12 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23AD919C59;
        Sat,  5 Dec 2020 17:40:08 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next] bonding: set xfrm feature flags more sanely
Date:   Sat,  5 Dec 2020 12:40:03 -0500
Message-Id: <20201205174003.578267-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove one of the ifdef blocks here, and instead of setting both
the xfrm hw_features and features flags, then unsetting the the features
flags if not in AB, wait to set the features flags if we're actually in AB
mode.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

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
 
-- 
2.28.0

