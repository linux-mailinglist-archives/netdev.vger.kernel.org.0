Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55932357DCD
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 10:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhDHIKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Apr 2021 04:10:13 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:48821 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDHIKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 04:10:12 -0400
Received: from marcel-macbook.holtmann.net (p4ff9f418.dip0.t-ipconnect.de [79.249.244.24])
        by mail.holtmann.org (Postfix) with ESMTPSA id 07DD9CECEF;
        Thu,  8 Apr 2021 10:17:43 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v2] Bluetooth: Add ncmd=0 recovery handling
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210407193611.v2.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
Date:   Thu, 8 Apr 2021 10:09:59 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <617F9F1B-E389-4843-9B70-5B2F477FA1F0@holtmann.org>
References: <20210407193611.v2.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
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
> Changes in v2:
> - Emit the hardware error when ncmd=0 occurs
> 
> include/net/bluetooth/hci.h      |  1 +
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         | 15 +++++++++++++++
> net/bluetooth/hci_event.c        | 10 ++++++++++
> 4 files changed, 27 insertions(+)
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
> index b0d9c36acc03..c102a8763cb5 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2769,6 +2769,20 @@ static void hci_cmd_timeout(struct work_struct *work)
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
> +	/* This is an irrecoverable state. Inject hw error event to reset
> +	 * the device and driver.
> +	 */
> +	hci_reset_dev(hdev);

	/* This is an irrecoverable state, inject hardware error event */
	hci_reset_dev(hdev);

Since you will not be resetting the driver here. You just tell the core stack to reset itself and with HCI_Reset hopefully bring the hardware back to life. Or if the ncmd=0 is a hardware bug, just start sending a new command.

> +}
> +
> struct oob_data *hci_find_remote_oob_data(struct hci_dev *hdev,
> 					  bdaddr_t *bdaddr, u8 bdaddr_type)
> {
> @@ -3831,6 +3845,7 @@ struct hci_dev *hci_alloc_dev(void)
> 	init_waitqueue_head(&hdev->suspend_wait_q);
> 
> 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
> +	INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
> 
> 	hci_request_setup(hdev);
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index cf2f4a0abdbd..114a9170d809 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -3635,6 +3635,11 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
> 	if (*opcode != HCI_OP_NOP)
> 		cancel_delayed_work(&hdev->cmd_timer);
> 
> +	if (!ev->ncmd &&!test_bit(HCI_RESET, &hdev->flags))
> +		schedule_delayed_work(&hdev->ncmd_timer, HCI_NCMD_TIMEOUT);
> +	else
> +		cancel_delayed_work(&hdev->ncmd_timer);
> +
> 	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags))
> 		atomic_set(&hdev->cmd_cnt, 1);
> 

	if (!test_bit(HCI_RESET, &hdev->flags)) {
		if (ev->ncmd) {
			cancel_delayed_work(&hdev->ncmd_timer);
			atomic_set(&hdev->cmd_cnt, 1);
		} else {
			schedule_delayed_work(&hdev->ncmd_timer,
					      HCI_NCMD_TIMEOUT);
		}
	}

I think doing it this way is a bit cleaner and avoid the check of !ncmd and !HCI_RESET twice.

And I wonder if there isn’t a cancel_delayed_work missing in hci_dev_do_close or some related location when we are shutting down.

What do we do when this happens during HCI_INIT. I think if ncmd_timer triggers during HCI_INIT, then hci_up needs to be aborted and no hardware error event to be injected.

In addition since you are now calling hci_reset_dev also from the core stack (perviously, it was just up to the drivers to do that), I would add an extra error.

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fd12f1652bdf..1c9ef5608930 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4073,6 +4073,8 @@ int hci_reset_dev(struct hci_dev *hdev)
        hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
        skb_put_data(skb, hw_err, 3);
 
+       bt_dev_err(hdev, "Injecting HCI hardware error event");
+
        /* Send Hardware Error to upper stack */
        return hci_recv_frame(hdev, skb);
 }

This has the advantage that if you take a btmon trace, you know this event is injected. Or more precisely eventually will be able to know since we haven’t merged my patches yet that will redirect bt_dev_{err,warn,..} into btmon as well.

Regards

Marcel

