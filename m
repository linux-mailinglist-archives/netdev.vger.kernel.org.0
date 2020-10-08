Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3028790E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbgJHP5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730838AbgJHP4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:56:08 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2771C0613D4;
        Thu,  8 Oct 2020 08:56:08 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x13so1720840pfa.9;
        Thu, 08 Oct 2020 08:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZvYaQVw6tdHVX47TfuI83g8RHr4L9yGtu355lu4vO1c=;
        b=s2ewPt/UIRSsbbXGz0xkcB30BjP6voTYIqbNUu+9+RjYOd5+kjxtQXwuvGoJDREzHV
         7hopy7CqWGzf37YK79GSVS+9latdLL2dtp7VKyknG+/6Cgxe68QjiePBrzU1SLrqx0J1
         TNBYahzNMrH8N8eSWFfD153A+eywoRui1AQVvzaiEoDTen1sxquTdmBVoPdT4RTgFik7
         kovz7F5LRV48VV2SNBghBM5u9ooa4GL4bh1IdM5DIRJXb0AQnvkN6hZyrTjiP3DTqIPQ
         19DvfSPzD6tV6xVhbFeVNAZA6wXJkXN+AAodjUj+Lc9xXXbEeCLqGapuc1NPg12VZLRS
         gkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZvYaQVw6tdHVX47TfuI83g8RHr4L9yGtu355lu4vO1c=;
        b=BiQp2IEJhHyc274Q+zbsUN8F1caX2DvppTy/s+T3mB7DAPx7bwy8YlTRjdAY3AghvW
         mXYdPLlxoMqyyA6j2n56LJtiKIeIi304yZ6o6013z0eqrqpDmd1TdyIGYa5m7mdKTDwd
         U1VckEuInSblVKSv36PEFl/HoDRSVAb6r6QkSiANN1b348IAYDx5B+nCOSMMjylABX/+
         pnQ/Xlzy3X8B389+pIal+lTfGRT9DPQlm9Ub7r3nawoB4N25Nh7ygdulwBhwHpYSNh12
         kJqOeVQvzb6AsIYiPozXW1qgtIB5eAFoz2LHZ9XbUJnjMUh66ZAU4QBZUN3ezIDnpANM
         K8vg==
X-Gm-Message-State: AOAM533IgJA3TPHRKtLLVs//U0I1eRejrSLdqlbrFwJvAhQu2MyxU7rY
        tot1YKlbO1t7G4LCUEssTL0=
X-Google-Smtp-Source: ABdhPJyj2Ebt5t0kYvL7Jsu/N9/1ctDAL7HDf+2IjvuD0lavv4Hlp3GQIkZ5PJiQsBrPC6RPvTKBEg==
X-Received: by 2002:a63:5663:: with SMTP id g35mr8173391pgm.163.1602172568359;
        Thu, 08 Oct 2020 08:56:08 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:56:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 073/117] wcn36xx: set fops_wcn36xx_bmps.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:25 +0000
Message-Id: <20201008155209.18025-73-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 389b5e7129a6..6bd874c0a9f5 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -93,6 +93,7 @@ static const struct file_operations fops_wcn36xx_bmps = {
 	.open = simple_open,
 	.read  =       read_file_bool_bmps,
 	.write =       write_file_bool_bmps,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t write_file_dump(struct file *file,
-- 
2.17.1

