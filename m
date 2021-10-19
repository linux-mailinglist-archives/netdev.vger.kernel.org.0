Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8496433F9B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 22:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhJSUKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Oct 2021 16:10:13 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:53894 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbhJSUKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 16:10:10 -0400
Received: from smtpclient.apple (p54899aa7.dip0.t-ipconnect.de [84.137.154.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5AF3ACED08;
        Tue, 19 Oct 2021 22:07:54 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v5 1/3] Bluetooth: Add struct of reading AOSP vendor
 capabilities
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211019200701.v5.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
Date:   Tue, 19 Oct 2021 22:07:53 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        pali@kernel.org, josephsih@google.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <72F09687-C2CB-44F5-8C44-7697B65A5348@holtmann.org>
References: <20211019200701.v5.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
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
> Changes in v5:
> - This is a new patch.
> - Add struct aosp_rp_le_get_vendor_capabilities so that next patch
>  can determine whether a particular capability is supported or not.
> 
> net/bluetooth/aosp.c | 45 +++++++++++++++++++++++++++++++++++++++++---
> 1 file changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
> index a1b7762335a5..3f0ea57a68de 100644
> --- a/net/bluetooth/aosp.c
> +++ b/net/bluetooth/aosp.c
> @@ -8,9 +8,32 @@
> 
> #include "aosp.h"
> 
> +#define AOSP_OP_LE_GET_VENDOR_CAPABILITIES	0x153

I rather have the hci_opcode_pack(0x3f, 0x153) here.

> +struct aosp_rp_le_get_vendor_capabilities {
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
> +	__u8	le_address_generation_offloading_support;
> +	__u32	a2dp_source_offload_capability_mask;
> +	__u8	bluetooth_quality_report_support;
> +	__u32	dynamic_audio_buffer_support;
> +} __packed;

So as far as I recall, the original struct was smaller. Google started to add new fields over time.

> +
> void aosp_do_open(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	struct aosp_rp_le_get_vendor_capabilities *rp;
> +	u16 opcode;
> +	u16 version_supported;
> 
> 	if (!hdev->aosp_capable)
> 		return;
> @@ -18,10 +41,26 @@ void aosp_do_open(struct hci_dev *hdev)
> 	bt_dev_dbg(hdev, "Initialize AOSP extension");
> 
> 	/* LE Get Vendor Capabilities Command */
> -	skb = __hci_cmd_sync(hdev, hci_opcode_pack(0x3f, 0x153), 0, NULL,
> -			     HCI_CMD_TIMEOUT);
> -	if (IS_ERR(skb))
> +	opcode = hci_opcode_pack(0x3f, AOSP_OP_LE_GET_VENDOR_CAPABILITIES);
> +	skb = __hci_cmd_sync(hdev, opcode, 0, NULL, HCI_CMD_TIMEOUT);
> +	if (IS_ERR(skb)) {
> +		bt_dev_warn(hdev, "AOSP get vendor capabilities (%ld)",
> +			    PTR_ERR(skb));
> +		return;
> +	}
> +
> +	bt_dev_info(hdev, "aosp le vendor capabilities length %d", skb->len);

This is not a bt_dev_info.

> +
> +	rp = (struct aosp_rp_le_get_vendor_capabilities *)skb->data;
> +
> +	if (rp->status) {
> +		bt_dev_err(hdev, "AOSP LE Get Vendor Capabilities status %d",
> +			   rp->status);
> 		return;
> +	}
> +
> +	version_supported = le16_to_cpu(rp->version_supported);
> +	bt_dev_info(hdev, "AOSP version 0x%4.4x", version_supported);

You need to check the supported version for basic length of the struct and then also bluetooth_quality_report_support details.

Regards

Marcel

