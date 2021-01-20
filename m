Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A72FD593
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbhATQZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:25:43 -0500
Received: from m12-11.163.com ([220.181.12.11]:56939 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403868AbhATQZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=JQUvh71mQF0XUlkDwq
        p83cwHhpG6GfqY8HneHsIKOxA=; b=L/6DcHAIqaGJaWneU91GJikb+EqPwSlVg/
        j5/Gqj9a+K5CKEgYjFN7LdK8dBHAOIHqQLhElztOm2etHv/e/qEqXKICJZfyhv7m
        GiJw4A3VaTmQsXOKntSUOmK63C3/qF5ViTIr6J18+Vk8nI8LdkX4yF9REZzEdfO7
        Atu4aR5Do=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp7 (Coremail) with SMTP id C8CowAC3Um0YIAhg08DwJg--.35034S4;
        Wed, 20 Jan 2021 20:20:43 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] net: fec: put child node on error path
Date:   Wed, 20 Jan 2021 04:20:37 -0800
Message-Id: <20210120122037.83897-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowAC3Um0YIAhg08DwJg--.35034S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw45XFyrWw4DJF1ftr4rGrg_yoWDuFbE9r
        1xWF4fAr48KF1xKw4rGr43Z3s0kryqqw18GF4IgayYg342vwnrZr48Arn3XryS9r42yF9r
        KFnxJF4ay34UKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYrGYJUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBURsgclaD9tCUgQAAs+
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also decrement the reference count of child device on error path.

Fixes: 3e782985cb3c ("net: ethernet: fec: Allow configuration of MDIO bus speed")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 04f24c66cf36..55c28fbc5f9e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2165,9 +2165,9 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
-	of_node_put(node);
 	if (err)
 		goto err_out_free_mdiobus;
+	of_node_put(node);
 
 	mii_cnt++;
 
@@ -2180,6 +2180,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 err_out_free_mdiobus:
 	mdiobus_free(fep->mii_bus);
 err_out:
+	of_node_put(node);
 	return err;
 }
 
-- 
2.17.1

