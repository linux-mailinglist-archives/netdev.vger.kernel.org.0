Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C72C3084FE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA2FWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhA2FWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 00:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7473E64DFF;
        Fri, 29 Jan 2021 05:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611897691;
        bh=Q9uI5rTUUdc3WmqbxNQPptdYKIzLxw211JQfjilkDDA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dZ4+H6faGpQouEye2pE6VIetUBh9Z4om82a88EM5mv19h+jwiMp6yXxqCqRUGipVj
         4kjT3hqK6K6e7YC8IBevaJ8OPdDffQQ+ARUgvy6Io4UmoY7ZxXD9fL53JNFfUQTw59
         drMXZU2Zz7Kl3XUdZcucG0qvow99PFH93F97nx1Sbj+zNarJCQKFjE5y9VQ+88cxIM
         /wjAN/3bCKk/ghhqANCHR/7z7Q07s2plHyDzPkBRUye3WnlpMB5TyfCGDmpECPaJo1
         ddCpfnmTEJMaUNZ+i4YYlJNfjMWfyxm4ZVi7vcB9tdd1rc2hbDeS2g+rMCZi8zWc5c
         SvkhBYtqfcnrg==
Date:   Thu, 28 Jan 2021 21:21:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
Message-ID: <20210128212130.6bda5d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com>
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
        <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpU-jBkmf6DYtGAA78fAZdemKNT50BSoUco-XngyUPYMhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 21:08:05 -0800 Cong Wang wrote:
> On Thu, Jan 28, 2021 at 12:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:  
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > dev_ifsioc_locked() is called with only RCU read lock, so when
> > > there is a parallel writer changing the mac address, it could
> > > get a partially updated mac address, as shown below:
> > >
> > > Thread 1                      Thread 2
> > > // eth_commit_mac_addr_change()
> > > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> > >                               // dev_ifsioc_locked()
> > >                               memcpy(ifr->ifr_hwaddr.sa_data,
> > >                                       dev->dev_addr,...);
> > >
> > > Close this race condition by guarding them with a RW semaphore,
> > > like netdev_get_name(). The writers take RTNL anyway, so this
> > > will not affect the slow path.
> > >
> > > Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> > > Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> > > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>  
> >
> > The addition of the write lock scares me a little for a fix, there's a
> > lot of code which can potentially run under the callbacks and notifiers
> > there.
> >
> > What about using a seqlock?  
> 
> Actually I did use seqlock in my initial version (not posted), it does not
> allow blocking inside write_seqlock() protection, so I have to change
> to rwsem.

Argh, you're right. No way we can construct something that tries to
read once and if it fails falls back to waiting for RTNL?
