Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03B66AC58B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjCFPg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjCFPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:36:05 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Mar 2023 07:35:15 PST
Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F07F367CF;
        Mon,  6 Mar 2023 07:35:15 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        by mail11.truemail.it (Postfix) with ESMTPA id 093F921E2C;
        Mon,  6 Mar 2023 15:56:33 +0100 (CET)
Date:   Mon, 6 Mar 2023 15:56:28 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <ZAX/HHyy2yL76N0K@francesco-nb.int.toradex.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 09:15:14PM +0530, Neeraj Sanjay Kale wrote:
> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any
> activity is to be initiated over UART.
> 
> This driver enables the power save feature by default by sending the vendor
> specific commands to the chip during setup.
> 
> During setup, the driver checks if a FW is already running on the chip
> by waiting for the bootloader signature, and downloads device specific FW
> file into the chip over UART if bootloader signature is received..
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

<snip>

> +#define FIRMWARE_W8987	"nxp/uartuart8987_bt.bin"
> +#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416	"nxp/uartiw416_bt_v0.bin"
> +#define FIRMWARE_IW612	"nxp/uartspi_n61x_v1.bin.se"

Where are this files coming from? Where can I download those?
Is loading a combo firmware from the mwifiex driver supported? 

> +#define HCI_NXP_PRI_BAUDRATE	115200
> +#define HCI_NXP_SEC_BAUDRATE	3000000

What if the UART device does not support 3000000 baudrate (think at
limitation on the clock source/divider of the UART)? Shouldn't this be
configurable?

> +#define NXP_V1_FW_REQ_PKT	0xa5
> +#define NXP_V1_CHIP_VER_PKT	0xaa
> +#define NXP_V3_FW_REQ_PKT	0xa7
> +#define NXP_V3_CHIP_VER_PKT	0xab
> +
> +#define NXP_ACK_V1		0x5a
> +#define NXP_NAK_V1		0xbf
> +#define NXP_ACK_V3		0x7a
> +#define NXP_NAK_V3		0x7b
> +#define NXP_CRC_ERROR_V3	0x7c

I assume this was already discussed, but the *_V1 looks just like the
existing Marvell protocol, is it really worth a new driver? I did not check all
the details here, so maybe the answer is just yes.

Francesco

