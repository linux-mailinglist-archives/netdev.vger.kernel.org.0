Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6582E9C67
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbhADRxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADRxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 12:53:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CD520715;
        Mon,  4 Jan 2021 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609782791;
        bh=TLKoEn8dPh4XnwjcPparN5G7EEyCbF5e+mOyQq4ZfBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rr9Jye3HBN5Fg/avVtC9UX0QsAxntZDJXKFxA/6gxJQUqx8hdRPUs2HCTfsZR0kv+
         lLchefqidsS2GrDak9SB3mpbPmiQGT3s5XrbVj4UltR66xYBoKOnuzOBDHGHhFaUuI
         xPVCCKVNXYB+kjMKxdCjVbfM6uH8IGPQG9HmNYCI/Y20OewvNmDzOEn5zw7LpkXaeb
         8peQKKiJGw/urqMlG/MDpIdRJ43npcGFsgEiWVHICZctrNYKzR9GHnt8kv2q75j1Zi
         1WbynilJuXOksIwkiAwm9m+WBioW9OQ3HB5DUU0ryCP4bzs8MdT4cTE+2dOg+7XJRt
         QGoL+3Xox1f7w==
Date:   Mon, 4 Jan 2021 09:53:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] docs: net: fix documentation on .ndo_get_stats
Message-ID: <20210104095309.28682a9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210104104227.oqx6xt76k5snmhs6@skbuf>
References: <20201231034524.1570729-1-kuba@kernel.org>
        <20210104104227.oqx6xt76k5snmhs6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jan 2021 12:42:27 +0200 Vladimir Oltean wrote:
> On Wed, Dec 30, 2020 at 07:45:24PM -0800, Jakub Kicinski wrote:
> > Fix calling context.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  Documentation/networking/netdevices.rst | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
> > index 5a85fcc80c76..a80676f5477d 100644
> > --- a/Documentation/networking/netdevices.rst
> > +++ b/Documentation/networking/netdevices.rst
> > @@ -64,8 +64,8 @@ struct net_device synchronization rules
> >  	Context: process
> >  
> >  ndo_get_stats:
> > -	Synchronization: dev_base_lock rwlock.
> > -	Context: nominally process, but don't sleep inside an rwlock
> > +	Synchronization: rtnl_lock() semaphore, or RCU.
> > +	Context: atomic
> >  
> >  ndo_start_xmit:
> >  	Synchronization: __netif_tx_lock spinlock.
> 
> And what happened to dev_base_lock? Did it suddenly go away?

I thought all callers switched to RCU. You investigated this in depth,
did I miss something? I'm sending this correction because I have a
series which adds to other sections of this file and this jumped out 
to me as incorrect.
