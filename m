Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0328EEB5
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 10:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388272AbgJOIpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 04:45:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42563 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbgJOIp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 04:45:29 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201015084517euoutp01736d814e272f9bd611fdcdc84321fa27~_HgNbO_-L1458814588euoutp01e
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 08:45:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201015084517euoutp01736d814e272f9bd611fdcdc84321fa27~_HgNbO_-L1458814588euoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602751517;
        bh=y0oCq68YdRF8NXo3BoF+euePbj27PoHRi5+zdDHBL9E=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sMvl/x85sFi4K4rR8Q+X771Rfd4XMVtb34n6mqgTiNUksRE3ilZdYDlZM6qbMO7zr
         dgBqWVfQeLd9qel/mCE0EaqUIxwpXUuuLyhiJ5AU9T/jwDfadS+IopisvYnHSh/GkZ
         LrJSIe3xZTVfGs+IoUV96X4DLCLVd1F/bC+fGwPg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201015084514eucas1p233f9f5da7d4dc04178aab2ef3ba72461~_HgKoQEp-3079930799eucas1p2k;
        Thu, 15 Oct 2020 08:45:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A6.54.05997.A1C088F5; Thu, 15
        Oct 2020 09:45:14 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84~_HgKNHJKM3079530795eucas1p2U;
        Thu, 15 Oct 2020 08:45:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201015084513eusmtrp2766b126b06102e13b168439f659e7c4d~_HgKMfAzK0782407824eusmtrp2w;
        Thu, 15 Oct 2020 08:45:13 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-d3-5f880c1ac3ef
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5E.1D.06017.91C088F5; Thu, 15
        Oct 2020 09:45:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201015084513eusmtip1cc1450371704605ce86930770bfe9efd~_HgKAupoJ2954629546eusmtip10;
        Thu, 15 Oct 2020 08:45:13 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2] net: phy: Prevent reporting advertised modes when
 autoneg is off
Date:   Thu, 15 Oct 2020 10:44:35 +0200
Message-Id: <20201015084435.24368-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfyyUcRzH+97zPHePy/F1LB9qpUurtPzol2e71mjZnvWX+iNNK108O4Zj
        d4hqJUrY+V3IjxgLUURcDqlddSpxTEuaS5mxrFaNtur65Txn+e/9+Xxe7+/789m+NCHtoNzp
        KFUCp1YpYmRCMakz/hjc5m6fGeZ7qYBiTGYDwbSWtlBMhekiydR8LqWYIV0uxYwZGhAz0lUh
        ZAxX7yPm9mOziDFWrwoQsyOvhgm2/eaYgNWXmUVsW2OWkNV3zgnY3PZGxM61rQ0WhYr3RHAx
        UUmc2mfvCXHkG+0DMl5rn1yr05KpqFOcjexowDvh5XAekY3EtBQ3IHgx2S3ki3kEtZZsAV/M
        IXjYbUFLlrG+ChtVj6C48+PiQIpnEOTObrBqIQ6EvBtPKSvkgr8hmJq+g6wFgXsR6N9eIayU
        Mz4MM01m0qpJvBGac8wLfZqWYDkM6Xz5tHVwuf6e0Kol2AmeXZtaxB2xF9xKG13UxAKT3lG+
        eATgXhEUNRUJePN+yGoaJHntDLN97SJer4G/+iqBNQvweSgq3M17tQh0Fd9tvBzGB38KrQyB
        t0BLlw/fDoT+4TSCtzrA609O/AoOUKgrsbUlkJkh5WlPaM7rsT3oDjmzDYhHWDDp2Xy0vmzZ
        XWXLbin7H1uNiEbkyiVqYpWcZruKO+WtUcRqElVK7/C42Da08Jn6//TNd6KuXycNCNNIZi9Z
        YckIk1KKJE1KrAEBTchcJPsG+o9LJRGKlNOcOi5MnRjDaQxoNU3KXCU7aj4ck2KlIoGL5rh4
        Tr00FdB27qmoZb7uTJtx9t1WCzlafFSVlqPYpHJUojqL4+aQDD+3guGOoEOhNeW1PeboL1+N
        uWbLo12ixEj/4umgSjqzxtx6N7zyXLrPiGyiashNXe8pTx0/S0RPyluemAYo1+uTKycOBIip
        0iIjeTAZl9QfUV7wCHnuM+73/rdHvr+xJ7hARmoiFX5ehFqj+Ae8//lGSAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xu7qSPB3xBq+3qVqcv3uI2WLjjPWs
        FnPOt7BYLHo/g9XiwrY+Voubh1YwWlzeNYfN4tDUvYwWa4/cZbc4tkDMgcvj8rWLzB5bVt5k
        8tg56y67x6ZVnWweO3d8ZvLo27KK0ePzJrkA9ig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMT
        Sz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jFs9+1kKengqFm/rYWlg3MHVxcjJISFgInHz+By2
        LkYuDiGBpYwS6953sHYxcgAlpCRWzk2HqBGW+HOtC6rmKaPE1YYHbCAJNgFHif6lJ1hBEiIC
        vxklthydB+YwC+xjlNh/dDE7yCRhgRCJXbecQRpYBFQl1vXeZQYJ8wpYS1zYZgCxQF6iffl2
        sJm8AoISJ2c+YQEpYRZQl1g/TwgkzC+gJbGm6ToLiM0MVN68dTbzBEaBWUg6ZiF0zEJStYCR
        eRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgXG079nPLDsaud8GHGAU4GJV4eBl+t8ULsSaW
        FVfmHmKU4GBWEuF1Ons6Tog3JbGyKrUoP76oNCe1+BCjKdA3E5mlRJPzgTGfVxJvaGpobmFp
        aG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qBUcxbYpfb34+rNRZ+/R+yYvpPlm+R
        ReGHc5UsotysA5+srHu24iL3vpC3LNECeqzyIfUFs++1vd4d+t66ccd7k+Ohj+4WSr1dwZMZ
        pTd3d9bZkF9CDDN/fpnQcKjat5Nz2WV9DomML3rxl0QFwpi1qjoY/R5Fe59b6Ck/xbvubMzb
        Ta0PNWfNVWIpzkg01GIuKk4EAKPQG6jBAgAA
X-CMS-MailID: 20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84
References: <CGME20201015084513eucas1p234e2fa7a42b973ee7feafbdac6267a84@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not report advertised link modes (local and remote) when
autonegotiation is turned off. mii_ethtool_get_link_ksettings() exhibits
the same behaviour and this patch aims at unifying the behavior of both
functions.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Changes in v2:
  - clear lp_advertising
  - set ETHTOOL_LINK_MODE_TP_BIT and ETHTOOL_LINK_MODE_MII_BIT in advertising

 drivers/net/phy/phy.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..6ede9c1c138c 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -315,8 +315,17 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
 	linkmode_copy(cmd->link_modes.supported, phydev->supported);
-	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
-	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
+	if (phydev->autoneg) {
+		linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
+		linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
+	} else {
+		linkmode_zero(cmd->link_modes.lp_advertising);
+		linkmode_zero(cmd->link_modes.advertising);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_TP_BIT,
+				 cmd->link_modes.advertising);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT,
+				 cmd->link_modes.advertising);
+	}
 
 	cmd->base.speed = phydev->speed;
 	cmd->base.duplex = phydev->duplex;
-- 
2.26.2

