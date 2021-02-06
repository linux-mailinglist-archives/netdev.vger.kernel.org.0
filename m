Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAC3311FB4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBFTcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhBFTcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:32:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E943164E53;
        Sat,  6 Feb 2021 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612639883;
        bh=6bQmaNWvzHtJweYNj9imwAba7NyI4nxU1x/8VYWdK3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GvYxNzjfYRblqjt0a8ydcO0cMpC4cK6ZkIQie9oN5xa7uGSRz1n2L61DyxNNN4QI3
         4nqOFk+scx9oLEZimMZM4molofwmHVtyZgFkVF1oJ2pVlBxXxA3e1tCNuiqJc4au80
         DCrdd/Kn12TL5LxuBoCmIiHqfjOO5LBJD9zl1cBYTsr1+i8RR1lVYtJFmaFn0NWfOI
         XDO7W/fLbmIRJw0Wc9WoK0DCeUd/Ed7+jnmOujrO+EVNTxoxubbMAuXX8wFkmlielP
         31TwbscYvc423mPb8VYPTb6HYD9LD+56PCsyL4lEcdcCezvduVoJV/48aZ7eMLP9Co
         2iqgYUEd1Ch8w==
Date:   Sat, 6 Feb 2021 11:31:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org, stranche@codeaurora.org,
        subashab@codeaurora.org
Subject: Re: [PATCH net-next v5 1/2] net: mhi-net: Add re-aggregation of
 fragmented packets
Message-ID: <20210206113121.52f27389@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
References: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 09:40:00 +0100 Loic Poulain wrote:
> When device side MTU is larger than host side MTU, the packets
> (typically rmnet packets) are split over multiple MHI transfers.
> In that case, fragments must be re-aggregated to recover the packet
> before forwarding to upper layer.
> 
> A fragmented packet result in -EOVERFLOW MHI transaction status for
> each of its fragments, except the final one. Such transfer was
> previously considered as error and fragments were simply dropped.
> 
> This change adds re-aggregation mechanism using skb chaining, via
> skb frag_list.
> 
> A warning (once) is printed since this behavior usually comes from
> a misconfiguration of the device (e.g. modem MTU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Applied, thanks, but I had to invert the order of the patches.
Otherwise during bisection someone may hit a point in the tree
where mhi_net generates fragmented skbs but rmnet does not handle
them.
