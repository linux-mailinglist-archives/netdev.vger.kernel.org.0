Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F7013FAE5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbgAPUzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:55:55 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38385 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgAPUzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 15:55:55 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so10505697pgm.5;
        Thu, 16 Jan 2020 12:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+nCilBulwSLVUvM6NtqMw6YwyNgyJgT4OlEUrZgT6CA=;
        b=lN43DV7LK8i3+NXeGADsv99ZF9HKYnmu8DdaMzDTCxqDQKL8H5XyC61Pmeo8S3wcOB
         4F21xyz2Y2Uv42Yqu3sRJYkg4UG6HpUTm03p1dCnXlnD1vzErbSHtke3xVSv7WHQ7lnW
         q0GSV+nHW9SjCZD3dIDVYVAcEPraI+VLQUFyIMQ206UntfYBkeEnLa0clG+q/fZ+tUVl
         nNP4aEeOO1SzQb6+XKawv118M2982eAx+80u7MVC0AcJ5jDmiw/zlTEX0ZU0h09dz2Vp
         u4QX8vaue6fiC82oMjnaA/L4GWm6pkqtp8+3zx8y6VKdWOQ1rkviuweMAYze/vaR/Zy1
         oV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+nCilBulwSLVUvM6NtqMw6YwyNgyJgT4OlEUrZgT6CA=;
        b=LhZXV7pRazCIS4IH2/FygrxVoL9s9nvHMiHY9MZvfU7WlawvQFyWSLPk73i3+7/iPr
         fzy0LekDjB3MvmVz/HsMJne7PUkqJFaqmXmZ1fMZVTAV3Z4VootDRNNI/DR2qgmOPeWs
         HkQxutmVF4om+Lievyw7iKlCMxea/W3VByQ+GhID40iPRufUqnmTyVJ1/m4DwFpZh5d5
         ouQJwhObWCF/7fnoacEyZxIVQld8m3vjOt3kf9YzJMAj+Ls6xu2ob4O95b9Lfw2nRq8l
         mjO7xC6V1NCde8Q6xNaGRzIzMhC0GmPSRPCuzMVW+fKVxZV2fzXXB6DB568DHejJ4bCm
         llOA==
X-Gm-Message-State: APjAAAXZrIVqHgOSVHunleCQVd86pb1NT2WzralL8Fw+lNTT6F1w3Jd8
        t97gu4xc/17a4B6/fj7LvQrjeEj6
X-Google-Smtp-Source: APXvYqyn7OG+Hb4SYnOSjqMni2pSoLLcAsIJ9Gq6Mh7Ln+sZRMIybKzp/iSXWMqNbwt18xU4lVbDjQ==
X-Received: by 2002:a63:f643:: with SMTP id u3mr39520879pgj.291.1579208154468;
        Thu, 16 Jan 2020 12:55:54 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u3sm2622614pjv.32.2020.01.16.12.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 12:55:54 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec
Date:   Thu, 16 Jan 2020 12:55:48 -0800
Message-Id: <20200116205549.12353-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the implementation of the system reset controller we lost a setting
that is currently applied by the bootloader and which configures the IMP
port for 2Gb/sec, the default is 1Gb/sec. This is needed given the
number of ports and applications we expect to run so bring back that
setting.

Fixes: 01b0ac07589e ("net: dsa: bcm_sf2: Add support for optional reset controller line")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index e43040c9f9ee..3e8635311d0d 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -68,7 +68,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS);
+		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.17.1

