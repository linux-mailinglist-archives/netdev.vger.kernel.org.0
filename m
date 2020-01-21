Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6229F144284
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgAUQxN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 11:53:13 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:60272 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgAUQxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:53:13 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 0F698CECE3;
        Tue, 21 Jan 2020 18:02:30 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [RFC PATCH 2/2] Bluetooth: Handle PM_SUSPEND_PREPARE and
 PM_POST_SUSPEND
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200117132623.RFC.2.I5f47e609ee90484bef06a09e37a66c6569eeb584@changeid>
Date:   Tue, 21 Jan 2020 17:53:10 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>, alainm@chromium.org,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CE580C0E-3F79-466C-BC93-0E469418496D@holtmann.org>
References: <20200117212705.57436-1-abhishekpandit@chromium.org>
 <20200117132623.RFC.2.I5f47e609ee90484bef06a09e37a66c6569eeb584@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
> Bluetooth controller is prepared correctly for suspend/resume. The
> suspend notifier will wait for all tasks to complete before returning.
> 
> At a high level, we do the following when entering suspend:
> - Pause any active discovery
> - Pause any active advertising
> - Set the event filter with addresses of wake capable Classic devices
>  and enable Page Scan
> - Update the LE whitelist to only include devices that can wake the
>  system, update the scan parameters and enable passive scanning.
> - Disconnect all devices with a POWER_DOWN reason
> 
> On resume, it reverses the above operations:
> - Clear event filters and restore page scan
> - Restore LE whitelist and restore passive scan
> - If advertising was active before suspend, re-enable it
> - If discovery was active before suspend, re-enable it
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> include/net/bluetooth/hci.h      |  30 +++-
> include/net/bluetooth/hci_core.h |  45 +++++
> net/bluetooth/hci_core.c         |  70 ++++++++
> net/bluetooth/hci_event.c        |  24 ++-
> net/bluetooth/hci_request.c      | 297 ++++++++++++++++++++++++++++---
> net/bluetooth/hci_request.h      |   4 +-
> net/bluetooth/mgmt.c             |  52 +++++-
> 7 files changed, 486 insertions(+), 36 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 6293bdd7d862..3c85c556e59a 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -932,10 +932,31 @@ struct hci_cp_sniff_subrate {
> #define HCI_OP_RESET			0x0c03
> 
> #define HCI_OP_SET_EVENT_FLT		0x0c05
> -struct hci_cp_set_event_flt {
> +#define HCI_SET_EVENT_FLT_SIZE		9
> +struct hci_cp_set_event_filter {
> 	__u8     flt_type;
> 	__u8     cond_type;
> -	__u8     condition[0];
> +	union {
> +		union {
> +			struct {
> +				__u8 val[3];
> +				__u8 mask[3];
> +			} __packed dev_class;
> +			bdaddr_t addr;
> +		} inq;
> +		union {
> +			__u8 auto_accept_any;
> +			struct {
> +				__u8 val[3];
> +				__u8 mask[3];
> +				__u8 auto_accept;
> +			} __packed dev_class;
> +			struct {
> +				bdaddr_t bdaddr;
> +				__u8 auto_accept;
> +			} __packed addr;
> +		} conn;
> +	} cond;

if we are only planning to use the address to whitelist device that are allowed to wake us up, then lets keep this struct simple. If at a later point we want to do something different, we deal with it then.

> } __packed;
> 
> /* Filter types */
> @@ -949,8 +970,9 @@ struct hci_cp_set_event_flt {
> #define HCI_CONN_SETUP_ALLOW_BDADDR	0x02
> 
> /* CONN_SETUP Conditions */
> -#define HCI_CONN_SETUP_AUTO_OFF	0x01
> -#define HCI_CONN_SETUP_AUTO_ON	0x02
> +#define HCI_CONN_SETUP_AUTO_OFF		0x01
> +#define HCI_CONN_SETUP_AUTO_ON		0x02
> +#define HCI_CONN_SETUP_AUTO_ON_WITH_RS	0x03
> 
> #define HCI_OP_READ_STORED_LINK_KEY	0x0c0d
> struct hci_cp_read_stored_link_key {
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index ce4bebcb0265..963871fca069 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -88,6 +88,49 @@ struct discovery_state {
> 	unsigned long		scan_duration;
> };
> 
> +#define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
> +
> +enum suspend_tasks {
> +	SUSPEND_PAUSE_DISCOVERY,
> +	SUSPEND_UNPAUSE_DISCOVERY,
> +
> +	SUSPEND_PAUSE_ADVERTISING,
> +	SUSPEND_UNPAUSE_ADVERTISING,
> +
> +	SUSPEND_LE_SET_SCAN_ENABLE,
> +	SUSPEND_DISCONNECTING,
> +
> +	SUSPEND_PREPARE_NOTIFIER,
> +	__SUSPEND_NUM_TASKS
> +};
> +
> +enum suspended_state {
> +	BT_RUNNING = 0,
> +	BT_SUSPENDED,
> +};
> +
> +struct suspend_state {
> +	int	discovery_old_state;
> +	int	advertising_old_state;
> +
> +	bool	discovery_paused;
> +	bool	advertising_paused;
> +
> +	int	disconnect_counter;
> +
> +	/* BREDR: Disallow changing event filters + page scan.
> +	 * LE: Disallow changing whitelist, scan params and scan enable.
> +	 */
> +	bool	freeze_filters;
> +
> +	DECLARE_BITMAP(tasks, __SUSPEND_NUM_TASKS);
> +	wait_queue_head_t	tasks_wait_q;
> +
> +	struct work_struct	prepare;
> +	enum suspended_state	next_state;
> +	enum suspended_state	state;
> +};
> +

With a simple glance, I am not convinced that this should be a separate struct. I would include things directly in hci_dev actually.

> struct hci_conn_hash {
> 	struct list_head list;
> 	unsigned int     acl_num;
> @@ -389,6 +432,8 @@ struct hci_dev {
> 	void			*smp_bredr_data;
> 
> 	struct discovery_state	discovery;
> +	struct suspend_state	suspend;
> +	struct notifier_block	suspend_notifier;
> 	struct hci_conn_hash	conn_hash;
> 
> 	struct list_head	mgmt_pending;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 7057b9b65173..76bd4f376790 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -31,6 +31,8 @@
> #include <linux/debugfs.h>
> #include <linux/crypto.h>
> #include <linux/property.h>
> +#include <linux/suspend.h>
> +#include <linux/wait.h>
> #include <asm/unaligned.h>
> 
> #include <net/bluetooth/bluetooth.h>
> @@ -3241,6 +3243,65 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
> 	}
> }
> 
> +static int hci_suspend_wait_event(struct hci_dev *hdev)
> +{
> +#define WAKE_COND                                                              \
> +	(find_first_bit(hdev->suspend.tasks, __SUSPEND_NUM_TASKS) ==           \
> +	 __SUSPEND_NUM_TASKS)
> +
> +	int i;
> +	int ret = wait_event_timeout(hdev->suspend.tasks_wait_q,
> +				     WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
> +
> +	if (ret == 0) {
> +		BT_DBG("Timed out waiting for suspend");
> +		for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
> +			if (test_bit(i, hdev->suspend.tasks))
> +				BT_DBG("Bit %d is set", i);
> +			clear_bit(i, hdev->suspend.tasks);
> +		}
> +
> +		ret = -ETIMEDOUT;
> +	} else {
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +static void hci_prepare_suspend(struct work_struct *work)
> +{
> +	struct hci_dev *hdev =
> +		container_of(work, struct hci_dev, suspend.prepare);
> +
> +	hci_dev_lock(hdev);
> +	hci_req_prepare_suspend(hdev, hdev->suspend.next_state);
> +	hci_dev_unlock(hdev);
> +}
> +
> +static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
> +				void *data)
> +{
> +	struct hci_dev *hdev =
> +		container_of(nb, struct hci_dev, suspend_notifier);
> +	int ret = 0;
> +
> +	if (action == PM_SUSPEND_PREPARE) {
> +		hdev->suspend.next_state = BT_SUSPENDED;
> +		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> +		queue_work(hdev->req_workqueue, &hdev->suspend.prepare);
> +
> +		ret = hci_suspend_wait_event(hdev);
> +	} else if (action == PM_POST_SUSPEND) {
> +		hdev->suspend.next_state = BT_RUNNING;
> +		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> +		queue_work(hdev->req_workqueue, &hdev->suspend.prepare);
> +
> +		ret = hci_suspend_wait_event(hdev);
> +	}
> +
> +	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
> +}
> /* Alloc HCI device */
> struct hci_dev *hci_alloc_dev(void)
> {
> @@ -3319,6 +3380,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	INIT_WORK(&hdev->tx_work, hci_tx_work);
> 	INIT_WORK(&hdev->power_on, hci_power_on);
> 	INIT_WORK(&hdev->error_reset, hci_error_reset);
> +	INIT_WORK(&hdev->suspend.prepare, hci_prepare_suspend);
> 
> 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
> 
> @@ -3327,6 +3389,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	skb_queue_head_init(&hdev->raw_q);
> 
> 	init_waitqueue_head(&hdev->req_wait_q);
> +	init_waitqueue_head(&hdev->suspend.tasks_wait_q);
> 
> 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
> 
> @@ -3438,6 +3501,11 @@ int hci_register_dev(struct hci_dev *hdev)
> 	hci_sock_dev_event(hdev, HCI_DEV_REG);
> 	hci_dev_hold(hdev);
> 
> +	hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
> +	error = register_pm_notifier(&hdev->suspend_notifier);
> +	if (error)
> +		goto err_wqueue;
> +
> 	queue_work(hdev->req_workqueue, &hdev->power_on);
> 
> 	return id;
> @@ -3471,6 +3539,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
> 
> 	hci_dev_do_close(hdev);
> 
> +	unregister_pm_notifier(&hdev->suspend_notifier);
> +
> 	if (!test_bit(HCI_INIT, &hdev->flags) &&
> 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
> 	    !hci_dev_test_flag(hdev, HCI_CONFIG)) {
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 6ddc4a74a5e4..623eca68afdd 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -2474,6 +2474,7 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
> static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
> {
> 	struct hci_ev_conn_complete *ev = (void *) skb->data;
> +	struct inquiry_entry *ie;
> 	struct hci_conn *conn;
> 
> 	BT_DBG("%s", hdev->name);
> @@ -2482,14 +2483,25 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
> 
> 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
> 	if (!conn) {
> -		if (ev->link_type != SCO_LINK)
> -			goto unlock;
> +		ie = hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
> +		if (ie) {
> +			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
> +					    HCI_ROLE_SLAVE);
> +			if (!conn) {
> +				bt_dev_err(hdev, "no memory for new conn");
> +				goto unlock;
> +			}
> +		} else {
> +			if (ev->link_type != SCO_LINK)
> +				goto unlock;

I do not understand this change. What does it do? I think you would need to add a comment here. Maybe this is a change that needs to be split out into a separate patch.

> 
> -		conn = hci_conn_hash_lookup_ba(hdev, ESCO_LINK, &ev->bdaddr);
> -		if (!conn)
> -			goto unlock;
> +			conn = hci_conn_hash_lookup_ba(hdev, ESCO_LINK,
> +						       &ev->bdaddr);
> +			if (!conn)
> +				goto unlock;
> 
> -		conn->type = SCO_LINK;
> +			conn->type = SCO_LINK;
> +		}
> 	}
> 
> 	if (!ev->status) {
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 2a1b64dbf76e..3044d9e1ea2b 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -447,7 +447,7 @@ static void __hci_update_background_scan(struct hci_request *req)
> 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
> 			hci_req_add_le_scan_disable(req);
> 
> -		hci_req_add_le_passive_scan(req);
> +		hci_req_add_le_passive_scan(req, false);

Generally it is pretty bad to have a list of boolean parameters since you don’t know what this call does. From context you can’t tell what this false means that is pretty bad if you have to re-read that code in a few month.

Can we do this more elegant without having to add a suspending variable to a bunch of existing functions?

> 
> 		BT_DBG("%s starting background scanning", hdev->name);
> 	}
> @@ -654,6 +654,12 @@ void hci_req_add_le_scan_disable(struct hci_request *req)
> {
> 	struct hci_dev *hdev = req->hdev;
> 
> +	/* Early exit if we've frozen filters for suspend*/

Space before */

> +	if (hdev->suspend.freeze_filters) {
> +		BT_DBG("Filters are frozen for suspend");
> +		return;
> +	}
> +
> 	if (use_ext_scan(hdev)) {
> 		struct hci_cp_le_set_ext_scan_enable cp;
> 
> @@ -681,12 +687,25 @@ static void add_to_white_list(struct hci_request *req,
> 	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
> }
> 
> -static u8 update_white_list(struct hci_request *req)
> +static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
> +				u8 bdaddr_type)
> +{
> +	struct hci_cp_le_del_from_white_list cp;
> +
> +	cp.bdaddr_type = bdaddr_type;
> +	bacpy(&cp.bdaddr, bdaddr);
> +
> +	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
> +}
> +
> +static u8 update_white_list(struct hci_request *req, bool allow_rpa,
> +			    bool remove_nonwakeable)
> {
> 	struct hci_dev *hdev = req->hdev;
> 	struct hci_conn_params *params;
> 	struct bdaddr_list *b;
> 	uint8_t white_list_entries = 0;
> +	bool wakeable;
> 
> 	/* Go through the current white list programmed into the
> 	 * controller one by one and check if that address is still
> @@ -695,24 +714,37 @@ static u8 update_white_list(struct hci_request *req)
> 	 * command to remove it from the controller.
> 	 */
> 	list_for_each_entry(b, &hdev->le_white_list, list) {
> -		/* If the device is neither in pend_le_conns nor
> -		 * pend_le_reports then remove it from the whitelist.
> +		wakeable = !!hci_bdaddr_list_lookup(&hdev->wakeable, &b->bdaddr,
> +						    b->bdaddr_type);
> +
> +		/* If the device is not likely to connect or report, remove it
> +		 * from the whitelist. Make an exception for wakeable devices if
> +		 * we're removing only non-wakeable devices (we want them to
> +		 * stay in whitelist).
> 		 */
> 		if (!hci_pend_le_action_lookup(&hdev->pend_le_conns,
> 					       &b->bdaddr, b->bdaddr_type) &&
> 		    !hci_pend_le_action_lookup(&hdev->pend_le_reports,
> -					       &b->bdaddr, b->bdaddr_type)) {
> -			struct hci_cp_le_del_from_white_list cp;
> -
> -			cp.bdaddr_type = b->bdaddr_type;
> -			bacpy(&cp.bdaddr, &b->bdaddr);
> +					       &b->bdaddr, b->bdaddr_type) &&
> +		    (!wakeable && remove_nonwakeable)) {
> +			BT_DBG("Removing %pMR (0x%x) - not pending or wakeable",
> +			       &b->bdaddr, b->bdaddr_type);
> +			del_from_white_list(req, &b->bdaddr, b->bdaddr_type);
> +			continue;
> +		}
> 
> -			hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST,
> -				    sizeof(cp), &cp);
> +		/* If we're removing non wakeable devices and this whitelist
> +		 * entry is not wake capable, we remove it from the whitelist.
> +		 */
> +		if (remove_nonwakeable && !wakeable) {
> +			BT_DBG("Removing %pMR (0x%x) - not wake capable",
> +			       &b->bdaddr, b->bdaddr_type);
> +			del_from_white_list(req, &b->bdaddr, b->bdaddr_type);
> 			continue;
> 		}
> 
> -		if (hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> +		if (!allow_rpa &&
> +		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> 			/* White list can not be used with RPAs */
> 			return 0x00;
> 		}
> @@ -740,14 +772,20 @@ static u8 update_white_list(struct hci_request *req)
> 			return 0x00;
> 		}
> 
> -		if (hci_find_irk_by_addr(hdev, &params->addr,
> -					 params->addr_type)) {
> +		if (!allow_rpa && hci_find_irk_by_addr(hdev, &params->addr,
> +						       params->addr_type)) {
> 			/* White list can not be used with RPAs */
> 			return 0x00;
> 		}
> 
> +		if (remove_nonwakeable &&
> +		    !hci_bdaddr_list_lookup(&hdev->wakeable, &b->bdaddr,
> +					    b->bdaddr_type))
> +			continue;
> +
> 		white_list_entries++;
> 		add_to_white_list(req, params);
> +		BT_DBG("Adding %pMR to whitelist", &params->addr);
> 	}
> 
> 	/* After adding all new pending connections, walk through
> @@ -764,14 +802,20 @@ static u8 update_white_list(struct hci_request *req)
> 			return 0x00;
> 		}
> 
> -		if (hci_find_irk_by_addr(hdev, &params->addr,
> -					 params->addr_type)) {
> +		if (!allow_rpa && hci_find_irk_by_addr(hdev, &params->addr,
> +						       params->addr_type)) {
> 			/* White list can not be used with RPAs */
> 			return 0x00;
> 		}
> 
> +		if (remove_nonwakeable &&
> +		    !hci_bdaddr_list_lookup(&hdev->wakeable, &b->bdaddr,
> +					    b->bdaddr_type))
> +			continue;
> +
> 		white_list_entries++;
> 		add_to_white_list(req, params);
> +		BT_DBG("Adding %pMR to whitelist", &params->addr);
> 	}
> 
> 	/* Select filter policy to use white list */
> @@ -784,7 +828,8 @@ static bool scan_use_rpa(struct hci_dev *hdev)
> }

I have the feeling we might now need to restructure the update white list function to keep it readable. It already has tons of comments for corner cases and would require now even more for the suspend corner cases.

My advice to really add comments explaining why this is correct or what things do for function that are complicated by nature.

> 
> static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
> -			       u16 window, u8 own_addr_type, u8 filter_policy)
> +			       u16 window, u8 own_addr_type, u8 filter_policy,
> +			       u8 filter_dup)
> {
> 	struct hci_dev *hdev = req->hdev;
> 
> @@ -836,7 +881,7 @@ static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
> 
> 		memset(&ext_enable_cp, 0, sizeof(ext_enable_cp));
> 		ext_enable_cp.enable = LE_SCAN_ENABLE;
> -		ext_enable_cp.filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
> +		ext_enable_cp.filter_dup = filter_dup;
> 
> 		hci_req_add(req, HCI_OP_LE_SET_EXT_SCAN_ENABLE,
> 			    sizeof(ext_enable_cp), &ext_enable_cp);
> @@ -855,17 +900,47 @@ static void hci_req_start_scan(struct hci_request *req, u8 type, u16 interval,
> 
> 		memset(&enable_cp, 0, sizeof(enable_cp));
> 		enable_cp.enable = LE_SCAN_ENABLE;
> -		enable_cp.filter_dup = LE_SCAN_FILTER_DUP_ENABLE;
> +		enable_cp.filter_dup = filter_dup;
> 		hci_req_add(req, HCI_OP_LE_SET_SCAN_ENABLE, sizeof(enable_cp),
> 			    &enable_cp);
> 	}
> }

If this is required, we should have this as a separate patch. Again, please see my comment with two many parameters. We ensured that callers use variable that clearly give a hint what the parameter is and what it does.

> 
> -void hci_req_add_le_passive_scan(struct hci_request *req)
> +static u16 __hci_get_scan_interval(struct hci_dev *hdev, bool suspending)
> +{
> +	if (suspending)
> +		return 0x0060;
> +	else
> +		return hdev->le_scan_interval;
> +}
> +
> +static u16 __hci_get_scan_window(struct hci_dev *hdev, bool suspending)
> +{
> +	if (suspending)
> +		return 0x0012;
> +	else
> +		return hdev->le_scan_window;
> +}

I think this makes the code harder to read. Just put the if-clause where you use it and use a constant for 0x0060 and 0x0012.

> +
> +void hci_req_add_le_passive_scan(struct hci_request *req, bool suspending)
> {
> 	struct hci_dev *hdev = req->hdev;
> 	u8 own_addr_type;
> 	u8 filter_policy;
> +	u8 filter_dup;
> +
> +	/* We allow whitelisting even with RPAs in suspend. In the worst case,
> +	 * we won't be able to wake from devices that use the privacy1.2
> +	 * features. Additionally, once we support privacy1.2 and IRK
> +	 * offloading, we can update this to also check for those conditions.
> +	 */
> +	bool allow_rpa = suspending;
> +
> +	/* Early exit if we've frozen filters for suspend*/
> +	if (hdev->suspend.freeze_filters) {
> +		BT_DBG("Filters are frozen for suspend");
> +		return;
> +	}
> 
> 	/* Set require_privacy to false since no SCAN_REQ are send
> 	 * during passive scanning. Not using an non-resolvable address
> @@ -881,7 +956,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
> 	 * happen before enabling scanning. The controller does
> 	 * not allow white list modification while scanning.
> 	 */
> -	filter_policy = update_white_list(req);
> +	BT_DBG("Updating white list with suspending = %d", suspending);
> +	filter_policy = update_white_list(req, allow_rpa, suspending);
> 
> 	/* When the controller is using random resolvable addresses and
> 	 * with that having LE privacy enabled, then controllers with
> @@ -896,8 +972,14 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
> 	    (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
> 		filter_policy |= 0x02;
> 
> -	hci_req_start_scan(req, LE_SCAN_PASSIVE, hdev->le_scan_interval,
> -			   hdev->le_scan_window, own_addr_type, filter_policy);
> +	filter_dup = suspending ? LE_SCAN_FILTER_DUP_DISABLE :
> +				  LE_SCAN_FILTER_DUP_ENABLE;

I think this warrants a comment why duplicate filtering gets disabled on suspend. I for example don’t get it.

> +
> +	BT_DBG("LE passive scan with whitelist = %d", filter_policy);
> +	hci_req_start_scan(req, LE_SCAN_PASSIVE,
> +			   __hci_get_scan_interval(hdev, suspending),
> +			   __hci_get_scan_window(hdev, suspending),
> +			   own_addr_type, filter_policy, filter_dup);
> }
> 
> static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
> @@ -918,6 +1000,170 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
> 	return adv_instance->scan_rsp_len;
> }
> 
> +static void hci_req_set_event_filter(struct hci_request *req, bool clear)
> +{
> +	struct bdaddr_list *b;
> +	struct hci_cp_set_event_filter f;
> +	struct hci_dev *hdev = req->hdev;
> +	int filters_updated = 0;
> +	u8 scan;
> +
> +	/* Always clear event filter when starting */
> +	memset(&f, 0, sizeof(f));
> +	f.flt_type = HCI_FLT_CLEAR_ALL;
> +	hci_req_add(req, HCI_OP_SET_EVENT_FLT, 1, &f);
> +
> +	if (!clear) {
> +		list_for_each_entry(b, &hdev->wakeable, list) {
> +			if (b->bdaddr_type != BDADDR_BREDR)
> +				continue;
> +
> +			memset(&f, 0, sizeof(f));
> +			bacpy(&f.cond.conn.addr.bdaddr, &b->bdaddr);
> +			f.flt_type = HCI_FLT_CONN_SETUP;
> +			f.cond_type = HCI_CONN_SETUP_ALLOW_BDADDR;
> +			f.cond.conn.addr.auto_accept = HCI_CONN_SETUP_AUTO_ON;
> +
> +			BT_DBG("Adding event filters for %pMR", &b->bdaddr);
> +			hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f), &f);
> +
> +			filters_updated++;
> +		}
> +
> +		scan = filters_updated ? SCAN_PAGE : SCAN_DISABLED;
> +		hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
> +	} else {
> +		/* Restore page scan to normal (i.e. there are disconnected
> +		 * devices in the whitelist.
> +		 */
> +		__hci_req_update_scan(req);
> +	}
> +}

Lets have a simple hci_req_clear_event_filter and hci_req_set_event_filter function. Doing both in one function doesn’t save much.

> +
> +static void hci_req_enable_le_suspend_scan(struct hci_request *req,
> +					   bool suspending)
> +{
> +	/* Can't change params without disabling first */
> +	hci_req_add_le_scan_disable(req);
> +
> +	/* Configure params and enable scanning */
> +	hci_req_add_le_passive_scan(req, suspending);
> +
> +	/* Block suspend notifier on response */
> +	set_bit(SUSPEND_LE_SET_SCAN_ENABLE, req->hdev->suspend.tasks);
> +}
> +
> +static void le_suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
> +{
> +	BT_DBG("Request complete opcode=0x%x, status=0x%x", opcode, status);
> +
> +	/* Expecting LE Set scan to return */
> +	if (opcode == HCI_OP_LE_SET_SCAN_ENABLE &&
> +	    test_and_clear_bit(SUSPEND_LE_SET_SCAN_ENABLE,
> +			       hdev->suspend.tasks)) {
> +		wake_up(&hdev->suspend.tasks_wait_q);
> +	}
> +}
> +
> +/* Call with hci_dev_lock */
> +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
> +{
> +	int old_state;
> +	struct hci_conn *conn;
> +	struct hci_request req;
> +
> +	if (next == hdev->suspend.state) {
> +		BT_DBG("Same state before and after: %d", next);
> +		goto done;
> +	}
> +
> +	hci_req_init(&req, hdev);
> +	if (next == BT_SUSPENDED) {
> +		/* Pause discovery if not already stopped */
> +		old_state = hdev->discovery.state;
> +		if (old_state != DISCOVERY_STOPPED) {
> +			set_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend.tasks);
> +			hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
> +			queue_work(hdev->req_workqueue, &hdev->discov_update);
> +		}
> +
> +		hdev->suspend.discovery_paused = true;
> +		hdev->suspend.discovery_old_state = old_state;
> +
> +		/* Stop advertising */
> +		old_state = hci_dev_test_flag(hdev, HCI_ADVERTISING);
> +		if (old_state) {
> +			set_bit(SUSPEND_PAUSE_ADVERTISING, hdev->suspend.tasks);
> +			cancel_delayed_work(&hdev->discov_off);
> +			queue_delayed_work(hdev->req_workqueue,
> +					   &hdev->discov_off, 0);
> +		}
> +
> +		hdev->suspend.advertising_paused = true;
> +		hdev->suspend.advertising_old_state = old_state;
> +
> +		/* Enable event filter for existing devices */
> +		hci_req_set_event_filter(&req, false);
> +
> +		/* Enable passive scan at lower duty cycle */
> +		hci_req_enable_le_suspend_scan(&req, true);
> +
> +		hdev->suspend.freeze_filters = true;
> +
> +		/* Run commands before disconnecting */
> +		hci_req_run(&req, le_suspend_req_complete);
> +
> +		hdev->suspend.disconnect_counter = 0;
> +		/* Soft disconnect everything (power off)*/
> +		list_for_each_entry(conn, &hdev->conn_hash.list, list) {
> +			hci_disconnect(conn, HCI_ERROR_REMOTE_POWER_OFF);
> +			hdev->suspend.disconnect_counter++;
> +		}
> +
> +		if (hdev->suspend.disconnect_counter > 0) {
> +			BT_DBG("Had %d disconnects. Will wait on them",
> +			       hdev->suspend.disconnect_counter);
> +			set_bit(SUSPEND_DISCONNECTING, hdev->suspend.tasks);
> +		}
> +	} else {
> +		hdev->suspend.freeze_filters = false;
> +
> +		/* Clear event filter */
> +		hci_req_set_event_filter(&req, true);
> +
> +		/* Reset passive/background scanning to normal */
> +		hci_req_enable_le_suspend_scan(&req, false);
> +
> +		/* Unpause advertising */
> +		hdev->suspend.advertising_paused = false;
> +		if (hdev->suspend.advertising_old_state) {
> +			set_bit(SUSPEND_UNPAUSE_ADVERTISING,
> +				hdev->suspend.tasks);
> +			hci_dev_set_flag(hdev, HCI_ADVERTISING);
> +			queue_work(hdev->req_workqueue,
> +				   &hdev->discoverable_update);
> +			hdev->suspend.advertising_old_state = 0;
> +		}
> +
> +		/* Unpause discovery */
> +		hdev->suspend.discovery_paused = false;
> +		if (hdev->suspend.discovery_old_state != DISCOVERY_STOPPED &&
> +		    hdev->suspend.discovery_old_state != DISCOVERY_STOPPING) {
> +			set_bit(SUSPEND_UNPAUSE_DISCOVERY, hdev->suspend.tasks);
> +			hci_discovery_set_state(hdev, DISCOVERY_STARTING);
> +			queue_work(hdev->req_workqueue, &hdev->discov_update);
> +		}
> +
> +		hci_req_run(&req, le_suspend_req_complete);
> +	}
> +
> +	hdev->suspend.state = next;
> +
> +done:
> +	clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend.tasks);
> +	wake_up(&hdev->suspend.tasks_wait_q);
> +}
> +
> static u8 get_cur_adv_instance_scan_rsp_len(struct hci_dev *hdev)
> {
> 	u8 instance = hdev->cur_adv_instance;
> @@ -2015,6 +2261,9 @@ void __hci_req_update_scan(struct hci_request *req)
> 	if (mgmt_powering_down(hdev))
> 		return;
> 
> +	if (hdev->suspend.freeze_filters)
> +		return;
> +
> 	if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
> 	    disconnected_whitelist_entries(hdev))
> 		scan = SCAN_PAGE;
> @@ -2538,7 +2787,7 @@ static int active_scan(struct hci_request *req, unsigned long opt)
> 		own_addr_type = ADDR_LE_DEV_PUBLIC;
> 
> 	hci_req_start_scan(req, LE_SCAN_ACTIVE, interval, DISCOV_LE_SCAN_WIN,
> -			   own_addr_type, 0);
> +			   own_addr_type, 0, LE_SCAN_FILTER_DUP_DISABLE);
> 	return 0;
> }
> 
> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> index a7019fbeadd3..f555bb789664 100644
> --- a/net/bluetooth/hci_request.h
> +++ b/net/bluetooth/hci_request.h
> @@ -66,7 +66,9 @@ void __hci_req_update_name(struct hci_request *req);
> void __hci_req_update_eir(struct hci_request *req);
> 
> void hci_req_add_le_scan_disable(struct hci_request *req);
> -void hci_req_add_le_passive_scan(struct hci_request *req);
> +void hci_req_add_le_passive_scan(struct hci_request *req, bool suspending);
> +
> +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next);
> 
> void hci_req_reenable_advertising(struct hci_dev *hdev);
> void __hci_req_enable_advertising(struct hci_request *req);
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 95092130f16c..e5bac060c999 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -24,6 +24,7 @@
> 
> /* Bluetooth HCI Management interface */
> 
> +#include <linux/delay.h>
> #include <linux/module.h>
> #include <asm/unaligned.h>
> 
> @@ -1385,6 +1386,12 @@ static int set_discoverable(struct sock *sk, struct hci_dev *hdev, void *data,
> 		goto failed;
> 	}
> 
> +	if (hdev->suspend.advertising_paused) {
> +		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_DISCOVERABLE,
> +				      MGMT_STATUS_BUSY);
> +		goto failed;
> +	}
> +
> 	if (!hdev_is_powered(hdev)) {
> 		bool changed = false;
> 
> @@ -3868,6 +3875,13 @@ void mgmt_start_discovery_complete(struct hci_dev *hdev, u8 status)
> 	}
> 
> 	hci_dev_unlock(hdev);
> +
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_UNPAUSE_DISCOVERY,
> +			       hdev->suspend.tasks)) {
> +		BT_DBG("Unpaused discovery");
> +		wake_up(&hdev->suspend.tasks_wait_q);
> +	}
> }
> 
> static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
> @@ -3929,6 +3943,13 @@ static int start_discovery_internal(struct sock *sk, struct hci_dev *hdev,
> 		goto failed;
> 	}
> 
> +	/* Can't start discovery when it is paused */
> +	if (hdev->suspend.discovery_paused) {
> +		err = mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_BUSY,
> +					&cp->type, sizeof(cp->type));
> +		goto failed;
> +	}
> +
> 	/* Clear the discovery filter first to free any previously
> 	 * allocated memory for the UUID list.
> 	 */
> @@ -4096,6 +4117,12 @@ void mgmt_stop_discovery_complete(struct hci_dev *hdev, u8 status)
> 	}
> 
> 	hci_dev_unlock(hdev);
> +
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend.tasks)) {
> +		BT_DBG("Paused discovery");
> +		wake_up(&hdev->suspend.tasks_wait_q);
> +	}
> }
> 
> static int stop_discovery(struct sock *sk, struct hci_dev *hdev, void *data,
> @@ -4327,6 +4354,17 @@ static void set_advertising_complete(struct hci_dev *hdev, u8 status,
> 	if (match.sk)
> 		sock_put(match.sk);
> 
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
> +			       hdev->suspend.tasks)) {
> +		BT_DBG("Paused advertising");
> +		wake_up(&hdev->suspend.tasks_wait_q);
> +	} else if (test_and_clear_bit(SUSPEND_UNPAUSE_ADVERTISING,
> +				      hdev->suspend.tasks)) {
> +		BT_DBG("Unpaused advertising");
> +		wake_up(&hdev->suspend.tasks_wait_q);
> +	}
> +
> 	/* If "Set Advertising" was just disabled and instance advertising was
> 	 * set up earlier, then re-enable multi-instance advertising.
> 	 */
> @@ -4378,6 +4416,10 @@ static int set_advertising(struct sock *sk, struct hci_dev *hdev, void *data,
> 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
> 				       MGMT_STATUS_INVALID_PARAMS);
> 
> +	if (hdev->suspend.advertising_paused)
> +		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
> +				       MGMT_STATUS_BUSY);
> +
> 	hci_dev_lock(hdev);
> 
> 	val = !!cp->val;
> @@ -4557,7 +4599,7 @@ static int set_scan_params(struct sock *sk, struct hci_dev *hdev,
> 		hci_req_init(&req, hdev);
> 
> 		hci_req_add_le_scan_disable(&req);
> -		hci_req_add_le_passive_scan(&req);
> +		hci_req_add_le_passive_scan(&req, false);
> 
> 		hci_req_run(&req, NULL);
> 	}
> @@ -7453,6 +7495,14 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
> 
> 	mgmt_event(MGMT_EV_DEVICE_DISCONNECTED, hdev, &ev, sizeof(ev), sk);
> 
> +	if (hdev->suspend.disconnect_counter > 0) {
> +		hdev->suspend.disconnect_counter--;
> +		if (hdev->suspend.disconnect_counter <= 0) {
> +			clear_bit(SUSPEND_DISCONNECTING, hdev->suspend.tasks);
> +			wake_up(&hdev->suspend.tasks_wait_q);
> +		}
> +	}
> +
> 	if (sk)
> 		sock_put(sk);

I might be wrong, but from an initial review, I feel we need to make this patch a lot simpler with regards to all its states. My proposal would be to break it down into a set of smaller changes and then build it from there.

Regards

Marcel

