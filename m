Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1C6BB561
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjCON6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjCON6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:58:11 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62DF93F3;
        Wed, 15 Mar 2023 06:58:00 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aedf0.dynamic.kabel-deutschland.de [95.90.237.240])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 70CE361CC457B;
        Wed, 15 Mar 2023 14:57:57 +0100 (CET)
Message-ID: <838f77fd-fc25-da16-b0fb-14624e0bc33e@molgen.mpg.de>
Date:   Wed, 15 Mar 2023 14:57:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v12 4/4] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
 <20230315120327.958413-5-neeraj.sanjaykale@nxp.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230315120327.958413-5-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Neeraj,


Thank you for your patch.


Am 15.03.23 um 13:03 schrieb Neeraj Sanjay Kale:
> This adds a driver based on serdev driver for the NXP BT serial protocol
> based on running H:4, which can enable the built-in Bluetooth device
> inside an NXP BT chip.
> 
> This driver has Power Save feature that will put the chip into sleep state
> whenever there is no activity for 2000ms, and will be woken up when any

Interesting. Are two seconds recommended in some specification?

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
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---

[…]

> ---
>   MAINTAINERS                   |    1 +
>   drivers/bluetooth/Kconfig     |   12 +
>   drivers/bluetooth/Makefile    |    1 +
>   drivers/bluetooth/btnxpuart.c | 1289 +++++++++++++++++++++++++++++++++
>   4 files changed, 1303 insertions(+)
>   create mode 100644 drivers/bluetooth/btnxpuart.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 030ec6fe89df..fdb9b0788c89 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22840,6 +22840,7 @@ M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
>   M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
>   S:	Maintained
>   F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> +F:	drivers/bluetooth/btnxpuart.c
>   
>   THE REST
>   M:	Linus Torvalds <torvalds@linux-foundation.org>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 5a1a7bec3c42..0703bdd44140 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -465,4 +465,16 @@ config BT_VIRTIO
>   	  Say Y here to compile support for HCI over Virtio into the
>   	  kernel or say M to compile as a module.
>   
> +config BT_NXPUART
> +	tristate "NXP protocol support"
> +	depends on SERIAL_DEV_BUS
> +	select CRC32
> +	help
> +	  NXP is serial driver required for NXP Bluetooth

NXP UART is a serial driver …?

> +	  devices with UART interface.
> +
> +	  Say Y here to compile support for NXP Bluetooth UART device into
> +	  the kernel, or say M here to compile as a module (btnxpuart).
> +
> +
>   endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index e0b261f24fc9..7a5967e9ac48 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
>   obj-$(CONFIG_BT_MTK)		+= btmtk.o
>   
>   obj-$(CONFIG_BT_VIRTIO)		+= virtio_bt.o
> +obj-$(CONFIG_BT_NXPUART)	+= btnxpuart.o
>   
>   obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
>   
> diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
> new file mode 100644
> index 000000000000..1483481f7cb0
> --- /dev/null
> +++ b/drivers/bluetooth/btnxpuart.c
> @@ -0,0 +1,1289 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  NXP Bluetooth driver
> + *  Copyright 2018-2023 NXP

If it’s a new file, how can copyright be from before 2023?

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
> +#include <linux/crc32.h>
> +#include <linux/string_helpers.h>
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
> +#define BTNXPUART_CHECK_BOOT_SIGNATURE	3
> +#define BTNXPUART_SERDEV_OPEN		4
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

milliseconds

> +#define PS_DEFAULT_TIMEOUT_PERIOD     2000

Please append the unit to the macro name.

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
> +struct ps_data {
> +	u8    target_ps_mode;	/* ps mode to be set */
> +	u8    cur_psmode;	/* current ps_mode */
> +	u8    ps_state;		/* controller's power save state */
> +	u8    ps_cmd;
> +	u8    h2c_wakeupmode;
> +	u8    cur_h2c_wakeupmode;
> +	u8    c2h_wakeupmode;
> +	u8    c2h_wakeup_gpio;
> +	u8    h2c_wakeup_gpio;
> +	bool  driver_sent_cmd;
> +	u16   h2c_ps_interval;
> +	u16   c2h_ps_interval;
> +	struct hci_dev *hdev;
> +	struct work_struct work;
> +	struct timer_list ps_timer;
> +};
> +
> +struct wakeup_cmd_payload {
> +	u8 c2h_wakeupmode;
> +	u8 c2h_wakeup_gpio;
> +	u8 h2c_wakeupmode;
> +	u8 h2c_wakeup_gpio;
> +} __packed;
> +
> +struct psmode_cmd_payload {
> +	u8 ps_cmd;
> +	__le16 c2h_ps_interval;
> +} __packed;
> +
> +struct btnxpuart_data {
> +	bool fw_dnld_use_high_baudrate;

It’d write `download` instead of dnld.

> +	const u8 *fw_name;

Why not char?

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
> +	wait_queue_head_t fw_dnld_done_wait_q;
> +	wait_queue_head_t check_boot_sign_wait_q;
> +
> +	u32 new_baudrate;
> +	u32 current_baudrate;
> +	u32 fw_init_baudrate;
> +	bool timeout_changed;
> +	bool baudrate_changed;
> +
> +	struct ps_data psdata;
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
> +	__be32 crc;
> +} __packed;
> +
> +struct nxp_bootloader_cmd {
> +	__le32 header;
> +	__le32 arg;
> +	__le32 payload_len;
> +	__be32 crc;
> +} __packed;
> +
> +static u8 crc8_table[CRC8_TABLE_SIZE];
> +
> +/* Default configurations */
> +#define DEFAULT_H2C_WAKEUP_MODE	WAKEUP_METHOD_BREAK
> +#define DEFAULT_PS_MODE		PS_MODE_ENABLE
> +#define FW_INIT_BAUDRATE	HCI_NXP_PRI_BAUDRATE
> +
> +static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
> +					u32 plen,
> +					void *param)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	struct sk_buff *skb;
> +
> +	/* set flag to prevent nxp_enqueue from parsing values from this command and
> +	 * calling hci_cmd_sync_queue() again.
> +	 */
> +	psdata->driver_sent_cmd = true;
> +	skb = __hci_cmd_sync(hdev, opcode, plen, param, HCI_CMD_TIMEOUT);
> +	psdata->driver_sent_cmd = false;
> +
> +	return skb;
> +}
> +
> +static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	if (schedule_work(&nxpdev->tx_work))
> +		set_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
> +}
> +
> +/* NXP Power Save Feature */
> +static void ps_start_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	if (!psdata)
> +		return;
> +
> +	if (psdata->cur_psmode == PS_MODE_ENABLE)
> +		mod_timer(&psdata->ps_timer, jiffies + msecs_to_jiffies(psdata->h2c_ps_interval));
> +}
> +
> +static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	flush_work(&psdata->work);
> +	del_timer_sync(&psdata->ps_timer);
> +}
> +
> +static void ps_control(struct hci_dev *hdev, u8 ps_state)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	int status;
> +
> +	if (psdata->ps_state == ps_state ||
> +	    !test_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state))
> +		return;
> +
> +	switch (psdata->cur_h2c_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		if (ps_state == PS_STATE_AWAKE)
> +			status = serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		else
> +			status = serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		if (ps_state == PS_STATE_AWAKE)
> +			status = serdev_device_break_ctl(nxpdev->serdev, 0);
> +		else
> +			status = serdev_device_break_ctl(nxpdev->serdev, -1);
> +		bt_dev_dbg(hdev, "Set UART break: %s, status=%d",
> +			   str_on_off(ps_state == PS_STATE_SLEEP), status);
> +		break;
> +	}
> +	if (!status)
> +		psdata->ps_state = ps_state;
> +	if (ps_state == PS_STATE_AWAKE)
> +		btnxpuart_tx_wakeup(nxpdev);
> +}
> +
> +static void ps_work_func(struct work_struct *work)
> +{
> +	struct ps_data *data = container_of(work, struct ps_data, work);
> +
> +	if (data->ps_cmd == PS_CMD_ENTER_PS && data->cur_psmode == PS_MODE_ENABLE)
> +		ps_control(data->hdev, PS_STATE_SLEEP);
> +	else if (data->ps_cmd == PS_CMD_EXIT_PS)
> +		ps_control(data->hdev, PS_STATE_AWAKE);
> +}
> +
> +static void ps_timeout_func(struct timer_list *t)
> +{
> +	struct ps_data *data = from_timer(data, t, ps_timer);
> +	struct hci_dev *hdev = data->hdev;
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +
> +	if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
> +		ps_start_timer(nxpdev);
> +	} else {
> +		data->ps_cmd = PS_CMD_ENTER_PS;
> +		schedule_work(&data->work);
> +	}
> +}
> +
> +static int ps_init_work(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	psdata->h2c_ps_interval = PS_DEFAULT_TIMEOUT_PERIOD;
> +	psdata->ps_state = PS_STATE_AWAKE;
> +	psdata->target_ps_mode = DEFAULT_PS_MODE;
> +	psdata->hdev = hdev;
> +	psdata->c2h_wakeupmode = BT_HOST_WAKEUP_METHOD_NONE;
> +	psdata->c2h_wakeup_gpio = 0xff;
> +
> +	switch (DEFAULT_H2C_WAKEUP_MODE) {
> +	case WAKEUP_METHOD_DTR:
> +		psdata->h2c_wakeupmode = WAKEUP_METHOD_DTR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		psdata->h2c_wakeupmode = WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	psdata->cur_psmode = PS_MODE_DISABLE;
> +	psdata->cur_h2c_wakeupmode = WAKEUP_METHOD_INVALID;
> +	INIT_WORK(&psdata->work, ps_work_func);
> +
> +	return 0;
> +}
> +
> +static void ps_init_timer(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
> +}
> +
> +static void ps_wakeup(struct btnxpuart_dev *nxpdev)
> +{
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	if (psdata->ps_state != PS_STATE_AWAKE) {
> +		psdata->ps_cmd = PS_CMD_EXIT_PS;
> +		schedule_work(&psdata->work);
> +	}
> +}
> +
> +static int send_ps_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	struct psmode_cmd_payload pcmd;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	if (psdata->target_ps_mode == PS_MODE_ENABLE)
> +		pcmd.ps_cmd = BT_PS_ENABLE;
> +	else
> +		pcmd.ps_cmd = BT_PS_DISABLE;
> +	pcmd.c2h_ps_interval = __cpu_to_le16(psdata->c2h_ps_interval);
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, sizeof(pcmd), &pcmd);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (!*status)
> +			psdata->cur_psmode = psdata->target_ps_mode;
> +		else
> +			psdata->target_ps_mode = psdata->cur_psmode;
> +		if (psdata->cur_psmode == PS_MODE_ENABLE)
> +			ps_start_timer(nxpdev);
> +		else
> +			ps_wakeup(nxpdev);
> +		bt_dev_dbg(hdev, "Power Save mode response: status=%d, ps_mode=%d",
> +			   *status, psdata->cur_psmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +	struct wakeup_cmd_payload pcmd;
> +	struct sk_buff *skb;
> +	u8 *status;
> +
> +	pcmd.c2h_wakeupmode = psdata->c2h_wakeupmode;
> +	pcmd.c2h_wakeup_gpio = psdata->c2h_wakeup_gpio;
> +	switch (psdata->h2c_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		pcmd.h2c_wakeupmode = BT_CTRL_WAKEUP_METHOD_DSR;
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		pcmd.h2c_wakeupmode = BT_CTRL_WAKEUP_METHOD_BREAK;
> +		break;
> +	}
> +	pcmd.h2c_wakeup_gpio = 0xff;
> +
> +	skb = nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, sizeof(pcmd), &pcmd);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Setting wake-up method failed (%ld)", PTR_ERR(skb));
> +		return PTR_ERR(skb);
> +	}
> +
> +	status = skb_pull_data(skb, 1);
> +	if (status) {
> +		if (*status == 0)
> +			psdata->cur_h2c_wakeupmode = psdata->h2c_wakeupmode;
> +		else
> +			psdata->h2c_wakeupmode = psdata->cur_h2c_wakeupmode;
> +		bt_dev_dbg(hdev, "Set Wakeup Method response: status=%d, h2c_wakeupmode=%d",
> +			   *status, psdata->cur_h2c_wakeupmode);
> +	}
> +	kfree_skb(skb);
> +
> +	return 0;
> +}
> +
> +static void ps_init(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct ps_data *psdata = &nxpdev->psdata;
> +
> +	serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_RTS);
> +	usleep_range(5000, 10000);
> +	serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
> +	usleep_range(5000, 10000);
> +
> +	switch (psdata->h2c_wakeupmode) {
> +	case WAKEUP_METHOD_DTR:
> +		serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
> +		serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
> +		break;
> +	case WAKEUP_METHOD_BREAK:
> +	default:
> +		serdev_device_break_ctl(nxpdev->serdev, -1);
> +		usleep_range(5000, 10000);
> +		serdev_device_break_ctl(nxpdev->serdev, 0);
> +		usleep_range(5000, 10000);
> +		break;
> +	}
> +	if (psdata->cur_h2c_wakeupmode != psdata->h2c_wakeupmode)
> +		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
> +	if (psdata->cur_psmode != psdata->target_ps_mode)
> +		hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
> +}
> +
> +/* NXP Firmware Download Feature */
> +static int nxp_download_firmware(struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err = 0;
> +
> +	nxpdev->fw_dnld_v1_offset = 0;
> +	nxpdev->fw_v1_sent_bytes = 0;
> +	nxpdev->fw_v1_expected_len = HDR_LEN;
> +	nxpdev->fw_v3_offset_correction = 0;
> +	nxpdev->baudrate_changed = false;
> +	nxpdev->timeout_changed = false;
> +
> +	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
> +	serdev_device_set_flow_control(nxpdev->serdev, 0);
> +	nxpdev->current_baudrate = HCI_NXP_PRI_BAUDRATE;
> +
> +	/* Wait till FW is downloaded and CTS becomes low */
> +	err = wait_event_interruptible_timeout(nxpdev->fw_dnld_done_wait_q,
> +					       !test_bit(BTNXPUART_FW_DOWNLOADING,
> +							 &nxpdev->tx_state),
> +					       msecs_to_jiffies(60000));
> +	if (err == 0) {
> +		bt_dev_err(hdev, "FW Download Timeout.");
> +		return -ETIMEDOUT;
> +	}
> +
> +	serdev_device_set_flow_control(nxpdev->serdev, 1);
> +	err = serdev_device_wait_for_cts(nxpdev->serdev, 1, 60000);
> +	if (err < 0) {
> +		bt_dev_err(hdev, "CTS is still high. FW Download failed.");
> +		return err;
> +	}
> +	release_firmware(nxpdev->fw);
> +	memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
> +
> +	/* Allow the downloaded FW to initialize */
> +	usleep_range(800 * USEC_PER_MSEC, 1 * USEC_PER_SEC);
> +
> +	return 0;
> +}
> +
> +static void nxp_send_ack(u8 ack, struct hci_dev *hdev)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	u8 ack_nak[2];
> +	int len = 1;
> +
> +	ack_nak[0] = ack;
> +	if (ack == NXP_ACK_V3) {
> +		ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xff);
> +		len = 2;
> +	}
> +	serdev_device_write_buf(nxpdev->serdev, ack_nak, len);
> +}
> +
> +static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd5;
> +	struct uart_config uart_config;
> +
> +	if (req_len == sizeof(nxp_cmd5)) {
> +		nxp_cmd5.header = __cpu_to_le32(5);
> +		nxp_cmd5.arg = 0;
> +		nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
> +		/* FW expects swapped CRC bytes */
> +		nxp_cmd5.crc = __cpu_to_be32(crc32_be(0UL, (char *)&nxp_cmd5,
> +						      sizeof(nxp_cmd5) - 4));
> +
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd5, sizeof(nxp_cmd5));
> +		nxpdev->fw_v3_offset_correction += req_len;
> +	} else if (req_len == sizeof(uart_config)) {
> +		uart_config.clkdiv.address = __cpu_to_le32(CLKDIVADDR);
> +		uart_config.clkdiv.value = __cpu_to_le32(0x00c00000);
> +		uart_config.uartdiv.address = __cpu_to_le32(UARTDIVADDR);
> +		uart_config.uartdiv.value = __cpu_to_le32(1);
> +		uart_config.mcr.address = __cpu_to_le32(UARTMCRADDR);
> +		uart_config.mcr.value = __cpu_to_le32(MCR);
> +		uart_config.re_init.address = __cpu_to_le32(UARTREINITADDR);
> +		uart_config.re_init.value = __cpu_to_le32(INIT);
> +		uart_config.icr.address = __cpu_to_le32(UARTICRADDR);
> +		uart_config.icr.value = __cpu_to_le32(ICR);
> +		uart_config.fcr.address = __cpu_to_le32(UARTFCRADDR);
> +		uart_config.fcr.value = __cpu_to_le32(FCR);
> +		/* FW expects swapped CRC bytes */
> +		uart_config.crc = __cpu_to_be32(crc32_be(0UL, (char *)&uart_config,
> +							 sizeof(uart_config) - 4));
> +
> +		serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_config, sizeof(uart_config));
> +		serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +		nxpdev->fw_v3_offset_correction += req_len;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static bool nxp_fw_change_timeout(struct hci_dev *hdev, u16 req_len)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct nxp_bootloader_cmd nxp_cmd7;
> +
> +	if (req_len != sizeof(nxp_cmd7))
> +		return false;
> +
> +	nxp_cmd7.header = __cpu_to_le32(7);
> +	nxp_cmd7.arg = __cpu_to_le32(0x70);
> +	nxp_cmd7.payload_len = 0;
> +	/* FW expects swapped CRC bytes */
> +	nxp_cmd7.crc = __cpu_to_be32(crc32_be(0UL, (char *)&nxp_cmd7,
> +					      sizeof(nxp_cmd7) - 4));
> +	serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, sizeof(nxp_cmd7));
> +	serdev_device_wait_until_sent(nxpdev->serdev, 0);
> +	nxpdev->fw_v3_offset_correction += req_len;
> +	return true;
> +}
> +
> +static u32 nxp_get_data_len(const u8 *buf)
> +{
> +	struct nxp_bootloader_cmd *hdr = (struct nxp_bootloader_cmd *)buf;
> +
> +	return __le32_to_cpu(hdr->payload_len);
> +}
> +
> +static bool is_fw_downloading(struct btnxpuart_dev *nxpdev)
> +{
> +	return test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +}
> +
> +static bool process_boot_signature(struct btnxpuart_dev *nxpdev)
> +{
> +	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
> +		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
> +		return false;
> +	}
> +	return is_fw_downloading(nxpdev);
> +}
> +
> +static int nxp_request_firmware(struct hci_dev *hdev, const u8 *fw_name)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	int err = 0;
> +
> +	if (!strlen(nxpdev->fw_name)) {
> +		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s", fw_name);
> +
> +		bt_dev_dbg(hdev, "Request Firmware: %s", nxpdev->fw_name);
> +		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
> +		if (err < 0) {
> +			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
> +			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		}
> +	}
> +	return err;
> +}
> +
> +/* for legacy chipsets with V1 bootloader */
> +static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
> +	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
> +	struct v1_data_req *req;
> +	u32 requested_len;
> +
> +	if (!process_boot_signature(nxpdev))
> +		goto free_skb;
> +
> +	req = (struct v1_data_req *)skb_pull_data(skb, sizeof(struct v1_data_req));
> +	if (!req)
> +		goto free_skb;
> +
> +	if ((req->len ^ req->len_comp) != 0xffff) {
> +		bt_dev_dbg(hdev, "ERR: Send NAK");
> +		nxp_send_ack(NXP_NAK_V1, hdev);
> +		goto free_skb;
> +	}
> +	nxp_send_ack(NXP_ACK_V1, hdev);
> +
> +	if (nxp_data->fw_dnld_use_high_baudrate) {
> +		if (!nxpdev->timeout_changed) {
> +			nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
> +			goto free_skb;
> +		}
> +		if (!nxpdev->baudrate_changed) {
> +			nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
> +			if (nxpdev->baudrate_changed) {
> +				serdev_device_set_baudrate(nxpdev->serdev,
> +							   HCI_NXP_SEC_BAUDRATE);
> +				serdev_device_set_flow_control(nxpdev->serdev, 1);
> +				nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
> +			}
> +			goto free_skb;
> +		}
> +	}
> +
> +	if (nxp_request_firmware(hdev, nxp_data->fw_name))
> +		goto free_skb;
> +
> +	requested_len = req->len;
> +	if (requested_len == 0) {
> +		bt_dev_dbg(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
> +		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
> +		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
> +		goto free_skb;
> +	}
> +	if (requested_len & 0x01) {
> +		/* The CRC did not match at the other end.
> +		 * Simply send the same bytes again.
> +		 */
> +		requested_len = nxpdev->fw_v1_sent_bytes;
> +		bt_dev_dbg(hdev, "CRC error. Resend %d bytes of FW.", requested_len);
> +	} else {
> +		nxpdev->fw_dnld_v1_offset += nxpdev->fw_v1_sent_bytes;
> +
> +		/* The FW bin file is made up of many blocks of
> +		 * 16 byte header and payload data chunks. If the
> +		 * FW has requested a header, read the payload length
> +		 * info from the header, before sending the header.
> +		 * In the next iteration, the FW should request the
> +		 * payload data chunk, which should be equal to the
> +		 * payload length read from header. If there is a
> +		 * mismatch, clearly the driver and FW are out of sync,
> +		 * and we need to re-send the previous header again.
> +		 */
> +		if (requested_len == nxpdev->fw_v1_expected_len) {
> +			if (requested_len == HDR_LEN)
> +				nxpdev->fw_v1_expected_len = nxp_get_data_len(nxpdev->fw->data +
> +									nxpdev->fw_dnld_v1_offset);
> +			else
> +				nxpdev->fw_v1_expected_len = HDR_LEN;
> +		} else if (requested_len == HDR_LEN) {
> +			/* FW download out of sync. Send previous chunk again */
> +			nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
> +			nxpdev->fw_v1_expected_len = HDR_LEN;
> +		}
> +	}
> +
> +	if (nxpdev->fw_dnld_v1_offset + requested_len <= nxpdev->fw->size)
> +		serdev_device_write_buf(nxpdev->serdev,
> +					nxpdev->fw->data + nxpdev->fw_dnld_v1_offset,
> +					requested_len);
> +	nxpdev->fw_v1_sent_bytes = requested_len;
> +
> +free_skb:
> +	kfree_skb(skb);
> +	return 0;
> +}
> +
> +static u8 *nxp_get_fw_name_from_chipid(struct hci_dev *hdev, u16 chipid)

Any reason to limit the length of `chipid` instead of using `unsigned int`?

> +{
> +	u8 *fw_name = NULL;

Ditto.

> +
> +	switch (chipid) {
> +	case CHIP_ID_W9098:
> +		fw_name = FIRMWARE_W9098;
> +		break;
> +	case CHIP_ID_IW416:
> +		fw_name = FIRMWARE_IW416;
> +		break;
> +	case CHIP_ID_IW612:
> +		fw_name = FIRMWARE_IW612;
> +		break;
> +	default:
> +		bt_dev_err(hdev, "Unknown chip signature %04x", chipid);
> +		break;
> +	}
> +	return fw_name;
> +}

[…]


Kind regards,

Paul
