Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE35359A8D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhDIJ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:59:47 -0400
Received: from outbound-smtp45.blacknight.com ([46.22.136.57]:46741 "EHLO
        outbound-smtp45.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233801AbhDIJ6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:58:25 -0400
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp45.blacknight.com (Postfix) with ESMTPS id B232EFAA0C
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 10:58:10 +0100 (IST)
Received: (qmail 26435 invoked from network); 9 Apr 2021 09:58:10 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 9 Apr 2021 09:58:10 -0000
Date:   Fri, 9 Apr 2021 10:58:08 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
Message-ID: <20210409095808.GL3697@techsingularity.net>
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net>
 <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net>
 <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 02:14:12AM -0700, Xie He wrote:
> On Fri, Apr 9, 2021 at 1:44 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> >
> > That would imply that the tap was communicating with a swap device to
> > allocate a pfmemalloc skb which shouldn't happen. Furthermore, it would
> > require the swap device to be deactivated while pfmemalloc skbs still
> > existed. Have you encountered this problem?
> 
> I'm not a user of swap devices or pfmemalloc skbs. I just want to make
> sure the protocols that I'm developing (not IP or IPv6) won't get
> pfmemalloc skbs when receiving, because those protocols cannot handle
> them.
> 
> According to the code, it seems always possible to get a pfmemalloc
> skb when a network driver calls "__netdev_alloc_skb". The skb will
> then be queued in per-CPU backlog queues when the driver calls
> "netif_rx". There seems to be nothing preventing "sk_memalloc_socks()"
> from becoming "false" after the skb is allocated and before it is
> handled by "__netif_receive_skb".
> 
> Do you mean that at the time "sk_memalloc_socks()" changes from "true"
> to "false", there would be no in-flight skbs currently being received,
> and all network communications have been paused?

Not all network communication, but communication with swap devices
should have stopped once sk_memalloc_socks is false.

-- 
Mel Gorman
SUSE Labs
