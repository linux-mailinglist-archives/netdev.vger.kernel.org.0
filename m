Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4C152869
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfFYJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:44:42 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49520 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFYJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jYV8Tj072ux9N6x6/rtvJHg3Xz7m+M7r2Q6yD4J1RGQ=; b=uoim6PPLOkExDpZcuSbCSxPqc3
        FwOBMp7VL0BHWOfCVRKRwjaIi3/ztEcA3QKLgHlk84/kKaKjZxY4Le7BTgHdg9kIEul7y5mFcmXuS
        +E0h+o+JthMAcCnB/qBN06PkVzAhGI8tJPmw3qofqrR+0pjxu7XD6DN5Tfc5vXHcMnsJKZgG8RH+X
        4YFFjXGHJaDSYQvUdL/lCI3JZfRMV56xmln5ubmHXtG7l2F+DU7IPcaNDB3SMWlUgh6rYOJkRwYNN
        X3IBsqKzAUc7mXp/Svd7mzOhKPHQ9P5QKkVnNus1zyAgb7wEJqUHf9s6xqV99h6mkknel26wLd4il
        1bFABzFQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37352 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hfi0A-0005ZY-MK; Tue, 25 Jun 2019 10:44:34 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hfi09-0007Zs-Vb; Tue, 25 Jun 2019 10:44:34 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phylink: further documentation clarifications
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
Date:   Tue, 25 Jun 2019 10:44:33 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify the validate() behaviour in a few cases which weren't mentioned
in the documentation, but which are necessary for users to get the
correct behaviour.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c5f3349e6824..6450bbf36e71 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -94,12 +94,19 @@ struct phylink_mac_ops {
  * Note that the PHY may be able to transform from one connection
  * technology to another, so, eg, don't clear 1000BaseX just
  * because the MAC is unable to BaseX mode. This is more about
- * clearing unsupported speeds and duplex settings.
+ * clearing unsupported speeds and duplex settings. The port modes
+ * should not be cleared; phylink_set_port_modes() will help with this.
  *
  * If the @state->interface mode is %PHY_INTERFACE_MODE_1000BASEX
  * or %PHY_INTERFACE_MODE_2500BASEX, select the appropriate mode
  * based on @state->advertising and/or @state->speed and update
- * @state->interface accordingly.
+ * @state->interface accordingly. See phylink_helper_basex_speed().
+ *
+ * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects the
+ * MAC driver to return all supported link modes.
+ *
+ * If the @state->interface mode is not supported, then the @supported
+ * mask must be cleared.
  */
 void validate(struct net_device *ndev, unsigned long *supported,
 	      struct phylink_link_state *state);
-- 
2.7.4

