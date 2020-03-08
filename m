Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972C917D2A0
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgCHI2s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Mar 2020 04:28:48 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36967 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHI2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 04:28:47 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 695DFCED15;
        Sun,  8 Mar 2020 09:38:13 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v4 2/5] Bluetooth: Handle PM_SUSPEND_PREPARE and
 PM_POST_SUSPEND
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200303170610.RFC.v4.2.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
Date:   Sun, 8 Mar 2020 09:28:44 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6DAF70F7-A5C7-4BE8-BE5C-222235EA098D@holtmann.org>
References: <20200304010650.259961-1-abhishekpandit@chromium.org>
 <20200303170610.RFC.v4.2.I62f17edc39370044c75ad43a55a7382b4b8a5ceb@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Register for PM_SUSPEND_PREPARE and PM_POST_SUSPEND to make sure the
> Bluetooth controller is prepared correctly for suspend/resume. Implement
> the registration, scheduling and task handling portions only in this
> patch.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v4:
> * Added check for mgmt_powering_down and hdev_is_powered in notifier
> 
> Changes in v3: None
> Changes in v2:
> * Moved pm notifier registration into its own patch and moved params out
>  of separate suspend_state
> 
> include/net/bluetooth/hci_core.h | 23 +++++++++
> net/bluetooth/hci_core.c         | 86 ++++++++++++++++++++++++++++++++
> net/bluetooth/hci_request.c      | 19 +++++++
> net/bluetooth/hci_request.h      |  2 +
> 4 files changed, 130 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 9d9ada5bc9d4..b82a89b88d1b 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -88,6 +88,20 @@ struct discovery_state {
> 	unsigned long		scan_duration;
> };
> 
> +#define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
> +
> +enum suspend_tasks {
> +	SUSPEND_POWERING_DOWN,
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
> struct hci_conn_hash {
> 	struct list_head list;
> 	unsigned int     acl_num;
> @@ -389,6 +403,15 @@ struct hci_dev {
> 	void			*smp_bredr_data;
> 
> 	struct discovery_state	discovery;
> +
> +	struct notifier_block	suspend_notifier;
> +	struct work_struct	suspend_prepare;
> +	enum suspended_state	suspend_state_next;
> +	enum suspended_state	suspend_state;
> +
> +	wait_queue_head_t	suspend_wait_q;
> +	DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
> +
> 	struct hci_conn_hash	conn_hash;
> 
> 	struct list_head	mgmt_pending;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index b0b0308127a3..ad89ff3f8f57 100644
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
> @@ -1764,6 +1766,9 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 	clear_bit(HCI_RUNNING, &hdev->flags);
> 	hci_sock_dev_event(hdev, HCI_DEV_CLOSE);
> 
> +	if (test_and_clear_bit(SUSPEND_POWERING_DOWN, hdev->suspend_tasks))
> +		wake_up(&hdev->suspend_wait_q);
> +
> 	/* After this point our queues are empty
> 	 * and no tasks are scheduled. */
> 	hdev->close(hdev);
> @@ -3241,6 +3246,78 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
> 	}
> }
> 
> +static int hci_suspend_wait_event(struct hci_dev *hdev)
> +{
> +#define WAKE_COND                                                              \
> +	(find_first_bit(hdev->suspend_tasks, __SUSPEND_NUM_TASKS) ==           \
> +	 __SUSPEND_NUM_TASKS)
> +
> +	int i;
> +	int ret = wait_event_timeout(hdev->suspend_wait_q,
> +				     WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
> +
> +	if (ret == 0) {
> +		BT_DBG("Timed out waiting for suspend");
> +		for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
> +			if (test_bit(i, hdev->suspend_tasks))
> +				BT_DBG("Bit %d is set", i);
> +			clear_bit(i, hdev->suspend_tasks);
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
> +		container_of(work, struct hci_dev, suspend_prepare);
> +
> +	hci_dev_lock(hdev);
> +	hci_req_prepare_suspend(hdev, hdev->suspend_state_next);
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
> +	/* If powering down, wait for completion. */
> +	if (mgmt_powering_down(hdev)) {
> +		set_bit(SUSPEND_POWERING_DOWN, hdev->suspend_tasks);
> +		ret = hci_suspend_wait_event(hdev);
> +		if (ret)
> +			goto done;
> +	}
> +
> +	/* Suspend notifier should only act on events when powered. */
> +	if (!hdev_is_powered(hdev))
> +		goto done;
> +
> +	if (action == PM_SUSPEND_PREPARE) {
> +		hdev->suspend_state_next = BT_SUSPENDED;
> +		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
> +		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
> +
> +		ret = hci_suspend_wait_event(hdev);
> +	} else if (action == PM_POST_SUSPEND) {
> +		hdev->suspend_state_next = BT_RUNNING;
> +		set_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
> +		queue_work(hdev->req_workqueue, &hdev->suspend_prepare);
> +
> +		ret = hci_suspend_wait_event(hdev);
> +	}
> +
> +done:
> +	return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
> +}
> /* Alloc HCI device */
> struct hci_dev *hci_alloc_dev(void)
> {
> @@ -3319,6 +3396,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	INIT_WORK(&hdev->tx_work, hci_tx_work);
> 	INIT_WORK(&hdev->power_on, hci_power_on);
> 	INIT_WORK(&hdev->error_reset, hci_error_reset);
> +	INIT_WORK(&hdev->suspend_prepare, hci_prepare_suspend);
> 
> 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
> 
> @@ -3327,6 +3405,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	skb_queue_head_init(&hdev->raw_q);
> 
> 	init_waitqueue_head(&hdev->req_wait_q);
> +	init_waitqueue_head(&hdev->suspend_wait_q);
> 
> 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
> 
> @@ -3438,6 +3517,11 @@ int hci_register_dev(struct hci_dev *hdev)
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
> @@ -3471,6 +3555,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
> 
> 	hci_dev_do_close(hdev);
> 
> +	unregister_pm_notifier(&hdev->suspend_notifier);
> +
> 	if (!test_bit(HCI_INIT, &hdev->flags) &&
> 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
> 	    !hci_dev_test_flag(hdev, HCI_CONFIG)) {
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 2a1b64dbf76e..08908469c043 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -918,6 +918,25 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
> 	return adv_instance->scan_rsp_len;
> }
> 
> +/* Call with hci_dev_lock */
> +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
> +{
> +	int old_state;
> +	struct hci_conn *conn;
> +	struct hci_request req;
> +
> +	if (next == hdev->suspend_state) {
> +		BT_DBG("Same state before and after: %d", next);
> +		goto done;
> +	}
> +
> +	hdev->suspend_state = next;
> +
> +done:
> +	clear_bit(SUSPEND_PREPARE_NOTIFIER, hdev->suspend_tasks);
> +	wake_up(&hdev->suspend_wait_q);
> +}
> +
> static u8 get_cur_adv_instance_scan_rsp_len(struct hci_dev *hdev)
> {
> 	u8 instance = hdev->cur_adv_instance;
> diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
> index a7019fbeadd3..0e81614d235e 100644
> --- a/net/bluetooth/hci_request.h
> +++ b/net/bluetooth/hci_request.h
> @@ -68,6 +68,8 @@ void __hci_req_update_eir(struct hci_request *req);
> void hci_req_add_le_scan_disable(struct hci_request *req);
> void hci_req_add_le_passive_scan(struct hci_request *req);
> 
> +void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next);
> +
> void hci_req_reenable_advertising(struct hci_dev *hdev);
> void __hci_req_enable_advertising(struct hci_request *req);
> void __hci_req_disable_advertising(struct hci_request *req);

patch looks good. However lets start using bt_dev_dbg where possible and make this 1/5 please.

Regards

Marcel

