Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5756E2B6F33
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgKQTqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:46:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731223AbgKQTqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:46:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605642395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lE+FZheUZpti8mdkEGCCEVmsflsjl1KanhD5yFuSSVg=;
        b=FxJhf/dA3TdyO4ZVxhWa5oFXcjlMroZvS7Rvls+NnHg1bK4HdoZVrmcABekMCMX1os+uC+
        s9EM5lbt8tXL/JbVUtTsHdq7fjhfii0zz2xGHZsrdyImd5aLUcD9R6jUZ7kROeo4UlIhdt
        Sn3sROGnF7jApULfNplQjMwjqq3yHy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-xUuBLMA8Ooy3lX038Sf8oA-1; Tue, 17 Nov 2020 14:46:33 -0500
X-MC-Unique: xUuBLMA8Ooy3lX038Sf8oA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E47A21074653;
        Tue, 17 Nov 2020 19:46:30 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-114-159.ams2.redhat.com [10.36.114.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B45A96B8E1;
        Tue, 17 Nov 2020 19:46:30 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 2D4ECA8092D; Tue, 17 Nov 2020 20:46:29 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     darcari@redhat.com
Subject: [RHEL8.4 PATCH] igc: fix link speed advertising
Date:   Tue, 17 Nov 2020 20:46:29 +0100
Message-Id: <20201117194629.178360-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link speed advertising in igc has two problems:

- When setting the advertisement via ethtool, the link speed is converted
  to the legacy 32 bit representation for the intel PHY code.
  This inadvertently drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT (being
  beyond bit 31).  As a result, any call to `ethtool -s ...' drops the
  2500Mbit/s link speed from the PHY settings.  Only reloading the driver
  alleviates that problem.

  Fix this by converting the ETHTOOL_LINK_MODE_2500baseT_Full_BIT to the
  Intel PHY ADVERTISE_2500_FULL bit explicitely.

- Rather than checking the actual PHY setting, the .get_link_ksettings
  function always fills link_modes.advertising with all link speeds
  the device is capable of.

  Fix this by checking the PHY autoneg_advertised settings and report
  only the actually advertised speeds up to ethtool.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 +++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 61d331ce38cd..75cb4ca36bac 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1675,12 +1675,18 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 	cmd->base.phy_address = hw->phy.addr;
 
 	/* advertising link modes */
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_10_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_HALF)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
+	if (hw->phy.autoneg_advertised & ADVERTISE_100_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_1000_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
+	if (hw->phy.autoneg_advertised & ADVERTISE_2500_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
 
 	/* set autoneg settings */
 	if (hw->mac.autoneg == 1) {
@@ -1792,6 +1798,12 @@ igc_ethtool_set_link_ksettings(struct net_device *netdev,
 
 	ethtool_convert_link_mode_to_legacy_u32(&advertising,
 						cmd->link_modes.advertising);
+	/* Converting to legacy u32 drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT.
+	 * We have to check this and convert it to ADVERTISE_2500_FULL
+	 * (aka ETHTOOL_LINK_MODE_2500baseX_Full_BIT) explicitely.
+	 */
+	if (ethtool_link_ksettings_test_link_mode(cmd, advertising, 2500baseT_Full))
+		advertising |= ADVERTISE_2500_FULL;
 
 	if (cmd->base.autoneg == AUTONEG_ENABLE) {
 		hw->mac.autoneg = 1;
-- 
2.27.0

