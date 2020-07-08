Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359DA218D6B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgGHQrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:47:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D34C061A0B;
        Wed,  8 Jul 2020 09:47:11 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so18975654pgf.0;
        Wed, 08 Jul 2020 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YIDdAQlGjsYvw19XCWPwW9U4WErJ5y9VgVOeXoVK1us=;
        b=G11va7FUDKfWeBeqi6lGDaRx2Vw+F/d9Zo2//sAZscPnyg3Bwj4toMNtnG4h9EJgVC
         E3CoIqiDC0iSejUHPJZyaWEBHZTSU7GPdeI0NqNfbEdwhoJE1D0DOUmKxd4tw4vjdmUj
         e2r6e+WlfrHnnHAnlWOSUN8GhMgrPvliZdN3moO32o4P16jv6v4kVleQoCchazDH7YHh
         mNJdxNl6ZdUh7KGHhP+cU8xPJKmNDsbijaJ9dznFAKpYOEfHCxVWOXv5fk4TFb2kwTUY
         APla+redE3iWT4pDhtkmrU8/m7lN66RB+YTrHDOr4lmQ7UBqteBFrxougiNSJswmaTXI
         xsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YIDdAQlGjsYvw19XCWPwW9U4WErJ5y9VgVOeXoVK1us=;
        b=kRIRIza9jTofw1dLcbor9ow/9qxo3DztsdWkehr2jYb3hCHByZoaIfWSo2CKFNLCf9
         0frRX6ke8tQFnhjnWpMFj2DsSCglaJSzpE4EoXi6n8dROT8hr/uSqTaOqrncfNmeTkAY
         iAxDQxsKKbYW3KIMqktrHpK17xQZ2Yra7GAyQl/blVIjhJPkwoUZwaDv7dR5HkteDk57
         yaJDqfdM0/DrtmvyVgKpEKbQlkavc1QcUA1kwtozLb33JhHJvtysXBQa46y1d9d8K+Ji
         ttjXq94ehCg4Op6P1b1dweY+INhwbfqvS28s2U366G1fibLVm1iAIdh2b3N+O+rdMyjU
         5tCQ==
X-Gm-Message-State: AOAM532ZgtB/ZlGLaB6e5dXMvaSbvLiNM7Iq7B3sbIUN0axwQm7LXj4U
        j0BmjVZ7pnEnONuk/KXRENlKiKM/
X-Google-Smtp-Source: ABdhPJyYUkRXoVQKF7q9AoaEDHNzoJiNA2nwr3NQB4m3KfpHyiCQvWhd1TVdUmLZg0n/T86FXyuufw==
X-Received: by 2002:a63:5619:: with SMTP id k25mr30455983pgb.139.1594226830495;
        Wed, 08 Jul 2020 09:47:10 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x22sm356247pfr.11.2020.07.08.09.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 09:47:09 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/2] net: phy: Define PHY statistics ethtool_phy_ops
Date:   Wed,  8 Jul 2020 09:46:24 -0700
Message-Id: <20200708164625.40180-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708164625.40180-1-f.fainelli@gmail.com>
References: <20200708164625.40180-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend ethtool_phy_ops to include the 3 function pointers necessary for
implementing PHY statistics. In a subsequent change we will uninline
those functions.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 +++
 include/linux/ethtool.h      | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 233334406f0f..7cda95330aea 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3028,6 +3028,9 @@ static struct phy_driver genphy_driver = {
 };
 
 static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
+	.get_sset_count		= phy_ethtool_get_sset_count,
+	.get_strings		= phy_ethtool_get_strings,
+	.get_stats		= phy_ethtool_get_stats,
 	.start_cable_test	= phy_start_cable_test,
 	.start_cable_test_tdr	= phy_start_cable_test_tdr,
 };
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 0c139a93b67a..969a80211df6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -508,6 +508,9 @@ struct phy_tdr_config;
 
 /**
  * struct ethtool_phy_ops - Optional PHY device options
+ * @get_sset_count: Get number of strings that @get_strings will write.
+ * @get_strings: Return a set of strings that describe the requested objects
+ * @get_stats: Return extended statistics about the PHY device.
  * @start_cable_test - Start a cable test
  * @start_cable_test_tdr - Start a Time Domain Reflectometry cable test
  *
@@ -515,6 +518,10 @@ struct phy_tdr_config;
  * and callers must take this into account. Callers must hold the RTNL lock.
  */
 struct ethtool_phy_ops {
+	int (*get_sset_count)(struct phy_device *dev);
+	int (*get_strings)(struct phy_device *dev, u8 *data);
+	int (*get_stats)(struct phy_device *dev,
+			 struct ethtool_stats *stats, u64 *data);
 	int (*start_cable_test)(struct phy_device *phydev,
 				struct netlink_ext_ack *extack);
 	int (*start_cable_test_tdr)(struct phy_device *phydev,
-- 
2.25.1

