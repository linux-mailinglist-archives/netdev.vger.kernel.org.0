Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859EDC3C28
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388940AbfJAQt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbfJAQoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00611222BE;
        Tue,  1 Oct 2019 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948283;
        bh=fs1kXOuMAZDK0RFCV/7w0Tm3PE2ZQmsW58TUgfoIP+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+cgwDUaRfLDzG6ya7MGYA+4Ux6iOjcgHj3mhlaBzaoGF17PvgDt7DChlEt++Sf7y
         +EVluZ6rMWIs0EjkPBAWEv9EHNAjKA696oyfKG1bbmkpCq3Nahacj/6kpG1JdGx5NR
         pqMkudrf8HLPun/okIlVGfig74LUUsvnUUYQ2gGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Mamonov <pmamonov@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/29] net/phy: fix DP83865 10 Mbps HDX loopback disable function
Date:   Tue,  1 Oct 2019 12:44:10 -0400
Message-Id: <20191001164423.16406-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164423.16406-1-sashal@kernel.org>
References: <20191001164423.16406-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Mamonov <pmamonov@gmail.com>

[ Upstream commit e47488b2df7f9cb405789c7f5d4c27909fc597ae ]

According to the DP83865 datasheet "the 10 Mbps HDX loopback can be
disabled in the expanded memory register 0x1C0.1". The driver erroneously
used bit 0 instead of bit 1.

Fixes: 4621bf129856 ("phy: Add file missed in previous commit.")
Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/national.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
index 2addf1d3f619e..3aa910b3dc89b 100644
--- a/drivers/net/phy/national.c
+++ b/drivers/net/phy/national.c
@@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
 
 static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
 {
+	u16 lb_dis = BIT(1);
+
 	if (disable)
-		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
+		ns_exp_write(phydev, 0x1c0,
+			     ns_exp_read(phydev, 0x1c0) | lb_dis);
 	else
 		ns_exp_write(phydev, 0x1c0,
-			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
+			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
 
 	pr_debug("10BASE-T HDX loopback %s\n",
-		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
+		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
 }
 
 static int ns_config_init(struct phy_device *phydev)
-- 
2.20.1

