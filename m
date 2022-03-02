Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD6C4CA4C0
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 13:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiCBMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 07:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiCBMZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 07:25:25 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E218C1C8D;
        Wed,  2 Mar 2022 04:24:40 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o8so1477248pgf.9;
        Wed, 02 Mar 2022 04:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDTg97giT1w4UkqUHDJQChQ0iXlcc4URzPQyrsb+epo=;
        b=U3lVbRMIfoWU+t87B4a2k2mgM8CkO2PEG90/U3hxRhx5a7LCpwNPQLz9zVBA/aWpc0
         780KVNWRLuHbVNqjc/IypFEOf2qquswJquVo1gMLLPYXR6MHqFapZefKfFZnmT1SLtio
         IlPNcfhBuxuCQYoJ0QHT/jcWgxVsXaLmc2WrbT1B38e/ZIHTj6SmL+UhJCAhina6zP5X
         yNU/f20G6tM0WrKKJX/+nvqm+1l3RvP4gdP/zhtT1Z2YrSndoJaxkhgOkVTFhUwe+YL7
         5+Nm94CE3vwKc2fHEeWitVKtxuvmCMX5QwiearRNDBkWRYbKbv4aZXfm3wRauu84qtic
         0ziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cDTg97giT1w4UkqUHDJQChQ0iXlcc4URzPQyrsb+epo=;
        b=5hL8Yd3tKPSdbK16dW0s1hglxR8QCpw30fCIwwN+wYFrn1hETY8Ka+3GnoO7YwmdQl
         6qCG1xoqTaI5l3YY2vukuPHgws6RGL5ahckdGIBgqmfiZ8dvJfu+imJpkU2GobQ9cISy
         NuQdsqLtAGog/xMQgSELedIl8HyUNgne50nxyBm4ubd5mB2Ht87mugsEDBLBivj68fJ8
         o7ui/8l5pHAxAuDXYfUSgi2m43X7mL00fGo9uZWnqhA5p3eyI4RD3216pJ0BpQhQBATd
         6z8tqoqFXK52+4qGPgXkgIiJXNLqwFL21Um4rOA75iZY0OCFg1Fl0i5UNQ7iFSvNxGd6
         Znnw==
X-Gm-Message-State: AOAM532e8pwfKNLE1QWHI5QVMuGvn3NBW5/iZaQEhPLBpVyHumvC1YJc
        K30HcHUpiG9IvqfuzaKIgw==
X-Google-Smtp-Source: ABdhPJwEA1XwhWCIzafS1YdEePdYyPSB+32gTHUngKk5ncC0ydYcP6rusXTAUGm49fRiKPBfhlZcIw==
X-Received: by 2002:a62:ddcc:0:b0:4e1:c248:d4a7 with SMTP id w195-20020a62ddcc000000b004e1c248d4a7mr32718797pff.63.1646223879848;
        Wed, 02 Mar 2022 04:24:39 -0800 (PST)
Received: from localhost.localdomain ([8.21.11.252])
        by smtp.gmail.com with ESMTPSA id gb9-20020a17090b060900b001beecaf986dsm3121105pjb.52.2022.03.02.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 04:24:39 -0800 (PST)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH v2] net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()
Date:   Wed,  2 Mar 2022 20:24:23 +0800
Message-Id: <20220302122423.4029168-1-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Fixes: 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
Changes in v2:
    - Add 'fixes' tag
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

