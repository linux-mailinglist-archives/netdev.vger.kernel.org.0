Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C066454DD8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbhKQTau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237879AbhKQTar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 14:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2010061BB6;
        Wed, 17 Nov 2021 19:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637177268;
        bh=+LoC2JR0lggi3yzwO4ZJsy9Z8Qx4P/EGKnZMKXk5f2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NgeNhfdGG1n38abzkhFofdgTjUFfbkPHSvPMm1J+epG0/Q1PTWF+cCC7dWbZaJlbp
         LYLBIa7zhPY5PQVfeD+IUNZgrH0pLwg/FFmamsYxIDnDSUSplYswkMJInoZ9E8nSE1
         BnjfCN5UPOrGI+QEQeTHs/KJW3BDjRPxrXU7NUxm32zMSMGc7gxz71AVZAit+xXsIt
         fZZ/7PQr2kjin0joy7S4HVYy+Rl0a/msX30BpbdnyqQA4ezDTUNUbzYDMK021IDgrO
         4KJlYTtLmpD5QKC4PNE89M8W9ZwWih43ZAc3yP2PQMFRv3h3esVJveFouCnq7/7SZA
         vn3WO+jR+yYIA==
Date:   Wed, 17 Nov 2021 21:27:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC net-next 1/2] net: add netdev_refs debug
Message-ID: <YZVXsETbkjq8U415@unreal>
References: <20211117174723.2305681-1-kuba@kernel.org>
 <20211117174723.2305681-2-kuba@kernel.org>
 <YZVI0cNLwd2flBkd@unreal>
 <20211117103545.189b6d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117103545.189b6d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:35:45AM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 20:24:17 +0200 Leon Romanovsky wrote:
> > > +/* Store a raw, unprotected pointer */
> > > +static inline void __netdev_ref_store(struct netdev_ref *ref,
> > > +				      struct net_device *dev)
> > > +{
> > > +	ref->dev = dev;
> > > +
> > > +#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
> > > +	refcount_set(&ref->cnt, 0);  
> > 
> > This is very uncommon pattern. I would expect that first pointer access
> > will start from 1, like all refcount_t users. If you still prefer to
> > start from 0, i suggest you to use atomic_t. 
> 
> It's not really "starting from 0", it's more of a "setting the count
> to invalid". It can't escape from this state with a simple inc.

I understand it and this is what raises eyebrows. The refcount_t type
has very clear semantics which you are stretching too far.

Let's see what Eric had in mind for his RFC.

Thanks
