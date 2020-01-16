Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED5513F34E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436991AbgAPSmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:42:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39264 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390316AbgAPSmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:42:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so20228957wrt.6
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wuUDDLReOkfLliPq4Xn5TqN1Ctv/jMJvi/6CTFWGYYY=;
        b=tSeaS3MjvOKhokXD8Y3y6XMUM8HqwvYPey/CmRpWrbc613SHsVTVHD823ZFrPlz3DS
         6ijVwYs5uLUbj6S2op+9t8NrDCl4HcjEmkjJOVNoNPSivxnc8XNbl9E/NtrprITFdlSM
         EEm7ECzjykhUVwjggClEnMYOriuwo6bpe8qWe/tsjImYKLfvPLJqspMK8qbGLcebQWKd
         BeM6IRYejePJ3XcrESdSUjeRyNNw/MhgZmiINzAcmPFqFvjAFvk82Y9MiGUZlBBvVyzo
         3ogT2vJJ/hLoJ7HfeOi8EKhBI2YDSmUy6MwH8UaB9i2tgTE1c+OTBQKlJ356gMk565Jk
         lCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wuUDDLReOkfLliPq4Xn5TqN1Ctv/jMJvi/6CTFWGYYY=;
        b=XSA4evBErBAtgxz3xSMmWtJ1ibkajzsHDNZue9bwJCJ4NTVsXQ8khbP/YiDjWSo2kw
         Kx+wqTs4ckxgmKUkLn3B+aIr5KiVFQV11eYcALK9InpGu9IrRNs/FKwYaVZw5R2Rh9HH
         hJLvljaDZGaV0GyM62UFH5vGBS/Fl7CIgwvQeJ7osg6UI+SIS/MPkmpnFuZbgdC7UpKY
         q3XpREAamVAJrIGj8lNvMmRPlRG+0OraUj0FFBb2telesTklHnC/Z1m7v9bb8AL/t3Uv
         QtqxS7GIltmeiJ6ToDj4Leq7Yl2mZtj5L01eKyfJsB6RdWzcMZiTPndgd/xCMzIu1YwG
         eUbg==
X-Gm-Message-State: APjAAAXcUYtnO/zDbshegvsdHeXX6WhjzBlXgGM/bGxnu0XMkpwDANDi
        GAvb2CWBKQ6G/fzXGKMclgE=
X-Google-Smtp-Source: APXvYqwOJXuRFDoGM68c0r/8pkWX19I68q03bDsTfwjRkSMPIe8e0JXXjvwqwRRmbJpARuDx3nLbkQ==
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr4795752wrn.146.1579200120005;
        Thu, 16 Jan 2020 10:42:00 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id d14sm31930938wru.9.2020.01.16.10.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:41:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next] net: dsa: felix: Don't error out on disabled ports with no phy-mode
Date:   Thu, 16 Jan 2020 20:41:53 +0200
Message-Id: <20200116184153.12301-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The felix_parse_ports_node function was tested only on device trees
where all ports were enabled. Fix this check so that the driver
continues to probe only with the ports where status is not "disabled",
as expected.

Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Use for_each_available_child_of_node instead of open-coding the
  of_device_is_available check.

 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index feccb6201660..269cc6953d47 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -323,7 +323,7 @@ static int felix_parse_ports_node(struct felix *felix,
 	struct device *dev = felix->ocelot.dev;
 	struct device_node *child;
 
-	for_each_child_of_node(ports_node, child) {
+	for_each_available_child_of_node(ports_node, child) {
 		phy_interface_t phy_mode;
 		u32 port;
 		int err;
-- 
2.17.1

