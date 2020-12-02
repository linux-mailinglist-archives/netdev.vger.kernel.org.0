Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A398C2CC662
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgLBTRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:17:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgLBTRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:17:39 -0500
Date:   Wed, 2 Dec 2020 11:16:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606936619;
        bh=p3qFvXorODELi7Dmo+QZgR27NcGlx3i74Mc7l0Lehvc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=c2OzZxHVKrCQf4pgVndmWxQ/DwR6ib5R8B9rxDWpMJKnuYa+4JXzIlEQ5dgnSWEt2
         rBpmA7ylEu1ijQeOFE0mNnwOPQZEnMrxM1uzz8DM0bKF4F+fLShWyBzxE3Ffc7fPhv
         uXxeZuvxYZGOQmoQvAWt6QlzIqCGetbdT/y8coMKKWXOZKSlCWZMlxLvq/aUzvk3RS
         JZBZTL523S/CJZdDjZoRxsx4qXy1e1AC6B2uNEjQgZfl2YnfbwhKlTpcSGLgVNULZn
         7+l2NOZrsTXljW+77FKmK56lXic53I/+i8JtdYFeez1YA2E1UEoeZM7A7BSOAPHGl8
         4aeVX55llIGrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, Maria Pasechnik <mariap@mellanox.com>
Subject: Re: [PATCH net] net: ip6_gre: set dev->hard_header_len when using
 header_ops
Message-ID: <20201202111657.197327df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130161911.464106-1-atenart@kernel.org>
References: <20201130161911.464106-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 17:19:11 +0100 Antoine Tenart wrote:
> syzkaller managed to crash the kernel using an NBMA ip6gre interface. I
> could reproduce it creating an NBMA ip6gre interface and forwarding
> traffic to it:
> 
>   skbuff: skb_under_panic: text:ffffffff8250e927 len:148 put:44 head:ffff8c03c7a33
>   ------------[ cut here ]------------
>   kernel BUG at net/core/skbuff.c:109!
>   Call Trace:
>   skb_push+0x10/0x10
>   ip6gre_header+0x47/0x1b0
>   neigh_connected_output+0xae/0xf0
> 
> ip6gre tunnel provides its own header_ops->create, and sets it
> conditionally when initializing the tunnel in NBMA mode. When
> header_ops->create is used, dev->hard_header_len should reflect the
> length of the header created. Otherwise, when not used,
> dev->needed_headroom should be used.
> 
> Fixes: eb95f52fc72d ("net: ipv6_gre: Fix GRO to work on IPv6 over GRE tap")
> Cc: Maria Pasechnik <mariap@mellanox.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>

Applied, thank you!
