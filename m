Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82FA1829A2
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbgCLHV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:21:58 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:42299 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387958AbgCLHV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 03:21:57 -0400
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 3743ECECF0;
        Thu, 12 Mar 2020 08:31:24 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v2] Bluetooth: clean up connection in hci_cs_disconnect
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200311191939.v2.1.I12c0712e93f74506385b67c6df287658c8fdad04@changeid>
Date:   Thu, 12 Mar 2020 08:21:55 +0100
Cc:     Alain Michaud <alainm@chromium.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <9D673EFD-077F-43CD-8293-C4E00453BD65@holtmann.org>
References: <20200311191939.v2.1.I12c0712e93f74506385b67c6df287658c8fdad04@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> In bluetooth core specification 4.2,
> Vol 2, Part E, 7.8.9 LE Set Advertise Enable Command, it says
> 
>    The Controller shall continue advertising until ...
>    or until a connection is created or ...
>    In these cases, advertising is then disabled.
> 
> Hence, advertising would be disabled before a connection is
> established. In current kernel implementation, advertising would
> be re-enabled when all connections are terminated.
> 
> The correct disconnection flow looks like
> 
>  < HCI Command: Disconnect
> 
>> HCI Event: Command Status
>      Status: Success
> 
>> HCI Event: Disconnect Complete
>      Status: Success
> 
> Specifically, the last Disconnect Complete Event would trigger a
> callback function hci_event.c:hci_disconn_complete_evt() to
> cleanup the connection and re-enable advertising when proper.
> 
> However, sometimes, there might occur an exception in the controller
> when disconnection is being executed. The disconnection flow might
> then look like
> 
>  < HCI Command: Disconnect
> 
>> HCI Event: Command Status
>      Status: Unknown Connection Identifier
> 
>  Note that "> HCI Event: Disconnect Complete" is missing when such an
> exception occurs. This would result in advertising staying disabled
> forever since the connection in question is not cleaned up correctly.
> 
> To fix the controller exception issue, we need to do some connection
> cleanup when the disconnect command status indicates an error.
> 
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> Changes in v2:
> - Moved "u8 type" declaration inside if block
> 
> net/bluetooth/hci_event.c | 14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

