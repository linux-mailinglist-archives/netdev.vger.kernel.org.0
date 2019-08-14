Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1368C805
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfHNC0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbfHNCZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:25:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE5E2084F;
        Wed, 14 Aug 2019 02:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749557;
        bh=U3nF8K1J6pAID1s02FfTJ5fMm2dy8ByM5SYkrLrAi64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlnEeAHmZn3/bb1qvr4W4g8Xt7OrcZboq6S4kFicrird/z2ewc8bp0bYU0mB1S6aU
         r8Y3VOS3u7qqjDVVGmjef1ooJpcZo/J3qZVl7gEXex6ckdxLx/pOZZwjtMf4LRLD8l
         grADGXc/V+vEdyyagP20zqeS7E9TO6oE1RTCIT0M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/28] bonding: Force slave speed check after link state recovery for 802.3ad
Date:   Tue, 13 Aug 2019 22:25:26 -0400
Message-Id: <20190814022550.17463-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022550.17463-1-sashal@kernel.org>
References: <20190814022550.17463-1-sashal@kernel.org>
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
index ed80c973f5468..fa50a4e8364c5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2079,6 +2079,15 @@ static void bond_miimon_commit(struct bonding *bond)
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

