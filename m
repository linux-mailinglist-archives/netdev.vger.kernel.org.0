Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF27645F70D
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 00:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241458AbhKZXGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 18:06:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:48638 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhKZXEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 18:04:48 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqkDP-000F4Y-20; Sat, 27 Nov 2021 00:01:11 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqkDN-0007l0-Uv; Sat, 27 Nov 2021 00:01:09 +0100
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
From:   Daniel Borkmann <daniel@iogearbox.net>
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
        Paolo Abeni <pabeni@redhat.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net> <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com> <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
Message-ID: <3c2fd51e-96c4-d500-bb4c-1972bb0fa3d6@iogearbox.net>
Date:   Sat, 27 Nov 2021 00:01:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26365/Fri Nov 26 10:23:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/21 11:27 PM, Daniel Borkmann wrote:
> On 11/26/21 7:06 PM, Jakub Kicinski wrote:
[...]
>> The information required by the admin is higher level. As you say the
>> primary concern there is "how many packets did XDP eat".
> 
> Agree. Above said, for XDP_DROP I would see one use case where you compare
> different drivers or bond vs no bond as we did in the past in [0] when
> testing against a packet generator (although I don't see bond driver covered
> in this series here yet where it aggregates the XDP stats from all bond slave
> devs).
> 
> On a higher-level wrt "how many packets did XDP eat", it would make sense
> to have the stats for successful XDP_{TX,REDIRECT} given these are out
> of reach from a BPF prog PoV - we can only count there how many times we
> returned with XDP_TX but not whether the pkt /successfully made it/.
> 
> In terms of error cases, could we just standardize all drivers on the behavior
> of e.g. mlx5e_xdp_handle(), meaning, a failure from XDP_{TX,REDIRECT} will
> hit the trace_xdp_exception() and then fallthrough to bump a drop counter
> (same as we bump in XDP_DROP then). So the drop counter will account for
> program drops but also driver-related drops.
> 
> At some later point the trace_xdp_exception() could be extended with an error
> code that the driver would propagate (given some of them look quite similar
> across drivers, fwiw), and then whoever wants to do further processing with
> them can do so via bpftrace or other tooling.

Just thinking out loud, one straight forward example we could start out with
that is also related to Paolo's series [1] ...

enum xdp_error {
	XDP_UNKNOWN,
	XDP_ACTION_INVALID,
	XDP_ACTION_UNSUPPORTED,
};

... and then bpf_warn_invalid_xdp_action() returns one of the latter two
which we pass to trace_xdp_exception(). Later there could be XDP_DRIVER_*
cases e.g. propagated from XDP_TX error exceptions.

         [...]
         default:
                 err = bpf_warn_invalid_xdp_action(act);
                 fallthrough;
         case XDP_ABORTED:
xdp_abort:
                 trace_xdp_exception(rq->netdev, prog, act, err);
                 fallthrough;
         case XDP_DROP:
                 lrstats->xdp_drop++;
                 break;
         }
         [...]

   [1] https://lore.kernel.org/netdev/cover.1637924200.git.pabeni@redhat.com/

> So overall wrt this series: from the lrstats we'd be /dropping/ the pass,
> tx_errors, redirect_errors, invalid, aborted counters. And we'd be /keeping/
> bytes & packets counters that XDP sees, (driver-)successful tx & redirect
> counters as well as drop counter. Also, XDP bytes & packets counters should
> not be counted twice wrt ethtool stats.
> 
>    [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9e2ee5c7e7c35d195e2aa0692a7241d47a433d1e
