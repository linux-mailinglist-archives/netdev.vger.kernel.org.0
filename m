Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244DC90B71
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 01:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfHPX1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 19:27:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbfHPX1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 19:27:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 15473141B37F4;
        Fri, 16 Aug 2019 16:27:43 -0700 (PDT)
Date:   Fri, 16 Aug 2019 16:27:37 -0700 (PDT)
Message-Id: <20190816.162737.128286385440292449.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix false detection of retransmit failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815032408.7287-1-tuong.t.lien@dektech.com.au>
References: <20190815032408.7287-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 16:27:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 15 Aug 2019 10:24:08 +0700

> This commit eliminates the use of the link 'stale_limit' & 'prev_from'
> (besides the already removed - 'stale_cnt') variables in the detection
> of repeated retransmit failures as there is no proper way to initialize
> them to avoid a false detection, i.e. it is not really a retransmission
> failure but due to a garbage values in the variables.
> 
> Instead, a jiffies variable will be added to individual skbs (like the
> way we restrict the skb retransmissions) in order to mark the first skb
> retransmit time. Later on, at the next retransmissions, the timestamp
> will be checked to see if the skb in the link transmq is "too stale",
> that is, the link tolerance time has passed, so that a link reset will
> be ordered. Note, just checking on the first skb in the queue is fine
> enough since it must be the oldest one.
> A counter is also added to keep track the actual skb retransmissions'
> number for later checking when the failure happens.
> 
> The downside of this approach is that the skb->cb[] buffer is about to
> be exhausted, however it is always able to allocate another memory area
> and keep a reference to it when needed.
> 
> Fixes: 77cf8edbc0e7 ("tipc: simplify stale link failure criteria")
> Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thank you.
