Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291D611E300
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 12:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfLMLtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 06:49:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46042 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLMLtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 06:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+baNYEODg9N7fmpBCmg4L19Cw3Cp19VXPw1KpglWdxE=; b=YZdMEWoFu4y+YB6ezhX2tghmT
        Z5nBmjX/JpeqmxrXzE8xbPccrd8uNqlIxwinSMuq+L91SvAhNUbTUSrgXRwBjO1nukp1Mibb9MRQ8
        CJxwdFrvqbaqBCkNojCw7eW23SGC/dP1OYSTVBlxtOBp7ex7HZZHJGv0C0Rr0CcjOtC74PS/wo7e5
        tjTVq4jQYjsF7Zl39h7I5Ex67fH6IdjF6MZLV922JxA3af6NphjJrO1XwjmNPsu5kwkHM6mOqjlCY
        JiVixqfiCecnizVIpclq/13kb7eHB5/IvsRm6sfs/ecAHuqVAVR2D9+ZJkWuCmuuK1m/YST45V/+N
        KrcH8CU9Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:48280)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ifjRw-0004ay-Hz
        for netdev@vger.kernel.org; Fri, 13 Dec 2019 11:49:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ifjRv-0007rb-QW
        for netdev@vger.kernel.org; Fri, 13 Dec 2019 11:49:35 +0000
Date:   Fri, 13 Dec 2019 11:49:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Subject: ethtool pause mode clarifications
Message-ID: <20191213114935.GR25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Please can someone explain the ethtool pause mode settings?  The man
page isn't particularly clear, it says:

       -A --pause
              Changes the pause parameters of the specified Ethernet device.

           autoneg on|off
                  Specifies whether pause autonegotiation should be enabled.

           rx on|off
                  Specifies whether RX pause should be enabled.

           tx on|off
                  Specifies whether TX pause should be enabled.


"autoneg" states whether pause autonegotiation should be enabled, but
how is this possible, when pause autonegotiation happens as part of the
rest of the autonegotiation as a matter of course, and the only control
we have at the PHY is the value of the pause and asym pause bits?

The alternative interpretation is that "autoneg" controls whether the
local end interprets the result of the pause negotiation or not.  In
other words, if:

	autoneg off rx on tx on

that causes pause modes to still be advertised to the partner, but the
results of pause negotiation to be overridden by forcing enablement of
pause reception and transmission.


Then there's the whole issue of translating something like:

	autoneg on rx on tx off

to the pause mode advertisement.  phylib translates this to a local
advertisement of pause=1 asym pause=1.  Looking at the table in 802.3,

Local device  Link partner
Pause AsymDir Pause AsymDir Result
  1     1       1     X     TX + RX - but ethtool wanted RX only
  1     1       0     1     This would give RX only

however, ethtool has no control over the link partner's advertisement,
so despite requesting "autoneg on rx on tx off" this may be no
different from "autoneg on rx on tx on".

However, there's another way to handle that - which is to treat autoneg
as a mask for the autonegotiation result:

	if (!ethtool_pause_autoneg || (local_adv & partner_adv & PAUSE)) {
		tx_pause = 1;
		rx_pause = 1;
	} else if (local_adv & partner_adv & ASYM_PAUSE) {
		tx_pause = partner_adv & PAUSE;
		rx_pause = local_adv & PAUSE;
	} else {
		tx_pause = 0;
		rx_pause = 0;
	}

	tx_pause &= ethtool_pause_tx;
	rx_pause &= ethtool_pause_rx;

In other words, treating the ethtool rx/tx pause parameters as
permissive bits for the result of negotiation or force bits when
pause autoneg is disabled.

Then comes the pause advertisement.  phylib uses this:

	pause_advertisement = rx;
	asym_pause_advertisement = rx ^ tx;

So, if we were to request rx=1 tx=1, we end up advertising pause but
no asym pause.  That gives us only two possible resolutions to pause
negotiation: TX+RX pause enabled at both ends, or TX+RX pause disabled
at both ends.  There is no resolution that leads to symmetric pause.
If what I suggest above is adopted for pause mode resolution, then a
more correct implementation would be:

	pause_advertisement = rx;
	asym_pause_advertisement = rx | tx;

So, would it be possible to clarify what these settings mean in the
ethtool man page please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
