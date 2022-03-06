Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1794CE968
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 06:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiCFF5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 00:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCFF5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 00:57:42 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DE94667D;
        Sat,  5 Mar 2022 21:56:48 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso13886214pjj.2;
        Sat, 05 Mar 2022 21:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=os8w5Gg1D8GDaRBK134jrMfUsM5RiwH/cspVVHfLEfQ=;
        b=oDkJEYHWqpBGOoCCE+UIkta0bZOXDAt1vnfAyjjFl9bwu6IAOFniMRetXfRr/G2WI0
         9mfj0iG8Y6FR9eFz/xcah/GolnFa9Tza4oq/vQd5GLHb+0RyCuv7NoSV5Y4LMI6bSAFS
         P/48xIFk9u1ZXyYxPlF9ab7G2uGcrdtUrSIs6fCrk/eHvr168238nO5yFo1haQkFQhhD
         KUefk8OiIwe/4ZZXs4hS8rt6O6TjExdIe0jLWbq/SHQzhocBFC+BqPX/jLAQquoknlKo
         RZawPTU6eF4NpmhUOn1nNtwFwlH1oZ9OZ0N2M445rXqyxfV+BO8uRZ9tAACOSTO7/INI
         lkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=os8w5Gg1D8GDaRBK134jrMfUsM5RiwH/cspVVHfLEfQ=;
        b=UY5YftOWmL4KwmCEyQyci8yAN1U4NmwvhFjarYeKN/0D9X/h6mRUy88K/gSp5Qf0mo
         woOYPI+BwfvOkawsg40wwvwabhZdeEglrIQBobypByFgp80gjhfgxleoFQM2HASW20fM
         YxNKuwFZNi/4Pbdo7eiF9K5DMDsxkeXXQ0q6sjwNdW9gS6spiBH0J6mZ5L9+3J3/+P0L
         dz+pZ7XaFkp5npLnhdavTVn3CIQ7uq3ApcAOMGoz9I+/DpWVRBH7AK4f2qgWx9G+TSYs
         4XGKjFR6SEhwc1jhGdNKpcav8l5lhLqhU13UBgKm2ELS9GynT+lI/fOYypsWmLkbGZ25
         3Whg==
X-Gm-Message-State: AOAM533wQwsxMOiMcXf8k8zRuOvFobBT4B1RzJGEThEf07+z8IIqcjJG
        VCvXBhbtkcyx3XVe3GLosmeH8cFPdexD
X-Google-Smtp-Source: ABdhPJxZdk7IzJWMEVpn4XVwv8ZwF9tuF5nBDv2NgRjWXVG+0lW2Sn0USsANGw5+9aIEtNM0RN6GPg==
X-Received: by 2002:a17:90b:1e43:b0:1bf:920:8a26 with SMTP id pi3-20020a17090b1e4300b001bf09208a26mr18498127pjb.52.1646546207785;
        Sat, 05 Mar 2022 21:56:47 -0800 (PST)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id d4-20020a17090a8d8400b001bc386dc44bsm14986239pjo.23.2022.03.05.21.56.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Mar 2022 21:56:47 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     andrew@lunn.ch, rajur@chelsio.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH v2] net: cxgb3: Fix an error code when probing the driver
Date:   Sun,  6 Mar 2022 05:56:32 +0000
Message-Id: <1646546192-32737-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646490284-22791-1-git-send-email-zheyuma97@gmail.com>
References: <1646490284-22791-1-git-send-email-zheyuma97@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, probe function should return < 0
for failure, otherwise kernel will treat value >= 0 as success.

Therefore, the driver should set 'err' to -ENODEV when
'adapter->registered_device_map' is NULL. Otherwise kernel will assume
that the driver has been successfully probed and will cause unexpected
errors.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
Changes in v2:
    - Change the error code
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index bfffcaeee624..0d3325cf2107 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3346,6 +3346,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	if (!adapter->registered_device_map) {
 		dev_err(&pdev->dev, "could not register any net devices\n");
+		err = -ENODEV;
 		goto out_free_dev;
 	}
 
-- 
2.25.1

