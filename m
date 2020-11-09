Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C169F2AB822
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbgKIMX3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Nov 2020 07:23:29 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:50303 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKIMX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:23:29 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id BDBFBCECC5;
        Mon,  9 Nov 2020 13:30:34 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v7 1/5] Bluetooth: Interleave with allowlist scan
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Date:   Mon, 9 Nov 2020 13:23:25 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FF6167B4-85B3-465E-9B7D-5985E1013341@holtmann.org>
References: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch implements the interleaving between allowlist scan and
> no-filter scan. It'll be used to save power when at least one monitor is
> registered and at least one pending connection or one device to be
> scanned for.
> 
> The durations of the allowlist scan and the no-filter scan are
> controlled by MGMT command: Set Default System Configuration. The
> default values are set randomly for now.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> ---
> 
> Changes in v7:
> - Fix bt_dev_warn argument type warning
> 
> Changes in v6:
> - Set parameter EnableAdvMonInterleaveScan to 1 byte long
> 
> Changes in v5:
> - Rename 'adv_monitor' from many functions/variables
> - Move __hci_update_interleaved_scan into hci_req_add_le_passive_scan
> - Update the logic of update_adv_monitor_scan_state
> 
> Changes in v4:
> - Rebase to bluetooth-next/master (previous 2 patches are applied)
> - Fix over 80 chars limit in mgmt_config.c
> - Set EnableAdvMonInterleaveScan default to Disable
> 
> Changes in v3:
> - Remove 'Bluez' prefix
> 
> Changes in v2:
> - remove 'case 0x001c' in mgmt_config.c
> 
> include/net/bluetooth/hci_core.h |  10 +++
> net/bluetooth/hci_core.c         |   4 +
> net/bluetooth/hci_request.c      | 136 +++++++++++++++++++++++++++++--
> net/bluetooth/mgmt_config.c      |  10 +++
> 4 files changed, 153 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 9873e1c8cd163..cfede18709d8f 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -361,6 +361,8 @@ struct hci_dev {
> 	__u8		ssp_debug_mode;
> 	__u8		hw_error_code;
> 	__u32		clock;
> +	__u16		advmon_allowlist_duration;
> +	__u16		advmon_no_filter_duration;
> 
> 	__u16		devid_source;
> 	__u16		devid_vendor;
> @@ -542,6 +544,14 @@ struct hci_dev {
> 	struct delayed_work	rpa_expired;
> 	bdaddr_t		rpa;
> 
> +	enum {
> +		INTERLEAVE_SCAN_NONE,
> +		INTERLEAVE_SCAN_NO_FILTER,
> +		INTERLEAVE_SCAN_ALLOWLIST
> +	} interleave_scan_state;
> +
> +	struct delayed_work	interleave_scan;
> +
> #if IS_ENABLED(CONFIG_BT_LEDS)
> 	struct led_trigger	*power_led;
> #endif
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 502552d6e9aff..65b7b74baba4c 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3592,6 +3592,10 @@ struct hci_dev *hci_alloc_dev(void)
> 	hdev->cur_adv_instance = 0x00;
> 	hdev->adv_instance_timeout = 0;
> 
> +	/* The default values will be chosen in the future */
> +	hdev->advmon_allowlist_duration = 300;
> +	hdev->advmon_no_filter_duration = 500;
> +
> 	hdev->sniff_max_interval = 800;
> 	hdev->sniff_min_interval = 80;
> 
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 6f12bab4d2fa6..70ea126f56282 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -378,6 +378,58 @@ void __hci_req_write_fast_connectable(struct hci_request *req, bool enable)
> 		hci_req_add(req, HCI_OP_WRITE_PAGE_SCAN_TYPE, 1, &type);
> }
> 
> +static void start_interleave_scan(struct hci_dev *hdev)
> +{
> +	hdev->interleave_scan_state = INTERLEAVE_SCAN_NO_FILTER;
> +	queue_delayed_work(hdev->req_workqueue,
> +			   &hdev->interleave_scan, 0);
> +}
> +
> +static bool is_interleave_scanning(struct hci_dev *hdev)
> +{
> +	return hdev->interleave_scan_state != INTERLEAVE_SCAN_NONE;
> +}
> +
> +static void cancel_interleave_scan(struct hci_dev *hdev)
> +{
> +	bt_dev_dbg(hdev, "%s cancelling interleave scan", hdev->name);
> +
> +	cancel_delayed_work_sync(&hdev->interleave_scan);
> +
> +	hdev->interleave_scan_state = INTERLEAVE_SCAN_NONE;
> +}
> +
> +/* Return true if interleave_scan wasn't started until exiting this function,
> + * otherwise, return false
> + */
> +static bool __hci_update_interleaved_scan(struct hci_dev *hdev)
> +{
> +	if (hci_is_adv_monitoring(hdev) &&
> +	    !(list_empty(&hdev->pend_le_conns) &&
> +	      list_empty(&hdev->pend_le_reports))) {
> +		if (!is_interleave_scanning(hdev)) {

This extra indentation is rather useless here. Just do another &&.

> +			/* If there is at least one ADV monitors and one pending
> +			 * LE connection or one device to be scanned for, we
> +			 * should alternate between allowlist scan and one
> +			 * without any filters to save power.
> +			 */
> +			start_interleave_scan(hdev);
> +			bt_dev_dbg(hdev, "%s starting interleave scan",
> +				   hdev->name);
> +			return true;
> +		}
> +	}
> +
> +	if (is_interleave_scanning(hdev)) {
> +		/* If the interleave condition no longer holds, cancel
> +		 * the existed interleave scan.
> +		 */
> +		cancel_interleave_scan(hdev);
> +	}
> +

I am also a bit awkward code.

Frankly you could check for is_interleave_scanning is true first and then
just leave the function. Don’t make this whole function more complicated
than needed.

> +	return false;
> +}
> +
> /* This function controls the background scanning based on hdev->pend_le_conns
>  * list. If there are pending LE connection we start the background scanning,
>  * otherwise we stop it.
> @@ -450,8 +502,8 @@ static void __hci_update_background_scan(struct hci_request *req)
> 			hci_req_add_le_scan_disable(req, false);
> 
> 		hci_req_add_le_passive_scan(req);
> -
> -		BT_DBG("%s starting background scanning", hdev->name);
> +		bt_dev_dbg(hdev, "%s starting background scanning",
> +			   hdev->name);
> 	}
> }

I would prefer if you find these, then do them as a cleanup patch. And then
also skip the whole hdev->name parameter altogether since that is for
bt_dev_dbg to do.

> @@ -844,12 +896,17 @@ static u8 update_white_list(struct hci_request *req)
> 			return 0x00;
> 	}
> 
> -	/* Once the controller offloading of advertisement monitor is in place,
> -	 * the if condition should include the support of MSFT extension
> -	 * support. If suspend is ongoing, whitelist should be the default to
> -	 * prevent waking by random advertisements.
> +	/* Use the allowlist unless the following conditions are all true:
> +	 * - We are not currently suspending
> +	 * - There are 1 or more ADV monitors registered
> +	 * - Interleaved scanning is not currently using the allowlist
> +	 *
> +	 * Once the controller offloading of advertisement monitor is in place,
> +	 * the above condition should include the support of MSFT extension
> +	 * support.
> 	 */
> -	if (!idr_is_empty(&hdev->adv_monitors_idr) && !hdev->suspended)
> +	if (!idr_is_empty(&hdev->adv_monitors_idr) && !hdev->suspended &&
> +	    hdev->interleave_scan_state != INTERLEAVE_SCAN_ALLOWLIST)
> 		return 0x00;
> 
> 	/* Select filter policy to use white list */
> @@ -1002,6 +1059,10 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
> 				      &own_addr_type))
> 		return;
> 
> +	if (__hci_update_interleaved_scan(hdev))
> +		return;
> +
> +	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
> 	/* Adding or removing entries from the white list must
> 	 * happen before enabling scanning. The controller does
> 	 * not allow white list modification while scanning.
> @@ -1871,6 +1932,64 @@ static void adv_timeout_expire(struct work_struct *work)
> 	hci_dev_unlock(hdev);
> }
> 
> +static int hci_req_add_le_interleaved_scan(struct hci_request *req,
> +					   unsigned long opt)
> +{
> +	struct hci_dev *hdev = req->hdev;
> +	int ret = 0;
> +
> +	hci_dev_lock(hdev);
> +
> +	if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
> +		hci_req_add_le_scan_disable(req, false);
> +	hci_req_add_le_passive_scan(req);
> +
> +	switch (hdev->interleave_scan_state) {
> +	case INTERLEAVE_SCAN_ALLOWLIST:
> +		bt_dev_dbg(hdev, "next state: allowlist");
> +		hdev->interleave_scan_state = INTERLEAVE_SCAN_NO_FILTER;
> +		break;
> +	case INTERLEAVE_SCAN_NO_FILTER:
> +		bt_dev_dbg(hdev, "next state: no filter");
> +		hdev->interleave_scan_state = INTERLEAVE_SCAN_ALLOWLIST;
> +		break;
> +	case INTERLEAVE_SCAN_NONE:

Is this also an error or should it just be ignored?

> +	default:

And is default really needed?

> +		BT_ERR("unexpected error");
> +		ret = -1;
> +	}
> +
> +	hci_dev_unlock(hdev);
> +
> +	return ret;
> +}
> +
> +static void interleave_scan_work(struct work_struct *work)
> +{
> +	struct hci_dev *hdev = container_of(work, struct hci_dev,
> +					    interleave_scan.work);
> +	u8 status;
> +	unsigned long timeout;
> +
> +	if (hdev->interleave_scan_state == INTERLEAVE_SCAN_ALLOWLIST) {
> +		timeout = msecs_to_jiffies(hdev->advmon_allowlist_duration);
> +	} else if (hdev->interleave_scan_state == INTERLEAVE_SCAN_NO_FILTER) {
> +		timeout = msecs_to_jiffies(hdev->advmon_no_filter_duration);
> +	} else {
> +		bt_dev_err(hdev, "unexpected error");
> +		return;
> +	}
> +
> +	hci_req_sync(hdev, hci_req_add_le_interleaved_scan, 0,
> +		     HCI_CMD_TIMEOUT, &status);
> +
> +	/* Don't continue interleaving if it was canceled */
> +	if (is_interleave_scanning(hdev)) {
> +		queue_delayed_work(hdev->req_workqueue,
> +				   &hdev->interleave_scan, timeout);
> +	}

This one should not use { }.

> +}
> +
> int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
> 			   bool use_rpa, struct adv_info *adv_instance,
> 			   u8 *own_addr_type, bdaddr_t *rand_addr)
> @@ -3298,6 +3417,7 @@ void hci_request_setup(struct hci_dev *hdev)
> 	INIT_DELAYED_WORK(&hdev->le_scan_disable, le_scan_disable_work);
> 	INIT_DELAYED_WORK(&hdev->le_scan_restart, le_scan_restart_work);
> 	INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
> +	INIT_DELAYED_WORK(&hdev->interleave_scan, interleave_scan_work);
> }
> 
> void hci_request_cancel_all(struct hci_dev *hdev)
> @@ -3317,4 +3437,6 @@ void hci_request_cancel_all(struct hci_dev *hdev)
> 		cancel_delayed_work_sync(&hdev->adv_instance_expire);
> 		hdev->adv_instance_timeout = 0;
> 	}
> +
> +	cancel_interleave_scan(hdev);
> }
> diff --git a/net/bluetooth/mgmt_config.c b/net/bluetooth/mgmt_config.c
> index b30b571f8caf8..2d3ad288c78ac 100644
> --- a/net/bluetooth/mgmt_config.c
> +++ b/net/bluetooth/mgmt_config.c
> @@ -67,6 +67,8 @@ int read_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
> 		HDEV_PARAM_U16(0x001a, le_supv_timeout),
> 		HDEV_PARAM_U16_JIFFIES_TO_MSECS(0x001b,
> 						def_le_autoconnect_timeout),
> +		HDEV_PARAM_U16(0x001d, advmon_allowlist_duration),
> +		HDEV_PARAM_U16(0x001e, advmon_no_filter_duration),
> 	};
> 	struct mgmt_rp_read_def_system_config *rp = (void *)params;
> 
> @@ -138,6 +140,8 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
> 		case 0x0019:
> 		case 0x001a:
> 		case 0x001b:
> +		case 0x001d:
> +		case 0x001e:
> 			if (len != sizeof(u16)) {
> 				bt_dev_warn(hdev, "invalid length %d, exp %zu for type %d",
> 					    len, sizeof(u16), type);
> @@ -251,6 +255,12 @@ int set_def_system_config(struct sock *sk, struct hci_dev *hdev, void *data,
> 			hdev->def_le_autoconnect_timeout =
> 					msecs_to_jiffies(TLV_GET_LE16(buffer));
> 			break;
> +		case 0x0001d:
> +			hdev->advmon_allowlist_duration = TLV_GET_LE16(buffer);
> +			break;
> +		case 0x0001e:
> +			hdev->advmon_no_filter_duration = TLV_GET_LE16(buffer);
> +			break;
> 		default:
> 			bt_dev_warn(hdev, "unsupported parameter %u", type);
> 			break;

Regards

Marcel

