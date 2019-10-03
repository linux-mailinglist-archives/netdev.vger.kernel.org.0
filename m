Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04ECA146
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfJCPmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:42:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfJCPmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:42:12 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67CE11433FC41;
        Thu,  3 Oct 2019 08:42:11 -0700 (PDT)
Date:   Thu, 03 Oct 2019 11:42:10 -0400 (EDT)
Message-Id: <20191003.114210.1662126661929949949.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, fw@strlen.de,
        hannes@stressinduktion.org, syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipv6: drop incoming packets having a v4mapped
 source address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002163855.145178-1-edumazet@google.com>
References: <20191002163855.145178-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 08:42:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  2 Oct 2019 09:38:55 -0700

> This began with a syzbot report. syzkaller was injecting
> IPv6 TCP SYN packets having a v4mapped source address.
> 
> After an unsuccessful 4-tuple lookup, TCP creates a request
> socket (SYN_RECV) and calls reqsk_queue_hash_req()
> 
> reqsk_queue_hash_req() calls sk_ehashfn(sk)
> 
> At this point we have AF_INET6 sockets, and the heuristic
> used by sk_ehashfn() to either hash the IPv4 or IPv6 addresses
> is to use ipv6_addr_v4mapped(&sk->sk_v6_daddr)
> 
> For the particular spoofed packet, we end up hashing V4 addresses
> which were not initialized by the TCP IPv6 stack, so KMSAN fired
> a warning.
> 
> I first fixed sk_ehashfn() to test both source and destination addresses,
> but then faced various problems, including user-space programs
> like packetdrill that had similar assumptions.
> 
> Instead of trying to fix the whole ecosystem, it is better
> to admit that we have a dual stack behavior, and that we
> can not build linux kernels without V4 stack anyway.
> 
> The dual stack API automatically forces the traffic to be IPv4
> if v4mapped addresses are used at bind() or connect(), so it makes
> no sense to allow IPv6 traffic to use the same v4mapped class.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
