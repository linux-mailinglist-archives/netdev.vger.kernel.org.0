Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25430B47A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBBBKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhBBBKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 059C564ED4;
        Tue,  2 Feb 2021 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612228162;
        bh=TizNW2zL4oh0s1cHiJ8abfnxuwrUy5tn4+DAdtpjc/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T7sBnFUPHoxmnqAP5r2CiO81RXnDRlpCoV5I98YAHHJGHme56UJw0Gae9j6g3zw5Q
         RkGD+bJTgiuP+FLkUYSIyfsW6X9F9f3ghZS5vtnfwL6ETt6j095Ytzzn1+jv6ZdjcB
         BfhDsJVtf3mlLoEPJ7DJOjBysZa3SpKeTSYeR3dbh/RMWBfmz+tXRE80/3ZVfmD57D
         pj00wAe5NQhzaSC1hGzdDBryq6lPmDdgoE4KIgbyCWJMVAb5bwM2jqfoQyKDI9hFKn
         /pA8vrKJfJZ6iObNsrNn+AdWfT0cfCwR2sFhfu3cEUHbJZc7ZYJuT/CRnBEJEgVjxm
         p7riRthefyE5Q==
Date:   Mon, 1 Feb 2021 17:09:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chinmay Agarwal <chinagar@codeaurora.org>
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, sharathv@codeaurora.org
Subject: Re: [PATCH] neighbour: Prevent a dead entry from updating gc_list
Message-ID: <20210201170920.6fa1204e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
References: <20210127165453.GA20514@chinagar-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 22:24:54 +0530 Chinmay Agarwal wrote:
> Following race condition was detected:
> <CPU A, t0> - neigh_flush_dev() is under execution and calls
> neigh_mark_dead(n) marking the neighbour entry 'n' as dead.
> 
> <CPU B, t1> - Executing: __netif_receive_skb() ->
> __netif_receive_skb_core() -> arp_rcv() -> arp_process().arp_process()
> calls __neigh_lookup() which takes a reference on neighbour entry 'n'.
> 
> <CPU A, t2> - Moves further along neigh_flush_dev() and calls
> neigh_cleanup_and_release(n), but since reference count increased in t2,
> 'n' couldn't be destroyed.
> 
> <CPU B, t3> - Moves further along, arp_process() and calls
> neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
> the neighbour entry back in gc_list(neigh_mark_dead(), removed it
> earlier in t0 from gc_list)
> 
> <CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
> the neighbour entry.
> 
> This leads to 'n' still being part of gc_list, but the actual
> neighbour structure has been freed.
> 
> The situation can be prevented from happening if we disallow a dead
> entry to have any possibility of updating gc_list. This is what the
> patch intends to achieve.
> 
> Fixes: 9c29a2f55ec0 ("neighbor: Fix locking order for gc_list changes")
> Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>

Applied, thanks!
