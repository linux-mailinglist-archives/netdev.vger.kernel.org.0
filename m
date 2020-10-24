Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6670E297A54
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 04:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758992AbgJXCNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 22:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757148AbgJXCNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 22:13:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8182176B;
        Sat, 24 Oct 2020 02:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603505633;
        bh=6Tgh646eyL6JHHu2j0pX2jjd8ErUUQKmUnlYTvSRhnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K2LQM9bbDMOexmHsYHtmGMbW28xML3H8ZRnUs/izvZvPH/+pVpfucYQ+5WizWGi3n
         5hXaQ5hYDFlsAF89XcMzj5hLqilk/LwBetX6oOZI2wyrerdlCHKa8MAmqhvmt/1d2N
         aoFH8ruydxbyOtQ+6cfSWlX9Hr9SdObM9LtRBGzY=
Date:   Fri, 23 Oct 2020 19:13:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, ncardwell@google.com
Subject: Re: [net v2] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
Message-ID: <20201023191348.7a6003f4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023184709.217614-1-arjunroy.kdev@gmail.com>
References: <20201023184709.217614-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 11:47:09 -0700 Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> With SO_RCVLOWAT, under memory pressure,
> it is possible to enter a state where:
> 
> 1. We have not received enough bytes to satisfy SO_RCVLOWAT.
> 2. We have not entered buffer pressure (see tcp_rmem_pressure()).
> 3. But, we do not have enough buffer space to accept more packets.
> 
> In this case, we advertise 0 rwnd (due to #3) but the application does
> not drain the receive queue (no wakeup because of #1 and #2) so the
> flow stalls.
> 
> Modify the heuristic for SO_RCVLOWAT so that, if we are advertising
> rwnd<=rcv_mss, force a wakeup to prevent a stall.
> 
> Without this patch, setting tcp_rmem to 6143 and disabling TCP
> autotune causes a stalled flow. With this patch, no stall occurs. This
> is with RPC-style traffic with large messages.
> 
> Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
