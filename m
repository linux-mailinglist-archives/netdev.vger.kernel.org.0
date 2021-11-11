Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BD44DBB1
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbhKKSqJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 13:46:09 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:48187 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhKKSqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:46:08 -0500
Received: from smtpclient.apple (p4fefc15c.dip0.t-ipconnect.de [79.239.193.92])
        by mail.holtmann.org (Postfix) with ESMTPSA id 6FED6CECD2;
        Thu, 11 Nov 2021 19:43:15 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH v2] Bluetooth: Don't initialize msft/aosp when using user
 channel
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211108200058.v2.1.Ide934b992a0b54085a6be469d3687963a245dba9@changeid>
Date:   Thu, 11 Nov 2021 19:43:14 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <17BDA821-9D4A-46C9-8C0E-F7DB35D50033@holtmann.org>
References: <20211108200058.v2.1.Ide934b992a0b54085a6be469d3687963a245dba9@changeid>
To:     Jesse Melhuish <melhuishj@chromium.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesse,

> A race condition is triggered when usermode control is given to
> userspace before the kernel's MSFT query responds, resulting in an
> unexpected response to userspace's reset command.
> 
> Issue can be observed in btmon:
> < HCI Command: Vendor (0x3f|0x001e) plen 2                    #3 [hci0]
>        05 01                                            ..
> @ USER Open: bt_stack_manage (privileged) version 2.22  {0x0002} [hci0]
> < HCI Command: Reset (0x03|0x0003) plen 0                     #4 [hci0]
>> HCI Event: Command Complete (0x0e) plen 5                   #5 [hci0]
>      Vendor (0x3f|0x001e) ncmd 1
> 	Status: Command Disallowed (0x0c)
> 	05                                               .
>> HCI Event: Command Complete (0x0e) plen 4                   #6 [hci0]
>      Reset (0x03|0x0003) ncmd 2
> 	Status: Success (0x00)
> 
> Signed-off-by: Jesse Melhuish <melhuishj@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> ---
> 
> Changes in v2:
> - Moved guard to the new home for this code.
> 
> net/bluetooth/hci_sync.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index b794605dc882..5f1f59ac1813 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -3887,8 +3887,10 @@ int hci_dev_open_sync(struct hci_dev *hdev)
> 	    hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
> 		ret = hdev->set_diag(hdev, true);
> 
> -	msft_do_open(hdev);
> -	aosp_do_open(hdev);
> +	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> +		msft_do_open(hdev);
> +		aosp_do_open(hdev);
> +	}

but then you need to do the same on hci_dev_close. Also it would be good to extend userchan-tester with test cases for this.

Regards

Marcel

