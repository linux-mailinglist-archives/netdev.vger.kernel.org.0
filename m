Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63226CCA3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgIPUrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgIPUrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:47:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2455C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:14 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so28536pgl.6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VhlNwxQKC8iXLlrLgB5H8XXWA7fwh8RmrAQKN8lDyK8=;
        b=KhEz3XENtONt6hSqxgH2Yz5CbMAFbE2DOs1a/DnUeQC+2psAC7C+GEMeZcwWki1LaR
         tzvqaQUnhgoZFh+xJo4q6O/pIHq+0edjZRw4pXNO1fQrvf9/AInKJIyb7mRrlW9KRsys
         Y1sPlw5PFILjDWfVQ2d4hUQ2Dn0Z65w05Fqvwq9/g2f4myxzTPMXpzZAim4wImvic0Bt
         +9Dr+AsUw15o3aumrBJToP2l/rfbL/ryv/W1ygmjK+sgCFhC2/B7jRGXqbjRrFyFNK3h
         L7Aoe/Jm5NiNTVLA3u6Bpqb++xzbxRWNvXNhtouwFDtFB3riy8N9xt7k6OhmjSk8qGj3
         s7xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhlNwxQKC8iXLlrLgB5H8XXWA7fwh8RmrAQKN8lDyK8=;
        b=BQhpNDqi+WjnTOjEze0OpTlMqVoJ1ZSSks/M9dFhFm7czgUG0RkyC1SCJrgiLjhjed
         jgF2K7rwOQ5Ily0XW5GPr0N6TXyz282yeGeAR/66Qa19wgaQjMWEzgk1qLaUGSdu2zoI
         rAlYoYtTz1y/cN1h9ffl6Ajk4IVeVohAWMnNkxOksleb/Kc68EeeZ0VdtChLP4eQf9+b
         miU2GIgOCggu3+BWsG9zgKu0Slaah5UUbnbht+pFN/XEZcRi8GVRsZ4Ui3/2YRkhKdmw
         XxqxYY3Qqzvqga4mZ6N+IgkHGHj4PfS8VoSVDSY6Kwdj+0zJnbM4Y0ZGj47gzWnv4E2b
         05zQ==
X-Gm-Message-State: AOAM532EAFUjqTbijBYBMU0GQJwb68sLtrXB05rER+3BNMtr64bfOU5/
        CssqQzjFdzcpONuZQ7t1nqrZcik38/ZJ0w==
X-Google-Smtp-Source: ABdhPJyTIdtCBHoJ5a/UoYJMkm6XsGPgxIf1ImELdBlHl3io+hbzbqFQxf/tizY7Q3cl/r4IE2Y+xg==
X-Received: by 2002:a05:6a00:1695:b029:142:2501:34e4 with SMTP id k21-20020a056a001695b0290142250134e4mr7758876pfc.61.1600289233825;
        Wed, 16 Sep 2020 13:47:13 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p11sm17684138pfq.130.2020.09.16.13.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 13:47:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net-next 1/2] net: mdio: mdio-bcm-unimac: Turn on PHY clock before dummy read
Date:   Wed, 16 Sep 2020 13:44:14 -0700
Message-Id: <20200916204415.1831417-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200916204415.1831417-1-f.fainelli@gmail.com>
References: <20200916204415.1831417-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom internal Gigabit PHYs not only require a dummy read to
clear an incorrect state in their MDIO logic, but they also need their
digital PHY clock to be turned on otherwise they will not respond to any
MDIO transaction.

Turning on that clock must happen shortly before we do the dummy read
otherwise we will never manage to get the correct PHY driver to probe.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index fbd36891ee64..43d389c1648e 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -160,6 +160,7 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 {
 	struct device_node *np = bus->dev.of_node;
 	struct device_node *child;
+	struct clk *clk;
 	u32 read_mask = 0;
 	int addr;
 
@@ -172,6 +173,16 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 				continue;
 
 			read_mask |= 1 << addr;
+
+			/* Some of the internal PHYs on this bus require their
+			 * digital clock to be turned on and this must be done
+			 * before the dummy BMSR read done right below. Do this
+			 * now such that we can successfully identify these
+			 * devices during get_phy_id().
+			 */
+			clk = of_clk_get(child, 0);
+			if (!IS_ERR(clk))
+				clk_prepare_enable(clk);
 		}
 	}
 
-- 
2.25.1

