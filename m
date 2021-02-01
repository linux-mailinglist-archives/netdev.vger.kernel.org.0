Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE130B28A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhBAWFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229975AbhBAWFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 17:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC22664E2C;
        Mon,  1 Feb 2021 22:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612217063;
        bh=kICdTlyMQHGicwzj1tusn99WVZumEnPYxxJnzgRt8Iw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BVB+2nMGxkjYsRA9YMDg9etntpJS2l8zuHLS6qaB/8h4rv65KKkVkG+6JRP/0Nb9+
         ie1uv9A63HzGG2gOrdnvcj8yFMXYwNO6cqoPS1QVjHXDHKhaZrL9/X0AG1UzJcuHrO
         1gKN00ZbtsSJ9tShdR96QSZwaFtqikueOaZ+8HyUVaXZHWxMxBPoW/RU0SSSKfVqsg
         slb3fFCXq/XXXja7NqJJc82OQQeieDgNIIziVnv3B91lFVtRVjpdb+WQ5Xy4lcPCyQ
         qXZboExBemvbjqw/rkU4oSgva3fCQ6pjZ/znijhyDDAGAiah1GOOG6vXeJ14L2vE4O
         indms4LqYAPow==
Date:   Mon, 1 Feb 2021 14:04:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net 1/4] igc: Report speed and duplex as unknown when
 device is runtime suspended
Message-ID: <20210201140421.33c176a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b692fbf3-8aaa-feea-f3c7-ea30484bd625@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
        <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
        <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <107f90ab-0466-67e8-8cc5-7ac79513f939@intel.com>
        <20210130101247.41592be3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b692fbf3-8aaa-feea-f3c7-ea30484bd625@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 12:22:25 +0200 Neftin, Sasha wrote:
> On 1/30/2021 20:12, Jakub Kicinski wrote:
> > On Sat, 30 Jan 2021 16:00:06 +0200 Neftin, Sasha wrote:  
> >> What is another rd32(IGC_STATUS) you meant? in  igc_ethtool_get_regs?  
> > 
> > Yes.
> >   
> >> While the device in D3 state there is no configuration space registers
> >> access.  
> > 
> > That's to say similar stack trace will be generated to the one fixed
> > here, if someone runs ethtool -d, correct? I don't see anything
> > checking runtime there either.
> >   
> yes.
> This problem crosses many drivers. (not only igb, igc,...)
> 
> specific to this one (igc), can we check 'netif_running at begin of the 
> _get_regs method:
> if (!netif_running(netdev))
> 	return;
> what do you think? (only OS can put device to the D3)

That'd address the particular issue we noticed in the 5min review of
this patch, but similar, less obvious problems may still be lurking?
I wish I knew more about PM so I could suggest a solution. It'd be
ideal to avoid the rtnl_lock calls in resume, so that the driver can
just wake up the device from within the callbacks. Maybe embedded
experts can chime in and suggest how it's usually handled..
