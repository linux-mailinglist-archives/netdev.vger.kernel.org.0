Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD1463BE7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbhK3Qik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:38:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:32903 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243583AbhK3Qii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 11:38:38 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="223482950"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="223482950"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 08:35:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="458897866"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2021 08:35:08 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AUGZ5mt017295;
        Tue, 30 Nov 2021 16:35:05 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
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
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP stats
Date:   Tue, 30 Nov 2021 17:34:54 +0100
Message-Id: <20211130163454.595897-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com> <20211130155612.594688-1-alexandr.lobakin@intel.com> <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 30 Nov 2021 08:12:07 -0800

> On Tue, 30 Nov 2021 16:56:12 +0100 Alexander Lobakin wrote:
> > 3. XDP and XSK ctrs separately or not.
> > 
> > My PoV is that those are two quite different worlds.
> > However, stats for actions on XSK really make a little sense since
> > 99% of time we have xskmap redirect. So I think it'd be fine to just
> > expand stats structure with xsk_{rx,tx}_{packets,bytes} and count
> > the rest (actions, errors) together with XDP.
> > 
> > 
> > Rest:
> >  - don't create a separate `ip` command and report under `-s`;
> >  - save some RTNL skb space by skipping zeroed counters.
> 
> Let me ruin this point of clarity for you. I think that stats should 
> be skipped when they are not collected (see ETHTOOL_STAT_NOT_SET).
> If messages get large user should use the GETSTATS call and avoid 
> the problem more effectively.

Well, it was Dave's thought here: [0]

> Another thought on this patch: with individual attributes you could save
> some overhead by not sending 0 counters to userspace. e.g., define a
> helper that does:

I know about ETHTOOL_STAT_NOT_SET, but RTNL xstats doesn't use this,
does it?
GETSTATS is another thing, and I'll use it, thanks.

> 
> > Also, regarding that I count all on the stack and then add to the
> > storage once in a polling cycle -- most drivers don't do that and
> > just increment the values in the storage directly, but this can be
> > less performant for frequently updated stats (or it's just my
> > embedded past).
> > Re u64 vs u64_stats_t -- the latter is more universal and
> > architecture-friendly, the former is used directly in most of the
> > drivers primarily because those drivers and the corresponding HW
> > are being run on 64-bit systems in the vast majority of cases, and
> > Ethtools stats themselves are not so critical to guard them with
> > anti-tearing. Anyways, local64_t is cheap on ARM64/x86_64 I guess?

[0] https://lore.kernel.org/netdev/a4602b15-25b1-c388-73b4-1f97f6f0e555@gmail.com/

Al
