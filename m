Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C089F620EFC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiKHLZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiKHLZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:25:00 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2653207A;
        Tue,  8 Nov 2022 03:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667906700; x=1699442700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bZWtWPh8AjDaSa0OzVSrWb7bd/MpGa9wkljck/k+riw=;
  b=YOobgmPx3OSwZmIIbOP8gI+zi33HhP62I+Y1qguvqL7FfV0WQdRDhxsL
   y0kY4PpmkScML6YRfd2XI/PFSBzfREHm9Etpjt5lz+67iYQc6vcurTaEq
   PNSuM+18uJGkwQ1ziv1oMCjyHrgN6GSIEQ15jr34skLW79RMFwvGbOvbq
   X6A7nrhdm1PFK1od619gkz5pW10PLaZ1oLCuMasgHVIyyuH2nmUmqQ4Ik
   4UyX1FWHkTqHv1wRhseLfX83kEdZlGeGu5V+1VAWGPLVfIXR7fmnmPmCl
   hT2XbkUZPfq78bhEos81/j9DO0VRBFuAHYMEn7ytwqLUZj5OYJgT3PpX7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="294040903"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="294040903"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 03:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965555581"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="965555581"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 08 Nov 2022 03:24:56 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A8BOsMT010189;
        Tue, 8 Nov 2022 11:24:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 2/4] net: lan966x: Split function lan966x_fdma_rx_get_frame
Date:   Tue,  8 Nov 2022 12:21:46 +0100
Message-Id: <20221108112146.605140-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107212415.pwkdyyrdlbndb7ob@soft-dev3-1>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-3-horatiu.vultur@microchip.com> <20221107160656.556195-1-alexandr.lobakin@intel.com> <20221107212415.pwkdyyrdlbndb7ob@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 7 Nov 2022 22:24:15 +0100

> The 11/07/2022 17:06, Alexander Lobakin wrote:
> 
> Hi Olek,

Hey,

> 
> > 
> > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > Date: Sun, 6 Nov 2022 22:11:52 +0100
> > 
> > > The function lan966x_fdma_rx_get_frame was unmapping the frame from
> > > device and check also if the frame was received on a valid port. And
> > > only after that it tried to generate the skb.
> > > Move this check in a different function, in preparation for xdp
> > > support. Such that xdp to be added here and the
> > > lan966x_fdma_rx_get_frame to be used only when giving the skb to upper
> > > layers.

[...]

> > > +     lan966x_ifh_get_src_port(page_address(page), src_port);
> > > +     if (WARN_ON(*src_port >= lan966x->num_phys_ports))
> > > +             return FDMA_ERROR;
> > > +
> > > +     return FDMA_PASS;
> > 
> > How about making this function return s64, which would be "src_port
> > or negative error", and dropping the second argument @src_port (the
> > example of calling it below)?
> 
> That was also my first thought.
> But the thing is, I am also adding FDMA_DROP in the next patch of this
> series(3/4). And I am planning to add also FDMA_TX and FDMA_REDIRECT in
> a next patch series.

Yeah, I was reviewing the patches one by one and found out you're
adding more return values later :S

> Should they(FDMA_DROP, FDMA_TX, FDMA_REDIRECT) also be some negative
> numbers? And then have something like you proposed belowed:
> ---
> src_port = lan966x_fdma_rx_check_frame(rx);
> if (unlikely(src_port < 0)) {
> 
>         switch(src_port) {
>         case FDMA_ERROR:
>              ...
>              goto allocate_new
>         case FDMA_DROP:
>              ...
>              continue;
>         case FDMA_TX:
>         case FDMA_REDIRECT:
>         }

It's okay to make them negative, but I wouldn't place them under
`unlikely`. It could be something like:

	src_port = lan966x_fdma_rx_check_frame(rx);
	if (unlikely(src_port == FDMA_ERROR))
		goto allocate_new;

	switch (src_port) {
	case 0 ... S64_MAX:
		// do PASS;
		break;
	case FDMA_TX:
		// do TX;
		break;
	case FDMA_REDIRECT:
	// and so on
	}

where

enum {
	FDMA_ERROR = -1, // only this one is "unlikely"
	FDMA_TX = -2,
	...
};

It's all just personal taste, so up to you :) Making
rx_check_frame() writing src_port to a pointer is fine as well.

> }
> ---
> 
> > 
> > > +}
> > > +
> > > +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
> > > +                                              u64 src_port)
> > > +{

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
