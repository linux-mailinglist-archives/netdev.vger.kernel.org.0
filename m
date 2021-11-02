Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3671A4428E1
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhKBHyS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Nov 2021 03:54:18 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54886 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhKBHyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 03:54:16 -0400
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 50A05CECE9;
        Tue,  2 Nov 2021 08:51:38 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v7 1/2] Bluetooth: Add struct of reading AOSP vendor
 capabilities
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
Date:   Tue, 2 Nov 2021 08:51:37 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8C7862EB-01EB-463E-AC20-AF1D8BCC1FFB@holtmann.org>
References: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch adds the struct of reading AOSP vendor capabilities.
> New capabilities are added incrementally. Note that the
> version_supported octets will be used to determine whether a
> capability has been defined for the version.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> 
> ---
> 
> Changes in v7:
> - Use the full struct aosp_rp_le_get_vendor_capa. If the
>  version_supported is >= 98, check bluetooth_quality_report_support.
> - Use __le16 and __le32.
> - Use proper bt_dev_err and bt_dev_warn per review comments.
> - Skip unnecessary bt_dev_dbg.
> - Remove unnecessary rp->status check.
> - Skip unnecessary check about version_supported on versions that we
>  do not care about. For now, we only care about quality report support.
> - Add the define for the length of the struct.
> - Mediatek will submit a separate patch to enable aosp.
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
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/aosp.c             | 83 +++++++++++++++++++++++++++++++-
> 2 files changed, 83 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 53a8c7d3a4bf..b5f061882c10 100644
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
> index a1b7762335a5..0d4f1702ce35 100644
> --- a/net/bluetooth/aosp.c
> +++ b/net/bluetooth/aosp.c
> @@ -8,9 +8,43 @@
> 
> #include "aosp.h"
> 
> +/* Command complete parameters of LE_Get_Vendor_Capabilities_Command
> + * The parameters grow over time. The base version that declares the
> + * version_supported field is v0.95. Refer to
> + * https://cs.android.com/android/platform/superproject/+/master:system/
> + *         bt/gd/hci/controller.cc;l=452?q=le_get_vendor_capabilities_handler
> + */
> +struct aosp_rp_le_get_vendor_capa {
> +	/* v0.95: 15 octets */
> +	__u8	status;
> +	__u8	max_advt_instances;
> +	__u8	offloaded_resolution_of_private_address;
> +	__le16	total_scan_results_storage;
> +	__u8	max_irk_list_sz;
> +	__u8	filtering_support;
> +	__u8	max_filter;
> +	__u8	activity_energy_info_support;
> +	__le16	version_supported;
> +	__le16	total_num_of_advt_tracked;
> +	__u8	extended_scan_support;
> +	__u8	debug_logging_supported;
> +	/* v0.96: 16 octets */
> +	__u8	le_address_generation_offloading_support;
> +	/* v0.98: 21 octets */
> +	__le32	a2dp_source_offload_capability_mask;
> +	__u8	bluetooth_quality_report_support;
> +	/* v1.00: 25 octets */
> +	__le32	dynamic_audio_buffer_support;
> +} __packed;
> +
> +#define VENDOR_CAPA_BASE_SIZE		15
> +#define VENDOR_CAPA_0_98_SIZE		21
> +
> void aosp_do_open(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	struct aosp_rp_le_get_vendor_capa *rp;
> +	u16 version_supported;
> 
> 	if (!hdev->aosp_capable)
> 		return;
> @@ -20,9 +54,56 @@ void aosp_do_open(struct hci_dev *hdev)
> 	/* LE Get Vendor Capabilities Command */
> 	skb = __hci_cmd_sync(hdev, hci_opcode_pack(0x3f, 0x153), 0, NULL,
> 			     HCI_CMD_TIMEOUT);
> -	if (IS_ERR(skb))
> +	if (IS_ERR(skb)) {
> +		bt_dev_err(hdev, "AOSP get vendor capabilities (%ld)",
> +			   PTR_ERR(skb));
> 		return;
> +	}
> +
> +	/* A basic length check */
> +	if (skb->len < VENDOR_CAPA_BASE_SIZE)
> +		goto length_error;
> +
> +	rp = (struct aosp_rp_le_get_vendor_capa *)skb->data;
> +
> +	version_supported = le16_to_cpu(rp->version_supported);
> +	/* AOSP displays the verion number like v0.98, v1.00, etc. */
> +	bt_dev_info(hdev, "AOSP version v%u.%02u",
> +		    version_supported >> 8, version_supported & 0xff);

call it "AOSP extensions ..” to not confused it with the AOSP release version. I can also fix myself before applying if you like.

> +
> +	/* Do not support very old versions. */
> +	if (version_supported < 95) {
> +		bt_dev_warn(hdev, "AOSP capabilities version %u too old",
> +			    version_supported);
> +		goto done;
> +	}
> +
> +	if (version_supported >= 95 && version_supported < 98) {
> +		bt_dev_warn(hdev, "AOSP quality report is not supported");
> +		goto done;
> +	}

I think you are bit too pedantic. Not that this bad in general, but you already established that your are >= 95 with the check above. So not need to repeat that here.

> +
> +	if (version_supported >= 98) {

Same here. You already established that you are >= 98 with the check above.

> +		if (skb->len < VENDOR_CAPA_0_98_SIZE)
> +			goto length_error;
> +
> +		/* The bluetooth_quality_report_support is defined at version
> +		 * v0.98. Refer to
> +		 * https://cs.android.com/android/platform/superproject/+/
> +		 *         master:system/bt/gd/hci/controller.cc;l=477
> +		 */
> +		if (rp->bluetooth_quality_report_support) {
> +			hdev->aosp_quality_report = true;
> +			bt_dev_info(hdev, "AOSP quality report is supported");
> +		}
> +	}
> +
> +	goto done;
> +
> +length_error:
> +	bt_dev_err(hdev, "AOSP capabilities length %d too short", skb->len);
> 
> +done:
> 	kfree_skb(skb);
> }

Rest looks great. Either send me a new version or I fix it before applying.

Regards

Marcel

