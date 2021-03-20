Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9386342EA3
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 18:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCTRda convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 20 Mar 2021 13:33:30 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35919 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 13:33:29 -0400
Received: from mac-pro.holtmann.net (p4fefce19.dip0.t-ipconnect.de [79.239.206.25])
        by mail.holtmann.org (Postfix) with ESMTPSA id 33FD2CECF7;
        Sat, 20 Mar 2021 18:41:05 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v1] Bluetooth: Add ncmd=0 recovery handling
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210319131533.v1.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
Date:   Sat, 20 Mar 2021 18:33:26 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DC038B82-5539-48D5-84BE-4575F2E794AD@holtmann.org>
References: <20210319131533.v1.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> During command status or command complete event, the controller may set
> ncmd=0 indicating that it is not accepting any more commands. In such a
> case, host holds off sending any more commands to the controller. If the
> controller doesn't recover from such condition, host will wait forever.
> 
> This patch adds a timer when controller gets into such condition and
> resets the controller if controller doesn't recover within the timeout
> period.
> 
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> Hello Maintainers,
> 
> We noticed that during suspend, sometimes the controller firmware gets
> into a state where it is not accepting any more commands (it returns
> ncmd=0 in Command Status):
> 
> < HCI Command: Disconnect (0x01|0x0006) plen 3  #398 [hci0] 83.760502
>         Handle: 1
>         Reason: Remote Device Terminated due to Power Off (0x15)
>> HCI Event: Command Status (0x0f) plen 4       #399 [hci0] 83.761694
>       Disconnect (0x01|0x0006) ncmd 0
>         Status: Success (0x00)
> 
> In such a case, the host holds off sending any more packets to the
> controller until it is ready to accept more commands. If the controller
> doesn't recover from such a condition, Command Timeout does not get
> triggered as Command Timeout is queued only once the packet is sent to
> the controller; hence, the host will wait forever. 
> 
> This patch adds a timer to recover from this condition. Since the
> suspend timeout is 2 seconds, I'm using 4 seconds timeout to recover
> from ncmd=0. This should give ample amount of time for recovery and
> should not create any race conditions with the suspend. Once we resume
> from the suspend normally, the timer would expire and reset the
> controller. I have verified this patch locally and able to connect to
> peer device after resume from suspend. Please let me know your thoughts
> on this.
> 
> Thanks,
> Manish.
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
> index b0d9c36acc03..5ee1609456bd 100644
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
> +	bt_dev_err(hdev, "ncmd timeout");
> +
> +	if (hci_dev_do_close(hdev))
> +		return;
> +
> +	hci_dev_do_open(hdev);
> +}
> +

I am pretty certain this can dead-lock if ncmd=0 happens inside hci_dev_do_open,do_close itself.

The second thing is that do_close+do_open is heavy hammer you are swinging here. It will also result in mgmt powered down/up. Is this something you really want since bluetoothd will notice this and has to re-init everything.

Regards

Marcel

