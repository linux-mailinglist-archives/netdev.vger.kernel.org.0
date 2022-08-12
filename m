Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8127591346
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238810AbiHLPsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiHLPsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:48:45 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAE09E2C5
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:48:44 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s9so1321967ljs.6
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=bFbDOQm22ztt3sjzpox0SGZF9u6rZdUlcZeD04qlWho=;
        b=Hys/ZrsgAktTL2C90NrfdDmHPYONRTzyknAQtZXfWy+m2QwbevONVp4HKoLDFyPV41
         JfdaSMuGkiQWE4DmNX52YrjO2BbLCbftGW3NW7Het7GM0Wr+izR9rPUn7XIHffQMRx2V
         3q5Cj/gbBmG44EC5bxiVmUE0m3qGicaMDSQTM9BU7+VZhkTqNT0dLSJtfGbWjQtfua3Q
         6nTQ+Vv3tQtDOp2yPlXrhCC8p/wYW4suLqVLkr3+fqFotusbZSjZzG5Lo5hVoO7mBRnP
         lF68Z+MjeCUnwr5HcjPio838LrMPFHLN7v1RL1hykNCigyKlDzdqettzKRFRw8UkQhtD
         +X+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=bFbDOQm22ztt3sjzpox0SGZF9u6rZdUlcZeD04qlWho=;
        b=eiE/O61sh+cECw/Z2yWILFwAQ7bN87ODyUnESSarhCX7r9A3r+4biAj0HxtGRkeIVL
         VH5s+vn/p75kqEAlcUbZ8mBhcPhPB0dfWRhaH75KTMuU3y8Kfp1I9TIKe/DqADjsXZFp
         w4MRK56HT1i8CoRbn+AG+Qau5LkhfyzQaGploduJANIsUKfMdUKRI21Cww9H0ITFZjvW
         VHlM4qTOMw0ObtxC8lc8Gs/Q51SsUYbOy3aq7M2txV8Ozw0iDY5lg7C4zC4jnH32HaI5
         I+RqDhkXNtjX0KAEFmZ1ydI6K0YRKNQFU7QE7rpqFN5Mj/r1uKWUjhOa/i+OuNZgEEiE
         mRSA==
X-Gm-Message-State: ACgBeo0sXauIwwaYuFsvK8OS5TO8OFnW4Ubc+c+UAHsr+ECaTZ45+eHs
        idGv2hjtss0mmOR7MVcktm+cAI0y5ar3QNc/
X-Google-Smtp-Source: AA6agR4hDsU9hwh7nZXKC2e7uf5INw8utSskCtLvd+tSSmaLvfPYIp61oyk7TCMEg+B8/kAgIrMu3Q==
X-Received: by 2002:a2e:be23:0:b0:25e:7756:5242 with SMTP id z35-20020a2ebe23000000b0025e77565242mr1326457ljq.443.1660319322970;
        Fri, 12 Aug 2022 08:48:42 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:be32:268f:3ab7:4324])
        by smtp.gmail.com with ESMTPSA id b14-20020a056512070e00b0048b97c7260csm249318lfs.222.2022.08.12.08.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 08:48:42 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guobin Huang <huangguobin4@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: moxa: inherit DMA masks to make dma_map_single() work
Date:   Fri, 12 Aug 2022 18:48:20 +0300
Message-Id: <20220812154820.2225457-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
moxart_mac_start_xmit() which leads to an incessant output of this:

[   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error

To make dma_map_single() work, inherit DMA masks from the platform device.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Pavel Skripkin <paskripkin@gmail.com>
CC: David S. Miller <davem@davemloft.net>
CC: Guobin Huang <huangguobin4@huawei.com>
CC: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index a3214a762e4b..de99211d85c2 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -537,6 +537,10 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 	ndev->irq = irq;
 
+	/* Inherit the DMA masks from the platform device */
+	ndev->dev.dma_mask = p_dev->dma_mask;
+	ndev->dev.coherent_dma_mask = p_dev->coherent_dma_mask;
+
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ret = register_netdev(ndev);
-- 
2.32.0

