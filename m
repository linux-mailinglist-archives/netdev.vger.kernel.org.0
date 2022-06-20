Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FEB5518B8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbiFTMV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240896AbiFTMVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:21:24 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB2415A37;
        Mon, 20 Jun 2022 05:21:21 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9345061EA1923;
        Mon, 20 Jun 2022 14:21:18 +0200 (CEST)
Message-ID: <1a554d8e-c479-f646-ce9d-25871affbcee@molgen.mpg.de>
Date:   Mon, 20 Jun 2022 14:21:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 4/4] Bluetooth: hci_bcm: Increase host baudrate for
 CYW55572 in autobaud mode
Content-Language: en-US
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <386b205422099c795272ad8b792091b692def3cd.1655723462.git.hakan.jansson@infineon.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <386b205422099c795272ad8b792091b692def3cd.1655723462.git.hakan.jansson@infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Your To: header field has:

     To:     unlisted-recipients:; (no To-header on input)

which is added to the receiver list when replying to all in Mozilla 
Thunderbird 91.10.0.
]


Dear Hakan,


Am 20.06.22 um 14:01 schrieb Hakan Jansson:
> Add device specific data for max baudrate in autobaud mode. This allows the
> host to use a baudrate higher than "init speed" when loading FW in autobaud
> mode.

Please mention 921600 in the commit message, and maybe also document 
what the current default is.

Please also add the measurement data to the commit message, that means, 
how much is the time to load the firmware decreased.

> 
> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> ---
>   drivers/bluetooth/hci_bcm.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
> index 0ae627c293c5..d7e0b75db8a6 100644
> --- a/drivers/bluetooth/hci_bcm.c
> +++ b/drivers/bluetooth/hci_bcm.c
> @@ -53,10 +53,12 @@
>    * struct bcm_device_data - device specific data
>    * @no_early_set_baudrate: Disallow set baudrate before driver setup()
>    * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
> + * @max_autobaud_speed: max baudrate supported by device in autobaud mode
>    */
>   struct bcm_device_data {
>   	bool	no_early_set_baudrate;
>   	bool	drive_rts_on_open;
> +	u32	max_autobaud_speed;

Why specify the length, and not just `unsigned int`? Maybe also add the 
unit to the variable name?

>   };
>   
>   /**
> @@ -100,6 +102,7 @@ struct bcm_device_data {
>    * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
>    * @pcm_int_params: keep the initial PCM configuration
>    * @use_autobaud_mode: start Bluetooth device in autobaud mode
> + * @max_autobaud_speed: max baudrate supported by device in autobaud mode
>    */
>   struct bcm_device {
>   	/* Must be the first member, hci_serdev.c expects this. */
> @@ -139,6 +142,7 @@ struct bcm_device {
>   	bool			drive_rts_on_open;
>   	bool			use_autobaud_mode;
>   	u8			pcm_int_params[5];
> +	u32			max_autobaud_speed;

Ditto.

>   };
>   
>   /* generic bcm uart resources */
> @@ -479,7 +483,10 @@ static int bcm_open(struct hci_uart *hu)
>   		else if (bcm->dev->drive_rts_on_open)
>   			hci_uart_set_flow_control(hu, true);
>   
> -		hu->init_speed = bcm->dev->init_speed;
> +		if (bcm->dev->use_autobaud_mode && bcm->dev->max_autobaud_speed)
> +			hu->init_speed = min(bcm->dev->oper_speed, bcm->dev->max_autobaud_speed);
> +		else
> +			hu->init_speed = bcm->dev->init_speed;
>   
>   		/* If oper_speed is set, ldisc/serdev will set the baudrate
>   		 * before calling setup()
> @@ -585,8 +592,8 @@ static int bcm_setup(struct hci_uart *hu)
>   		return 0;
>   
>   	/* Init speed if any */
> -	if (hu->init_speed)
> -		speed = hu->init_speed;
> +	if (bcm->dev && bcm->dev->init_speed)
> +		speed = bcm->dev->init_speed;
>   	else if (hu->proto->init_speed)
>   		speed = hu->proto->init_speed;
>   	else
> @@ -1519,6 +1526,7 @@ static int bcm_serdev_probe(struct serdev_device *serdev)
>   
>   	data = device_get_match_data(bcmdev->dev);
>   	if (data) {
> +		bcmdev->max_autobaud_speed = data->max_autobaud_speed;
>   		bcmdev->no_early_set_baudrate = data->no_early_set_baudrate;
>   		bcmdev->drive_rts_on_open = data->drive_rts_on_open;
>   	}
> @@ -1542,6 +1550,10 @@ static struct bcm_device_data bcm43438_device_data = {
>   	.drive_rts_on_open = true,
>   };
>   
> +static struct bcm_device_data cyw55572_device_data = {
> +	.max_autobaud_speed = 921600,
> +};
> +
>   static const struct of_device_id bcm_bluetooth_of_match[] = {
>   	{ .compatible = "brcm,bcm20702a1" },
>   	{ .compatible = "brcm,bcm4329-bt" },
> @@ -1554,7 +1566,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
>   	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
>   	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
>   	{ .compatible = "brcm,bcm4335a0" },
> -	{ .compatible = "infineon,cyw55572-bt" },
> +	{ .compatible = "infineon,cyw55572-bt", .data = &cyw55572_device_data },
>   	{ },
>   };
>   MODULE_DEVICE_TABLE(of, bcm_bluetooth_of_match);


Kind regards,

Paul
