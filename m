Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A98439755
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhJYNUg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Oct 2021 09:20:36 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50199 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhJYNUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:20:35 -0400
Received: from smtpclient.apple (p4ff9f2d2.dip0.t-ipconnect.de [79.249.242.210])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6FA05CED18;
        Mon, 25 Oct 2021 15:18:11 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v6 1/3] Bluetooth: Add struct of reading AOSP vendor
 capabilities
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211021230356.v6.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
Date:   Mon, 25 Oct 2021 15:18:11 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        pali@kernel.org, chromeos-bluetooth-upstreaming@chromium.org,
        josephsih@google.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4E4ECD59-527D-4FDB-8EF8-21BC99FDE8D8@holtmann.org>
References: <20211021230356.v6.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jospeh,

> This patch adds the struct of reading AOSP vendor capabilities.
> New capabilities are added incrementally. Note that the
> version_supported octets will be used to determine whether a
> capability has been defined for the version.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> 
> ---
> 
> Changes in v6:
> - Add historical versions of struct aosp_rp_le_get_vendor_capabilities.
> - Perform the basic check about the struct length.
> - Through the version, bluetooth_quality_report_support can be checked.
> 
> Changes in v5:
> - This is a new patch.
> - Add struct aosp_rp_le_get_vendor_capabilities so that next patch
>  can determine whether a particular capability is supported or not.
> 
> include/net/bluetooth/hci_core.h |   1 +
> net/bluetooth/aosp.c             | 116 ++++++++++++++++++++++++++++++-
> 2 files changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index dd8840e70e25..32b3774227f2 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -603,6 +603,7 @@ struct hci_dev {
> 
> #if IS_ENABLED(CONFIG_BT_AOSPEXT)
> 	bool			aosp_capable;
> +	bool			aosp_quality_report;
> #endif
> 
> 	int (*open)(struct hci_dev *hdev);
> diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
> index a1b7762335a5..64684b2bf79b 100644
> --- a/net/bluetooth/aosp.c
> +++ b/net/bluetooth/aosp.c
> @@ -8,9 +8,53 @@
> 
> #include "aosp.h"
> 
> +/* Command complete parameters of LE_Get_Vendor_Capabilities_Command
> + * The parameters grow over time. The first version that declares the
> + * version_supported field is v0.95. Refer to
> + * https://cs.android.com/android/platform/superproject/+/master:system/
> + *         bt/gd/hci/controller.cc;l=452?q=le_get_vendor_capabilities_handler
> + */
> +
> +/* the base capabilities struct with the version_supported field */
> +struct aosp_rp_le_get_vendor_capa_v95 {
> +	__u8	status;
> +	__u8	max_advt_instances;
> +	__u8	offloaded_resolution_of_private_address;
> +	__u16	total_scan_results_storage;
> +	__u8	max_irk_list_sz;
> +	__u8	filtering_support;
> +	__u8	max_filter;
> +	__u8	activity_energy_info_support;
> +	__u16	version_supported;
> +	__u16	total_num_of_advt_tracked;
> +	__u8	extended_scan_support;
> +	__u8	debug_logging_supported;
> +} __packed;
> +
> +struct aosp_rp_le_get_vendor_capa_v96 {
> +	struct aosp_rp_le_get_vendor_capa_v95 v95;
> +	/* v96 */
> +	__u8	le_address_generation_offloading_support;
> +} __packed;
> +
> +struct aosp_rp_le_get_vendor_capa_v98 {
> +	struct aosp_rp_le_get_vendor_capa_v96 v96;
> +	/* v98 */
> +	__u32	a2dp_source_offload_capability_mask;
> +	__u8	bluetooth_quality_report_support;
> +} __packed;
> +
> +struct aosp_rp_le_get_vendor_capa_v100 {
> +	struct aosp_rp_le_get_vendor_capa_v98 v98;
> +	/* v100 */
> +	__u32	dynamic_audio_buffer_support;
> +} __packed;
> +

while this is an interesting idea to document the different versions, I don’t thing you need to overboard like this. Just use the full struct and make sure you check the version_supported to ensure you are not reading beyond the bounds of your result.

Meaning you can have a struct pointer point to smaller memory, just make sure you never access it if it is not there. So I would just add defines for the different versions and their length of the struct.

Oh, I might have forgotten that, you need to use __le16 and __le32 to indicate the endianness of the data on the wire.

> void aosp_do_open(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	struct aosp_rp_le_get_vendor_capa_v95 *base_rp;
> +	u16 version_supported;
> 
> 	if (!hdev->aosp_capable)
> 		return;
> @@ -20,9 +64,79 @@ void aosp_do_open(struct hci_dev *hdev)
> 	/* LE Get Vendor Capabilities Command */
> 	skb = __hci_cmd_sync(hdev, hci_opcode_pack(0x3f, 0x153), 0, NULL,
> 			     HCI_CMD_TIMEOUT);
> -	if (IS_ERR(skb))
> +	if (IS_ERR(skb)) {
> +		bt_dev_warn(hdev, "AOSP get vendor capabilities (%ld)",
> +			    PTR_ERR(skb));

This is actually an error. If the driver indicates support for it, this better succeed. If not complain loudly.

> 		return;
> +	}
> +
> +	bt_dev_dbg(hdev, "aosp le vendor capabilities length %d", skb->len);

Skip this one.

Add a basic length check that you know you can get to rp->version_supported field.

> +
> +	base_rp = (struct aosp_rp_le_get_vendor_capa_v95 *)skb->data;
> +
> +	if (base_rp->status) {
> +		bt_dev_err(hdev, "AOSP LE Get Vendor Capabilities status %d",
> +			   base_rp->status);
> +		goto done;
> +	}

Actually the status is already evaluated via the __hci_cmd_sync command. No need to repeat it here.

> +
> +	version_supported = le16_to_cpu(base_rp->version_supported);
> +	bt_dev_info(hdev, "AOSP version %u", version_supported);
> +
> +	/* Do not support very old versions. */
> +	if (version_supported < 95) {
> +		bt_dev_err(hdev, "capabilities version %u too old",
> +			   version_supported);
> +		goto done;
> +	}

This is not an error. Just print a warning here. And “AOSP capabilities ..” please.

> +
> +	if (version_supported >= 95) {
> +		struct aosp_rp_le_get_vendor_capa_v95 *rp;
> +
> +		rp = (struct aosp_rp_le_get_vendor_capa_v95 *)skb->data;
> +		if (skb->len < sizeof(*rp))
> +			goto length_error;
> +	}
> +
> +	if (version_supported >= 96) {
> +		struct aosp_rp_le_get_vendor_capa_v96 *rp;
> +
> +		rp = (struct aosp_rp_le_get_vendor_capa_v96 *)skb->data;
> +		if (skb->len < sizeof(*rp))
> +			goto length_error;
> +	}

Since we don’t use any data out of these two above, skip it. If the version is less than < 0.98 we are just ignoring it. You can print a warning that "AOSP quality report is not supported”.


> +
> +	if (version_supported >= 98) {
> +		struct aosp_rp_le_get_vendor_capa_v98 *rp;
> +
> +		rp = (struct aosp_rp_le_get_vendor_capa_v98 *)skb->data;
> +		if (skb->len < sizeof(*rp))
> +			goto length_error;
> +
> +		/* The bluetooth_quality_report_support is defined at version v0.98.
> +		 * Refer to https://cs.android.com/android/platform/superproject/+/
> +		 *                  master:system/bt/gd/hci/controller.cc;l=477
> +		 */
> +		if (rp->bluetooth_quality_report_support) {
> +			hdev->aosp_quality_report = true;
> +			bt_dev_info(hdev, "bluetooth quality report is supported");
> +		}
> +	}
> +
> +	if (version_supported >= 100) {
> +		struct aosp_rp_le_get_vendor_capa_v100 *rp;
> +
> +		rp = (struct aosp_rp_le_get_vendor_capa_v100 *)skb->data;
> +		if (skb->len < sizeof(*rp))
> +			goto length_error;
> +	}

Skip that one as well. We only care about quality report support.

> +
> +	goto done;
> +
> +length_error:
> +	bt_dev_err(hdev, "AOSP capabilities length %d too short", skb->len);
> 
> +done:
> 	kfree_skb(skb);
> }

Regards

Marcel

