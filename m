Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30392192223
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYIK1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 04:10:27 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60677 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgCYIK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:10:27 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id A34E9CECCA;
        Wed, 25 Mar 2020 09:19:56 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
Date:   Wed, 25 Mar 2020 09:10:24 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <72699110-843A-4382-8FF1-20C5D4D557A2@holtmann.org>
References: <20200325070336.1097-1-mcchou@chromium.org>
 <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
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
> Changes in v2:
> - Define struct msft_vnd_ext and add a field of this type to struct
> hci_dev to facilitate the support of Microsoft vendor extension.
> 
> drivers/bluetooth/btusb.c        | 14 ++++++++++++--
> include/net/bluetooth/hci_core.h |  6 ++++++
> 2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 3bdec42c9612..4c49f394f174 100644
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
> @@ -3734,6 +3737,8 @@ static int btusb_probe(struct usb_interface *intf,
> 	hdev->send   = btusb_send_frame;
> 	hdev->notify = btusb_notify;
> 
> +	hdev->msft_ext.opcode = HCI_OP_NOP;
> +

do this in the hci_alloc_dev procedure for every driver. This doesn’t belong in the driver.

> #ifdef CONFIG_PM
> 	err = btusb_config_oob_wake(hdev);
> 	if (err)
> @@ -3800,6 +3805,11 @@ static int btusb_probe(struct usb_interface *intf,
> 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
> 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> 		set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> +
> +		if (id->driver_info & BTUSB_MSFT_VND_EXT &&
> +			(id->idProduct == 0x0025 || id->idProduct == 0x0aaa)) {

Please scrap this extra check. You already selected out the PID with the blacklist_table. In addition, I do not want to add a PID in two places in the driver.

An alternative is to not use BTUSB_MSFT_VND_EXT and let the Intel code set it based on the hardware / firmware revision it finds. We might need to discuss which is the better approach for the Intel hardware since not all PIDs are unique.

> +			hdev->msft_ext.opcode = 0xFC1E;
> +		}
> 	}
> 
> 	if (id->driver_info & BTUSB_MARVELL)
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index d4e28773d378..0ec3d9b41d81 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -244,6 +244,10 @@ struct amp_assoc {
> 
> #define HCI_MAX_PAGES	3
> 
> +struct msft_vnd_ext {
> +	__u16	opcode;
> +};
> +
> struct hci_dev {
> 	struct list_head list;
> 	struct mutex	lock;
> @@ -343,6 +347,8 @@ struct hci_dev {
> 
> 	struct amp_assoc	loc_assoc;
> 
> +	struct msft_vnd_ext	msft_ext;
> +
> 	__u8		flow_ctl_mode;
> 
> 	unsigned int	auto_accept_delay;

Regards

Marcel

