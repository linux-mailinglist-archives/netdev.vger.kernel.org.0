Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAB862C0FF
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 15:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiKPOeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 09:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiKPOeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 09:34:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B895C2195;
        Wed, 16 Nov 2022 06:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668609255; x=1700145255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=38d+7I+PSJp7fiCJLjk7YV/W8ID1c2SPGRtRx9IT9ps=;
  b=Fq6YNR41kx0B2Le8GnVioeLLxI1LL8AZZrJmOOmbriWlPWNs5hbK9MF5
   C9GcuwYBV4u/09WdfVJ5YnSSBRnwpuoIhhw3CfEckoY/l+PiBYMxr1Vew
   EGbbLNMlejQYuFJnPgKLjMXAnyQzlTm5bt7YEoB+40D8azczMgVAyuBo8
   dXAcpKTZAbwfdoiDMipuPmzvyoiAgoCtqLCHJw4wSC29gIBfZ80EenDCp
   WsRwyyEXj1NateCBllirL9QSjhL2mllixmOrWMOWZRERAe9p83S2Qixjl
   1w3h7dpeQbfy0YhSuprEneIz3Xz2v+c/3xiqxEI5mGab6x0nf0hN9IO1U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="313706180"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="313706180"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 06:34:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="670519005"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="670519005"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 16 Nov 2022 06:34:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGEYAhv017898;
        Wed, 16 Nov 2022 14:34:10 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
Date:   Wed, 16 Nov 2022 15:33:36 +0100
Message-Id: <20221116143336.3385874-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com> <20221114134542.697174-1-alexandr.lobakin@intel.com> <Y3JLz1niXbdVbRH9@lunn.ch> <PAXPR04MB91853D935E363E8A7E3ED7BF89059@PAXPR04MB9185.eurprd04.prod.outlook.com> <20221114152327.702592-1-alexandr.lobakin@intel.com> <PAXPR04MB918589D35F8B10307D4D430E89059@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Mon, 14 Nov 2022 21:17:48 +0000

> > -----Original Message-----
> > From: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Sent: Monday, November 14, 2022 9:23 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; Andrew Lunn
> > <andrew@lunn.ch>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> > Fastabend <john.fastabend@gmail.com>; Wei Fang <wei.fang@nxp.com>;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; imx@lists.linux.dev;
> > kernel test robot <lkp@intel.com>
> > Subject: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics

[...]

> Did some testing with the atomic64_t counter, with the following codes to update
> the u64 counter in the end of every NAPI poll cycle.
> 
> @@ -1764,7 +1768,13 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  
>         if (xdp_result & FEC_ENET_XDP_REDIR)
>                 xdp_do_flush_map();
> +#if 1
> +       if (xdp_prog) {
> +               int i;
> +               for(i = 0; i < XDP_STATS_TOTAL; i++)
> +                       atomic64_add(xdp_stats[i], &rxq->stats[i]);
> +       }
> +#endif
>         return pkt_received;
>  }
> 
> With the codes above, the testing result is below:
> root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
>  sock0@eth0:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 349399         1035008
> tx                 0              0
> 
>  sock0@eth0:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 349407         1384640
> tx                 0              0
> 
> Without  the atomic_add codes above, the testing result is below:
> root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
>  sock0@eth0:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 350109         1989130
> tx                 0              0
> 
>  sock0@eth0:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 350425         2339786
> tx                 0              0
> 
> And regarding the u32 counter solution, the testing result is below:
>    root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
>      sock0@eth0:0 rxdrop xdp-drv
>                        pps            pkts           1.00
>     rx                 361347         2637796
>     tx                 0              0
> 
> There are about 10K pkts/s difference here. Do we really want the u64 counters?

Where did those atomic64_t come from? u64_stats_t use either plain
u64 for 32-bit platforms or local64_t for 64-bit ones. Take a look
at [0] for the example of how x86_64 does this, it is far from
atomic64_t.

> 
> Regards,
> Shenwei
> 
> >>
> >> Thanks,
> >> Shenwei
> >>
> >>>
> >>>        Andrew
> >
> > Thanks,
> > Olek

[0] https://elixir.bootlin.com/linux/v6.1-rc5/source/arch/x86/include/asm/local.h#L31

Thanks,
Olek
