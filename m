Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0254246E8DB
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhLINPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbhLINPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:15:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9F4C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 05:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JPYkcsWO2bOIeCroDzA3GxjUHPWnW9Ax2oHoZ3I6X/Y=; b=YrKrfrURtsDXcwy0aG1jH7g85h
        6yEDXuXAxpKjpe9VHasELJkX0r4D0F477owcBD887EIOseIel1m8DJrKXJztUBvuqpMcRypSmwmZU
        KXA8R5yiNuuAJGvSjilndbvCpPg2nw8etHZiz/kc/yDmVmP3GPGRQhgaM90WDTJlWqBWmV7t/UctU
        95sogfFp9dkv1WSvapL8tMn+g6CNAW1KseEYcNcKjLMzgrqe3+bc8aVYuz04nCCIC1Z6h2J0/6DiU
        rAqozPIyhPOFVjAvovK+BCbxdwaRmYUprzIcTgvNJyoaLTYZtRjc7lFzTlcP48fFSMO9PVRf1MjUw
        sdLUJQwg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45528 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvJCv-0008Sh-C8; Thu, 09 Dec 2021 13:11:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mvJCu-00F93r-UO; Thu, 09 Dec 2021 13:11:32 +0000
In-Reply-To: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
References: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] net: phylink: add legacy_pre_march2020 indicator
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mvJCu-00F93r-UO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 09 Dec 2021 13:11:32 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a boolean to phylink_config to indicate whether a driver has not
been updated for the changes in commit 7cceb599d15d ("net: phylink:
avoid mac_config calls"), and thus are reliant on the old behaviour.

We were currently keying the phylink behaviour on the presence of a
PCS, but this is sub-optimal for modern drivers that may not have a
PCS.

This commit merely introduces the new flag, but does not add any use,
since we need all legacy drivers to set this flag before it can be
used. Once these legacy drivers have been updated, we can remove this
flag.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Resent with the correct cover-letter message-ID.

 include/linux/phylink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 01224235df0f..d005b8e36048 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -84,6 +84,8 @@ enum phylink_op_type {
  * struct phylink_config - PHYLINK configuration structure
  * @dev: a pointer to a struct device associated with the MAC
  * @type: operation type of PHYLINK instance
+ * @legacy_pre_march2020: driver has not been updated for March 2020 updates
+ *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @pcs_poll: MAC PCS cannot provide link change interrupt
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
@@ -97,6 +99,7 @@ enum phylink_op_type {
 struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
+	bool legacy_pre_march2020;
 	bool pcs_poll;
 	bool poll_fixed_state;
 	bool ovr_an_inband;
-- 
2.30.2

