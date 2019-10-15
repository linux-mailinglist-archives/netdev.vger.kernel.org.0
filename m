Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1F8D7338
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJOK2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:28:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38166 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJOK2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pL5D7aYHaKzxXb6vMLqJlgak61/I1hPxIUacYa5t0CM=; b=c2A2GT8K+lacp3zQDN+IyTnFMQ
        +OX/simApL0nYE/Fo1AjljtKoMdkStw+0iUZrplEShLVOWqFvCDpLO073pe8W/7FcCWRKxPdsoz+P
        QPUXtxXiVvHXuVn3SvQXYilMuUj/SdhkvvZcZADe671qe7pitcDF0YZGnH+2jFg8tIQBv6w9DXwTt
        VKldYApRRwAkpEpipVD00oKJjBzdQXNZwveCs++oTIvjgj9nmREttsfPF6DTR6FGnJ7CD3V9QcNJU
        u3zxMW8e0FIXPEFO4ONwY94hSOHHz0NFxHBiwmfNpL617k11S9R7r8Jgxt5zx9SQEd4LioUn6l9K+
        n8gRWfmg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:38500 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iKK4M-0003re-Sp; Tue, 15 Oct 2019 11:28:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iKK4M-0000bC-AE; Tue, 15 Oct 2019 11:28:46 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: use more linkmode_*
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iKK4M-0000bC-AE@rmk-PC.armlinux.org.uk>
Date:   Tue, 15 Oct 2019 11:28:46 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use more linkmode_* helpers rather than open-coding the bitmap
operations.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 7 ++-----
 include/linux/linkmode.h  | 6 ++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a5a57ca94c1a..8e53ed90da3c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -117,9 +117,7 @@ static int phylink_is_empty_linkmode(const unsigned long *linkmode)
 	phylink_set(tmp, Pause);
 	phylink_set(tmp, Asym_Pause);
 
-	bitmap_andnot(tmp, linkmode, tmp, __ETHTOOL_LINK_MODE_MASK_NBITS);
-
-	return linkmode_empty(tmp);
+	return linkmode_subset(linkmode, tmp);
 }
 
 static const char *phylink_an_mode_str(unsigned int mode)
@@ -1728,8 +1726,7 @@ static int phylink_sfp_module_insert(void *upstream,
 	if (phy_interface_mode_is_8023z(iface) && pl->phydev)
 		return -EINVAL;
 
-	changed = !bitmap_equal(pl->supported, support,
-				__ETHTOOL_LINK_MODE_MASK_NBITS);
+	changed = !linkmode_equal(pl->supported, support);
 	if (changed) {
 		linkmode_copy(pl->supported, support);
 		linkmode_copy(pl->link_config.advertising, config.advertising);
diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index a99c58866860..fe740031339d 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -82,4 +82,10 @@ static inline int linkmode_equal(const unsigned long *src1,
 	return bitmap_equal(src1, src2, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static inline int linkmode_subset(const unsigned long *src1,
+				  const unsigned long *src2)
+{
+	return bitmap_subset(src1, src2, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 #endif /* __LINKMODE_H */
-- 
2.20.1

