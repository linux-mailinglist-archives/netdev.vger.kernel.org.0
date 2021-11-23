Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7545A1AC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhKWLoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbhKWLoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 06:44:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF81EC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 03:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4WNg7z+jf8Oq0zGFdRHpOdrEgnvx4dxIRZMmv5uik6g=; b=CJvfUufRHBsXgD4WtEqDvs79Ky
        2Nx7nIfe7RqzUaUCQGlge1Zk8IJwW9laa4rF4BDR2TSk3tF4JohQBzY6qMWt3DxmxLw/LoTQtYsVj
        P/CosUw6UP+nDREi1VF9bc6VC3HSpO93dfUwyDtqBwSwLbu/7RhRZMEoo34zwSvB5nsaUcJUZZvRD
        QPzCJW5MjH2r2njvM0iZTqYZqXIOHFiEdWn1rll+Anx/fW1Pyjjj7qywsGYneTryNdmqbHVbPerGD
        MALv2Gz6rK+REEP7Ax3S8VoMF92zPc5YALqIwZOv7ukH0f6xaw7sPuYkx+OMOT7wAmTySVNTzekMR
        BkfItVJg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55814)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpUAN-0007pU-8T; Tue, 23 Nov 2021 11:40:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpUAM-0000By-Ll; Tue, 23 Nov 2021 11:40:50 +0000
Date:   Tue, 23 Nov 2021 11:40:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net
Subject: Re: [PATCH net 2/2] net: phylink: Force retrigger in case of latched
 link-fail indicator
Message-ID: <YZzTQgyhsbWAfmZu@shell.armlinux.org.uk>
References: <20211122235154.6392-1-kabel@kernel.org>
 <20211122235154.6392-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211122235154.6392-3-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:51:54AM +0100, Marek Behún wrote:
> On mv88e6xxx 1G/2.5G PCS, the SerDes register 4.2001.2 has the following
> description:
>   This register bit indicates when link was lost since the last
>   read. For the current link status, read this register
>   back-to-back.
> 
> Thus to get current link state, we need to read the register twice.
> 
> But doing that in the link change interrupt handler would lead to
> potentially ignoring link down events, which we really want to avoid.
> 
> Thus this needs to be solved in phylink's resolve, by retriggering
> another resolve in the event when PCS reports link down and previous
> link was up.
> 
> The wrong value is read when phylink requests change from sgmii to
> 2500base-x mode, and link won't come up. This fixes the bug.

I've also been re-thinking this patch - I don't think it's sufficient
to completely solve the problem, and I think this is required to make
it bullet-proof.

I suspect the reason no problem is being seen is that normally, the
BMSR is read prior to calling phylink_mac_change() which will "unlatch"
the bit.

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 73cb97285caa..47fe16b4e387 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1097,10 +1097,17 @@ static void phylink_resolve(struct work_struct *w)
 			phylink_mac_pcs_get_state(pl, &link_state);
 
 			/* The PCS may have a latching link-fail indicator.
-			 * If the PCS link goes down, retrigger a resolve.
+			 * If the link was up, bring the link down and
+			 * re-trigger the resolve. Otherwise, re-read the
+			 * PCS state to get the current status of the link.
 			 */
-			if (!link_state.link && cur_link_state)
-				retrigger = true;
+			if (!link_state.link) {
+				if (cur_link_state)
+					retrigger = true;
+				else
+					phylink_mac_pcs_get_state(pl,
+								  &link_state);
+			}
 
 			/* If we have a phy, the "up" state is the union of
 			 * both the PHY and the MAC

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
