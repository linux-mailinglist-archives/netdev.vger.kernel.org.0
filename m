Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609D3574F19
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbiGNNYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239612AbiGNNYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:24:33 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA861EC46
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 06:23:56 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f2so2553057wrr.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 06:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id;
        bh=SiUSVLAnvVeI5u+hwMpEBXSKNBAd6XuAgwmDbQkb2+k=;
        b=MF2P7I0Ginwmsdxmmi/Yd69qIq3iwQ35n847hudt5AGKrtK+E7zvcbs5QeELkSebfw
         /4N3ALBc53D6x3I9pDT30B9WDBZBCkvFgB1wxzoPtsnWF8KWVu63iTYNanQutQEuduOs
         QmouK3JqmrVxm1ArjivOlUhkLmJ3RNsasoIATEbzOCXnp5oPRfH34ISEYwuIv235wAVC
         x3WOrQf5EkhIXVJNzNosx0IPX0QMLpHoek/W6jdJitQjhHaxDLGP3QDBTJGy5StEdttZ
         97kEZoEQW4NhUbbCs2ZqDTXqKYhDj6Vp+1ovnfNDxQaU7kaDbmDHbLlervsws6b5zzg8
         BM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=SiUSVLAnvVeI5u+hwMpEBXSKNBAd6XuAgwmDbQkb2+k=;
        b=5TAoLGfxF8ZBg6Z+GnnmAm9FcS0Em+82b+YQEEAhnc44LSCOVdoQePmzm8IzbDQfyB
         tP8fkMjq/rG9Wdkl7yEoHAk769y4yl4SE6WPttZntcO9ZUL75wBo1nyWzeeR+aKhYs8E
         mAdIPUsD9XMEx/IKGhjOtDdlUZbKBgavxVD/FZVdBFo/3XZ+PJCe9UMjydhYguQjiyou
         hJc3aBvb75sCKSkoXg6MrHd2LTWKRJ1Q0qB8YTPZFUsg1cXdFfRBQCU4zjKZL7Bq8OQa
         LtkX0UlUDNP1wOm2ZzVslsP2FcsD3ipQzBdY4suM//e5dTe+dyDxlSwtp9VEYR5JQOkC
         nwCA==
X-Gm-Message-State: AJIora9bzQA4EfNHZKj1JEx39bCj/0uQtta5+gJAQO/3LpP/gDdXDRaA
        CBB9u+exCh9Y+WtthuMg5GF5KRVffVMoDmLDD0g=
X-Google-Smtp-Source: AGRyM1tAEl/NXP6JN1bElUNcQcbAbQ0hU7fg2/J8KaRXncBRyXFqZbF8C9wtN1vIBdPsC24CQ90/Ew==
X-Received: by 2002:a05:6000:1085:b0:21d:7afc:1424 with SMTP id y5-20020a056000108500b0021d7afc1424mr8281387wrw.553.1657805034611;
        Thu, 14 Jul 2022 06:23:54 -0700 (PDT)
Received: from localhost.localdomain ([5.35.12.50])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b0039c4ba160absm12229783wms.2.2022.07.14.06.23.54
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jul 2022 06:23:54 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Subject: [PATCH] net: altera: Handle dma_set_coherent_mask error codes
Date:   Thu, 14 Jul 2022 16:23:42 +0300
Message-Id: <20220714132342.13051-1-kda@linux-powerpc.org>
X-Mailer: git-send-email 2.16.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

handle the error in the case that DMA mask is not supportyed

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 8c5828582c21..7773d978321a 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1439,10 +1439,14 @@ static int altera_tse_probe(struct platform_device *pdev)
 	}
 
 	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
-		dma_set_coherent_mask(priv->device,
+		ret = dma_set_coherent_mask(priv->device,
 				      DMA_BIT_MASK(priv->dmaops->dmamask));
+		if (ret)
+			goto err_free_netdev;
 	} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
-		dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
+		ret = dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
+		if (ret)
+			goto err_free_netdev;
 	} else {
 		ret = -EIO;
 		goto err_free_netdev;
-- 
2.16.4

