Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC432B9F29
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgKTARU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgKTARU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:17:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B07C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:17:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfu6r-0005h0-6z; Fri, 20 Nov 2020 01:17:07 +0100
Date:   Fri, 20 Nov 2020 01:17:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Message-ID: <20201120001705.GL15137@breakpoint.cc>
References: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119225842.GK15137@breakpoint.cc>
 <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ramsay, Lincoln <Lincoln.Ramsay@digi.com> wrote:

[ patch looks good to me, I have no further comments ]

> > For build_skb path to work the buffer scheme would need to be changed
> > to reserve headroom, so yes, I think that the proposed patch is the
> > most convenient solution.
> 
> I don't know about benefits/feasibility, but I did wonder if (in the event that the "fast path" is possible), the dma_mapping could use an offset? The page would include the skb header but the dma mapping would not. If that was done though, only 1 RX frame would fit into the page (at least on my system, where the RX frame seems to be 2k and the page is 4k). Also, there's a possibility to set the "order" variable, so that multiple pages are created at once and I'm not sure if this would work in that case.

Yes, this is what some drivers do, they allocate a page, pass
pageaddr + headroom_offset everywhere, except build_skb() which gets the
pageaddr followed by skb_reserve(skb, headroom_offset).

> > This only copies the initial part and then the rest is added as a frag.
> 
> Oh yeah. That's not as bad as I had thought then :)
> 
> I wonder though... if the "fast path" is possible, could the whole packet (including header) be added as a frag, avoiding the header copy? Or is that not how SKBs work?

No, you can either have skb->head point to the page (build_skb), or
skb->head needs to be kmalloc'd (napi_alloc_skb for example).

Both can have page frags. In the second case, at least L2 header
needs to be in skb->head (and ip stack would pull in L3 header as well
later on anyway).
