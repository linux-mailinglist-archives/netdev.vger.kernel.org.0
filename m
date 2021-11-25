Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D8445DFAF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347486AbhKYRah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:30:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:37834 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242904AbhKYR2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:28:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="222770518"
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="222770518"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 09:17:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="509828399"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 25 Nov 2021 09:17:12 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1APHH9FD003210;
        Thu, 25 Nov 2021 17:17:09 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 07/26] mvneta: add .ndo_get_xdp_stats() callback
Date:   Thu, 25 Nov 2021 18:16:49 +0100
Message-Id: <20211125171649.127647-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <YZ4kWXnqZQhSu+mw@shell.armlinux.org.uk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com> <20211123163955.154512-8-alexandr.lobakin@intel.com> <YZ4kWXnqZQhSu+mw@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King (Oracle) <linux@armlinux.org.uk>
Date: Wed, 24 Nov 2021 11:39:05 +0000

> On Tue, Nov 23, 2021 at 05:39:36PM +0100, Alexander Lobakin wrote:
> > +	for_each_possible_cpu(cpu) {
> > +		const struct mvneta_pcpu_stats *stats;
> > +		const struct mvneta_stats *ps;
> > +		u64 xdp_xmit_err;
> > +		u64 xdp_redirect;
> > +		u64 xdp_tx_err;
> > +		u64 xdp_pass;
> > +		u64 xdp_drop;
> > +		u64 xdp_xmit;
> > +		u64 xdp_tx;
> > +		u32 start;
> > +
> > +		stats = per_cpu_ptr(pp->stats, cpu);
> > +		ps = &stats->es.ps;
> > +
> > +		do {
> > +			start = u64_stats_fetch_begin_irq(&stats->syncp);
> > +
> > +			xdp_drop = ps->xdp_drop;
> > +			xdp_pass = ps->xdp_pass;
> > +			xdp_redirect = ps->xdp_redirect;
> > +			xdp_tx = ps->xdp_tx;
> > +			xdp_tx_err = ps->xdp_tx_err;
> > +			xdp_xmit = ps->xdp_xmit;
> > +			xdp_xmit_err = ps->xdp_xmit_err;
> > +		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> > +
> > +		xdp_stats->drop += xdp_drop;
> > +		xdp_stats->pass += xdp_pass;
> > +		xdp_stats->redirect += xdp_redirect;
> > +		xdp_stats->tx += xdp_tx;
> > +		xdp_stats->tx_errors += xdp_tx_err;
> > +		xdp_stats->xmit_packets += xdp_xmit;
> > +		xdp_stats->xmit_errors += xdp_xmit_err;
> 
> Same comment as for mvpp2 - this could share a lot of code from
> mvneta_ethtool_update_pcpu_stats() (although it means we end up
> calculating a little more for the alloc error and refill error
> that this API doesn't need) but I think sharing that code would be
> a good idea.

Ah, I didn't do that because in my first series I was removing
Ethtool counters at all. In this one, I left them as-is due to
some of folks hinted me that those counters (not specifically
on mvpp2 or mvneta, let's say on virtio-net or so) could have
already been used in some admin scripts somewhere in the world
(but with a TODO to figure out which driver I could remove them
in and do that).
It would be great if you know and would hint me if I could remove
those XDP-related Ethtool counters from Marvell drivers or not.
If so, I'll wipe them, otherwise just factor out common parts to
wipe out code duplication.

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Thanks,
Al
