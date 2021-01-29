Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2713C308C11
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhA2SAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhA2SAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 13:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF41164E0B;
        Fri, 29 Jan 2021 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611943208;
        bh=OJrK5xKfn0PlhlVhtYcslB4Wy8uob1KcYmLbp6A8SwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SnF1fAjPsWNQeN953QL+J5dnbXQVY9MSMQlh/Ezwu0UeWF7Cnm/fZodhq2LgL96Jb
         p2c6kWiR0v9AiLwo40pgR+xjNEij6yQO7YOAaLtNrTMj/07fN3A3+AjZJCG6/i/rOq
         /PDrlPCnSwqQTSWth2WsP7AkcbWaLS/E6XihHvZuyDiaa2kKueXQJdb43eZ5yfQFqA
         088KMUaqhQ5kpNCCbFnnozZSgcNJByOs36TBJY3F2Jv0bOfMCcsyNyU4yUaDnt6cQ3
         hrSs8EObOJf+sfSM6ThZ+vzIPfC0ymdyfdeN/E0SsjJN0mIgnCeeAIXn/dx/KNesqv
         Pqdj0CE9CEjAQ==
Date:   Fri, 29 Jan 2021 10:00:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
Message-ID: <20210129100007.4dd35815@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUGR1OjeEcsFqkeZZRHDkiQ=+=OiSAB8EgzxG9Dh-5c5w@mail.gmail.com>
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
        <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com>
        <20210128212130.6bda5d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpUGR1OjeEcsFqkeZZRHDkiQ=+=OiSAB8EgzxG9Dh-5c5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 21:47:04 -0800 Cong Wang wrote:
> On Thu, Jan 28, 2021 at 9:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 28 Jan 2021 21:08:05 -0800 Cong Wang wrote:  
> > > On Thu, Jan 28, 2021 at 12:55 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > >
> > > > On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:  
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > dev_ifsioc_locked() is called with only RCU read lock, so when
> > > > > there is a parallel writer changing the mac address, it could
> > > > > get a partially updated mac address, as shown below:
> > > > >
> > > > > Thread 1                      Thread 2
> > > > > // eth_commit_mac_addr_change()
> > > > > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> > > > >                               // dev_ifsioc_locked()
> > > > >                               memcpy(ifr->ifr_hwaddr.sa_data,
> > > > >                                       dev->dev_addr,...);
> > > > >
> > > > > Close this race condition by guarding them with a RW semaphore,
> > > > > like netdev_get_name(). The writers take RTNL anyway, so this
> > > > > will not affect the slow path.
> > > > >
> > > > > Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> > > > > Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> > > > > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>  
> > > >
> > > > The addition of the write lock scares me a little for a fix, there's a
> > > > lot of code which can potentially run under the callbacks and notifiers
> > > > there.
> > > >
> > > > What about using a seqlock?  
> > >
> > > Actually I did use seqlock in my initial version (not posted), it does not
> > > allow blocking inside write_seqlock() protection, so I have to change
> > > to rwsem.  
> >
> > Argh, you're right. No way we can construct something that tries to
> > read once and if it fails falls back to waiting for RTNL?  
> 
> I don't think there is any way to tell whether the read fails, a partially
> updated address can not be detected without additional flags etc..

Let me pseudo code it, I can't English that well:

void reader(obj)
{
	unsigned int seq;

	seq = READ_ONCE(seqcnt);
	if (seq & 1)
		goto slow_path;
	smb_rmb();

	obj = read_the_thing();

	smb_rmb();
	if (seq == READ_ONCE(seqcnt))
		return;

slow_path:
	rtnl_lock();
	obj = read_the_thing();
	rtnl_unlock();
}

void writer()
{
	ASSERT_RNTL();

	seqcnt++;
	smb_wmb();

	modify_the_thing();

	smb_wmb();
	seqcnt++;
}


I think raw_seqcount helpers should do here?

> And devnet_rename_sem is already there, pretty much similar to this
> one.

Ack, I don't see rename triggering cascading notifications, tho.
I think you've seen the recent patch for locking in team, that's 
pretty much what I'm afraid will happen here. 

But if I'm missing something about the seqcount or you strongly prefer
the rwlock, we can do that, too. Although I'd rather take this patch 
to net-next in that case.
