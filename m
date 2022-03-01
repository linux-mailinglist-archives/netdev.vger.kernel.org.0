Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFAF4C8D7E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiCAOQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiCAOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:16:54 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EF28EB7B;
        Tue,  1 Mar 2022 06:16:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y11so14328344pfa.6;
        Tue, 01 Mar 2022 06:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AOmwVd9edsIWjbmnt5Vz1bXusEeT8SvFDTAq62duuU0=;
        b=cIAys3nROTVgD2GXuegWrU6S65y4slbQMvSByHeXIROlywCNom9+QMTFge+n92J6kn
         JPgCrFVeluCckR4rrUvTq8j7wRnA/Xa+U5fnGV6enHJ3UXYPkua4bPPgTuzfZ7E2W5SK
         VIcj1JwPv/y0V3KmAdwF29l7bC5dlWTkQNxCtkw/vD9znr90ULi4k7jjaSFHUnjYD4sO
         cG/6ArewzoGrOSUZzrWfnZQudXTHWxrUNoCbuAjX0rjQ3dL2ofBv6Wscje2I7pPQ+/TG
         OHticZF4a6qjB99fa6zMT3oyreegsjXTkQHT8x0auggYwc647kynfJuEpBwI3hq038eX
         W2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AOmwVd9edsIWjbmnt5Vz1bXusEeT8SvFDTAq62duuU0=;
        b=5TJWrXXSMWft7lu1vhxYbwZ78rGG1tjZxZUwr/U/CO05os9IZWJpwb2j3x7QzfxdcH
         vRgXMXcbyW3XdbUPk4kWFBlBWas+IVg64rxXlAgmE+ZwQwxs24ZzeMGzNb/V0oDNbHfw
         qjOKgDGGbtlJaWszzXSrCGxKllANPPL1XEUVxpr365qDwkapCHP35EIwsKCN2ChEOGu9
         NyZe7jjib7cViY53KNk3fXAPDzN29P8W+eX31dhDFgBw0+JeELHwN9Sh7rAAkZZuEsku
         O1dRC20IXX1rwrp2Yn79JEv2y5gsuE82DuALRGKJ6rILCzJsxqzI+kBHtMF55I9XX2/Z
         eyAw==
X-Gm-Message-State: AOAM532KUzOuaSRZ00xYKblp7f2CoqxqpWnDVBqL9YLYgWedqRR+yLAI
        QKLPMyIMqOTAzPsXJPjb720=
X-Google-Smtp-Source: ABdhPJwZiguy4a5MTNAk69jnWYUgTNxG+Sg3tlZ+qv5iKbjphYKQSK6WZBInbxKBcESfJS2ZmszILA==
X-Received: by 2002:a05:6a00:1747:b0:4f3:e449:4416 with SMTP id j7-20020a056a00174700b004f3e4494416mr19326497pfc.5.1646144172642;
        Tue, 01 Mar 2022 06:16:12 -0800 (PST)
Received: from localhost.localdomain ([115.27.208.93])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79597000000b004e1bf2f5818sm18209990pfj.87.2022.03.01.06.16.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 06:16:12 -0800 (PST)
From:   Yeqi Fu <fufuyqqqqqq@gmail.com>
To:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yeqi Fu <fufuyqqqqqq@gmail.com>,
        Yongzhi Liu <lyz_cs@pku.edu.cn>
Subject: [PATCH v1] dpaa2-switch: fix memory leak of dpaa2_switch_acl_entry_add
Date:   Tue,  1 Mar 2022 22:15:44 +0800
Message-Id: <20220301141544.13411-1-fufuyqqqqqq@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <a87a691a-62c2-5b42-3be8-ee1161281ad8@suse.de>
References: <a87a691a-62c2-5b42-3be8-ee1161281ad8@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling branch did not properly free the memory of cmd_buf
before return, which would cause memory leak. So fix this by adding
kfree to the error handling branch.

Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
Signed-off-by: Yeqi Fu <fufuyqqqqqq@gmail.com>
Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..4d07aee07f4c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
-- 
2.30.1 (Apple Git-130)

