Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71522256D0D
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgH3JTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 05:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgH3JTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 05:19:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA7B20714;
        Sun, 30 Aug 2020 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598779159;
        bh=e2CkEznyGpjK37GjiF87TzHNHnfIBnUNctJ8uWQKXXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nNoW5uMGuk930nrYwDxvhKucdfXCTUqfYPHcv2boWxibjqj7fY06U4WqDh4Inpe75
         0NtVbdlzcP11m1XKOZDEBvQaTgWmOcAZI2nxjrqJwNihwqwWO97aCTKaYMbYKn4p1W
         jbraUucjy7oBpHOFj6fcfR8ZaUJUczz15FOWjuVc=
Date:   Sun, 30 Aug 2020 11:19:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        netdev@vger.kernel.org,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, davem@davemloft.net
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 deref in hci_phy_link_complete_evt
Message-ID: <20200830091917.GB122343@kroah.com>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
 <20200829165712.229437-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829165712.229437-1-anmol.karan123@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 29, 2020 at 10:27:12PM +0530, Anmol Karn wrote:
> Fix null pointer deref in hci_phy_link_complete_evt, there was no 
> checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
> in hci_cmd_work, for hdev->sent_cmd.
> 
> To fix this issue Add pointer checking in hci_cmd_work and
> hci_phy_link_complete_evt.
> [Linux-next-20200827]
> 
> This patch corrected some mistakes from previous patch.
> 
> Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
>  net/bluetooth/hci_core.c  | 5 ++++-
>  net/bluetooth/hci_event.c | 4 ++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 68bfe57b6625..996efd654e7a 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -4922,7 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
>  
>  		kfree_skb(hdev->sent_cmd);
>  
> -		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> +		if (hdev->sent_cmd) {
> +			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> +		}

How can sent_cmd be NULL here?  Are you sure something previous to this
shouldn't be fixed instead?


> +
>  		if (hdev->sent_cmd) {
>  			if (hci_req_status_pend(hdev))
>  				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 4b7fc430793c..1e7d9bee9111 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
>  		hci_dev_unlock(hdev);
>  		return;
>  	}
> +	if (!(hcon->amp_mgr->l2cap_conn->hcon)) {
> +		hci_dev_unlock(hdev);
> +		return;
> +	}

How can this be triggered?

thanks,

greg k-h
