Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3962C148E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgKWTgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:36:08 -0500
Received: from mga06.intel.com ([134.134.136.31]:53000 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgKWTgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 14:36:07 -0500
IronPort-SDR: sC3XC+GLa75a9RVDj+oTSO++Yev8p8raTiwRaH4FpsV2XCyz3r1LE9eCijD98pReWK5eNViE5O
 SDy3OKMELNTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="233439436"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="233439436"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 11:36:07 -0800
IronPort-SDR: JpVS/ONgGCkFh1akX9jord2eO29BGEUBit6kbi6TC8IumpwyMiA4pk5VXhjnjXMGSUneWFJ1MJ
 vA6cQt6zUcXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="327306191"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2020 11:36:05 -0800
Date:   Mon, 23 Nov 2020 20:28:17 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Dmitry Bogdanov [C]" <dbogdanov@marvell.com>
Subject: Re: [EXT] Re: [PATCH v3] aquantia: Remove the build_skb path
Message-ID: <20201123192817.GA11618@ranger.igk.intel.com>
References: <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119224916.GA24569@ranger.igk.intel.com>
 <2fbb195a-a1b5-cec0-1ba1-bf45efc0ad24@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fbb195a-a1b5-cec0-1ba1-bf45efc0ad24@marvell.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 11:18:34AM +0300, Igor Russkikh wrote:
> 
> 
> On 20/11/2020 1:49 am, Maciej Fijalkowski wrote:
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Thu, Nov 19, 2020 at 10:34:48PM +0000, Ramsay, Lincoln wrote:
> >> When performing IPv6 forwarding, there is an expectation that SKBs
> >> will have some headroom. When forwarding a packet from the aquantia
> >> driver, this does not always happen, triggering a kernel warning.
> >>
> >> The build_skb path fails to allow for an SKB header, but the hardware
> >> buffer it is built around won't allow for this anyway. Just always use
> > the
> >> slower codepath that copies memory into an allocated SKB.
> >>
> >> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>
> >> ---
> > 
> > (Next time please include in the subject the tree that you're targetting
> > the patch)
> > 
> > I feel like it's only a workaround, not a real solution. On previous
> > thread Igor says:
> > 
> > "The limitation here is we can't tell HW on granularity less than 1K."
> > 
> > Are you saying that the minimum headroom that we could provide is 1k?
> 
> We can tell HW to place packets with 4 bytes granularity addresses, but the
> problem is the length granularity of this buffer - 1K.
> 
> This means we can do as Ramsay initially suggested - just offset the packet
> placement. But then we have to guarantee that 1K after this offset is
> available to HW.

Ok, I see, thanks for clarifying.

> 
> Since normal layout is 1400 packets - we do use 2K (half page) for each packet.

What is 'normal layout is 1400 packets' ? Didn't you mean the 1500 byte
standard MTU? So this is what you've been trying to tell me - that for
1500 byte mtu and 1k HW granularity you need to provide to HW 2k of
contiguous space, correct?

> This way we reuse each allocated page for at least two packets (and putting
> skb_shared into the remaining 512b).

I don't think I follow that. I thought that 2k needs to be exclusive for
HW and now you're saying that for remaining 512 bytes you can do whatever
you want.

If that's true then I think you can have build_skb support and I don't see
that 1k granularity as a limitation.

> 
> Obviously we may allocate 4K page for a single packet, and tell HW that it can
> use 3K for data. This'll give 1K headroom. Quite an overload - assuming IMIX
> is of 0.5K - 1.4K..
> 
> Of course that depends on a usecase. If you know all your traffic is 16K
> jumbos - putting 1K headroom is very small overhead on memory usage.
> 
> > Maybe put more pressure on memory side and pull in order-1 pages, provide
> > this big headroom and tailroom for skb_shared_info and use build_skb by
> > default? With standard 1500 byte MTU.
> I know many customers do consider AQC chips in near embedded environments
> (routers, etc). They really do care about memories. So that could be risky.

We have a knob that is controlled by ethtool's priv flag so you can change
the memory model and pull the build_skb out of the picture. Just FYI.

> 
> > This issue would pop up again if this driver would like to support XDP
> > where 256 byte headroom will have to be provided.
> 
> Actually it already popped. Thats one of the reasons I'm delaying with xdp
> patch series for this driver.
> 
> I think the best tradeoff here would be allocating order 1 or 2 pages (i.e. 8K
> or 16K), and reuse the page for multiple placements of 2K XDP packets:
> 
> (256+2048)*3 = 6912 (1K overhead for each 3 packets)
> 
> (256+2048)*7 = 16128 (200b overhead over 7 packets)

And for XDP_PASS you would use build_skb? Then tailroom needs to be
provided.

> 
> Regards,
>   Igor
> 
> 
> 
