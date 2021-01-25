Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049ED304AAA
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbhAZE77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:59:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:4706 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbhAYMmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 07:42:25 -0500
IronPort-SDR: upo2iEezrbsOqSXFQukqXk+q0pH/OQMsQ7zqTYNrDwfvim2JAYiMVef1Oujd9oMPH/P+q2hPPr
 cwZvduJgjnpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="177145414"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="177145414"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 04:37:29 -0800
IronPort-SDR: wZw4bW3WjKnu2fFH3hkaiu+PLe0dvYjc0jEnD3Stplg0mOgtq2xRmDX9r+Gu7pzWU3yikIypRN
 /JtD9dHSl/cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="387355317"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2021 04:37:26 -0800
Date:   Mon, 25 Jan 2021 13:27:24 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCHv16 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210125122724.GA18646@ranger.igk.intel.com>
References: <20210120022514.2862872-1-liuhangbin@gmail.com>
 <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210122074652.2981711-4-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122074652.2981711-4-liuhangbin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 03:46:49PM +0800, Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed
> before[0], The goal is to be able to implement an OVS-like data plane in
> XDP, i.e., a software switch that can forward XDP frames to multiple ports.
> 
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
> 
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because a
> physical interface can be part of a logical grouping, such as a bond
> device.
> 
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
> 
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. The forwarding
> map could be DEVMAP or DEVMAP_HASH, but the exclude map *must* be
> DEVMAP_HASH to get better performace. If user don't want to use exclude
> map and just want simply stop redirecting back to ingress device, they
> can use flag BPF_F_EXCLUDE_INGRESS.

Hangbin,

before you submit next revision, could you try to apply imperative mood to
your commit messages?

From Documentation/process/submitting-patches.rst:

<quote>
Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour.
</quote>

That's the thing I'm trying to remind people internally and it feels like
we keep on forgetting about that.

Thanks!

> 
> As both bpf_xdp_redirect_map() and this new helpers are using struct
> bpf_redirect_info, I add a new ex_map and set tgt_value to NULL in the
> new helper to make a difference with bpf_xdp_redirect_map().
> 
> Also I keep the general data path in net/core/filter.c, the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.
> 
> [0] https://xdp-project.net/#Handling-multicast
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
