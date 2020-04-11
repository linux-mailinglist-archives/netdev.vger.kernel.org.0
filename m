Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C81A5448
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgDKXEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbgDKXEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22FDC215A4;
        Sat, 11 Apr 2020 23:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646292;
        bh=p38O/2mQNXuwn5pJCSLK7R5UGjaTsUKvp2Qd+A+zw3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=by6wYbzLhUmDBVcg6PdwzMBUMJRVpuFpl1U9tj8vaF3ff26YwU+pj1Gs880Pjrs5o
         C1bcjeZLYW+I4kWcy+Zz2enTRj64aSppFoaSMlrK7IeK4oFpTnhlvClRSshj4ZnRZ9
         iMIH2LrhAEz/q5nX2JCaKa+b364lvLokr9YfhSes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 053/149] net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278
Date:   Sat, 11 Apr 2020 19:02:10 -0400
Message-Id: <20200411230347.22371-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
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
index b0f5280a83cb6..d9b003432e71b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -615,6 +615,9 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
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

