Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34398DA503
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 07:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388817AbfJQFL7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Oct 2019 01:11:59 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54251 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732590AbfJQFL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 01:11:59 -0400
Received: from surfer-172-29-2-69-hotspot.internet-for-guests.com (p2E5701B0.dip0.t-ipconnect.de [46.87.1.176])
        by mail.holtmann.org (Postfix) with ESMTPSA id 28616CECE2;
        Thu, 17 Oct 2019 07:20:56 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [PATCH v2] Bluetooth: hci_core: fix init for HCI_USER_CHANNEL
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191017032039.18413-1-mkorpershoek@baylibre.com>
Date:   Thu, 17 Oct 2019 07:11:57 +0200
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0B1D4151-BB95-47A6-B062-686DF7362A6B@holtmann.org>
References: <474814D3-A97F-48D1-8268-3D200BE60795@holtmann.org>
 <20191017032039.18413-1-mkorpershoek@baylibre.com>
To:     Mattijs Korpershoek <mkorpershoek@baylibre.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mattijs,

> During the setup() stage, HCI device drivers expect the chip to
> acknowledge its setup() completion via vendor specific frames.
> 
> If userspace opens() such HCI device in HCI_USER_CHANNEL [1] mode,
> the vendor specific frames are never tranmitted to the driver, as
> they are filtered in hci_rx_work().
> 
> Allow HCI devices which operate in HCI_USER_CHANNEL mode to receive
> frames if the HCI device is is HCI_INIT state.
> 
> [1] https://www.spinics.net/lists/linux-bluetooth/msg37345.html
> 
> Fixes: 23500189d7e0 ("Bluetooth: Introduce new HCI socket channel for user operation")
> Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
> ---
> Changelog:
> v2:
> * change test logic to transfer packets when in INIT phase
>  for user channel mode as recommended by Marcel
> * renamed patch from
>  "Bluetooth: hci_core: fix init with HCI_QUIRK_NON_PERSISTENT_SETUP"
> 
> v1:
> * https://lkml.org/lkml/2019/10/3/2250
> 
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
> net/bluetooth/hci_core.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

