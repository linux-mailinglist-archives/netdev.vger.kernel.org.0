Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0398F6283CA
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiKNPXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKNPXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:23:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D5BAE6F;
        Mon, 14 Nov 2022 07:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668439426; x=1699975426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3YGz0WuDg8QLeQUTdAu+E2JCLUkYanLt0hZyxnC9k8=;
  b=fF1kAb9YMkrAq6mKBzj3j9ZYHgH9+GqDC0lNacBzOVBDCeMxlK+41HKV
   5MmKYpeApWHL95x2rUSluOL/agiSx+Ax/zHHIIrhOFGNybiRuh1QdUqrD
   cAoNWbjapNR400GemqBYcUJ70wg/vVY8GTuen+c4emInf2a2t6Op+LRaI
   ILLAcDrf29akXrwlEsTU+DMagIQLg4oTCjZKCNyIREUxSmaf4Vdm2I9si
   6DqUFsebhPvmAcBsjUbVxeJMvXTjmzX7pineWUgowm0izgLZ73wzfop7R
   IPIP3uXVWth4REryaGT1XCWUBs6PdJzh0XHjdRx/CAAddv+j1IapdiF0v
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="312001726"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="312001726"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:23:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="763521091"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="763521091"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 14 Nov 2022 07:23:42 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEFNeaI025737;
        Mon, 14 Nov 2022 15:23:41 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
Date:   Mon, 14 Nov 2022 16:23:27 +0100
Message-Id: <20221114152327.702592-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com> <20221114134542.697174-1-alexandr.lobakin@intel.com> <Y3JLz1niXbdVbRH9@lunn.ch> <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Mon, 14 Nov 2022 15:06:04 +0000

> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Monday, November 14, 2022 8:08 AM
> > To: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Shenwei Wang <shenwei.wang@nxp.com>; David S. Miller
> > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> > Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> > Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> > <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev;
> > kernel test robot <lkp@intel.com>
> > Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
> >
> > Caution: EXT Email
> >
> >> Drivers should never select PAGE_POOL_STATS. This Kconfig option was
> >> made to allow user to choose whether he wants stats or better
> >> performance on slower systems. It's pure user choice, if something
> >> doesn't build or link, it must be guarded with
> >> IS_ENABLED(CONFIG_PAGE_POOL_STATS).
> >
> > Given how simple the API is, and the stubs for when CONFIG_PAGE_POOL_STATS
> > is disabled, i doubt there is any need for the driver to do anything.
> >
> >>>     struct page_pool *page_pool;
> >>>     struct xdp_rxq_info xdp_rxq;
> >>> +   u32 stats[XDP_STATS_TOTAL];
> >>
> >> Still not convinced it is okay to deliberately provoke overflows here,
> >> maybe we need some more reviewers to help us agree on what is better?
> >
> > You will find that many embedded drivers only have 32 bit hardware stats and do
> > wrap around. And the hardware does not have atomic read and clear so you can
> > accumulate into a u64. The FEC is from the times of MIB 2 ifTable, which only
> > requires 32 bit counters. ifXtable is modern compared to the FEC.
> >
> > Software counters like this are a different matter. The overhead of a
> > u64 on a 32 bit system is probably in the noise, so i think there is strong
> > argument for using u64.
> 
> If it is required to support u64 counters, the code logic need to change to record 
> the counter locally per packet, and then update the counters for the fec instance
> when the napi receive loop is complete. In this way we can reduce the performance
> overhead.

That's how it is usually done in the drivers. You put u32 counters
on the stack, it's impossible to overflow them in just one NAPI poll
cycle. Then, after you're done with processing descriptors, you just
increment the 64-bit on-ring counters at once.

> 
> Thanks,
> Shenwei
> 
> >
> >        Andrew

Thanks,
Olek
