Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7791B651DB3
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiLTJmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiLTJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:41:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AB1B81
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671529246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PG7o67LSsdfk2zHmNLZEI4WfoVMWdNxQFSFno9lPa60=;
        b=I2l7si4URz8eoU/bsbn2UAzvQ73z31fpo2elW8y+VILUFakn+Lg3ncL/Wb0ga2JkmtEDgA
        NduJz/tstmcO5zo0TS0ah1oPnehbO8BrWCHH67XNGQK1KFwiy500sX+9Xh5Y0ef6//tGO/
        SaKLaV+YOV4zT3fkPO04lb+UtBiNb4c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-459-5JVDokBWPMKzO7LLrKDuiA-1; Tue, 20 Dec 2022 04:40:45 -0500
X-MC-Unique: 5JVDokBWPMKzO7LLrKDuiA-1
Received: by mail-qv1-f71.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso6895109qvb.21
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 01:40:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PG7o67LSsdfk2zHmNLZEI4WfoVMWdNxQFSFno9lPa60=;
        b=KbrCP4+WbQO0du9Fvusdg06xu7H26FrfOff8CLXLWZ6kRQqKQSrn2UgGpX2IwQRE/u
         +pnvz51QU6CSWRz0DdJoWdj6qRAu2//ciuJaOWs7cGjNFjTIbdwZlIYtIORHFsYMdoEC
         G52zXTQfGf+5DMFSdE+DKFdYP6MlcByWE2uslZVo8uXg2VY/7+8CkdCLQUvcq78lNngU
         0+dnuDG+frCwwCwk6ijJrmdaRpZU6/WCkfeLLuMYJNeuy7j5DfRJfxf/WpasLHiJgkLv
         9SMq1uGEUvzwv0/u6iH1b2HeMkil85cqvd+b0rH/TNG2H+pn0RZN+p/MXDRV6FmJPxKp
         YNYw==
X-Gm-Message-State: ANoB5plUECYY7GO+0igjsOhANkzohEXBAbB7mxGB9XmiGmLp6jqFfLBK
        IVZQyuo0n+xtqI67Q+4+nocThUv5vDUfsIsJVyR5hJNKtJHwl1xm4lysf/Q+CKzrws8LUX7lrYU
        2+dj1wyzVsfBJMMBh
X-Received: by 2002:ac8:7c8:0:b0:3a7:ee95:cc37 with SMTP id m8-20020ac807c8000000b003a7ee95cc37mr60329818qth.14.1671529244638;
        Tue, 20 Dec 2022 01:40:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5AwITqteKoZoHdD2Xl2rkS77Udp6g0ZhU+nVF/2NwgUUm0pzHK9+iOImktZKvQ0mDO4kxI2A==
X-Received: by 2002:ac8:7c8:0:b0:3a7:ee95:cc37 with SMTP id m8-20020ac807c8000000b003a7ee95cc37mr60329797qth.14.1671529244283;
        Tue, 20 Dec 2022 01:40:44 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id h26-20020ac8745a000000b00399fe4aac3esm7407866qtr.50.2022.12.20.01.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:40:43 -0800 (PST)
Message-ID: <8b5f3a9b1ed8d31a84129dc284a95091aebb25fd.camel@redhat.com>
Subject: Re: [PATCH] net: lan78xx: isolate LAN88XX specific operations
From:   Paolo Abeni <pabeni@redhat.com>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com
Date:   Tue, 20 Dec 2022 10:40:40 +0100
In-Reply-To: <20221216144910.1416322-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
         <20221216144910.1416322-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

On Fri, 2022-12-16 at 15:49 +0100, Enguerrand de Ribaucourt wrote:
> Some operations during the cable switch workaround modify the register
> LAN88XX_INT_MASK of the PHY. However, this register is specific to the
> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the LAN7801,
> that register (0x19), corresponds to the LED and MAC address
> configuration, resulting in unapropriate behavior.
> 
> Fixes: 14437e3fa284 ("lan78xx: workaround of forced 100 Full/Half duplex mode error")

AFACS LAN7801 support was introduced after the above commit, so I guess
 89b36fb5e532 ("lan78xx: Lan7801 Support for Fixed PHY")
should be a better fixes tag.

> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> ---
>  drivers/net/usb/lan78xx.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index f18ab8e220db..ea0a56e6cd40 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -2116,6 +2116,7 @@ static void lan78xx_link_status_change(struct net_device *net)
>  {
>  	struct phy_device *phydev = net->phydev;
>  	int temp;
> +	bool lan88_fixup;
>  
>  	/* At forced 100 F/H mode, chip may fail to set mode correctly
>  	 * when cable is switched between long(~50+m) and short one.
> @@ -2123,10 +2124,15 @@ static void lan78xx_link_status_change(struct net_device *net)
>  	 * at forced 100 F/H mode.
>  	 */
>  	if (!phydev->autoneg && (phydev->speed == 100)) {
> -		/* disable phy interrupt */
> -		temp = phy_read(phydev, LAN88XX_INT_MASK);
> -		temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
> -		phy_write(phydev, LAN88XX_INT_MASK, temp);
> +		lan88_fixup = (PHY_LAN8835 & 0xfffffff0) ==
> +			(phydev->phy_id & 0xfffffff0);
> +
> +		if(lan88_fixup) {
> +			/* disable phy interrupt */
> +			temp = phy_read(phydev, LAN88XX_INT_MASK);
> +			temp &= ~LAN88XX_INT_MASK_MDINTPIN_EN_;
> +			phy_write(phydev, LAN88XX_INT_MASK, temp);
> +		}

Why don't you use instead something alike:

		phy_config_interrupt(phydev, 0);

		//force 10 and 100 speed

		phy_config_interrupt(phydev, 1);

so that you properly keep interrupt disabled regardless of the chip
version?

Thanks!

Paolo

