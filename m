Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A32C04D8
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgKWLqH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Nov 2020 06:46:07 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:50105 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgKWLqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:46:06 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 869A3CECCF;
        Mon, 23 Nov 2020 12:53:15 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH 0/3] Bluetooth: Power down controller when suspending
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201118234352.2138694-1-abhishekpandit@chromium.org>
Date:   Mon, 23 Nov 2020 12:46:02 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org, mcchou@chromium.org,
        danielwinkler@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7235CD4E-963C-4BCB-B891-62494AD7F10D@holtmann.org>
References: <20201118234352.2138694-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> This patch series adds support for a quirk that will power down the
> Bluetooth controller when suspending and power it back up when resuming.
> 
> On Marvell SDIO Bluetooth controllers (SD8897 and SD8997), we are seeing
> a large number of suspend failures with the following log messages:
> 
> [ 4764.773873] Bluetooth: hci_cmd_timeout() hci0 command 0x0c14 tx timeout
> [ 4767.777897] Bluetooth: btmrvl_enable_hs() Host sleep enable command failed
> [ 4767.777920] Bluetooth: btmrvl_sdio_suspend() HS not actived, suspend failed!
> [ 4767.777946] dpm_run_callback(): pm_generic_suspend+0x0/0x48 returns -16
> [ 4767.777963] call mmc2:0001:2+ returned -16 after 4882288 usecs
> 
> The daily failure rate with this signature is quite significant and
> users are likely facing this at least once a day (and some unlucky users
> are likely facing it multiple times a day).
> 
> Given the severity, we'd like to power off the controller during suspend
> so the driver doesn't need to take any action (or block in any way) when
> suspending and power on during resume. This will break wake-on-bt for
> users but should improve the reliability of suspend.
> 
> We don't want to force all users of MVL8897 and MVL8997 to encounter
> this behavior if they're not affected (especially users that depend on
> Bluetooth for keyboard/mouse input) so the new behavior is enabled via
> module param. We are limiting this quirk to only Chromebooks (i.e.
> laptop). Chromeboxes will continue to have the old behavior since users
> may depend on BT HID to wake and use the system.

I don’t have a super great feeling with this change.

So historically only hciconfig hci0 up/down was doing a power cycle of the controller and when adding the mgmt interface we moved that to the mgmt interface. In addition we added a special case of power up via hdev->setup. We never had an intention that the kernel otherwise can power up/down the controller as it pleases.

Can we ask Marvell first to investigate why this is fundamentally broken with their hardware? Since what you are proposing is a pretty heavy change that might has side affects. For example the state machine for the mgmt interface has no concept of a power down/up from the kernel. It is all triggered by bluetoothd.

I am careful here since the whole power up/down path is already complicated enough.

Regards

Marcel

