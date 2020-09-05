Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35E725E840
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgIEOEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgIEODk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:03:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45911C061246
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 07:03:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so9268711wmj.2
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 07:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4w7lhVa/MMPsgT7b8Dk5gygQuJ2oI28kmOPvPbKnNtQ=;
        b=rKKa95lTC/NwFSilHI5K806RdAZ1nCITObAY5H6oTNuWplGZx/UZZNik1ItluQBR7j
         VzdTOHhAgFMqbxSFP1g7tcoT+qdVMxaIsumTx4SKgSEzjx8obeRE55Og5ewC992PiqV/
         +9e2uzmoo4NIzCU6gAbmhl9TT4h9LAcXMhpJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4w7lhVa/MMPsgT7b8Dk5gygQuJ2oI28kmOPvPbKnNtQ=;
        b=KoZon0rfSsfgr9Et1PjgJldPrhPoAU1oB8nRqVcrk5VkOT6URyNAprkr5o/bHR5Tiu
         MOwWgmN5jSKRY6RcyvHXxZeYWWpxMyPfmE5R3SVthgaNtZ5TYk0Lb43PKUSGfxPyG8As
         jRl/q4/23e1EpRyM5QKNpvy84C04xhLDl8HX6z7G/8EQerqeE22EjSQ0Lx+GEsNRqH9M
         xrDeA6wdmvneq5NpW9H8aOMjvakzGJuNHlvCupOWTYwIkV+IHUSSdyQNzsYBRyACYr7q
         hou0eP2/ThMj0u8M+gMVVUZQEX2kR/6MyL5YHZzBkE/wD91t9seL8HfxpuDai+W6QH+C
         sphw==
X-Gm-Message-State: AOAM531u0lS/019g3Kc5+bfOeY/TpAqljtQzaB16bbeE6AD+g+pVIvvA
        JE1OKRcrDOBC48b/A3UNDfXtzQ==
X-Google-Smtp-Source: ABdhPJw+AGxdclglSjnRVVYZt9ow7mnE7/5Pnzcz+8M9/W6ga0toIESbMCUri8//unEWRXNS0LVGrw==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr11692019wma.45.1599314618546;
        Sat, 05 Sep 2020 07:03:38 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id b2sm17390369wmh.47.2020.09.05.07.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 07:03:38 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 2/4] net: dsa: microchip: Add debug print for XMII port mode
Date:   Sat,  5 Sep 2020 15:03:23 +0100
Message-Id: <20200905140325.108846-3-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905140325.108846-1-pbarker@konsulko.com>
References: <20200905140325.108846-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When debug is enabled for this driver, this allows users to confirm that
the correct port mode is in use.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a48f5edab561..3e36aa628c9f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1211,21 +1211,25 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
 		switch (dev->interface) {
 		case PHY_INTERFACE_MODE_MII:
+			dev_dbg(dev->dev, "Port%d: MII mode\n", port);
 			ksz9477_set_xmii(dev, 0, &data8);
 			ksz9477_set_gbit(dev, false, &data8);
 			p->phydev.speed = SPEED_100;
 			break;
 		case PHY_INTERFACE_MODE_RMII:
+			dev_dbg(dev->dev, "Port%d: RMII mode\n", port);
 			ksz9477_set_xmii(dev, 1, &data8);
 			ksz9477_set_gbit(dev, false, &data8);
 			p->phydev.speed = SPEED_100;
 			break;
 		case PHY_INTERFACE_MODE_GMII:
+			dev_dbg(dev->dev, "Port%d: GMII mode\n", port);
 			ksz9477_set_xmii(dev, 2, &data8);
 			ksz9477_set_gbit(dev, true, &data8);
 			p->phydev.speed = SPEED_1000;
 			break;
 		default:
+			dev_dbg(dev->dev, "Port%d: RGMII mode\n", port);
 			ksz9477_set_xmii(dev, 3, &data8);
 			ksz9477_set_gbit(dev, true, &data8);
 			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
-- 
2.28.0

