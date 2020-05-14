Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA51D2FF2
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgENMi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgENMi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 08:38:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A72C061A0C;
        Thu, 14 May 2020 05:38:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w64so151805wmg.4;
        Thu, 14 May 2020 05:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmmeNEZrjOkx1Cy+isBz9LxMlDnG3aHp30agruimX6g=;
        b=Not+DOqiJAhwlYKuU8oWOQK9NW/ToXWF4bQYVipYB5pS9fdcUArbqrJJKIUi03KHOw
         O/2iU2gJfR7svc+L6yQj/e7WSO2lH6sT6HxlCL55VQGyNsPPeQ7az35X6sjDrxfxM+hX
         r+7lPVKbMtWmcU+hkab5bQyUgYiiolSXo0ZYpIhTo8lEPMde3y9YRvU57pJMcTYYd3hl
         zmoHNrLUAlHl9HHs3OIstskWDJOBHj2jko811Hdc2nUEgLKIQWXcy568tHF83tP+esXy
         Cw0LVZwKqb++tWGyhCKIL1Z/dm8bgxpJfnQXYY5XakTSVRutCO39bD64wizmBnU46/S5
         I9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MmmeNEZrjOkx1Cy+isBz9LxMlDnG3aHp30agruimX6g=;
        b=dPg2hYo5b3e2fRVOvyYeiexbsaSL4P93sqLOeGbbBC/cxr2aOFmjyhSDletz0Z8L/+
         C4gGT9T2yxcwmHPZmdaDgtvuYAYlKsFOqk91WPhHhCRCweXvqALpAIuwGxtN6b+xdtTl
         2F+qkp4bzP9BzdqaO99SChL9F9udBvZhS6O4YV26EDTFHf/92jm2x15iGX4gjhE/5Bwm
         eYIip1qvJwU8UXnpUzwr8W5TfKHVf/cmfAf+8T5Jf5x9AAnIp3YPll7lyBUfPbANM/Yy
         584MxjEyKYE5fDY+6iYNArdMXPLb0kRKsYm6/u5Xn2HwwZe36VqcGGgQlA9HpMVBC7PJ
         vxQA==
X-Gm-Message-State: AGi0PuZY2EZ/6Ic3ucgOkMmC3+QelmCFArQaE3II/M+ZJD3ZvWrNflk0
        lr+Z3ZgUMkeNAn107alHLqkDBWy/
X-Google-Smtp-Source: APiQypIVDLtiquGPj4wJVqRcDwOwEPpLZpE1TaanWgY1lWPgqx7aIFcF2EZYU32+G/5D65PV3yc+Hw==
X-Received: by 2002:a1c:6506:: with SMTP id z6mr19493129wmb.104.1589459937744;
        Thu, 14 May 2020 05:38:57 -0700 (PDT)
Received: from localhost (pD9E51079.dip0.t-ipconnect.de. [217.229.16.121])
        by smtp.gmail.com with ESMTPSA id y4sm3673729wro.91.2020.05.14.05.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 05:38:56 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH net/next] r8152: Use MAC address from device tree if available
Date:   Thu, 14 May 2020 14:38:48 +0200
Message-Id: <20200514123848.933199-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

If a MAC address was passed via the device tree node for the r8152
device, use it and fall back to reading from EEPROM otherwise. This is
useful for devices where the r8152 EEPROM was not programmed with a
valid MAC address, or if users want to explicitly set a MAC address in
the bootloader and pass that to the kernel.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/usb/r8152.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8f8d9883d363..1af72ec284ca 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1504,15 +1504,19 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 
 	sa->sa_family = dev->type;
 
-	if (tp->version == RTL_VER_01) {
-		ret = pla_ocp_read(tp, PLA_IDR, 8, sa->sa_data);
-	} else {
-		/* if device doesn't support MAC pass through this will
-		 * be expected to be non-zero
-		 */
-		ret = vendor_mac_passthru_addr_read(tp, sa);
-		if (ret < 0)
-			ret = pla_ocp_read(tp, PLA_BACKUP, 8, sa->sa_data);
+	ret = eth_platform_get_mac_address(&dev->dev, sa->sa_data);
+	if (ret < 0) {
+		if (tp->version == RTL_VER_01) {
+			ret = pla_ocp_read(tp, PLA_IDR, 8, sa->sa_data);
+		} else {
+			/* if device doesn't support MAC pass through this will
+			 * be expected to be non-zero
+			 */
+			ret = vendor_mac_passthru_addr_read(tp, sa);
+			if (ret < 0)
+				ret = pla_ocp_read(tp, PLA_BACKUP, 8,
+						   sa->sa_data);
+		}
 	}
 
 	if (ret < 0) {
-- 
2.24.1

