Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92F12CF7F5
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgLEAZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:25:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgLEAZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:25:08 -0500
Date:   Fri, 4 Dec 2020 16:24:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607127867;
        bh=SbNLAc37PPUFIHBbSXCD5hfBO4DhLscn+PzU6JQaEs0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=izALLrJXA+ZZgoI1g4D6TjPYjBATmgDG+GfjEmKScYk28oPEzDT9ZlEj/bf9+pGkV
         zjvmOzZno90aEL74YPC7B7Wq2x1IfA/OuGBngMNzNIs/tlQ21s5nTFbR0wGVkpAn65
         9VvK4mVa7Fe5w0x/KXTrLl6+kmIlOT+rvH8+dlht4SuA5AdS4A8KUbKyU5Sk096r/Y
         kzWhihZY/EdsQ6/O+8E5yMyj2qQcdfearTrc0nmhxO2dQRoRarGSUvPGr/JnFuo5FC
         nMyl5Xu/XAY1xJJAf7+mJFPBKUAc7UqoL88jAR5E63YIsafy0hDMgo8+Ja6x0uIBO9
         u4IEoGX1R9G+A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
        <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
        <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 15:57:36 -0800 Saeed Mahameed wrote:
> On Fri, 2020-12-04 at 15:17 -0800, Jakub Kicinski wrote:
> > On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:  
> > > > > option 2) route PTP traffic to a special SQs per ring, this SQ
> > > > > will
> > > > > be
> > > > > PTP port accurate, Normal traffic will continue through regular
> > > > > SQs
> > > > > 
> > > > > Pros: Regular non PTP traffic not affected.
> > > > > Cons: High memory footprint for creating special SQs
> > > > > 
> > > > > So we prefer (2) + private flag to avoid the performance hit
> > > > > and
> > > > > the
> > > > > redundant memory usage out of the box.    
> > > > 
> > > > Option 3 - have only one special PTP queue in the system. PTP
> > > > traffic
> > > > is rather low rate, queue per core doesn't seem necessary.  
> > > 
> > > We only forward ptp traffic to the new special queue but we create
> > > more
> > > than one to avoid internal locking as we will utilize the tx
> > > softirq
> > > percpu.  
> > 
> > In other words to make the driver implementation simpler we'll have
> > a pretty basic feature hidden behind a ethtool priv knob and a number
> > of queues which doesn't match reality reported to user space. Hm.  
> 
> I look at these queues as a special HW objects to allow the accurate
> PTP stamping, they piggyback on the reported txqs, so they are
> transparent, 

But they are visible to the stack, via sysfs, netlink. Any check
in the kernel that tries to help the driver by validating user input
against real_num_tx_queues will be moot for mlx5e.

mlx5e hides the AF_XDP queues behind normal RSS queues, but it would
have extra visible queues for TX PTP.

> they just increase the memory footprint of each ring.

For every ring or for every TC? (which is hopefully 1 in any non-DCB
deployment?)

> for the priv flags, one of the floating ideas was to
> use hwtstamp_rx_filters flags:
>  
> https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/net_tstamp.h#L107
> 
> Our hardware timestamps all packets for free whether you request it or
> not, Currently there is no option to setup "ALL_PTP" traffic in ethtool
> -T, but we can add this flag as it make sense to be in ethtool -T, thus
> we could use it in mlx5 to determine if user selected ALL_PTP, then ptp
> packets will go through this accurate special path.
> 
> This is not a W/A or an abuse to the new flag, it just means if you
> select ALL_PTP then a side effect will be our HW will be more accurate 
> for PTP traffic.
> 
> What do you think ?

That sounds much better than the priv flag, yes.

> Regarding reducing to a single special queue, i will discuss with Eran
> and the Team on Sunday.

Okay, thanks.
