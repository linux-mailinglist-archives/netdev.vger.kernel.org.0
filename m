Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0204E51B5F9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbiEECe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbiEECe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD1A2DA9F;
        Wed,  4 May 2022 19:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03195615C2;
        Thu,  5 May 2022 02:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07087C385A4;
        Thu,  5 May 2022 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651717849;
        bh=RkDhcgrzYae7GmKeIL3pDbwgzqwIh9Ckm5gs6D/gdC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pouF2F4dNdWdKDOnHU3L2517bVFfOcb6TYpC5jtBTgbGpyMSw3Jyk3He3hU9KlG3w
         Up4AvnNvaqmsHozVeC83iiwYDP7ctQ9VYzGJNIGyFuMQk0FViVh1hraFrXZ5VJM6nM
         htlS/VCq3RLIUc4HXOnwEx7GO5D4mrRxfE4AVbdtAgnNj1SjilOyVSwOU6EixmbLVb
         yy+k1izGp64NKjnsOgk1RIbSgtVsvN0n7zF4nRTBXYFS5HiPDO02zxHoVF3A7viJr9
         jTTuMw99VZegegwRIjZyQ+Ia7GD5jlRuWHmyHAP0N7AHpMV0+z/A5xPBbF76IaoeDG
         vu0ODDt3LDamw==
Date:   Wed, 4 May 2022 19:30:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Jacky Chou <jackychou@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: ax88179_178a: Bind only to vendor-specific
 interface
Message-ID: <20220504193047.1e4b97b7@kernel.org>
In-Reply-To: <20220502110644.167179-1-marcan@marcan.st>
References: <20220502110644.167179-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 May 2022 20:06:44 +0900 Hector Martin wrote:
> The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
> chipset, but exposes CDC Ethernet configurations as well as the
> vendor specific one. 

And we have reasons to believe all dongle vendors may have a similar
problem?

> This driver ends up binding first to both CDC
> interfaces, tries to instantiate two Ethernet interfaces talking to
> the same device, and the result is a nice fireworks show.
> 
> Change all the ID matches to specifically match the vendor-specific
> interface. By default the device comes up in CDC mode and is bound by
> that driver (which works fine); users may switch it to the vendor
> interface using sysfs to set bConfigurationValue, at which point the
> device actually goes through a reconnect cycle and comes back as a
> vendor specific only device, and then this driver binds and works too.
> 
> v2: Fixed interface protocol match, commit message.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/net/usb/ax88179_178a.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index e2fa56b92685..7c7c2f31d9f1 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -1914,55 +1914,55 @@ static const struct driver_info at_umc2000sp_info = {
>  static const struct usb_device_id products[] = {
>  {
>  	/* ASIX AX88179 10/100/1000 */
> -	USB_DEVICE(0x0b95, 0x1790),
> +	USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x1790, 0xff, 0xff, 0),
>  	.driver_info = (unsigned long)&ax88179_info,
>  }, 

Should we use USB_CLASS_VENDOR_SPEC and USB_SUBCLASS_VENDOR_SPEC ?
Maybe define a local macro wrapper for USB_DEVICE_AND.. which will
fill those in to avoid long lines?
