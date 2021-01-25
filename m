Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EB930343E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbhAZFUu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:20:50 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:48839 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbhAYPq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:46:59 -0500
Received: from marcel-macbook.holtmann.net (p4ff9f11c.dip0.t-ipconnect.de [79.249.241.28])
        by mail.holtmann.org (Postfix) with ESMTPSA id EAD99CECCA;
        Mon, 25 Jan 2021 16:20:27 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3] Bluetooth: Keep MSFT ext info throughout ahci_dev's
 life cycle
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210121163801.v3.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
Date:   Mon, 25 Jan 2021 16:13:02 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <070E7413-A3E3-4FEB-80BC-D3DD922DA19B@holtmann.org>
References: <20210121163801.v3.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This moves msft_do_close() from hci_dev_do_close() to
> hci_unregister_dev() to avoid clearing MSFT extension info. This also
> avoids retrieving MSFT info upon every msft_do_open() if MSFT extension
> has been initialized.
> 
> The following test steps were performed.
> (1) boot the test device and verify the MSFT support debug log in syslog
> (2) restart bluetoothd and verify msft_do_close() doesn't get invoked
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> ---
> Hi Maintainers,
> 
> This patch fixes the life cycle of MSFT HCI extension. The current
> symmetric calls to msft_do{open,close} in hci_dev_do_{open,close} cause
> incorrect MSFT features during bluetoothd start-up. After the kernel
> powers on the controller to register the hci_dev, it performs
> hci_dev_do_close() which call msft_do_close() and MSFT data gets wiped
> out. And then during the startup of bluetoothd, Adv Monitor Manager
> relies on reading the MSFT features from the kernel to present the
> feature set of the controller to D-Bus clients. However, the power state
> of the controller is off during the init of D-Bus interfaces. As a
> result, invalid MSFT features are returned by the kernel, since it was
> previously wiped out due to hci_dev_do_close().

then just keep the values around and not wipe them. However I prefer still to keep the symmetry and re-read the value every time we init. We can make sure to release the msft_data on unregister.

Regards

Marcel

