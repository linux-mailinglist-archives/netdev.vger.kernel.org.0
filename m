Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530FB5B6DE6
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 15:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiIMNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIMNCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 09:02:54 -0400
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01BCB2228C
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 06:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eLE7J
        V8sdoWdXNWRx+SHN8kYX1iFjhmFEX+O0Muguig=; b=N7kN7BKJS9XNMQSgFLTbt
        mYimHbD3JOxDAO7cni4eJJCja78hAtc6KVzFxo5x+fHKyZIeTCv4W18cH39nhUAP
        O/z28iX0/1mAbdPJozhPddP55n33sK8c7Cl7gHzM24IdxsPR+FhpIyTJ6Hh9Mshb
        PEydIYS2sPhyvp45OWHnzY=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp10 (Coremail) with SMTP id NuRpCgBHfe0dfiBjm_hGBg--.12793S2;
        Tue, 13 Sep 2022 20:57:03 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     windhl@126.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linmq006@gmail.com
Subject: [PATCH v2] of: mdio: Add of_node_put() when breaking out of for_each_xx
Date:   Tue, 13 Sep 2022 20:56:59 +0800
Message-Id: <20220913125659.3331969-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgBHfe0dfiBjm_hGBg--.12793S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr4xXr17Ww1kXw4kGrW3Jrb_yoWfZFX_Ka
        s5XF9rXF4DGr43KrsIkrW3Z3sYya18Wr40qa4SgrZ3tw40vr12gr1DZF13XrykXFZ7AFZr
        tryqyF4Iy34xCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRtAwIJUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi2gd7F1uwMurloAABsG
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In of_mdiobus_register(), we should call of_node_put() for 'child'
escaped out of for_each_available_child_of_node().

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Cc: Miaoqian Lin <linmq006@gmail.com>
Co-developed-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 v2: use proper tag advised by Jakub Kicinski
 v1: fix the bug

 drivers/net/mdio/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..796e9c7857d0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -231,6 +231,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	return 0;
 
 unregister:
+	of_node_put(child);
 	mdiobus_unregister(mdio);
 	return rc;
 }
-- 
2.25.1

