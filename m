Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989E64812F9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhL2M5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbhL2M5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:57:43 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90DBC061574;
        Wed, 29 Dec 2021 04:57:42 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id v15so35871909ljc.0;
        Wed, 29 Dec 2021 04:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ymrcu0NdAYgBRfMD3NZIRZpuT2x6n05Qa8UE3nDq6AY=;
        b=PjqwIzKFowUjUXAaUK+hQsZm25oNliCOT+bzV5Fa1h1M/+2zCwlKN9GKvoIjI8DSiD
         6v2wbhAwTNn7qazJozydYiPff3vqEO6XLsYxLB+8xB+xPZFN70KHh5PbyYkNuX4cXPhB
         DeRHlYlOAhVCPnw6fGrPFLRckvQbODo1pO7OzPWqn/PSvQLuS8WaKBu9A0iYt8ji3M0g
         npJXjpaFDyNjXo/0aDs3eoOAIDhaq0iUVaf/4TXhcNFEQTn27i3/JrN2kDnFX1gbcL+Z
         IX3WOzOotTCPHFQGGRpIz6acLDQQ7dft6YZD7jiEvP1Mf0VTWep8w6HpXlddP6hkvK/z
         hRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ymrcu0NdAYgBRfMD3NZIRZpuT2x6n05Qa8UE3nDq6AY=;
        b=VFuneEQtzbgxDAOwUlPQso2oDbw7imVRjk4RQr9XkVn+UxFSLB7gFCUXFObF0Tb7dy
         e4XJUVv3g1s1qAo4uNwFw6dchGB6sic5af55hR5q261lu8hmuaAuI0cVfEL8cvDOQYW6
         g5ZNZgndY1C36+zR9U5zE2lVw7Qs98EY5380tMhVscgjJ8uCLaBIpcj+XUR08LWcJNyh
         IFKLIEwwpaQdBgAWJ7a+txDNQNeQHRHADlgvkHnQE011y9Sf0ldmX/FgZddByacPwE+w
         118zWq0CdQFEbBFZRRRntxaHt2NOVmdzn7A5nYkucPgS3aOCvETBQ1+wnKILGUHjv58F
         35BA==
X-Gm-Message-State: AOAM532/j+buhRLL5avgqBhJaW3JUpKHc+PGChe0MiEAmXe45Us8F6YX
        yIFvOUt8iWzRpA66bSU9g2skfdJVoxHwqA==
X-Google-Smtp-Source: ABdhPJyfju1VKSrobnGp63EhJj/x8pNA64RJqEZfbtxXkj9yq3bGwq1qAxlkGlV8AHrE8ekptBV46w==
X-Received: by 2002:a05:651c:891:: with SMTP id d17mr10534009ljq.502.1640782660949;
        Wed, 29 Dec 2021 04:57:40 -0800 (PST)
Received: from grimoire.. ([178.176.72.189])
        by smtp.googlemail.com with ESMTPSA id l1sm261525ljq.130.2021.12.29.04.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 04:57:40 -0800 (PST)
From:   Adam Kandur <sys.arch.adam@gmail.com>
To:     linux-usb@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adam Kandur <sys.arch.adam@gmail.com>
Subject: [PATCH] net/usb: remove goto in ax88772_reset()
Date:   Wed, 29 Dec 2021 15:57:30 +0300
Message-Id: <20211229125730.6779-1-sys.arch.adam@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

goto statements in ax88772_reset() in net/usb/asix_devices.c are used
to return ret variable. As function by default returns 0 if ret
variable >= 0 and "out:" only returns ret, I assume goto might be
removed.

Signed-off-by: Adam Kandur <sys.arch.adam@gmail.com>

---
 drivers/net/usb/asix_devices.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 4514d35ef..9de5fc53f 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -332,23 +332,20 @@ static int ax88772_reset(struct usbnet *dev)
 	ret = asix_write_cmd(dev, AX_CMD_WRITE_NODE_ID, 0, 0,
 			     ETH_ALEN, data->mac_addr, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	/* Set RX_CTL to default values with 2k buffer, and enable cactus */
 	ret = asix_write_rx_ctl(dev, AX_DEFAULT_RX_CTL, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = asix_write_medium_mode(dev, AX88772_MEDIUM_DEFAULT, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	phy_start(priv->phydev);
 
 	return 0;
-
-out:
-	return ret;
 }
 
 static int ax88772_hw_reset(struct usbnet *dev, int in_pm)
-- 
2.34.0

