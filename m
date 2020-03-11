Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7332181779
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgCKMHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:07:34 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53104 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgCKMHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:07:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZX/3fGrdOhZeFTGx8YZ+H/TekcqNg+mioVrWb26i5Vk=; b=kaHwpioAUR/y9fAtoPo1fXmQYB
        EGixRxS38EOWdsrFPOhQ1SYzW1sO5n9IbD++fgkeO/IIKdabA5YY3YOU3aVO3E6IZRk97vedkYM1U
        LCeCD7G+UcsFh1KWN48XJ58Svg4XpqKBHUkixmLV0EvnpVrig/9zMtFQPc5xvr2yUPv9fc+WZ2Vri
        iTG+bBZRVIHkHRKgKzN4tzJou84/254MYdplIAWDM6blnSxb7Z/OMidDwdnaVZ13VftcrexGSSooD
        KXfb2Jew/bNtZMd/ClL5MdGIyKYaW/oFj5ygoLafVl4QvGOTbhL2IzZ8Ed1QtJlJ2JOjCNJX+OZF0
        t8OKjrjA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:56978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jC090-00037J-Hu; Wed, 11 Mar 2020 12:07:26 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jC08z-0001cK-Mg; Wed, 11 Mar 2020 12:07:25 +0000
In-Reply-To: <20200311120643.GN25745@shell.armlinux.org.uk>
References: <20200311120643.GN25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/5] net: mii: add linkmode_adv_to_mii_adv_x()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jC08z-0001cK-Mg@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Mar 2020 12:07:25 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to convert a linkmode advertisement to a clause 37
advertisement value for 1000base-x and 2500base-x.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/mii.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 309de4a3e6e7..219b93cad1dd 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -536,6 +536,26 @@ static inline void mii_lpa_mod_linkmode_x(unsigned long *linkmodes, u16 lpa,
 			 lpa & LPA_1000XFULL);
 }
 
+/**
+ * linkmode_adv_to_mii_adv_x - encode a linkmode to config_reg
+ * @linkmodes: linkmodes
+ * @fd_bit: full duplex bit
+ */
+static inline u16 linkmode_adv_to_mii_adv_x(const unsigned long *linkmodes,
+					    int fd_bit)
+{
+	u16 adv = 0;
+
+	if (linkmode_test_bit(fd_bit, linkmodes))
+		adv |= ADVERTISE_1000XFULL;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT, linkmodes))
+		adv |= ADVERTISE_1000XPAUSE;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, linkmodes))
+		adv |= ADVERTISE_1000XPSE_ASYM;
+
+	return adv;
+}
+
 /**
  * mii_advertise_flowctrl - get flow control advertisement flags
  * @cap: Flow control capabilities (FLOW_CTRL_RX, FLOW_CTRL_TX or both)
-- 
2.20.1

