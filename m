Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1DC496641
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiAUUQL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 15:16:11 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:45621 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiAUUQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:16:10 -0500
Received: from smtpclient.apple (p4fefca45.dip0.t-ipconnect.de [79.239.202.69])
        by mail.holtmann.org (Postfix) with ESMTPSA id BF3C6CED16;
        Fri, 21 Jan 2022 21:16:06 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH v1 1/2] Bluetooth: aosp: surface AOSP quality report
 through mgmt
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220121192152.v1.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
Date:   Fri, 21 Jan 2022 21:16:06 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
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
Message-Id: <5728C674-E467-4955-AEDC-6FFB05A9D869@holtmann.org>
References: <20220121192152.v1.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> When receiving a HCI vendor event, the kernel checks if it is an
> AOSP bluetooth quality report. If yes, the event is sent to bluez
> user space through the mgmt socket.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> include/net/bluetooth/hci_core.h |  2 ++
> include/net/bluetooth/mgmt.h     |  7 ++++
> net/bluetooth/aosp.c             | 61 ++++++++++++++++++++++++++++++++
> net/bluetooth/aosp.h             | 12 +++++++
> net/bluetooth/hci_event.c        | 33 ++++++++++++++++-
> net/bluetooth/mgmt.c             | 22 ++++++++++++
> 6 files changed, 136 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 21eadb113a31..727cb9c056b2 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -1861,6 +1861,8 @@ int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
> int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
> void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
> 				  bdaddr_t *bdaddr, u8 addr_type);
> +int mgmt_quality_report(struct hci_dev *hdev, struct sk_buff *skb,
> +			u8 quality_spec);
> 
> u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
> 		      u16 to_multiplier);
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index 99266f7aebdc..6a0fcb3aef8a 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -1120,3 +1120,10 @@ struct mgmt_ev_adv_monitor_device_lost {
> 	__le16 monitor_handle;
> 	struct mgmt_addr_info addr;
> } __packed;
> +
> +#define MGMT_EV_QUALITY_REPORT			0x0031
> +struct mgmt_ev_quality_report {
> +	__u8 quality_spec;
> +	__u8 data_len;
> +	__u8 data[0];
> +} __packed;
> diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
> index 432ae3aac9e3..9e3551627ad5 100644
> --- a/net/bluetooth/aosp.c
> +++ b/net/bluetooth/aosp.c
> @@ -199,3 +199,64 @@ int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
> 	else
> 		return disable_quality_report(hdev);
> }
> +
> +#define BLUETOOTH_QUALITY_REPORT_EV		0x58
> +struct bqr_data {
> +	__u8 quality_report_id;
> +	__u8 packet_type;
> +	__le16 conn_handle;
> +	__u8 conn_role;
> +	__s8 tx_power_level;
> +	__s8 rssi;
> +	__u8 snr;
> +	__u8 unused_afh_channel_count;
> +	__u8 afh_select_unideal_channel_count;
> +	__le16 lsto;
> +	__le32 conn_piconet_clock;
> +	__le32 retransmission_count;
> +	__le32 no_rx_count;
> +	__le32 nak_count;
> +	__le32 last_tx_ack_timestamp;
> +	__le32 flow_off_count;
> +	__le32 last_flow_on_timestamp;
> +	__le32 buffer_overflow_bytes;
> +	__le32 buffer_underflow_bytes;
> +
> +	/* Vendor Specific Parameter */
> +	__u8 vsp[0];
> +} __packed;
> +
> +struct aosp_hci_vs_data {
> +	__u8 code;
> +	__u8 data[0];
> +} __packed;

unless you need these two for something, scrap them. You can define constants for the size check.

> +
> +bool aosp_is_quality_report_evt(struct sk_buff *skb)
> +{
> +	struct aosp_hci_vs_data *ev;
> +
> +	if (skb->len < sizeof(struct aosp_hci_vs_data))
> +		return false;
> +
> +	ev = (struct aosp_hci_vs_data *)skb->data;
> +
> +	return ev->code == BLUETOOTH_QUALITY_REPORT_EV;
> +}
> +
> +bool aosp_pull_quality_report_data(struct sk_buff *skb)
> +{
> +	size_t bqr_data_len = sizeof(struct bqr_data);
> +
> +	skb_pull(skb, sizeof(struct aosp_hci_vs_data));
> +
> +	/* skb->len is allowed to be larger than bqr_data_len to have
> +	 * the Vendor Specific Parameter (vsp) field.
> +	 */
> +	if (skb->len < bqr_data_len) {
> +		BT_ERR("AOSP evt data len %d too short (%u expected)",
> +		       skb->len, bqr_data_len);
> +		return false;
> +	}
> +
> +	return true;
> +}

This part I find a bit convoluted, just do a basic length check and then move on. The kernel has no interest in this data.

> diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
> index 2fd8886d51b2..49894a995647 100644
> --- a/net/bluetooth/aosp.h
> +++ b/net/bluetooth/aosp.h
> @@ -10,6 +10,8 @@ void aosp_do_close(struct hci_dev *hdev);
> 
> bool aosp_has_quality_report(struct hci_dev *hdev);
> int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
> +bool aosp_is_quality_report_evt(struct sk_buff *skb);
> +bool aosp_pull_quality_report_data(struct sk_buff *skb);
> 
> #else
> 
> @@ -26,4 +28,14 @@ static inline int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
> 	return -EOPNOTSUPP;
> }
> 
> +static inline bool aosp_is_quality_report_evt(struct sk_buff *skb)
> +{
> +	return false;
> +}
> +
> +static inline bool aosp_pull_quality_report_data(struct sk_buff *skb)
> +{
> +	return false;
> +}
> +
> #endif
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 681c623aa380..bccb659a9454 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -37,6 +37,7 @@
> #include "smp.h"
> #include "msft.h"
> #include "eir.h"
> +#include "aosp.h"
> 
> #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
> 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
> @@ -4225,6 +4226,36 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
> 	queue_work(hdev->workqueue, &hdev->tx_work);
> }
> 
> +#define QUALITY_SPEC_NA			0x0
> +#define QUALITY_SPEC_INTEL_TELEMETRY	0x1
> +#define QUALITY_SPEC_AOSP_BQR		0x2
> +
> +static bool quality_report_evt(struct hci_dev *hdev,  void *data,
> +			       struct sk_buff *skb)
> +{
> +	if (aosp_is_quality_report_evt(skb)) {
> +		if (aosp_has_quality_report(hdev) &&
> +		    aosp_pull_quality_report_data(skb))
> +			mgmt_quality_report(hdev, skb, QUALITY_SPEC_AOSP_BQR);
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void hci_vendor_evt(struct hci_dev *hdev, void *data,
> +			   struct sk_buff *skb)
> +{
> +	/* Every distinct vendor specification must have a well-defined
> +	 * condition to determine if an event meets the specification.
> +	 * The skb is consumed by a specification only if the event meets
> +	 * the specification.
> +	 */
> +	if (!quality_report_evt(hdev, data, skb))
> +		msft_vendor_evt(hdev, data, skb);
> +}

No, not like this. This gets messy really quickly.

We should allow for defining vendor event prefixes here. That AOSP decided to convolute the space 0x54 and above in unfortunate, but that is what we have to deal with.

> +
> static void hci_mode_change_evt(struct hci_dev *hdev, void *data,
> 				struct sk_buff *skb)
> {
> @@ -6811,7 +6842,7 @@ static const struct hci_ev {
> 	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
> 	       sizeof(struct hci_ev_num_comp_blocks)),
> 	/* [0xff = HCI_EV_VENDOR] */
> -	HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
> +	HCI_EV(HCI_EV_VENDOR, hci_vendor_evt, 0),
> };
> 
> static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 08d6494f1b34..78687ae885be 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -4389,6 +4389,28 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
> 			       MGMT_STATUS_NOT_SUPPORTED);
> }
> 
> +int mgmt_quality_report(struct hci_dev *hdev, struct sk_buff *skb,
> +			u8 quality_spec)
> +{
> +	struct mgmt_ev_quality_report *ev;
> +	size_t ev_len;
> +	int err;
> +
> +	/* The ev comes with a variable-length data field. */
> +	ev_len = sizeof(*ev) + skb->len;
> +	ev = kmalloc(ev_len, GFP_KERNEL);
> +	if (!ev)
> +		return -ENOMEM;
> +
> +	ev->quality_spec = quality_spec;
> +	ev->data_len = skb->len;
> +	memcpy(ev->data, skb->data, skb->len);
> +	err = mgmt_event(MGMT_EV_QUALITY_REPORT, hdev, ev, ev_len, NULL);
> +	kfree(ev);
> +
> +	return err;
> +}
> +

Don’t we have mgmt helper functions that allow us to add headers to a mgmt skb. I think there is really no point in allocating memory via kmalloc.

Regards

Marcel

