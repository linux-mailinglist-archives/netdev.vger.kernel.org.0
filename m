Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4105C153172
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBENIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:08:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBENIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:08:38 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34185158E2189;
        Wed,  5 Feb 2020 05:08:37 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:08:35 +0100 (CET)
Message-Id: <20200205.140835.1375589051372133185.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, cpaasch@apple.com, pabeni@redhat.com
Subject: Re: [PATCH net] mptcp: fix use-after-free on tcp fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204171230.618-1-fw@strlen.de>
References: <20200204171230.618-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:08:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Tue,  4 Feb 2020 18:12:30 +0100

> When an mptcp socket connects to a tcp peer or when a middlebox interferes
> with tcp options, mptcp needs to fall back to plain tcp.
> Problem is that mptcp is trying to be too clever in this case:
> 
> It attempts to close the mptcp meta sk and transparently replace it with
> the (only) subflow tcp sk.
> 
> Unfortunately, this is racy -- the socket is already exposed to userspace.
> Any parallel calls to send/recv/setsockopt etc. can cause use-after-free:
> 
> BUG: KASAN: use-after-free in atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:693 [inline]
 ...
> While the use-after-free can be resolved, there is another problem:
> sock->ops and sock->sk assignments are not atomic, i.e. we may get calls
> into mptcp functions with sock->sk already pointing at the subflow socket,
> or calls into tcp functions with a mptcp meta sk.
> 
> Remove the fallback code and call the relevant functions for the (only)
> subflow in case the mptcp socket is connected to tcp peer.
> 
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian.
