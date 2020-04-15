Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402591A9DEE
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409446AbgDOLsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409422AbgDOLsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F7C20775;
        Wed, 15 Apr 2020 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951287;
        bh=bUXNDQQRGaIuaP5JVoTNgFflarxDr46radtnMT9rNO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAejOywbFFLt3IavI5Rxhnb/7UJfIE7+9CFZ2BhwpIdbaa1NaD0S205IEYn6Lrfj3
         Zj/0Aqo9Y04YkxEyhPzCv4kxsSVQaWQ3fNIXibI4+8pNZrrpkMp96c7e+V3uDcM+TR
         p0TPRi1v5o6NRYUU2vrvcTy3KCFHTzUPIO5bFVS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/21] net: dsa: bcm_sf2: Ensure correct sub-node is parsed
Date:   Wed, 15 Apr 2020 07:47:42 -0400
Message-Id: <20200415114748.15713-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114748.15713-1-sashal@kernel.org>
References: <20200415114748.15713-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit afa3b592953bfaecfb4f2f335ec5f935cff56804 ]

When the bcm_sf2 was converted into a proper platform device driver and
used the new dsa_register_switch() interface, we would still be parsing
the legacy DSA node that contained all the port information since the
platform firmware has intentionally maintained backward and forward
compatibility to client programs. Ensure that we do parse the correct
node, which is "ports" per the revised DSA binding.

Fixes: d9338023fb8e ("net: dsa: bcm_sf2: Make it a real platform device driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index a3a8d7b62f3fb..796571fccba70 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -976,6 +976,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	struct device_node *dn = pdev->dev.of_node;
 	struct b53_platform_data *pdata;
 	struct dsa_switch_ops *ops;
+	struct device_node *ports;
 	struct bcm_sf2_priv *priv;
 	struct b53_device *dev;
 	struct dsa_switch *ds;
@@ -1038,7 +1039,11 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->indir_lock);
 	mutex_init(&priv->stats_mutex);
 
-	bcm_sf2_identify_ports(priv, dn->child);
+	ports = of_find_node_by_name(dn, "ports");
+	if (ports) {
+		bcm_sf2_identify_ports(priv, ports);
+		of_node_put(ports);
+	}
 
 	priv->irq0 = irq_of_parse_and_map(dn, 0);
 	priv->irq1 = irq_of_parse_and_map(dn, 1);
-- 
2.20.1

