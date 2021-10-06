Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448044249C4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbhJFWia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239654AbhJFWi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D48C061762;
        Wed,  6 Oct 2021 15:36:33 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id dj4so15482335edb.5;
        Wed, 06 Oct 2021 15:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DXD9K7sZ6yTBvu209ZfQAW71yA/R1uO8qK6acuTsoXI=;
        b=hggA0EJX3LJBLN37Z8cjJx97ReBwjH4wBuvGXgPCKc6L463ScX30y+2SExB8SDMOGZ
         NKJbnufSdgcL0MxijGyfr8Uq79/F3A0i0aU+9NWkwuEzDh3yAMMUVQIoJl31/IYTkgjq
         /GxE9L3DJY1MkxiEPrc6n+Q7yejZaGU/uMIrS6lACwIce+YXYViv9tEQXUP5N7e8lsOW
         HMcvJF1uf43IRMr5Zfo8i8UA1qo5rgMTkrqLk7gcWsQXkTIODolyyb/qEYegxs4hJpfe
         vzCQl2WYW6SDWF69TLNRHS7KiSNvMAketaUTR30hR0K0ZvqFi6sEiO1FnnyFDh9WQVxb
         B0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DXD9K7sZ6yTBvu209ZfQAW71yA/R1uO8qK6acuTsoXI=;
        b=QXHNl9mAeB9ZzU3rw8FcoYQ94wi08AyRF84hLJe/4/5rjsDsOAWk5IkrmtrFhGNNAa
         ADbUdCqHTxxjFqxG3VgUprt56f6J4PQFR8sDJjejbUiFoQS6H6Glex7YKSVO327q9t+t
         cmvD1XYStduSBB6RcEl21GiCB6BNCa7zKaKVJgTrIk2xsMbmXsIAC1T7FrRu8HcyYVaz
         DTgKYfUDPdtq1ykzrZgGTbo+J9m9mTYR/hnJ0irzSyLXclQCMRjQPhWe/zUJmEkmHLCE
         MgZB//uAzniDnyZt74cY5Mk6tLnE+nDxhD8TNHiveV2uoFfuurchnOemP2JtlaS8gui1
         n3og==
X-Gm-Message-State: AOAM531dZhGTa2gwbErvbAScV8J3xC2lrEg2llWOZNbWML//PUg7sT/6
        0UfANu4NTlWhbSoGOd7GpKxK+nUGA5Y=
X-Google-Smtp-Source: ABdhPJx6Qo9MHigDssolAylOkYcO7vUnKHqSaSZo2+P0je3a2Y6ORXJg7ureTar6CSbUnD0oxAA0jA==
X-Received: by 2002:a17:906:54c3:: with SMTP id c3mr1083406ejp.536.1633559791836;
        Wed, 06 Oct 2021 15:36:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:31 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH 03/13] drivers: net: phy: at803x: enable prefer master for 83xx internal phy
Date:   Thu,  7 Oct 2021 00:35:53 +0200
Message-Id: <20211006223603.18858-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From original QCA source code the port was set to prefer master as port
type in 1000BASE-T mode. Apply the same settings also here.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 71237a4e85a3..851d47b8a331 100644
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

