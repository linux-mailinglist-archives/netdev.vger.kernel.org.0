Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18463450A6
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhCVUVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:21:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:45119 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhCVUUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:20:49 -0400
IronPort-SDR: wwiRac0TZeUkVbt3tKkbK8FD2nIQK8oPhfT8l++ilc1OxZinw1eBS0GL4jKqnXdwojd7sEBoVw
 Hu0wVXX9/t0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="170303783"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="170303783"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:20:48 -0700
IronPort-SDR: JwCBkwhyCgdwkd2s9CrzWUiRmXSbrCFSqgoUfCcmr3tTAw49BJ4WLBHa4ndun5T30B+qEtEffG
 cdd2GZ86I/dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="390611082"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 22 Mar 2021 13:20:41 -0700
Date:   Mon, 22 Mar 2021 21:10:06 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 bpf-next 13/17] veth: implement ethtool's
 get_channels() callback
Message-ID: <20210322201006.GB56104@ranger.igk.intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
 <20210311152910.56760-14-maciej.fijalkowski@intel.com>
 <CAJ8uoz0+Ofu32-QmX1mYka2f52ym=zG_OPyz3wto=pv-brOi-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz0+Ofu32-QmX1mYka2f52ym=zG_OPyz3wto=pv-brOi-w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:44:38AM +0100, Magnus Karlsson wrote:
> On Thu, Mar 11, 2021 at 4:43 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Libbpf's xsk part calls get_channels() API to retrieve the queue count
> > of the underlying driver so that XSKMAP is sized accordingly.
> >
> > Implement that in veth so multi queue scenarios can work properly.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/veth.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index aa1a66ad2ce5..efca3d45f5c2 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -218,6 +218,17 @@ static void veth_get_ethtool_stats(struct net_device *dev,
> >         }
> >  }
> >
> > +static void veth_get_channels(struct net_device *dev,
> > +                             struct ethtool_channels *channels)
> > +{
> > +       channels->tx_count = dev->real_num_tx_queues;
> > +       channels->rx_count = dev->real_num_rx_queues;
> > +       channels->max_tx = dev->real_num_tx_queues;
> > +       channels->max_rx = dev->real_num_rx_queues;
> > +       channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_rx_queues);
> > +       channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_rx_queues);
> 
> Copy and paste error in the above two lines. One of the min entries
> should be dev->real_num_tx_queues. Kind of pointless otherwise ;-).

Geez. Embarrassing :)

> 
> > +}
> > +
> >  static const struct ethtool_ops veth_ethtool_ops = {
> >         .get_drvinfo            = veth_get_drvinfo,
> >         .get_link               = ethtool_op_get_link,
> > @@ -226,6 +237,7 @@ static const struct ethtool_ops veth_ethtool_ops = {
> >         .get_ethtool_stats      = veth_get_ethtool_stats,
> >         .get_link_ksettings     = veth_get_link_ksettings,
> >         .get_ts_info            = ethtool_op_get_ts_info,
> > +       .get_channels           = veth_get_channels,
> >  };
> >
> >  /* general routines */
> > --
> > 2.20.1
> >
