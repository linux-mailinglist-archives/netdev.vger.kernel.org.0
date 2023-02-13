Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5596C694E06
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjBMRcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBMRcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:32:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526C6A276;
        Mon, 13 Feb 2023 09:32:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E68C5B8163F;
        Mon, 13 Feb 2023 17:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACE3C4339B;
        Mon, 13 Feb 2023 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676309535;
        bh=i+t2JBZ+52dMxItNuyDw9F/YTqCD0RC13zGq4NymM6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7gU2mVBZ7q/gdiyWhdLiNJ/AWYg5UmxnMexcZLtthRyUI9saaYRZT7zP863SV2hO
         KRHa2dJinfpVmBAsYPPyxKdLVezfkPVqkwMg+SMcOa5OFcrMUMZkN/mvSuh+Q7HhUd
         7ddUdP/JXVnUxA60q0YA58Fa881eHcs/5SDJG68c=
Date:   Mon, 13 Feb 2023 16:15:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v3 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <Y+pULHm2Qys738Zg@kroah.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
 <20230213145432.1192911-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230213145432.1192911-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 08:24:32PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial
> protocol based on running H:4, which can enable the built-in
> Bluetooth device inside a generic NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into
> sleep state whenever there is no activity for 2000ms, and will
> be woken up when any activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending
> the vendor specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the
> chip based on the CTS line, and downloads device specific FW file
> into the chip over UART.
> 
> The driver contains certain device specific default parameters
> related to FW filename, baudrate and timeouts which can be
> overwritten by an optional user space config file. These parameters
> may vary from one module vendor to another.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip
> based on compatibility devices mentioned in DT bindings. Handled
> potential memory leaks and null pointer dereference issues,
> simplified FW download feature, handled byte-order and few cosmetic
> changes. (Ilpo Järvinen, Alok Tiwari, Hillf Danton)
> v3: Added conf file support necessary to support different vendor
> modules, moved .h file contents to .c, cosmetic changes. (Luiz
> Augusto von Dentz, Rob Herring, Leon Romanovsky)
> ---
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1370 +++++++++++++++++++++++++++++++++
>  3 files changed, 1382 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..773b40d34b7b 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -465,4 +465,15 @@ config BT_VIRTIO
>  	  Say Y here to compile support for HCI over Virtio into the
>  	  kernel or say M to compile as a module.
>  
> +config BT_NXPUART
> +	tristate "NXP protocol support"
> +	depends on SERIAL_DEV_BUS
> +	help
> +	  NXP is serial driver required for NXP Bluetooth
> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module.

What is the module name?

> +#define MAX_TAG_STR_LEN				20
> +#define BT_FW_CONF_FILE				"nxp/bt_mod_para.conf"

You can not load "configuration files" as firmware, as that is not what
firmware is for.

Firmware is to be sent straight to the device, the kernel is not
supposed to do any parsing like you are doing:

> +#define USER_CONFIG_TAG				"user_config"
> +#define FW_NAME_TAG					"fw_name"
> +#define OPER_SPEED_TAG				"oper_speed"
> +#define FW_DL_PRI_BAUDRATE_TAG		"fw_dl_pri_speed"
> +#define FW_DL_SEC_BAUDRATE_TAG		"fw_dl_sec_speed"
> +#define FW_INIT_BAUDRATE			"fw_init_speed"
> +#define PS_INTERVAL_MS				"ps_interval_ms"

With these values.

Please use the normal kernel interfaces for configuring your device.
that is NOT the firmware interface, sorry.

thanks,

greg k-h
