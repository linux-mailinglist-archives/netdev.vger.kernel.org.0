Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792A9148239
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbgAXL0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:26:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403921AbgAXL0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1062C20838;
        Fri, 24 Jan 2020 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865172;
        bh=TzowKccvI55mtIGH0oD/xZt9s53+e4QQyQqrJGl7Uro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6ag9tUvkkrCvTQAAKfm3RtwbzMvqgPA759tl10s1cJsjaBeU/abH4LiMCxjvoHHN
         SaCRi7AFYblWDuFrv2b0pncjZAL43wGK6/9sUykzgxTSAEdocalSX7sVjJVNoZzgDA
         6thiYol3Oj8Q7VP0WQuHxYsMwd946AlHZhTciiEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 473/639] net: pasemi: fix an use-after-free in pasemi_mac_phy_init()
Date:   Fri, 24 Jan 2020 10:30:43 +0100
Message-Id: <20200124093147.032938762@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

[ Upstream commit faf5577f2498cea23011b5c785ef853ded22700b ]

The phy_dn variable is still being used in of_phy_connect() after the
of_node_put() call, which may result in use-after-free.

Fixes: 1dd2d06c0459 ("net: Rework pasemi_mac driver to use of_mdio infrastructure")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index 8a31a02c9f47f..65f69e562618a 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1053,7 +1053,6 @@ static int pasemi_mac_phy_init(struct net_device *dev)
 
 	dn = pci_device_to_OF_node(mac->pdev);
 	phy_dn = of_parse_phandle(dn, "phy-handle", 0);
-	of_node_put(phy_dn);
 
 	mac->link = 0;
 	mac->speed = 0;
@@ -1062,6 +1061,7 @@ static int pasemi_mac_phy_init(struct net_device *dev)
 	phydev = of_phy_connect(dev, phy_dn, &pasemi_adjust_link, 0,
 				PHY_INTERFACE_MODE_SGMII);
 
+	of_node_put(phy_dn);
 	if (!phydev) {
 		printk(KERN_ERR "%s: Could not attach to phy\n", dev->name);
 		return -ENODEV;
-- 
2.20.1



