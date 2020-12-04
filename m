Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F52CF6F8
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388186AbgLDWjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbgLDWjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:39:02 -0500
Date:   Fri, 4 Dec 2020 14:38:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607121502;
        bh=bSP9fljyjb4YJ+I9siplY/Q3sIfwQhJrl6+H78zkUQ0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nfn122hi4t7sWbnxaBxwRxt6VARnoCH8IhYF3ppoKI9IICQ24ul4n8lSwUeNDUbvI
         /eIprhkEIrM0Tx6p+Z7bMIwb9WgKIZh5k4jFI1i7niz2ACjrFAnino2+dR/XmcqiSj
         fAZiWotSqqE7BjWSNhaqUlk5o5fRw04aBQ7Zr6ip5Js5cHI1m81li71AL9iiwL96b7
         jAyW5WXbfhc8BBDna5EJ/Y8Xh6Nad7JieEUlthMTP4kvdejBKM9hIJiXoNGk38e+fn
         01LM6GUOPqZ357NY7H5pFAK+N24PE0sDV5tOgGvFtIJ81QGOm94byKSaWiLmlM7hCN
         wW56ht07Rt+Jg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
Subject: Re: [net-next v3 0/8] Perf. optimizations for TCP Recv. Zerocopy
Message-ID: <20201204143816.7e59877c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 14:53:41 -0800 Arjun Roy wrote:
> Summarized:
> 1. It is possible that a read payload is not exactly page aligned -
> that there may exist "straggler" bytes that we cannot map into the
> caller's address space cleanly. For this, we allow the caller to
> provide as argument a "hybrid copy buffer", turning
> getsockopt(TCP_ZEROCOPY_RECEIVE) into a "hybrid" operation that allows
> the caller to avoid a subsequent recvmsg() call to read the
> stragglers.
> 
> 2. Similarly, for "small" read payloads that are either below the size
> of a page, or small enough that remapping pages is not a performance
> win - we allow the user to short-circuit the remapping operations
> entirely and simply copy into the buffer provided.
> 
> Some of the patches in the middle of this set are refactors to support
> this "short-circuiting" optimization.
> 
> 3. We allow the user to provide a hint that performing a page zap
> operation (and the accompanying TLB shootdown) may not be necessary,
> for the provided region that the kernel will attempt to map pages
> into. This allows us to avoid this expensive operation while holding
> the socket lock, which provides a significant performance advantage.
> 
> With all of these changes combined, "medium" sized receive traffic
> (multiple tens to few hundreds of KB) see significant efficiency gains
> when using TCP receive zerocopy instead of regular recvmsg(). For
> example, with RPC-style traffic with 32KB messages, there is a roughly
> 15% efficiency improvement when using zerocopy. Without these changes,
> there is a roughly 60-70% efficiency reduction with such messages when
> employing zerocopy.

Applied, thank you!
