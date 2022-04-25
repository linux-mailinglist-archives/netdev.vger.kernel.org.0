Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9221950E9F6
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 22:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245145AbiDYURZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbiDYURX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:17:23 -0400
X-Greylist: delayed 514 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Apr 2022 13:14:17 PDT
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050:0:465::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CBD1240E0;
        Mon, 25 Apr 2022 13:14:16 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4KnGGV3KQxz9sQq;
        Mon, 25 Apr 2022 22:05:38 +0200 (CEST)
Message-ID: <6c52dc89-015a-9c51-9568-778ccb8c2dd9@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1650917136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38IMGApEWMDQRzOu9Up92LzBejF2/6NEUKrWMdbx4cI=;
        b=EQNXJJULaE/lP/xYon/esS8BNihN8LpOs2J1cknYX2/AEY5M4BSrpqhcaXWtoEzj+KZQBf
        Gf/ViTcF+7fnvHnKnIPc/kf5hO7JwwR60PNyzyE4tFppH4mSX4m/dJl9x/vZfE49OAnHG6
        IOL4aMPW4gOdM54duSST9DhK/n7JvxsvcA7LcVdhPze2bxKvFhw6lVlqlwTnDDwcl0ho/h
        pKnkgc+uiaRKKKSY5Pl05lKZekQGRNf4Rcy12iHO9y5OqExeOdK+vBWHb+R21THynA8xGV
        SROjM86sw94+neuYkknMylIz7+XGD/NMAL8qalPe38ipPW+pJFNfduUyzfxf8g==
Date:   Mon, 25 Apr 2022 22:05:32 +0200
MIME-Version: 1.0
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: Don't set
 GSWIP_MII_CFG_RMII_CLK
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
        Jan Hoffmann <jan@3e8.eu>
References: <20220425152027.2220750-1-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <20220425152027.2220750-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 17:20, Martin Blumenstingl wrote:
> Commit 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining
> GSWIP_MII_CFG bits") added all known bits in the GSWIP_MII_CFGp
> register. It helped bring this register into a well-defined state so the
> driver has to rely less on the bootloader to do things right.
> Unfortunately it also sets the GSWIP_MII_CFG_RMII_CLK bit without any
> possibility to configure it. Upon further testing it turns out that all
> boards which are supported by the GSWIP driver in OpenWrt which use an
> RMII PHY have a dedicated oscillator on the board which provides the
> 50MHz RMII reference clock.
> 
> Don't set the GSWIP_MII_CFG_RMII_CLK bit (but keep the code which always
> clears it) to fix support for the Fritz!Box 7362 SL in OpenWrt. This is
> a board with two Atheros AR8030 RMII PHYs. With the "RMII clock" bit set
> the MAC also generates the RMII reference clock whose signal then
> conflicts with the signal from the oscillator on the board. This results
> in a constant cycle of the PHY detecting link up/down (and as a result
> of that: the two ports using the AR8030 PHYs are not working).
> 
> At the time of writing this patch there's no known board where the MAC
> (GSWIP) has to generate the RMII reference clock. If needed this can be
> implemented in future by providing a device-tree flag so the
> GSWIP_MII_CFG_RMII_CLK bit can be toggled per port.
> 
> Fixes: 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits")
> Cc: stable@vger.kernel.org
> Tested-by: Jan Hoffmann <jan@3e8.eu>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

Looks like Linux does not have a standard device tree flag to indicate 
that MAC should provide the RMII clock. Deactivating it is probably a 
good solution.

> ---
>   drivers/net/dsa/lantiq_gswip.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index a416240d001b..12c15da55664 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1681,9 +1681,6 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
>   		break;
>   	case PHY_INTERFACE_MODE_RMII:
>   		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
> -
> -		/* Configure the RMII clock as output: */
> -		miicfg |= GSWIP_MII_CFG_RMII_CLK;
>   		break;
>   	case PHY_INTERFACE_MODE_RGMII:
>   	case PHY_INTERFACE_MODE_RGMII_ID:

