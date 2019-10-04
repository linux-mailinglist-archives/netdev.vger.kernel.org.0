Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5B5CBC4F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388890AbfJDNxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:53:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35558 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388697AbfJDNxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:53:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so5968308wmi.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 06:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m4aCAKcUDYzXPZoLgEO2moCzxytqOzwd315TgVOq64Y=;
        b=e2vTUeNPJiy4xS7tyOb8nGrbYUf90DGOn9U3Ivc0PgpXf6q7Mx9t40k/CgVVfNblwZ
         Xuyta3hdfb1RKo2Ot+Oq/VlGAoaXOqggfmWE2N1xNf2xhujlg092eJNjqTgvjdHBXtV9
         8SnugH/Inb1aXThWK1ewl6JRS9xDlZkOWWM2qLXfXhr8+SucaWt/uC1eLekeU4fxJbll
         5vS8ogbOtYpF7wfA86Qqma2H8U4v2NcMa201ltLYpSb0VC+JG7HdQACQF6LrS5n058kY
         W8k2C7/9w15DVclRvcDOmFugtsqcofQMoVO3l1UEUujk+uQITf9aHaOqGSlb6MaGN01B
         uRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m4aCAKcUDYzXPZoLgEO2moCzxytqOzwd315TgVOq64Y=;
        b=XnTBbHVvTB7MbGsV+VxI5J2LQkldGGfmS89KiyVfnLAFA7L/DcXSo3V2oE4GfMENlc
         WHvzLDyrTx/yyMONc6mDnNTEWos7cZq25MdrMdSAUi2xA43Hy3Ym3FBWlsfXMPa3SENN
         aJMfhYcFCrwDrTCVBTjbr8fmb2P34uzw3a1pd0ZSwsS+HaXr87H59H0bsbb+kG66/JmK
         M9n0JlfBm9cTxv9ID4pOoQjPCUKvkw02aucfmL4p+2Tkq0hbQLtgIAbift+jxucwpjOw
         IQObT+jnaca3waA28i/Nq6FbqBoJRRArHYGAoqpkeEWTlXwiY7KRutKC5jKANJXSClSZ
         Q96Q==
X-Gm-Message-State: APjAAAU1GAfimwnQq7vw/80AiORYcpqEzadlvDCAlJ/CKv0M81TUm1MH
        q1GNfJKWws+REPiF2jup/+I=
X-Google-Smtp-Source: APXvYqzppODBTLEsalp+tlToizvHESrIlrTcjXkbhZePnYQt9UPzPoDY9vAcAzIeVZ5+nF6qd4j0/w==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr6199475wmj.126.1570197219315;
        Fri, 04 Oct 2019 06:53:39 -0700 (PDT)
Received: from NewMoon.iit.local ([90.147.180.254])
        by smtp.gmail.com with ESMTPSA id 94sm10819794wrk.92.2019.10.04.06.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 06:53:37 -0700 (PDT)
From:   Andrea Merello <andrea.merello@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH] net: phy: allow for reset line to be tied to a sleepy GPIO controller
Date:   Fri,  4 Oct 2019 15:53:32 +0200
Message-Id: <20191004135332.5746-1-andrea.merello@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio_device_reset() makes use of the atomic-pretending API flavor for
handling the PHY reset GPIO line.

I found no hint that mdio_device_reset() is called from atomic context
and indeed it uses usleep_range() since long time, so I would assume that
it is OK to sleep there.

This patch switch to gpiod_set_value_cansleep() in mdio_device_reset().
This is relevant if e.g. the PHY reset line is tied to a I2C GPIO
controller.

This has been tested on a ZynqMP board running an upstream 4.19 kernel and
then hand-ported on current kernel tree.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/phy/mdio_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index e282600bd83e..c1d345c3cab3 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -121,7 +121,7 @@ void mdio_device_reset(struct mdio_device *mdiodev, int value)
 		return;
 
 	if (mdiodev->reset_gpio)
-		gpiod_set_value(mdiodev->reset_gpio, value);
+		gpiod_set_value_cansleep(mdiodev->reset_gpio, value);
 
 	if (mdiodev->reset_ctrl) {
 		if (value)
-- 
2.17.1

