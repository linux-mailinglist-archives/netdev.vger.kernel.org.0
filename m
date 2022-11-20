Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9F46312A3
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 06:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKTFxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 00:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKTFxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 00:53:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D6A3414
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:53 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d20so7919307plr.10
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGq4tyssPNzEDZulOMeW9RPjXw3SFqYX386ZQSsBjlY=;
        b=XErg0odPq3M5zHxBgBcqwBTozIBXLKo2r3f8P5DSoaaPfxCQAXaXrL6BjwSADTLmh/
         Ylyg0fBh6PLrxrMPnfcHYSHehMOZQ7puR2S1c2ixrS4K6Uhc8G+7ds8QvB+QbytZu6c9
         H2pltRb4f44zNksau1bOxeLjq4xTmg/xHLVOYONaZ2UiOqsp3iYoM7jzgf/QH/1hgLxq
         9Xa8OiMHOX0sTgdSdq+DwZUpOoQPYvUICcj8diPIKr7zH8jwlsgxQ1Ef7Q/t6qtxvquu
         sQh5rX8OMWUm2p9VyxRoxU/zBqhs1UySTUo2qoqSFrV0Hyu7eSqP/nxcBIxhNkjStEsy
         F+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uGq4tyssPNzEDZulOMeW9RPjXw3SFqYX386ZQSsBjlY=;
        b=YIfdWw1tipWbpjUhkHCdTVuMRXsq9hi3PJ0k0XXZpzUj7rXHY8i3DcJAPvBEKizT2D
         V9I06Sbg4ByfIKxm4Z8bchgvRr6Fe+WIUe7veYNioUmihyOPNs+piFoNeP+VPG0rhhjs
         HM+IRr5c1OFkusU+dA6bI/jCBWsS1VirsafKKJxcQ9yakD+rLv/dCambXTc258snfRD3
         yDpzjPS/ifIeihC56J4Kr9ABaJu4CpDwfCLR0Jp25N1vq5y2FYsT03ezATEcZdXcJvMy
         3nQZG3PAd7UkrztaWld82lOpPQnodqzHRgYSfPBtCpczYkXLqcl4jJ0ckytetbgp/aaQ
         29sA==
X-Gm-Message-State: ANoB5pkFC906obzZIUMm2N2N6KbAdAuN6QqEtiC7cjNiy3tw60sL8hkO
        mxt/HtYtaWHf0CyGCx+aEWY=
X-Google-Smtp-Source: AA0mqf5J7cqrJ4uDIYDT9W2F9hVyVgKlM8ax/+iAhzRB95oj9Ntx8LlI1ky9XRQgxVWjfOD5r3lSeA==
X-Received: by 2002:a17:903:260d:b0:186:c56d:4950 with SMTP id jd13-20020a170903260d00b00186c56d4950mr6604878plb.69.1668923632564;
        Sat, 19 Nov 2022 21:53:52 -0800 (PST)
Received: from localhost.localdomain ([176.119.148.120])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902f60100b00186ac4b21cfsm6733397plg.230.2022.11.19.21.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 21:53:52 -0800 (PST)
From:   Yan Cangang <nalanzeyu@gmail.com>
To:     leon@kernel.org, kuba@kernel.org, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com
Cc:     netdev@vger.kernel.org, Yan Cangang <nalanzeyu@gmail.com>
Subject: [PATCH net v3 1/2] net: ethernet: mtk_eth_soc: fix resource leak in error path
Date:   Sun, 20 Nov 2022 13:52:58 +0800
Message-Id: <20221120055259.224555-2-nalanzeyu@gmail.com>
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

In mtk_probe(), when mtk_ppe_init() or mtk_eth_offload_init() failed,
mtk_mdio_cleanup() isn't called. Fix it.

Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1d1f2342e3ec..16269c6c09ac 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4145,13 +4145,13 @@ static int mtk_probe(struct platform_device *pdev)
 						   eth->soc->offload_version, i);
 			if (!eth->ppe[i]) {
 				err = -ENOMEM;
-				goto err_free_dev;
+				goto err_deinit_mdio;
 			}
 		}
 
 		err = mtk_eth_offload_init(eth);
 		if (err)
-			goto err_free_dev;
+			goto err_deinit_mdio;
 	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
-- 
2.30.2

