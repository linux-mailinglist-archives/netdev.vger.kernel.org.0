Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69D117D2AE
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCHIjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Mar 2020 04:39:02 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59594 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCHIjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 04:39:02 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6A188CED15;
        Sun,  8 Mar 2020 09:48:28 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v4 5/5] Bluetooth: Pause discovery and advertising
 during suspend
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200303170610.RFC.v4.5.Iccdad520469ca3524a7e5966c5f88e5bca756e13@changeid>
Date:   Sun, 8 Mar 2020 09:38:59 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DB7CF910-5065-45A4-BD4E-A2FDA5B56E67@holtmann.org>
References: <20200304010650.259961-1-abhishekpandit@chromium.org>
 <20200303170610.RFC.v4.5.Iccdad520469ca3524a7e5966c5f88e5bca756e13@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> To prevent spurious wake ups, we disable any discovery or advertising
> when we enter suspend and restore it when we exit suspend. While paused,
> we disable any management requests to modify discovery or advertising.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
> * Refactored pause discovery + advertising into its own patch
> 
> include/net/bluetooth/hci_core.h | 11 ++++++++
> net/bluetooth/hci_request.c      | 43 ++++++++++++++++++++++++++++++++
> net/bluetooth/mgmt.c             | 41 ++++++++++++++++++++++++++++++
> 3 files changed, 95 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 4eb5b2786048..af264a247636 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -91,6 +91,12 @@ struct discovery_state {
> #define SUSPEND_NOTIFIER_TIMEOUT	msecs_to_jiffies(2000) /* 2 seconds */
> 
> enum suspend_tasks {
> +	SUSPEND_PAUSE_DISCOVERY,
> +	SUSPEND_UNPAUSE_DISCOVERY,
> +
> +	SUSPEND_PAUSE_ADVERTISING,
> +	SUSPEND_UNPAUSE_ADVERTISING,
> +
> 	SUSPEND_SCAN_DISABLE,
> 	SUSPEND_SCAN_ENABLE,
> 	SUSPEND_DISCONNECTING,
> @@ -409,6 +415,11 @@ struct hci_dev {
> 
> 	struct discovery_state	discovery;
> 
> +	int			discovery_old_state;
> +	bool			discovery_paused;
> +	int			advertising_old_state;
> +	bool			advertising_paused;
> +
> 	struct notifier_block	suspend_notifier;
> 	struct work_struct	suspend_prepare;
> 	enum suspended_state	suspend_state_next;
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index 88fd95d70f89..e25cfb6fd9aa 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -1036,6 +1036,28 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
> 		/* Mark device as suspended */
> 		hdev->suspended = true;
> 
> +		/* Pause discovery if not already stopped */
> +		old_state = hdev->discovery.state;
> +		if (old_state != DISCOVERY_STOPPED) {
> +			set_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend_tasks);
> +			hci_discovery_set_state(hdev, DISCOVERY_STOPPING);
> +			queue_work(hdev->req_workqueue, &hdev->discov_update);
> +		}
> +
> +		hdev->discovery_paused = true;
> +		hdev->discovery_old_state = old_state;
> +
> +		/* Stop advertising */
> +		old_state = hci_dev_test_flag(hdev, HCI_ADVERTISING);
> +		if (old_state) {
> +			set_bit(SUSPEND_PAUSE_ADVERTISING, hdev->suspend_tasks);
> +			cancel_delayed_work(&hdev->discov_off);
> +			queue_delayed_work(hdev->req_workqueue,
> +					   &hdev->discov_off, 0);
> +		}
> +
> +		hdev->advertising_paused = true;
> +		hdev->advertising_old_state = old_state;
> 		/* Disable page scan */
> 		page_scan = SCAN_DISABLED;
> 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
> @@ -1081,6 +1103,27 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
> 		hci_req_clear_event_filter(&req);
> 		/* Reset passive/background scanning to normal */
> 		hci_req_config_le_suspend_scan(&req);
> +
> +		/* Unpause advertising */
> +		hdev->advertising_paused = false;
> +		if (hdev->advertising_old_state) {
> +			set_bit(SUSPEND_UNPAUSE_ADVERTISING,
> +				hdev->suspend_tasks);
> +			hci_dev_set_flag(hdev, HCI_ADVERTISING);
> +			queue_work(hdev->req_workqueue,
> +				   &hdev->discoverable_update);
> +			hdev->advertising_old_state = 0;
> +		}
> +
> +		/* Unpause discovery */
> +		hdev->discovery_paused = false;
> +		if (hdev->discovery_old_state != DISCOVERY_STOPPED &&
> +		    hdev->discovery_old_state != DISCOVERY_STOPPING) {
> +			set_bit(SUSPEND_UNPAUSE_DISCOVERY, hdev->suspend_tasks);
> +			hci_discovery_set_state(hdev, DISCOVERY_STARTING);
> +			queue_work(hdev->req_workqueue, &hdev->discov_update);
> +		}
> +
> 		hci_req_run(&req, suspend_req_complete);
> 	}
> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index f6751ce0d561..28572579c06d 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -1387,6 +1387,12 @@ static int set_discoverable(struct sock *sk, struct hci_dev *hdev, void *data,
> 		goto failed;
> 	}
> 
> +	if (hdev->advertising_paused) {
> +		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_DISCOVERABLE,
> +				      MGMT_STATUS_BUSY);
> +		goto failed;
> +	}
> +
> 	if (!hdev_is_powered(hdev)) {
> 		bool changed = false;
> 
> @@ -3870,6 +3876,13 @@ void mgmt_start_discovery_complete(struct hci_dev *hdev, u8 status)
> 	}
> 
> 	hci_dev_unlock(hdev);
> +
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_UNPAUSE_DISCOVERY,
> +			       hdev->suspend_tasks)) {
> +		BT_DBG("Unpaused discovery");
> +		wake_up(&hdev->suspend_wait_q);
> +	}
> }
> 
> static bool discovery_type_is_valid(struct hci_dev *hdev, uint8_t type,
> @@ -3931,6 +3944,13 @@ static int start_discovery_internal(struct sock *sk, struct hci_dev *hdev,
> 		goto failed;
> 	}
> 
> +	/* Can't start discovery when it is paused */
> +	if (hdev->discovery_paused) {
> +		err = mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_BUSY,
> +					&cp->type, sizeof(cp->type));
> +		goto failed;
> +	}
> +
> 	/* Clear the discovery filter first to free any previously
> 	 * allocated memory for the UUID list.
> 	 */
> @@ -4098,6 +4118,12 @@ void mgmt_stop_discovery_complete(struct hci_dev *hdev, u8 status)
> 	}
> 
> 	hci_dev_unlock(hdev);
> +
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_PAUSE_DISCOVERY, hdev->suspend_tasks)) {
> +		BT_DBG("Paused discovery");
> +		wake_up(&hdev->suspend_wait_q);
> +	}
> }
> 
> static int stop_discovery(struct sock *sk, struct hci_dev *hdev, void *data,
> @@ -4329,6 +4355,17 @@ static void set_advertising_complete(struct hci_dev *hdev, u8 status,
> 	if (match.sk)
> 		sock_put(match.sk);
> 
> +	/* Handle suspend notifier */
> +	if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
> +			       hdev->suspend_tasks)) {
> +		BT_DBG("Paused advertising");
> +		wake_up(&hdev->suspend_wait_q);
> +	} else if (test_and_clear_bit(SUSPEND_UNPAUSE_ADVERTISING,
> +				      hdev->suspend_tasks)) {
> +		BT_DBG("Unpaused advertising");
> +		wake_up(&hdev->suspend_wait_q);
> +	}
> +
> 	/* If "Set Advertising" was just disabled and instance advertising was
> 	 * set up earlier, then re-enable multi-instance advertising.
> 	 */
> @@ -4380,6 +4417,10 @@ static int set_advertising(struct sock *sk, struct hci_dev *hdev, void *data,
> 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
> 				       MGMT_STATUS_INVALID_PARAMS);
> 
> +	if (hdev->advertising_paused)
> +		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
> +				       MGMT_STATUS_BUSY);
> +
> 	hci_dev_lock(hdev);
> 
> 	val = !!cp->val;

looks good. Just make this 4/5 and use bt_dev_dbg where possible.

Regards

Marcel

