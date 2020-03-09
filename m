Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454D017D8A0
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgCIEsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:48:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgCIEsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:48:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9277D158B6EE5;
        Sun,  8 Mar 2020 21:48:38 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:48:37 -0700 (PDT)
Message-Id: <20200308.214837.642980003705609359.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, paulb@mellanox.com,
        jiri@mellanox.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] net/sched: act_ct: fix lockdep splat in
 tcf_ct_flow_table_get
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200308212748.107539-1-edumazet@google.com>
References: <20200308212748.107539-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:48:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun,  8 Mar 2020 14:27:48 -0700

> Convert zones_lock spinlock to zones_mutex mutex,
> and struct (tcf_ct_flow_table)->ref to a refcount,
> so that control path can use regular GFP_KERNEL allocations
> from standard process context. This is more robust
> in case of memory pressure.
> 
> The refcount is needed because tcf_ct_flow_table_put() can
> be called from RCU callback, thus in BH context.
> 
> The issue was spotted by syzbot, as rhashtable_init()
> was called with a spinlock held, which is bad since GFP_KERNEL
> allocations can sleep.
> 
> Note to developers : Please make sure your patches are tested
> with CONFIG_DEBUG_ATOMIC_SLEEP=y
 ...
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paul Blakey <paulb@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks.
