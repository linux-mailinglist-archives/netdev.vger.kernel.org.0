Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163AC62B29A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiKPFOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKPFOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:14:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3A62EF5E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:14:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k7so15409116pll.6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7BkpB6uGFgiGKg3Tl2oIcFvZPFIAwifvlYSqPFFZTU=;
        b=Kj5AhVgd6yHv5j32w3FbDaUg30lFhOnGGzIDwx4eNRuYiLSjTkNHUxaL2Agki/S7t4
         UDj81vKRa/po5y6YwQio9gLiil0QU2wUDJSvSejLIS0sqsg5oa7Eg8Hx2t8zgcCmlzGu
         XAnVvRPH3QlNRLZ8MTYC4c4mkCs50kz1uehxWv0sGfx+Fx+99+pfZLmYcWXnoklJsbb2
         nDBZyO5UzB9I8djnMTLaDAuEIa8l+0AtGInVbnXPYTkoX3/hTPwIF8Ylmivm0grbyC04
         JwIE5MuxsOae/te561yeNPPEhVVezXLXQaVFgW7vHI28tE/XHdlR72RtzM6oMTcw7pzF
         R/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7BkpB6uGFgiGKg3Tl2oIcFvZPFIAwifvlYSqPFFZTU=;
        b=zfBDL1w8xIaRnhJAeXGmdPsoLQovJJXaX9SLr7t/rsJG91M4xwRwt0ajU3j/S56oQi
         y6XQE8I3gLSQ5jtsgzniunxqWBXTEDUwwP1InHvyPk59AmT+jhcqaPz3oRg4c+HSbd8i
         7iyd5cQoEkHtob6Pi58MY7eg9iwx4/iSYUagPAzNPiMIOe9XLzAPmQn1IFYHVVbEdfpb
         LXHClGjEeZYGtpZHUgufKjOekIUDBEJOSjmjscKlpqFSpJLV/SCD46bDTjVMB1M4sMKW
         wKmojhdGBlF8kRJMrfEKOJLWbIf2fCNOWr54rhlMJouMXz0ZmkF5D4YVvZNKJwErBMdO
         ZNfA==
X-Gm-Message-State: ANoB5pmVtOuwWeXYHOCV/TdCA09NcVOBcia1jpARYDqGL7vsbXACpCpN
        0Kwy7kntVjQJNr7NKyzRrJI=
X-Google-Smtp-Source: AA0mqf4f6A0S8ycLiOC527FxEODy/e5l4wvVzl0ahaFgGalFaAa11YWtLThwEK+5HgJhixoE5nD2rQ==
X-Received: by 2002:a17:903:483:b0:17c:5b30:6a1e with SMTP id jj3-20020a170903048300b0017c5b306a1emr7058363plb.138.1668575691349;
        Tue, 15 Nov 2022 21:14:51 -0800 (PST)
Received: from localhost.localdomain ([176.119.148.120])
        by smtp.gmail.com with ESMTPSA id b24-20020aa79518000000b0056abfa74eddsm10054752pfp.147.2022.11.15.21.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 21:14:51 -0800 (PST)
From:   Yan Cangang <nalanzeyu@gmail.com>
To:     leon@kernel.org, Mark-MC.Lee@mediatek.com, john@phrozen.org,
        nbd@nbd.name, netdev@vger.kernel.org, sean.wang@mediatek.com
Cc:     Yan Cangang <nalanzeyu@gmail.com>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: fix memory leak in error path
Date:   Wed, 16 Nov 2022 13:14:07 +0800
Message-Id: <20221116051407.1679342-1-nalanzeyu@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y3H1VgVOJB5kHbaa@unreal>
References: <Y3H1VgVOJB5kHbaa@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mtk_ppe_init(), when dmam_alloc_coherent() or devm_kzalloc() failed,
the rhashtable ppe->l2_flows isn't destroyed. Fix it.

In mtk_probe(), when mtk_eth_offload_init() or register_netdev() failed,
have the same problem. Also, call to mtk_mdio_cleanup() is missed in this
case. Fix it.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
---
v1: https://lore.kernel.org/netdev/20221112233239.824389-1-nalanzeyu@gmail.com/T/
v2:
  - clean up commit message
  - new mtk_ppe_deinit() function, call it before calling mtk_mdio_cleanup()

 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  9 +++++----
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 19 +++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7cd381530aa4..3f806a1358b7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4143,13 +4143,13 @@ static int mtk_probe(struct platform_device *pdev)
 						   eth->soc->offload_version, i);
 			if (!eth->ppe[i]) {
 				err = -ENOMEM;
-				goto err_free_dev;
+				goto err_deinit_ppe;
 			}
 		}
 
 		err = mtk_eth_offload_init(eth);
 		if (err)
-			goto err_free_dev;
+			goto err_deinit_ppe;
 	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
@@ -4159,7 +4159,7 @@ static int mtk_probe(struct platform_device *pdev)
 		err = register_netdev(eth->netdev[i]);
 		if (err) {
 			dev_err(eth->dev, "error bringing up device\n");
-			goto err_deinit_mdio;
+			goto err_deinit_ppe;
 		} else
 			netif_info(eth, probe, eth->netdev[i],
 				   "mediatek frame engine at 0x%08lx, irq %d\n",
@@ -4177,7 +4177,8 @@ static int mtk_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_deinit_mdio:
+err_deinit_ppe:
+	mtk_ppe_deinit(eth);
 	mtk_mdio_cleanup(eth);
 err_free_dev:
 	mtk_free_dev(eth);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 2d8ca99f2467..784ecb2dc9fb 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -737,7 +737,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 				  MTK_PPE_ENTRIES * soc->foe_entry_size,
 				  &ppe->foe_phys, GFP_KERNEL);
 	if (!foe)
-		return NULL;
+		goto err_free_l2_flows;
 
 	ppe->foe_table = foe;
 
@@ -745,11 +745,26 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 			sizeof(*ppe->foe_flow);
 	ppe->foe_flow = devm_kzalloc(dev, foe_flow_size, GFP_KERNEL);
 	if (!ppe->foe_flow)
-		return NULL;
+		goto err_free_l2_flows;
 
 	mtk_ppe_debugfs_init(ppe, index);
 
 	return ppe;
+
+err_free_l2_flows:
+	rhashtable_destroy(&ppe->l2_flows);
+	return NULL;
+}
+
+void mtk_ppe_deinit(struct mtk_eth *eth)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(eth->ppe); i++) {
+		if (!eth->ppe[i])
+			return;
+		rhashtable_destroy(&eth->ppe[i]->l2_flows);
+	}
 }
 
 static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 0b7a67a958e4..a09c32539bcc 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -304,6 +304,7 @@ struct mtk_ppe {
 
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 			     int version, int index);
+void mtk_ppe_deinit(struct mtk_eth *eth);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 
-- 
2.30.2

