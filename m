Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB682146B0
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 16:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGDO4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 10:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGDO4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 10:56:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1818C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 07:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YN8mEYVh3fsQ4PaSoR5dVUtE3ry8H1i0s4EWlny5Y1s=; b=xU81TiWSv4N5bbO299ndDwo35
        ngqlN81eW3ThEI+x3oFpKvez9tgJYEwUHJFm3FfLzpzgK2Q62qWe2jCOouC9OH5MG6YJyOiw6q6lm
        FJLnRSdDlSTrw0oIajlvbqqEuxo36KJnJn9AQvdkhWJzora8jNToHEZ1BhCHcCItpfXwUaRP1XaOx
        u4G6jotj4fyWuhvQbL/2MTKZoxBRRnz5Y8Ve+wxLiO13rRE/CiPd4C8ROM28KOxzjPIZwxvSsZflX
        HtEcMwPctPpMR5lgukJS/23sdvbG+tNfwi1o7CWTCeqAolX/fUmEP/jg3MRp4yXgoUj/GVYrvmupI
        uWmSjkdmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35244)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jrjaT-0004hp-OL; Sat, 04 Jul 2020 15:56:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jrjaQ-0003xt-26; Sat, 04 Jul 2020 15:56:14 +0100
Date:   Sat, 4 Jul 2020 15:56:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
Message-ID: <20200704145613.GR1551@shell.armlinux.org.uk>
References: <20200704124507.3336497-1-olteanv@gmail.com>
 <20200704124507.3336497-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704124507.3336497-6-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 04, 2020 at 03:45:06PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Cisco SGMII and USXGMII standards specify control information
> exchange to be "achieved by using the Auto-Negotiation functionality
> defined in Clause 37 of the IEEE Specification 802.3z".
> 
> The differences to clause 37 auto-negotiation are specified by the
> respective standards. In the case of SGMII, the differences are spelled
> out as being:
> 
> - A reduction of the link timer value, from 10 ms to 1.6 ms.
> - A customization of the tx_config_reg[15:0], mostly to allow
>   propagation of speed information.
> 
> A similar situation is going on for USXGMII as well: "USXGMII Auto-neg
> mechanism is based on Clause 37 (Figure 37-6) plus additional management
> control to select USXGMII mode".
> 
> The point is, both Cisco standards make explicit reference that they
> require an auto-negotiation state machine implemented as per "Figure
> 37-6-Auto-Negotiation state diagram" from IEEE 802.3. In the SGMII spec,
> it is very clearly pointed out that both the MAC PCS (Figure 3 MAC
> Functional Block) and the PHY PCS (Figure 2 PHY Functional Block)
> contain an auto-negotiation block defined by "Auto-Negotiation Figure
> 37-6".
> 
> Since both ends of the SGMII/USXGMII link implement the same state
> machine (just carry different tx_config_reg payloads, which they convey
> to their link partner via /C/ ordered sets), naturally the ability to
> restart auto-negotiation is symmetrical. The state machine in IEEE 802.3
> Figure 37-6 specifies the signal that triggers an auto-negotiation
> restart as being "mr_restart_an=TRUE".
> 
> Furthermore, clause "37.2.5.1.9 State diagram variable to management
> register mapping", through its "Table 37-8-PCS state diagram variable to
> management register mapping", requires a PCS compliant to clause 37 to
> expose the mr_restart_an signal to management through MDIO register "0.9
> Auto-Negotiation restart", aka BMCR_ANRESTART in Linux terms.
> 
> The Felix PCS for SGMII and USXGMII is compliant to clause 37, so it
> exposes BMCR_ANRESTART to the operating system. When this bit is
> asserted, the following happens:
> 
> 1. STATUS[Auto_Negotiation_Complete] goes from 1->0.
> 2. The PCS starts sending AN sequences instead of packets or IDLEs.
> 3. The PCS waits to receive AN sequences from PHY and matches them.
> 4. Once it has received  matching AN sequences and a PHY acknowledge,
>    STATUS[Auto_Negotiation_Complete] goes from 0->1.
> 5. Normal packet transmission restarts.
> 
> Otherwise stated, the MAC PCS has the ability to re-trigger a switch of
> the lane from data mode into configuration mode, then control
> information exchange takes place, then the lane is switched back into
> data mode. These 5 steps are collectively described as "restart AN state
> machine" by the PCS documentation.
> This is all as per IEEE 802.3 Clause 37 AN state machine, which SGMII
> and USXGMII do not touch at this fundamental level.
> 
> Now, it is true that the Cisco SGMII and USXGMII specs mention that the
> control information exchange has a unidirectional meaning. That is, the
> PHY restarts the clause 37 auto-negotiation upon any change in MDI
> auto-negotiation parameters.
> 
> PHYLINK takes this fact a bit further, and since the fact that for
> SGMII/USXGMII, the MAC PCS conveys no new information to the PHY PCS
> (beyond acknowledging the received config word), does not have any use
> for permitting the MAC PCS to trigger a restart of the clause 37
> auto-negotiation.
> 
> The only SERDES protocols for which PHYLINK allows that are 1000Base-X
> and 2500Base-X. For those, the control information exchange _is_
> bidirectional (local PCS specifies its duplex and flow control
> abilities) since the link partner is at the other side of the media.
> 
> For any other SERDES protocols, the .phylink_mac_an_restart callback is
> dead code. This is probably OK, I can't come up with a situation where
> it might be useful for the MAC PCS to clear its cache of link state and
> ask for a new tx_config_reg.
> 
> So remove this code.

NAK for this description.  You know why.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
