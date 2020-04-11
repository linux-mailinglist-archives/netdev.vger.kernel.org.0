Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3C1A56F5
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgDKXNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgDKXNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:13:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2062320787;
        Sat, 11 Apr 2020 23:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646829;
        bh=pb0HsRJJ5jCJK7KhsG5jlq9kRHAIunQL+o6nTKDSeUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiq8nNEi31DvAJYoaQahE6E7WGlVN0skcNsxss+JF3TXhPJGuE6HgKcEIO5W9Lam4
         mGJXodMK/iVUG6rAfRku99iWcU52fkW6jIIob4YbO8BRao6CcPv003gHNMax1Rr6Pm
         JRPDL5zOlMzzfNWjGN3O4dHBAXXZdICDZybd3KW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/37] net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278
Date:   Sat, 11 Apr 2020 19:13:08 -0400
Message-Id: <20200411231327.26550-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
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
index 6bca42e34a53d..4b0c48a40ba6e 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -691,6 +691,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
 
+	if (priv->type == BCM7278_DEVICE_ID && dsa_is_cpu_port(ds, port))
+		reg |= GMIIP_SPEED_UP_2G;
+
 	core_writel(priv, reg, offset);
 
 	if (!phydev->is_pseudo_fixed_link)
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 49695fcc2ea8f..3c4fd7cda701a 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -162,6 +162,7 @@ enum bcm_sf2_reg_offs {
 #define  RXFLOW_CNTL			(1 << 4)
 #define  TXFLOW_CNTL			(1 << 5)
 #define  SW_OVERRIDE			(1 << 6)
+#define  GMIIP_SPEED_UP_2G		(1 << 7)
 
 #define CORE_WATCHDOG_CTRL		0x001e4
 #define  SOFTWARE_RESET			(1 << 7)
-- 
2.20.1

