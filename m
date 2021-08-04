Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18063E041F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhHDPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:25:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:52776 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238994AbhHDPZ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 11:25:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299531340"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="299531340"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 08:25:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="585490624"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 04 Aug 2021 08:25:02 -0700
Received: from alobakin-mobl.ger.corp.intel.com (kswiecic-MOBL.ger.corp.intel.com [10.213.28.10])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 174FOvOo013258;
        Wed, 4 Aug 2021 16:24:57 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        "Michal Kubiak" <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Netanel Belgazal" <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        "Petr Vorel" <petr.vorel@gmail.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 07/21] ethernet, ena: convert to standard XDP stats
Date:   Wed,  4 Aug 2021 17:24:55 +0200
Message-Id: <20210804152455.173-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <pj41zllf5hmkck.fsf@u570694869fb251.ant.amazon.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com> <20210803163641.3743-8-alexandr.lobakin@intel.com> <pj41zllf5hmkck.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>
Date: Wed, 4 Aug 2021 16:04:59 +0300

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
> >
> >
> >
> > Its 6 XDP per-channel counters align just fine with the standard
> > stats.
> > Drop them from the custom Ethtool statistics and expose to the
> > standard stats infra instead.
> >
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> >  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 46 
> >  ++++++++++++++++---
> >  1 file changed, 40 insertions(+), 6 deletions(-)
> 
> Hi,
> thanks for making this patch. I like the idea of splitting stats 
> into a per-queue basis
> 
> >
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c 
> > b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > index 851a198cec82..1b6563641575 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > @@ -90,12 +90,6 @@ static const struct ena_stats 
> > ena_stats_rx_strings[] = {
> >         ENA_STAT_RX_ENTRY(bad_req_id),
> >         ENA_STAT_RX_ENTRY(empty_rx_ring),
> >         ENA_STAT_RX_ENTRY(csum_unchecked),
> > -       ENA_STAT_RX_ENTRY(xdp_aborted),
> > -       ENA_STAT_RX_ENTRY(xdp_drop),
> > -       ENA_STAT_RX_ENTRY(xdp_pass),
> > -       ENA_STAT_RX_ENTRY(xdp_tx),
> > -       ENA_STAT_RX_ENTRY(xdp_invalid),
> > -       ENA_STAT_RX_ENTRY(xdp_redirect),
> >
> 
> The ena_stats_rx_strings array is (indirectly) accessed through 
> ena_get_stats() function which is used for both fetching ethtool 
> stats and
> for sharing the stats with the device in case of an error (through 
> ena_dump_stats_ex() function).
> 
> The latter use is broken by removing the XDP specific stats from 
> ena_stats_rx_strings array.
> 
> I can submit an adaptation for the new system later (similar to 
> mlx5) if you prefer

Feel free to either do that (I'll exclude this patch from that
series then) or you can give me some little tips or examples or
anything on how to improve this one, so ena would stay converted.
Both ways are fine for me.

> thanks,
> Shay

Thanks,
Al

> >  };
> >
> >  static const struct ena_stats ena_stats_ena_com_strings[] = {
> > @@ -324,6 +318,44 @@ static void ena_get_ethtool_strings(struct 
> > net_device *netdev,
> >         }
> >  }
> >
> > +static int ena_get_std_stats_channels(struct net_device 
> > *netdev, u32 sset)
> > +{
> > +       const struct ena_adapter *adapter = netdev_priv(netdev);
> > +
> > +       switch (sset) {
> > +       case ETH_SS_STATS_XDP:
> > +               return adapter->num_io_queues;
> > +       default:
> > +               return -EOPNOTSUPP;
> > +       }
> > +}
> > +
> > +static void ena_get_xdp_stats(struct net_device *netdev,
> > +                             struct ethtool_xdp_stats 
> > *xdp_stats)
> > +{
> > +       const struct ena_adapter *adapter = netdev_priv(netdev);
> > +       const struct u64_stats_sync *syncp;
> > +       const struct ena_stats_rx *stats;
> > +       struct ethtool_xdp_stats *iter;
> > +       u32 i;
> > +
> ...
> >  {
> > @@ -916,6 +948,8 @@ static const struct ethtool_ops 
> > ena_ethtool_ops = {
> >         .get_tunable            = ena_get_tunable,
> >         .set_tunable            = ena_set_tunable,
> >         .get_ts_info            = ethtool_op_get_ts_info,
> > +       .get_std_stats_channels = ena_get_std_stats_channels,
> > +       .get_xdp_stats          = ena_get_xdp_stats,
> >  };
> >
> >  void ena_set_ethtool_ops(struct net_device *netdev)
> 
> 
