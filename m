Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7915FF19
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBOPuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:50:25 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34156 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C0yOsJFMoJBAvMTz5m31IGzCQXPToqGnVUa2g7VsslQ=; b=NH/Y5fO47x22fALr/xMJbex9MJ
        3T0FgA/nv6Q8H/cFRZhqWARVBSnRdKhqp5F5m+mcFE457bivIZR14imaOvkLDy+UyrnGsC6zcRHY9
        lNXZ88w4msFPSNJ865j4vvw+eIha8pi45mI4g/Meo/O8Tpv3NhyIoC5/Df1D98nOkRC5/o6jQsvLB
        se7SqeGj4BtdIne8/h1t+15BLw7wbHDz1SaeitKTu3iJhJXI7i77cyeWV/WZYbFdIzzQ+Hwm1tpNP
        H9pbjHwsI7KvUp8yiQUeRegTQqGwDDmNvklzVLMRPXS15EgtHfPE445xDi77IcRYs7JGMrEBb9X6V
        gOAkS3Rw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:57260 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhr-0005kN-JL; Sat, 15 Feb 2020 15:50:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j2zhp-0003Yf-1O; Sat, 15 Feb 2020 15:50:09 +0000
In-Reply-To: <20200215154839.GR25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 10/10] net: phylink: clarify flow control settings in
 documentation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j2zhp-0003Yf-1O@rmk-PC.armlinux.org.uk>
Date:   Sat, 15 Feb 2020 15:50:09 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify the expected flow control settings operation in the phylink
documentation for each negotiation mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 0d6073c2b2b7..812357c03df4 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -152,13 +152,20 @@ void mac_pcs_get_state(struct phylink_config *config,
  * guaranteed to be correct, and so any mac_config() implementation must
  * never reference these fields.
  *
+ * In all negotiation modes, as defined by @mode, @state->pause indicates the
+ * pause settings which should be applied as follows. If %MLO_PAUSE_AN is not
+ * set, %MLO_PAUSE_TX and %MLO_PAUSE_RX indicate whether the MAC should send
+ * pause frames and/or act on received pause frames respectively. Otherwise,
+ * the results of in-band negotiation/status from the MAC PCS should be used
+ * to control the MAC pause mode settings.
+ *
  * The action performed depends on the currently selected mode:
  *
  * %MLO_AN_FIXED, %MLO_AN_PHY:
- *   Configure the specified @state->speed, @state->duplex and
- *   @state->pause (%MLO_PAUSE_TX / %MLO_PAUSE_RX) modes over a link
- *   specified by @state->interface.  @state->advertising may be used,
- *   but is not required.  Other members of @state must be ignored.
+ *   Configure the specified @state->speed and @state->duplex over a link
+ *   specified by @state->interface. @state->advertising may be used, but
+ *   is not required. Pause modes as above. Other members of @state must
+ *   be ignored.
  *
  *   Valid state members: interface, speed, duplex, pause, advertising.
  *
@@ -170,11 +177,14 @@ void mac_pcs_get_state(struct phylink_config *config,
  *   mac_pcs_get_state() callback. Changes in link state must be made
  *   by calling phylink_mac_change().
  *
+ *   Interface mode specific details are mentioned below.
+ *
  *   If in 802.3z mode, the link speed is fixed, dependent on the
- *   @state->interface. Duplex is negotiated, and pause is advertised
- *   according to @state->an_enabled, @state->pause and
- *   @state->advertising flags. Beware of MACs which only support full
- *   duplex at gigabit and higher speeds.
+ *   @state->interface. Duplex and pause modes are negotiated via
+ *   the in-band configuration word. Advertised pause modes are set
+ *   according to the @state->an_enabled and @state->advertising
+ *   flags. Beware of MACs which only support full duplex at gigabit
+ *   and higher speeds.
  *
  *   If in Cisco SGMII mode, the link speed and duplex mode are passed
  *   in the serial bitstream 16-bit configuration word, and the MAC
-- 
2.20.1

