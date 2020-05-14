Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA161D3738
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgENRAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:00:44 -0400
Received: from foss.arm.com ([217.140.110.172]:40676 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgENRAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 13:00:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 663061042;
        Thu, 14 May 2020 10:00:43 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E4513F71E;
        Thu, 14 May 2020 10:00:43 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH] net: phy: Fix c45 no phy detected logic
Date:   Thu, 14 May 2020 12:00:25 -0500
Message-Id: <20200514170025.1379981-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit "disregard Clause 22 registers present bit..." clears
the low bit of the devices_in_package data which is being used
in get_phy_c45_ids() to determine if a phy/register is responding
correctly. That check is against 0x1FFFFFFF, but since the low
bit is always cleared, the check can never be true. This leads to
detecting c45 phy devices where none exist.

Lets fix this by also clearing the low bit in the mask to 0x1FFFFFFE.
This allows us to continue to autoprobe standards compliant devices
without also gaining a large number of bogus ones.

Fixes: 3b5e74e0afe3 ("net: phy: disregard "Clause 22 registers present" bit in get_phy_c45_devs_in_pkg")
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ac2784192472..b93d984d35cc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -723,7 +723,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 		if (phy_reg < 0)
 			return -EIO;
 
-		if ((*devs & 0x1fffffff) == 0x1fffffff) {
+		if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
 			/*  If mostly Fs, there is no device there,
 			 *  then let's continue to probe more, as some
 			 *  10G PHYs have zero Devices In package,
@@ -733,7 +733,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			if (phy_reg < 0)
 				return -EIO;
 			/* no device there, let's get out of here */
-			if ((*devs & 0x1fffffff) == 0x1fffffff) {
+			if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
 				*phy_id = 0xffffffff;
 				return 0;
 			} else {
-- 
2.24.1

