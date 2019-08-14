Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A208C711
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfHNCSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbfHNCSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:18:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA81216F4;
        Wed, 14 Aug 2019 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749125;
        bh=J6mQ9/2igUrWkfb/ewDtRr+g54jLGwhZCXQHjwUToLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZ754ViXg2yrGoUwH8q4F1e7FQ6Pmu2se4fO5SnMopLEDfW+SBbbuyGvimU6ocssf
         lfP9RFNs/K8kYvAVZQm8+AqXv0zrWQFbR611yM6fnsOc1hl9gxoWs1uEHmWHtGPXSL
         WkMB+przNa5z9hbkIM3dKlAYN2JxlRQRmUyErXZ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/44] bonding: Force slave speed check after link state recovery for 802.3ad
Date:   Tue, 13 Aug 2019 22:17:56 -0400
Message-Id: <20190814021834.16662-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 12185dfe44360f814ac4ead9d22ad2af7511b2e9 ]

The following scenario was encountered during testing of logical
partition mobility on pseries partitions with bonded ibmvnic
adapters in LACP mode.

1. Driver receives a signal that the device has been
   swapped, and it needs to reset to initialize the new
   device.

2. Driver reports loss of carrier and begins initialization.

3. Bonding driver receives NETDEV_CHANGE notifier and checks
   the slave's current speed and duplex settings. Because these
   are unknown at the time, the bond sets its link state to
   BOND_LINK_FAIL and handles the speed update, clearing
   AD_PORT_LACP_ENABLE.

4. Driver finishes recovery and reports that the carrier is on.

5. Bond receives a new notification and checks the speed again.
   The speeds are valid but miimon has not altered the link
   state yet.  AD_PORT_LACP_ENABLE remains off.

Because the slave's link state is still BOND_LINK_FAIL,
no further port checks are made when it recovers. Though
the slave devices are operational and have valid speed
and duplex settings, the bond will not send LACPDU's. The
simplest fix I can see is to force another speed check
in bond_miimon_commit. This way the bond will update
AD_PORT_LACP_ENABLE if needed when transitioning from
BOND_LINK_FAIL to BOND_LINK_UP.

CC: Jarod Wilson <jarod@redhat.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 11a0e84d3d7cb..68e28346a367f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2151,6 +2151,15 @@ static void bond_miimon_commit(struct bonding *bond)
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->new_link) {
 		case BOND_LINK_NOCHANGE:
+			/* For 802.3ad mode, check current slave speed and
+			 * duplex again in case its port was disabled after
+			 * invalid speed/duplex reporting but recovered before
+			 * link monitoring could make a decision on the actual
+			 * link status
+			 */
+			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
+			    slave->link == BOND_LINK_UP)
+				bond_3ad_adapter_speed_duplex_changed(slave);
 			continue;
 
 		case BOND_LINK_UP:
-- 
2.20.1

