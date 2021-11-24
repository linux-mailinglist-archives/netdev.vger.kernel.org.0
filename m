Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB4745B945
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbhKXLlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:41:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:37783 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237708AbhKXLly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 06:41:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="321495484"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="321495484"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 03:38:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="538598992"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 24 Nov 2021 03:38:34 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AOBcWOh027559;
        Wed, 24 Nov 2021 11:38:32 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Shay Agroskin" <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David Arinzon" <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        "Saeed Bishara" <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2 net-next 05/26] enetc: implement generic XDP stats callbacks
Date:   Wed, 24 Nov 2021 12:37:11 +0100
Message-Id: <20211124113711.165114-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123170920.wgactazyupm32yqu@skbuf>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com> <20211123163955.154512-6-alexandr.lobakin@intel.com> <20211123170920.wgactazyupm32yqu@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 23 Nov 2021 17:09:20 +0000

> On Tue, Nov 23, 2021 at 05:39:34PM +0100, Alexander Lobakin wrote:
> > Similarly to dpaa2, enetc stores 5 per-channel counters for XDP.
> > Add necessary callbacks to be able to access them using new generic
> > XDP stats infra.
> >
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!

> These counters can be dropped from ethtool, nobody depends on having
> them there.

Got it, thanks. I'll remove them in v3 or, in case v2 gets accepted,
will send a follow-up patch(es) for removing redundant Ethtool
stats.

> Side question: what does "nch" stand for?

"The number of channels". I was thinking of an intuitial, but short
term, as get_xdp_stats_channels is too long and breaks Tab aligment
of tons of net_device_ops across the tree.
It was "nqs" /number of queues/ previously, but we usually use term
"queue" referring to one-direction ring, in case of these stats and
XDP in general "queue pair" or simply "channel" is more correct.

Thanks,
Al
