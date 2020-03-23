Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3852F18FC26
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCWR4z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Mar 2020 13:56:55 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59036 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgCWR4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:56:54 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 68D5ECECFF;
        Mon, 23 Mar 2020 19:06:24 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
Date:   Mon, 23 Mar 2020 18:56:52 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org>
References: <20200323072824.254495-1-mcchou@chromium.org>
 <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This adds a bit mask of driver_info for Microsoft vendor extension and
> indicates the support for Intel 9460/9560 and 9160/9260. See
> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> microsoft-defined-bluetooth-hci-commands-and-events for more information
> about the extension. This was verified with Intel ThunderPeak BT controller
> where msft_vnd_ext_opcode is 0xFC1E.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> Changes in v1:
> - Add a bit mask of driver_info for Microsoft vendor extension.
> - Indicates the support of Microsoft vendor extension for Intel
> 9460/9560 and 9160/9260.
> - Add fields to struct hci_dev to facilitate the support of Microsoft
> vendor extension.
> 
> drivers/bluetooth/btusb.c        | 18 ++++++++++++++++--
> include/net/bluetooth/hci.h      |  2 ++
> include/net/bluetooth/hci_core.h |  4 ++++
> 3 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 3bdec42c9612..5eb27d1c4ac7 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
> #define BTUSB_CW6622		0x100000
> #define BTUSB_MEDIATEK		0x200000
> #define BTUSB_WIDEBAND_SPEECH	0x400000
> +#define BTUSB_MSFT_VND_EXT	0x800000
> 
> static const struct usb_device_id btusb_table[] = {
> 	/* Generic Bluetooth USB device */
> @@ -335,7 +336,8 @@ static const struct usb_device_id blacklist_table[] = {
> 
> 	/* Intel Bluetooth devices */
> 	{ USB_DEVICE(0x8087, 0x0025), .driver_info = BTUSB_INTEL_NEW |
> -						     BTUSB_WIDEBAND_SPEECH },
> +						     BTUSB_WIDEBAND_SPEECH |
> +						     BTUSB_MSFT_VND_EXT },
> 	{ USB_DEVICE(0x8087, 0x0026), .driver_info = BTUSB_INTEL_NEW |
> 						     BTUSB_WIDEBAND_SPEECH },
> 	{ USB_DEVICE(0x8087, 0x0029), .driver_info = BTUSB_INTEL_NEW |
> @@ -348,7 +350,8 @@ static const struct usb_device_id blacklist_table[] = {
> 	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL |
> 						     BTUSB_WIDEBAND_SPEECH },
> 	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_NEW |
> -						     BTUSB_WIDEBAND_SPEECH },
> +						     BTUSB_WIDEBAND_SPEECH |
> +						     BTUSB_MSFT_VND_EXT },
> 
> 	/* Other Intel Bluetooth devices */
> 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
> @@ -3734,6 +3737,11 @@ static int btusb_probe(struct usb_interface *intf,
> 	hdev->send   = btusb_send_frame;
> 	hdev->notify = btusb_notify;
> 
> +	hdev->msft_vnd_ext_opcode = HCI_OP_NOP;
> +	hdev->msft_vnd_ext_features = 0;
> +	hdev->msft_vnd_ext_evt_prefix_len = 0;
> +	hdev->msft_vnd_ext_evt_prefix = NULL;
> +

Add the extra parameters when you start using them. Keep this patch for just the opcode.

> #ifdef CONFIG_PM
> 	err = btusb_config_oob_wake(hdev);
> 	if (err)
> @@ -3800,6 +3808,12 @@ static int btusb_probe(struct usb_interface *intf,
> 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
> 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> +
> +		if (id->driver_info & BTUSB_MSFT_VND_EXT &&
> +			(id->idProduct == 0x0025 || id->idProduct == 0x0aaa)) {

I don’t get the extra check here. It is not needed. Just rely on id->driver_info.

> +			hdev->msft_vnd_ext_opcode =
> +				hci_opcode_pack(HCI_VND_DEBUG_CMD_OGF, 0x001E);

Don’t bother with opcode_pack here. Just assign it 0xFC1E.

> +		}
> 	}
> 
> 	if (id->driver_info & BTUSB_MARVELL)
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 5f60e135aeb6..b85e95454367 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -38,6 +38,8 @@
> 
> #define HCI_MAX_CSB_DATA_SIZE	252
> 
> +#define HCI_VND_DEBUG_CMD_OGF	0x3f
> +
> /* HCI dev events */
> #define HCI_DEV_REG			1
> #define HCI_DEV_UNREG			2
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index d4e28773d378..15daf3b2d4f0 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -315,6 +315,10 @@ struct hci_dev {
> 	__u8		ssp_debug_mode;
> 	__u8		hw_error_code;
> 	__u32		clock;
> +	__u16		msft_vnd_ext_opcode;
> +	__u64		msft_vnd_ext_features;
> +	__u8		msft_vnd_ext_evt_prefix_len;
> +	void		*msft_vnd_ext_evt_prefix;
> 
> 	__u16		devid_source;
> 	__u16		devid_vendor;

Regards

Marcel

