Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5183415994
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfEGFiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbfEGFiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C2521530;
        Tue,  7 May 2019 05:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207480;
        bh=dxV053zhGb4G++2yO2/3vvKS9KiYcm1mq0KoO8T0WdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mw8amyw9NJum7BkuRZ/pGbXJCo+VEj0fWcTzbNbTOB18w9/HTW5PIiiQi/xFTaSHr
         bRmzO/NKSAwTZNCfCA6I9GH9OCBqPJ6JJAR4DYHdphXEMFIg98t7OKBVPGF9XbR4G+
         Zgw2m4QLISqJZVfe+kJE0s+3Iwkp6knzm3RZc8zg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 66/81] net: dsa: mv88e6xxx: fix few issues in mv88e6390x_port_set_cmode
Date:   Tue,  7 May 2019 01:35:37 -0400
Message-Id: <20190507053554.30848-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 5ceaeb99ffb4dc002d20f6ac243c19a85e2c7a76 ]

This patches fixes few issues in mv88e6390x_port_set_cmode().

1. When entering the function the old cmode may be 0, in this case
   mv88e6390x_serdes_get_lane() returns -ENODEV. As result we bail
   out and have no chance to set a new mode. Therefore deal properly
   with -ENODEV.

2. Once we have disabled power and irq, let's set the cached cmode to 0.
   This reflects the actual status and is cleaner if we bail out with an
   error in the following function calls.

3. The cached cmode is used by mv88e6390x_serdes_get_lane(),
   mv88e6390_serdes_power_lane() and mv88e6390_serdes_irq_enable().
   Currently we set the cached mode to the new one at the very end of
   the function only, means until then we use the old one what may be
   wrong.

4. When calling mv88e6390_serdes_irq_enable() we use the lane value
   belonging to the old cmode. Get the lane belonging to the new cmode
   before calling this function.

It's hard to provide a good "Fixes" tag because quite a few smaller
changes have been done to the code in question recently.

Fixes: d235c48b40d3 ("net: dsa: mv88e6xxx: power serdes on/off for 10G interfaces on 6390X")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/dsa/mv88e6xxx/port.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fffce734f0a..fdeddbfa829d 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -379,18 +379,22 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		return 0;
 
 	lane = mv88e6390x_serdes_get_lane(chip, port);
-	if (lane < 0)
+	if (lane < 0 && lane != -ENODEV)
 		return lane;
 
-	if (chip->ports[port].serdes_irq) {
-		err = mv88e6390_serdes_irq_disable(chip, port, lane);
+	if (lane >= 0) {
+		if (chip->ports[port].serdes_irq) {
+			err = mv88e6390_serdes_irq_disable(chip, port, lane);
+			if (err)
+				return err;
+		}
+
+		err = mv88e6390x_serdes_power(chip, port, false);
 		if (err)
 			return err;
 	}
 
-	err = mv88e6390x_serdes_power(chip, port, false);
-	if (err)
-		return err;
+	chip->ports[port].cmode = 0;
 
 	if (cmode) {
 		err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
@@ -404,6 +408,12 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 
+		chip->ports[port].cmode = cmode;
+
+		lane = mv88e6390x_serdes_get_lane(chip, port);
+		if (lane < 0)
+			return lane;
+
 		err = mv88e6390x_serdes_power(chip, port, true);
 		if (err)
 			return err;
@@ -415,8 +425,6 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		}
 	}
 
-	chip->ports[port].cmode = cmode;
-
 	return 0;
 }
 
-- 
2.20.1

