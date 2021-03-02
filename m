Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80AE32B38B
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449674AbhCCEBp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Mar 2021 23:01:45 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:47226 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448141AbhCBOIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 09:08:02 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fb90.dip0.t-ipconnect.de [79.249.251.144])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5FE90CECC8;
        Tue,  2 Mar 2021 15:11:15 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH 1/2] Bluetooth: Notify suspend on le conn failed
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210301120602.1.Ia32a022edc307a4cb0c93dc18d52b6c5f97db23b@changeid>
Date:   Tue, 2 Mar 2021 15:03:41 +0100
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5FE82D7B-E67B-4EF2-B0B2-12978BCA5DBE@holtmann.org>
References: <20210301200605.106607-1-abhishekpandit@chromium.org>
 <20210301120602.1.Ia32a022edc307a4cb0c93dc18d52b6c5f97db23b@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> When suspending, Bluetooth disconnects all connected peers devices. If
> an LE connection is started but isn't completed, we will see an LE
> Create Connection Cancel instead of an HCI disconnect. This just adds
> a check to see if an LE cancel was the last disconnected device and wake
> the suspend thread when that is the case.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> ---
> Here is an HCI trace when the issue occurred.
> 
> < HCI Command: LE Create Connection (0x08|0x000d) plen 25                                           #187777 [hci0] 2021-02-03 21:42:35.130208
>        Scan interval: 60.000 msec (0x0060)
>        Scan window: 60.000 msec (0x0060)
>        Filter policy: White list is not used (0x00)
>        Peer address type: Random (0x01)
>        Peer address: D9:DC:6B:61:EB:3A (Static)
>        Own address type: Public (0x00)
>        Min connection interval: 15.00 msec (0x000c)
>        Max connection interval: 30.00 msec (0x0018)
>        Connection latency: 20 (0x0014)
>        Supervision timeout: 3000 msec (0x012c)
>        Min connection length: 0.000 msec (0x0000)
>        Max connection length: 0.000 msec (0x0000)
>> HCI Event: Command Status (0x0f) plen 4                                                           #187778 [hci0] 2021-02-03 21:42:35.131184
>      LE Create Connection (0x08|0x000d) ncmd 1
>        Status: Success (0x00)
> < HCI Command: LE Create Connection Cancel (0x08|0x000e) plen 0                                     #187805 [hci0] 2021-02-03 21:42:37.183336
>> HCI Event: Command Complete (0x0e) plen 4                                                         #187806 [hci0] 2021-02-03 21:42:37.192394
>      LE Create Connection Cancel (0x08|0x000e) ncmd 1
>        Status: Success (0x00)
>> HCI Event: LE Meta Event (0x3e) plen 19                                                           #187807 [hci0] 2021-02-03 21:42:37.193400
>      LE Connection Complete (0x01)
>        Status: Unknown Connection Identifier (0x02)
>        Handle: 0
>        Role: Master (0x00)
>        Peer address type: Random (0x01)
>        Peer address: D9:DC:6B:61:EB:3A (Static)
>        Connection interval: 0.00 msec (0x0000)
>        Connection latency: 0 (0x0000)
>        Supervision timeout: 0 msec (0x0000)
>        Master clock accuracy: 0x00
> ... <skip a few unrelated events>
> @ MGMT Event: Controller Suspended (0x002d) plen 1                                                 {0x0002} [hci0] 2021-02-03 21:42:39.178780
>        Suspend state: Controller running (failed to suspend) (0)
> @ MGMT Event: Controller Suspended (0x002d) plen 1                                                 {0x0001} [hci0] 2021-02-03 21:42:39.178780
>        Suspend state: Controller running (failed to suspend) (0)
> ... <actual suspended time>
> < HCI Command: Set Event Filter (0x03|0x0005) plen 1                                                #187808 [hci0] 2021-02-04 09:23:07.313591
>        Type: Clear All Filters (0x00)
> 
> net/bluetooth/hci_conn.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

