Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AB2215B3F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgGFPz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:55:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:19988 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729364AbgGFPz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1594050928; x=1625586928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3TkKY9KQeRhIuvy9P3RKz9OgjskSbhfD+RbYGnayy5Y=;
  b=ZFRpUio23l2gVWRaEK190lWzIe7K53+bVtgZLQv1TQ/o0NIF9w35xqLR
   ft9RGOEG7Y7BMU8ojlOs+D1XjF/07LQwx4vwFmlHFLiICgvFTMolhD6PC
   SnqugWSYXeQVPppIx1QVZbkyMqgySPhcV2XnqNknGuL1UWD5Lq4BVghBn
   M=;
IronPort-SDR: +RmzTn2MlYjYF92koCnVJ7eH9l8i8f3obZZSRi/Y5U6zOrWEsqt56T+eWHkB6/Psm7ZYy+s7AP
 p2DgYTMbJ39A==
X-IronPort-AV: E=Sophos;i="5.75,320,1589241600"; 
   d="scan'208";a="41712052"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 06 Jul 2020 15:55:27 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id D6C95A23D1;
        Mon,  6 Jul 2020 15:55:26 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 15:55:25 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.162.73) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 6 Jul 2020 15:55:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <ja@ssi.bg>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net-next] inet: Remove an unnecessary argument of syn_ack_recalc().
Date:   Tue, 7 Jul 2020 00:55:17 +0900
Message-ID: <20200706155517.96748-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <cb795577-4759-3ab6-43c9-7a4f9c8d832f@gmail.com>
References: <cb795577-4759-3ab6-43c9-7a4f9c8d832f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D16UWB002.ant.amazon.com (10.43.161.234) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Sun, 5 Jul 2020 10:08:08 -0700
> On 7/4/20 8:28 AM, Kuniyuki Iwashima wrote:
> > Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> > retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> > if a minisock is held and a SYN+ACK is retransmitted or not.
> > 
> > If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> > has the same value because max_retries is overwritten by rskq_defer_accept
> > in reqsk_timer_handler().
> > 
> > This commit adds two changes:
> > - remove max_retries from the arguments of syn_ack_recalc() and use
> >    rskq_defer_accept instead.
> > - rename thresh to max_retries for readability.
> > 
> 
> Honestly this looks unnecessary code churn to me.
> 
> This will make future backports more error prone.
> 
> Real question is : why do you want this change in the first place ?

The current code does non-zero checks for rskq_defer_accept twice in
reqsk_timer_handler() and syn_ack_recalc(), the former of which is
redundant.

Also, max_retries can have two meanings in reqsk_timer_handler() depending
on TCP_DEFER_ACCEPT:
  - the number of retries to resend SYN+ACK (unused)
  - the number of retries to drop bare ACK

On the other hand, the max_retries in reqsk_timer_handler() has only the
latter meaning and is confusing because rskq_defer_accept has the same
(original) value and the both values are used.

As far as I see, in the original code, the non-zero check was reasonable
because it was done once and the max_retries was evaluated through the
function (tcp_synack_timer()).


$ git blame net/ipv4/tcp_timer.c 1944972d3bb651474a5021c9da8d0166ae19f1eb
...
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 464) static void tcp_synack_timer(struct sock *sk)
...
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 468)    int max_retries = tp->syn_retries ? : sysctl_tcp_synack_retries;
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 469)    int thresh = max_retries;
...
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 505)    if (tp->defer_accept)
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 506)            max_retries = tp->defer_accept;
...
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 515)                            if ((req->retrans < thresh ||
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 516)                                 (req->acked && req->retrans < max_retries))
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 517)                                && !req->class->rtx_syn_ack(sk, req, NULL)) {


Currently, the code already looks a bit churned and error-prone.

It might be because of the ambiguity of the name of max_retries. 

rskq_defer_accept is assigned to max_retries but not always "max".
The code checks thresh at first, and then max_retries. So, as a result of
the evaluation order, it can be "max" (also may be smaller than thresh).
Moreover, in this context, there are three kinds of "retries": timer
(num_timeout), resending SYN+ACK (thresh), and dropping bare ACK
(max_retries and rskq_defer_accept).

In the original code, it was OK because we did not use rskq_defer_accept
twice.

The commit introduces syn_ack_recalc() and delegates the decision of
retries to the function.

I think it is better to 
  - remove the redundant check of rskq_defer_accept
  - pass only necessary arguments to syn_ack_recalc()
  - use a more understandable name instead of max_retries in two functions. 

For example, max_resends and rskq_defer_accept, or max_syn_ack_retries and
rskq_defer_accept. (I am not confident about what is the most
understandable name for anyone.)

So, I would like to respin the patch rephrasing max_retries to the proper
name.

What would you think about this?

Sincerely,
Kuniyuki
