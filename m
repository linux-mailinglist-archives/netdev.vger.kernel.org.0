Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDC2F0685
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbhAJK73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 05:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbhAJK73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 05:59:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF69DC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OOuNycd/ptBKBtXDz7bNQrd1JC7rOSs7jB0EjbzSYSE=; b=CmXkOCtOl4ya/tPCvHBEcs4eZQ
        sxsrkKLnDqyrwywOa1bviwi7ltMPNr3sDI71NvWYwoeCHIqzT/MpRJp4PrV0Xp7K66ldH1zzDYQ6W
        U2N+PveQn5ODXfzirDT4FeRM7eP+nMAWvHHJlf4U+dd0WlOSTDViY9fYjoPYEdCTVcShe1y88x20v
        C3BcxC/jdfbPctOOyQwn/JMvmEuTJYjR+e0GQmWYmds9+8aF6hsdX7pKEnmNIpawGRGoDlyrO8nGw
        Y8LPCVU8KwTHJVFQh3BpQSMoZMsJmyumM82Ttpx/ctse0HJUUfAwbs/EWbVPe0ziEohvrKRVFzNje
        PgZbntlw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52388 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYQa-0005mD-Iu; Sun, 10 Jan 2021 10:58:32 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYQa-0004iR-CU; Sun, 10 Jan 2021 10:58:32 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: sfp: cope with SFPs that set both LOS normal
 and LOS inverted
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 10 Jan 2021 10:58:32 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SFP MSA defines two option bits in byte 65 to indicate how the
Rx_LOS signal on SFP pin 8 behaves:

bit 2 - Loss of Signal implemented, signal inverted from standard
        definition in SFP MSA (often called "Signal Detect").
bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
        (often called "Rx_LOS").

Clearly, setting both bits results in a meaningless situation: it would
mean that LOS is implemented in both the normal sense (1 = signal loss)
and inverted sense (0 = signal loss).

Unfortunately, there are modules out there which set both bits, which
will be initially interpret as "inverted" sense, and then, if the LOS
signal changes state, we will toggle between LINK_UP and WAIT_LOS
states.

Change our LOS handling to give well defined behaviour: only interpret
these bits as meaningful if exactly one is set, otherwise treat it as
if LOS is not implemented.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 374351de2063..b2a5ed6915fa 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1534,15 +1534,19 @@ static void sfp_sm_link_down(struct sfp *sfp)
 
 static void sfp_sm_link_check_los(struct sfp *sfp)
 {
-	unsigned int los = sfp->state & SFP_F_LOS;
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+	bool los = false;
 
 	/* If neither SFP_OPTIONS_LOS_INVERTED nor SFP_OPTIONS_LOS_NORMAL
-	 * are set, we assume that no LOS signal is available.
+	 * are set, we assume that no LOS signal is available. If both are
+	 * set, we assume LOS is not implemented (and is meaningless.)
 	 */
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED))
-		los ^= SFP_F_LOS;
-	else if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL)))
-		los = 0;
+	if (los_options == los_inverted)
+		los = !(sfp->state & SFP_F_LOS);
+	else if (los_options == los_normal)
+		los = !!(sfp->state & SFP_F_LOS);
 
 	if (los)
 		sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
@@ -1552,18 +1556,22 @@ static void sfp_sm_link_check_los(struct sfp *sfp)
 
 static bool sfp_los_event_active(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_LOW) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_HIGH);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_LOW) ||
+	       (los_options == los_normal && event == SFP_E_LOS_HIGH);
 }
 
 static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_HIGH) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_LOW);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_HIGH) ||
+	       (los_options == los_normal && event == SFP_E_LOS_LOW);
 }
 
 static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
-- 
2.20.1

