Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFBA412AC7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbhIUB6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhIUBuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D2CC06AB04;
        Mon, 20 Sep 2021 14:54:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso1005667pjb.3;
        Mon, 20 Sep 2021 14:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmOHqsChp2kVGC4NmmlLg2wVuuPYUcY2cFvEjqxXRkQ=;
        b=oVYwHQoDV575JPkk1cIIp2zGJ8/UerEtQcZsBSreGRwOLNsVwr0qfmecU/Pe1vqZI7
         FP2Sx15nhpWvTmE3kxKwRUdgINyJF0PxDxlVWt1EwDlgHAl3A7s1h6VAZ4zmWom6/GRa
         rNXEOL4Tk28w0IejhhQwB7ysGD5b+SyobiNxGNHWvAOjBimRCyBVoLzi9zh4XpLwsWHe
         N8Roz0QTbZrhL2k6U7YV7xBV8DIlzKfyaxyej3l0RYcFkTYRsfn+z7qluj0VmxxakjjG
         or97eBH4uGuAFbEbKv6AU+YLs2Mbt2wCMVbwozJ0J+11HIbaDqwnQ7JCH5ZNqztSbnnS
         lO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmOHqsChp2kVGC4NmmlLg2wVuuPYUcY2cFvEjqxXRkQ=;
        b=piS/cQeItX6F8C7eqsXYf1IaAwlqh+8Mf3GpRDx42LAdeJJDa+WHfvY8nlFYKQ60iP
         dkhDUeZEZgncc4fDFasUGLu7JhIfLkYFzv8xao3KGz+6lvjvmx8WAuUzYtBaG91FJ0+k
         LmrQPO2ZuomlsKtsXWPRDPsdgTjKLv6UF1UXlk06m/UbDtZicLggBihsfUUkvMnGGCXw
         M9y3+eNz+uz6fRVGPH4pFxaGUUE/a8F1Pk/gF7d5o9yqIDQuGo2mAQrTk1y+nJiiYu8e
         PVuB1iyRIejJyqzZW4HlavAMy0v/hBpfYrMU3NogzdCvuEYnjHa1gnHdNn9KH8+7R85+
         XYlQ==
X-Gm-Message-State: AOAM531pLlUIwWQblrWwtX1N6sYgWwAjt1sVPg8smi9Rs6rJzu+3nhkH
        +NDyoZaDo/VLNa75xgLVpdh/3DgQc5M=
X-Google-Smtp-Source: ABdhPJw5S0pFwTSwn3edKT8NPeFLdXVE2I/YU8rD/zJHRk2xq7XoWX0PTV5yej3dAVHpbR7120Pd7A==
X-Received: by 2002:a17:902:6848:b0:13a:46e1:2195 with SMTP id f8-20020a170902684800b0013a46e12195mr24601681pln.80.1632174868763;
        Mon, 20 Sep 2021 14:54:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:28 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 3/5] net: phy: broadcom: Utilize appropriate suspend for BCM54810/11
Date:   Mon, 20 Sep 2021 14:54:16 -0700
Message-Id: <20210920215418.3247054-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we enable APD and DLL/RXC/TXC disable we need to use
bcm54xx_suspend() in order not to do a read/modify/write of the BMCR
register which is incompatible with the desired settings.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 952341e0baec..bb5104ae4610 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -903,7 +903,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
-	.suspend	= genphy_suspend,
+	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
@@ -919,7 +919,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.config_intr    = bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
-	.suspend	= genphy_suspend,
+	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
 	.link_change_notify	= bcm54xx_link_change_notify,
 }, {
-- 
2.25.1

