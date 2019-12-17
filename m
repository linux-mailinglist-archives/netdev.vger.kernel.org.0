Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5BC122D6B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfLQNuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:50:37 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56972 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfLQNuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:50:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3ZYg62xTh5gFE4K8Xb1O0oUMxhzGaoygLSKa3n1bb8o=; b=S8do0kEugq5TE8I3YH3/m8LA/2
        KBz6BywYJUj+c/mlEHXf5sFMYSx+IPakFtplduUhIDmPqRu5O//Gvt8MX6HF9dUnoVyca87wj5A3t
        MNTmcvEaOtZcsuQQSOb8nOAW8z/tXmwiLEE6NJbEOSr4l/dOFoMWcjm7Sg4+78Gs9JtSRPyLmmUQS
        HXiuhEZ+h56XzGLPz9THs6+LSWnDu2lDphcFDMW3S9aTbSyleEs7lGlNwqHDZ2C7cGzzk6Ml/H3l/
        b0j/elQXohjEei/wOqbMJ4R2BbAGWy2HnDXoOKczgOdJaiory7UX3y2DFYNXloYvdFFD7iZBj8F53
        Fuvdo06w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:35726 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihDF8-0006JK-EG; Tue, 17 Dec 2019 13:50:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihDF7-0002Hr-S3; Tue, 17 Dec 2019 13:50:29 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sfp: report error on failure to read sfp soft
 status
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihDF7-0002Hr-S3@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 13:50:29 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report a rate-limited error if we fail to read the SFP soft status,
and preserve the current status in that case. This avoids I2C bus
errors from triggering a link flap.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e54aef921038..73c2969f11a4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -442,13 +442,20 @@ static unsigned int sfp_soft_get_state(struct sfp *sfp)
 {
 	unsigned int state = 0;
 	u8 status;
+	int ret;
 
-	if (sfp_read(sfp, true, SFP_STATUS, &status, sizeof(status)) ==
-		     sizeof(status)) {
+	ret = sfp_read(sfp, true, SFP_STATUS, &status, sizeof(status));
+	if (ret == sizeof(status)) {
 		if (status & SFP_STATUS_RX_LOS)
 			state |= SFP_F_LOS;
 		if (status & SFP_STATUS_TX_FAULT)
 			state |= SFP_F_TX_FAULT;
+	} else {
+		dev_err_ratelimited(sfp->dev,
+				    "failed to read SFP soft status: %d\n",
+				    ret);
+		/* Preserve the current state */
+		state = sfp->state;
 	}
 
 	return state & sfp->state_soft_mask;
-- 
2.20.1

