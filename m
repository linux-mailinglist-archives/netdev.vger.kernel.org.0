Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3DE198742
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgC3WS4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Mar 2020 18:18:56 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50691 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgC3WSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 18:18:55 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7EE2FCECB0;
        Tue, 31 Mar 2020 00:28:26 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Bluez PATCH v1] bluetooth: set advertising intervals
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200330153143.Bluez.v1.1.Id488d4a31aa751827c55c79ca20033013156ea0a@changeid>
Date:   Tue, 31 Mar 2020 00:18:53 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <13AE955C-1C23-4FE5-8BD3-44AA0C21520E@holtmann.org>
References: <20200330153143.Bluez.v1.1.Id488d4a31aa751827c55c79ca20033013156ea0a@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch supports specification of advertising intervals in
> bluetooth kernel subsystem.
> 
> A new set_advertising_intervals mgmt handler is added to support
> the new mgmt opcode MGMT_OP_SET_ADVERTISING_INTERVALS. The
> min_interval and max_interval are simply recorded in hdev struct.
> 
> The intervals together with other advertising parameters would be
> sent to the controller before advertising is enabled in the procedure
> of registering an advertisement.
> 
> In cases that advertising has been enabled before
> set_advertising_intervals is invoked, it would re-enable advertising
> to make the intervals take effect. This is less preferable since
> bluetooth core specification states that the parameters should be set
> before advertising is enabled. However, the advertising re-enabling
> feature is kept since it might be useful in multi-advertisements.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
> 
> include/net/bluetooth/hci.h      |   1 +
> include/net/bluetooth/hci_core.h |  11 +++
> include/net/bluetooth/mgmt.h     |   8 ++
> net/bluetooth/hci_core.c         |   4 +-
> net/bluetooth/mgmt.c             | 147 +++++++++++++++++++++++++++++++
> 5 files changed, 169 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 5f60e135aeb6..4877289b0f95 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -278,6 +278,7 @@ enum {
> 	HCI_LE_ENABLED,
> 	HCI_ADVERTISING,
> 	HCI_ADVERTISING_CONNECTABLE,
> +	HCI_ADVERTISING_INTERVALS,

this is not needed.

> 	HCI_CONNECTABLE,
> 	HCI_DISCOVERABLE,
> 	HCI_LIMITED_DISCOVERABLE,
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index d4e28773d378..a3a23e2daa64 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -220,6 +220,17 @@ struct adv_info {
> #define HCI_MAX_ADV_INSTANCES		5
> #define HCI_DEFAULT_ADV_DURATION	2
> 
> +/*
> + * Refer to BLUETOOTH SPECIFICATION Version 5.2 [Vol 4, Part E]
> + * Section 7.8.5 about
> + * - the default min/max intervals, and
> + * - the valid range of min/max intervals.
> + */
> +#define HCI_DEFAULT_LE_ADV_MIN_INTERVAL	0x0800
> +#define HCI_DEFAULT_LE_ADV_MAX_INTERVAL	0x0800
> +#define HCI_VALID_LE_ADV_MIN_INTERVAL	0x0020
> +#define HCI_VALID_LE_ADV_MAX_INTERVAL	0x4000
> +
> #define HCI_MAX_SHORT_NAME_LENGTH	10
> 
> /* Min encryption key size to match with SMP */
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index f41cd87550dc..32a21f77260e 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -103,6 +103,7 @@ struct mgmt_rp_read_index_list {
> #define MGMT_SETTING_STATIC_ADDRESS	0x00008000
> #define MGMT_SETTING_PHY_CONFIGURATION	0x00010000
> #define MGMT_SETTING_WIDEBAND_SPEECH	0x00020000
> +#define MGMT_SETTING_ADVERTISING_INTERVALS	0x00040000

And this here is also not needed. The settings parameter is not a good choice here.

> 
> #define MGMT_OP_READ_INFO		0x0004
> #define MGMT_READ_INFO_SIZE		0
> @@ -674,6 +675,13 @@ struct mgmt_cp_set_blocked_keys {
> 
> #define MGMT_OP_SET_WIDEBAND_SPEECH	0x0047
> 
> +#define MGMT_OP_SET_ADVERTISING_INTERVALS	0x0048

Use MGMT_OP_SET_ADV_INTERVAL here. It is a single interval actually.

> +struct mgmt_cp_set_advertising_intervals {
> +	__le16	min_interval;
> +	__le16	max_interval;
> +} __packed;
> +#define MGMT_SET_ADVERTISING_INTERVALS_SIZE	4
> +
> #define MGMT_EV_CMD_COMPLETE		0x0001
> struct mgmt_ev_cmd_complete {
> 	__le16	opcode;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 2e7bc2da8371..34ed8a11991d 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3382,8 +3382,8 @@ struct hci_dev *hci_alloc_dev(void)
> 	hdev->sniff_min_interval = 80;
> 
> 	hdev->le_adv_channel_map = 0x07;
> -	hdev->le_adv_min_interval = 0x0800;
> -	hdev->le_adv_max_interval = 0x0800;
> +	hdev->le_adv_min_interval = HCI_DEFAULT_LE_ADV_MIN_INTERVAL;
> +	hdev->le_adv_max_interval = HCI_DEFAULT_LE_ADV_MAX_INTERVAL;
> 	hdev->le_scan_interval = 0x0060;
> 	hdev->le_scan_window = 0x0030;
> 	hdev->le_conn_min_interval = 0x0018;
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 6552003a170e..235fff7b14cc 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -108,6 +108,7 @@ static const u16 mgmt_commands[] = {
> 	MGMT_OP_SET_APPEARANCE,
> 	MGMT_OP_SET_BLOCKED_KEYS,
> 	MGMT_OP_SET_WIDEBAND_SPEECH,
> +	MGMT_OP_SET_ADVERTISING_INTERVALS,
> };
> 
> static const u16 mgmt_events[] = {
> @@ -775,6 +776,7 @@ static u32 get_supported_settings(struct hci_dev *hdev)
> 		settings |= MGMT_SETTING_SECURE_CONN;
> 		settings |= MGMT_SETTING_PRIVACY;
> 		settings |= MGMT_SETTING_STATIC_ADDRESS;
> +		settings |= MGMT_SETTING_ADVERTISING_INTERVALS;
> 	}
> 
> 	if (test_bit(HCI_QUIRK_EXTERNAL_CONFIG, &hdev->quirks) ||
> @@ -854,6 +856,9 @@ static u32 get_current_settings(struct hci_dev *hdev)
> 	if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
> 		settings |= MGMT_SETTING_WIDEBAND_SPEECH;
> 
> +	if (hci_dev_test_flag(hdev, HCI_ADVERTISING_INTERVALS))
> +		settings |= MGMT_SETTING_ADVERTISING_INTERVALS;
> +

Please scrap all of this.

> 	return settings;
> }
> 
> @@ -4768,6 +4773,147 @@ static int set_fast_connectable(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> +static void set_advertising_intervals_complete(struct hci_dev *hdev,
> +					       u8 status, u16 opcode)
> +{
> +	struct cmd_lookup match = { NULL, hdev };
> +	struct hci_request req;
> +	u8 instance;
> +	struct adv_info *adv_instance;
> +	int err;
> +
> +	hci_dev_lock(hdev);
> +
> +	if (status) {
> +		u8 mgmt_err = mgmt_status(status);
> +
> +		mgmt_pending_foreach(MGMT_OP_SET_ADVERTISING_INTERVALS, hdev,
> +				     cmd_status_rsp, &mgmt_err);
> +		goto unlock;
> +	}
> +
> +	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
> +		hci_dev_set_flag(hdev, HCI_ADVERTISING);
> +	else
> +		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
> +
> +	mgmt_pending_foreach(MGMT_OP_SET_ADVERTISING_INTERVALS, hdev,
> +			     settings_rsp, &match);
> +
> +	new_settings(hdev, match.sk);
> +
> +	if (match.sk)
> +		sock_put(match.sk);
> +
> +	/* If "Set Advertising" was just disabled and instance advertising was
> +	 * set up earlier, then re-enable multi-instance advertising.
> +	 */
> +	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
> +	    list_empty(&hdev->adv_instances))
> +		goto unlock;
> +
> +	instance = hdev->cur_adv_instance;
> +	if (!instance) {
> +		adv_instance = list_first_entry_or_null(&hdev->adv_instances,
> +							struct adv_info, list);
> +		if (!adv_instance)
> +			goto unlock;
> +
> +		instance = adv_instance->instance;
> +	}
> +
> +	hci_req_init(&req, hdev);
> +
> +	err = __hci_req_schedule_adv_instance(&req, instance, true);
> +	if (!err)
> +		err = hci_req_run(&req, enable_advertising_instance);
> +	else
> +		BT_ERR("Failed to re-configure advertising intervals");
> +
> +unlock:
> +	hci_dev_unlock(hdev);
> +}
> +
> +static int _reenable_advertising(struct sock *sk, struct hci_dev *hdev,
> +				 void *data, u16 len)
> +{
> +	struct mgmt_pending_cmd *cmd;
> +	struct hci_request req;
> +	int err;
> +
> +	if (pending_find(MGMT_OP_SET_ADVERTISING_INTERVALS, hdev)) {
> +		return mgmt_cmd_status(sk, hdev->id,
> +				       MGMT_OP_SET_ADVERTISING_INTERVALS,
> +				       MGMT_STATUS_BUSY);
> +	}
> +
> +	cmd = mgmt_pending_add(sk, MGMT_OP_SET_ADVERTISING_INTERVALS, hdev,
> +			       data, len);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	hci_req_init(&req, hdev);
> +	cancel_adv_timeout(hdev);
> +
> +	/* Switch to instance "0" for the Set Advertising setting.
> +	 * We cannot use update_[adv|scan_rsp]_data() here as the
> +	 * HCI_ADVERTISING flag is not yet set.
> +	 */
> +	hdev->cur_adv_instance = 0x00;
> +	/* This function disables advertising before enabling it. */
> +	__hci_req_enable_advertising(&req);
> +
> +	err = hci_req_run(&req, set_advertising_intervals_complete);
> +	if (err < 0)
> +		mgmt_pending_remove(cmd);
> +
> +	return err;
> +}
> +
> +static int set_advertising_intervals(struct sock *sk, struct hci_dev *hdev,
> +				     void *data, u16 len)
> +{
> +	struct mgmt_cp_set_advertising_intervals *cp = data;
> +	int err;
> +
> +	BT_DBG("%s", hdev->name);
> +
> +	/* This method is intended for LE devices only.*/
> +	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED))
> +		return mgmt_cmd_status(sk, hdev->id,
> +				       MGMT_OP_SET_ADVERTISING_INTERVALS,
> +				       MGMT_STATUS_REJECTED);
> +
> +	/* Check the validity of the intervals. */
> +	if (cp->min_interval < HCI_VALID_LE_ADV_MIN_INTERVAL ||
> +	    cp->max_interval > HCI_VALID_LE_ADV_MAX_INTERVAL ||
> +	    cp->min_interval > cp->max_interval) {
> +		return mgmt_cmd_status(sk, hdev->id,
> +				       MGMT_OP_SET_ADVERTISING_INTERVALS,
> +				       MGMT_STATUS_INVALID_PARAMS);
> +	}
> +
> +	hci_dev_lock(hdev);
> +
> +	hci_dev_set_flag(hdev, HCI_ADVERTISING_INTERVALS);
> +	hdev->le_adv_min_interval = cp->min_interval;
> +	hdev->le_adv_max_interval = cp->max_interval;
> +
> +	/* Re-enable advertising only when it is already on. */
> +	if (hci_dev_test_flag(hdev, HCI_LE_ADV)) {
> +		err = _reenable_advertising(sk, hdev, data, len);
> +		goto unlock;
> +	}
> +
> +	err = send_settings_rsp(sk, MGMT_OP_SET_ADVERTISING_INTERVALS, hdev);
> +	new_settings(hdev, sk);

This is more like the Set Scan Parameters command. We don’t return settings here.

> +
> +unlock:
> +	hci_dev_unlock(hdev);
> +
> +	return err;
> +}
> +
> static void set_bredr_complete(struct hci_dev *hdev, u8 status, u16 opcode)
> {
> 	struct mgmt_pending_cmd *cmd;
> @@ -7099,6 +7245,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
> 	{ set_blocked_keys,	   MGMT_OP_SET_BLOCKED_KEYS_SIZE,
> 						HCI_MGMT_VAR_LEN },
> 	{ set_wideband_speech,	   MGMT_SETTING_SIZE },
> +	{ set_advertising_intervals, MGMT_SET_ADVERTISING_INTERVALS_SIZE },
> };
> 
> void mgmt_index_added(struct hci_dev *hdev)

As stated by Luiz, in general we better have this all per instance. However I would not object to introduce a really simple mgmt command that just allows to modify the default advertising interval via mgmt (I think it is already possible via debugfs at the moment).

I am fine with this, since I think we eventually require an Add Extended Advertising command that will get more complex and will also take time to define and test correctly.

Regards

Marcel

