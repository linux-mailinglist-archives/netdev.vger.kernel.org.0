Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4920CE5C37
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfJZN3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbfJZNUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C4D214DA;
        Sat, 26 Oct 2019 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096045;
        bh=d+k+F8sEkdzwwKGHDr6Pgq1fJ05P427d/R561d/xQso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8xX7er4kXoe7oj8PqnLWsFnbhyT5BXXvf41Dl57xlylfAFsK36wGKk1mqu7GVOQx
         WPwLwQHBJYVFn2J58k5XwcCsIWfAvAcGxc3T98CsZiDULgYiiClVGeZKPfRCRPxxH+
         prgsbAtif3ikskhPWyTEmqbqAcxMLYsy/3DDfVV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 48/59] net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
Date:   Sat, 26 Oct 2019 09:18:59 -0400
Message-Id: <20191026131910.3435-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit efb86fede98cdc70b674692ff617b1162f642c49 ]

The RGMII_MODE_EN bit value was 0 for GENET versions 1 through 3, and
became 6 for GENET v4 and above, account for that difference.

Fixes: aa09677cba42 ("net: bcmgenet: add MDIO routines")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h | 1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 14b49612aa863..4dabf37319c84 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -369,6 +369,7 @@ struct bcmgenet_mib_counters {
 #define  EXT_PWR_DOWN_PHY_EN		(1 << 20)
 
 #define EXT_RGMII_OOB_CTRL		0x0C
+#define  RGMII_MODE_EN_V123		(1 << 0)
 #define  RGMII_LINK			(1 << 4)
 #define  OOB_DISABLE			(1 << 5)
 #define  RGMII_MODE_EN			(1 << 6)
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index de0e24d912fe9..7b2fbbc334639 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -261,7 +261,11 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	 */
 	if (priv->ext_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
-		reg |= RGMII_MODE_EN | id_mode_dis;
+		reg |= id_mode_dis;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			reg |= RGMII_MODE_EN_V123;
+		else
+			reg |= RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
 	}
 
-- 
2.20.1

