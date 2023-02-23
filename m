Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E123C6A068E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjBWKsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjBWKsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:48:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E34C15572;
        Thu, 23 Feb 2023 02:48:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC94616B5;
        Thu, 23 Feb 2023 10:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD21C433D2;
        Thu, 23 Feb 2023 10:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677149294;
        bh=JwmNI2Lo8sTrNWeiDTCxCHRZGl3QFUVJuHx58Vb1VyE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zz41rr1nqWB7VqrFwnMoaIzUun01+96F4nM2dXHVAyS1pN2Q87hoY7TSlqLlrPd5n
         bGlekWuRVAcfqNlYYdSiKONnjL03aiUn54Dj6sfbLsbfxyCdn5FrWKnaejYhxjRArk
         DXBlRslwfYkMWtbzhIvOwenPGWb1UbOzATFiOMgY=
Date:   Thu, 23 Feb 2023 11:48:11 +0100
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
Subject: Re: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <Y/dEa6UJ2pXWsyOV@kroah.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 04:06:14PM +0530, Neeraj Sanjay Kale wrote:
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
> based on the CTS line, and downloads device specific FW file into the
> chip over UART.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Removed conf file support and added static data for each chip based on
> compatibility devices mentioned in DT bindings. Handled potential memory
> leaks and null pointer dereference issues, simplified FW download feature,
> handled byte-order and few cosmetic changes. (Ilpo Järvinen, Alok Tiwari,
> Hillf Danton)
> v3: Added conf file support necessary to support different vendor modules,
> moved .h file contents to .c, cosmetic changes. (Luiz Augusto von Dentz,
> Rob Herring, Leon Romanovsky)
> v4: Removed conf file support, optimized driver data, add logic to select
> FW name based on chip signature (Greg KH, Ilpo Jarvinen, Sherry Sun)
> v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
> parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto
> von Dentz)
> ---
>  MAINTAINERS                   |    1 +
>  drivers/bluetooth/Kconfig     |   11 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/btnxpuart.c | 1312 +++++++++++++++++++++++++++++++++
>  4 files changed, 1325 insertions(+)
>  create mode 100644 drivers/bluetooth/btnxpuart.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 030ec6fe89df..fdb9b0788c89 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22840,6 +22840,7 @@ M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
>  M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> +F:	drivers/bluetooth/btnxpuart.c
>  
>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..359a4833e31f 100644
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
> +	  the kernel, or say M here to compile as a module (btnxpuart).
> +
> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index e0b261f24fc9..7a5967e9ac48 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
>  obj-$(CONFIG_BT_MTK)		+= btmtk.o
>  
>  obj-$(CONFIG_BT_VIRTIO)		+= virtio_bt.o
> +obj-$(CONFIG_BT_NXPUART)	+= btnxpuart.o
>  
>  obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
>  
> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
> new file mode 100644
> index 000000000000..55f6bf7c5d87
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1312 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/serdev.h>
> +#include <linux/of.h>
> +#include <linux/skbuff.h>
> +#include <asm/unaligned.h>
> +#include <linux/firmware.h>
> +#include <linux/string.h>
> +#include <linux/crc8.h>
> +
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include "h4_recv.h"
> +
> +#define MANUFACTURER_NXP		37
> +
> +#define BTNXPUART_TX_STATE_ACTIVE	1
> +#define BTNXPUART_FW_DOWNLOADING	2
> +
> +#define FIRMWARE_W8987	"nxp/uartuart8987_bt.bin"
> +#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
> +#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
> +#define FIRMWARE_IW416	"nxp/uartiw416_bt_v0.bin"
> +#define FIRMWARE_IW612	"nxp/uartspi_n61x_v1.bin.se"
> +
> +#define CHIP_ID_W9098		0x5c03
> +#define CHIP_ID_IW416		0x7201
> +#define CHIP_ID_IW612		0x7601
> +
> +#define HCI_NXP_PRI_BAUDRATE	115200
> +#define HCI_NXP_SEC_BAUDRATE	3000000
> +
> +#define MAX_FW_FILE_NAME_LEN    50
> +
> +/* Default ps timeout period in milli-second */
> +#define PS_DEFAULT_TIMEOUT_PERIOD     2000
> +
> +/* wakeup methods */
> +#define WAKEUP_METHOD_DTR       0
> +#define WAKEUP_METHOD_BREAK     1
> +#define WAKEUP_METHOD_EXT_BREAK 2
> +#define WAKEUP_METHOD_RTS       3
> +#define WAKEUP_METHOD_INVALID   0xff
> +
> +/* power save mode status */
> +#define PS_MODE_DISABLE         0
> +#define PS_MODE_ENABLE          1
> +
> +/* Power Save Commands to ps_work_func  */
> +#define PS_CMD_EXIT_PS          1
> +#define PS_CMD_ENTER_PS         2
> +
> +/* power save state */
> +#define PS_STATE_AWAKE          0
> +#define PS_STATE_SLEEP          1
> +
> +/* Bluetooth vendor command : Sleep mode */
> +#define HCI_NXP_AUTO_SLEEP_MODE	0xfc23
> +/* Bluetooth vendor command : Wakeup method */
> +#define HCI_NXP_WAKEUP_METHOD	0xfc53
> +/* Bluetooth vendor command : Set operational baudrate */
> +#define HCI_NXP_SET_OPER_SPEED	0xfc09
> +/* Bluetooth vendor command: Independent Reset */
> +#define HCI_NXP_IND_RESET	0xfcfc
> +
> +/* Bluetooth Power State : Vendor cmd params */
> +#define BT_PS_ENABLE			0x02
> +#define BT_PS_DISABLE			0x03
> +
> +/* Bluetooth Host Wakeup Methods */
> +#define BT_HOST_WAKEUP_METHOD_NONE      0x00
> +#define BT_HOST_WAKEUP_METHOD_DTR       0x01
> +#define BT_HOST_WAKEUP_METHOD_BREAK     0x02
> +#define BT_HOST_WAKEUP_METHOD_GPIO      0x03
> +
> +/* Bluetooth Chip Wakeup Methods */
> +#define BT_CTRL_WAKEUP_METHOD_DSR       0x00
> +#define BT_CTRL_WAKEUP_METHOD_BREAK     0x01
> +#define BT_CTRL_WAKEUP_METHOD_GPIO      0x02
> +#define BT_CTRL_WAKEUP_METHOD_EXT_BREAK 0x04
> +#define BT_CTRL_WAKEUP_METHOD_RTS       0x05
> +
> +#define MAX_USER_PARAMS			10
> +
> +struct ps_data {
> +	u8    ps_mode;
> +	u8    cur_psmode;
> +	u8    ps_state;
> +	u8    ps_cmd;
> +	u8    h2c_wakeupmode;
> +	u8    cur_h2c_wakeupmode;
> +	u8    c2h_wakeupmode;
> +	u8    c2h_wakeup_gpio;
> +	bool  driver_sent_cmd;
> +	bool  timer_on;
> +	u32   interval;
> +	struct hci_dev *hdev;
> +	struct work_struct work;
> +	struct timer_list ps_timer;
> +};
> +
> +struct btnxpuart_data {
> +	bool fw_dnld_use_high_baudrate;
> +	const u8 *fw_name;
> +};
> +
> +struct btnxpuart_dev {
> +	struct hci_dev *hdev;
> +	struct serdev_device *serdev;
> +
> +	struct work_struct tx_work;
> +	unsigned long tx_state;
> +	struct sk_buff_head txq;
> +	struct sk_buff *rx_skb;
> +
> +	const struct firmware *fw;
> +	u8 fw_name[MAX_FW_FILE_NAME_LEN];
> +	u32 fw_dnld_v1_offset;
> +	u32 fw_v1_sent_bytes;
> +	u32 fw_v3_offset_correction;
> +	u32 fw_v1_expected_len;
> +	wait_queue_head_t suspend_wait_q;
> +
> +	u32 new_baudrate;
> +	u32 current_baudrate;
> +	bool timeout_changed;
> +	bool baudrate_changed;
> +
> +	struct ps_data *psdata;
> +	struct btnxpuart_data *nxp_data;
> +};
> +
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
> +
> +#define HDR_LEN			16
> +
> +#define NXP_RECV_FW_REQ_V1 \
> +	.type = NXP_V1_FW_REQ_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_CHIP_VER_V3 \
> +	.type = NXP_V3_CHIP_VER_PKT, \
> +	.hlen = 4, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 4
> +
> +#define NXP_RECV_FW_REQ_V3 \
> +	.type = NXP_V3_FW_REQ_PKT, \
> +	.hlen = 9, \
> +	.loff = 0, \
> +	.lsize = 0, \
> +	.maxlen = 9
> +
> +struct v1_data_req {
> +	__le16 len;
> +	__le16 len_comp;
> +} __packed;
> +
> +struct v3_data_req {
> +	__le16 len;
> +	__le32 offset;
> +	__le16 error;
> +	u8 crc;
> +} __packed;
> +
> +struct v3_start_ind {
> +	__le16 chip_id;
> +	u8 loader_ver;
> +	u8 crc;
> +} __packed;
> +
> +/* UART register addresses of BT chip */
> +#define CLKDIVADDR	0x7f00008f
> +#define UARTDIVADDR	0x7f000090
> +#define UARTMCRADDR	0x7f000091
> +#define UARTREINITADDR	0x7f000092
> +#define UARTICRADDR	0x7f000093
> +#define UARTFCRADDR	0x7f000094
> +
> +#define MCR		0x00000022
> +#define INIT		0x00000001
> +#define ICR		0x000000c7
> +#define FCR		0x000000c7
> +
> +#define POLYNOMIAL8	0x07
> +#define POLYNOMIAL32	0x04c11db7L
> +
> +struct uart_reg {
> +	__le32 address;
> +	__le32 value;
> +} __packed;
> +
> +struct uart_config {
> +	struct uart_reg clkdiv;
> +	struct uart_reg uartdiv;
> +	struct uart_reg mcr;
> +	struct uart_reg re_init;
> +	struct uart_reg icr;
> +	struct uart_reg fcr;
> +	__le32 crc;
> +} __packed;
> +
> +struct nxp_bootloader_cmd {
> +	__le32 header;
> +	__le32 arg;
> +	__le32 payload_len;
> +	__le32 crc;
> +} __packed;
> +
> +static u8 crc8_table[CRC8_TABLE_SIZE];

Shouldn't this be initialized when the module is loaded and not at some
random time later on?

> +static unsigned long crc32_table[256];

Why do you hand-create this, don't we have kernel functions for this?

> +
> +/* Default Power Save configuration */
> +static int h2c_wakeupmode = WAKEUP_METHOD_BREAK;
> +static int ps_mode = PS_MODE_ENABLE;

This will not work.

> +
> +static int init_baudrate = 115200;

and neither will this, as you need to support multiple devices in the
system, your driver should never be only able to work with one device.
Please make these device-specific things, not the same for the whole
driver.

> +static int ps_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = nxpdev->psdata;
> +
> +	if (psdata->ps_state == PS_STATE_AWAKE)
> +		return 0;
> +	psdata->ps_cmd = PS_CMD_EXIT_PS;
> +	schedule_work(&psdata->work);
> +
> +	return 1;

Why is this function returning anything (and what does 0 and 1 mean?)
when you never actually check the return value of it?

thanks,

greg k-h
