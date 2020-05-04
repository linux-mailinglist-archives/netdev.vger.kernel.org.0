Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727FD1C4678
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEDS4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDS4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:56:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AAFC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:56:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFAA7120F5281;
        Mon,  4 May 2020 11:56:44 -0700 (PDT)
Date:   Mon, 04 May 2020 11:56:43 -0700 (PDT)
Message-Id: <20200504.115643.1162428608759543632.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH v2 net-next] net_sched: sch_fq: add horizon attribute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501140741.161104-1-edumazet@google.com>
References: <20200501140741.161104-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:56:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  1 May 2020 07:07:41 -0700

> QUIC servers would like to use SO_TXTIME, without having CAP_NET_ADMIN,
> to efficiently pace UDP packets.
> 
> As far as sch_fq is concerned, we need to add safety checks, so
> that a buggy application does not fill the qdisc with packets
> having delivery time far in the future.
> 
> This patch adds a configurable horizon (default: 10 seconds),
> and a configurable policy when a packet is beyond the horizon
> at enqueue() time:
> - either drop the packet (default policy)
> - or cap its delivery time to the horizon.
> 
> $ tc -s -d qd sh dev eth0
> qdisc fq 8022: root refcnt 257 limit 10000p flow_limit 100p buckets 1024
>  orphan_mask 1023 quantum 10Kb initial_quantum 51160b low_rate_threshold 550Kbit
>  refill_delay 40.0ms timer_slack 10.000us horizon 10.000s
>  Sent 1234215879 bytes 837099 pkt (dropped 21, overlimits 0 requeues 6)
>  backlog 0b 0p requeues 6
>   flows 1191 (inactive 1177 throttled 0)
>   gc 0 highprio 0 throttled 692 latency 11.480us
>   pkts_too_long 0 alloc_errors 0 horizon_drops 21 horizon_caps 0
> 
> v2: fixed an overflow on 32bit kernels in fq_init(), reported
>     by kbuild test robot <lkp@intel.com>
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, with some fuzz due to the recent fq optimizations.

Thanks.
