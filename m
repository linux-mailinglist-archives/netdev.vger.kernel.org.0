Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8645333FDB8
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhCRDVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhCRDVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 23:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1463364EFC;
        Thu, 18 Mar 2021 03:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616037684;
        bh=QOtXK6Ec9/3i2FBcUrutU4vPFPJXNzko8Hou0zo6b0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RUXwEgkZOfdEA9KgB1z8gfEFWzOZZilJmfuz4cG+74p7eXjqFu2d/kYgp8eEmI2jp
         Lh9SoXDyVjcLcKn+PGnwvxJxOLxJ6CFiljMM1uTs9Wfc3ppS1ano9o3d5Y8+A1f9I9
         mrsICt7zVT+9c4NHN9bxa2zgvPS9KMDJNdmLRfjI=
Date:   Wed, 17 Mar 2021 20:21:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, arjunroy@google.com, shakeelb@google.com,
        edumazet@google.com, soheil@google.com, kuba@kernel.org,
        mhocko@kernel.org, hannes@cmpxchg.org, shy828301@gmail.com,
        guro@fb.com
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-Id: <20210317202123.7d2eaa0e54c36c20571a335c@linux-foundation.org>
In-Reply-To: <20210316013003.25271-1-arjunroy.kdev@gmail.com>
References: <20210316013003.25271-1-arjunroy.kdev@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 18:30:03 -0700 Arjun Roy <arjunroy.kdev@gmail.com> wrote:

> From: Arjun Roy <arjunroy@google.com>
> 
> TCP zerocopy receive is used by high performance network applications
> to further scale. For RX zerocopy, the memory containing the network
> data filled by the network driver is directly mapped into the address
> space of high performance applications. To keep the TLB cost low,
> these applications unmap the network memory in big batches. So, this
> memory can remain mapped for long time. This can cause a memory
> isolation issue as this memory becomes unaccounted after getting
> mapped into the application address space. This patch adds the memcg
> accounting for such memory.
> 
> Accounting the network memory comes with its own unique challenges.
> The high performance NIC drivers use page pooling to reuse the pages
> to eliminate/reduce expensive setup steps like IOMMU. These drivers
> keep an extra reference on the pages and thus we can not depend on the
> page reference for the uncharging. The page in the pool may keep a
> memcg pinned for arbitrary long time or may get used by other memcg.
> 
> This patch decouples the uncharging of the page from the refcnt and
> associates it with the map count i.e. the page gets uncharged when the
> last address space unmaps it. Now the question is, what if the driver
> drops its reference while the page is still mapped? That is fine as
> the address space also holds a reference to the page i.e. the
> reference count can not drop to zero before the map count.

What tree were you hoping to get this merged through?  I'd suggest net
- it's more likely to get tested over there.

>
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

These changes could be inside #ifdef CONFIG_NET.  Although I expect
MEMCG=y&&NET=n is pretty damn rare.

