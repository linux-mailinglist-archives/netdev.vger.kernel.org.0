Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A592AB7F5
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKIMQ5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Nov 2020 07:16:57 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:59923 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgKIMQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:16:57 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id 041BDCECC5;
        Mon,  9 Nov 2020 13:24:02 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [Linux-kernel-mentees] [PATCH net v2] Bluetooth: Fix
 slab-out-of-bounds read in hci_le_direct_adv_report_evt()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200909071700.1100748-1-yepeilin.cs@gmail.com>
Date:   Mon, 9 Nov 2020 13:16:53 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AF20F58E-C800-45A8-A5B8-296DE4C0D906@holtmann.org>
References: <20200805180902.684024-1-yepeilin.cs@gmail.com>
 <20200909071700.1100748-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peilin,

> `num_reports` is not being properly checked. A malformed event packet with
> a large `num_reports` number makes hci_le_direct_adv_report_evt() read out
> of bounds. Fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2f010b55884e ("Bluetooth: Add support for handling LE Direct Advertising Report events")
> Reported-and-tested-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> ---
> Change in v2:
>    - add "Cc: stable@" tag.
> 
> net/bluetooth/hci_event.c | 12 +++++-------
> 1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 4b7fc430793c..aec43ae488d1 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5863,21 +5863,19 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
> 					 struct sk_buff *skb)
> {
> 	u8 num_reports = skb->data[0];
> -	void *ptr = &skb->data[1];
> +	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
> 
> -	hci_dev_lock(hdev);
> +	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
> +		return;
> 
> -	while (num_reports--) {
> -		struct hci_ev_le_direct_adv_info *ev = ptr;
> +	hci_dev_lock(hdev);
> 
> +	for (; num_reports; num_reports--, ev++)
> 		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
> 				   ev->bdaddr_type, &ev->direct_addr,
> 				   ev->direct_addr_type, ev->rssi, NULL, 0,
> 				   false);
> 
> -		ptr += sizeof(*ev);
> -	}
> -
> 	hci_dev_unlock(hdev);
> }

patch has been applied to bluetooth-next tree.

Regards

Marcel

