Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D695412AC6
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbhIUB6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbhIUBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C13AC06AB03;
        Mon, 20 Sep 2021 14:54:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso513155pjj.0;
        Mon, 20 Sep 2021 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K7GTsxet9/y2vshzKDYfPB4KzqayYDkaHK/3vwe3MJg=;
        b=ZQ8N23b1TbKpylH/ORAaHHsH3GBDRZ7YCHCZ+nvIVpN0NURF6can38jzt3+YcL8Tsf
         e7I5kxj94hfbxD8atFArtodVxbkQV3sLBcNQ2Zzolfsn4qdZ2Q+2TF1Tmwsatp3IATSp
         YVMYygMspwdhj/5McsCg3+TW+lF52PVXQDkahxKRvYb98I0cJPkqBXBho+lFLI8qmKfg
         C9Juwsl4ixDNG7Y+GPYShpPS+CJuyvCJBF9KgebBKp9DDhi0fcXxIMPBJpGmx0jXm7kV
         89tKFqyJWOwcbk/An29PU+g9X/XwgEihuNXwJKyiEEizj/aSgdjbVz5c/Pk81U5lSuz5
         UThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K7GTsxet9/y2vshzKDYfPB4KzqayYDkaHK/3vwe3MJg=;
        b=QXwgaLbwlOshajrDoEgbh88nZRXj/S/qRWMTNbyQHqeiGrmv4/iFmzM5sfTpmB4H1W
         4uR1v7l9VaR/VpED4GCvWHEnu1vhGOE1VSy7Se0nQpGRK1BYdAhiV/a1cnUZQoV6gGk8
         RENgr7k0jwRhVHN9W7WGHQgpBwtLNShKAziQ6dNVZrAGbrCpwJvXsL/fygIHzHh9rkZN
         ORO/CA8gFHQzjm0E/SU6I/Pq24PibCy7jVhDpf2awK0ZWZrk2ICaTBoaF+kueLCUkJje
         jPKJr9YKKYOlumdQjBfNyaHSqP33rjDR5oi+f/wWb8aaC16O2sHEuNRpYE3Mi6eAKCO5
         XYSQ==
X-Gm-Message-State: AOAM531X3HAQfwlJiN0cOcWmeMugsj7Nk9VBRt+DMGsdBPAjoLHNzEnL
        CxFKS67oUNlGkM7mwRpxxvo3dqCvExQ=
X-Google-Smtp-Source: ABdhPJzGSdaE/kNPz/O1NJ6foIOu58blTNTiqiVTDiu0O7rUo9K7ytWN+zQqU/GNs1NglHHlVz3HYg==
X-Received: by 2002:a17:902:e293:b0:13a:4f14:f24 with SMTP id o19-20020a170902e29300b0013a4f140f24mr24366267plc.4.1632174867400;
        Mon, 20 Sep 2021 14:54:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/5] net: phy: broadcom: Wire suspend/resume for BCM50610 and BCM50610M
Date:   Mon, 20 Sep 2021 14:54:15 -0700
Message-Id: <20210920215418.3247054-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two Ethernet PHYs support IDDQ-SR therefore wire-up the suspend
and resume callbacks to point to bcm54xx_suspend() and bcm54xx_resume().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index f5868a0dee4b..952341e0baec 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -948,6 +948,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.suspend	= bcm54xx_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM50610M,
 	.phy_id_mask	= 0xfffffff0,
@@ -961,6 +963,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 	.link_change_notify	= bcm54xx_link_change_notify,
+	.suspend	= bcm54xx_suspend,
+	.resume		= bcm54xx_resume,
 }, {
 	.phy_id		= PHY_ID_BCM57780,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.25.1

