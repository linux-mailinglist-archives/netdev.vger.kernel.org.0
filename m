Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C1F1A5883
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgDKXKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgDKXK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75FA720757;
        Sat, 11 Apr 2020 23:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646629;
        bh=OHh8W/rYjJG0JGWwMu+RIa89RX1bDKCXWFbkIySu1qI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWJAoejoK0bttPvj1d5uJIB3Yh/qfqbZN0sfX5KujFU9x7udn3rh6Q1j4fUTdCVDn
         rPqXnSGCaMmFbcrR9nLTnUfV/K9lFbEQ0eOmqxlXtCRlC+4r+zNT7cnOJGYTkZwzMG
         z1dRoDiIRaU48VQfCDRZ6v6IlnWIlz/zUD/3V7ok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 037/108] net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278
Date:   Sat, 11 Apr 2020 19:08:32 -0400
Message-Id: <20200411230943.24951-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7458bd540fa0a90220b9e8c349d910d9dde9caf8 ]

Either port 5 or port 8 can be used on a 7278 device, make sure that
port 5 also gets configured properly for 2Gb/sec in that case.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c      | 3 +++
 drivers/net/dsa/bcm_sf2_regs.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 46dc913da852d..d4e804184c545 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -602,6 +602,9 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
 
+	if (priv->type == BCM7278_DEVICE_ID && dsa_is_cpu_port(ds, port))
+		reg |= GMIIP_SPEED_UP_2G;
+
 	core_writel(priv, reg, offset);
 }
 
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index d8a5e6269c0ef..7844781763359 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -178,6 +178,7 @@ enum bcm_sf2_reg_offs {
 #define  RXFLOW_CNTL			(1 << 4)
 #define  TXFLOW_CNTL			(1 << 5)
 #define  SW_OVERRIDE			(1 << 6)
+#define  GMIIP_SPEED_UP_2G		(1 << 7)
 
 #define CORE_WATCHDOG_CTRL		0x001e4
 #define  SOFTWARE_RESET			(1 << 7)
-- 
2.20.1

