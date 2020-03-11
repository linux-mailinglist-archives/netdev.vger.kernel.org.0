Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7D181EA0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgCKRF0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Mar 2020 13:05:26 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:33594 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCKRF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:05:26 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 4829ECECE2;
        Wed, 11 Mar 2020 18:14:53 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v6 0/5] Bluetooth: Handle system suspend gracefully
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200311155404.209990-1-abhishekpandit@chromium.org>
Date:   Wed, 11 Mar 2020 18:05:24 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <99C097F2-FD84-49B8-B3D7-F03C34C4F563@holtmann.org>
References: <20200311155404.209990-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> This patch series prepares the Bluetooth controller for system suspend
> by disconnecting all devices and preparing the event filter and LE
> whitelist with devices that can wake the system from suspend.
> 
> The main motivation for doing this is so we can enable Bluetooth as
> a wake up source during suspend without it being noisy. Bluetooth should
> wake the system when a HID device receives user input but otherwise not
> send any events to the host.
> 
> This patch series was tested on several Chromebooks with both btusb and
> hci_serdev on kernel 4.19. The set of tests was basically the following:
> * Reconnects after suspend succeed
> * HID devices can wake the system from suspend (needs some related bluez
>  changes to call the Set Wake Capable management command)
> * System properly pauses and unpauses discovery + advertising around
>  suspend
> * System does not wake from any events from non wakeable devices
> 
> Series 2 has refactored the change into multiple smaller commits as
> requested. I tried to simplify some of the whitelist filtering edge
> cases but unfortunately it remains quite complex.
> 
> Series 3 has refactored it further and should have resolved the
> whitelisting complexity in series 2.
> 
> Series 4 adds a fix to check for powered down and powering down adapters.
> 
> Series 5 moves set_wake_capable to the last patch in the series and
> changes BT_DBG to bt_dev_dbg.
> 
> Please review and provide any feedback.
> 
> Thanks
> Abhishek
> 
> 
> Changes in v6:
> * Removed unused variables in hci_req_prepare_suspend
> * Add int old_state to this patch
> 
> Changes in v5:
> * Convert BT_DBG to bt_dev_dbg
> * Added wakeable list and changed BT_DBG to bt_dev_dbg
> * Add wakeable to hci_conn_params and change BT_DBG to bt_dev_dbg
> * Changed BT_DBG to bt_dev_dbg
> * Wakeable entries moved to other commits
> * Patch moved to end of series
> 
> Changes in v4:
> * Added check for mgmt_powering_down and hdev_is_powered in notifier
> 
> Changes in v3:
> * Refactored to only handle BR/EDR devices
> * Split LE changes into its own commit
> * Added wakeable property to le_conn_param
> * Use wakeable list for BR/EDR and wakeable property for LE
> 
> Changes in v2:
> * Moved pm notifier registration into its own patch and moved params out
>  of separate suspend_state
> * Refactored filters and whitelist settings to its own patch
> * Refactored update_white_list to have clearer edge cases
> * Add connected devices to whitelist (previously missing corner case)
> * Refactored pause discovery + advertising into its own patch
> 
> Abhishek Pandit-Subedi (5):
>  Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
>  Bluetooth: Handle BR/EDR devices during suspend
>  Bluetooth: Handle LE devices during suspend
>  Bluetooth: Pause discovery and advertising during suspend
>  Bluetooth: Add mgmt op set_wake_capable
> 
> include/net/bluetooth/hci.h      |  17 +-
> include/net/bluetooth/hci_core.h |  43 ++++
> include/net/bluetooth/mgmt.h     |   7 +
> net/bluetooth/hci_core.c         | 102 ++++++++++
> net/bluetooth/hci_event.c        |  24 +++
> net/bluetooth/hci_request.c      | 331 ++++++++++++++++++++++++++-----
> net/bluetooth/hci_request.h      |   2 +
> net/bluetooth/mgmt.c             |  92 +++++++++
> 8 files changed, 558 insertions(+), 60 deletions(-)

patches 1-4 have been applied to bluetooth-next tree.

I skipped patch 5 since now we have to discuss how best the API for setting the wakeable devices will be. Care to start up a discussion thread for that?

Regards

Marcel

