Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6C41BAE3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243207AbhI1XRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhI1XRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 19:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B7661350;
        Tue, 28 Sep 2021 23:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632870927;
        bh=k7mvWJXkefJr5oLTs0BZ3zdxRTUmPf1MZiYeBJyA7XE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ocew+esxplXzgMhKYMhrSw5RjLI6sQPl1Tpiuz8hw6JSCq3j+N+XNUkVedyO993Vz
         kB/Ij0uONZRhaKQ1ZZqXSnOBF2v/N41R+q0zq2sq2NxQ23yEfYDftUU4VR/G/OdTMH
         oxm49bvwucnXPGvvMvoowjDmc+Q9umDv5WNjC8kj1JHt8ObHwSzQGcNYlVh1ez5xeN
         mJiNFel0VlgIcQiY2L0+VJZsOkQBkdwCpihJ/x7cJEdneu0g15RAolcOsu81GTtT4G
         EkbSXP3x3KS0H0lgcufVPniUi6iCcip81W7MXc2oH8u82Mr+tvpN3iGdV9NBgTKLYR
         vCCYhS4Sz8W2g==
Date:   Tue, 28 Sep 2021 16:15:21 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, llvm@lists.linux.dev
Subject: Re: [PATCH bpf-next 06/13] xsk: optimize for aligned case
Message-ID: <YVOiCYXTL63R4Mu9@archlinux-ax161>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
 <20210922075613.12186-7-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922075613.12186-7-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 09:56:06AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Optimize for the aligned case by precomputing the parameter values of
> the xdp_buff_xsk and xdp_buff structures in the heads array. We can do
> this as the heads array size is equal to the number of chunks in the
> umem for the aligned case. Then every entry in this array will reflect
> a certain chunk/frame and can therefore be prepopulated with the
> correct values and we can drop the use of the free_heads stack. Note
> that it is not possible to allocate more buffers than what has been
> allocated in the aligned case since each chunk can only contain a
> single buffer.
> 
> We can unfortunately not do this in the unaligned case as one chunk
> might contain multiple buffers. In this case, we keep the old scheme
> of populating a heads entry every time it is used and using
> the free_heads stack.
> 
> Also move xp_release() and xp_get_handle() to xsk_buff_pool.h. They
> were for some reason in xsk.c even though they are buffer pool
> operations.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

My apologies if this has already been reported (I have not seen a report
on netdev nor a report from Intel around it) but this patch as
commit 94033cd8e73b ("xsk: Optimize for aligned case") in -next causes
the following build failure with clang + x86_64 allmodconfig:

net/xdp/xsk_buff_pool.c:465:15: error: variable 'xskb' is uninitialized when used here [-Werror,-Wuninitialized]
                        xp_release(xskb);
                                   ^~~~
net/xdp/xsk_buff_pool.c:455:27: note: initialize the variable 'xskb' to silence this warning
        struct xdp_buff_xsk *xskb;
                                 ^
                                  = NULL
1 error generated.

Cheers,
Nathan
