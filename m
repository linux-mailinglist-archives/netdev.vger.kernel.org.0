Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E14A7674
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiBBRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:05:39 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:45022 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346141AbiBBRFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:05:35 -0500
Received: from [IPV6:2003:e9:d731:20df:8d81:5815:ac7:f110] (p200300e9d73120df8d8158150ac7f110.dip0.t-ipconnect.de [IPv6:2003:e9:d731:20df:8d81:5815:ac7:f110])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F2539C0747;
        Wed,  2 Feb 2022 18:05:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643821534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UYiKG5irel85M2hVSs3zwqADE7rrOfUI2dMO3lN/Li0=;
        b=TXhy94b4H/p3MLmzy7A+yPRKlg48MNmI1xrXKjJPU7bnTRf5g0WwXOoTJwAjH9QxZ70Isy
        imaJw6pmdC59GgtbUzt+piZUcz0w6UJjwEAy5lRcCHGsMtAx8PrY5O5Q+hmIed9fY8Wvmp
        c70+cVRowCeQ/c14FzWLU47fGDrtnmDEfD6xeHYgw35augF9RWn6lLIzNgt8+7dape3FtQ
        FzqYgIZqVyGFNYiQ5YcwCSuQoSrjNyxQm28oZeRKQyafvD6x8a6tLTTEQ6dAPUjP0TTHts
        JqTJuwrGBhJHaDyEcqiR0ahJRQllpFq2okURJ6XPDVUXFM4m5Mz6LNI2HA0Mlg==
Message-ID: <f5b23fe2-da5f-aadf-ae26-db6b31b55249@datenfreihafen.org>
Date:   Wed, 2 Feb 2022 18:05:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH wpan-next v3 1/4] net: ieee802154: ca8210: Fix lifs/sifs
 periods
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
 <20220201180629.93410-2-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220201180629.93410-2-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello.

On 01.02.22 19:06, Miquel Raynal wrote:
> These periods are expressed in time units (microseconds) while 40 and 12
> are the number of symbol durations these periods will last. We need to
> multiply them both with the symbol_duration in order to get these
> values in microseconds.
> 
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   drivers/net/ieee802154/ca8210.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index f3438d3e104a..2bc730fd260e 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2975,8 +2975,8 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
>   	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
>   	ca8210_hw->phy->cca_ed_level = -9800;
>   	ca8210_hw->phy->symbol_duration = 16;
> -	ca8210_hw->phy->lifs_period = 40;
> -	ca8210_hw->phy->sifs_period = 12;
> +	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
> +	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
>   	ca8210_hw->flags =
>   		IEEE802154_HW_AFILT |
>   		IEEE802154_HW_OMIT_CKSUM |
> 

As mentioned in the discussion on the other thread I ripped this one out 
and applied it as fix to the wpan tree. Thanks!

regards
Stefan Schmidt
