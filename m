Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C028639D9B0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhFGKdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhFGKdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 06:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5CE6105A;
        Mon,  7 Jun 2021 10:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623061901;
        bh=QDWSZEpNc4xQ1VqsobtEpkvi3gCs9U7824XDo8S/V0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eXIR3lMLCBk7NJht1nSrHju2Frq/LgW/B8BpcT02rUIUPWPdsrv5it5e9cUHhmtUx
         qaqzswAdLGb7OHW3atgH0QGH15ZiARmTErCFdxXyRbPoT5Ues9L8chwdMQX6u+KHAc
         zVNOo+8HPjFWzmRdET6Fu0Nx+NCAWQih+nq32M+Y=
Date:   Mon, 7 Jun 2021 12:31:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Leon Romanovsky <leon@kernel.org>, SyzScope <syzscope@gmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL31i98CpOO/AjKY@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
 <20210606085004.12212-1-hdanton@sina.com>
 <20210607074828.3259-1-hdanton@sina.com>
 <20210607100201.3345-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607100201.3345-1-hdanton@sina.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 06:02:01PM +0800, Hillf Danton wrote:
> On Mon, 7 Jun 2021 09:55:31 +0200 Greg KH wrote:
> >On Mon, Jun 07, 2021 at 03:48:28PM +0800, Hillf Danton wrote:
> >> On Sun, 6 Jun 2021 11:54:22 +0200 Greg KH wrote:
> >> >On Sun, Jun 06, 2021 at 04:50:04PM +0800, Hillf Danton wrote:
> >> >> 
> >> >> To fix the uaf reported, add reference count to hci channel to track users.
> >> >> Then only channels with zero users will be released.
> >> >> 
> >> >> It is now only for thoughts.
> >> >> 
> >> >> +++ x/include/net/bluetooth/hci_core.h
> >> >> @@ -704,6 +704,7 @@ struct hci_chan {
> >> >>  	struct sk_buff_head data_q;
> >> >>  	unsigned int	sent;
> >> >>  	__u8		state;
> >> >> +	atomic_t ref;
> >> >
> >> >Please no, never use "raw" atomic variables.  Especially for something
> >> >like this, use a kref.
> >> 
> >> Fair, thanks for taking a look at it.
> >> 
> >> Spin with care for the race the added ref fails to cut.
> >
> >I do not understand what you mean here.
> >
> >> To ease review the full syzreport is also attached.
> >> 
> >> To fix uaf, add user track to hci channel and we will only release channel if
> >> its user hits zero. And a dryrun mechanism is also added to take care of the
> >> race user track fails to cut.
> >> 
> >> 	CPU0			CPU1
> >> 	----			----
> >> 	hci_chan_del		l2cap_conn_del
> >> 				chan->user = 0;
> >> 
> >> 	if (chan->user != 0)
> >> 		return;
> >> 	synchronize_rcu();
> >> 	kfree(chan);
> >> 
> >> 				hci_chan_del();
> >> 
> >> It is now only for thoughts.
> >> 
> >> +++ x/include/net/bluetooth/hci_core.h
> >> @@ -704,6 +704,10 @@ struct hci_chan {
> >>  	struct sk_buff_head data_q;
> >>  	unsigned int	sent;
> >>  	__u8		state;
> >> +	__u8		user;
> >
> >No.
> >
> >> +	__u8		release;
> >
> >No please no.
> >
> >> +
> >> +#define HCHAN_RELEASE_DRYRUN 1
> >>  };
> >>  
> >>  struct hci_conn_params {
> >> +++ x/net/bluetooth/l2cap_core.c
> >> @@ -1903,6 +1903,12 @@ static void l2cap_conn_del(struct hci_co
> >>  
> >>  	mutex_unlock(&conn->chan_lock);
> >>  
> >> +	/* see comment in hci_chan_del() */
> >> +	conn->hchan->release = HCHAN_RELEASE_DRYRUN;
> >> +	smp_wmb();
> >> +	conn->hchan->user--;
> >
> >And the reason you are open-coding a kref is why???
> >
> >Please again no.
> >
> >> +	hci_chan_del(conn->hchan);
> >> +	conn->hchan->release = 0;
> >>  	hci_chan_del(conn->hchan);
> >>  
> >>  	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
> >> @@ -7716,6 +7722,8 @@ static struct l2cap_conn *l2cap_conn_add
> >>  	kref_init(&conn->ref);
> >>  	hcon->l2cap_data = conn;
> >>  	conn->hcon = hci_conn_get(hcon);
> >> +	/* dec in l2cap_conn_del() */
> >> +	hchan->user++;
> >
> >{sigh}
> >
> >No, there is a reason we wrote kref many _decades_ ago.  Please use it,
> >your original attempt with an atomic was just fine, just use the proper
> >data structures the kernel provides you as this is obviously a reference
> >counted object.
> 
> I see your concern. I thought this is a simpler user track than kref and
> open coded a couple of lines. I see it is incorrect. Sorry for that.
> 
> After taking another look at the added user track, I realised that it serves
> no more than a one-off state word that prevents channel from being released.
> Then the race behind the uaf can be fixed by adding a state on top of the
> dryrun introduced even without tracking users.
> 
> The state machine works as the following,
> 1) it is initialised to be backoff that means channel cannot be released
>    at the moment.
> 2) it is changed to be dryrun on releasing to cut the race that survived
>    backoff.
> 3) it is finally set to zero for release after cutting the chance for race.

Adding another state on top of this feels rough, does it really solve
the race here?  Normally a reference count should be enough to properly
tear things down when needed, rolling back from a "can I try this now"
state still seems racy without the needed lock somewhere.


> 
> 
> +++ x/include/net/bluetooth/hci_core.h
> @@ -704,6 +704,10 @@ struct hci_chan {
>  	struct sk_buff_head data_q;
>  	unsigned int	sent;
>  	__u8		state;
> +	__u8		release;
> +
> +#define HCHAN_RELEASE_DRYRUN  1
> +#define HCHAN_RELEASE_BACKOFF 2
>  };
>  
>  struct hci_conn_params {
> +++ x/net/bluetooth/l2cap_core.c
> @@ -1903,6 +1903,10 @@ static void l2cap_conn_del(struct hci_co
>  
>  	mutex_unlock(&conn->chan_lock);
>  
> +	/* see comment in hci_chan_del() */
> +	conn->hchan->release = HCHAN_RELEASE_DRYRUN;
> +	hci_chan_del(conn->hchan);
> +	conn->hchan->release = 0;
>  	hci_chan_del(conn->hchan);
>  
>  	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
> @@ -7716,6 +7720,8 @@ static struct l2cap_conn *l2cap_conn_add
>  	kref_init(&conn->ref);
>  	hcon->l2cap_data = conn;
>  	conn->hcon = hci_conn_get(hcon);
> +	/* release is changed in l2cap_conn_del() */
> +	hchan->release = HCHAN_RELEASE_BACKOFF;
>  	conn->hchan = hchan;
>  
>  	BT_DBG("hcon %p conn %p hchan %p", hcon, conn, hchan);
> +++ x/net/bluetooth/hci_conn.c
> @@ -1769,12 +1769,26 @@ void hci_chan_del(struct hci_chan *chan)
>  	struct hci_conn *conn = chan->conn;
>  	struct hci_dev *hdev = conn->hdev;
>  
> +	if (chan->release == HCHAN_RELEASE_BACKOFF)
> +		return;
> +
>  	BT_DBG("%s hcon %p chan %p", hdev->name, conn, chan);
>  
> -	list_del_rcu(&chan->list);
> +	if (!list_empty(&chan->list))
> +		list_del_rcu(&chan->list);
>  
>  	synchronize_rcu();
>  
> +	if (chan->release == HCHAN_RELEASE_DRYRUN) {
> +		/*
> +		 * after list_del chan is only visible to the owner of dryrun,
> +		 * which is needed to cut the race that survived backoff,
> +		 * and simply return to owner. 

checkpatch will ding you for this not being the proper format for
networking, it hit me last week as well :)

thanks,

greg k-h
