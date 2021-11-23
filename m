Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D310E459FAA
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhKWKDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhKWKDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 05:03:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2F4C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fTcvLpPz/LI1BZa+3R5EayZc6ONehYohUJqWm4x8FEc=; b=fMwWV7P6zDvruLM/U/VTSCMKe5
        8HRTNuJolzo5qpf89sdHgskdaGGxqQqy8Sz5VlDvjsRi/iATHQO6VJWkZxYW9YSkiVisHrYnRmbV2
        qVAwjHtxpneXvU4CEH8ljxlVq8x+Vl31vV3G4qqpVxLQ7jAr73oil6nSQMhcUoJstAQzcIXkcyKS7
        ML+ggqTKYQhkjxBKqVaRwS6vYxI9cuEBv+zAu2qi9MNcslTnoD2wbib7Q86lOCbNC1rIOIq5fdJWL
        Kxwc+4KGfbVXw0k7lvv/enxL53hDPKMWI8t+EYqDOCVxKfvb78z5O31L9cwacJyaCHHR2gYxmekoS
        QZQIRgeA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36036 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSb6-0007hi-0r; Tue, 23 Nov 2021 10:00:20 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSb5-00BXoV-IG; Tue, 23 Nov 2021 10:00:19 +0000
In-Reply-To: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 2/8] net: phylink: add legacy_pre_march2020
 indicator
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpSb5-00BXoV-IG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 23 Nov 2021 10:00:19 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a boolean to phylink_config to indicate whether a driver has not
been updated for the changes in commit 7cceb599d15d ("net: phylink:
avoid mac_config calls"), and thus are reliant on the old behaviour.

We were keying this behaviour on the presence of a PCS, but this
becomes an unreliable indicator when making PCS optional. Hence, we
use a flag instead.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
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

