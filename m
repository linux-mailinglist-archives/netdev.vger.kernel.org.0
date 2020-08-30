Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC3D256F80
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 19:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgH3RaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 13:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgH3RaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 13:30:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B598020714;
        Sun, 30 Aug 2020 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598808602;
        bh=BopSRUDvmAHu4C4ZgQT5LSsunJM/+eyFrpOMQmKj4+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/zT74G2muYeReBEmL01IvpBsAYzbg5InWmKENnYGXCe/CJs+n+lN7YGS5w2Ku2LU
         W43mtTTjg1YBcBEAMCLFOTpRHcgS2bhXQ/tMU4azm211lZA0UXM36AIMRTSlJOAWNP
         R5fHsy4/+y4oBWFiAvdI4SDnogWOvna90R4xEJTs=
Date:   Sun, 30 Aug 2020 19:30:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     syzbot+0bef568258653cff272f@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 deref in hci_phy_link_complete_evt
Message-ID: <20200830173010.GA1872728@kroah.com>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
 <20200829165712.229437-1-anmol.karan123@gmail.com>
 <20200830091917.GB122343@kroah.com>
 <20200830122623.GA235919@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830122623.GA235919@Thinkpad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 05:56:23PM +0530, Anmol Karn wrote:
> On Sun, Aug 30, 2020 at 11:19:17AM +0200, Greg KH wrote:
> > On Sat, Aug 29, 2020 at 10:27:12PM +0530, Anmol Karn wrote:
> > > Fix null pointer deref in hci_phy_link_complete_evt, there was no 
> > > checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
> > > in hci_cmd_work, for hdev->sent_cmd.
> > > 
> > > To fix this issue Add pointer checking in hci_cmd_work and
> > > hci_phy_link_complete_evt.
> > > [Linux-next-20200827]
> > > 
> > > This patch corrected some mistakes from previous patch.
> > > 
> > > Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
> > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > ---
> > >  net/bluetooth/hci_core.c  | 5 ++++-
> > >  net/bluetooth/hci_event.c | 4 ++++
> > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index 68bfe57b6625..996efd654e7a 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -4922,7 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
> > >  
> > >  		kfree_skb(hdev->sent_cmd);
> > >  
> > > -		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > > +		if (hdev->sent_cmd) {
> > > +			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > > +		}
> > 
> > How can sent_cmd be NULL here?  Are you sure something previous to this
> > shouldn't be fixed instead?
> 
> Sir, sent_cmd was freed before this condition check, thats why i checked it,

But it can not be NULL at that point in time, as nothing set it to NULL,
correct?

> i think i should check it before the free of hdev->sent_cmd like,
> 
> if (hdev->sent_cmd)
> 	kfree_skb(hdev->sent_cmd);

No, that's not needed.

What is the problem with these lines that you are trying to solve?

> > > +
> > >  		if (hdev->sent_cmd) {
> > >  			if (hci_req_status_pend(hdev))
> > >  				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
> > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > index 4b7fc430793c..1e7d9bee9111 100644
> > > --- a/net/bluetooth/hci_event.c
> > > +++ b/net/bluetooth/hci_event.c
> > > @@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> > >  		hci_dev_unlock(hdev);
> > >  		return;
> > >  	}
> > > +	if (!(hcon->amp_mgr->l2cap_conn->hcon)) {
> > > +		hci_dev_unlock(hdev);
> > > +		return;
> > > +	}
> > 
> > How can this be triggered?
> 
> syzbot showed that this line is accessed irrespective of the null value it contains, so  added a 
> pointer check for that.

But does hcon->amp_mgr->l2cap_conn->hcon become NULL here?

thanks,

greg k-h
