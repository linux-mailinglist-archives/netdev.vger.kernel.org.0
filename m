Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4086B3BEF
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCJKXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCJKXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:23:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B2E5021;
        Fri, 10 Mar 2023 02:23:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y2so4874252pjg.3;
        Fri, 10 Mar 2023 02:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678443783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qFmfnzJtjeGDe7BE2KF+y8kTx97aE6GIls5Ec122EsQ=;
        b=UK0slwaJ3tvOwEa0urOTQddEFuNoqxCU4VdnnUnIgRrI4TGw4PPIC6woAfBmwVdHlw
         QrzgsDDUjDnJ4dHzhzB4vJ96otKQJRWXJPs5OFPpqYh+8nBV3CBxuYfS0FbHhWSNrBmJ
         Upx3JDomZsuKhZKvpPVyhoSiTvZlKJnf0eIxE1urT/qhHxAM4IU8fS7p0yFmvM5gvNU+
         weLmC3hXcq8P4Xf8BmREeh1z2S+Xe/MTjGoNJMoO0AvLDFtiHnnLMdhzDao2cj97eLrm
         i1RuF8GA7oRaDO8VCpZ6Kvc5C7i0ENm01HsMop2R+9cOvVrWlK5T839EnKhXkvGCCs/0
         yUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678443783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFmfnzJtjeGDe7BE2KF+y8kTx97aE6GIls5Ec122EsQ=;
        b=LD1RTbisMOIU4sRWSzjkbj45M+ItF2N6w02oLDkXvxMKPuA7oDM2XXbegYq3RL8aW8
         3TodXI3WoX9gWCpiy4nI8a+c0J8WJdAMnTm+cBoJ1bQMCuNScNbYx5TfDdOLU2M0pLST
         KlUOTTB5VFiHouFvhgukqZ5WwHRtwnten3e5eOFM/f1oAz3DWaEM51F82qRkCjjCrzhH
         rf7dqxFGSyDG+atNPjTonYMq//5CZG7WaIFNRxrt82TqvkLkda2ekqlX4JpO9vaX1RCO
         H3Dx0hN1V4OVHr5reflD7rvbWHVjBlt2XUNN4Gd7ecCzKPB+0hzJ9fSXxlmPWtzF121B
         AVDA==
X-Gm-Message-State: AO0yUKUNlHxiGNfTUCdAdoYfhKLfuLo86+HQusp/oBhL7KsS80UywlLh
        FeGsmvCHjWv1zy+tanWQ17Q=
X-Google-Smtp-Source: AK7set914/0LxIQtmrcUWYbk7Imqff9dPd0+ZwULPS5HR26HZr2buHSN5W+2BSSpDvMCQUGIuNQgWg==
X-Received: by 2002:a17:903:283:b0:19d:1871:3bfa with SMTP id j3-20020a170903028300b0019d18713bfamr30286335plr.27.1678443782999;
        Fri, 10 Mar 2023 02:23:02 -0800 (PST)
Received: from localhost ([137.184.7.236])
        by smtp.gmail.com with ESMTPSA id c7-20020a170902d48700b0019b06263bcasm1119035plg.247.2023.03.10.02.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:23:02 -0800 (PST)
From:   Gencen Gan <u202011061@gmail.com>
To:     Chas Williams <3chas3@gmail.com>
Cc:     Ganliber <u202011061@gmail.com>, Dongliang Mu <dzm91@hust.edu.cn>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] atm: he: fix potential ioremap leak of membase in he_dev
Date:   Fri, 10 Mar 2023 18:22:56 +0800
Message-Id: <20230310102256.1130846-1-u202011061@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganliber <u202011061@gmail.com>

In the function he_start() in drivers/atm/he.c, there
is no unmapping of he_dev->membase in the branch that
exits due to an error like reset failure, which may 
cause a memory leak.

Signed-off-by: Ganliber <u202011061@gmail.com>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/atm/he.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index ad91cc6a34fc..2d12b46aa5bd 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1058,6 +1058,7 @@ static int he_start(struct atm_dev *dev)
 	status = he_readl(he_dev, RESET_CNTL);
 	if ((status & BOARD_RST_STATUS) == 0) {
 		hprintk("reset failed\n");
+		iounmap(he_dev->membase);
 		return -EINVAL;
 	}
 
@@ -1114,8 +1115,10 @@ static int he_start(struct atm_dev *dev)
 	he_writel(he_dev, lb_swap, LB_SWAP);
 
 	/* 4.10 initialize the interrupt queues */
-	if ((err = he_init_irq(he_dev)) != 0)
+	if ((err = he_init_irq(he_dev)) != 0) {
+		iounmap(he_dev->membase);
 		return err;
+	}
 
 	/* 4.11 enable pci bus controller state machines */
 	host_cntl |= (OUTFF_ENB | CMDFF_ENB |
@@ -1165,6 +1168,7 @@ static int he_start(struct atm_dev *dev)
 
 	if (nvpibits != -1 && nvcibits != -1 && nvpibits+nvcibits != HE_MAXCIDBITS) {
 		hprintk("nvpibits + nvcibits != %d\n", HE_MAXCIDBITS);
+		iounmap(he_dev->membase);
 		return -ENODEV;
 	}
 
@@ -1413,8 +1417,10 @@ static int he_start(struct atm_dev *dev)
 
 	/* 5.1.8 cs block connection memory initialization */
 	
-	if (he_init_cs_block_rcm(he_dev) < 0)
+	if (he_init_cs_block_rcm(he_dev) < 0) {
+		iounmap(he_dev->membase);
 		return -ENOMEM;
+	}
 
 	/* 5.1.10 initialize host structures */
 
@@ -1424,13 +1430,16 @@ static int he_start(struct atm_dev *dev)
 					   sizeof(struct he_tpd), TPD_ALIGNMENT, 0);
 	if (he_dev->tpd_pool == NULL) {
 		hprintk("unable to create tpd dma_pool\n");
+		iounmap(he_dev->membase);
 		return -ENOMEM;         
 	}
 
 	INIT_LIST_HEAD(&he_dev->outstanding_tpds);
 
-	if (he_init_group(he_dev, 0) != 0)
+	if (he_init_group(he_dev, 0) != 0) {
+		iounmap(he_dev->membase);
 		return -ENOMEM;
+	}
 
 	for (group = 1; group < HE_NUM_GROUPS; ++group) {
 		he_writel(he_dev, 0x0, G0_RBPS_S + (group * 32));
@@ -1465,6 +1474,7 @@ static int he_start(struct atm_dev *dev)
 					 &he_dev->hsp_phys, GFP_KERNEL);
 	if (he_dev->hsp == NULL) {
 		hprintk("failed to allocate host status page\n");
+		iounmap(he_dev->membase);
 		return -ENOMEM;
 	}
 	he_writel(he_dev, he_dev->hsp_phys, HSP_BA);
-- 
2.34.1

