Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B551829A6
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388032AbgCLHXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:23:41 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36131 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387869AbgCLHXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:23:41 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1A851CECF0;
        Thu, 12 Mar 2020 08:33:08 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [Bluez PATCH v2] Bluetooth: L2CAP: handle l2cap config request
 during open state
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200312123453.Bluez.v2.1.I50b301a0464eb68e3d62721bf59e11ed2617c415@changeid>
Date:   Thu, 12 Mar 2020 08:23:39 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <07D55B75-02FB-4BCB-8918-CB5D0E15C2CE@holtmann.org>
References: <20200312123453.Bluez.v2.1.I50b301a0464eb68e3d62721bf59e11ed2617c415@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> According to Core Spec Version 5.2 | Vol 3, Part A 6.1.5,
> the incoming L2CAP_ConfigReq should be handled during
> OPEN state.
> 
> The section below shows the btmon trace when running
> L2CAP/COS/CFD/BV-12-C before and after this change.
> 
> === Before ===
> ...
>> ACL Data RX: Handle 256 flags 0x02 dlen 12                #22
>      L2CAP: Connection Request (0x02) ident 2 len 4
>        PSM: 1 (0x0001)
>        Source CID: 65
> < ACL Data TX: Handle 256 flags 0x00 dlen 16                #23
>      L2CAP: Connection Response (0x03) ident 2 len 8
>        Destination CID: 64
>        Source CID: 65
>        Result: Connection successful (0x0000)
>        Status: No further information available (0x0000)
> < ACL Data TX: Handle 256 flags 0x00 dlen 12                #24
>      L2CAP: Configure Request (0x04) ident 2 len 4
>        Destination CID: 65
>        Flags: 0x0000
>> HCI Event: Number of Completed Packets (0x13) plen 5      #25
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> HCI Event: Number of Completed Packets (0x13) plen 5      #26
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> ACL Data RX: Handle 256 flags 0x02 dlen 16                #27
>      L2CAP: Configure Request (0x04) ident 3 len 8
>        Destination CID: 64
>        Flags: 0x0000
>        Option: Unknown (0x10) [hint]
>        01 00                                            ..
> < ACL Data TX: Handle 256 flags 0x00 dlen 18                #28
>      L2CAP: Configure Response (0x05) ident 3 len 10
>        Source CID: 65
>        Flags: 0x0000
>        Result: Success (0x0000)
>        Option: Maximum Transmission Unit (0x01) [mandatory]
>          MTU: 672
>> HCI Event: Number of Completed Packets (0x13) plen 5      #29
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> ACL Data RX: Handle 256 flags 0x02 dlen 14                #30
>      L2CAP: Configure Response (0x05) ident 2 len 6
>        Source CID: 64
>        Flags: 0x0000
>        Result: Success (0x0000)
>> ACL Data RX: Handle 256 flags 0x02 dlen 20                #31
>      L2CAP: Configure Request (0x04) ident 3 len 12
>        Destination CID: 64
>        Flags: 0x0000
>        Option: Unknown (0x10) [hint]
>        01 00 91 02 11 11                                ......
> < ACL Data TX: Handle 256 flags 0x00 dlen 14                #32
>      L2CAP: Command Reject (0x01) ident 3 len 6
>        Reason: Invalid CID in request (0x0002)
>        Destination CID: 64
>        Source CID: 65
>> HCI Event: Number of Completed Packets (0x13) plen 5      #33
>        Num handles: 1
>        Handle: 256
>        Count: 1
> ...
> === After ===
> ...
>> ACL Data RX: Handle 256 flags 0x02 dlen 12               #22
>      L2CAP: Connection Request (0x02) ident 2 len 4
>        PSM: 1 (0x0001)
>        Source CID: 65
> < ACL Data TX: Handle 256 flags 0x00 dlen 16               #23
>      L2CAP: Connection Response (0x03) ident 2 len 8
>        Destination CID: 64
>        Source CID: 65
>        Result: Connection successful (0x0000)
>        Status: No further information available (0x0000)
> < ACL Data TX: Handle 256 flags 0x00 dlen 12               #24
>      L2CAP: Configure Request (0x04) ident 2 len 4
>        Destination CID: 65
>        Flags: 0x0000
>> HCI Event: Number of Completed Packets (0x13) plen 5     #25
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> HCI Event: Number of Completed Packets (0x13) plen 5     #26
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> ACL Data RX: Handle 256 flags 0x02 dlen 16               #27
>      L2CAP: Configure Request (0x04) ident 3 len 8
>        Destination CID: 64
>        Flags: 0x0000
>        Option: Unknown (0x10) [hint]
>        01 00                                            ..
> < ACL Data TX: Handle 256 flags 0x00 dlen 18               #28
>      L2CAP: Configure Response (0x05) ident 3 len 10
>        Source CID: 65
>        Flags: 0x0000
>        Result: Success (0x0000)
>        Option: Maximum Transmission Unit (0x01) [mandatory]
>          MTU: 672
>> HCI Event: Number of Completed Packets (0x13) plen 5     #29
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> ACL Data RX: Handle 256 flags 0x02 dlen 14               #30
>      L2CAP: Configure Response (0x05) ident 2 len 6
>        Source CID: 64
>        Flags: 0x0000
>        Result: Success (0x0000)
>> ACL Data RX: Handle 256 flags 0x02 dlen 20               #31
>      L2CAP: Configure Request (0x04) ident 3 len 12
>        Destination CID: 64
>        Flags: 0x0000
>        Option: Unknown (0x10) [hint]
>        01 00 91 02 11 11                                .....
> < ACL Data TX: Handle 256 flags 0x00 dlen 18               #32
>      L2CAP: Configure Response (0x05) ident 3 len 10
>        Source CID: 65
>        Flags: 0x0000
>        Result: Success (0x0000)
>        Option: Maximum Transmission Unit (0x01) [mandatory]
>          MTU: 672
> < ACL Data TX: Handle 256 flags 0x00 dlen 12               #33
>      L2CAP: Configure Request (0x04) ident 3 len 4
>        Destination CID: 65
>        Flags: 0x0000
>> HCI Event: Number of Completed Packets (0x13) plen 5     #34
>        Num handles: 1
>        Handle: 256
>        Count: 1
>> HCI Event: Number of Completed Packets (0x13) plen 5     #35
>        Num handles: 1
>        Handle: 256
>        Count: 1
> ...
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> 
> ---
> 
> Changes in v2:
> - Updated commit messages
> 
> net/bluetooth/l2cap_core.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

