Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82ED576E17
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 15:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiGPNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiGPNFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 09:05:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED55260A;
        Sat, 16 Jul 2022 06:05:21 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y15so613991plp.10;
        Sat, 16 Jul 2022 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jjGe3L9TiFV6FJ+E5XvhpZkMgf2NPsXY2lR2l1aKcOw=;
        b=LuJB6kFsh4VY/mnIXcqQJrOwgfXgxeB0fhwqOD19C18NFhqJlobgI207hSjyUFSm/K
         wtu8073cDoTMp9bp7sQP7hM441QxRazaD6h4T+2/wE0UP0BYYWr/FS7W6VKJ6qRTTOX0
         eGNe3kEZEAeKiS20iqQf+VfaL5vY2EcemsrydY4dqFTqwzZJ1DHBPQE3tTbNg5YsbtKH
         tzK98El1Q24VgN1WMYBHyecdzXhY8K5lblupRN3uTdHQYxixIsy+FW/n2YNG1DfnjxyS
         2nW72M1rTWg/PR1HsjiHMglT0sMtnJd8ElzINgVl/sr5qRjX0rXtGTmspLaUMobIIjfg
         zJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jjGe3L9TiFV6FJ+E5XvhpZkMgf2NPsXY2lR2l1aKcOw=;
        b=JAjti+vgsGQGXbs4gfSHbf3B7TmpfwtITlM8virfrdqChoIjyR+8qOl6kIZUgP8kK1
         ModVJWeF8UCpEfSd6uXDu6q25HK8AfqMrH6vecd2tMv6U2EVmIyBITeI25Yx0FePbEVx
         Rlklb4w8Ks2XV+KPI4FG3PUHn5S1aR3Zjn1U2XGUqcGA1VKha/n8OLgAyeYpGI0YcOOT
         Cf/Em19VhoEPUIW++kwxUQ2BCvJo39IZ5vxnmoiZHYF3sGx22scJIX58aRAqtzvq2vk6
         Gd4g6FGU9Acexpj8OVydKKSqsGw2EdHMQXOjSxDtzxKCkwEM9Ba9hsUlo729P8kyZ+5w
         Z/8A==
X-Gm-Message-State: AJIora8qI0t3XJX3bmUR9MT4WKA5y4gTrPQXWATNSAT+trlwz3epkw5P
        0NCwNDcbb8+NYJCdUcvoDA==
X-Google-Smtp-Source: AGRyM1tpLyZ3E7V+hBKicc0Of0PUmmRR1fbvKmZuhak2HBexH8vuX/nJGgNi2qA/021ABkNhrh4ELA==
X-Received: by 2002:a17:902:b712:b0:16b:d667:ab59 with SMTP id d18-20020a170902b71200b0016bd667ab59mr18826698pls.74.1657976720928;
        Sat, 16 Jul 2022 06:05:20 -0700 (PDT)
Received: from localhost.localdomain ([144.202.91.207])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902e38300b0015e8d4eb1c8sm5456831ple.18.2022.07.16.06.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 06:05:20 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] rtl8xxxu: Fix the error handling of the probe function
Date:   Sat, 16 Jul 2022 21:04:44 +0800
Message-Id: <20220716130444.2950690-1-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver fails at ieee80211_alloc_hw() at the probe time, the
driver will free the 'hw' which is not allocated, causing a bug.

The following log can reveal it:

[   15.981294] BUG: KASAN: user-memory-access in mutex_is_locked+0xe/0x40
[   15.981558] Read of size 8 at addr 0000000000001ab0 by task modprobe/373
[   15.982583] Call Trace:
[   15.984282]  ieee80211_free_hw+0x22/0x390
[   15.984446]  rtl8xxxu_probe+0x3a1/0xab30 [rtl8xxxu]

Fix the bug by changing the order of the error handling.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 8b2ca9e8eac6..567ada2e665a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6657,7 +6657,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	if (!hw) {
 		ret = -ENOMEM;
 		priv = NULL;
-		goto exit;
+		goto err_put_dev;
 	}
 
 	priv = hw->priv;
@@ -6679,24 +6679,24 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 
 	ret = rtl8xxxu_parse_usb(priv, interface);
 	if (ret)
-		goto exit;
+		goto err_set_intfdata;
 
 	ret = rtl8xxxu_identify_chip(priv);
 	if (ret) {
 		dev_err(&udev->dev, "Fatal - failed to identify chip\n");
-		goto exit;
+		goto err_set_intfdata;
 	}
 
 	ret = rtl8xxxu_read_efuse(priv);
 	if (ret) {
 		dev_err(&udev->dev, "Fatal - failed to read EFuse\n");
-		goto exit;
+		goto err_set_intfdata;
 	}
 
 	ret = priv->fops->parse_efuse(priv);
 	if (ret) {
 		dev_err(&udev->dev, "Fatal - failed to parse EFuse\n");
-		goto exit;
+		goto err_set_intfdata;
 	}
 
 	rtl8xxxu_print_chipinfo(priv);
@@ -6704,12 +6704,12 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	ret = priv->fops->load_firmware(priv);
 	if (ret) {
 		dev_err(&udev->dev, "Fatal - failed to load firmware\n");
-		goto exit;
+		goto err_set_intfdata;
 	}
 
 	ret = rtl8xxxu_init_device(hw);
 	if (ret)
-		goto exit;
+		goto err_set_intfdata;
 
 	hw->wiphy->max_scan_ssids = 1;
 	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
@@ -6759,12 +6759,12 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	if (ret) {
 		dev_err(&udev->dev, "%s: Failed to register: %i\n",
 			__func__, ret);
-		goto exit;
+		goto err_set_intfdata;
 	}
 
 	return 0;
 
-exit:
+err_set_intfdata:
 	usb_set_intfdata(interface, NULL);
 
 	if (priv) {
@@ -6772,9 +6772,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		mutex_destroy(&priv->usb_buf_mutex);
 		mutex_destroy(&priv->h2c_mutex);
 	}
-	usb_put_dev(udev);
 
 	ieee80211_free_hw(hw);
+err_put_dev:
+	usb_put_dev(udev);
 
 	return ret;
 }
-- 
2.25.1

