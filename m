Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBE4FDBAA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiDLKGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351941AbiDLJmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:42:33 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6821013E15;
        Tue, 12 Apr 2022 01:51:32 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z16so16921195pfh.3;
        Tue, 12 Apr 2022 01:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WLg00iAtfnL7pmg00LeUrTt106/C7VI+77BQXv24oU=;
        b=hcH+S+ZkyHRqTzPb7UUggtmrBlax6NtGVOa9Cov0lkAPMN8Ne25YWc3fq5tTj1LMR/
         Q6eXAsA/lvqkRdebokrZj918JTWERk4pPrgIc5lttKHaVRA7smmd2UTOFEuAEksOEnPc
         dSH5xeGBmXuGWJcsDdcRcbmRfajERGMK+z8PfdoQ0aHygLBW5eM9ztnADl4MJvkJ85AE
         NbxdcXaiCc7NnclAay1RvKLnIXnZzVlDZz6x2elapYJKAwmI0rAO6AHKUn4PUJpkDd39
         9k2oMVm0HeV/6V0HHXOMFDHBypyQH7/Drm7IaJjIBxSBG+8kRHGzHSpv/qtRKAxlcEjI
         gmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3WLg00iAtfnL7pmg00LeUrTt106/C7VI+77BQXv24oU=;
        b=igcjEKL5ZtjvNAILehx304WcMwhpFiirM9lJ9GUzJ5Sqn9zos6nH4YiTgnNzNpSNOd
         BSjt6PSoRSe6ef0RSpcBKH2JWx+kRqQhMbtAxiInnAZU5l3nyBjlV0VXofjn43H+mM91
         AvvghNKhVf5urpGFkfejZjKcYE39Lo1fQ0u9IZ8BiBcWVgyS+C4S2r62pufq3J5f26v6
         N52aUAmJNPxlNyJ+edgKcTUPO0h+cE7hGTgJ66Gb1z4KlJZUp4TcEaBKl9ymM3sEk8J5
         WE8L6TFaujDlA4WIcX+x93Y7ggVNu2pacDgT2j2cmZzE8ewcjzNGADr/WuSD1BcNpbAw
         31ew==
X-Gm-Message-State: AOAM532VztHRzaLFUaMSg5Ygr0WVrOeyZX6UH/mwmpI0peQ+zbb/H3xn
        josQhGF1icApbJAUmtt7cuY=
X-Google-Smtp-Source: ABdhPJw97PpSb4uHzXslZKqacwDVSDfJrRt/hJFxD8nU9dbNgh0hoJE+/6enklzvGXfW2UypDbuxcQ==
X-Received: by 2002:a63:7701:0:b0:382:7f20:5f83 with SMTP id s1-20020a637701000000b003827f205f83mr29394251pgc.163.1649753491910;
        Tue, 12 Apr 2022 01:51:31 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b80-20020a621b53000000b005059f5d7587sm10535851pfb.60.2022.04.12.01.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:51:31 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linus.walleij@linaro.org, arnd@arndb.de, lv.ruyi@zte.com.cn,
        wanjiabing@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ixp4xx_eth: fix error check return value of platform_get_irq()
Date:   Tue, 12 Apr 2022 08:51:26 +0000
Message-Id: <20220412085126.2532924-1-lv.ruyi@zte.com.cn>
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

platform_get_irq() return negative value on failure, so null check of
return value is incorrect. Fix it by comparing whether it is less than
zero.

Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 1f382777aa5a..9abbdb71e629 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -271,7 +271,7 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	ixp_clock.master_irq = platform_get_irq(pdev, 0);
 	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
 	if (IS_ERR(ixp_clock.regs) ||
-	    !ixp_clock.master_irq || !ixp_clock.slave_irq)
+	    ixp_clock.master_irq < 0 || ixp_clock.slave_irq < 0)
 		return -ENXIO;
 
 	ixp_clock.caps = ptp_ixp_caps;
-- 
2.25.1

