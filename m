Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE94C46281D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhK2XUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbhK2XTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:19:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C33C0698D1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OOch/KCMcXvcw+BSoDTB3JXlLg44xx6zfEOB1Kacw0k=; b=AxRmBBSKspU6aflA6LSGmowyo7
        gaDiMqR0dTRKni/55jj5hrzWlv5Dxi18SWHhR93R6yl88q6uOzMWqZ0PWklJB3odyWbsohS7SI+P2
        gCEy48EjpA0HTql+4q51Q4NwYWAa49K0DOqcUU2zQTKdGbVo9U6A0U6AZuOxvIPI0+0y4x3uqxfYe
        Ci0lM0G0j3OIeUgOq36zF2gGsy+jvszmP64mzAjY7iktgD5shX9B8QJcIXASaQRfmWyIsN9HQl0af
        gH4Hr/kzu+SKoKw3LgJkrirf8Pj2RMPo1oY7F1uIpnH/KmqvBXB8zB2CFtY2ueRFQtJUy3sIvW97J
        BGiP54Og==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55966)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mrpqj-0006FL-UU; Mon, 29 Nov 2021 23:14:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mrpqj-0006Tk-GM; Mon, 29 Nov 2021 23:14:17 +0000
Date:   Mon, 29 Nov 2021 23:14:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
 <20211129195823.11766-7-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129195823.11766-7-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 08:58:23PM +0100, Marek Behún wrote:
>  static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> -					  u16 status, u16 lpa,
> +					  u16 ctrl, u16 status, u16 lpa,
>  					  struct phylink_link_state *state)
>  {
> +	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> +
>  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
> -		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> +		state->an_complete = !!(ctrl & BMCR_ANENABLE);

I think I'd much rather report the value of BMSR_ANEGCAPABLE - since
an_complete controls the BMSR_ANEGCAPABLE bit in the emulated PHY
that userspace sees. Otherwise, an_complete is not used.

state->link is the key that phylink uses to know whether it can
trust the status being reported.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
