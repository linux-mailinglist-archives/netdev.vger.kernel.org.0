Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD65E325604
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhBYTDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233025AbhBYTDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 14:03:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4FD64EFA;
        Thu, 25 Feb 2021 19:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614279789;
        bh=mqRATAtny9DcsR1CdJJNpoJ/uwWCFDvyI0SopqofvyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=u4hT3ugYzLnd8M6gdo71afj/JH5CaQWhiNmm5uCGyfAy4thc+ErElqhOp3EiRy8cx
         aIcWAssFjmTdfbxJYzge/PDYrBzU4y8t61MqK3I8SOdenhjQAwv27RulAVpVgX5HNs
         GBHCw7R1SfKIrX+sXy8ZPy4Q6C4EzVu4VbQBaDt77Ssj1OhGe4dM1UP13vuyGptd/y
         cjRhJmirUsk1wwnGAXWkbcFSD5HOAwH0Ag3ztMYcYfyXoIHvoyzY4lv/aDw/TPLokm
         ZtvSyJZ/IvTBrIe73xbwHQBM5awHnkoDRhGsOaJwHw1/h+25bt7fvN9rek2rUAOQtJ
         wVmFQYA3KQdhQ==
Received: by pali.im (Postfix)
        id DC322760; Thu, 25 Feb 2021 20:03:06 +0100 (CET)
Date:   Thu, 25 Feb 2021 20:03:06 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 16/67] net: sfp: add mode quirk for GPON
 module Ubiquiti U-Fiber Instant
Message-ID: <20210225190306.65jnl557vvs6d7o3@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210224125026.481804-16-sashal@kernel.org>
 <20210224125212.482485-12-sashal@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 24 February 2021 07:49:34 Sasha Levin wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> [ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]

Hello! This commit requires also commit~1 from that patch series:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=426c6cbc409cbda9ab1a9dbf15d3c2ef947eb8c1

Without it kernel cannot read EEPROM from Ubiquiti U-Fiber Instant
module and therefore the hook based on EEPROM data which is below would
not be applied.

> The Ubiquiti U-Fiber Instant SFP GPON module has nonsensical information
> stored in its EEPROM. It claims to support all transceiver types including
> 10G Ethernet. Clear all claimed modes and set only 1000baseX_Full, which is
> the only one supported.
> 
> This module has also phys_id set to SFF, and the SFP subsystem currently
> does not allow to use SFP modules detected as SFFs. Add exception for this
> module so it can be detected as supported.
> 
> This change finally allows to detect and use SFP GPON module Ubiquiti
> U-Fiber Instant on Linux system.
> 
> EEPROM content of this SFP module is (where XX is serial number):
> 
> 00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
> 10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
> 20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
> 30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
> 40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
> 50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/phy/sfp-bus.c | 15 +++++++++++++++
>  drivers/net/phy/sfp.c     | 17 +++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index 20b91f5dfc6ed..4cf874fb5c5b4 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -44,6 +44,17 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
>  	phylink_set(modes, 2500baseX_Full);
>  }
>  
> +static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
> +				      unsigned long *modes)
> +{
> +	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
> +	 * types including 10G Ethernet which is not truth. So clear all claimed
> +	 * modes and set only one mode which module supports: 1000baseX_Full.
> +	 */
> +	phylink_zero(modes);
> +	phylink_set(modes, 1000baseX_Full);
> +}
> +
>  static const struct sfp_quirk sfp_quirks[] = {
>  	{
>  		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> @@ -63,6 +74,10 @@ static const struct sfp_quirk sfp_quirks[] = {
>  		.vendor = "HUAWEI",
>  		.part = "MA5671A",
>  		.modes = sfp_quirk_2500basex,
> +	}, {
> +		.vendor = "UBNT",
> +		.part = "UF-INSTANT",
> +		.modes = sfp_quirk_ubnt_uf_instant,
>  	},
>  };
>  
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 91d74c1a920ab..804295ad8a044 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -273,8 +273,21 @@ static const struct sff_data sff_data = {
>  
>  static bool sfp_module_supported(const struct sfp_eeprom_id *id)
>  {
> -	return id->base.phys_id == SFF8024_ID_SFP &&
> -	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
> +	if (id->base.phys_id == SFF8024_ID_SFP &&
> +	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP)
> +		return true;
> +
> +	/* SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored
> +	 * phys id SFF instead of SFP. Therefore mark this module explicitly
> +	 * as supported based on vendor name and pn match.
> +	 */
> +	if (id->base.phys_id == SFF8024_ID_SFF_8472 &&
> +	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP &&
> +	    !memcmp(id->base.vendor_name, "UBNT            ", 16) &&
> +	    !memcmp(id->base.vendor_pn, "UF-INSTANT      ", 16))
> +		return true;
> +
> +	return false;
>  }
>  
>  static const struct sff_data sfp_data = {
> -- 
> 2.27.0
> 

On Wednesday 24 February 2021 07:51:28 Sasha Levin wrote:
> From: Pali Rohár <pali@kernel.org>
> 
> [ Upstream commit f0b4f847673299577c29b71d3f3acd3c313d81b7 ]
> 
> The Ubiquiti U-Fiber Instant SFP GPON module has nonsensical information
> stored in its EEPROM. It claims to support all transceiver types including
> 10G Ethernet. Clear all claimed modes and set only 1000baseX_Full, which is
> the only one supported.
> 
> This module has also phys_id set to SFF, and the SFP subsystem currently
> does not allow to use SFP modules detected as SFFs. Add exception for this
> module so it can be detected as supported.
> 
> This change finally allows to detect and use SFP GPON module Ubiquiti
> U-Fiber Instant on Linux system.
> 
> EEPROM content of this SFP module is (where XX is serial number):
> 
> 00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
> 10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
> 20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
> 30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
> 40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
> 50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/phy/sfp-bus.c | 15 +++++++++++++++
>  drivers/net/phy/sfp.c     | 17 +++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index 58014feedf6c8..fb954e8141802 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -44,6 +44,17 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
>  	phylink_set(modes, 2500baseX_Full);
>  }
>  
> +static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
> +				      unsigned long *modes)
> +{
> +	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
> +	 * types including 10G Ethernet which is not truth. So clear all claimed
> +	 * modes and set only one mode which module supports: 1000baseX_Full.
> +	 */
> +	phylink_zero(modes);
> +	phylink_set(modes, 1000baseX_Full);
> +}
> +
>  static const struct sfp_quirk sfp_quirks[] = {
>  	{
>  		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> @@ -63,6 +74,10 @@ static const struct sfp_quirk sfp_quirks[] = {
>  		.vendor = "HUAWEI",
>  		.part = "MA5671A",
>  		.modes = sfp_quirk_2500basex,
> +	}, {
> +		.vendor = "UBNT",
> +		.part = "UF-INSTANT",
> +		.modes = sfp_quirk_ubnt_uf_instant,
>  	},
>  };
>  
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 34aa196b7465c..d8a809cf20c15 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -272,8 +272,21 @@ static const struct sff_data sff_data = {
>  
>  static bool sfp_module_supported(const struct sfp_eeprom_id *id)
>  {
> -	return id->base.phys_id == SFF8024_ID_SFP &&
> -	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
> +	if (id->base.phys_id == SFF8024_ID_SFP &&
> +	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP)
> +		return true;
> +
> +	/* SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored
> +	 * phys id SFF instead of SFP. Therefore mark this module explicitly
> +	 * as supported based on vendor name and pn match.
> +	 */
> +	if (id->base.phys_id == SFF8024_ID_SFF_8472 &&
> +	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP &&
> +	    !memcmp(id->base.vendor_name, "UBNT            ", 16) &&
> +	    !memcmp(id->base.vendor_pn, "UF-INSTANT      ", 16))
> +		return true;
> +
> +	return false;
>  }
>  
>  static const struct sff_data sfp_data = {
> -- 
> 2.27.0
> 

