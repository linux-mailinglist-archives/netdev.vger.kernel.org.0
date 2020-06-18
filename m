Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391311FFB84
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgFRTI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:08:27 -0400
Received: from nautica.notk.org ([91.121.71.147]:34180 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbgFRTI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 15:08:27 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id EA9E8C01C; Thu, 18 Jun 2020 21:08:22 +0200 (CEST)
Date:   Thu, 18 Jun 2020 21:08:07 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Fix sparse rcu warnings in client.c
Message-ID: <20200618190807.GA20699@nautica>
References: <20200618183310.5352-1-alexander.kapshuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200618183310.5352-1-alexander.kapshuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kapshuk wrote on Thu, Jun 18, 2020:
> Address sparse nonderef rcu warnings:
> net/9p/client.c:790:17: warning: incorrect type in argument 1 (different address spaces)
> net/9p/client.c:790:17:    expected struct spinlock [usertype] *lock
> net/9p/client.c:790:17:    got struct spinlock [noderef] <asn:4> *
> net/9p/client.c:792:48: warning: incorrect type in argument 1 (different address spaces)
> net/9p/client.c:792:48:    expected struct spinlock [usertype] *lock
> net/9p/client.c:792:48:    got struct spinlock [noderef] <asn:4> *
> net/9p/client.c:872:17: warning: incorrect type in argument 1 (different address spaces)
> net/9p/client.c:872:17:    expected struct spinlock [usertype] *lock
> net/9p/client.c:872:17:    got struct spinlock [noderef] <asn:4> *
> net/9p/client.c:874:48: warning: incorrect type in argument 1 (different address spaces)
> net/9p/client.c:874:48:    expected struct spinlock [usertype] *lock
> net/9p/client.c:874:48:    got struct spinlock [noderef] <asn:4> *
> 
> Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>

Thanks for this patch.
From what I can see, there are tons of other parts of the code doing the
same noderef access pattern to access current->sighand->siglock and I
don't see much doing that.
A couple of users justify this by saying SLAB_TYPESAFE_BY_RCU ensures
we'll always get a usable lock which won't be reinitialized however we
access it... It's a bit dubious we'll get the same lock than unlock to
me, so I agree to some change though.

After a second look I think we should use something like the following:

if (!lock_task_sighand(current, &flags))
	warn & skip (or some error, we'd null deref if this happened currently);
recalc_sigpending();
unlock_task_sighand(current, &flags);

As you can see, the rcu_read_lock() isn't kept until the unlock so I'm
not sure it will be enough to please sparse, but I've convinced myself
current->sighand cannot change while we hold the lock and there just are
too many such patterns in the kernel.

Please let me know if I missed something or if there is an ongoing
effort to change how this works; I'll wait for a v2.

-- 
Dominique
