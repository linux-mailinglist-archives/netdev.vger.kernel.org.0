Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68565463ABB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbhK3QAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:00:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:35902 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243120AbhK3QAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 11:00:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="299636567"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="299636567"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 07:56:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="540454492"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 30 Nov 2021 07:56:30 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AUFuRh0006481;
        Tue, 30 Nov 2021 15:56:27 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Date:   Tue, 30 Nov 2021 16:56:12 +0100
Message-Id: <20211130155612.594688-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Tue, 23 Nov 2021 17:39:29 +0100

Ok, open questions:

1. Channels vs queues vs global.

Jakub: no per-channel.
David (Ahern): it's worth it to separate as Rx/Tx.
Toke is fine with globals at the end I think?

My point was that for most of the systems we have 1:1 Rx:Tx
(usually num_online_cpus()), so asking drivers separately for
the number of RQs and then SQs would end up asking for the same
number twice.
But the main reason TBH was that most of the drivers store stats
on a per-channel basis and I didn't want them to regress in
functionality. I'm fine with reporting only netdev-wide if
everyone are.

In case if we keep per-channel: report per-channel only by request
and cumulative globals by default to not flood the output?

2. Count all errors as "drops" vs separately.

Daniel: account everything as drops, plus errors should be
reported as exceptions for tracing sub.
Jesper: we shouldn't mix drops and errors.

My point: we shouldn't, that's why there are patches for 2 drivers
to give errors a separate counter.
I provided an option either to report all errors together ('errors'
in stats structure) or to provide individual counters for each of
them (sonamed ctrs), but personally prefer detailed errors. However,
they might "go detailed" under trace_xdp_exception() only, sound
fine (OTOH in RTNL stats we have both "general" errors and detailed
error counters).

3. XDP and XSK ctrs separately or not.

My PoV is that those are two quite different worlds.
However, stats for actions on XSK really make a little sense since
99% of time we have xskmap redirect. So I think it'd be fine to just
expand stats structure with xsk_{rx,tx}_{packets,bytes} and count
the rest (actions, errors) together with XDP.


Rest:
 - don't create a separate `ip` command and report under `-s`;
 - save some RTNL skb space by skipping zeroed counters.

Also, regarding that I count all on the stack and then add to the
storage once in a polling cycle -- most drivers don't do that and
just increment the values in the storage directly, but this can be
less performant for frequently updated stats (or it's just my
embedded past).
Re u64 vs u64_stats_t -- the latter is more universal and
architecture-friendly, the former is used directly in most of the
drivers primarily because those drivers and the corresponding HW
are being run on 64-bit systems in the vast majority of cases, and
Ethtools stats themselves are not so critical to guard them with
anti-tearing. Anyways, local64_t is cheap on ARM64/x86_64 I guess?

Thanks,
Al
