Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1184B4C83DA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 07:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiCAGRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 01:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiCAGRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 01:17:48 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955EF66610;
        Mon, 28 Feb 2022 22:17:07 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o23so13558838pgk.13;
        Mon, 28 Feb 2022 22:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=bRCqQChC7MrmALWDDLp0brhfRcUBh/cUVk5Hjz2Bq50=;
        b=RtbrAaRd+XkSo/V5lQtmt3cMwYufBKfByAp0krUUNZDOuz2skInm4FYa0UmCk5YHZM
         Ta2ggGl18m4OZWLX42v90oa6831sgVnKmtQXGTOV+FbrnGoYS/dgxMW4MndWxQ5EAGsZ
         RKt0GhBeCMvzdR5P6yy9Xig+DzXk2c/nJLnX01ZF7ZuK934fobYlBmLCi2MbSVysWQnX
         xfZ/kW6i9QPtvdEplunaxcWvghm3fP5X+nGR8s8ns45otkn+8WJCwqEG2auE71zuS9aA
         bwHrzWDj/fgWncYUTMtrCjZk2oI2PrgvDvpoZzdt1BioU4Ju4DwkUzW90Bg7U/LsgBOa
         x/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bRCqQChC7MrmALWDDLp0brhfRcUBh/cUVk5Hjz2Bq50=;
        b=Okh/mFrVVavvVOpCDMmWR4r38yjb+BAJrqMgBnS3zQgMkLwZ2va0YmPYz3jNvz0051
         s26YTgl7V68o9xv0xSRAGLRu9DBCSQ3zSPTzbJcxwMSkiC9d/DbxW22zU6Qx8aDXIM5Z
         sYB5lO5BsV2ypjmjRK7WPYaBLmqWDZjM6ClOshBhSqznyL3w71Vhl4ySluGHAu3ms73S
         q1d8sxfp7yMD0CZGAHR/Sl3sfRftrgQ1p6B0iupxGoSaxQ6VGZ4BPYTLCNk4P1A4ja4B
         PuuiEZVeozXKpCcPo+ZafyXVKc4RHz9EO8f4evBKmBsyWbAznXoAogurSaUYgbMSuRX3
         Bx5Q==
X-Gm-Message-State: AOAM533rfVh8PO/tuv4SFet8KKUU5e1Zv9lVvtnTnqPUq/XBUy27fA9n
        smTaKd1WRdfn3mtQSzGb+QM=
X-Google-Smtp-Source: ABdhPJyxi1tQkpS/TuMBswvco6T7c/fFdaI6NyPDt30nGJEZa6bMkvJnnA/3MFnADSpFaW2Zhvo9mQ==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr25499132pfu.59.1646115427085;
        Mon, 28 Feb 2022 22:17:07 -0800 (PST)
Received: from meizu.meizu.com ([137.59.103.163])
        by smtp.gmail.com with ESMTPSA id z13-20020a63e10d000000b003733d6c90e4sm11614924pgh.82.2022.02.28.22.17.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 22:17:06 -0800 (PST)
From:   Haowen Bai <baihaowen88@gmail.com>
To:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen88@gmail.com>
Subject: [PATCH] net: marvell: Use min() instead of doing it manually
Date:   Tue,  1 Mar 2022 14:16:57 +0800
Message-Id: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com>
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

Fix following coccicheck warning:
drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportunity for min()

Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 143ca8b..1018b9e 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
 	if (er->rx_mini_pending || er->rx_jumbo_pending)
 		return -EINVAL;
 
-	mp->rx_ring_size = er->rx_pending < 4096 ? er->rx_pending : 4096;
+	mp->rx_ring_size = min(er->rx_pending, 4096);
 	mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
 				   MV643XX_MAX_SKB_DESCS * 2, 4096);
 	if (mp->tx_ring_size != er->tx_pending)
-- 
2.7.4

