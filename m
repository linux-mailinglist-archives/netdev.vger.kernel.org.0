Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6EA4CE55E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 15:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiCEO4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 09:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiCEO4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 09:56:04 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E2396A9;
        Sat,  5 Mar 2022 06:55:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id n15so227623plh.2;
        Sat, 05 Mar 2022 06:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=aCTkDCJYSB+lOnRJ9woHxklOjSBgeP6h4/7iJlYWqs8=;
        b=KpL2cMjlDbeYQQWH0y/uLqKLMeb1AcPo65b6XqQdmB1Dc6Num2JQ25L1hz926LXuPd
         lqndb69Dkf1lC4NIfZvneoNdMYZXUvGmsOCVDMr9wF7VmXYCdGeKGR1TCxEG9zQ4n2JN
         lMux9BaePU5yPWP+WqDGXorL6/TXVmjtzgtQxv4heQPC2DoQwuEAW3bxnM0MCv34htju
         UOuffRKP3pMOMKzPvZ+zp6XRJCQWiYIG9i49PcT8wfShCSc5X4+AR+HSNopwMoWR2qOm
         rB4v/f8xsVJhIBgO92mTEiYoc5whoR1uY038ikSXARs95A2H96lR5P91nrrZ1D5OubtB
         +P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aCTkDCJYSB+lOnRJ9woHxklOjSBgeP6h4/7iJlYWqs8=;
        b=sbmH8QzKPyPQe3DbnRyOZC53MIHgduy0/MN8dOr2A8YJn8Rdloye7RESko5YhHBg6t
         U0t4lthgOF4L11vLc7/afLG9u3BQr2xh+Ghdan4rMADumw3MJiY7gDe7nFOOaWM60x1I
         eQYco3hqzTp/iciidYid2yjcRcg3k61HpWha+zbDfwst7zuMjbOE2KsSiAEueR+5U9uk
         j/nzGvDSxKFY9V3/BhBJ+GCAhhk0KyuZWZq218RlD8tHEKfAM+floCH8zMtMCKLFYLdl
         VIPjrv1lCe2DbohTx+0UXksAqlHFxKYfqpARXiWT5IRFtav8ldVRLaYMg5XnAWXwonmq
         TYHg==
X-Gm-Message-State: AOAM530p3FwfYuWgeHz7xRDw6NqJKLWjbF4sJCjFl22gZj4eDZoRm8LY
        B5x2Fgw5w0Cu0h+RoYOskQ==
X-Google-Smtp-Source: ABdhPJyuFeAxh3xixyiYxI1F75IvUa00LHlfeeQee5vDZsyzOu2SMMXR5LdlQXbbhKtZhRu9ehuilg==
X-Received: by 2002:a17:902:8e88:b0:14f:b460:ec02 with SMTP id bg8-20020a1709028e8800b0014fb460ec02mr3954907plb.35.1646492114497;
        Sat, 05 Mar 2022 06:55:14 -0800 (PST)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm10078213pfl.135.2022.03.05.06.55.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 06:55:14 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] ethernet: sun: Free the coherent when failing in probing
Date:   Sat,  5 Mar 2022 14:55:04 +0000
Message-Id: <1646492104-23040-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver fails to register net device, it should free the DMA
region first, and then do other cleanup.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/ethernet/sun/sunhme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index ad9029ae6848..77e5dffb558f 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3146,7 +3146,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3179,6 +3179,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
-- 
2.25.1

