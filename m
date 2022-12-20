Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7336B6520E8
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiLTMpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiLTMpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:45:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FFD12634
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671540074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2q8SwI06rG85fDetmmuxQo59eHILI8/YdzNmZm6nI1I=;
        b=H5dS/Xv3B+GnaYZQ4PnfhD1n6AOW5mFl3JdLcrSuQC0ByNxpqTG7NGTJKwqHOPN7pc+gHb
        deehekWFOBDYwUOamPBAXB6SHSU4V/6o1YtFH7+eq8C+Mddl9REMutoKMypy1OyfhlYpdv
        sDHcQsrV20LKWr2Z/ES8POyRHD4ElaA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-J6Atji9RPy21B9VYzmG6Lg-1; Tue, 20 Dec 2022 07:41:13 -0500
X-MC-Unique: J6Atji9RPy21B9VYzmG6Lg-1
Received: by mail-qk1-f199.google.com with SMTP id bk24-20020a05620a1a1800b006ffcdd05756so9362892qkb.22
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2q8SwI06rG85fDetmmuxQo59eHILI8/YdzNmZm6nI1I=;
        b=v3tmrjVV+3uQuCRDL2TKqCjATZ0PIjxf/sGbzW71gm431FtRG5Tyn2Y1fF2ZdCeIxy
         QKw00uMmOW+iiWOj8bBMBtIHH3yQOsEGq7p4KcvPa5nXVBxUbJzfcg2NJtzCy3obxwzJ
         /uQ/WeGVTamFV3przVKL/fACqkVNZ4KBBbvKHFEKLCYZYoA3iWZlLE4WAiYUG2TOu+9c
         pvS6bCKUXmsvyReXUGanR3yMAJPvr2/a3aDLn5V45qv/DfZ6PF9I3ms/MuosCf+KGBcG
         9QJCIBLG+nyCbY1EIzaE+pyOyHPrXagErERTJDxbYwfrmXOw0wo8ziy/MR7jlhMXa6YC
         Clow==
X-Gm-Message-State: ANoB5plCnHV6Kzqph9FVtMlqXUzANO14xf+c0VniTn/cMeYl9EaScYWq
        8TbtfEWz3Df2Nmc8tBItG/IlDDVPNa9w+DfxzjumnlwL6Vqtl/i8pn+fxFs94EtEUcO8MYOFu8I
        Ob6vJ6f+TsBkD9Zdh
X-Received: by 2002:a05:622a:514d:b0:39c:da21:6c06 with SMTP id ew13-20020a05622a514d00b0039cda216c06mr63252015qtb.8.1671540072740;
        Tue, 20 Dec 2022 04:41:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7MUsDvnrgvQ7EDcDaMYiLJIyNquPtq5d9fqUADnnh2YK/ADyek24vnSfWPqL13Q0HFBihl/w==
X-Received: by 2002:a05:622a:514d:b0:39c:da21:6c06 with SMTP id ew13-20020a05622a514d00b0039cda216c06mr63251997qtb.8.1671540072461;
        Tue, 20 Dec 2022 04:41:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id x18-20020a05620a259200b006fc2b672950sm8792696qko.37.2022.12.20.04.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 04:41:11 -0800 (PST)
Message-ID: <1061700ecedf92911d474a675bd3c47354ab600a.camel@redhat.com>
Subject: Re: [PATCH v2] net: lan78xx: prevent LAN88XX specific operations
From:   Paolo Abeni <pabeni@redhat.com>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com
Date:   Tue, 20 Dec 2022 13:41:08 +0100
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

You should not attach this tag (or acked-by) on your own. 

The following is not even the code I was _asking_ about...

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

This looks wrong. Should probably be:

	phy_enable_interrupts(phydev);


Paolo

