Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B452D5061C3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343491AbiDSBnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245727AbiDSBnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:43:45 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418B525C77;
        Mon, 18 Apr 2022 18:41:05 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id fu34so2573174qtb.8;
        Mon, 18 Apr 2022 18:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNU/TphCFnbVlBp1Z5GLi2lvQvgI9Sbk164GKyVPu8E=;
        b=pfU22xzLs21/6Lq/Rrj8jK21a5J0ZtShm14Q1ECtF8xkydqjTPPth5Hf0uUGkd+z2H
         rBa1VP3+KB/MHJXwCo2BQOrsV0/tPZUz0ddrVNhel8yV8aSGm1ci2ATaJBtRDK8+iyAp
         yEYrhhDv4+frxfPpvrUYlrExB6gM3Gd8Mns8qKQGbodSz8Gv791RKfkIrbDVtqQLYk9+
         01glCHJ649U6gSAbcM2vGOcNYebrd2uHjOr/TRU4L8RHovjy6EXALfVDD3K7QIDrPPEj
         2rLMdo1Q+aNgk0QqEirQ42TTryNRnM4p5lgm3k+RdhRd2b1Kh5qAnvedFjHRTQ+9L1XC
         3RyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNU/TphCFnbVlBp1Z5GLi2lvQvgI9Sbk164GKyVPu8E=;
        b=tZfJ437m1TzcpQhz8x61IlJ1Pjs9aW9bvTHWS1OCOXfytG1quRENNn+ZiRoyvgFgu3
         hGz7NDMvBpwplArshOw+UEFgjmN+WTarEufa+NlPyrl7QbhKnGxFSsMrHXsSj6DwZB4w
         5DbQZfbGEIHJS72bXbZSZfTAfGI9xlCUe8RoMlnNEYSPEX9NjR3v2+IHkRkLIw9ggMtm
         nn76B9ZgX4qhTUNIIjPUWt2E01PJzkCDPytwpcCq5LZDaLTfaESfMuJzJ+GbDLyJdiFu
         8dkeFaXeH4X3K54P/vbvXjL+XY5riWvgeU1n71TwLjwWOhxI24Xi3cOIBXm/W52NFAUE
         L65w==
X-Gm-Message-State: AOAM532PwRovrVhiw7oqUL5km77SeS8o5+SMUpROMJQAh9lK5OHpTFm/
        7HZgBg1ONdSCl/iMNCKCsss=
X-Google-Smtp-Source: ABdhPJxW6v4zSCrzZlfYGwY7zwHvHS0HEYIJAi4Sf+TOZJQVtZsBpPB1dvzIRUobBStfs2t4C4oGbw==
X-Received: by 2002:a05:622a:1813:b0:2f1:fb18:3ea3 with SMTP id t19-20020a05622a181300b002f1fb183ea3mr5998736qtc.108.1650332464480;
        Mon, 18 Apr 2022 18:41:04 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 187-20020a370bc4000000b0069c8f01368csm6490447qkl.92.2022.04.18.18.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:41:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix error check return value of debugfs_create_dir()
Date:   Tue, 19 Apr 2022 01:40:56 +0000
Message-Id: <20220419014056.2561750-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

If an error occurs, debugfs_create_file() will return ERR_PTR(-ERROR),
so use IS_ERR() to check it.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index a81d3fd1a439..0c284c18a8d7 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -165,7 +165,7 @@ void mtk_wed_hw_add_debugfs(struct mtk_wed_hw *hw)
 
 	snprintf(hw->dirname, sizeof(hw->dirname), "wed%d", hw->index);
 	dir = debugfs_create_dir(hw->dirname, NULL);
-	if (!dir)
+	if (IS_ERR(dir))
 		return;
 
 	hw->debugfs_dir = dir;
-- 
2.25.1

