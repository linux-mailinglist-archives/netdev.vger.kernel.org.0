Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119E21C5D8D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgEEQ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730282AbgEEQ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:44 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54901C061A0F;
        Tue,  5 May 2020 09:26:44 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jW0Ou-001bTK-0E; Tue, 05 May 2020 16:26:32 +0000
Date:   Tue, 5 May 2020 17:26:31 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Dumazet <edumazet@google.com>
Cc:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle
 change
Message-ID: <20200505162631.GY23230@ZenIV.linux.org.uk>
References: <a8510327-d4f0-1207-1342-d688e9d5b8c3@gmail.com>
 <20200505154644.18997-1-sjpark@amazon.com>
 <CANn89iLHV2wyhk6-d6j_4=Ns01AEE5HSA4Qu3LO0gqKgcG81vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLHV2wyhk6-d6j_4=Ns01AEE5HSA4Qu3LO0gqKgcG81vQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 09:00:44AM -0700, Eric Dumazet wrote:

> > Not exactly the 10,000,000, as it is only the possible highest number, but I
> > was able to observe clear exponential increase of the number of the objects
> > using slabtop.  Before the start of the problematic workload, the number of
> > objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
> > to 1,136,576.
> >
> >           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> > before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
> > after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
> >
> 
> Great, thanks.
> 
> How recent is the kernel you are running for your experiment ?
> 
> Let's make sure the bug is not in RCU.
> 
> After Al changes, RCU got slightly better under stress.

The thing that worries me here is that this is far from being the only
source of RCU-delayed freeing of objects.  If we really see bogus OOM
kills due to that (IRL, not in an artificial microbenchmark), we'd
better do something that would help with all those sources, not just
paper over the contributions from one of those.  Because there's no
chance in hell to get rid of RCU-delayed freeing in general...

Does the problem extend to kfree_rcu()?  And there's a lot of RCU
callbacks that boil down to kmem_cache_free(); those really look like
they should have exact same issue - sock_free_inode() is one of those,
after all.
