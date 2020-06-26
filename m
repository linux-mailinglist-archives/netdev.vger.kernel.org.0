Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7520BCF7
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFZXAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:00:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:53520 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgFZXAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:00:36 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1joxKW-0000PS-RM; Sat, 27 Jun 2020 01:00:20 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1joxKW-000HDo-F1; Sat, 27 Jun 2020 01:00:20 +0200
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        hch@lst.de, davem@davemloft.net, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, maximmi@mellanox.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
Date:   Sat, 27 Jun 2020 01:00:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200626134358.90122-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25855/Fri Jun 26 15:19:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20 3:43 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> When the AF_XDP buffer allocation API was introduced it had an
> optimization, "cheap_dma". The idea was that when the umem was DMA
> mapped, the pool also checked whether the mapping required a
> synchronization (CPU to device, and vice versa). If not, it would be
> marked as "cheap_dma" and the synchronization would be elided.
> 
> In [1] Christoph points out that the optimization above breaks the DMA
> API abstraction, and should be removed. Further, Christoph points out
> that optimizations like this should be done within the DMA mapping
> core, and not elsewhere.
> 
> Unfortunately this has implications for the packet rate
> performance. The AF_XDP rxdrop scenario shows a 9% decrease in packets
> per second.
> 
> [1] https://lore.kernel.org/netdev/20200626074725.GA21790@lst.de/
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Given there is roughly a ~5 weeks window at max where this removal could
still be applied in the worst case, could we come up with a fix / proposal
first that moves this into the DMA mapping core? If there is something that
can be agreed upon by all parties, then we could avoid re-adding the 9%
slowdown. :/

Thanks,
Daniel
