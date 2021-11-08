Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D8449C24
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhKHTFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbhKHTFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 14:05:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D148C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 11:03:01 -0800 (PST)
Date:   Mon, 8 Nov 2021 20:02:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636398178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZkjr/TQ3VhqI2p+z3DXRWGKsyAoXJxMeWe2GkHkt/Y=;
        b=gWiSfM+T6deAF6TZslfUVvdPttQ686DSZhNbEGgZnv16EVZ4XR0y7MP+s67mr0eaiNs7JA
        15jYXGg3iryBlntjLmjFAj/6B9QbjFUdqjo+1vMV8DbFTJxqhHI41kBLA1Lh/V/CeaogZc
        sBlFLTQrfJPHiP/HR1dGKdGQ3vKXutBlgMSeJxZO2MWlAL8ne9+Ygc4mVAEljHG4HO3U0r
        ILlhRxC2g7laJcc3tanjyi7UY+w7CdpNhCXh5U63VcBYOcI32Ng7ngJP8I+a4s3HPn7KRf
        Vxc295h7ARJq5ihDd0zzRNukObcawpB/6BWXXXcOJ8hlIF7ALM3d2qRyDhf9yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636398178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QZkjr/TQ3VhqI2p+z3DXRWGKsyAoXJxMeWe2GkHkt/Y=;
        b=HTYnsyPjOBB6+QpPC3Ir8em4qOM4LC20n2ZCR5zs0Y+WBvCGFbgJud/gS0Xti81F+/QPW0
        D7GSa+y/IpnEGmAw==
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Bastian Germann <bage@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't
 discard phy_start_aneg's return
Message-ID: <20211108200257.78864d69@mitra>
In-Reply-To: <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
References: <20211105153648.8337-1-bage@linutronix.de>
        <20211108141834.19105-1-bage@linutronix.de>
        <YYkzbE39ERAxzg4k@shell.armlinux.org.uk>
        <20211108160653.3d6127df@mitra>
        <YYlLvhE6/wjv8g3z@lunn.ch>
        <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
        <YYlk8Rv85h0Ia/LT@lunn.ch>
        <e07b6b7c-3353-461e-887d-96be9a9f6f36@gmail.com>
Organization: Linutronix GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 19:01:23 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> If we would like to support PHY's that don't support all MDI modes
> then supposedly this would require to add ETHTOOL_LINK_MODE bits for
> the MDI modes. Then we could use the generic mechanism to check the
> bits in the "supported" bitmap.

The things are even worse:
The chip supports only auto-MDIX at Gigabit and force MDI and
auto-MDIX in 10/100 modes. No force MDIX at all.

A validation callback from phy_ethtool_ksettings_set() before
restarting the PHY seems reasonable for me. Something like:

	/* Verify the settings we care about. */
	if (autoneg != AUTONEG_ENABLE && autoneg != AUTONEG_DISABLE)
	        return -EINVAL;

        if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
	        return -EINVAL;

        if (autoneg == AUTONEG_DISABLE &&
	    ((speed != SPEED_1000 &&
	      speed != SPEED_100 &&
              speed != SPEED_10) ||
             (duplex != DUPLEX_HALF &&
              duplex != DUPLEX_FULL)))
                return -EINVAL;

	if (phydev->validate_cmd && phydev->validate_cmd(cmd))
		return -EINVAL;

Thanks
    Benedikt Spranger
