Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA2546D730
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhLHPoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbhLHPoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:44:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4033FC061746;
        Wed,  8 Dec 2021 07:40:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 021D3B82182;
        Wed,  8 Dec 2021 15:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D26BC00446;
        Wed,  8 Dec 2021 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638978048;
        bh=kZAQdmjmzZVeialWjep6DCDmI3SooF1R1NgyjW81QYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLGSC6wpPOxZQ95WCnvoDF8pOiz/MoYKRdZ1RHAUcWmYgPQ/DizuKyiWciaPVvB0J
         PKjgescJUXn6x3uNL/THzMNFFh0szqtz9/GxUKVmqHs6SVvzK73E+mf7vCat/HItl2
         1ftuCGTBINHK0wUuJTLnJ0c5bL8zu4i1RnC6S51nyGEWGYhFSoOaGGkAsDlicjekAB
         +emTpNQIx3MPdwzGV8qwAhNDBflKw1OGi8ggoTwRKRgzjRSBWT0tIIRet10GPOK0vZ
         MhPxpzpDfg6ZPKtwd0cMHFCV+oqhWOkEwa9YGZWnZ9zJ1/OTaVCi1i7eZ+rWuQ1QjR
         SHH4DXQXxTNfg==
Date:   Wed, 8 Dec 2021 16:40:42 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211208164042.6fbcddb1@thinkpad>
In-Reply-To: <20211208140413.96856-1-amhamza.mgc@gmail.com>
References: <20211207140647.6926a3e7@thinkpad>
        <20211208140413.96856-1-amhamza.mgc@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 19:04:13 +0500
Ameer Hamza <amhamza.mgc@gmail.com> wrote:

> mv88e6390_serdes_power() and mv88e6393x_serdes_power() should return
> with EINVAL error if cmode is undefined.
> 
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/serdes.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 33727439724a..f3dc1865f291 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			   bool up)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err = 0;
> +	int err;
>  
>  	switch (cmode) {
>  	case MV88E6XXX_PORT_STS_CMODE_SGMII:
> @@ -842,6 +842,8 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
>  		err = mv88e6390_serdes_power_10g(chip, lane, up);
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	if (!err && up)
> @@ -1507,7 +1509,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			    bool on)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err = 0;
> +	int err;
>  
>  	if (port != 0 && port != 9 && port != 10)
>  		return -EOPNOTSUPP;
> @@ -1541,6 +1543,8 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  	case MV88E6393X_PORT_STS_CMODE_10GBASER:
>  		err = mv88e6390_serdes_power_10g(chip, lane, on);
>  		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
>  	if (err)

please make it err = -EINVAL instead of direct return, so that we can
check in the code after and handle the error case.

Marek
