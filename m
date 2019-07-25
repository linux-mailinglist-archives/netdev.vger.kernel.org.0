Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38A174A18
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390626AbfGYJjf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 05:39:35 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34511 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfGYJjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:39:35 -0400
Received: from marcel-macbook.fritz.box (p5B3D2BA7.dip0.t-ipconnect.de [91.61.43.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 178D5CED29;
        Thu, 25 Jul 2019 11:48:10 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] net: bluetooth: hci_sock: Fix a possible null-pointer
 dereference in hci_mgmt_cmd()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190725092253.15912-1-baijiaju1990@gmail.com>
Date:   Thu, 25 Jul 2019 11:39:32 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BC138E23-E2FE-450E-B33E-1AD846D14687@holtmann.org>
References: <20190725092253.15912-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jia-Ju,

> In hci_mgmt_cmd(), there is an if statement on line 1570 to check
> whether hdev is NULL:
>    if (hdev && chan->hdev_init)
> 
> When hdev is NULL, it is used on line 1575:
>    err = handler->func(sk, hdev, cp, len);
> 
> Some called functions of handler->func use hdev, such as:
> set_appearance(), add_device() and remove_device() in mgmt.c.
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, hdev is checked before calling handler->func().
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
> net/bluetooth/hci_sock.c | 11 ++++++-----
> 1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index d32077b28433..18ea1e47ea48 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1570,11 +1570,12 @@ static int hci_mgmt_cmd(struct hci_mgmt_chan *chan, struct sock *sk,
> 	if (hdev && chan->hdev_init)
> 		chan->hdev_init(sk, hdev);
> 
> -	cp = buf + sizeof(*hdr);
> -
> -	err = handler->func(sk, hdev, cp, len);
> -	if (err < 0)
> -		goto done;
> +	if (hdev) {
> +		cp = buf + sizeof(*hdr);
> +		err = handler->func(sk, hdev, cp, len);
> +		if (err < 0)
> +			goto done;
> +	}
> 
> 	err = msglen;

have you evaluated the statement above:

        no_hdev = (handler->flags & HCI_MGMT_NO_HDEV);                           
        if (no_hdev != !hdev) {                                                  
                err = mgmt_cmd_status(sk, index, opcode,                         
                                      MGMT_STATUS_INVALID_INDEX);                
                goto done;                                                       
        }

I think that code is just overly complex and can be simplified, but I doubt you get to the situation where hdev is NULL for any function that requires it. Only the handler->func marked with HCI_MGMT_NO_HDEV will get hdev == NULL and these are not using it.

So we might can make this easier code to really check the index != MGMT_INDEX_NONE check above to cover all cases to ensure that hdev is either valid or set to NULL before proceeding any further.

And since we have a full set of unit tests in tools/mgmt-tester, I assume we would have had a chance to catch an issue like this. But we can add a test case to it to explicitly call the functions with either MGMT_INDEX_NONE used or not.

Regards

Marcel

