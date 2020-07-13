Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811FA21E302
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGMWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgGMWaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:30:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B286A20899;
        Mon, 13 Jul 2020 22:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594679419;
        bh=RbioDPqIruOwjvgR+/utN6C/KuiKJYmmm2XhtvXQ5Wg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ww61/VEOA9drLSoKz8PJ8QERdbIXZ6TfSPUM4P5SkheS07KymB+1Mugo8s/MWD5Nh
         XIuMpCnuYdnqqnOuJYKCRu5oYEUX5Xyw5PUJ69fykXjincT3J8DwzDDdUqRPDv02sv
         F7KN3BrQkEGI2fFP3eYB/0X+03htGsJPYgfpmYHc=
Date:   Mon, 13 Jul 2020 15:30:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] enetc: Add adaptive interrupt coalescing
Message-ID: <20200713153017.07caaf73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594644970-13531-7-git-send-email-claudiu.manoil@nxp.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
        <1594644970-13531-7-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 15:56:10 +0300 Claudiu Manoil wrote:
> Use the generic dynamic interrupt moderation (dim)
> framework to implement adaptive interrupt coalescing
> in ENETC.  With the per-packet interrupt scheme, a high
> interrupt rate has been noted for moderate traffic flows
> leading to high CPU utilization.  The 'dim' scheme
> implemented by the current patch addresses this issue
> improving CPU utilization while using minimal coalescing
> time thresholds in order to preserve a good latency.
> 
> Below are some measurement results for before and after
> this patch (and related dependencies) basically, for a
> 2 ARM Cortex-A72 @1.3Ghz CPUs system (32 KB L1 data cache),
> using netperf @ 1Gbit link (maximum throughput):
> 
> 1) 1 Rx TCP flow, both Rx and Tx processed by the same NAPI
> thread on the same CPU:
> 	CPU utilization		int rate (ints/sec)
> Before:	50%-60% (over 50%)		92k
> After:  just under 50%			35k
> Comment:  Small CPU utilization improvement for a single flow
> 	  Rx TCP flow (i.e. netperf -t TCP_MAERTS) on a single
> 	  CPU.
> 
> 2) 1 Rx TCP flow, Rx processing on CPU0, Tx on CPU1:
> 	Total CPU utilization	Total int rate (ints/sec)
> Before:	60%-70%			85k CPU0 + 42k CPU1
> After:  15%			3.5k CPU0 + 3.5k CPU1
> Comment:  Huge improvement in total CPU utilization
> 	  correlated w/a a huge decrease in interrupt rate.
> 
> 3) 4 Rx TCP flows + 4 Tx TCP flows (+ pings to check the latency):
> 	Total CPU utilization	Total int rate (ints/sec)
> Before:	~80% (spikes to 90%)		~100k
> After:   60% (more steady)		 ~10k
> Comment:  Important improvement for this load test, while the
> 	  ping test outcome was not impacted.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Does it really make sense to implement DIM for TX?

For TX the only thing we care about is that no queue in the system
underflows. So the calculation is simply timeout = queue len / speed.
The only problem is which queue in the system is the smallest (TX 
ring, TSQ etc.) but IMHO there's little point in the extra work to
calculate the thresholds dynamically. On real life workloads the
scheduler overhead the async work structs introduce cause measurable
regressions.

That's just to share my experience, up to you to decide if you want 
to keep the TX-side DIM or not :)
