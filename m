Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08049EC4E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbiA0ULx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jan 2022 15:11:53 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38190 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiA0ULx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:11:53 -0500
Received: from smtpclient.apple (p4ff9fc34.dip0.t-ipconnect.de [79.249.252.52])
        by mail.holtmann.org (Postfix) with ESMTPSA id 61E98CED25;
        Thu, 27 Jan 2022 21:11:51 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH v2 2/2] Bluetooth: btintel: surface Intel telemetry events
 through mgmt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220127181738.v2.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
Date:   Thu, 27 Jan 2022 21:11:50 +0100
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
Message-Id: <05486302-58D8-464D-A276-552DF63E9C57@holtmann.org>
References: <20220127181738.v2.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
 <20220127181738.v2.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
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
> Changes in v2:
> - Drop the pull_quality_report_data function from hci_dev.
>  Do not bother hci_dev with it. Do not bleed the details
>  into the core.
> 
> drivers/bluetooth/btintel.c      | 27 ++++++++++++++++++++++++++-
> drivers/bluetooth/btintel.h      |  7 +++++++
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_event.c        | 12 ++++++++++++
> 4 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
> index 1a4f8b227eac..9e1fdb68b669 100644
> --- a/drivers/bluetooth/btintel.c
> +++ b/drivers/bluetooth/btintel.c
> @@ -2401,8 +2401,9 @@ static int btintel_setup_combined(struct hci_dev *hdev)
> 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> 	set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> 
> -	/* Set up the quality report callback for Intel devices */
> +	/* Set up the quality report callbacks for Intel devices */
> 	hdev->set_quality_report = btintel_set_quality_report;
> +	hdev->is_quality_report_evt = btintel_is_quality_report_evt;
> 
> 	/* For Legacy device, check the HW platform value and size */
> 	if (skb->len == sizeof(ver) && skb->data[1] == 0x37) {
> @@ -2645,6 +2646,30 @@ void btintel_secure_send_result(struct hci_dev *hdev,
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
> +bool btintel_is_quality_report_evt(struct sk_buff *skb)
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
> +EXPORT_SYMBOL_GPL(btintel_is_quality_report_evt);
> +
> MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
> MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
> MODULE_VERSION(VERSION);
> diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
> index c9b24e9299e2..6dd4695b8b86 100644
> --- a/drivers/bluetooth/btintel.h
> +++ b/drivers/bluetooth/btintel.h
> @@ -210,6 +210,7 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
> void btintel_secure_send_result(struct hci_dev *hdev,
> 				const void *ptr, unsigned int len);
> int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
> +bool btintel_is_quality_report_evt(struct sk_buff *skb);
> #else
> 
> static inline int btintel_check_bdaddr(struct hci_dev *hdev)
> @@ -305,4 +306,10 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
> {
> 	return -ENODEV;
> }
> +
> +static inline bool btintel_is_quality_report_evt(struct sk_buff *skb)
> +{
> +	return false;
> +}
> +
> #endif
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index b726fd595895..9d855ac1cb29 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -632,6 +632,7 @@ struct hci_dev {
> 	void (*cmd_timeout)(struct hci_dev *hdev);
> 	bool (*wakeup)(struct hci_dev *hdev);
> 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
> +	bool (*is_quality_report_evt)(struct sk_buff *skb);
> 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
> 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
> 				     struct bt_codec *codec, __u8 *vnd_len,
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 1b69d3efd415..892a48d2f6be 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4238,6 +4238,16 @@ static void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
> 				    QUALITY_SPEC_AOSP_BQR);
> }
> 
> +static void intel_vendor_evt(struct hci_dev *hdev,  void *data,
> +			     struct sk_buff *skb)
> +{
> +	/* Only interested in the telemetry event for now. */
> +	if (hdev->set_quality_report &&
> +	    hdev->is_quality_report_evt && hdev->is_quality_report_evt(skb))
> +		mgmt_quality_report(hdev, skb->data, skb->len,
> +				    QUALITY_SPEC_INTEL_TELEMETRY);
> +}
> +

this is not workable like this. Intel specific stuff has to stay out of net/bluetooth/. Frankly I am also confused why this is this way in the first place.

So if a driver sets aosp_capable, then we can check the AOSP range and hand it to net/bluetooth/aosp.c for further processing. For the MSFT extensions, we can already map them accordingly due to the event prefix. And everything other event has to go to the driver as raw event to do whatever it wants with it.

Regards

Marcel

