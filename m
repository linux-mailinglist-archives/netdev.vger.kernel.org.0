Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3941E427332
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbhJHVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJHVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 17:50:20 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7887C061570;
        Fri,  8 Oct 2021 14:48:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id p1so9247450pfh.8;
        Fri, 08 Oct 2021 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FTfSae2Ub/GRhG0hDDbJoYdWWu5F/iD25Fu+zHz1GTA=;
        b=Tho5yDa3ZRTBaBfmf3Th7zv+AUlPqAgtGaJw3LDmI9HkVPAsYdO4CPviPeaL+u62rm
         nDmXNUz+IZhnkM2UMiULXlffeNmguj1ciUuOe/iFBJZ9NT1zJcA8VW8wTKI25GfU7UQf
         HwkYe6d/93+s2M+VPZHFSK3dNMgCp+zYkF0GE0lXCmYybELtmByBQv3BS11EITkUhtqz
         o17jISBIBCpqJpdYAyEwsiO0B/LN57RPaVHHFQazMlXwh/sBt1L8A422NspuYssRWlME
         2FwGTiVJ4Yt5mvBMjQBK7JEsXfDHLJzrN9P3RAp8rE8L+uYFtI+cAMXkb4uqei/Wqrma
         d9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FTfSae2Ub/GRhG0hDDbJoYdWWu5F/iD25Fu+zHz1GTA=;
        b=13i83pBy7q+PKxhR9IxgsfoLsNbunY/ZFntTaAVitX1DEFInmbBJ4MyOjUJuTrjoN/
         DWNcKBomdK5QZHsaj8YOTBfp5cF5J5SCVKQdh8jmBNPWn328BCSbj8iD6aHT8tupwsRj
         Wwy6WlA6FlJMVT2LQgklYP8tfXI0z8S4fsO5L2FLUPmpotuPT1bTP5AKt3SIs3MskivG
         lf425gXL90F7Ofq7eK9jEowRJ9IEEv9pV/q3u44ZzzE2UDdPKAzDY8/UmYzwclWcoNHO
         nSO3AwdxEwa0fEouu+WoRUzE8OQhx71RLRh4V/w5WrC3H+Hd/6M0vhv8zc6TP9x3j5v5
         1qgQ==
X-Gm-Message-State: AOAM531fX4g30s9nocLbtmlAnWg+z4dyQ9F2LVsSvIL0ODyimLCnAXIa
        xADTNXO7g9DSoWga5ZCe0ajU6/e+AK0=
X-Google-Smtp-Source: ABdhPJzBiG612UtRe48w7tz5q9NvYDbT2fM+V6xij3Uoiy9XR98SWQCLuMXWDHId5PcLEX8tKyE/gw==
X-Received: by 2002:a63:2261:: with SMTP id t33mr6699895pgm.274.1633729703893;
        Fri, 08 Oct 2021 14:48:23 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z124sm259923pfb.108.2021.10.08.14.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:48:22 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: Do not shutdown PHYs in READY state
Date:   Fri,  8 Oct 2021 14:42:52 -0700
Message-Id: <20211008214252.3644175-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case a PHY device was probed thus in the PHY_READY state, but not
configured and with no network device attached yet, we should not be
trying to shut it down because it has been brought back into reset by
phy_device_reset() towards the end of phy_probe() and anyway we have not
configured the PHY yet.

Fixes: e2f016cf7751 ("net: phy: add a shutdown procedure")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ba5ad86ec826..4f9990b47a37 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3125,6 +3125,9 @@ static void phy_shutdown(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	if (phydev->state == PHY_READY || !phydev->attached_dev)
+		return;
+
 	phy_disable_interrupts(phydev);
 }
 
-- 
2.25.1

