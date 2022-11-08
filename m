Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC1620F34
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiKHLhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbiKHLhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:37:06 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F6E15723;
        Tue,  8 Nov 2022 03:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667907425; x=1699443425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wS7+TWmj2Lw3rMZ6NWcYNkuSEncHx1hdZe7Eikl/1AM=;
  b=ispRJdmhZIDA+cz48HXbePXDNNJAnTc2p04ZYO3hjjIpI+y6gVQwuZvL
   w23R0hamT0UOBPDPeLeOE6yOB07Lcp/VrI0vY6zoH31XiMrWgSnQQ7w9j
   tpJjKhdI52P8XcFtqlQa+THnvQOoYfsAkKBufJg8ofHXpMkOyAwyS2yOn
   ooby1zgCTQdwM+APaVVSPSfwiRKhcZRQbUrlP2ZYIOUkuY3QqBdV7CsNp
   rSCzKQtQa6VwKYTNpS9rUk4+/CGqRoFHZLsHbjJ+WcNKwVQckyTEsKA71
   zxPgMe2CKPprHe9ClTBSl6gW07jzmLC1FYwc246z8t78GWDXEIfL0Id34
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290391527"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="290391527"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 03:37:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="638761222"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="638761222"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 08 Nov 2022 03:37:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A8Bb1SU015189;
        Tue, 8 Nov 2022 11:37:01 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 4/4] net: lan96x: Use page_pool API
Date:   Tue,  8 Nov 2022 12:33:31 +0100
Message-Id: <20221108113331.605821-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107213521.i6qmjut5hdxrrmcs@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-5-horatiu.vultur@microchip.com> <20221107164056.557894-1-alexandr.lobakin@intel.com> <20221107213521.i6qmjut5hdxrrmcs@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 7 Nov 2022 22:35:21 +0100

> The 11/07/2022 17:40, Alexander Lobakin wrote:
> 
> Hi Olek,
> 
> > 
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Date: Sun, 6 Nov 2022 22:11:54 +0100
> > 
> > > Use the page_pool API for allocation, freeing and DMA handling instead
> > > of dev_alloc_pages, __free_pages and dma_map_page.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---
> > >  .../net/ethernet/microchip/lan966x/Kconfig    |  1 +
> > >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 72 ++++++++++---------
> > >  .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
> > >  3 files changed, 43 insertions(+), 33 deletions(-)
> > 
> > [...]
> > 
> > > @@ -84,6 +62,27 @@ static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
> > >       rx->last_entry = dcb;
> > >  }
> > >
> > > +static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
> > > +{
> > > +     struct lan966x *lan966x = rx->lan966x;
> > > +     struct page_pool_params pp_params = {
> > > +             .order = rx->page_order,
> > > +             .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > > +             .pool_size = FDMA_DCB_MAX,
> > > +             .nid = NUMA_NO_NODE,
> > > +             .dev = lan966x->dev,
> > > +             .dma_dir = DMA_FROM_DEVICE,
> > > +             .offset = 0,
> > > +             .max_len = PAGE_SIZE << rx->page_order,
> > 
> > ::max_len's primary purpose is to save time on DMA syncs.
> > First of all, you can substract
> > `SKB_DATA_ALIGN(sizeof(struct skb_shared_info))`, your HW never
> > writes to those last couple hundred bytes.
> > But I suggest calculating ::max_len basing on your current MTU
> > value. Let's say you have 16k pages and MTU of 1500, that is a huge
> > difference (except your DMA is always coherent, but I assume that's
> > not the case).
> > 
> > In lan966x_fdma_change_mtu() you do:
> > 
> >         max_mtu = lan966x_fdma_get_max_mtu(lan966x);
> >         max_mtu += IFH_LEN_BYTES;
> >         max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> >         max_mtu += VLAN_HLEN * 2;
> > 
> > `lan966x_fdma_get_max_mtu(lan966x) + IFH_LEN_BYTES + VLAN_HLEN * 2`
> > (ie 1536 for the MTU of 1500) is your max_len value actually, given
> > that you don't reserve any headroom (which is unfortunate, but I
> > guess you're working on this already, since XDP requires
> > %XDP_PACKET_HEADROOM).
> 
> Thanks for the suggestion. I will try it.
> Regarding XDP_PACKET_HEADROOM, for the XDP_DROP, I didn't see it to be
> needed. Once the support for XDP_TX or XDP_REDIRECT is added, then yes I
> need to reserve also the headroom.

Correct, since you're disabling metadata support in
xdp_prepare_buff(), headroom is not needed for pass and drop
actions.

It's always good to have at least %NET_SKB_PAD headroom inside an
skb, so that networking stack won't perform excessive reallocations,
and your code currently misses that -- if I understand currently,
after converting hardware-specific header to an Ethernet header you
have 28 - 14 = 14 bytes of headroom, which sometimes can be not
enough for example for forwarding cases. It's not related to XDP,
but I would do that as a prerequisite patch for Tx/redirect, since
you'll be adding headroom support anyway :)

> 
> > 
> > > +     };
> > > +
> > > +     rx->page_pool = page_pool_create(&pp_params);
> > > +     if (IS_ERR(rx->page_pool))
> > > +             return PTR_ERR(rx->page_pool);

[...]

> > > --
> > > 2.38.0
> > 
> > Thanks,
> > Olek
> 
> -- 
> /Horatiu

Thanks,
Olek
