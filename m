Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642DB30BD63
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBBLtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:49:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:52250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhBBLtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 06:49:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 184F1AD6A;
        Tue,  2 Feb 2021 11:48:29 +0000 (UTC)
Subject: Re: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <edumazet@google.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-2-haokexin@gmail.com>
 <20210202113618.s4tz2q7ysbnecgsl@skbuf>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <2d406568-5b1d-d941-5503-68ba2ed49f34@suse.cz>
Date:   Tue, 2 Feb 2021 12:48:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202113618.s4tz2q7ysbnecgsl@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 12:36 PM, Ioana Ciornei wrote:
> On Sun, Jan 31, 2021 at 03:44:23PM +0800, Kevin Hao wrote:
>> In the current implementation of page_frag_alloc(), it doesn't have
>> any align guarantee for the returned buffer address. But for some
>> hardwares they do require the DMA buffer to be aligned correctly,
>> so we would have to use some workarounds like below if the buffers
>> allocated by the page_frag_alloc() are used by these hardwares for
>> DMA.
>>     buf = page_frag_alloc(really_needed_size + align);
>>     buf = PTR_ALIGN(buf, align);
>> 
>> These codes seems ugly and would waste a lot of memories if the buffers
>> are used in a network driver for the TX/RX.
> 
> Isn't the memory wasted even with this change?

Yes, but less of it. Not always full amount of align, but up to it. Perhaps even
zero.

> I am not familiar with the frag allocator so I might be missing
> something, but from what I understood each page_frag_cache keeps only
> the offset inside the current page being allocated, offset which you
> ALIGN_DOWN() to match the alignment requirement. I don't see how that
> memory between the non-aligned and aligned offset is going to be used
> again before the entire page is freed.

True, thath's how page_frag is designed. The align amounts would be most likely
too small to be usable anyway.
