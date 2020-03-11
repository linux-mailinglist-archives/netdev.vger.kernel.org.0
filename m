Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD9D181BF1
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgCKPDP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Mar 2020 11:03:15 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43491 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgCKPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:03:15 -0400
Received: from [172.20.10.2] (x59cc8a78.dyn.telefonica.de [89.204.138.120])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3C97DCECDF;
        Wed, 11 Mar 2020 16:12:42 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v5 0/5] Bluetooth: Handle system suspend gracefully
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200308212334.213841-1-abhishekpandit@chromium.org>
Date:   Wed, 11 Mar 2020 16:03:12 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C9E912BC-01E0-4E5D-ABC9-DBA932231E50@holtmann.org>
References: <20200308212334.213841-1-abhishekpandit@chromium.org>
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

so I was planning to apply patches 1-4. The only thing that I noticed was that patch 2 introduces the following warning.

  CC      net/bluetooth/hci_request.o
net/bluetooth/hci_request.c: In function ‘hci_req_prepare_suspend’:
net/bluetooth/hci_request.c:973:6: warning: unused variable ‘old_state’ [-Wunused-variable]
  973 |  int old_state;
      |      ^~~~~~~~~

I think this variable should only be introduced in patch 4. Are you able to respin this series so that the variable moves to patch 4. If not, I can try to fix this myself.

Regards

Marcel

