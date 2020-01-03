Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035D612F99B
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 16:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgACPOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 10:14:05 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42280 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgACPOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 10:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N0h91rh8kQr2S218chi5xVtDfnmQFaTU1qpdrbyjZU4=; b=kTHsoxA5g4Gvaex1yqJaSxBd9N
        Xt5xLkEjfiv5oHKZUdrRe3SM1lQsQA5qAah3zGPGLSqMpxKWdiHDlv+nrROqNSbqe1F5jPUe2MXnl
        pdOxrMqoXgqftOJcFUxBWybWiiO8+cF9m6gdIUdphYJUQKC0Qen5nMKptDnYuq2m3OnfVsqfgcl3T
        uz21pNQnytQLJ3unMKxhfkze1HpTver+RNfhEaWJ3bAyLQ7HMK1ggF5tHGDZQHJ5+AYuwXj5yWanx
        OlmdGhcVUxng09zvlrnyMYEOdfc7aFc4P/k3yI/GvWoJQZrUT1OAx6vA96D1KrBJBbBNS2THNW+IO
        eVLf5HgA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49808 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inOeC-0002ks-SX; Fri, 03 Jan 2020 15:13:56 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1inOeC-00004q-18; Fri, 03 Jan 2020 15:13:56 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylink: fix failure to register on x86 systems
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1inOeC-00004q-18@rmk-PC.armlinux.org.uk>
Date:   Fri, 03 Jan 2020 15:13:56 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot reports a boot failure with qemu in 5.5-rc,
referencing commit 2203cbf2c8b5 ("net: sfp: move fwnode parsing into
sfp-bus layer"). This is caused by phylink_create() being passed a
NULL fwnode, causing fwnode_property_get_reference_args() to return
-EINVAL.

Don't attempt to attach to a SFP bus if we have no fwnode, which
avoids this issue.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Fixes: 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c0be51baf827..dcab9061b1ce 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -562,6 +562,9 @@ static int phylink_register_sfp(struct phylink *pl,
 	struct sfp_bus *bus;
 	int ret;
 
+	if (!fwnode)
+		return 0;
+
 	bus = sfp_bus_find_fwnode(fwnode);
 	if (IS_ERR(bus)) {
 		ret = PTR_ERR(bus);
-- 
2.20.1

