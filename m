Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DC6427DFA
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhJIWsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhJIWs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:48:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8E2C061570;
        Sat,  9 Oct 2021 15:46:31 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so50922060edv.12;
        Sat, 09 Oct 2021 15:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nMGz1jaxSRjc4ldn7/fMoncfQgr+j4K4wAw0fNIBVyA=;
        b=SSrZYV75Ria6kF2+8upArL/wuu6Dwv2AZqJ8DCgM3ry2XrXctsqC2jCZoOig5NZxm7
         PAFS7Y+A3qp+kG6MAZVeguXNIgEifqn6IO0Wk1pQ1aKhiMS+op90ZNQVMutnmVFgEq8/
         wQVlkaIgbEDMS/0Fmd4Dd098bX562+c7/6mSpvVX97PeGspIDcHhh+H9cyDYjRF5urmZ
         6kCxLAjj/Uq2zv0rDkD9RjweupUQzbe6+DnMU5Rd4eaBcAaFc1Aljl74IXIRW1mb7Ggc
         Tha+iUglsJWXeezCf9WjYCd9pxuNKkS9/SJhkD1rLo/WrpIfEWHYmMWs6dsU9yZoGkkl
         SeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMGz1jaxSRjc4ldn7/fMoncfQgr+j4K4wAw0fNIBVyA=;
        b=owbkvNTdhE5+ym08sF2Rtrfvt5EfKOWEg3k8tx+U6FjD8joQ/+sLS34skPfkmKczu+
         pDXD6hfqNm7UtoLPxtlm9PqEKU3reWIuG3tnjxI2NWYRs2VJ0h5Pr4hgJjcdbYwIEGOv
         jE2kVCQ7zbXh1k6bSUZvZUgMpp0jx+IFl2LiMGXMWxRJk1EBWQ/QgEY0CELh8aWvNQY8
         ZAFUAheLETcV1932753yNTwRnUjE8T/d9PXT5b9L0vQpuYVxBWkbps3rx+nrO1mrd+D/
         VsVayj+dTo24n3wdukHIr+OwFgdJlOTkgti2k5MsWY12m3Ya+gHwNF8+FD2R6QD1azlK
         JCcg==
X-Gm-Message-State: AOAM533xX+o6dcXiPhUxkZU3FaJ/mtlNb3YhLAEI9sOneZv73GEpTEEm
        21BTigXsDZOJnJQfMZjK6fM=
X-Google-Smtp-Source: ABdhPJz10ifvq6SYbzoKVBea8Txya+CZpaVKJP6QzppxyfIcesoQ+8D9TVuOYAfEsBLjO1rHGLaZqg==
X-Received: by 2002:a50:9993:: with SMTP id m19mr26856357edb.357.1633819590364;
        Sat, 09 Oct 2021 15:46:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id l13sm1727115eds.92.2021.10.09.15.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:46:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 3/4] net: phy: at803x: enable prefer master for 83xx internal phy
Date:   Sun, 10 Oct 2021 00:46:17 +0200
Message-Id: <20211009224618.4988-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211009224618.4988-1-ansuelsmth@gmail.com>
References: <20211009224618.4988-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From original QCA source code the port was set to prefer master as port
type in 1000BASE-T mode. Apply the same settings also here.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/at803x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5208ea8fdd69..402b2096f209 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1325,6 +1325,9 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
 				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
 
+	/* Following original QCA sourcecode set port to prefer master */
+	phy_set_bits(phydev, MII_CTRL1000, CTL1000_PREFER_MASTER);
+
 	return 0;
 }
 
-- 
2.32.0

