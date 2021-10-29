Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248AC43F773
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJ2GuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:50:16 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41163 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230252AbhJ2GuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 02:50:15 -0400
Received: from [192.168.0.2] (ip5f5aef83.dynamic.kabel-deutschland.de [95.90.239.131])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8AB2861E64846;
        Fri, 29 Oct 2021 08:47:45 +0200 (CEST)
Message-ID: <89af2e39-fe5c-c285-7805-8c7a6a5a2e51@molgen.mpg.de>
Date:   Fri, 29 Oct 2021 08:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe: set X550 MDIO speed before
 talking to PHY
Content-Language: en-US
To:     Cyril Novikov <cnovikov@lynx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <81be24c4-a7e4-0761-abf4-204f4849b6eb@lynx.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <81be24c4-a7e4-0761-abf4-204f4849b6eb@lynx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Cyril,


On 29.10.21 03:03, Cyril Novikov wrote:
> The MDIO bus speed must be initialized before talking to the PHY the first
> time in order to avoid talking to it using a speed that the PHY doesn't
> support.
> 
> This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
> Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb network
> plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which combined
> with the 10Gb network results in a 24MHz MDIO speed, which is apparently
> too fast for the connected PHY. PHY register reads over MDIO bus return
> garbage, leading to initialization failure.

Maybe add a Fixes tag?

> Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using
> the following setup:
> 
> * Use an Atom C3000 family system with at least one X550 LAN on the SoC
> * Disable PXE or other BIOS network initialization if possible
>    (the interface must not be initialized before Linux boots)
> * Connect a live 10Gb Ethernet cable to an X550 port
> * Power cycle (not reset, doesn't always work) the system and boot Linux
> * Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -17

Why not add that to the commit message?

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> index 9724ffb16518..e4b50c7781ff 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
> @@ -3405,6 +3405,9 @@ static s32 ixgbe_reset_hw_X550em(struct ixgbe_hw *hw)
>   	/* flush pending Tx transactions */
>   	ixgbe_clear_tx_pending(hw);
>   
> +	/* set MDIO speed before talking to the PHY in case it's the 1st time */
> +	ixgbe_set_mdio_speed(hw);
> +
>   	/* PHY ops must be identified and initialized prior to reset */
>   	status = hw->phy.ops.init(hw);
>   	if (status == IXGBE_ERR_SFP_NOT_SUPPORTED ||
> 

Is `ixgbe_set_mdio_speed(hw)` at the end of the function then still needed?


Kind regards,

Paul
