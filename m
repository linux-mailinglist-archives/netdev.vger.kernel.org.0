Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836AB4CB52C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiCCC6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiCCC6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:58:07 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2124993A;
        Wed,  2 Mar 2022 18:57:23 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id ay10so5636535wrb.6;
        Wed, 02 Mar 2022 18:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=VWT1nnZHFDs5KVBOsFtYYBtJaBHbWpLPsvtCyOdWdNA=;
        b=WRMDzRVxlt+lbSe+XQv4GQ55KeEuKYtud9GSY9bBRprMwKCIGSWym34qliDbbk4IQd
         p0RV1PL+byNgeR70N1HoqI3dkGa3EhjEKO70n9HHQRYhbNDieIYRAifCt4X7DbJQfCle
         ma8XSa2zwNtVJB7YHyJ/PXvy4ty8AZzEwR5a+E2cqpPmrJs4a8A3ydGALHrBZlLN4mhd
         nwB5Tz/0YPUkFUWO4YWIjlXEob3yq3MgokWdj1CfB420hB1+aa23E1lwMrWkivCsjGLp
         z+s3LofRlqBznrnjuDADYlUZHSLsSBhFzIweBksvAZkG6eyAPhKESFQgPmgPHfzXQ6D3
         An9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VWT1nnZHFDs5KVBOsFtYYBtJaBHbWpLPsvtCyOdWdNA=;
        b=58T0HdP5Wxe0UdGTXr5YUDjg0mnznkSHmh1oZ9byhiPQ49jZH2JtZqkm39WDuP0VJK
         HBChYYWHmRQPWkemWTJwlaY+AI3KWuRy9hICHtNQvYqbxBtNA6SE+Pixm3kdDgq3yamT
         I6qqgZMLFTGG5EfEO/0XqydYnxqYsPrcftCqOkVj7TNSykWaFNlcze237dQ18a2SvTuL
         5lveBK4Mw9WU6cAydm4uG1fltUUYAEuruZeKfh/+2k4CgsFT67p1XTxPkvaOmf/DGFeT
         zJcySVXZ3qM4p1ZyjoNj9ZrAIQ39nPrdDteeAOySQomh+hsqhpy4q2iSIsoW7GTVwWRo
         FSqw==
X-Gm-Message-State: AOAM530ont+eJcW1ZHqsYul/az7Zip/GuIxKtyVDQslifQxPCxy+KyRQ
        1n3TJa3KlyhvopGKGbdsom4=
X-Google-Smtp-Source: ABdhPJwRki+RozVmL4+AnfkNifNb8GY8a4uRigih5L9Ru3UVsKhqOjv5ZFlPbnKgRKOYj4nox/IpOg==
X-Received: by 2002:a05:6000:16c9:b0:1ef:f2e8:1210 with SMTP id h9-20020a05600016c900b001eff2e81210mr10481252wrf.494.1646276241741;
        Wed, 02 Mar 2022 18:57:21 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.48])
        by smtp.gmail.com with ESMTPSA id k184-20020a1ca1c1000000b0038617ae5297sm2323697wme.33.2022.03.02.18.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 18:57:21 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     isdn@linux-pingi.de, davem@davemloft.net, zou_wei@huawei.com,
        zheyuma97@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
Date:   Wed,  2 Mar 2022 18:57:10 -0800
Message-Id: <20220303025710.1201-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dma_set_mask() in setup_hw() can fail, so its return value
should be checked.

Fixes: e85da794f658 ("mISDN: switch from 'pci_' to 'dma_' API")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index bd087cca1c1d..af17459c1a5c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2005,7 +2005,11 @@ setup_hw(struct hfc_pci *hc)
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
-	dma_set_mask(&hc->pdev->dev, 0xFFFF8000);
+	if (dma_set_mask(&hc->pdev->dev, 0xFFFF8000)) {
+		printk(KERN_WARNING
+		       "HFC-PCI: No usable DMA configuration!\n");
+		return -EIO;
+	}
 	buffer = dma_alloc_coherent(&hc->pdev->dev, 0x8000, &hc->hw.dmahandle,
 				    GFP_KERNEL);
 	/* We silently assume the address is okay if nonzero */
-- 
2.17.1

