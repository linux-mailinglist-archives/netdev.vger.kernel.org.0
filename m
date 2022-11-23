Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6739636191
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiKWOXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiKWOXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:23:03 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0CC1004F;
        Wed, 23 Nov 2022 06:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669213372; x=1700749372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ixa95dAdHlMX4D4FM87G4YI/hP0ckAp6HL/glipwILE=;
  b=eNRsZPCbQXuEedx4/V92H0L/U0ruZ9QD2nUbIe153JbVvL8h/1rGDEad
   IgFoDeSG013y+Rgk0CvjMpoGdfrXbG1VUFQGGnahcL+7dZlf4r2R3NWMy
   SlMZ/8OYBOipQbTBYHvs91Tc7HijXTedgDhy3mVdeKSKIrY8OMn7yNeo/
   lq7qnnZrDcI3sn7RcCQIiLjTbj/YfTRhszIUIMBLWjTFRWoUlzfFmzLN6
   yiDTHZX/l9JyNVXI7mmVVBMRKkwOA8SIRruLGwxcvjgO6iVLFVz8NNzUn
   LsF/OJ/9fgw0Ow9a5yEJiRx6ccbO4DcCqKzeGE9iVE6EaFb6FJzLQLid1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293782812"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293782812"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 06:22:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="710601733"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="710601733"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2022 06:22:49 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANEMlcc012150;
        Wed, 23 Nov 2022 14:22:47 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 7/7] net: lan966x: Add support for XDP_REDIRECT
Date:   Wed, 23 Nov 2022 15:22:41 +0100
Message-Id: <20221123142241.480973-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122213724.exqdhdxujvgtojxq@soft-dev3-1>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-8-horatiu.vultur@microchip.com> <20221122120430.419770-1-alexandr.lobakin@intel.com> <20221122213724.exqdhdxujvgtojxq@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
Date: Tue, 22 Nov 2022 22:37:24 +0100

> The 11/22/2022 13:04, Alexander Lobakin wrote:
> > 
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Date: Mon, 21 Nov 2022 22:28:50 +0100
> > 
> > > Extend lan966x XDP support with the action XDP_REDIRECT. This is similar
> > > with the XDP_TX, so a lot of functionality can be reused.
> > >
> > > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > > ---
> > >  .../ethernet/microchip/lan966x/lan966x_fdma.c | 83 +++++++++++++++----
> > >  .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
> > >  .../ethernet/microchip/lan966x/lan966x_main.h | 10 ++-
> > >  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 31 ++++++-
> > >  4 files changed, 109 insertions(+), 16 deletions(-)

[...]

> > I suggest carefully inspecting this struct with pahole (or by just
> > printkaying its layout/sizes/offsets at runtime) and see if there's
> > any holes and how it could be optimized.
> > Also, it's just my personal preference, but it's not that unpopular:
> > I don't trust bools inside structures as they may surprise with
> > their sizes or alignment depending on the architercture. Considering
> > all the blah I wrote, I'd define it as:
> > 
> > struct lan966x_tx_dcb_buf {
> >         dma_addr_t dma_addr;            // can be 8 bytes on 32-bit plat
> >         struct net_device *dev;         // ensure natural alignment
> >         struct sk_buff *skb;
> >         struct xdp_frame *xdpf;
> >         u32 len;
> >         u32 xdp_ndo:1;                  // put all your booleans here in
> >         u32 used:1;                     // one u32
> >         ...
> > };
> 
> Thanks for the suggestion. I make sure not that this struct will not
> have any holes.
> Can it be a rule of thumb, that every time when a new member is added to
> a struct, to make sure that it doesn't introduce any holes?

Yass, it's always good to do a quick check each time you're making
changes in a structure. This can prevent not only from excessive
memory usage, but most important from performance hits when some
hot field gets pushed out of the cacheline the field was in
previously.
Minimizing holes and using `u32 :1` vs `bool` for flags is more of
my personal preference, but it's kinda backed by experience, so I
treat it as something worth sharing :D

> 
> > 
> > BTW, we usually do union { skb, xdpf } since they're mutually
> > exclusive. And to distinguish between XDP and regular Tx you can use
> > one more bit/bool. This can also come handy later when you add XSk
> > support (you will be adding it, right? Please :P).
> 
> I think I will take this battle at later point when I will add XSK :)
> After I finish with this patch series, I will need to focus on some VCAP
> support for lan966x.

Sure!

> And maybe after that I will be able to add XSK. Because I need to look
> more at this XSK topic as I have looked too much on it before but I heard
> a lot of great things about it :)

Depends on the real usecases of the hardware. But always good to see
more drivers supporting it :>

> 
> > 
> > >       int len;
> > >       dma_addr_t dma_addr;
> > >       bool used;
> > 
> > [...]
> > 
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
