Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D378D18C68C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgCTEg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:36:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCTEg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:36:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D4141590D671;
        Thu, 19 Mar 2020 21:36:58 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:36:57 -0700 (PDT)
Message-Id: <20200319.213657.2200534713230659786.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, micron10@gmail.com,
        fw@strlen.de, pablo@netfilter.org
Subject: Re: [PATCH net] tcp: ensure skb->dev is NULL before leaving TCP
 stack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319194955.13742-1-edumazet@google.com>
References: <20200319194955.13742-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:36:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 19 Mar 2020 12:49:55 -0700

> skb->rbnode is sharing three skb fields : next, prev, dev
> 
> When a packet is sent, TCP keeps the original skb (master)
> in a rtx queue, which was converted to rbtree a while back.
> 
> __tcp_transmit_skb() is responsible to clone the master skb,
> and add the TCP header to the clone before sending it
> to network layer.
> 
> skb_clone() already clears skb->next and skb->prev, but copies
> the master oskb->dev into the clone.
> 
> We need to clear skb->dev, otherwise lower layers could interpret
> the value as a pointer to a netdev.
> 
> This old bug surfaced recently when commit 28f8bfd1ac94
> ("netfilter: Support iif matches in POSTROUTING") was merged.
> 
> Before this netfilter commit, skb->dev value was ignored and
> changed before reaching dev_queue_xmit()
> 
> Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
> Fixes: 28f8bfd1ac94 ("netfilter: Support iif matches in POSTROUTING")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Martin Zaharinov <micron10@gmail.com>

Applied and queued up for -stable, thanks Eric.
