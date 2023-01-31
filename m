Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A497C682825
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjAaJF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjAaJFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3DA7EFD;
        Tue, 31 Jan 2023 01:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 531A46146C;
        Tue, 31 Jan 2023 09:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91B0C433D2;
        Tue, 31 Jan 2023 09:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675155677;
        bh=FxfUAfy1NrNxn5s+/Ay/JREjg2ryukTPquy/zDB8xuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJd8xvUJOlfRU7uq4LJguUZ6s3fpp+imgdnEzqOBwh8IbVKHsVv7NP8hbC+mr5060
         jxwExn4RLAbFNGFwXpCsavrbYFEC33DAJXQilzeeMNxEXqG04c0R/TCDUt6r/crqN0
         Nf5J9suSO7ZPkFo5fMA+Ll2YuEfGcxrtcjVJOPed0QhbK06eEBbUshoF7OKCMR4m3d
         e88lhpOZ/1xEzWnqlIAywoATlNuZs+HsI5e2CrvT3CGAjX5nDFzK2tWvjcCs6R9nHB
         ZFxl+859upfY+UDPElWvCjmkn92i5cp0qOLwuk3bBqnGe4M6IW13NLOjZ8fJouRlzY
         j2eFtmxQxmIPw==
Date:   Tue, 31 Jan 2023 11:01:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v2 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <Y9jY2TXpl0rylQW3@unreal>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230130180504.2029440-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:35:04PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial
> protocol based on running H:4, which can enable the built-in
> Bluetooth device inside a generic NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into
> sleep state whenever there is no activity for 2000ms, and will
> be woken up when any activity is to be initiated.
> 
> This driver enables the power save feature by default by sending
> the vendor specific commands to the chip during setup.
> 
> During setup, the driver is capable of validating correct chip
> is attached to the host based on the compatibility parameter
> from DT and chip's unique bootloader signature, and download
> firmware.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based
> on compatibility devices mentioned in DT bindings. Handled potential
> memory leaks and null pointer dereference issues, simplified FW download
> feature, handled byte-order and few cosmetic changes. (Ilpo Järvinen,
> Alok Tiwari, Hillf Danton)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1145 +++++++++++++++++++++++++++++++++
>  drivers/bluetooth/btnxpuart.h |  227 +++++++
>  5 files changed, 1385 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
>  create mode 100644 drivers/bluetooth/btnxpuart.h

<...>

> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
> new file mode 100644
> index 000000000000..6e6bc5a70af2
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1145 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + *
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.

Please don't add license text, SPDX tag is enough.

<...>

> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd);
> +
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +
> +	if (status) {

Please don't add blank lines between function call and error checks of
that function.

> +		if (!*status)
> +			psdata->cur_psmode = psdata->ps_mode;
> +		else
> +			psdata->ps_mode = psdata->cur_psmode;
> +		if (psdata->cur_psmode == PS_MODE_ENABLE)
> +			ps_start_timer(nxpdev);
> +		else
> +			ps_wakeup(nxpdev);
> +		BT_INFO("Power Save mode response: status=%d, ps_mode=%d",
> +			*status, psdata->cur_psmode);
> +	}
> +	kfree_skb(skb);

<...>

> +module_serdev_device_driver(nxp_serdev_driver);
> +
> +MODULE_AUTHOR("Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>");
> +MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
> +MODULE_VERSION("v1.0");

No module versions in new code.

Thanks
