Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B220F35
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfEPTZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:25:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEPTZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:25:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D88A133E97B3;
        Thu, 16 May 2019 12:25:49 -0700 (PDT)
Date:   Thu, 16 May 2019 12:25:49 -0700 (PDT)
Message-Id: <20190516.122549.1356146859638469688.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, weiwan@google.com, dsahern@gmail.com,
        kafai@fb.com
Subject: Re: [PATCH net] ipv6: prevent possible fib6 leaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516023952.28943-1-edumazet@google.com>
References: <20190516023952.28943-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:25:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 15 May 2019 19:39:52 -0700

> At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
> for finding all percpu routes and set their ->from pointer
> to NULL, so that fib6_ref can reach its expected value (1).
> 
> The problem right now is that other cpus can still catch the
> route being deleted, since there is no rcu grace period
> between the route deletion and call to fib6_drop_pcpu_from()
> 
> This can leak the fib6 and associated resources, since no
> notifier will take care of removing the last reference(s).
> 
> I decided to add another boolean (fib6_destroying) instead
> of reusing/renaming exception_bucket_flushed to ease stable backports,
> and properly document the memory barriers used to implement this fix.
> 
> This patch has been co-developped with Wei Wang.
> 
> Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
