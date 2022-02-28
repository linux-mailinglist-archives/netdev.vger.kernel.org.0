Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3147E4C6B0C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbiB1LpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236003AbiB1LpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:45:09 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508B255BF8;
        Mon, 28 Feb 2022 03:44:31 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 139so11168958pge.1;
        Mon, 28 Feb 2022 03:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=y21FhvJidn6kLBskYYJE+cynG9YW5dkgghGH1W6oQO4=;
        b=bngQB9AxEvfodIiKLDevwmFCMFfB8S+Io5eTI8BEb+bH8awluo4P3n7S1Asxqv4lRM
         DebJbiuzHO8D1T3QTSffQxTAoP6L4xEJgiUwdinekx5/r2zCv4zjVcsHNc4sbCGfOCWW
         L+BUqXnvWqXe2TwUhNZuKRT+XTwadrAfmgHORQffxcKf7R8QGAZZXsHrLbnY09eCyg9e
         dw6Y+hMW7pIXNyUD/77pVpFvfv32MCdsOSDvM2ZZzaJzi54LByAB4fdF208rmUXxcIqc
         0jrkfrD+jWx2qtEEAkcTZBTdpc96+fwydms9Iv8NJoZjLDMaRbKj1i7TxQm83M2e1dMn
         sKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y21FhvJidn6kLBskYYJE+cynG9YW5dkgghGH1W6oQO4=;
        b=1OAOwOdO1093jXTyqgdS5aE7OzLgtZ7E9/ZLBq/1feIrzgvpzl948CVlmyD0xM8KMJ
         okpcKMRT1981vsKlQdSUtXpwN3lAVGFkyh/wuZqnqPZqAfWTSMHq9eRhhW4y0B3QNLgW
         jSl/O5IMTgRxgWxsCLAGUfwcsrYgdxyQHeb11Kak4TLK2c5cbcH2EeNS+Mmb7oK6vf5a
         V9+2bcT7hPNOsXAxUXJVjhKlkDy/7uxFvFW7+H75qyr3M8doKjERG7VLIws0NMM/YqIh
         d6bzlLP/rLMcodsLxnYVrvSB0PEn1UZfnAan5UBMD3CCKBdrPen/jqic2S5vjhuAVLM4
         vvow==
X-Gm-Message-State: AOAM530pIkS0IO1bucD9KX1wHvQ4QkuvKL1jQtzsfO6xS2wMWMDqc3Hz
        qC4mRUBN7zczoYS27DMtsbKFPcH/pMix
X-Google-Smtp-Source: ABdhPJyyDqaJyjmrWNj+EkzM6gXfAmiwtItUrLZ74LSfs0s5Fsx/+24VkHe8VdphlIJwUq5aZ6alug==
X-Received: by 2002:a05:6a00:21cd:b0:4e1:b09b:18e8 with SMTP id t13-20020a056a0021cd00b004e1b09b18e8mr21141927pfj.60.1646048670760;
        Mon, 28 Feb 2022 03:44:30 -0800 (PST)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id g7-20020a056a000b8700b004e1bed5c3bfsm13532189pfj.68.2022.02.28.03.44.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 03:44:30 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()
Date:   Mon, 28 Feb 2022 11:44:13 +0000
Message-Id: <1646048653-8962-1-git-send-email-zheyuma97@gmail.com>
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

During driver initialization, the pointer of card info, i.e. the
variable 'ci' is required. However, the definition of
'com20020pci_id_table' reveals that this field is empty for some
devices, which will cause null pointer dereference when initializing
these devices.

The following log reveals it:

[    3.973806] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[    3.973819] RIP: 0010:com20020pci_probe+0x18d/0x13e0 [com20020_pci]
[    3.975181] Call Trace:
[    3.976208]  local_pci_probe+0x13f/0x210
[    3.977248]  pci_device_probe+0x34c/0x6d0
[    3.977255]  ? pci_uevent+0x470/0x470
[    3.978265]  really_probe+0x24c/0x8d0
[    3.978273]  __driver_probe_device+0x1b3/0x280
[    3.979288]  driver_probe_device+0x50/0x370

Fix this by checking whether the 'ci' is a null pointer first.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/arcnet/com20020-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 6382e1937cca..c580acb8b1d3 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -138,6 +138,9 @@ static int com20020pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	ci = (struct com20020_pci_card_info *)id->driver_data;
+	if (!ci)
+		return -EINVAL;
+
 	priv->ci = ci;
 	mm = &ci->misc_map;
 
-- 
2.25.1

