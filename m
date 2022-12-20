Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3F6520EE
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbiLTMrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLTMrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:47:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33091192AF
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671540313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UNjEclpm+e/XTNsRG0cyZjq9glUF7fC/NlLJ+OGTKE=;
        b=G2ZKHDdCoLxAqkwLBYuQ3oagZyD9SMdhehve1kjnK1eXgvq5XliOt2k0rxyuFvrk02JCLj
        TufxBAIqrv8aww+vC589grlJHl7XBb69GkFiM1Ve9C6P7eiljxP17I5ZDGWWSRbtVX3i2/
        vDbsA00gHluTkH88KH/myPm4KG9OzYw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-178-HOmEEXA3ObuB5fd9s1_BZw-1; Tue, 20 Dec 2022 07:45:12 -0500
X-MC-Unique: HOmEEXA3ObuB5fd9s1_BZw-1
Received: by mail-qk1-f199.google.com with SMTP id br6-20020a05620a460600b007021e1a5c48so9257550qkb.6
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:45:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3UNjEclpm+e/XTNsRG0cyZjq9glUF7fC/NlLJ+OGTKE=;
        b=SczU62MNNvSpWap8CguNk6pSK27ZL8SG/NnVxSodcGwUDMrwc6oQloRl+VUH8peDwk
         /ufxMYtxoBzDNhpNNpm1p51NViUice/D1SPz/XZCG/392MmMH2TtsJJz8ukc0Pasl5+c
         OzoXcCZl2TDmgT5igEA9FNYoGHq49gudMCdYdumXfaOGcSoAbE2JSt1dE2rAqFIMm6qN
         iy3eKeFNfybqgCkXjN7n9QlXpk0P171YkJKBx7BtOqObkbKbYJYud9Dulhf7Nhk37Nqx
         O9rG7OxZXTQXOaUMI2PPQGQ/eV2/llkwsc10xEvbSGo3DsA428yS0gSf2ojGHXPm7Gm8
         HI0w==
X-Gm-Message-State: AFqh2kqIzMxUxDvBfBo5m/yccZDXE20yKa/eFxfnhCFVG6vJzKSNp+nN
        byr52gXOhpjDqBLnLrE871W1Fp98fNyV+qgjxf3xhT/+zOJfmGSN3yYfND2d+3X752jpZRCxxZg
        7s+hM0EHfDzupR8lo
X-Received: by 2002:ac8:7082:0:b0:3a8:1593:f15b with SMTP id y2-20020ac87082000000b003a81593f15bmr3123440qto.50.1671540311727;
        Tue, 20 Dec 2022 04:45:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt0kdNBcIX8/dEgzoydDa0U7HPLbVzCtyoNwoQc0ZMK2RI5/tvg6dfxyF2MSVVDiE1f6SilOw==
X-Received: by 2002:ac8:7082:0:b0:3a8:1593:f15b with SMTP id y2-20020ac87082000000b003a81593f15bmr3123418qto.50.1671540311455;
        Tue, 20 Dec 2022 04:45:11 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id i12-20020ac813cc000000b003ab1ee36ee7sm826884qtj.51.2022.12.20.04.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 04:45:11 -0800 (PST)
Message-ID: <d382c89ca5dc8675ed88efeae62f4adc0e72d6c0.camel@redhat.com>
Subject: Re: [PATCH v2] net: lan78xx: prevent LAN88XX specific operations
From:   Paolo Abeni <pabeni@redhat.com>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com
Date:   Tue, 20 Dec 2022 13:45:08 +0100
In-Reply-To: <20221220113733.714233-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
         <20221220113733.714233-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 12:37 +0100, Enguerrand de Ribaucourt wrote:
> Some operations during the cable switch workaround modify the register
> LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> that register (0x19), corresponds to the LED and MAC address
> configuration, resulting in unapropriate behavior.
> 
> Use the generic phy interrupt functions instead.
> 
> Fixes: 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>;
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> ---
>  drivers/net/usb/lan78xx.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index f18ab8e220db..65d5d54994ff 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -28,6 +28,7 @@
>  #include <linux/phy_fixed.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
> +#include <linux/phy.h>
>  #include "lan78xx.h"
>  
>  #define DRIVER_AUTHOR	"WOOJUNG HUH <woojung.huh@microchip.com>"
> @@ -2123,10 +2124,7 @@ static void lan78xx_link_status_change(struct net_device *net)
>  	 * at forced 100 F/H mode.
>  	 */
>  	if (!phydev->autoneg && (phydev->speed == 100)) {
> -		/* disable phy interrupt */
> -		temp = phy_read(phydev, LAN88XX_INT_MASK);
> -		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
> -		phy_write(phydev, LAN88XX_INT_MASK, temp);
> +		phy_disable_interrupts(phydev);
>  
>  		temp = phy_read(phydev, MII_BMCR);
>  		temp &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
> @@ -2134,13 +2132,7 @@ static void lan78xx_link_status_change(struct net_device *net)
>  		temp |= BMCR_SPEED100;
>  		phy_write(phydev, MII_BMCR, temp); /* set to 100 later */
>  
> -		/* clear pending interrupt generated while workaround */
> -		temp = phy_read(phydev, LAN88XX_INT_STS);
> -
> -		/* enable phy interrupt back */
> -		temp = phy_read(phydev, LAN88XX_INT_MASK);
> -		temp |= LAN88XX_INT_MASK_MDINTPIN_EN_;
> -		phy_write(phydev, LAN88XX_INT_MASK, temp);
> +		phy_request_interrupt(phydev);
>  	}
>  }
> 

Oops, this does not even build... please take your time testing the
code before sending patches to the ML.

Paolo

