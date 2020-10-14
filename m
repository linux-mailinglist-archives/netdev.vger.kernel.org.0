Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8128E0DD
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 14:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgJNM5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 08:57:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50856 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgJNM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 08:57:20 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201014125707euoutp02f22d999bb32cfe122b2a6541e65aeb82~93S0Jxec91062110621euoutp02e
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 12:57:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201014125707euoutp02f22d999bb32cfe122b2a6541e65aeb82~93S0Jxec91062110621euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602680227;
        bh=vQlxo6nLjtzjzaE1lL8/oISJVcqfsRAvglzDQMnNXFw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=BP02PhckUf3s1RlYwLCl5XC9Gt5UeCBdU+MmuKHPhI6OjkAXfCMw9MpSpjqJ1TP6E
         /tKoxHnpKk7FkHrWyivFbjXcODmrsQwYG4QJFOjet0pvFIBmCA432xRLGJsdsB4AFh
         bRwgX9znN5BHJX+QThf0nNkTZXQGx0QOj4arPu10=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201014125656eucas1p2f3b32701d9f4f89cc99974ae6b428812~93SpWHXhu2671526715eucas1p2z;
        Wed, 14 Oct 2020 12:56:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id E9.96.06456.895F68F5; Wed, 14
        Oct 2020 13:56:56 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88~93So2gW7d1318413184eucas1p1F;
        Wed, 14 Oct 2020 12:56:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201014125655eusmtrp2b374e2185b3a68cedbc113e098e3c545~93So1fV3x0988109881eusmtrp2H;
        Wed, 14 Oct 2020 12:56:55 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-3c-5f86f5986550
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 07.2C.06017.795F68F5; Wed, 14
        Oct 2020 13:56:55 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201014125655eusmtip2d19c87f17b3c70bef40711952d775b74~93SorydE00352703527eusmtip2B;
        Wed, 14 Oct 2020 12:56:55 +0000 (GMT)
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
Subject: [PATCH] net: phy: Prevent reporting advertised modes when autoneg
 is off
Date:   Wed, 14 Oct 2020 14:56:50 +0200
Message-Id: <20201014125650.12137-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7djPc7ozvrbFG7TO47E4f/cQs8XGGetZ
        Leacb2GxWPR+BqvFhW19rBY3D61gtLi8aw6bxaGpexkt1h65y25xbIGYA5fH5WsXmT22rLzJ
        5LFz1l12j02rOtk8du74zOTRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGbNf/WUrmM9e8Xnq
        JsYGxkVsXYycHBICJhJ7t51g7mLk4hASWMEo0fr2EJTzhVHi1qO7zCBVQgKfGSV2bgmA6Zh7
        7yELRNFyRomn/7axQzjPGSXuXFgONpdNwFGif+kJVpCEiMBXRoknzzYwgjjMAvuARt2bAjZX
        WCBY4vWfVUwgNouAqsSZ3qOsIDavgLXEnbU3GCH2yUu0L9/OBhEXlDg58wkLiM0voCWxpuk6
        mM0MVNO8dTbY4RIC+9gltvz9A9XsIvGs7QKULSzx6vgWdghbRuL/zvlAizmA7HqJyZPMIHp7
        GCW2zfnBAlEDdMS5X2wgNcwCmhLrd+lDhB0l3u7uZIVo5ZO48VYQ4gQ+iUnbpjNDhHklOtqE
        IKpVJNb174EaKCXR+2oF1DEeEk8OXGCawKg4C8ljs5A8Mwth7wJG5lWM4qmlxbnpqcWGeanl
        esWJucWleel6yfm5mxiByen0v+OfdjB+vZR0iFGAg1GJh7djQ2u8EGtiWXFl7iFGCQ5mJRFe
        p7On44R4UxIrq1KL8uOLSnNSiw8xSnOwKInzGi96GSskkJ5YkpqdmlqQWgSTZeLglGpgFN53
        58h2tabij6tDjLuifWRPV5y7It9zk2lX5LpLMSfqCtvZvx/9ckrhtvWJGxqRrLYzbNcVLrrK
        eXLNkW+HRLQeOGkrH7DmTHc89VJl+Zr/AkWz90Rf/y9a+I7v20epv60VB+pXbbE6HjTF+ekM
        qV+7QgT8UzwnF7XWvvNONOOykn/Pmmx8X4mlOCPRUIu5qDgRAA6VK2lKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xe7rTv7bFG9w9rGNx/u4hZouNM9az
        Wsw538Jisej9DFaLC9v6WC1uHlrBaHF51xw2i0NT9zJarD1yl93i2AIxBy6Py9cuMntsWXmT
        yWPnrLvsHptWdbJ57Nzxmcmjb8sqRo/Pm+QC2KP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxM
        LPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mma/+stWMJ+94vPUTYwNjIvYuhg5OSQETCTm3nvI
        0sXIxSEksJRRYteUw0AOB1BCSmLl3HSIGmGJP9e62CBqnjJKNH+exwKSYBNwlOhfeoIVJCEi
        8JtRYsvReWAOs8A+Ron9Rxezg1QJCwRKTHi9hBHEZhFQlTjTe5QVxOYVsJa4s/YGI8QKeYn2
        5dvZIOKCEidnPgG7gllAXWL9PCGQML+AlsSaputgi5mBypu3zmaewCgwC0nHLISOWUiqFjAy
        r2IUSS0tzk3PLTbSK07MLS7NS9dLzs/dxAiMrW3Hfm7Zwdj1LvgQowAHoxIPb8eG1ngh1sSy
        4srcQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2I0BXpnIrOUaHI+MO7zSuINTQ3NLSwN
        zY3Njc0slMR5OwQOxggJpCeWpGanphakFsH0MXFwSjUwRlx+qLR722b3bz1ztt/YtauXLcL0
        VTLrt0v7Yx9Wvc/JXf/ljJxSb96//N/y86TyWZc3Mbz7cYJVTeDwuqdWb5f9lDxx5fqWp+Xm
        y99u36h2bL1GXsVuJfvadEftdwoHY49tko6XWbmo+9eVayfW2bYKzn8sfzgqoro330foMbtZ
        YpqIsWhBhhJLcUaioRZzUXEiAAClWSHDAgAA
X-CMS-MailID: 20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88
References: <CGME20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not report advertised link modes when autonegotiation is turned
off. mii_ethtool_get_link_ksettings() exhibits the same behaviour.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/net/phy/phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 35525a671400..3cadf224fdb2 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -315,7 +315,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 			       struct ethtool_link_ksettings *cmd)
 {
 	linkmode_copy(cmd->link_modes.supported, phydev->supported);
-	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
+	if (phydev->autoneg)
+		linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
 	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
 
 	cmd->base.speed = phydev->speed;
-- 
2.26.2

