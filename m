Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7989E403F51
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhIHTDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhIHTDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 15:03:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F17C061575;
        Wed,  8 Sep 2021 12:02:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so2219059pjx.5;
        Wed, 08 Sep 2021 12:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U1k5GQSTcred1g/ZNyrVoNcjW0ouRAOMfDJ41Mlu1oc=;
        b=cHhAr/lTYynEQBFsKa9bx49xDOWen4UKlN3N8aXy/rpd3jiIQFEHC2kaq+Z+bY36Zs
         WdPi/s4bZdmkVchfc/YH5j41O1S11CM2y5AhS3lKqBofNAWGMwgPhReJTCZ+zcBaoOsC
         rFhJeGr9TIwv2+kZCFw7mnhLH2YfNLUuj/9j+rD7AR7S0I7m1WBjwZSeAHmj+d05RF83
         TVBNVxI7WEUby8GBpFrYiDoL+PuNIdDyATfskZj1d2xDmMg3jNFFnqqI2WyWawneT+Cl
         mekjiSFZuGdABZ2cx283w3cSy/ihiUeyQKQU+1hBVeD3CLoJQnBIUQXUYL0Ek+dbyKep
         rX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U1k5GQSTcred1g/ZNyrVoNcjW0ouRAOMfDJ41Mlu1oc=;
        b=JfZNbhIR21dk5ZdgkL3OVUe/UMIqsGgD/05vDWSb7gNZKZTR/zq3u6rhREAFjocaQk
         nbFB5VuIZl2VOwxDcDuGjdlyHKVLObwtTfwXzWm/cRcNTC6tupsiytVNQDO3iNroD28p
         POp8GXQDnlddJwQ/UQOPG3m0g+uIIJB5S+w6qUVn3ap5Tx06sSZDCXWWNLDiN8k+9Cye
         +mIUYTGAElMRgd9VbMs53Zl1wGp6vFybz3fotth788Gw9lrcbch3OEJGjk7BmP6ALNxz
         NdgTj4b1p3ofv6oYdUzKMFYLRcnHzlpXb6uLUVy5K27irCRzubQ77fE5iTsuc5YzRbk/
         sIVQ==
X-Gm-Message-State: AOAM531YD/RX45VGWxNW2bhveN/cYkjPNoljRcIyc9+Wx690KW0SkCIa
        d04IWmY+lIHLJz4o+6jAsU3mObCgg/D8Wg==
X-Google-Smtp-Source: ABdhPJxbQeIDZMPm9HrQqP63h0FIOAqMScmLwBrQe91itkWilAyF+eWES5YKI987V80RiPJBE57cyQ==
X-Received: by 2002:a17:90b:1952:: with SMTP id nk18mr5688240pjb.193.1631127761633;
        Wed, 08 Sep 2021 12:02:41 -0700 (PDT)
Received: from tong-desktop.local (99-105-211-126.lightspeed.sntcca.sbcglobal.net. [99.105.211.126])
        by smtp.googlemail.com with ESMTPSA id t10sm3863378pge.10.2021.09.08.12.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:02:41 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>
Subject: [PATCH v2] net: macb: fix use after free on rmmod
Date:   Wed,  8 Sep 2021 12:02:32 -0700
Message-Id: <20210908190232.573178-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
References: <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

plat_dev->dev->platform_data is released by platform_device_unregister(),
use of pclk and hclk is a use-after-free. Since device unregister won't
need a clk device we adjust the function call sequence to fix this issue.

[   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
[   31.275563] Freed by task 306:
[   30.276782]  platform_device_release+0x25/0x80

Suggested-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
v2: switch lines to fix the issue instead

 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 8b7b59908a1a..f66d22de5168 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -111,9 +111,9 @@ static void macb_remove(struct pci_dev *pdev)
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
 
-	platform_device_unregister(plat_dev);
 	clk_unregister(plat_data->pclk);
 	clk_unregister(plat_data->hclk);
+	platform_device_unregister(plat_dev);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.25.1

