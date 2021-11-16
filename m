Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8B94533F9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhKPOVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:21:25 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:33524 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhKPOVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:21:23 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id CDA9ECECD9;
        Tue, 16 Nov 2021 15:18:24 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v3 1/2] Bluetooth: Ignore HCI_ERROR_CANCELLED_BY_HOST on
 adv set terminated event
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211111132045.v3.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
Date:   Tue, 16 Nov 2021 15:18:24 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5F95A4B3-0002-414A-A397-520BF6089017@holtmann.org>
References: <20211111132045.v3.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> This event is received when the controller stops advertising,
> specifically for these three reasons:
> (a) Connection is successfully created (success).
> (b) Timeout is reached (error).
> (c) Number of advertising events is reached (error).
> (*) This event is NOT generated when the host stops the advertisement.
> Refer to the BT spec ver 5.3 vol 4 part E sec 7.7.65.18. Note that the
> section was revised from BT spec ver 5.0 vol 2 part E sec 7.7.65.18
> which was ambiguous about (*).
> 
> Some chips (e.g. RTL8822CE) send this event when the host stops the
> advertisement with status = HCI_ERROR_CANCELLED_BY_HOST (due to (*)
> above). This is treated as an error and the advertisement will be
> removed and userspace will be informed via MGMT event.
> 
> On suspend, we are supposed to temporarily disable advertisements,
> and continue advertising on resume. However, due to the behavior
> above, the advertisements are removed instead.
> 
> This patch returns early if HCI_ERROR_CANCELLED_BY_HOST is received.
> 
> Btmon snippet of the unexpected behavior:
> @ MGMT Command: Remove Advertising (0x003f) plen 1
>        Instance: 1
> < HCI Command: LE Set Extended Advertising Enable (0x08|0x0039) plen 6
>        Extended advertising: Disabled (0x00)
>        Number of sets: 1 (0x01)
>        Entry 0
>          Handle: 0x01
>          Duration: 0 ms (0x00)
>          Max ext adv events: 0
>> HCI Event: LE Meta Event (0x3e) plen 6
>      LE Advertising Set Terminated (0x12)
>        Status: Operation Cancelled by Host (0x44)
>        Handle: 1
>        Connection handle: 0
>        Number of completed extended advertising events: 5
>> HCI Event: Command Complete (0x0e) plen 4
>      LE Set Extended Advertising Enable (0x08|0x0039) ncmd 2
>        Status: Success (0x00)
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> 
> ---
> 
> (no changes since v2)
> 
> Changes in v2:
> * Split clearing HCI_LE_ADV into its own patch
> * Reword comments
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_event.c   | 12 ++++++++++++
> 2 files changed, 13 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

