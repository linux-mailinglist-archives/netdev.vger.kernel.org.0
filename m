Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86853DBA92
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbhG3O1r convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Jul 2021 10:27:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41914 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhG3O1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:27:46 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 29AEBCED30;
        Fri, 30 Jul 2021 16:27:40 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v4 4/4] Bluetooth: Support the quality report events
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210618160016.v4.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
Date:   Fri, 30 Jul 2021 16:27:39 +0200
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Joseph Hwang <josephsih@google.com>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F368F697-9A10-48F3-BD03-60E60CF2E466@holtmann.org>
References: <20210618160016.v4.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
 <20210618160016.v4.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
To:     Joseph Hwang <josephsih@chromium.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

> This patch allows a user space process to enable/disable the quality
> report events dynamically through the set experimental feature mgmt
> interface if CONFIG_BT_FEATURE_QUALITY_REPORT is enabled.
> 
> Since the quality report feature needs to invoke the callback function
> provided by the driver, i.e., hdev->set_quality_report, a valid
> controller index is required.
> 
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> (no changes since v1)
> 
> include/net/bluetooth/hci.h      |   4 ++
> include/net/bluetooth/hci_core.h |  22 ++++--
> net/bluetooth/Kconfig            |  11 +++
> net/bluetooth/mgmt.c             | 118 ++++++++++++++++++++++++++++++-
> 4 files changed, 148 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index b80415011dcd..2811b60e1acc 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -331,6 +331,10 @@ enum {
> 	HCI_CMD_PENDING,
> 	HCI_FORCE_NO_MITM,
> 
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +	HCI_QUALITY_REPORT,
> +#endif
> +
> 	__HCI_NUM_FLAGS,
> };
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index a53e94459ecd..c25de25a7036 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -605,6 +605,9 @@ struct hci_dev {
> 	int (*set_bdaddr)(struct hci_dev *hdev, const bdaddr_t *bdaddr);
> 	void (*cmd_timeout)(struct hci_dev *hdev);
> 	bool (*prevent_wake)(struct hci_dev *hdev);
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
> +#endif
> };
> 
> #define HCI_PHY_HANDLE(handle)	(handle & 0xff)
> @@ -752,12 +755,19 @@ extern struct mutex hci_cb_list_lock;
> #define hci_dev_test_and_clear_flag(hdev, nr)  test_and_clear_bit((nr), (hdev)->dev_flags)
> #define hci_dev_test_and_change_flag(hdev, nr) test_and_change_bit((nr), (hdev)->dev_flags)
> 
> -#define hci_dev_clear_volatile_flags(hdev)			\
> -	do {							\
> -		hci_dev_clear_flag(hdev, HCI_LE_SCAN);		\
> -		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
> -		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
> -		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +#define hci_dev_clear_flag_quality_report(x) { hci_dev_clear_flag(hdev, x); }
> +#else
> +#define hci_dev_clear_flag_quality_report(x) {}
> +#endif
> +
> +#define hci_dev_clear_volatile_flags(hdev)				\
> +	do {								\
> +		hci_dev_clear_flag(hdev, HCI_LE_SCAN);			\
> +		hci_dev_clear_flag(hdev, HCI_LE_ADV);			\
> +		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);	\
> +		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);		\
> +		hci_dev_clear_flag_quality_report(HCI_QUALITY_REPORT)	\
> 	} while (0)
> 

we are not doing a CONFIG_BT_FEATURE_QUALITY_REPORT here then. This is getting out of control. What is the harm of always adding this feature? I don’t see a large size impact.

> /* ----- HCI interface to upper protocols ----- */
> diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
> index e0ab4cd7afc3..d63c3cdf2d6f 100644
> --- a/net/bluetooth/Kconfig
> +++ b/net/bluetooth/Kconfig
> @@ -148,4 +148,15 @@ config BT_FEATURE_DEBUG
> 	  This provides an option to enable/disable debugging statements
> 	  at runtime via the experimental features interface.
> 
> +config BT_FEATURE_QUALITY_REPORT
> +	bool "Runtime option for logging controller quality report events"
> +	depends on BT
> +	default n
> +	help
> +	  This provides an option to enable/disable controller quality report
> +	  events logging at runtime via the experimental features interface.
> +	  The quality report events may include the categories of system
> +	  exceptions, connections/disconnection, the link quality statistics,
> +	  etc.
> +
> source "drivers/bluetooth/Kconfig"
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index d1bf5a55ff85..0de089524d74 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -3791,6 +3791,14 @@ static const u8 debug_uuid[16] = {
> };
> #endif
> 
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +/* 330859bc-7506-492d-9370-9a6f0614037f */
> +static const u8 quality_report_uuid[16] = {
> +	0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
> +	0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
> +};
> +#endif
> +
> /* 671b10b5-42c0-4696-9227-eb28d1b049d6 */
> static const u8 simult_central_periph_uuid[16] = {
> 	0xd6, 0x49, 0xb0, 0xd1, 0x28, 0xeb, 0x27, 0x92,
> @@ -3806,7 +3814,7 @@ static const u8 rpa_resolution_uuid[16] = {
> static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
> 				  void *data, u16 data_len)
> {
> -	char buf[62];	/* Enough space for 3 features */
> +	char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
> 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
> 	u16 idx = 0;
> 	u32 flags;
> @@ -3850,6 +3858,26 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
> 		idx++;
> 	}
> 
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +	if (hdev) {
> +		if (hdev->set_quality_report) {
> +			/* BIT(0): indicating if set_quality_report is
> +			 * supported by controller.
> +			 */
> +			flags = BIT(0);
> +
> +			/* BIT(1): indicating if the feature is enabled. */
> +			if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
> +				flags |= BIT(1);
> +		} else {
> +			flags = 0;
> +		}
> +		memcpy(rp->features[idx].uuid, quality_report_uuid, 16);
> +		rp->features[idx].flags = cpu_to_le32(flags);
> +		idx++;
> +	}
> +#endif
> +
> 	rp->feature_count = cpu_to_le16(idx);
> 
> 	/* After reading the experimental features information, enable
> @@ -3892,6 +3920,23 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
> }
> #endif
> 
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +static int exp_quality_report_feature_changed(bool enabled, struct sock *skip)
> +{
> +	struct mgmt_ev_exp_feature_changed ev;
> +
> +	BT_INFO("enabled %d", enabled);
> +
> +	memset(&ev, 0, sizeof(ev));
> +	memcpy(ev.uuid, quality_report_uuid, 16);
> +	ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
> +
> +	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
> +				  &ev, sizeof(ev),
> +				  HCI_MGMT_EXP_FEATURE_EVENTS, skip);
> +}
> +#endif
> +
> static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
> 			   void *data, u16 data_len)
> {
> @@ -4038,6 +4083,77 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
> 		return err;
> 	}
> 
> +#ifdef CONFIG_BT_FEATURE_QUALITY_REPORT
> +	if (!memcmp(cp->uuid, quality_report_uuid, 16)) {
> +		bool val, changed;
> +		int err;
> +
> +		/* Command requires to use a valid controller index */
> +		if (!hdev)
> +			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
> +					       MGMT_OP_SET_EXP_FEATURE,
> +					       MGMT_STATUS_INVALID_INDEX);
> +
> +		/* Parameters are limited to a single octet */
> +		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
> +			return mgmt_cmd_status(sk, hdev->id,
> +					       MGMT_OP_SET_EXP_FEATURE,
> +					       MGMT_STATUS_INVALID_PARAMS);
> +
> +		/* Only boolean on/off is supported */
> +		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
> +			return mgmt_cmd_status(sk, hdev->id,
> +					       MGMT_OP_SET_EXP_FEATURE,
> +					       MGMT_STATUS_INVALID_PARAMS);

You really need somewhere here is hdev->set_quality_report is set.

> +
> +		hci_req_sync_lock(hdev);
> +
> +		val = !!cp->param[0];
> +		changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
> +
> +		if (!hdev->set_quality_report) {
> +			BT_INFO("quality report not supported");
> +			err = mgmt_cmd_status(sk, hdev->id,
> +					      MGMT_OP_SET_EXP_FEATURE,
> +					      MGMT_STATUS_NOT_SUPPORTED);
> +			goto unlock_quality_report;
> +		}
> +
> +		if (changed) {
> +			err = hdev->set_quality_report(hdev, val);
> +			if (err) {
> +				BT_ERR("set_quality_report value %d err %d",
> +				       val, err);
> +				err = mgmt_cmd_status(sk, hdev->id,
> +						      MGMT_OP_SET_EXP_FEATURE,
> +						      MGMT_STATUS_FAILED);
> +				goto unlock_quality_report;
> +			}
> +			if (val)
> +				hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
> +			else
> +				hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
> +		}
> +
> +		BT_INFO("quality report enable %d changed %d",
> +			val, changed);
> +
> +		memcpy(rp.uuid, quality_report_uuid, 16);
> +		rp.flags = cpu_to_le32(val ? BIT(0) : 0);
> +		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
> +		err = mgmt_cmd_complete(sk, hdev->id,
> +					MGMT_OP_SET_EXP_FEATURE, 0,
> +					&rp, sizeof(rp));
> +
> +		if (changed)
> +			exp_quality_report_feature_changed(val, sk);
> +
> +unlock_quality_report:
> +		hci_req_sync_unlock(hdev);
> +		return err;
> +	}
> +#endif
> +
> 	return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
> 			       MGMT_OP_SET_EXP_FEATURE,
> 			       MGMT_STATUS_NOT_SUPPORTED);

Regards

Marcel

