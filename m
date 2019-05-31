Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E27309A9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 09:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfEaHrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 03:47:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45291 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfEaHrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 03:47:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id b18so5765561wrq.12
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 00:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=dzpfityjiyVjBLgLIDdS7jy7fuGuzY8jJendAr5fdaU=;
        b=hZaEcrWuUar2mSp1ulSSIeJ12sn8rUP1OAZf+IIRLpBbnKhQSP9vi0gQXR0j1ER0LX
         ltI4MssBF2CzGdisONdQnG4gD88VboWQpwTL4trObnfDYR3Sl/QFjKXn9dby4LOS043X
         3Rops2zaYBopA+JOQ7ZNXWXkJsaNcBwiOE/9T0nsnPbNUxOwEAvapWcICHZuH3or8+mt
         8ZX1Pgan+DnhKlHYud7azYM+juhUDqlDTTbFLwWum0uUKv/+cLO6k9tuvm6x+605IMli
         yWW9EQXOgkBgS7mI9g53fdyB525QQpsuP4QZcJVDgLZkUqMELDZVpMazCy6hyuS6Ffg1
         +64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dzpfityjiyVjBLgLIDdS7jy7fuGuzY8jJendAr5fdaU=;
        b=jQa1/ImJElCVZOGTZWvWaaxkYRctgHbzZy1KbEXC5xfzMI4dpqvlaxuhj5qJrys6HJ
         ZY7tTVacfBeRNCskvI4qsrUDVBUSTfCexxYexjPjTO37pC8NK5Ofd7dcjFkNmfNkSUvU
         8pBxlGS10OsgPV+CHXO/EpU4+bwfXMGUW5VMRKQJntkrwKbnYGQPOXtYeJvTmMTmB93J
         iKPTw5KoksJNIieS4LI5QOgHElKlFZgCfU8UZv2I07ur2UC66Z98V29xfcoeTvYB75l7
         HEBOh3c9EdXUOiK7FBs58dCWYyy2tZ1ZFdOE/6ZyCcXXa1zxEooAkXrN8PO9+sQLgCMD
         3ksA==
X-Gm-Message-State: APjAAAWGo60BW7oU8QGtbX1uUFLkxgBgEFrtYw7exnsayY17e0iUwR6g
        aoAleKEPD9N1JYc7avmj3LZ/HA==
X-Google-Smtp-Source: APXvYqyOtIS/CRng6RAf7TVt12TGYUminrxW7vT1l9v+5dGgwHi0wPivDQp+dRnsatvgBKL/P8MrvQ==
X-Received: by 2002:a5d:6709:: with SMTP id o9mr5380589wru.301.1559288863582;
        Fri, 31 May 2019 00:47:43 -0700 (PDT)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id a4sm11022778wrf.78.2019.05.31.00.47.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 00:47:43 -0700 (PDT)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH] net: phy: support C45 phys in SIOCGMIIREG/SIOCSMIIREG ioctls
Date:   Fri, 31 May 2019 10:47:27 +0300
Message-Id: <20190531074727.3257-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows phytool [1] and similar tools to read and write C45 phy
registers from userspace.

This is useful for debugging and for porting vendor phy diagnostics tools.

[1] https://github.com/wkz/phytool

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
---
 drivers/net/phy/phy.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e8885429293a..3d991958bde0 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -407,6 +407,7 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 	struct mii_ioctl_data *mii_data = if_mii(ifr);
 	u16 val = mii_data->val_in;
 	bool change_autoneg = false;
+	int ret;
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
@@ -414,12 +415,28 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		/* fall through */
 
 	case SIOCGMIIREG:
+		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
+			ret = phy_read_mmd(phydev,
+					   mdio_phy_id_devad(mii_data->phy_id),
+					   mii_data->reg_num);
+			if (ret < 0)
+				return ret;
+			mii_data->val_out = ret;
+			return 0;
+		}
 		mii_data->val_out = mdiobus_read(phydev->mdio.bus,
 						 mii_data->phy_id,
 						 mii_data->reg_num);
 		return 0;
 
 	case SIOCSMIIREG:
+		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
+			ret = phy_write_mmd(phydev,
+					    mdio_phy_id_devad(mii_data->phy_id),
+					    mii_data->reg_num,
+					    mii_data->val_in);
+			return ret;
+		}
 		if (mii_data->phy_id == phydev->mdio.addr) {
 			switch (mii_data->reg_num) {
 			case MII_BMCR:
-- 
2.11.0

