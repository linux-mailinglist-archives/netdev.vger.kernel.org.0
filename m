Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF381CFEB0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgELTuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgELTuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:50:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FA2C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:50:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABC771283561B;
        Tue, 12 May 2020 12:50:21 -0700 (PDT)
Date:   Tue, 12 May 2020 12:50:20 -0700 (PDT)
Message-Id: <20200512.125020.1577259938371953992.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] tcp: fix SO_RCVLOWAT hangs with fat skbs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512135430.201113-1-edumazet@google.com>
References: <20200512135430.201113-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 May 2020 12:50:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 12 May 2020 06:54:30 -0700

> We autotune rcvbuf whenever SO_RCVLOWAT is set to account for 100%
> overhead in tcp_set_rcvlowat()
> 
> This works well when skb->len/skb->truesize ratio is bigger than 0.5
> 
> But if we receive packets with small MSS, we can end up in a situation
> where not enough bytes are available in the receive queue to satisfy
> RCVLOWAT setting.
> As our sk_rcvbuf limit is hit, we send zero windows in ACK packets,
> preventing remote peer from sending more data.
> 
> Even autotuning does not help, because it only triggers at the time
> user process drains the queue. If no EPOLLIN is generated, this
> can not happen.
> 
> Note poll() has a similar issue, after commit
> c7004482e8dc ("tcp: Respect SO_RCVLOWAT in tcp_poll().")
> 
> Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
