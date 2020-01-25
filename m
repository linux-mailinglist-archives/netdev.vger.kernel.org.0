Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94361493DE
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 08:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAYHO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 02:14:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgAYHO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 02:14:57 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBB6515A16D6C;
        Fri, 24 Jan 2020 23:14:55 -0800 (PST)
Date:   Sat, 25 Jan 2020 08:14:53 +0100 (CET)
Message-Id: <20200125.081453.329018046256576212.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, mptcp@lists.01.org,
        edumazet@google.com, cpaasch@apple.com
Subject: Re: [PATCH net-next 1/2] mptcp: do not inherit inet proto ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125000403.251894-2-mathew.j.martineau@linux.intel.com>
References: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
        <20200125000403.251894-2-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 23:14:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 24 Jan 2020 16:04:02 -0800

> From: Florian Westphal <fw@strlen.de>
> 
> We need to initialise the struct ourselves, else we expose tcp-specific
> callbacks such as tcp_splice_read which will then trigger splat because
> the socket is an mptcp one:
> 
> BUG: KASAN: slab-out-of-bounds in tcp_mstamp_refresh+0x80/0xa0 net/ipv4/tcp_output.c:57
> Write of size 8 at addr ffff888116aa21d0 by task syz-executor.0/5478
> 
> CPU: 1 PID: 5478 Comm: syz-executor.0 Not tainted 5.5.0-rc6 #3
> Call Trace:
>  tcp_mstamp_refresh+0x80/0xa0 net/ipv4/tcp_output.c:57
>  tcp_rcv_space_adjust+0x72/0x7f0 net/ipv4/tcp_input.c:612
>  tcp_read_sock+0x622/0x990 net/ipv4/tcp.c:1674
>  tcp_splice_read+0x20b/0xb40 net/ipv4/tcp.c:791
>  do_splice+0x1259/0x1560 fs/splice.c:1205
> 
> To prevent build error with ipv6, add the recv/sendmsg function
> declaration to ipv6.h.  The functions are already accessible "thanks"
> to retpoline related work, but they are currently only made visible
> by socket.c specific INDIRECT_CALLABLE macros.
> 
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied.
