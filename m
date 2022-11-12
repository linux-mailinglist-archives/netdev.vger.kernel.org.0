Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8241626CA8
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 00:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiKLXdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 18:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiKLXdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 18:33:32 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AECA1BF
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 15:33:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so7615832pjk.1
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 15:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YQ79OKVd7iIymbFIHL+sQgdxNhmZoIoceNlKtKeunJw=;
        b=DM6O+cNUmd8Z3vjJlavPED/emmfdu4L8AXlNsnhvikxG5fiw3QJWEN8Wg71jDnOrVW
         HaJhLIl8rxiYXGw0svEYfmcZwBE5LhBSUfyY1LpcXD88Vmozd4tPqFLNVEHLxLoarXTx
         p7MNgY43M+wPiev83c1Vf5c3MaiIlUkNcgL5J1SVhwfQ4vRfIpQwcGPM9kk7+FYQVnI+
         obTst+ko5nFVfZAEmJuGrYcbnC5r5Hn0Bc5Iis4+KZprefAFlbUVd7ng4xu5GpbaXZ2c
         KfcSoyca2GGHyrs5Y+TEQ+NTMNLn+pzFI5gN4Og2Rzg67+Rhhy7yhljR7G1huqTvvuFf
         AQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQ79OKVd7iIymbFIHL+sQgdxNhmZoIoceNlKtKeunJw=;
        b=HKzFC4rN5DsT0Z+LJVTdWemrOHXb6VOlis1PBSnVPXjDPAxidSCTLhJfcfLmzSqzXM
         NuBgKtjK8FV41lQSyQNAvkFcw8KYpYlBXsevyrXUTaoAAnK9DfnxUI6nlmb1Wj8brztu
         taQgF9NkGTMQXYvYWdz50vo4IVXVoMmgAHrQBoRiNIlk2bo4GsFdD2q9oTGVPJ4TF8dD
         Uxpg/cLTAYL1wTdJQ+0KEYdN4q9Dbcsq7zB0KoricwaHZOnZCsPRbJjGK8EITq8gxgab
         Ij/Nm7v6DevJym/KqkPfrlZLAsTVrPlGCMzcknDhNiyFviHHl+xyaLOYSJbNfbXPvTHy
         VLVg==
X-Gm-Message-State: ANoB5pkSnS1ErLRi3q0YFMW+RgztYS8L8OcLQ7xEZok2gfX87mQUCneA
        9U3iI2MowR9CSAFRd6LJUHEJZMyApKmXixfoH9k=
X-Google-Smtp-Source: AA0mqf5dDnPymWZlBlyzUf8Z8QiBr7a6sr4602ZrOa05POsmmsr1jQBug2g2q113ZS90kESBi/2BLQ==
X-Received: by 2002:a17:90b:215:b0:213:2411:50e7 with SMTP id fy21-20020a17090b021500b00213241150e7mr8015293pjb.212.1668296009566;
        Sat, 12 Nov 2022 15:33:29 -0800 (PST)
Received: from localhost.localdomain ([45.92.127.40])
        by smtp.gmail.com with ESMTPSA id k29-20020aa7973d000000b0056bb7d90f0fsm3788308pfg.182.2022.11.12.15.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 15:33:29 -0800 (PST)
From:   Yan Cangang <nalanzeyu@gmail.com>
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com
Cc:     netdev@vger.kernel.org, Yan Cangang <nalanzeyu@gmail.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix memory leak in mtk_ppe_init()
Date:   Sun, 13 Nov 2022 07:32:39 +0800
Message-Id: <20221112233239.824389-1-nalanzeyu@gmail.com>
X-Mailer: git-send-email 2.30.2
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

    When dmam_alloc_coherent() or devm_kzalloc() failed, the rhashtable
    ppe->l2_flows isn't destroyed. Fix it.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 2d8ca99f2467..8da4c8be59fd 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -737,7 +737,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 				  MTK_PPE_ENTRIES * soc->foe_entry_size,
 				  &ppe->foe_phys, GFP_KERNEL);
 	if (!foe)
-		return NULL;
+		goto err_free_l2_flows;
 
 	ppe->foe_table = foe;
 
@@ -745,11 +745,15 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
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
 }
 
 static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
-- 
2.30.2

