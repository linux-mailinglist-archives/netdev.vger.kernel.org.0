Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2BB2C2ABC
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbgKXPDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389452AbgKXPDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:03:50 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365AC0613D6;
        Tue, 24 Nov 2020 07:03:49 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 10so2695519wml.2;
        Tue, 24 Nov 2020 07:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=HFdlhJaaYtVAHZoZx+O2cfNnd2v0cgIEGMNjYfyBtsM=;
        b=ZeuxxeGJizVrTQ8/+drC2BXOjRHNr8TNITrPHM54Kju6SErP4aUNRGzd2no43NToYD
         GdUOSa+9BSjoQiP7X9sNWQ1giuNJPUv72hBAZXSCVj4MRdTf0HYgdM+tAR3fMuYvagD9
         aOs6Dsgc8B7gcIHIz3Fenf0FpsxsbUQ4dR0YImjAtUWhpYyJJHznwBpsjgiP7MmQvPtH
         j2bxpkbKc3T6wGJ6ono2W6k/NDP5bzUzFG9wyD4fI0ps2BZ5QDv73Q4CHF3bZz4iUKSy
         Cw58Ivn2TvJpbCBhBu+BUT66wspodlZlJu6QPslG71dFXtiDQ10NrADNfnNilXlL8kQS
         LlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=HFdlhJaaYtVAHZoZx+O2cfNnd2v0cgIEGMNjYfyBtsM=;
        b=tzmJ3Y7sTG9xosC3Hzf2cRBm4/gSE5uoK99S1ss07fuGInruwJwqIrrp8cECX5W0jc
         sJcy/Bc/4WSeJ0jOR6IDRKbTC36xKRihD7lnSArVhkx/GeLIHnuzK+ZjRiYZqsUK1mKB
         tMHfrwpEM3UDBaSe4WNuSNdlm89avwy6ExbGPSUMDXGcAYJr4n54BsLLFZTpUSwnkn/0
         IpJstu+PXbb2n0T5Xpy1IoOSmnSL2B5aMt46YqGTrJZvOCzIEMc/yOBK0vQR4Q4SQRsK
         Vmi8a2+FA4SFZzh9U0pcu5E09sWhqRDxDkCn0yixznp1/zm87svSuVa7oMw90nRYOotW
         eWnw==
X-Gm-Message-State: AOAM531Iy7x9GCtKz1GSUrdv6sSLN+oB/K3n3ehBXG5whtZqrtX52LaK
        C6E4eB5i5GaFE7iHTfuYPIwBB3VD0urx2g==
X-Google-Smtp-Source: ABdhPJww+D+Kpjg5W65A9K3BrPYYERd+hjbvhkiesPVWAgqYd7TEqnJVbB08jzGFXDLnyziJPgEzhQ==
X-Received: by 2002:a1c:3d05:: with SMTP id k5mr5093414wma.151.1606230225625;
        Tue, 24 Nov 2020 07:03:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:4cf3:cdf5:5d2a:5c8c? (p200300ea8f2328004cf3cdf55d2a5c8c.dip0.t-ipconnect.de. [2003:ea:8f23:2800:4cf3:cdf5:5d2a:5c8c])
        by smtp.googlemail.com with ESMTPSA id u5sm5669309wml.13.2020.11.24.07.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 07:03:44 -0800 (PST)
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
To:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yonglong Liu <liuyonglong@huawei.com>
Cc:     stable@vger.kernel.org, linuxarm@huawei.com,
        Salil Mehta <salil.mehta@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20201124143848.874894-1-antonio.borneo@st.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4684304a-37f5-e0cd-91cf-3f86318979c3@gmail.com>
Date:   Tue, 24 Nov 2020 16:03:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201124143848.874894-1-antonio.borneo@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24.11.2020 um 15:38 schrieb Antonio Borneo:
> If the auto-negotiation fails to establish a gigabit link, the phy
> can try to 'down-shift': it resets the bits in MII_CTRL1000 to
> stop advertising 1Gbps and retries the negotiation at 100Mbps.
> 
I see that Russell answered already. My 2cts:

Are you sure all PHY's supporting downshift adjust the
advertisement bits? IIRC an Aquantia PHY I dealt with does not.
And if a PHY does so I'd consider this problematic:
Let's say you have a broken cable and the PHY downshifts to
100Mbps. If you change the cable then the PHY would still negotiate
100Mbps only.

Also I think phydev->advertising reflects what the user wants to
advertise, as mentioned by Russell before.


>>From commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode
> in genphy_read_status") the content of MII_CTRL1000 is not checked
> anymore at the end of the negotiation, preventing the detection of
> phy 'down-shift'.
> In case of 'down-shift' phydev->advertising gets out-of-sync wrt
> MII_CTRL1000 and still includes modes that the phy have already
> dropped. The link partner could still advertise higher speeds,
> while the link is established at one of the common lower speeds.
> The logic 'and' in phy_resolve_aneg_linkmode() between
> phydev->advertising and phydev->lp_advertising will report an
> incorrect mode.
> 
> Issue detected with a local phy rtl8211f connected with a gigabit
> capable router through a two-pairs network cable.
> 
> After auto-negotiation, read back MII_CTRL1000 and mask-out from
> phydev->advertising the modes that have been eventually discarded
> due to the 'down-shift'.
> 
> Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
> Cc: stable@vger.kernel.org # v5.1+
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Link: https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com
> ---
> To: Andrew Lunn <andrew@lunn.ch>
> To: Heiner Kallweit <hkallweit1@gmail.com>
> To: Russell King <linux@armlinux.org.uk>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> To: netdev@vger.kernel.org
> To: Yonglong Liu <liuyonglong@huawei.com>
> Cc: linuxarm@huawei.com
> Cc: Salil Mehta <salil.mehta@huawei.com>
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-kernel@vger.kernel.org
> Cc: Antonio Borneo <antonio.borneo@st.com>
> 
>  drivers/net/phy/phy_device.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 5dab6be6fc38..5d1060aa1b25 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2331,7 +2331,7 @@ EXPORT_SYMBOL(genphy_read_status_fixed);
>   */
>  int genphy_read_status(struct phy_device *phydev)
>  {
> -	int err, old_link = phydev->link;
> +	int adv, err, old_link = phydev->link;
>  
>  	/* Update the link, but return if there was an error */
>  	err = genphy_update_link(phydev);
> @@ -2356,6 +2356,14 @@ int genphy_read_status(struct phy_device *phydev)
>  		return err;
>  
>  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> +		if (phydev->is_gigabit_capable) {
> +			adv = phy_read(phydev, MII_CTRL1000);
> +			if (adv < 0)
> +				return adv;
> +			/* update advertising in case of 'down-shift' */
> +			mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
> +							adv);
> +		}
>  		phy_resolve_aneg_linkmode(phydev);
>  	} else if (phydev->autoneg == AUTONEG_DISABLE) {
>  		err = genphy_read_status_fixed(phydev);
> 
> base-commit: d549699048b4b5c22dd710455bcdb76966e55aa3
> 

