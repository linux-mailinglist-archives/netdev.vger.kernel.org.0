Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247601986FD
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgC3WIv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Mar 2020 18:08:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36355 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbgC3WIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 18:08:45 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id BA211CECB0;
        Tue, 31 Mar 2020 00:18:16 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v4 2/2] Bluetooth: btusb: Read the supported features of
 Microsoft vendor extension
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200328004507.v4.2.Ic59b637deef8e646f6599a80c9a2aa554f919e55@changeid>
Date:   Tue, 31 Mar 2020 00:08:43 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1FA9284F-C8DD-40A3-81A7-65AC6DE1E3C5@holtmann.org>
References: <20200328074632.21907-1-mcchou@chromium.org>
 <20200328004507.v4.2.Ic59b637deef8e646f6599a80c9a2aa554f919e55@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This defines opcode and packet structures of Microsoft vendor extension.
> For now, we add only the HCI_VS_MSFT_Read_Supported_Features command. See
> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> microsoft-defined-bluetooth-hci-commands-and-events#microsoft-defined-
> bluetooth-hci-events for more details.
> Upon initialization of a hci_dev, we issue a
> HCI_VS_MSFT_Read_Supported_Features command to read the supported features
> of Microsoft vendor extension if the opcode of Microsoft vendor extension
> is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
> bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
> hci_vs_msft_read_supported_features for more details.
> This was verified on a device with Intel ThunderPeak BT controller where
> the Microsoft vendor extension features are 0x000000000000003f.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> Changes in v4:
> - Move MSFT's do_open() and do_close() from net/bluetooth/hci_core.c to
> net/bluetooth/msft.c.
> - Other than msft opcode, define struct msft_data to host the rest of
> information of Microsoft extension and leave a void* pointing to a
> msft_data in struct hci_dev.
> 
> Changes in v3:
> - Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().
> 
> Changes in v2:
> - Issue a HCI_VS_MSFT_Read_Supported_Features command with
> __hci_cmd_sync() instead of constructing a request.
> 
> include/net/bluetooth/hci_core.h |   1 +
> net/bluetooth/hci_core.c         |   5 ++
> net/bluetooth/hci_event.c        |   5 ++
> net/bluetooth/msft.c             | 126 +++++++++++++++++++++++++++++++
> net/bluetooth/msft.h             |  10 +++
> 5 files changed, 147 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 239cae2d9998..59ddcd3a52cc 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -486,6 +486,7 @@ struct hci_dev {
> 
> #if IS_ENABLED(CONFIG_BT_MSFTEXT)
> 	__u16			msft_opcode;
> +	void			*msft_data;
> #endif
> 
> 	int (*open)(struct hci_dev *hdev);
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index dbd2ad3a26ed..c38707de767a 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -44,6 +44,7 @@
> #include "hci_debugfs.h"
> #include "smp.h"
> #include "leds.h"
> +#include "msft.h"
> 
> static void hci_rx_work(struct work_struct *work);
> static void hci_cmd_work(struct work_struct *work);
> @@ -1563,6 +1564,8 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> 	    hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
> 		ret = hdev->set_diag(hdev, true);
> 
> +	msft_do_open(hdev);
> +
> 	clear_bit(HCI_INIT, &hdev->flags);
> 
> 	if (!ret) {
> @@ -1758,6 +1761,8 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 
> 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
> 
> +	msft_do_close(hdev);
> +
> 	if (hdev->flush)
> 		hdev->flush(hdev);
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 20408d386268..42b5871151a6 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -35,6 +35,7 @@
> #include "a2mp.h"
> #include "amp.h"
> #include "smp.h"
> +#include "msft.h"
> 
> #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
> 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
> @@ -6144,6 +6145,10 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
> 		hci_num_comp_blocks_evt(hdev, skb);
> 		break;
> 
> +	case HCI_EV_VENDOR:
> +		msft_vendor_evt(hdev, skb);
> +		break;
> +
> 	default:
> 		BT_DBG("%s event 0x%2.2x", hdev->name, event);
> 		break;
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index 7609932c48ca..f76e4c79556e 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -6,6 +6,24 @@
> 
> #include "msft.h"
> 
> +#define MSFT_OP_READ_SUPPORTED_FEATURES		0x00
> +struct msft_cp_read_supported_features {
> +	__u8   sub_opcode;
> +} __packed;
> +struct msft_rp_read_supported_features {
> +	__u8   status;
> +	__u8   sub_opcode;
> +	__le64 features;
> +	__u8   evt_prefix_len;
> +	__u8   evt_prefix[0];
> +} __packed;
> +
> +struct msft_data {
> +	__u64 features;
> +	__u8  evt_prefix_len;
> +	__u8  *evt_prefix;
> +};
> +
> void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
> {
> 	hdev->msft_opcode = opcode;
> @@ -14,3 +32,111 @@ void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
> 		    hdev->msft_opcode);
> }
> EXPORT_SYMBOL(msft_set_opcode);
> +
> +static struct msft_data *read_supported_features(struct hci_dev *hdev)
> +{
> +	struct msft_data *msft;

I used a second parameter, but yes, my initial code was totally flawed with the msft_data access.

> +	struct msft_cp_read_supported_features cp;
> +	struct msft_rp_read_supported_features *rp;
> +	struct sk_buff *skb;
> +
> +	cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
> +
> +	skb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
> +			     HCI_CMD_TIMEOUT);
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "Failed to read MSFT supported features (%ld)",
> +			   PTR_ERR(skb));
> +		return NULL;
> +	}
> +
> +	if (skb->len < sizeof(*rp)) {
> +		bt_dev_err(hdev, "MSFT supported features length mismatch");
> +		goto failed;
> +	}
> +
> +	rp = (struct msft_rp_read_supported_features *)skb->data;
> +
> +	if (rp->sub_opcode != MSFT_OP_READ_SUPPORTED_FEATURES)
> +		goto failed;
> +
> +	msft = kzalloc(sizeof(*msft), GFP_KERNEL);
> +	if (!msft)
> +		goto failed;
> +
> +	if (rp->evt_prefix_len > 0) {
> +		msft->evt_prefix = kmemdup(rp->evt_prefix, rp->evt_prefix_len,
> +					   GFP_KERNEL);
> +		if (!msft->evt_prefix)
> +			goto failed;
> +	}
> +
> +	msft->evt_prefix_len = rp->evt_prefix_len;
> +	msft->features = __le64_to_cpu(rp->features);
> +	kfree_skb(skb);
> +
> +	bt_dev_info(hdev, "MSFT supported features %llx", msft->features);
> +	return msft;
> +
> +failed:
> +	kfree_skb(skb);
> +	return NULL;
> +}
> +
> +void msft_do_open(struct hci_dev *hdev)
> +{
> +	if (hdev->msft_opcode == HCI_OP_NOP)
> +		return;
> +
> +	bt_dev_dbg(hdev, "Initialize MSFT extension");
> +	hdev->msft_data = read_supported_features(hdev);
> +}
> +
> +void msft_do_close(struct hci_dev *hdev)
> +{
> +	struct msft_data *msft = hdev->msft_data;
> +
> +	if (!msft)
> +		return;
> +
> +	bt_dev_dbg(hdev, "Cleanup of MSFT extension");
> +
> +	hdev->msft_data = NULL;
> +
> +	kfree(msft->evt_prefix);
> +	kfree(msft);
> +}
> +
> +int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
> +{

So this was on purpose void. There is no point in returning any feedback from this function. It either handles the event or it doesn’t. The caller function doesn’t care.

> +	struct msft_data *msft = hdev->msft_data;
> +	u8 event;
> +
> +	if (!msft)
> +		return -ENOSYS;
> +
> +	/* When the extension has defined an event prefix, check that it
> +	 * matches, and otherwise just return.
> +	 */
> +	if (msft->evt_prefix_len > 0) {
> +		if (skb->len < msft->evt_prefix_len)
> +			return -ENOSYS;
> +
> +		if (memcmp(skb->data, msft->evt_prefix, msft->evt_prefix_len))
> +			return -ENOSYS;
> +
> +		skb_pull(skb, msft->evt_prefix_len);
> +	}
> +
> +	/* Every event starts at least with an event code and the rest of
> +	 * the data is variable and depends on the event code. Returns true
> +	 */
> +	if (skb->len < 1)
> +		return -EBADMSG;
> +
> +	event = *skb->data;
> +	skb_pull(skb, 1);
> +
> +	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
> +	return 0;
> +}
> diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> index 7218ea759dde..6a7d0ac6c66c 100644
> --- a/net/bluetooth/msft.h
> +++ b/net/bluetooth/msft.h
> @@ -4,15 +4,25 @@
> #ifndef __MSFT_H
> #define __MSFT_H
> 
> +#include <linux/errno.h>
> #include <net/bluetooth/hci_core.h>
> 
> #if IS_ENABLED(CONFIG_BT_MSFTEXT)
> 
> void msft_set_opcode(struct hci_dev *hdev, __u16 opcode);
> +void msft_do_open(struct hci_dev *hdev);
> +void msft_do_close(struct hci_dev *hdev);
> +int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
> 
> #else
> 
> static inline void msft_set_opcode(struct hci_dev *hdev, __u16 opcode) {}
> +static inline void msft_do_open(struct hci_dev *hdev) {}
> +static inline void msft_do_close(struct hci_dev *hdev) {}
> +static inline int msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
> +{
> +	return -ENOSYS;
> +}
> 
> #endif

Regards

Marcel

