Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CECB13EDCB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393573AbgAPSFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:05:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34271 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405686AbgAPSFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:05:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id w5so7699836wmi.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JAW/siyrdDp3e7Z8Mz8Me9I8vid3/NP/GpT1sgaivtI=;
        b=kfSJXn2WE7prFzv1IsZiWDkmzVbY4NMbvnNbyrGd8uCbaDjSOE9rThJWWOW1D5vzpT
         y87UFQSp5nW71EiU5gUtluN0KCa6uabv1wT1BFpM43Bs3FkfxSlwt6dZVjMN3HPQKDbd
         rhHcYgRsPHPBpueXXy9TMu8ILMLl+p+lrBPJ75cmLGEEJd4R5+IKa5YMJkCOGPxLluFm
         cfPsdTZLd9tkJba/XFfCNpOiSjGydSENpuDVV7JvluZx10qAZwMig/J6y/admw9sp8Pt
         J2nR4Amh2M0wb/WtkyI/upkXlRpl+J3IXk0Fl21Sp/0L/YSKGNkHToMYJzcXjiXUs71O
         a2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JAW/siyrdDp3e7Z8Mz8Me9I8vid3/NP/GpT1sgaivtI=;
        b=qtFZXLRRfDXuacOqpbf+nEQrOVGyfC2JkaX8o2vpxnajGsKhBKai6WWM4DXSJzcpeC
         YTv/bxvASWv4B47YiRdJRcKfyi+bLaisM8ZLksUkh8RgxU7NDYwQcAd52FAmU+eXe4tn
         8EC1lQ8U0d2tLXFWcV6TLIidUKWyabvhLj+kkRvO49V8aLD2V69j7MlWSmZGdXdwvp2r
         wEP2M7+jA/QUGnGLYdIYJDb5zJ9IZrHxdMY64hOYydtCfCiHSHbSCTUz91U0T76fIUm9
         zcPU8YOLHA4W6zAMCyUx/qZt+zjpwgHx1gd44zMJGS8E7X/c6o7KRtyC5q+DQ4DQtDuF
         OYZQ==
X-Gm-Message-State: APjAAAWi7EWUKUke93paFX2Vf1jngYKsGD1EHzs5VjXZOPj88PHSwgzh
        ObMLsu1jWUVobjRMiSJED3o=
X-Google-Smtp-Source: APXvYqw2W+dun8emexgJ3jbUz/oNGhti9K0u1wtYbq1YPoewWIM2AqvGmcSTrdOxCespsH0hPvXApQ==
X-Received: by 2002:a05:600c:2c0b:: with SMTP id q11mr294132wmg.2.1579197917468;
        Thu, 16 Jan 2020 10:05:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id d8sm29549927wrx.71.2020.01.16.10.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:05:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: felix: Set USXGMII link based on BMSR, not LPA
Date:   Thu, 16 Jan 2020 20:05:06 +0200
Message-Id: <20200116180506.28337-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

At least some PHYs (AQR412) don't advertise copper-side link status
during system side AN.

So remove this duplicate assignment to pcs->link and rely on the
previous one for link state: the local indication from the MAC PCS.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 03482616faa7..1e82b0d72058 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -892,7 +892,6 @@ static void vsc9959_pcs_link_state_usxgmii(struct phy_device *pcs,
 		break;
 	}
 
-	pcs->link = USXGMII_LPA_LNKS(lpa);
 	if (USXGMII_LPA_DUPLEX(lpa))
 		pcs->duplex = DUPLEX_FULL;
 	else
-- 
2.17.1

