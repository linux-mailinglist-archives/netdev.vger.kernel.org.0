Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81B63A66BE
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhFNMkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhFNMkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:40:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08693C061766
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:38:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r7so31864656edv.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C7yUyUUuYRfzS7MJnVml7BYaeIIuGU7FGAU580X186I=;
        b=qEHb0OD86AoSy1+MiBajkerL9RomUVRHNlz3DgqVTX+lY8qdpUDeg93XaulS5yMJ2y
         /i71u0/HqwzptmMMqWhUu/4IWxxjv1lUMAmEbVWF4dIJr0S8p1tvCV7V+2DQ/RRGF2e/
         ls9Iwh+ojtuVg7GZ+6SJGTmS6e3KcSMRYwwF9XQtYJEi3si+u7rTYzug/o8vl4ItfXwD
         N1FQJyUu+vQmiWUUNdBBXbS6eetBsjlNZy58Au1jQigNS2B555byLeVLAf/hsuwxWxl5
         2rvJanOhIKxbGRcXRu9QC8Ql7iybDu6+BpawU1TJiY1h/nS98ZJ6I2dnk6MZh5LfbZeE
         sLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C7yUyUUuYRfzS7MJnVml7BYaeIIuGU7FGAU580X186I=;
        b=fkBk8Mz9eJNuIqWYM9CF6c7s5tUD3VTukDIVA86VcXtjZHojQRSewBkYWV+kZifl9+
         +sKQHNRsFNukfHPv6G/WDM3z4vmfTUtGgrz0sGYKZIe2VxVM0OoJTg/56mQsoJ9cXM0t
         pnsHbzk6DZZABp9MF41fcTtg+/5zaeQRPr2xUPujNn1Ce5RfCfkBB0cY1DGqWodKplm2
         8+5/HPHZzrQlIwkvNMa0EzCY01Ki9D7K1WdxbgMOt0di8atx0cVb90p3RNrRDIPwVMGG
         EnzMNZNn+2opy/28f8Dsd8acdJIXyp9hXRz07Zk+M+DDIZO3vY+TE54NRxEgtHMuEk8O
         HgeQ==
X-Gm-Message-State: AOAM530o/Xwk2XdUOvErQBua7E1l9xNoRgknWY3C5VPpRvs7GgUPLqV4
        GpH687Azny57wUKxGgUe3Uw=
X-Google-Smtp-Source: ABdhPJwZsEoN7DlX/+Barjirca0qTQ4npcUxRtUC7d8HGoKXIWIaAGMGaBHHK4ogRI7Dkev3Ju6x7w==
X-Received: by 2002:a50:fe8d:: with SMTP id d13mr657945edt.14.1623674312658;
        Mon, 14 Jun 2021 05:38:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id f6sm7157965eja.108.2021.06.14.05.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:38:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 3/3] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
Date:   Mon, 14 Jun 2021 15:38:15 +0300
Message-Id: <20210614123815.443467-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614123815.443467-1-olteanv@gmail.com>
References: <20210614123815.443467-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
silicon, there is a bug in that the registers for selecting the 100base-T1
autoneg master/slave roles are not writable.

To enable write access to the master/slave registers, these additional
PHY writes are necessary during initialization.

The issue has been corrected in later SJA1110 silicon versions and is
not present in the standalone PHY variants, but applying the workaround
unconditionally in the driver should not do any harm.

Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: added a comment

 drivers/net/phy/nxp-c45-tja11xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 118b393b1cbb..f8b2ecd0d6bf 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1035,6 +1035,12 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	/* Bug workaround for SJA1110 rev B: enable write access
+	 * to MDIO_MMD_PMAPMD
+	 */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 
-- 
2.25.1

