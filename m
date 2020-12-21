Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3B2DFA6E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgLUJtD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Dec 2020 04:49:03 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38461 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgLUJtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 04:49:02 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fab6.dip0.t-ipconnect.de [79.249.250.182])
        by mail.holtmann.org (Postfix) with ESMTPSA id D70F2CED03;
        Mon, 21 Dec 2020 10:16:51 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3 2/5] Bluetooth: advmon offload MSFT add monitor
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201216123317.v3.2.I4969a334028027df34dab9740cd16bbce278633c@changeid>
Date:   Mon, 21 Dec 2020 10:09:33 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B63F9CDF-542F-4F24-87E4-14B3587C6887@holtmann.org>
References: <20201216043335.2185278-1-apusaka@google.com>
 <20201216123317.v3.2.I4969a334028027df34dab9740cd16bbce278633c@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> Enables advertising monitor offloading to the controller, if MSFT
> extension is supported. The kernel won't adjust the monitor parameters
> to match what the controller supports - that is the user space's
> responsibility.
> 
> This patch only manages the addition of monitors. Monitor removal is
> going to be handled by another patch.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Yun-Hao Chung <howardchung@google.com>
> 
> ---
> 
> (no changes since v2)
> 
> Changes in v2:
> * Also implement the new MGMT opcode and merge the functionality with
>  the old one.
> 
> include/net/bluetooth/hci_core.h |  17 ++-
> net/bluetooth/hci_core.c         |  54 +++++++--
> net/bluetooth/mgmt.c             | 144 ++++++++++++++--------
> net/bluetooth/msft.c             | 201 ++++++++++++++++++++++++++++++-
> net/bluetooth/msft.h             |  12 ++
> 5 files changed, 367 insertions(+), 61 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 8b7cf3620938..879d1e38ce96 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -261,13 +261,20 @@ struct adv_rssi_thresholds {
> struct adv_monitor {
> 	struct list_head patterns;
> 	struct adv_rssi_thresholds rssi;
> -	bool		active;
> 	__u16		handle;
> +
> +	enum {
> +		ADV_MONITOR_STATE_NOT_REGISTERED,
> +		ADV_MONITOR_STATE_REGISTERED,
> +		ADV_MONITOR_STATE_OFFLOADED
> +	} state;
> };
> 
> #define HCI_MIN_ADV_MONITOR_HANDLE		1
> -#define HCI_MAX_ADV_MONITOR_NUM_HANDLES	32
> +#define HCI_MAX_ADV_MONITOR_NUM_HANDLES		32
> #define HCI_MAX_ADV_MONITOR_NUM_PATTERNS	16
> +#define HCI_ADV_MONITOR_EXT_NONE		1
> +#define HCI_ADV_MONITOR_EXT_MSFT		2
> 
> #define HCI_MAX_SHORT_NAME_LENGTH	10
> 
> @@ -1326,9 +1333,12 @@ void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
> 
> void hci_adv_monitors_clear(struct hci_dev *hdev);
> void hci_free_adv_monitor(struct adv_monitor *monitor);
> -int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
> +int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
> +bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
> +			int *err);
> int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
> bool hci_is_adv_monitoring(struct hci_dev *hdev);
> +int hci_get_adv_monitor_offload_ext(struct hci_dev *hdev);
> 
> void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
> 
> @@ -1804,6 +1814,7 @@ void mgmt_advertising_added(struct sock *sk, struct hci_dev *hdev,
> void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
> 			      u8 instance);
> int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
> +int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
> 
> u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
> 		      u16 to_multiplier);
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 9d2c9a1c552f..fa13e35f775d 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3070,27 +3070,55 @@ void hci_free_adv_monitor(struct adv_monitor *monitor)
> 	kfree(monitor);
> }
> 
> -/* This function requires the caller holds hdev->lock */
> -int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
> +int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
> +{
> +	return mgmt_add_adv_patterns_monitor_complete(hdev, status);
> +}
> +
> +/* Assigns handle to a monitor, and if offloading is supported and power is on,
> + * also attempts to forward the request to the controller.
> + * Returns true if request is forwarded (result is pending), false otherwise.
> + * This function requires the caller holds hdev->lock.
> + */
> +bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
> +			 int *err)
> {
> 	int min, max, handle;
> 
> -	if (!monitor)
> -		return -EINVAL;
> +	*err = 0;
> +
> +	if (!monitor) {
> +		*err = -EINVAL;
> +		return false;
> +	}
> 
> 	min = HCI_MIN_ADV_MONITOR_HANDLE;
> 	max = HCI_MIN_ADV_MONITOR_HANDLE + HCI_MAX_ADV_MONITOR_NUM_HANDLES;
> 	handle = idr_alloc(&hdev->adv_monitors_idr, monitor, min, max,
> 			   GFP_KERNEL);
> -	if (handle < 0)
> -		return handle;
> +	if (handle < 0) {
> +		*err = handle;
> +		return false;
> +	}
> 
> -	hdev->adv_monitors_cnt++;
> 	monitor->handle = handle;
> 
> -	hci_update_background_scan(hdev);
> +	if (!hdev_is_powered(hdev))
> +		return false;
> 
> -	return 0;
> +	switch (hci_get_adv_monitor_offload_ext(hdev)) {
> +	case HCI_ADV_MONITOR_EXT_NONE:
> +		hci_update_background_scan(hdev);
> +		BT_DBG("%s add monitor status %d", hdev->name, *err);

lets use bt_dev_dbg.

> +		/* Message was not forwarded to controller - not an error */
> +		return false;
> +	case HCI_ADV_MONITOR_EXT_MSFT:
> +		*err = msft_add_monitor_pattern(hdev, monitor);
> +		BT_DBG("%s add monitor msft status %d", hdev->name, *err);
> +		break;
> +	}
> +
> +	return (*err == 0);
> }
> 
> static int free_adv_monitor(int id, void *ptr, void *data)
> @@ -3134,6 +3162,14 @@ bool hci_is_adv_monitoring(struct hci_dev *hdev)
> 	return !idr_is_empty(&hdev->adv_monitors_idr);
> }
> 
> +int hci_get_adv_monitor_offload_ext(struct hci_dev *hdev)
> +{
> +	if (msft_monitor_supported(hdev))
> +		return HCI_ADV_MONITOR_EXT_MSFT;
> +
> +	return HCI_ADV_MONITOR_EXT_NONE;
> +}
> +
> struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
> 					 bdaddr_t *bdaddr, u8 type)
> {
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index cd574054aa39..9bd9f6540664 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -4185,6 +4185,7 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
> 	int handle, err;
> 	size_t rp_size = 0;
> 	__u32 supported = 0;
> +	__u32 enabled = 0;
> 	__u16 num_handles = 0;
> 	__u16 handles[HCI_MAX_ADV_MONITOR_NUM_HANDLES];
> 
> @@ -4192,12 +4193,11 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
> 
> 	hci_dev_lock(hdev);
> 
> -	if (msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR)
> +	if (msft_monitor_supported(hdev))
> 		supported |= MGMT_ADV_MONITOR_FEATURE_MASK_OR_PATTERNS;
> 
> -	idr_for_each_entry(&hdev->adv_monitors_idr, monitor, handle) {
> +	idr_for_each_entry(&hdev->adv_monitors_idr, monitor, handle)
> 		handles[num_handles++] = monitor->handle;
> -	}
> 
> 	hci_dev_unlock(hdev);
> 
> @@ -4206,11 +4206,11 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
> 	if (!rp)
> 		return -ENOMEM;
> 
> -	/* Once controller-based monitoring is in place, the enabled_features
> -	 * should reflect the use.
> -	 */
> +	/* All supported features are currently enabled */
> +	enabled = supported;
> +
> 	rp->supported_features = cpu_to_le32(supported);
> -	rp->enabled_features = 0;
> +	rp->enabled_features = cpu_to_le32(enabled);
> 	rp->max_num_handles = cpu_to_le16(HCI_MAX_ADV_MONITOR_NUM_HANDLES);
> 	rp->max_num_patterns = HCI_MAX_ADV_MONITOR_NUM_PATTERNS;
> 	rp->num_handles = cpu_to_le16(num_handles);
> @@ -4226,6 +4226,45 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
> 	return err;
> }
> 
> +int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
> +{
> +	struct mgmt_rp_add_adv_patterns_monitor rp;
> +	struct mgmt_pending_cmd *cmd;
> +	struct adv_monitor *monitor;
> +	int err = 0;
> +
> +	hci_dev_lock(hdev);
> +
> +	cmd = pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev);
> +	if (!cmd) {
> +		cmd = pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev);
> +		if (!cmd)
> +			goto done;
> +	}
> +
> +	monitor = cmd->user_data;
> +	rp.monitor_handle = cpu_to_le16(monitor->handle);
> +
> +	if (!status) {
> +		mgmt_adv_monitor_added(cmd->sk, hdev, monitor->handle);
> +		hdev->adv_monitors_cnt++;
> +		if (monitor->state == ADV_MONITOR_STATE_NOT_REGISTERED)
> +			monitor->state = ADV_MONITOR_STATE_REGISTERED;
> +		hci_update_background_scan(hdev);
> +	}
> +
> +	err = mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
> +				mgmt_status(status), &rp, sizeof(rp));
> +	mgmt_pending_remove(cmd);
> +
> +done:
> +	hci_dev_unlock(hdev);
> +	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
> +		   rp.monitor_handle, status);
> +
> +	return err;
> +}
> +
> static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 				      void *data, u16 len, u16 op)
> {
> @@ -4236,14 +4275,25 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 	struct mgmt_adv_pattern *patterns = NULL;
> 	struct adv_monitor *m = NULL;
> 	struct adv_pattern *p = NULL;
> -	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
> +	struct mgmt_pending_cmd *cmd;
> 	__u8 cp_ofst = 0, cp_len = 0;
> -	int err, i;
> +	int err, status, i;
> +	bool pending;
> 	u8 pattern_count;
> 	u16 expected_len;
> 
> 	BT_DBG("request for %s", hdev->name);
> 
> +	hci_dev_lock(hdev);
> +
> +	if (pending_find(MGMT_OP_SET_LE, hdev) ||
> +	    pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev) ||
> +	    pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev) ||
> +	    pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev)) {
> +		status = MGMT_STATUS_BUSY;
> +		goto unlock;
> +	}
> +
> 	if (op == MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI) {
> 		cp_rssi = data;
> 		pattern_count = cp_rssi->pattern_count;
> @@ -4258,20 +4308,20 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 		expected_len = sizeof(*cp) + pattern_count * sizeof(*patterns);
> 	}
> 
> -	if (len != expected_len || pattern_count == 0) {
> -		err = mgmt_cmd_status(sk, hdev->id, op,
> -				      MGMT_STATUS_INVALID_PARAMS);
> -		goto failed;
> +	if (len != expected_len || pattern_count == 0 ||
> +	    pattern_count > HCI_MAX_ADV_MONITOR_NUM_PATTERNS) {
> +		status = MGMT_STATUS_INVALID_PARAMS;
> +		goto unlock;
> 	}
> 
> 	m = kmalloc(sizeof(*m), GFP_KERNEL);
> 	if (!m) {
> -		err = -ENOMEM;
> -		goto failed;
> +		status = MGMT_STATUS_NO_RESOURCES;
> +		goto unlock;
> 	}
> 
> 	INIT_LIST_HEAD(&m->patterns);
> -	m->active = false;
> +	m->state = ADV_MONITOR_STATE_NOT_REGISTERED;
> 
> 	if (rssi) {
> 		m->rssi.low_threshold = rssi->low_threshold;
> @@ -4295,26 +4345,19 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 	}
> 
> 	for (i = 0; i < pattern_count; i++) {
> -		if (++mp_cnt > HCI_MAX_ADV_MONITOR_NUM_PATTERNS) {
> -			err = mgmt_cmd_status(sk, hdev->id, op,
> -					      MGMT_STATUS_INVALID_PARAMS);
> -			goto failed;
> -		}
> -
> 		cp_ofst = patterns[i].offset;
> 		cp_len = patterns[i].length;
> 		if (cp_ofst >= HCI_MAX_AD_LENGTH ||
> 		    cp_len > HCI_MAX_AD_LENGTH ||
> 		    (cp_ofst + cp_len) > HCI_MAX_AD_LENGTH) {
> -			err = mgmt_cmd_status(sk, hdev->id, op,
> -					      MGMT_STATUS_INVALID_PARAMS);
> -			goto failed;
> +			status = MGMT_STATUS_INVALID_PARAMS;
> +			goto unlock;
> 		}
> 
> 		p = kmalloc(sizeof(*p), GFP_KERNEL);
> 		if (!p) {
> -			err = -ENOMEM;
> -			goto failed;
> +			status = MGMT_STATUS_NO_RESOURCES;
> +			goto unlock;
> 		}
> 
> 		p->ad_type = patterns[i].ad_type;
> @@ -4326,41 +4369,46 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> 		list_add(&p->list, &m->patterns);
> 	}
> 
> -	if (mp_cnt != pattern_count) {
> -		err = mgmt_cmd_status(sk, hdev->id, op,
> -				      MGMT_STATUS_INVALID_PARAMS);
> -		goto failed;
> +	cmd = mgmt_pending_add(sk, op, hdev, data, len);
> +	if (!cmd) {
> +		status = MGMT_STATUS_NO_RESOURCES;
> +		goto unlock;
> 	}
> 
> -	hci_dev_lock(hdev);
> -
> -	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
> -
> -	err = hci_add_adv_monitor(hdev, m);
> +	pending = hci_add_adv_monitor(hdev, m, &err);
> 	if (err) {
> -		if (err == -ENOSPC) {
> -			mgmt_cmd_status(sk, hdev->id, op,
> -					MGMT_STATUS_NO_RESOURCES);
> -		}
> +		if (err == -ENOSPC || err == -ENOMEM)
> +			status = MGMT_STATUS_NO_RESOURCES;
> +		else if (err == -EINVAL)
> +			status = MGMT_STATUS_INVALID_PARAMS;
> +		else
> +			status = MGMT_STATUS_FAILED;
> +
> +		mgmt_pending_remove(cmd);
> 		goto unlock;
> 	}
> 
> -	if (hdev->adv_monitors_cnt > prev_adv_monitors_cnt)
> +	if (!pending) {
> +		mgmt_pending_remove(cmd);
> +		rp.monitor_handle = cpu_to_le16(m->handle);
> 		mgmt_adv_monitor_added(sk, hdev, m->handle);
> +		m->state = ADV_MONITOR_STATE_REGISTERED;
> +		hdev->adv_monitors_cnt++;
> 
> -	hci_dev_unlock(hdev);
> +		hci_dev_unlock(hdev);
> +		return mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_SUCCESS,
> +					 &rp, sizeof(rp));
> +	}
> 
> -	rp.monitor_handle = cpu_to_le16(m->handle);
> +	hci_dev_unlock(hdev);
> 
> -	return mgmt_cmd_complete(sk, hdev->id, op,
> -				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
> +	cmd->user_data = m;
> +	return 0;
> 
> unlock:
> 	hci_dev_unlock(hdev);
> -
> -failed:
> 	hci_free_adv_monitor(m);
> -	return err;
> +	return mgmt_cmd_status(sk, hdev->id, op, status);
> }
> 
> static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index 4b39534a14a1..e4b8fe71b9c3 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -5,9 +5,16 @@
> 
> #include <net/bluetooth/bluetooth.h>
> #include <net/bluetooth/hci_core.h>
> +#include <net/bluetooth/mgmt.h>
> 
> +#include "hci_request.h"
> +#include "mgmt_util.h"
> #include "msft.h"
> 
> +#define MSFT_RSSI_THRESHOLD_VALUE_MIN		-127
> +#define MSFT_RSSI_THRESHOLD_VALUE_MAX		20
> +#define MSFT_RSSI_LOW_TIMEOUT_MAX		0x3C
> +
> #define MSFT_OP_READ_SUPPORTED_FEATURES		0x00
> struct msft_cp_read_supported_features {
> 	__u8   sub_opcode;
> @@ -21,12 +28,55 @@ struct msft_rp_read_supported_features {
> 	__u8   evt_prefix[];
> } __packed;
> 
> +#define MSFT_OP_LE_MONITOR_ADVERTISEMENT	0x03
> +#define MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN	0x01
> +struct msft_le_monitor_advertisement_pattern {
> +	__u8 length;
> +	__u8 data_type;
> +	__u8 start_byte;
> +	__u8 pattern[0];
> +};
> +
> +struct msft_le_monitor_advertisement_pattern_data {
> +	__u8 count;
> +	__u8 data[0];
> +};
> +
> +struct msft_cp_le_monitor_advertisement {
> +	__u8 sub_opcode;
> +	__s8 rssi_high;
> +	__s8 rssi_low;
> +	__u8 rssi_low_interval;
> +	__u8 rssi_sampling_period;
> +	__u8 cond_type;
> +	__u8 data[0];
> +} __packed;
> +
> +struct msft_rp_le_monitor_advertisement {
> +	__u8 status;
> +	__u8 sub_opcode;
> +	__u8 handle;
> +} __packed;
> +
> +struct msft_monitor_advertisement_handle_data {
> +	__u8  msft_handle;
> +	__u16 mgmt_handle;
> +	struct list_head list;
> +};
> +
> struct msft_data {
> 	__u64 features;
> 	__u8  evt_prefix_len;
> 	__u8  *evt_prefix;
> +	struct list_head handle_map;
> +	__u16 pending_add_handle;
> };
> 
> +bool msft_monitor_supported(struct hci_dev *hdev)
> +{
> +	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
> +}
> +
> static bool read_supported_features(struct hci_dev *hdev,
> 				    struct msft_data *msft)
> {
> @@ -90,12 +140,14 @@ void msft_do_open(struct hci_dev *hdev)
> 		return;
> 	}
> 
> +	INIT_LIST_HEAD(&msft->handle_map);
> 	hdev->msft_data = msft;
> }
> 
> void msft_do_close(struct hci_dev *hdev)
> {
> 	struct msft_data *msft = hdev->msft_data;
> +	struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
> 
> 	if (!msft)
> 		return;
> @@ -104,6 +156,11 @@ void msft_do_close(struct hci_dev *hdev)
> 
> 	hdev->msft_data = NULL;
> 
> +	list_for_each_entry_safe(handle_data, tmp, &msft->handle_map, list) {
> +		list_del(&handle_data->list);
> +		kfree(handle_data);
> +	}
> +
> 	kfree(msft->evt_prefix);
> 	kfree(msft);
> }
> @@ -145,5 +202,147 @@ __u64 msft_get_features(struct hci_dev *hdev)
> {
> 	struct msft_data *msft = hdev->msft_data;
> 
> -	return  msft ? msft->features : 0;
> +	return msft ? msft->features : 0;
> +}
> +
> +static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
> +					     u8 status, u16 opcode,
> +					     struct sk_buff *skb)
> +{
> +	struct msft_rp_le_monitor_advertisement *rp;
> +	struct adv_monitor *monitor;
> +	struct msft_monitor_advertisement_handle_data *handle_data;
> +	struct msft_data *msft = hdev->msft_data;
> +
> +	hci_dev_lock(hdev);
> +
> +	monitor = idr_find(&hdev->adv_monitors_idr, msft->pending_add_handle);
> +	if (!monitor) {
> +		bt_dev_err(hdev, "msft add advmon: monitor %d is not found!",
> +			   msft->pending_add_handle);
> +		status = HCI_ERROR_UNSPECIFIED;
> +		goto unlock;
> +	}
> +
> +	if (status)
> +		goto unlock;
> +
> +	rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
> +	if (skb->len < sizeof(*rp)) {
> +		status = HCI_ERROR_UNSPECIFIED;
> +		goto unlock;
> +	}
> +
> +	handle_data = kmalloc(sizeof(*handle_data), GFP_KERNEL);
> +	if (!handle_data) {
> +		status = HCI_ERROR_UNSPECIFIED;
> +		goto unlock;
> +	}
> +
> +	handle_data->mgmt_handle = monitor->handle;
> +	handle_data->msft_handle = rp->handle;
> +	INIT_LIST_HEAD(&handle_data->list);
> +	list_add(&handle_data->list, &msft->handle_map);
> +
> +	monitor->state = ADV_MONITOR_STATE_OFFLOADED;
> +
> +unlock:
> +	if (status && monitor) {
> +		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
> +		hci_free_adv_monitor(monitor);
> +	}
> +
> +	hci_dev_unlock(hdev);
> +
> +	hci_add_adv_patterns_monitor_complete(hdev, status);
> +}
> +
> +static bool msft_monitor_rssi_valid(struct adv_monitor *monitor)
> +{
> +	struct adv_rssi_thresholds *r = &monitor->rssi;
> +
> +	if (r->high_threshold < MSFT_RSSI_THRESHOLD_VALUE_MIN ||
> +	    r->high_threshold > MSFT_RSSI_THRESHOLD_VALUE_MAX ||
> +	    r->low_threshold < MSFT_RSSI_THRESHOLD_VALUE_MIN ||
> +	    r->low_threshold > MSFT_RSSI_THRESHOLD_VALUE_MAX)
> +		return false;
> +
> +	/* High_threshold_timeout is not supported,
> +	 * once high_threshold is reached, events are immediately reported.
> +	 */
> +	if (r->high_threshold_timeout != 0)
> +		return false;
> +
> +	if (r->low_threshold_timeout > MSFT_RSSI_LOW_TIMEOUT_MAX)
> +		return false;
> +
> +	/* Sampling period from 0x00 to 0xFF are all allowed */
> +	return true;
> +}
> +
> +static bool msft_monitor_pattern_valid(struct adv_monitor *monitor)
> +{
> +	return msft_monitor_rssi_valid(monitor);
> +	/* No additional check needed for pattern-based monitor */
> +}
> +
> +/* This function requires the caller holds hdev->lock */
> +int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
> +{
> +	struct msft_cp_le_monitor_advertisement *cp;
> +	struct msft_le_monitor_advertisement_pattern_data *pattern_data;
> +	struct msft_le_monitor_advertisement_pattern *pattern;
> +	struct adv_pattern *entry;
> +	struct hci_request req;
> +	struct msft_data *msft = hdev->msft_data;
> +	size_t total_size = sizeof(*cp) + sizeof(*pattern_data);
> +	ptrdiff_t offset = 0;
> +	u8 pattern_count = 0;
> +	int err = 0;
> +
> +	if (!msft)
> +		return -EOPNOTSUPP;
> +
> +	if (!msft_monitor_pattern_valid(monitor))
> +		return -EINVAL;
> +
> +	list_for_each_entry(entry, &monitor->patterns, list) {
> +		pattern_count++;
> +		total_size += sizeof(*pattern) + entry->length;
> +	}
> +
> +	cp = kmalloc(total_size, GFP_KERNEL);
> +	if (!cp)
> +		return -ENOMEM;
> +
> +	cp->sub_opcode = MSFT_OP_LE_MONITOR_ADVERTISEMENT;
> +	cp->rssi_high = monitor->rssi.high_threshold;
> +	cp->rssi_low = monitor->rssi.low_threshold;
> +	cp->rssi_low_interval = (u8)monitor->rssi.low_threshold_timeout;
> +	cp->rssi_sampling_period = monitor->rssi.sampling_period;
> +
> +	cp->cond_type = MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN;
> +
> +	pattern_data = (void *)cp->data;
> +	pattern_data->count = pattern_count;
> +
> +	list_for_each_entry(entry, &monitor->patterns, list) {
> +		pattern = (void *)(pattern_data->data + offset);
> +		/* the length also includes data_type and offset */
> +		pattern->length = entry->length + 2;
> +		pattern->data_type = entry->ad_type;
> +		pattern->start_byte = entry->offset;
> +		memcpy(pattern->pattern, entry->value, entry->length);
> +		offset += sizeof(*pattern) + entry->length;
> +	}
> +
> +	hci_req_init(&req, hdev);
> +	hci_req_add(&req, hdev->msft_opcode, total_size, cp);
> +	err = hci_req_run_skb(&req, msft_le_monitor_advertisement_cb);
> +	kfree(cp);
> +
> +	if (!err)
> +		msft->pending_add_handle = monitor->handle;
> +
> +	return err;
> }
> diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> index e9c478e890b8..0ac9b15322b1 100644
> --- a/net/bluetooth/msft.h
> +++ b/net/bluetooth/msft.h
> @@ -12,16 +12,28 @@
> 
> #if IS_ENABLED(CONFIG_BT_MSFTEXT)
> 
> +bool msft_monitor_supported(struct hci_dev *hdev);
> void msft_do_open(struct hci_dev *hdev);
> void msft_do_close(struct hci_dev *hdev);
> void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
> __u64 msft_get_features(struct hci_dev *hdev);
> +int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor);
> 
> #else
> 
> +static inline bool msft_monitor_supported(struct hci_dev *hdev)
> +{
> +	return false;
> +}
> +
> static inline void msft_do_open(struct hci_dev *hdev) {}
> static inline void msft_do_close(struct hci_dev *hdev) {}
> static inline void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb) {}
> static inline __u64 msft_get_features(struct hci_dev *hdev) { return 0; }
> +static inline int msft_add_monitor_pattern(struct hci_dev *hdev,
> +					   struct adv_monitor *monitor)
> +{
> +	return -EOPNOTSUPP;
> +}

Regards

Marcel

