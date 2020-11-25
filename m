Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E432C415C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 14:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgKYNrU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Nov 2020 08:47:20 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59644 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKYNrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 08:47:20 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id B42A0CED07;
        Wed, 25 Nov 2020 14:54:29 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH 0/3] Bluetooth: Power down controller when suspending
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CANFp7mVSGNbwCkWCj=bVzbE8L38nwu0+UMR9jkOYcYQmGBaAEw@mail.gmail.com>
Date:   Wed, 25 Nov 2020 14:47:16 +0100
Cc:     crlo@marvell.com, akarwar@marvell.com,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Daniel Winkler <danielwinkler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F681A79B-D4BC-465B-9102-C0322FF8D01F@holtmann.org>
References: <20201118234352.2138694-1-abhishekpandit@chromium.org>
 <7235CD4E-963C-4BCB-B891-62494AD7F10D@holtmann.org>
 <CANFp7mVSGNbwCkWCj=bVzbE8L38nwu0+UMR9jkOYcYQmGBaAEw@mail.gmail.com>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

>>> This patch series adds support for a quirk that will power down the
>>> Bluetooth controller when suspending and power it back up when resuming.
>>> 
>>> On Marvell SDIO Bluetooth controllers (SD8897 and SD8997), we are seeing
>>> a large number of suspend failures with the following log messages:
>>> 
>>> [ 4764.773873] Bluetooth: hci_cmd_timeout() hci0 command 0x0c14 tx timeout
>>> [ 4767.777897] Bluetooth: btmrvl_enable_hs() Host sleep enable command failed
>>> [ 4767.777920] Bluetooth: btmrvl_sdio_suspend() HS not actived, suspend failed!
>>> [ 4767.777946] dpm_run_callback(): pm_generic_suspend+0x0/0x48 returns -16
>>> [ 4767.777963] call mmc2:0001:2+ returned -16 after 4882288 usecs
>>> 
>>> The daily failure rate with this signature is quite significant and
>>> users are likely facing this at least once a day (and some unlucky users
>>> are likely facing it multiple times a day).
>>> 
>>> Given the severity, we'd like to power off the controller during suspend
>>> so the driver doesn't need to take any action (or block in any way) when
>>> suspending and power on during resume. This will break wake-on-bt for
>>> users but should improve the reliability of suspend.
>>> 
>>> We don't want to force all users of MVL8897 and MVL8997 to encounter
>>> this behavior if they're not affected (especially users that depend on
>>> Bluetooth for keyboard/mouse input) so the new behavior is enabled via
>>> module param. We are limiting this quirk to only Chromebooks (i.e.
>>> laptop). Chromeboxes will continue to have the old behavior since users
>>> may depend on BT HID to wake and use the system.
>> 
>> I don’t have a super great feeling with this change.
>> 
>> So historically only hciconfig hci0 up/down was doing a power cycle of the controller and when adding the mgmt interface we moved that to the mgmt interface. In addition we added a special case of power up via hdev->setup. We never had an intention that the kernel otherwise can power up/down the controller as it pleases.
> 
> Aside from the powered setting, the stack is resilient to the
> controller crashing (which would be akin to a power off and power on).
> From the view of bluez, adapter lost and power down should be almost
> equivalent right? ChromeOS has several platforms where Bluetooth has
> been reset after suspend, usually due USB being powered off in S3, and
> the stack is still well-behaving when that occurs.

it gets multitudes more complicated if you look at HCI User Channel and other pieces that utilize the core HCI infrastructure.

HCI interface lost, because of USB disconnect is different. That is a clean path. Similar to RFKILL that just only does a power down.

>> Can we ask Marvell first to investigate why this is fundamentally broken with their hardware?
> 
> +Chin-Ran Lo and +Amitkumar Karwar (added based on changes to
> drivers/bluetooth/btmrvl_main.c)
> 
> Could you please take a look at the original cover letter and comment
> (or add others at Marvell who may be able to)? Is this a known issue
> or a fix?

I wonder if sending a HCI Reset at before entering suspend would be enough. Meaning clear all controller states first and then suspend. This will still disable any kind of remote wakeup support, but might avoid having to fully power down and power up again.

>> Since what you are proposing is a pretty heavy change that might has side affects. For example the state machine for the mgmt interface has no concept of a power down/up from the kernel. It is all triggered by bluetoothd.
>> 
>> I am careful here since the whole power up/down path is already complicated enough.
>> 
> 
> That sounds reasonable. I have landed this within ChromeOS so we can
> test whether a) this improves stability enough and b) whether the
> power off/on in the kernel has significant side effects. This will go
> through our automated testing and dogfooding over the next few weeks
> and hopefully identify those side-effects. I will re-raise this topic
> with updates once we have more data.
> 
> Also, in case it wasn't very clear, I put this behind a module param
> that defaults to False because this is so heavy handed. We're only
> using it on specific Chromebooks that are exhibiting the worst
> behavior and not disabling it wholesale for all btmrvl controllers.

We really need a conformance hci-tester that checks if a controller is behaving correctly as promised.

Regards

Marcel

