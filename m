Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32B4454D44
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhKQSiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhKQSiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C65D61BD4;
        Wed, 17 Nov 2021 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637174146;
        bh=wZq4dIVdLi+5M3OUFY9Vi8y4HNxwRYL0NYyIJjbga/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LIsteJxFx4FNGpgOlmBmmnby1JvyAZ2bXKJxOrPUElGqGZrqFRv0rijezkdIC4/9w
         EnnWn31k/wMtWW9yXK3DLynnNJH7414mli9yEUGn4EagzYk9U3e5CJBrxyg6gKu7lQ
         otvukvIuJFWh84iKb74lpU0zG3o0ryfaFkH8WrKEdLgem3Y0Xakh2tjmkyx3PpYeJ+
         C/hy7gpTA2JuSvrBvUGdwUubFSexHG7ugOi+9CjyPGrUMfsXRWh7usxAUWXuOtHCNg
         wKMj+NCp/Tcs3k9+fFWSpZt9zyUyPY39qZkXV4FfKkWEXSGmIiSXuAGt7vjC8N02dY
         z26Yk9jd5i0dg==
Date:   Wed, 17 Nov 2021 10:35:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC net-next 1/2] net: add netdev_refs debug
Message-ID: <20211117103545.189b6d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZVI0cNLwd2flBkd@unreal>
References: <20211117174723.2305681-1-kuba@kernel.org>
        <20211117174723.2305681-2-kuba@kernel.org>
        <YZVI0cNLwd2flBkd@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 20:24:17 +0200 Leon Romanovsky wrote:
> > +/* Store a raw, unprotected pointer */
> > +static inline void __netdev_ref_store(struct netdev_ref *ref,
> > +				      struct net_device *dev)
> > +{
> > +	ref->dev = dev;
> > +
> > +#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
> > +	refcount_set(&ref->cnt, 0);  
> 
> This is very uncommon pattern. I would expect that first pointer access
> will start from 1, like all refcount_t users. If you still prefer to
> start from 0, i suggest you to use atomic_t. 

It's not really "starting from 0", it's more of a "setting the count
to invalid". It can't escape from this state with a simple inc.

> IMHO, much better will be to use kref for this type of reference counting.

I'm not really sure if the netdev_ref_{get,put}() part is necessary.

Main pattern I'm trying to replace is a pointer which is optionally 
holding a reference (0, 1 references). Rather than a pointer which 
is ref counted (1..n references).

IOW __netdev_ref_store() is much more likely to be used than
netdev_ref_get(), that's also why netdev_put() does not invalidate
the pointer itself.
