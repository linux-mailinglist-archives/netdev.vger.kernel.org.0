Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECB725F76F
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgIGKMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgIGKMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:12:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514C5C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:12:20 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e17so13824740wme.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h/iWzwJprojFLaXHNN6SpV7edO4SBlrOTMGBiAVdF8w=;
        b=R61uNwnN0I2T9xAtGFBQzNkb/eLWRlcqryGCf0jQ39h2Gc8uJxYA/rpxu1b5qSttrT
         k2wJvXcjJgMlt8iZarVdbYGZs8tKClS2122SwKL3cCg4LritGpBcd/yw/7HRgTy7N83h
         OtTW4FuZKR0IWBLYInIb/aoOCthQTw28kQIHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h/iWzwJprojFLaXHNN6SpV7edO4SBlrOTMGBiAVdF8w=;
        b=f1ovxYPP5TDYfWEIfyL+JbJqxl6dY72igWVXYXD8xJjOrQNlhtOVCJkNvqTU6Sb2YV
         4HOKWMGthSREdZBn7ZFj+jnZQsOoZg3RfuXeQTJsTY1KDcuF+2qfWx/Jog6d/MMbwZFC
         VF0yiaQeSvxDWPFw34UHHTrOnnR2qJxo5nkNNAoj6/KDSZWFaxt5ZxJttyQoUUYg2qYu
         7J+4U3ggorE0fTh1CFCJ0mB+fM+fd/nlVR5nGMZkUQ7JldkmuapXdeDPxV2DuwFK4OO+
         bv95s3DpIvYCobh6JmKwJyS/+eY7hb4fumm/PSx5duj40Xq+nlKGfisB2mJf4YGHg5Xb
         vcpQ==
X-Gm-Message-State: AOAM533qA86tEqlTMx1JUDQgu/p/IARop5X0AC43zMEY5fbKwu2iHKqS
        X6Um7qViuDvDM6V8NCZcejDXQg==
X-Google-Smtp-Source: ABdhPJyGhLWilbOzrpRHp5cBB7FuChMM0Jy2R1lW5FX+XXyj2p2VtYgD34w8J75H1RZ60DKBLjlCVg==
X-Received: by 2002:a7b:c848:: with SMTP id c8mr18825723wml.184.1599473538971;
        Mon, 07 Sep 2020 03:12:18 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id i16sm24173748wrq.73.2020.09.07.03.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:12:18 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v2 2/4] net: dsa: microchip: Improve phy mode message
Date:   Mon,  7 Sep 2020 11:12:06 +0100
Message-Id: <20200907101208.1223-3-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101208.1223-1-pbarker@konsulko.com>
References: <20200907101208.1223-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Always print the selected phy mode for the CPU port when using the
ksz9477 driver. If the phy mode was changed, also print the previous
mode to aid in debugging.

To make the message more clear, prefix it with the port number which it
applies to and improve the language a little.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index df5ecd0261fa..9513af057793 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1265,6 +1265,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	for (i = 0; i < dev->port_cnt; i++) {
 		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
 			phy_interface_t interface;
+			char *prev_msg, *prev_mode;
 
 			dev->cpu_port = i;
 			dev->host_mask = (1 << dev->cpu_port);
@@ -1277,11 +1278,19 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 			interface = ksz9477_get_interface(dev, i);
 			if (!dev->interface)
 				dev->interface = interface;
-			if (interface && interface != dev->interface)
-				dev_info(dev->dev,
-					 "use %s instead of %s\n",
-					  phy_modes(dev->interface),
-					  phy_modes(interface));
+			if (interface && interface != dev->interface) {
+				prev_msg = " instead of ";
+				prev_mode = phy_modes(interface);
+			} else {
+				prev_msg = "";
+				prev_mode = "";
+			}
+			dev_info(dev->dev,
+				 "Port%d: using phy mode %s%s%s\n",
+				 i,
+				 phy_modes(dev->interface),
+				 prev_msg,
+				 prev_mode);
 
 			/* enable cpu port */
 			ksz9477_port_setup(dev, i, true);
-- 
2.28.0

