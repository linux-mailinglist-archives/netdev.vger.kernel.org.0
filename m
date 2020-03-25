Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14C192294
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 09:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCYIZP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 04:25:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50636 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgCYIZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 04:25:15 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7398FCECCA;
        Wed, 25 Mar 2020 09:34:45 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2 2/2] Bluetooth: btusb: Read the supported features of
 Microsoft vendor extension
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200325000332.v2.2.I4e01733fa5b818028dc9188ca91438fc54aa5028@changeid>
Date:   Wed, 25 Mar 2020 09:25:13 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <32026740-96FE-4377-B5A1-2AEE324880D0@holtmann.org>
References: <20200325070336.1097-1-mcchou@chromium.org>
 <20200325000332.v2.2.I4e01733fa5b818028dc9188ca91438fc54aa5028@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This adds a new header to facilitate the opcode and packet structures of
> vendor extension(s). For now, we add only the
> HCI_VS_MSFT_Read_Supported_Features command from Microsoft vendor
> extension. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
> bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
> microsoft-defined-bluetooth-hci-events for more details.
> Upon initialization of a hci_dev, we issue a
> HCI_VS_MSFT_Read_Supported_Features command to read the supported features
> of Microsoft vendor extension if the opcode of Microsoft vendor extension
> is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
> bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
> hci_vs_msft_read_supported_features for more details.
> This was verified on a device with Intel ThhunderPeak BT controller where
> the Microsoft vendor extension features are 0x000000000000003f.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> Changes in v2:
> - Issue a HCI_VS_MSFT_Read_Supported_Features command with
> __hci_cmd_sync() instead of constructing a request.
> 
> drivers/bluetooth/btusb.c          |  3 ++
> include/net/bluetooth/hci_core.h   |  4 ++
> include/net/bluetooth/vendor_hci.h | 51 +++++++++++++++++++
> net/bluetooth/hci_core.c           | 78 ++++++++++++++++++++++++++++++
> 4 files changed, 136 insertions(+)
> create mode 100644 include/net/bluetooth/vendor_hci.h
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 4c49f394f174..410d50dbd4e2 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -3738,6 +3738,9 @@ static int btusb_probe(struct usb_interface *intf,
> 	hdev->notify = btusb_notify;
> 
> 	hdev->msft_ext.opcode = HCI_OP_NOP;
> +	hdev->msft_ext.features = 0;
> +	hdev->msft_ext.evt_prefix_len = 0;
> +	hdev->msft_ext.evt_prefix = NULL;

as noted in the other review, let hci_alloc_dev and hci_free_dev deal with this.

> 
> #ifdef CONFIG_PM
> 	err = btusb_config_oob_wake(hdev);
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 0ec3d9b41d81..f2876c5067a4 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -30,6 +30,7 @@
> 
> #include <net/bluetooth/hci.h>
> #include <net/bluetooth/hci_sock.h>
> +#include <net/bluetooth/vendor_hci.h>
> 
> /* HCI priority */
> #define HCI_PRIO_MAX	7
> @@ -246,6 +247,9 @@ struct amp_assoc {
> 
> struct msft_vnd_ext {
> 	__u16	opcode;
> +	__u64	features;
> +	__u8	evt_prefix_len;
> +	void	*evt_prefix;
> };
> 
> struct hci_dev {
> diff --git a/include/net/bluetooth/vendor_hci.h b/include/net/bluetooth/vendor_hci.h
> new file mode 100644
> index 000000000000..89a6795e672c
> --- /dev/null
> +++ b/include/net/bluetooth/vendor_hci.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * BlueZ - Bluetooth protocol stack for Linux
> + * Copyright (C) 2020 Google Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation;
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
> + * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
> + * IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
> + * CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + *
> + * ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
> + * COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
> + * SOFTWARE IS DISCLAIMED.
> + */
> +
> +#ifndef __VENDOR_HCI_H
> +#define __VENDOR_HCI_H
> +
> +#define MSFT_EVT_PREFIX_MAX_LEN			255
> +
> +struct msft_cmd_cmp_info {
> +	__u8 status;
> +	__u8 sub_opcode;
> +} __packed;
> +
> +/* Microsoft Vendor HCI subcommands */
> +#define MSFT_OP_READ_SUPPORTED_FEATURES		0x00
> +#define MSFT_FEATURE_MASK_RSSI_MONITOR_BREDR_CONN	0x0000000000000001
> +#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_CONN		0x0000000000000002
> +#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_ADV		0x0000000000000004
> +#define MSFT_FEATURE_MASK_ADV_MONITOR_LE_ADV		0x0000000000000008
> +#define MSFT_FEATURE_MASK_VERIFY_CURVE			0x0000000000000010
> +#define MSFT_FEATURE_MASK_CONCURRENT_ADV_MONITOR	0x0000000000000020
> +struct msft_cp_read_supported_features {
> +	__u8 sub_opcode;
> +} __packed;
> +struct msft_rp_read_supported_features {
> +	__u64 features;
> +	__u8  evt_prefix_len;
> +	__u8  evt_prefix[0];
> +} __packed;
> +
> +#endif /* __VENDOR_HCI_H */

Lets put this all in net/bluetooth/msft.c for now.

> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index dbd2ad3a26ed..1ea32d10ed08 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1407,6 +1407,76 @@ static void hci_dev_get_bd_addr_from_property(struct hci_dev *hdev)
> 	bacpy(&hdev->public_addr, &ba);
> }
> 
> +static void process_msft_vnd_ext_cmd_complete(struct hci_dev *hdev,
> +					      struct sk_buff *skb)
> +{
> +	struct msft_cmd_cmp_info *info = (void *)skb->data;
> +	const u8 status = info->status;
> +	const u16 sub_opcode = __le16_to_cpu(info->sub_opcode);
> +
> +	skb_pull(skb, sizeof(*info));
> +
> +	if (IS_ERR(skb)) {
> +		BT_WARN("%s: Microsoft extension response packet invalid",
> +			hdev->name);
> +		return;
> +	}
> +
> +	if (status) {
> +		BT_WARN("%s: Microsoft extension sub command 0x%2.2x failed",
> +			hdev->name, sub_opcode);
> +		return;
> +	}
> +
> +	BT_DBG("%s: status 0x%2.2x sub opcode 0x%2.2x", hdev->name, status,
> +	       sub_opcode);
> +
> +	switch (sub_opcode) {
> +	case MSFT_OP_READ_SUPPORTED_FEATURES: {
> +		struct msft_rp_read_supported_features *rp = (void *)skb->data;
> +		u8 prefix_len = rp->evt_prefix_len;
> +
> +		hdev->msft_ext.features = __le64_to_cpu(rp->features);
> +		hdev->msft_ext.evt_prefix_len = prefix_len;
> +		hdev->msft_ext.evt_prefix = kmalloc(prefix_len, GFP_ATOMIC);

Are we really in interrupt context here? I don’t think there is a need for GFP_ATOMIC.

> +		if (!hdev->msft_ext.evt_prefix) {
> +			BT_WARN("%s: Microsoft extension invalid event prefix",
> +				hdev->name);

Please start using bt_dev_warn etc.

> +			return;
> +		}
> +
> +		memcpy(hdev->msft_ext.evt_prefix, rp->evt_prefix, prefix_len);
> +		BT_INFO("%s: Microsoft extension features 0x%016llx",
> +			hdev->name, hdev->msft_ext.features);
> +		break;
> +	}
> +	default:
> +		BT_WARN("%s: Microsoft extension unknown sub opcode 0x%2.2x",
> +			hdev->name, sub_opcode);
> +		break;
> +	}
> +}
> +
> +static void read_vendor_extension_features(struct hci_dev *hdev)
> +{
> +	struct sk_buff *skb;
> +	const u16 msft_opcode = hdev->msft_ext.opcode;
> +
> +	if (msft_opcode !=  HCI_OP_NOP) {

I really prefer it this way

	if (!something_supported)
		return;

> +		struct msft_cp_read_supported_features cp;
> +
> +		cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
> +		skb = __hci_cmd_sync(hdev, msft_opcode, sizeof(cp), &cp,
> +				     HCI_CMD_TIMEOUT);
> +
> +		process_msft_vnd_ext_cmd_complete(hdev, skb);
> +		if (skb) {
> +			kfree_skb(skb);
> +			skb = NULL;
> +		}
> +	}
> +}
> +
> static int hci_dev_do_open(struct hci_dev *hdev)
> {
> 	int ret = 0;
> @@ -1554,6 +1624,11 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> 		}
> 	}
> 
> +	/* Check features supported by HCI extensions after the init procedure
> +	 * completed.
> +	 */
> +	read_vendor_extension_features(hdev);
> +

	msft_do_open(hdev);


> 	/* If the HCI Reset command is clearing all diagnostic settings,
> 	 * then they need to be reprogrammed after the init procedure
> 	 * completed.
> @@ -1733,6 +1808,9 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 			cancel_delayed_work_sync(&adv_instance->rpa_expired_cb);
> 	}
> 
> +	kfree(hdev->msft_ext.evt_prefix);
> +	hdev->msft_ext.evt_prefix = NULL;
> +

	msft_do_close(hdev);


And let these two function clear, init, free etc. everything except hdev->msft_ext.opcode

That said, I would actually also introduce a wrapper msft_set_opcode(hdev, opcode); so that the driver doesn’t have to know the internal on how that opcode is stored.

We can also keep the struct msft_ext internal to msft.c and don’t have to expose the internal details. So all stay confined in net/bluetooth/msft.c.

> 	/* Avoid potential lockdep warnings from the *_flush() calls by
> 	 * ensuring the workqueue is empty up front.
> 	 */

Regards

Marcel

