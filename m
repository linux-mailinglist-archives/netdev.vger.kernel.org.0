Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B2423B1ED
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgHDAyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHDAyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:54:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A5EC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 17:54:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B9F812786F6A;
        Mon,  3 Aug 2020 17:38:05 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:54:48 -0700 (PDT)
Message-Id: <20200803.175448.1236821189300519422.davem@davemloft.net>
To:     jfwang@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, edumazet@google.com,
        yyd@google.com, ycheng@google.com
Subject: Re: [PATCH net-next] tcp: apply a floor of 1 for RTT samples from
 TCP timestamps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730234916.2708735-1-jfwang@google.com>
References: <20200730234916.2708735-1-jfwang@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:38:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianfeng Wang <jfwang@google.com>
Date: Thu, 30 Jul 2020 23:49:16 +0000

> For retransmitted packets, TCP needs to resort to using TCP timestamps
> for computing RTT samples. In the common case where the data and ACK
> fall in the same 1-millisecond interval, TCP senders with millisecond-
> granularity TCP timestamps compute a ca_rtt_us of 0. This ca_rtt_us
> of 0 propagates to rs->rtt_us.
> 
> This value of 0 can cause performance problems for congestion control
> modules. For example, in BBR, the zero min_rtt sample can bring the
> min_rtt and BDP estimate down to 0, reduce snd_cwnd and result in a
> low throughput. It would be hard to mitigate this with filtering in
> the congestion control module, because the proper floor to apply would
> depend on the method of RTT sampling (using timestamp options or
> internally-saved transmission timestamps).
> 
> This fix applies a floor of 1 for the RTT sample delta from TCP
> timestamps, so that seq_rtt_us, ca_rtt_us, and rs->rtt_us will be at
> least 1 * (USEC_PER_SEC / TCP_TS_HZ).
> 
> Note that the receiver RTT computation in tcp_rcv_rtt_measure() and
> min_rtt computation in tcp_update_rtt_min() both already apply a floor
> of 1 timestamp tick, so this commit makes the code more consistent in
> avoiding this edge case of a value of 0.
> 
> Signed-off-by: Jianfeng Wang <jfwang@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Kevin Yang <yyd@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>

Applied and queued up for -stable, thanks.
