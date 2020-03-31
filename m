Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD9198C0A
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 08:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCaGFU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 02:05:20 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43900 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgCaGFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 02:05:20 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 62C91CECC4;
        Tue, 31 Mar 2020 08:14:51 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v4 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABmPvSF=pcffe18iAKgbU8bwFvVDp-NKeAFGw8auKoVd1XAuTQ@mail.gmail.com>
Date:   Tue, 31 Mar 2020 08:05:18 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <852FDEFC-7AD1-4CB9-9C45-BBAB5B2A8D14@holtmann.org>
References: <20200328074632.21907-1-mcchou@chromium.org>
 <20200328004507.v4.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <9CC14296-9A0E-4257-A388-B2F7C155CCE5@holtmann.org>
 <CABmPvSF=pcffe18iAKgbU8bwFvVDp-NKeAFGw8auKoVd1XAuTQ@mail.gmail.com>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

>>> This adds a bit mask of driver_info for Microsoft vendor extension and
>>> indicates the support for Intel 9460/9560 and 9160/9260. See
>>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
>>> microsoft-defined-bluetooth-hci-commands-and-events for more information
>>> about the extension. This also add a kernel config, BT_MSFTEXT, and a
>>> source file to facilitate Microsoft vendor extension functions.
>>> This was verified with Intel ThunderPeak BT controller
>>> where msft_vnd_ext_opcode is 0xFC1E.
>>> 
>>> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>>> 
>>> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
>>> ---
>>> 
>>> Changes in v4:
>>> - Introduce CONFIG_BT_MSFTEXT as a starting point of providing a
>>> framework to use Microsoft extension
>>> - Create include/net/bluetooth/msft.h and net/bluetooth/msft.c to
>>> facilitate functions of Microsoft extension.
>>> 
>>> Changes in v3:
>>> - Create net/bluetooth/msft.c with struct msft_vnd_ext defined internally
>>> and change the hdev->msft_ext field to void*.
>>> - Define and expose msft_vnd_ext_set_opcode() for btusb use.
>>> - Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev().
>>> 
>>> Changes in v2:
>>> - Define struct msft_vnd_ext and add a field of this type to struct
>>> hci_dev to facilitate the support of Microsoft vendor extension.
>>> 
>>> drivers/bluetooth/btusb.c        | 11 +++++++++--
>>> include/net/bluetooth/hci_core.h |  4 ++++
>> 
>> so I don’t like the intermixing of core features and drivers unless it is needed. In this case it is not needed since we can first introduce the core support and then enable the driver to use it.
> I will make btusb changes as a different commit in v5.

check the series that I posted. I tested them on ThunderPeak and if it also works, we use that as a base and then go from there.

>> 
>>> net/bluetooth/Kconfig            |  9 ++++++++-
>>> net/bluetooth/Makefile           |  1 +
>>> net/bluetooth/msft.c             | 16 ++++++++++++++++
>>> net/bluetooth/msft.h             | 19 +++++++++++++++++++
>>> 6 files changed, 57 insertions(+), 3 deletions(-)
>>> create mode 100644 net/bluetooth/msft.c
>>> create mode 100644 net/bluetooth/msft.h
>>> 
>>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>>> index 3bdec42c9612..0fe47708d3c8 100644
>>> --- a/drivers/bluetooth/btusb.c
>>> +++ b/drivers/bluetooth/btusb.c
>>> @@ -21,6 +21,7 @@
>>> #include <net/bluetooth/bluetooth.h>
>>> #include <net/bluetooth/hci_core.h>
>>> 
>>> +#include "../../net/bluetooth/msft.h"
>> 
>> This was my bad. I didn’t realized that drivers need to the set the opcode and not the core. I updated the patches to fix this.
> I will move it to include/net/bluetooth/.

I put it in hci_core.h since don’t want to add any extra needed include for driver. They are big enough already and adding more files doesn’t really help.

Regards

Marcel

