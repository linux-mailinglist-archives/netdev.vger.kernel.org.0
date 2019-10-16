Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA3D99F9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406576AbfJPT12 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 15:27:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50892 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfJPT12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:27:28 -0400
Received: from surfer-172-29-2-69-hotspot.internet-for-guests.com (p578ac27a.dip0.t-ipconnect.de [87.138.194.122])
        by mail.holtmann.org (Postfix) with ESMTPSA id 655A2CECDE;
        Wed, 16 Oct 2019 21:36:24 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH] Bluetooth: hci_core: fix init with
 HCI_QUIRK_NON_PERSISTENT_SETUP
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191004000933.24575-1-mkorpershoek@baylibre.com>
Date:   Wed, 16 Oct 2019 21:27:25 +0200
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <474814D3-A97F-48D1-8268-3D200BE60795@holtmann.org>
References: <20191004000933.24575-1-mkorpershoek@baylibre.com>
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattijs,

> Some HCI devices which have the HCI_QUIRK_NON_PERSISTENT_SETUP [1]
> require a call to setup() to be ran after every open().
> 
> During the setup() stage, these devices expect the chip to acknowledge
> its setup() completion via vendor specific frames.
> 
> If userspace opens() such HCI device in HCI_USER_CHANNEL [2] mode,
> the vendor specific frames are never tranmitted to the driver, as
> they are filtered in hci_rx_work().
> 
> Allow HCI devices which have HCI_QUIRK_NON_PERSISTENT_SETUP to process
> frames if the HCI device is is HCI_INIT state.
> 
> [1] https://lore.kernel.org/patchwork/patch/965071/
> [2] https://www.spinics.net/lists/linux-bluetooth/msg37345.html
> 
> Fixes: 740011cfe948 ("Bluetooth: Add new quirk for non-persistent setup settings")
> Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
> ---
> Some more background on the change follows:
> 
> The Android bluetooth stack (Bluedroid) also has a HAL implementation
> which follows Linux's standard rfkill interface [1].
> 
> This implementation relies on the HCI_CHANNEL_USER feature to get
> exclusive access to the underlying bluetooth device.
> 
> When testing this along with the btkmtksdio driver, the
> chip appeared unresponsive when calling the following from userspace:
> 
>    struct sockaddr_hci addr;
>    int fd;
> 
>    fd = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
> 
>    memset(&addr, 0, sizeof(addr));
>    addr.hci_family = AF_BLUETOOTH;
>    addr.hci_dev = 0;
>    addr.hci_channel = HCI_CHANNEL_USER;
> 
>    bind(fd, (struct sockaddr *) &addr, sizeof(addr)); # device hangs
> 
> In the case of bluetooth drivers exposing QUIRK_NON_PERSISTENT_SETUP
> such as btmtksdio, setup() is called each multiple times.
> In particular, when userspace calls bind(), the setup() is called again
> and vendor specific commands might be send to re-initialize the chip.
> 
> Those commands are filtered out by hci_core in HCI_CHANNEL_USER mode,
> preventing setup() from completing successfully.
> 
> This has been tested on a 4.19 kernel based on Android Common Kernel.
> It has also been compile tested on bluetooth-next.
> 
> [1] https://android.googlesource.com/platform/system/bt/+/refs/heads/master/vendor_libs/linux/interface/
> 
> net/bluetooth/hci_core.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 04bc79359a17..5f12e8574d54 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -4440,9 +4440,20 @@ static void hci_rx_work(struct work_struct *work)
> 			hci_send_to_sock(hdev, skb);
> 		}
> 
> +		/* If the device has been opened in HCI_USER_CHANNEL,
> +		 * the userspace has exclusive access to device.
> +		 * When HCI_QUIRK_NON_PERSISTENT_SETUP is set and
> +		 * device is HCI_INIT,  we still need to process
> +		 * the data packets to the driver in order
> +		 * to complete its setup().
> +		 */
> 		if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> -			kfree_skb(skb);
> -			continue;
> +			if (!test_bit(HCI_QUIRK_NON_PERSISTENT_SETUP,
> +				      &hdev->quirks) ||
> +			    !test_bit(HCI_INIT, &hdev->flags)) {
> +				kfree_skb(skb);
> +				continue;
> +			}
> 		}

	if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
	    !test_bit(HCI_INIT, &hdev->flags)) {
		kfree_skb(skb);
		continue;
	}

Wouldn’t it be enough to just add a check for HCI_INIT to this. I mean it makes no difference if ->setup is repeated on each device open or not. We want to process event during HCI_INIT when in user channel mode.

Regards

Marcel

