Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9853E01A0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhHDNFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:05:52 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:53286 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbhHDNFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1628082340; x=1659618340;
  h=references:from:to:cc:in-reply-to:date:message-id:
   mime-version:subject;
  bh=6DQs4BJxZy5tiv1i8yLWpSEtKNltR4iXCeNhNIa5+Sg=;
  b=PKOfmbq0NUc2Ow3w4cMLlBqRjUCkVlPuPaYbjxINUybqSwRAibfU04Rp
   uyIkNlpiOxvBRQFzZzuyemTFVQDBWylZX459KTRqOSHU2/nPxpqD0rH5w
   STMEeeuzOiFsgIYcuXUEpLA1kNNuujODLA8pN0t0yJplZAK4zclxOY3/p
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,294,1620691200"; 
   d="scan'208";a="127110400"
Subject: Re: [PATCH net-next 07/21] ethernet, ena: convert to standard XDP stats
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 04 Aug 2021 13:05:28 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 0804AA0472;
        Wed,  4 Aug 2021 13:05:24 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.161.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 4 Aug 2021 13:05:04 +0000
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
 <20210803163641.3743-8-alexandr.lobakin@intel.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        "Michal Kubiak" <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Netanel Belgazal" <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "Guy Tzalik" <gtzalik@amazon.com>,
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
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "Vladyslav Tarasiuk" <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        "Petr Vorel" <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
In-Reply-To: <20210803163641.3743-8-alexandr.lobakin@intel.com>
Date:   Wed, 4 Aug 2021 16:04:59 +0300
Message-ID: <pj41zllf5hmkck.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.229]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexander Lobakin <alexandr.lobakin@intel.com> writes:

>
>
>
> Its 6 XDP per-channel counters align just fine with the standard
> stats.
> Drop them from the custom Ethtool statistics and expose to the
> standard stats infra instead.
>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 46 
>  ++++++++++++++++---
>  1 file changed, 40 insertions(+), 6 deletions(-)

Hi,
thanks for making this patch. I like the idea of splitting stats 
into a per-queue basis

>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c 
> b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index 851a198cec82..1b6563641575 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -90,12 +90,6 @@ static const struct ena_stats 
> ena_stats_rx_strings[] = {
>         ENA_STAT_RX_ENTRY(bad_req_id),
>         ENA_STAT_RX_ENTRY(empty_rx_ring),
>         ENA_STAT_RX_ENTRY(csum_unchecked),
> -       ENA_STAT_RX_ENTRY(xdp_aborted),
> -       ENA_STAT_RX_ENTRY(xdp_drop),
> -       ENA_STAT_RX_ENTRY(xdp_pass),
> -       ENA_STAT_RX_ENTRY(xdp_tx),
> -       ENA_STAT_RX_ENTRY(xdp_invalid),
> -       ENA_STAT_RX_ENTRY(xdp_redirect),
>

The ena_stats_rx_strings array is (indirectly) accessed through 
ena_get_stats() function which is used for both fetching ethtool 
stats and
for sharing the stats with the device in case of an error (through 
ena_dump_stats_ex() function).

The latter use is broken by removing the XDP specific stats from 
ena_stats_rx_strings array.

I can submit an adaptation for the new system later (similar to 
mlx5) if you prefer

thanks,
Shay

>  };
>
>  static const struct ena_stats ena_stats_ena_com_strings[] = {
> @@ -324,6 +318,44 @@ static void ena_get_ethtool_strings(struct 
> net_device *netdev,
>         }
>  }
>
> +static int ena_get_std_stats_channels(struct net_device 
> *netdev, u32 sset)
> +{
> +       const struct ena_adapter *adapter = netdev_priv(netdev);
> +
> +       switch (sset) {
> +       case ETH_SS_STATS_XDP:
> +               return adapter->num_io_queues;
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +}
> +
> +static void ena_get_xdp_stats(struct net_device *netdev,
> +                             struct ethtool_xdp_stats 
> *xdp_stats)
> +{
> +       const struct ena_adapter *adapter = netdev_priv(netdev);
> +       const struct u64_stats_sync *syncp;
> +       const struct ena_stats_rx *stats;
> +       struct ethtool_xdp_stats *iter;
> +       u32 i;
> +
...
>  {
> @@ -916,6 +948,8 @@ static const struct ethtool_ops 
> ena_ethtool_ops = {
>         .get_tunable            = ena_get_tunable,
>         .set_tunable            = ena_set_tunable,
>         .get_ts_info            = ethtool_op_get_ts_info,
> +       .get_std_stats_channels = ena_get_std_stats_channels,
> +       .get_xdp_stats          = ena_get_xdp_stats,
>  };
>
>  void ena_set_ethtool_ops(struct net_device *netdev)

