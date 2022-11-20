Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E206312A2
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 06:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiKTFyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 00:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKTFyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 00:54:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9599EA3419
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id a22-20020a17090a6d9600b0021896eb5554so2770836pjk.1
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovs2GfYuwAqPv4jU6p/GMnpsj70GUJXd7qxztAZ368w=;
        b=Ok9/g14/ZGRcsKgWUAUM5SThWuQNqiCtziCvjmOjzxRxq3q1Q1OwFIeBDO5C3Y5r8x
         +WUHahU6OcoYJefPdFXOW5qtXfdMvb2JIJVS8x33X8HDzIaVOt+zkV5jafq+Jxgcfqbp
         IY62dcckFYeTgIhBqoZsT/1A4cPSyLbtZvQThBLJUALzp0kATosHKN4h99IyK/my4nij
         wjKFBEJmHygvTaOwZETfEIGiiLx2c0cCpV8LQdKbeyvJAXjMDo0hRZO8iPLui4R1ixTY
         ta6oJOJIsyBA71nRSgZXa6UGMNvkO1f2aFqtuhzfS03BPSm7xOzZ1Jp1qaafcKzViJoK
         zgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovs2GfYuwAqPv4jU6p/GMnpsj70GUJXd7qxztAZ368w=;
        b=0zTgQeTxh07qbGPeDcCUN2c69sXj/70JbtLepq4DBY+Ht/Fz6C/I2zAqv73WWcnkPB
         sRJB1orhXErZMItVqHSNd/qsfAZpZ1xDUOiAMheIBnZDllPpuxHNUudnKw+xWPRxnOOc
         ZCEO8fD6xGiFMZ9bJX5rS7G3qrSEiRFKwAUYYp/xDgIXPW16HuYVba+Tc+JFGZg5GfG0
         /D3sa9/IOEm5ZvA4b9Y7yNIzIlF7Jm2YxFzEyly89SrL4s6KJ9Hvmcn3+Ma3exdZXvmB
         LIXtT3h5jymoPjXO7CCWYVhZgq3TiKou3W76b6k65950rITZpu8q4BZAzx6LV3CAraNV
         rakw==
X-Gm-Message-State: ANoB5pnXwNTU9GHIpvbGa2CIL0h9u9ulW+6mOdT+dNLKdRdjAJyYZ6Y6
        al/zI6qxK8HdrpcjHCpEXDi7JDt9WDc=
X-Google-Smtp-Source: AA0mqf7UBM4tFFvyOk9WGPKPgUdSNI6hZca/d9G+uQmgi3A5TdVJR5d8OWzrnnHJJN9xZQj+0HcNjw==
X-Received: by 2002:a17:903:2c2:b0:182:631a:ef28 with SMTP id s2-20020a17090302c200b00182631aef28mr6341146plk.46.1668923639146;
        Sat, 19 Nov 2022 21:53:59 -0800 (PST)
Received: from localhost.localdomain ([176.119.148.120])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902f60100b00186ac4b21cfsm6733397plg.230.2022.11.19.21.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 21:53:58 -0800 (PST)
From:   Yan Cangang <nalanzeyu@gmail.com>
To:     leon@kernel.org, kuba@kernel.org, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com
Cc:     netdev@vger.kernel.org, Yan Cangang <nalanzeyu@gmail.com>
Subject: [PATCH net v3 2/2] net: ethernet: mtk_eth_soc: fix memory leak in error path
Date:   Sun, 20 Nov 2022 13:52:59 +0800
Message-Id: <20221120055259.224555-3-nalanzeyu@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221120055259.224555-1-nalanzeyu@gmail.com>
References: <20221120055259.224555-1-nalanzeyu@gmail.com>
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

In mtk_probe(), when mtk_ppe_init() or mtk_eth_offload_init() or
register_netdev() failed, have the same problem. Fix it.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  9 +++++----
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 19 +++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 16269c6c09ac..142d12214ef6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4145,13 +4145,13 @@ static int mtk_probe(struct platform_device *pdev)
 						   eth->soc->offload_version, i);
 			if (!eth->ppe[i]) {
 				err = -ENOMEM;
-				goto err_deinit_mdio;
+				goto err_deinit_ppe;
 			}
 		}
 
 		err = mtk_eth_offload_init(eth);
 		if (err)
-			goto err_deinit_mdio;
+			goto err_deinit_ppe;
 	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
@@ -4161,7 +4161,7 @@ static int mtk_probe(struct platform_device *pdev)
 		err = register_netdev(eth->netdev[i]);
 		if (err) {
 			dev_err(eth->dev, "error bringing up device\n");
-			goto err_deinit_mdio;
+			goto err_deinit_ppe;
 		} else
 			netif_info(eth, probe, eth->netdev[i],
 				   "mediatek frame engine at 0x%08lx, irq %d\n",
@@ -4179,7 +4179,8 @@ static int mtk_probe(struct platform_device *pdev)
 
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

