Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FEAB8FE
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392958AbfIFNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:13:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389197AbfIFNNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:13:40 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B04B152F693D;
        Fri,  6 Sep 2019 06:13:38 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:13:36 +0200 (CEST)
Message-Id: <20190906.151336.1295858768713607107.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH net] net: sched: fix reordering issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905122022.106680-1-edumazet@google.com>
References: <20190905122022.106680-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:13:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  5 Sep 2019 05:20:22 -0700

> Whenever MQ is not used on a multiqueue device, we experience
> serious reordering problems. Bisection found the cited
> commit.
> 
> The issue can be described this way :
> 
> - A single qdisc hierarchy is shared by all transmit queues.
>   (eg : tc qdisc replace dev eth0 root fq_codel)
> 
> - When/if try_bulk_dequeue_skb_slow() dequeues a packet targetting
>   a different transmit queue than the one used to build a packet train,
>   we stop building the current list and save the 'bad' skb (P1) in a
>   special queue. (bad_txq)
> 
> - When dequeue_skb() calls qdisc_dequeue_skb_bad_txq() and finds this
>   skb (P1), it checks if the associated transmit queues is still in frozen
>   state. If the queue is still blocked (by BQL or NIC tx ring full),
>   we leave the skb in bad_txq and return NULL.
> 
> - dequeue_skb() calls q->dequeue() to get another packet (P2)
> 
>   The other packet can target the problematic queue (that we found
>   in frozen state for the bad_txq packet), but another cpu just ran
>   TX completion and made room in the txq that is now ready to accept
>   new packets.
> 
> - Packet P2 is sent while P1 is still held in bad_txq, P1 might be sent
>   at next round. In practice P2 is the lead of a big packet train
>   (P2,P3,P4 ...) filling the BQL budget and delaying P1 by many packets :/
> 
> To solve this problem, we have to block the dequeue process as long
> as the first packet in bad_txq can not be sent. Reordering issues
> disappear and no side effects have been seen.
> 
> Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
