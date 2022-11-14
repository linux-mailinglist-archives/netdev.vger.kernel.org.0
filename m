Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7379D62816A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiKNNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiKNNfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:35:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20724DE87;
        Mon, 14 Nov 2022 05:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668432909; x=1699968909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AerKXFsYG0MC60H6jSoivKzof9tjMF6SohiFF0KBOm0=;
  b=GzYQCFu/T9hLNOvc7a6jCfgA3eUHJGrBAFjbx+WUZ450htRjKUbmz5oN
   XZfXw73dNCBQ2rDOfBImzUPSc5F3me6h8pq+a9cgE6f2CLXALgufbXkw3
   whdNfvzwlc+NQ/AfdAMzTzdRsbXkbsPBXybxqJ70TodMp+iPk0W331cS9
   fFwsXeTUu23SmWU6bi897JAYyH2zxjx37s4kIRvA4tRekmXI8838Z5l4s
   kIpW+SlrwGnep/GEqfiAneLH3Xb5yv+v3hm3Vu3w8moudKD1iHnHAUaM1
   8YXi+4pMkFjFIXn3+KEcdw4Q5rLpyKophc64q+eetO0o2ZY/3FqznJ3sz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="291683980"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="291683980"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:35:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638477165"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="638477165"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2022 05:35:05 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEDZ4LW004280;
        Mon, 14 Nov 2022 13:35:04 GMT
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
Date:   Mon, 14 Nov 2022 14:35:02 +0100
Message-Id: <20221114133502.696740-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <PAXPR04MB9185CDDD50250DFE5E492C7189019@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com> <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com> <PAXPR04MB91853A6A1DDDBB06F33C975E89019@PAXPR04MB9185.eurprd04.prod.outlook.com> <20221110164321.3534977-1-alexandr.lobakin@intel.com> <PAXPR04MB9185CDDD50250DFE5E492C7189019@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Thu, 10 Nov 2022 21:40:21 +0000

> > -----Original Message-----
> > From: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Sent: Thursday, November 10, 2022 10:43 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Paolo Abeni
> > <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Alexei
> > > > at ../drivers/net/ethernet/freescale/fec_main.c:2788:4:
> > > > ../include/linux/fortify-string.h:413:25: warning: call to
> > '__read_overflow2_field'
> > > > declared with attribute warning: detected read beyond size of field
> > > > (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
> > > >   413 |                         __read_overflow2_field(q_size_field, size);
> > > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >
> > > > I think you can address it changing fec_xdp_stat_strs definition to:
> > > >
> > > > static const char
> > > > fec_xdp_stat_strs[XDP_STATS_TOTAL][ETH_GSTRING_LEN] =
> > >
> > > That does a problem. How about just change the memcpy to strncpy?
> > 
> > Don't use a static char array, it would consume more memory than the current
> > code. Just replace memcpy()s with strscpy().
> > 
> > Why u32 for the stats tho? It will overflow sooner or later. "To keep it simple
> > and compatible" you can use u64_stats API :)
> 
> The reason to use u32 here is : 1. It is simple to implement. 2. To follow the same
> behavior as the other MAC hardware statistic counters which are all 32bit. 3. I did
> investigate the u64_stats API, and think it is still a little expensive here.

1) u64_stats_t is not much harder.
2) This only means your HW statistics handling in the driver is
   wrong, as every driver which HW has 32-bit counter implements
   64-bit containers and a periodic task to take fresh HW numbers
   and clear them (so that the full stats are stored in the driver
   only).
3) Page Pool stats currently give you much more overhead as they are
   pure 64-bit, not u64_stats_t, with no synchronization.
   What is your machine and how fast your link is? Just curious, I
   never had any serious regressions using u64_stats_t on either
   high-end x86_64 servers or low-end MIPS32.

> 
> Thanks,
> Shenwei
> 
> > 
> > >
> > > Regards,
> > > Shenwei
> > >
> > > > { // ...
> > > >
> > > > Cheers,
> > > >
> > > > Paolo
> > 
> > Thanks,
> > Olek

Thanks,
Olek
