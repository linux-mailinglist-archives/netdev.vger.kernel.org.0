Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1436368D9B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 09:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbhDWHGv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 03:06:51 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36386 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWHGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 03:06:49 -0400
Received: from marcel-macbook.holtmann.net (p4fefc624.dip0.t-ipconnect.de [79.239.198.36])
        by mail.holtmann.org (Postfix) with ESMTPSA id BF39FCECFB;
        Fri, 23 Apr 2021 09:13:58 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3] Bluetooth: Add ncmd=0 recovery handling
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210422101657.v3.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
Date:   Fri, 23 Apr 2021 09:06:10 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C4B3A9F0-2D1D-4274-92AE-8616258E5947@holtmann.org>
References: <20210422101657.v3.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> During command status or command complete event, the controller may set
> ncmd=0 indicating that it is not accepting any more commands. In such a
> case, host holds off sending any more commands to the controller. If the
> controller doesn't recover from such condition, host will wait forever,
> until the user decides that the Bluetooth is broken and may power cycles
> the Bluetooth.
> 
> This patch triggers the hardware error to reset the controller and
> driver when it gets into such state as there is no other wat out.
> 
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> Changes in v3:
> - Restructure ncmd_timer scheduling in hci_event.c
> - Cancel delayed work in hci_dev_do_close
> - Do not inject hw error during HCI_INIT
> - Update comment, add log message while injecting hw error
> 
> Changes in v2:
> - Emit the hardware error when ncmd=0 occurs
> 
> include/net/bluetooth/hci.h      |  1 +
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         | 22 ++++++++++++++++++++++
> net/bluetooth/hci_event.c        | 22 ++++++++++++++++++----
> 4 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index ea4ae551c426..c4b0650fb9ae 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -339,6 +339,7 @@ enum {
> #define HCI_PAIRING_TIMEOUT	msecs_to_jiffies(60000)	/* 60 seconds */
> #define HCI_INIT_TIMEOUT	msecs_to_jiffies(10000)	/* 10 seconds */
> #define HCI_CMD_TIMEOUT		msecs_to_jiffies(2000)	/* 2 seconds */
> +#define HCI_NCMD_TIMEOUT	msecs_to_jiffies(4000)	/* 4 seconds */
> #define HCI_ACL_TX_TIMEOUT	msecs_to_jiffies(45000)	/* 45 seconds */
> #define HCI_AUTO_OFF_TIMEOUT	msecs_to_jiffies(2000)	/* 2 seconds */
> #define HCI_POWER_OFF_TIMEOUT	msecs_to_jiffies(5000)	/* 5 seconds */
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index ebdd4afe30d2..f14692b39fd5 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -470,6 +470,7 @@ struct hci_dev {
> 	struct delayed_work	service_cache;
> 
> 	struct delayed_work	cmd_timer;
> +	struct delayed_work	ncmd_timer;
> 
> 	struct work_struct	rx_work;
> 	struct work_struct	cmd_work;
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index b0d9c36acc03..37789c5d0579 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1723,6 +1723,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 	}
> 
> 	cancel_delayed_work(&hdev->power_off);
> +	cancel_delayed_work(&hdev->ncmd_timer);
> 
> 	hci_request_cancel_all(hdev);
> 	hci_req_sync_lock(hdev);
> @@ -2769,6 +2770,24 @@ static void hci_cmd_timeout(struct work_struct *work)
> 	queue_work(hdev->workqueue, &hdev->cmd_work);
> }
> 
> +/* HCI ncmd timer function */
> +static void hci_ncmd_timeout(struct work_struct *work)
> +{
> +	struct hci_dev *hdev = container_of(work, struct hci_dev,
> +					    ncmd_timer.work);
> +
> +	bt_dev_err(hdev, "Controller not accepting commands anymore: ncmd = 0");
> +
> +	/* No hardware error event needs to be injected if the ncmd timer
> +	 * triggers during HCI_INIT.
> +	 */

while the patch looks good, I would be more strongly with my wording here.

	/* During HCI_INIT phase no events can be injected if the ncmd timer
	 * triggers since the procedure has its own timeout handling.
	 */

> +	if (test_bit(HCI_INIT, &hdev->flags))
> +		return;
> +
> +	/* This is an irrecoverable state, inject hardware error event */
> +	hci_reset_dev(hdev);
> +}
> +
> struct oob_data *hci_find_remote_oob_data(struct hci_dev *hdev,
> 					  bdaddr_t *bdaddr, u8 bdaddr_type)
> {
> @@ -3831,6 +3850,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	init_waitqueue_head(&hdev->suspend_wait_q);
> 
> 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
> +	INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
> 
> 	hci_request_setup(hdev);
> 
> @@ -4068,6 +4088,8 @@ int hci_reset_dev(struct hci_dev *hdev)
> 	hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
> 	skb_put_data(skb, hw_err, 3);
> 
> +	bt_dev_err(hdev, "Injecting HCI hardware error event");
> +
> 	/* Send Hardware Error to upper stack */
> 	return hci_recv_frame(hdev, skb);
> }
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index cf2f4a0abdbd..8cd4bcf5dd00 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3635,8 +3635,15 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
> 	if (*opcode != HCI_OP_NOP)
> 		cancel_delayed_work(&hdev->cmd_timer);
> 
> -	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags))
> -		atomic_set(&hdev->cmd_cnt, 1);
> +	if (!test_bit(HCI_RESET, &hdev->flags)) {
> +		if (ev->ncmd) {
> +			cancel_delayed_work(&hdev->ncmd_timer);
> +			atomic_set(&hdev->cmd_cnt, 1);
> +		} else {
> +			schedule_delayed_work(&hdev->ncmd_timer,
> +					      HCI_NCMD_TIMEOUT);
> +		}
> +	}
> 
> 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
> 			     req_complete_skb);
> @@ -3740,8 +3747,15 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
> 	if (*opcode != HCI_OP_NOP)
> 		cancel_delayed_work(&hdev->cmd_timer);
> 
> -	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags))
> -		atomic_set(&hdev->cmd_cnt, 1);
> +	if (!test_bit(HCI_RESET, &hdev->flags)) {
> +		if (ev->ncmd) {
> +			cancel_delayed_work(&hdev->ncmd_timer);
> +			atomic_set(&hdev->cmd_cnt, 1);
> +		} else {
> +			schedule_delayed_work(&hdev->ncmd_timer,
> +					      HCI_NCMD_TIMEOUT);
> +		}
> +	}
> 

Since the code is getting a bit more complex now, I would prefer that in a follow up patch we provide a common helper function for this.

	static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, bool is_nop)
	{
		if (!is_nop)
			cancel_delayed_work(&hdev->cmd_timer);

		if (!test_bit(HCI_RESET, ..) {
			..
		}
	}

And then you can just do:

	handle_cmd_cnt_and_timer(hdev, *opcode == HCI_OP_NOP);

Or something similar to this.

Regards

Marcel

