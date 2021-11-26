Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A1245F6DB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 23:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhKZWdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 17:33:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:44440 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243757AbhKZWbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 17:31:11 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqjgd-000AaT-NR; Fri, 26 Nov 2021 23:27:19 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqjgc-0003zq-Pf; Fri, 26 Nov 2021 23:27:18 +0100
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
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
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net> <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com> <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
Date:   Fri, 26 Nov 2021 23:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26365/Fri Nov 26 10:23:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/21 7:06 PM, Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 13:30:16 +0100 Toke Høiland-Jørgensen wrote:
>>>> TBH I wasn't following this thread too closely since I saw Daniel
>>>> nacked it already. I do prefer rtnl xstats, I'd just report them
>>>> in -s if they are non-zero. But doesn't sound like we have an agreement
>>>> whether they should exist or not.
>>>
>>> Right, just -s is fine, if we drop the per-channel approach.
>>
>> I agree that adding them to -s is fine (and that resolves my "no one
>> will find them" complain as well). If it crowds the output we could also
>> default to only output'ing a subset, and have the more detailed
>> statistics hidden behind a verbose switch (or even just in the JSON
>> output)?
>>
>>>> Can we think of an approach which would make cloudflare and cilium
>>>> happy? Feels like we're trying to make the slightly hypothetical
>>>> admin happy while ignoring objections of very real users.
>>>
>>> The initial idea was to only uniform the drivers. But in general
>>> you are right, 10 drivers having something doesn't mean it's
>>> something good.
>>
>> I don't think it's accurate to call the admin use case "hypothetical".
>> We're expending a significant effort explaining to people that XDP can
>> "eat" your packets, and not having any standard statistics makes this
>> way harder. We should absolutely cater to our "early adopters", but if
>> we want XDP to see wider adoption, making it "less weird" is critical!
> 
> Fair. In all honesty I said that hoping to push for a more flexible
> approach hidden entirely in BPF, and not involving driver changes.
> Assuming the XDP program has more fine grained stats we should be able
> to extract those instead of double-counting. Hence my vague "let's work
> with apps" comment.
> 
> For example to a person familiar with the workload it'd be useful to
> know if program returned XDP_DROP because of configured policy or
> failure to parse a packet. I don't think that sort distinction is
> achievable at the level of standard stats.

Agree on the additional context. How often have you looked at tc clsact
/dropped/ stats specifically when you debug a more complex BPF program
there?

   # tc -s qdisc show clsact dev foo
   qdisc clsact ffff: parent ffff:fff1
    Sent 6800 bytes 120 pkt (dropped 0, overlimits 0 requeues 0)
    backlog 0b 0p requeues 0

Similarly, XDP_PASS counters may be of limited use as well for same reason
(and I think we might not even have a tc counter equivalent for it).

> The information required by the admin is higher level. As you say the
> primary concern there is "how many packets did XDP eat".

Agree. Above said, for XDP_DROP I would see one use case where you compare
different drivers or bond vs no bond as we did in the past in [0] when
testing against a packet generator (although I don't see bond driver covered
in this series here yet where it aggregates the XDP stats from all bond slave
devs).

On a higher-level wrt "how many packets did XDP eat", it would make sense
to have the stats for successful XDP_{TX,REDIRECT} given these are out
of reach from a BPF prog PoV - we can only count there how many times we
returned with XDP_TX but not whether the pkt /successfully made it/.

In terms of error cases, could we just standardize all drivers on the behavior
of e.g. mlx5e_xdp_handle(), meaning, a failure from XDP_{TX,REDIRECT} will
hit the trace_xdp_exception() and then fallthrough to bump a drop counter
(same as we bump in XDP_DROP then). So the drop counter will account for
program drops but also driver-related drops.

At some later point the trace_xdp_exception() could be extended with an error
code that the driver would propagate (given some of them look quite similar
across drivers, fwiw), and then whoever wants to do further processing with
them can do so via bpftrace or other tooling.

So overall wrt this series: from the lrstats we'd be /dropping/ the pass,
tx_errors, redirect_errors, invalid, aborted counters. And we'd be /keeping/
bytes & packets counters that XDP sees, (driver-)successful tx & redirect
counters as well as drop counter. Also, XDP bytes & packets counters should
not be counted twice wrt ethtool stats.

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9e2ee5c7e7c35d195e2aa0692a7241d47a433d1e

Thanks,
Daniel
