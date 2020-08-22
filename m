Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B6E24E492
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 03:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgHVBt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 21:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgHVBt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 21:49:26 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CACA720735;
        Sat, 22 Aug 2020 01:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598060966;
        bh=Us7hR9PT5tLu6mD4GU5oeioUGExScaxHbh/g39vD+JE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1jYfxNcMceDQKsYeSftPRMdM0vH9CVmTfU0rF6zBESYRAU5OlACX0ROuCCRj0k9xp
         JoSaOqfanYfnM0rq68gCAW2vjPunmOKPMyodDRVnN8SM5KccWY2DIDvTkpqY6MulUR
         17H438kGAS3M4yAMh4XVIjrq8HI5DUy46mSbIM74=
Date:   Fri, 21 Aug 2020 18:49:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH v3 1/2] net: add support for threaded NAPI polling
Message-ID: <20200821184924.5b5c421c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200821190151.9792-1-nbd@nbd.name>
References: <20200821190151.9792-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 21:01:50 +0200 Felix Fietkau wrote:
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
> 
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
> 
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
> 
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).
> 
> Based on a patch by Hillf Danton

I've tested this patch on a non-NUMA system with a moderately
high-network workload (roughly 1:6 network to compute cycles)
- and it provides ~2.5% speedup in terms of RPS but 1/6/10% worse
P50/P99/P999 latency.

I started working on a counter-proposal which uses a pool of threads
dedicated to NAPI polling. It's not unlike the workqueue code but
trying to be a little more clever. It gives me ~6.5% more RPS but at
the same time lowers the p99 latency by 35% without impacting other
percentiles. (I only started testing this afternoon, so hopefully the
numbers will improve further).

I'm happy for this patch to be merged, it's quite nice, but I wanted 
to give the heads up that I may have something that would replace it...

The extremely rough PoC, less than half-implemented code which is really
too broken to share:
https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/log/?h=tapi
