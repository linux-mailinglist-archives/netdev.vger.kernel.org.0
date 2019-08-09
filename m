Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC91686F3B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405293AbfHIBXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:23:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405170AbfHIBXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:23:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DCEFA14284347;
        Thu,  8 Aug 2019 18:22:59 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:22:59 -0700 (PDT)
Message-Id: <20190808.182259.1921801896274965443.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        linux-net-drivers@solarflare.com
Subject: Re: [PATCH v3 net-next 0/3] net: batched receive in GRO path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:23:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 6 Aug 2019 14:52:06 +0100

> This series listifies part of GRO processing, in a manner which allows those
>  packets which are not GROed (i.e. for which dev_gro_receive returns
>  GRO_NORMAL) to be passed on to the listified regular receive path.
> dev_gro_receive() itself is not listified, nor the per-protocol GRO
>  callback, since GRO's need to hold packets on lists under napi->gro_hash
>  makes keeping the packets on other lists awkward, and since the GRO control
>  block state of held skbs can refer only to one 'new' skb at a time.
> Instead, when napi_frags_finish() handles a GRO_NORMAL result, stash the skb
>  onto a list in the napi struct, which is received at the end of the napi
>  poll or when its length exceeds the (new) sysctl net.core.gro_normal_batch.
> 
> Performance figures with this series, collected on a back-to-back pair of
>  Solarflare sfn8522-r2 NICs with 120-second NetPerf tests.  In the stats,
>  sample size n for old and new code is 6 runs each; p is from a Welch t-test.
> Tests were run both with GRO enabled and disabled, the latter simulating
>  uncoalesceable packets (e.g. due to IP or TCP options).  The receive side
>  (which was the device under test) had the NetPerf process pinned to one CPU,
>  and the device interrupts pinned to a second CPU.  CPU utilisation figures
>  (used in cases of line-rate performance) are summed across all CPUs.
> net.core.gro_normal_batch was left at its default value of 8.
 ...
> The above results are fairly mixed, and in most cases not statistically
>  significant.  But I think we can roughly conclude that the series
>  marginally improves non-GROable throughput, without hurting latency
>  (except in the large-payload busy-polling case, which in any case yields
>  horrid performance even on net-next (almost triple the latency without
>  busy-poll).  Also, drivers which, unlike sfc, pass UDP traffic to GRO
>  would expect to see a benefit from gaining access to batching.
> 
> Changed in v3:
>  * gro_normal_batch sysctl now uses SYSCTL_ONE instead of &one
>  * removed RFC tags (no comments after a week means no-one objects, right?)
> 
> Changed in v2:
>  * During busy poll, call gro_normal_list() to receive batched packets
>    after each cycle of the napi busy loop.  See comments in Patch #3 for
>    complications of doing the same in busy_poll_stop().
> 
> [1]: Cohen 1959, doi: 10.1080/00401706.1959.10489859

Series applied, thanks Edward.
