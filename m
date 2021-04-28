Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067A336DEC1
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243415AbhD1SFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 14:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243400AbhD1SFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 14:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79D40613FF;
        Wed, 28 Apr 2021 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619633096;
        bh=gZ/+/ppbjQBqfkwzHR/OGN3R5z3j67dMoWhJA7f+TIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T6gMkpAGnOGU0Og3bzaoFjD0uqhvrZ2qzsPXMIVC415tUAFO0YFS9qjIMphswMyh6
         h7m/mERO+ebGtNelsCftiEPA7Dd9wF0+nZy8ZvHbASnA5FloP3ppU51EHeBQtDlWsG
         2os2oT0XA/sS/qeoD8+5qrlPfDyK5C7EuLJVNK6RynuN9ijL22woOzmYtj5YS2oRUk
         wBVGG4xj34ocS6JwB36c6cd7A2WO9Bjh28O3ZK7LpWXN47Ob6NoncuyqOH5rcgEpqn
         LJ4hGPW3DpZgHExpIjn4PHNlEFzlvcp4QCVZ+eQ+b1cod+c/yIERqe6xVZ4aNuiX2g
         BCe79PhOO15Bw==
Date:   Wed, 28 Apr 2021 11:04:51 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: -Wconstant-conversion in
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
Message-ID: <YImjw3eypUdhkp88@archlinux-ax161>
References: <20200417004120.GA18080@ubuntu-s3-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417004120.GA18080@ubuntu-s3-xlarge-x86>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:41:20PM -0700, Nathan Chancellor wrote:
> Hi all,
> 
> I was building s390 allyesconfig with clang and came across a curious
> warning:
> 
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:580:41: warning:
> implicit conversion from 'unsigned long' to 'int' changes value from
> 18446744073709551584 to -32 [-Wconstant-conversion]
>         mvpp2_pools[MVPP2_BM_SHORT].pkt_size = MVPP2_BM_SHORT_PKT_SIZE;
>                                              ~ ^~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/mvpp2/mvpp2.h:699:33: note: expanded from
> macro 'MVPP2_BM_SHORT_PKT_SIZE'
> #define MVPP2_BM_SHORT_PKT_SIZE MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE)
>                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/mvpp2/mvpp2.h:634:30: note: expanded from
> macro 'MVPP2_RX_MAX_PKT_SIZE'
>         ((total_size) - NET_SKB_PAD - MVPP2_SKB_SHINFO_SIZE)
>                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> 1 warning generated.
> 
> As far as I understand it, the warning comes from the fact that
> MVPP2_BM_SHORT_FRAME_SIZE is treated as size_t because
> MVPP2_SKB_SHINFO_SIZE ultimately calls ALIGN with sizeof(struct
> skb_shared_info), which has typeof called on it.
> 
> The implicit conversion probably is fine but it would be nice to take
> care of the warning. I am not sure what would be the best way to do that
> would be though. An explicit cast would take care of it, maybe in
> MVPP2_SKB_SHINFO_SIZE since the actual value I see is 320, which is able
> to be fit into type int easily.
> 
> Any comments would be appreciated, there does not appear to be a
> dedicated maintainer of this driver according to get_maintainer.pl.

Sorry for the necrobump, I am doing a bug scrub and it seems like this
driver now has maintainers so keying them in in case they have any
comments/suggestions.

Cheers,
Nathan
