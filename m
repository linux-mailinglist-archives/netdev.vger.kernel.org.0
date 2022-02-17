Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B04BA067
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbiBQMxu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Feb 2022 07:53:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiBQMxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:53:47 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77D1610FD9;
        Thu, 17 Feb 2022 04:53:32 -0800 (PST)
Received: from smtpclient.apple (p4fefcd07.dip0.t-ipconnect.de [79.239.205.7])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4E357CECDE;
        Thu, 17 Feb 2022 13:53:31 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH v4 2/3] Bluetooth: btintel: surface Intel telemetry events
 through mgmt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220215213519.v4.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
Date:   Thu, 17 Feb 2022 13:53:30 +0100
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@google.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FCAB9F47-39D4-4564-A0E6-530F79AF5B5B@holtmann.org>
References: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
 <20220215213519.v4.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jospeh,

> When receiving a HCI vendor event, the kernel checks if it is an
> Intel telemetry event. If yes, the event is sent to bluez user
> space through the mgmt socket.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> (no changes since v3)
> 
> Changes in v3:
> - Move intel_vendor_evt() from hci_event.c to the btintel driver.
> 
> Changes in v2:
> - Drop the pull_quality_report_data function from hci_dev.
>  Do not bother hci_dev with it. Do not bleed the details
>  into the core.
> 
> drivers/bluetooth/btintel.c      | 37 +++++++++++++++++++++++++++++++-
> drivers/bluetooth/btintel.h      |  7 ++++++
> include/net/bluetooth/hci_core.h |  2 ++
> net/bluetooth/hci_event.c        | 12 +++++++++++
> 4 files changed, 57 insertions(+), 1 deletion(-)

I don’t like intermixing core additions with driver implementations of it. I thought that I have mentioned this a few times, but maybe I missed that in the last review round. So first introduce the callbacks and the handling in hci_core etc. and then provide a patch for the driver using it.

> 
> diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
> index 06514ed66022..c7732da2752f 100644
> --- a/drivers/bluetooth/btintel.c
> +++ b/drivers/bluetooth/btintel.c
> @@ -2401,9 +2401,12 @@ static int btintel_setup_combined(struct hci_dev *hdev)
> 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> 	set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> 
> -	/* Set up the quality report callback for Intel devices */
> +	/* Set up the quality report callbacks for Intel devices */
> 	hdev->set_quality_report = btintel_set_quality_report;
> 
> +	/* Set up the vendor specific callback for Intel devices */
> +	hdev->vendor_evt = btintel_vendor_evt;
> +
> 	/* For Legacy device, check the HW platform value and size */
> 	if (skb->len == sizeof(ver) && skb->data[1] == 0x37) {
> 		bt_dev_dbg(hdev, "Read the legacy Intel version information");
> @@ -2650,6 +2653,38 @@ void btintel_secure_send_result(struct hci_dev *hdev,
> }
> EXPORT_SYMBOL_GPL(btintel_secure_send_result);
> 
> +#define INTEL_PREFIX		0x8087
> +#define TELEMETRY_CODE		0x03
> +
> +struct intel_prefix_evt_data {
> +	__le16 vendor_prefix;
> +	__u8 code;
> +	__u8 data[];   /* a number of struct intel_tlv subevents */
> +} __packed;
> +
> +static bool is_quality_report_evt(struct sk_buff *skb)
> +{
> +	struct intel_prefix_evt_data *ev;
> +	u16 vendor_prefix;
> +
> +	if (skb->len < sizeof(struct intel_prefix_evt_data))
> +		return false;
> +
> +	ev = (struct intel_prefix_evt_data *)skb->data;
> +	vendor_prefix = __le16_to_cpu(ev->vendor_prefix);
> +
> +	return vendor_prefix == INTEL_PREFIX && ev->code == TELEMETRY_CODE;
> +}
> +
> +void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb)
> +{
> +	/* Only interested in the telemetry event for now. */
> +	if (hdev->set_quality_report && is_quality_report_evt(skb))
> +		mgmt_quality_report(hdev, skb->data, skb->len,
> +				    QUALITY_SPEC_INTEL_TELEMETRY);

You can not do that. Keep the interaction with hci_dev as limited as possible. I think it would be best to introduce a hci_recv_quality_report function that drivers can call.

And really don’t bother with all these check. Dissect the vendor event, if it is a quality report, then just report it via that callback. And you should be stripping off the prefix etc. Just report the plain data.

> +}
> +EXPORT_SYMBOL_GPL(btintel_vendor_evt);
> +
> MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
> MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
> MODULE_VERSION(VERSION);
> diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
> index e0060e58573c..82dc278b09eb 100644
> --- a/drivers/bluetooth/btintel.h
> +++ b/drivers/bluetooth/btintel.h
> @@ -211,6 +211,7 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
> void btintel_secure_send_result(struct hci_dev *hdev,
> 				const void *ptr, unsigned int len);
> int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
> +void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb);
> #else
> 
> static inline int btintel_check_bdaddr(struct hci_dev *hdev)
> @@ -306,4 +307,10 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
> {
> 	return -ENODEV;
> }
> +
> +static inline void btintel_vendor_evt(struct hci_dev *hdev,  void *data,

Double space here.

> +				      struct sk_buff *skb)
> +{
> +}
> +
> #endif
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index ea83619ac4de..3505ffe20779 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -635,6 +635,8 @@ struct hci_dev {
> 	void (*cmd_timeout)(struct hci_dev *hdev);
> 	bool (*wakeup)(struct hci_dev *hdev);
> 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
> +	void (*vendor_evt)(struct hci_dev *hdev, void *data,
> +			   struct sk_buff *skb);

So I do not understand the void *data portion. Just hand down the skb.

> 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
> 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
> 				     struct bt_codec *codec, __u8 *vnd_len,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6468ea0f71bd..e34dea0f0c2e 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4250,6 +4250,7 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
>  *       space to avoid collision.
>  */
> static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
> +static unsigned char INTEL_PREFIX[] = { 0x87, 0x80 };

This really bugs me. Intel specifics can not be here. I think we really have to push all vendor events down to the driver.

> 
> /* Some vendor prefixes are fixed values and lengths. */
> #define FIXED_EVT_PREFIX(_prefix, _vendor_func)				\
> @@ -4273,6 +4274,16 @@ static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
> 	.get_prefix_len = _prefix_len_func,				\
> }
> 
> +/* Every vendor that handles particular vendor events in its driver should
> + * 1. set up the vendor_evt callback in its driver and
> + * 2. add an entry in struct vendor_event_prefix.
> + */
> +static void vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb)
> +{
> +	if (hdev->vendor_evt)
> +		hdev->vendor_evt(hdev, data, skb);
> +}
> +
> /* Every distinct vendor specification must have a well-defined vendor
>  * event prefix to determine if a vendor event meets the specification.
>  * If an event prefix is fixed, it should be delcared with FIXED_EVT_PREFIX.
> @@ -4287,6 +4298,7 @@ struct vendor_event_prefix {
> 	__u8 (*get_prefix_len)(struct hci_dev *hdev);
> } evt_prefixes[] = {
> 	FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
> +	FIXED_EVT_PREFIX(INTEL_PREFIX, vendor_evt),
> 	DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
> 			   msft_vendor_evt),

Regards

Marcel

