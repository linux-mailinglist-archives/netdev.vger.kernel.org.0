Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E3413F2A4
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393001AbgAPSgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:36:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42954 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391727AbgAPSgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:36:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so20133503wro.9
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aSq3uPwKVluLx4xB6whM+oWvxxWccfkoE67uN3vgI00=;
        b=kHcA0TeT0MioNRfhOsZTuEYKFHpdlctuwQac8Ke7I48sTfbVag0bjBmRojEoyBK+qd
         Z7Ke1auPJ+qmquNhi0dneh/frvhspbyJBsG7Rax72FI3+tXG1dEod9M6+mGHGO+EAhnT
         rsVJ/f+XndUE6UFpkiCabL4CHj2Toqo4ykXwPQENcrLXBQ5G5ISOm8CF5t1IhfyOxnNQ
         /LTw69zvto15KsC+HDUxeYYxX7P/lnA5f4GhecJPtyCYhVeZKZ7x/L1q/2ZNNpAANNjt
         m8F3uNDvfQ3OCPL7VEPBhq2NCMWCkridPD84reh1/VrIP1DdgW43W+98kuwqWTKs8H+w
         9BXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aSq3uPwKVluLx4xB6whM+oWvxxWccfkoE67uN3vgI00=;
        b=PPT0+yUszuQBiJpHF+ampRT40R28qsQGStwKQ7WxMSfjRGm/IA6AJTsn7LSChdHbmc
         bi7Y0/ICfjU47yxn2LWb3GzlhtzjjXwIC/abpEb5qGC2CaGe1eZV5ZA1atkM13EAHlgt
         XOFaxEiTC8PHfJaPWVTOfWrObGHo/aqW1++P8ASlXMFB6/NOfPzCLlS+lN5MMOsTXJsp
         ViYRX67HGtborql/Zo9KzOkr0gTwaouKt9C/Z9dk8dQ0kpUPBoipo5XMjyPj4CHm4Q47
         dt4gGueN2625U3fxN40PF6v+K3PHkMtov4UrkRd+voJeGyiAqngrWxzoA7ch9BJGAA8L
         cx/g==
X-Gm-Message-State: APjAAAX7mDLYhFxE8I0ttrLmQzmK6KkSE0icr09K7M2qKdE8JNYyNKS6
        FOmYm2ofOPdkuf8YqQX4CMc=
X-Google-Smtp-Source: APXvYqwSZq6ATKmQfNoQcww7Pa8rm6oejQcC0YOG+XsPuCMtg0StA5EqtcNtrIjqEPQq2O+2cRNsFA==
X-Received: by 2002:adf:b605:: with SMTP id f5mr4587991wre.383.1579199801826;
        Thu, 16 Jan 2020 10:36:41 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id p15sm3700701wma.40.2020.01.16.10.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:36:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: sja1105: Don't error out on disabled ports with no phy-mode
Date:   Thu, 16 Jan 2020 20:36:35 +0200
Message-Id: <20200116183635.4759-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105_parse_ports_node function was tested only on device trees
where all ports were enabled. Fix this check so that the driver
continues to probe only with the ports where status is not "disabled",
as expected.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 784e6b8166a0..b27ef01b9445 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -580,6 +580,9 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 		u32 index;
 		int err;
 
+		if (!of_device_is_available(child))
+			continue;
+
 		/* Get switch port number from DT */
 		if (of_property_read_u32(child, "reg", &index) < 0) {
 			dev_err(dev, "Port number not defined in device tree "
-- 
2.17.1

