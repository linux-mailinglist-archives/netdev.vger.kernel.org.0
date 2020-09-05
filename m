Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF0A25E841
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgIEOE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgIEODm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:03:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2E0C061247
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 07:03:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so10228971wrt.3
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 07:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4LvnQQGv5OQrrtObdiwWlScTo7CXcMwrqPH8HgUosjI=;
        b=Q2vN4rumUQCCtxnGe7hhoAePnghvyFs5HwAx6T0M5tkkXDBZ5XDvMuTPX8vmlwlzCE
         n2+dc3gD8LkgsKqOUN/LhGVOZAtWQyPg1KIHIxKhj3fFAPFHP+oY0IdzFctXNWnUf4oK
         AbVEmzGBjXnfu86uhtv0inTAlHR26lVdKCOCQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4LvnQQGv5OQrrtObdiwWlScTo7CXcMwrqPH8HgUosjI=;
        b=bQZjaF0KnBLqK1blytDknoFg+HYP4P92Ej3U8rikD4N6Lj/bsOJZVC/EVgBdkwrguj
         w8Onq8/swo/qfoO7lOA7jzix0WxYzYK86f77QbfxMMoWe8S5ybiKX+BEjrIBaaCkeHD4
         K9vmsqQRnMA7vA8oG/srG87MlrzuIgG1dRX/9m6TORmllR5N2pLHJMIgZp82zrjNXdV8
         Q8d5+x9yO9tjI2fVKkmnjx2stfbgqiIKA9DCUzux++MxKZ8UyMd5RUhjBxPqliaEaE+T
         2+BccwB87EErLiC+FwUdJcsoDcd6Ut85QtyIkePHCg3y/bVD6bDCYBuazr5D2zjXAYA+
         9N5w==
X-Gm-Message-State: AOAM531mBnaSZ8QO81jyRPadOByUSvIuvuR5RwbeThl2yADqin7TQvgi
        Z9LI+wyNjLPN5H1CsyqxQcw+nA==
X-Google-Smtp-Source: ABdhPJwD+BRp0vkVI0hryaQWiJSI5Axu9MwOmoiBB3S5fMvAJzoKupzd4tZAI4J4PWk+4pV5y/Be6g==
X-Received: by 2002:a5d:56c1:: with SMTP id m1mr12052599wrw.87.1599314619465;
        Sat, 05 Sep 2020 07:03:39 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id b2sm17390369wmh.47.2020.09.05.07.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 07:03:39 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 3/4] net: dsa: microchip: Disable RGMII in-band status on KSZ9893
Date:   Sat,  5 Sep 2020 15:03:24 +0100
Message-Id: <20200905140325.108846-4-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905140325.108846-1-pbarker@konsulko.com>
References: <20200905140325.108846-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't assume that the link partner supports the in-band status
reporting which is enabled by default on the KSZ9893 when using RGMII
for the upstream port.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 3e36aa628c9f..2c953ab6ce16 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1240,6 +1240,9 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				data8 |= PORT_RGMII_ID_EG_ENABLE;
+			/* On KSZ9893, disable RGMII in-band status support */
+			if (dev->features & IS_9893)
+				data8 &= ~PORT_MII_MAC_MODE;
 			p->phydev.speed = SPEED_1000;
 			break;
 		}
-- 
2.28.0

