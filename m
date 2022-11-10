Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C33E624772
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiKJQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbiKJQsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:48:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8451DD6F;
        Thu, 10 Nov 2022 08:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668098874; x=1699634874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sLTSISWzUr5ww4UVTAKQbU1w81C51YBDl84qwQHSgtI=;
  b=GTJ5zzZVjI+YpVEU0Mjl7tKrdV5XH/5FWRPtRwePYYKvI07NWtU5bkTh
   7hdtcOSqrBbqlFKLR6TyRmr5/U5PTZZ3QVUCOgPQvllGneGhrr53nwVNz
   3mepKocRHqOq2JblspEse8wy39e92rgC9SSSg1xzpZLiYjZGW3275yiJd
   /aaa2LfuQxNjItHjlRS/2R+fa3sMrv8AyZl1w+P0qaOG/p1ARMf4QqG3e
   rlM9lFeiJaXPDfX04WG5zQD4NQQbxMCBafYp0jZb2AJKQJe4Rd47iYl2C
   EFwIU6w2QHIl5WUqCG0wGSBFMSIa1nY1JvJrpdzSGEeUaaESLk4Zu+By7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="310078421"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="310078421"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 08:46:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="882418907"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="882418907"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 10 Nov 2022 08:46:38 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AAGkbeC023491;
        Thu, 10 Nov 2022 16:46:37 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool statistics
Date:   Thu, 10 Nov 2022 17:43:21 +0100
Message-Id: <20221110164321.3534977-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com> <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com> <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Thu, 10 Nov 2022 13:29:56 +0000

> > -----Original Message-----
> > From: Paolo Abeni <pabeni@redhat.com>
> > Sent: Thursday, November 10, 2022 5:54 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>; David S. Miller
> > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> > Kicinski <kuba@kernel.org>
> > >       case ETH_SS_STATS:
> > > -             for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
> > > -                     memcpy(data + i * ETH_GSTRING_LEN,
> > > -                             fec_stats[i].name, ETH_GSTRING_LEN);
> > > +             for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
> > > +                     memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
> > > +                     data += ETH_GSTRING_LEN;
> > > +             }
> > > +             for (i = 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
> > > +                     memcpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
> > > +                     data += ETH_GSTRING_LEN;
> >
> > The above triggers a warning:
> >
> > In function 'fortify_memcpy_chk',
> >     inlined from 'fec_enet_get_strings'
> > at ../drivers/net/ethernet/freescale/fec_main.c:2788:4:
> > ../include/linux/fortify-string.h:413:25: warning: call to '__read_overflow2_field'
> > declared with attribute warning: detected read beyond size of field (2nd
> > parameter); maybe use struct_group()? [-Wattribute-warning]
> >   413 |                         __read_overflow2_field(q_size_field, size);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > I think you can address it changing fec_xdp_stat_strs definition to:
> >
> > static const char fec_xdp_stat_strs[XDP_STATS_TOTAL][ETH_GSTRING_LEN] =
> 
> That does a problem. How about just change the memcpy to strncpy?

Don't use a static char array, it would consume more memory than the
current code. Just replace memcpy()s with strscpy().

Why u32 for the stats tho? It will overflow sooner or later. "To
keep it simple and compatible" you can use u64_stats API :)

> 
> Regards,
> Shenwei
> 
> > { // ...
> >
> > Cheers,
> >
> > Paolo

Thanks,
Olek
