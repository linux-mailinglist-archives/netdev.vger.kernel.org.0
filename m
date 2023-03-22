Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A6C6C431E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCVGZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCVGZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:25:25 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 220884FCF5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 23:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=iePpi
        6jFvsbsulcOvtoqGordQA1DJVJ/fjYmXPHlxV4=; b=iBdHP30wJ58+az+Xa2hUN
        7FiZQq1iFUJqzFGVKi/fxi4JGaMyejNoHuIC5tmBEcVLQHJ3Ff4g1ff//GQigM16
        UOCRSVNByG7vCjXEWS9GdO4b2rVrjnKxr24Oo612qKrlYHvtJ45KqsLP7fkTXWWZ
        Ha7fxugjqFAdxng5J1mjhk=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by zwqz-smtp-mta-g2-0 (Coremail) with SMTP id _____wDXPv9KnhpkOsmdAQ--.3812S2;
        Wed, 22 Mar 2023 14:20:59 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, david.daney@cavium.com,
        windhl@126.com
Subject: [PATCH] net: mdio: thunder: Add missing fwnode_handle_put()
Date:   Wed, 22 Mar 2023 14:20:57 +0800
Message-Id: <20230322062057.1857614-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDXPv9KnhpkOsmdAQ--.3812S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr1kuF4kWF1kGr13Zr4ruFg_yoW3Kwb_Ww
        n7ZF9rXr17Jr1Ik3ZrAw4Sv342qF409rZ7CFsaga4vqFy5ZFyrury0vF98Ww18Z3yYyas8
        Jr13trWxA34fKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRpMKA5UUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgA6F1-HarT0egABs+
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In device_for_each_child_node(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/mdio/mdio-thunder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f35..394b864aaa37 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
-- 
2.25.1

