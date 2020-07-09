Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52C221AAA7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgGIWiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:38:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:38580 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgGIWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:38:04 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtfB3-0000gU-FI; Fri, 10 Jul 2020 00:38:01 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtfB3-000C3M-6s; Fri, 10 Jul 2020 00:38:01 +0200
Subject: Re: [PATCHv6 bpf-next 0/3] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7c80ca4b-4c7d-0322-9483-f6f0465d6370@iogearbox.net>
Date:   Fri, 10 Jul 2020 00:37:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709013008.3900892-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 3:30 AM, Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed before[0],
> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
> a software switch that can forward XDP frames to multiple ports.
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

Could you move this description as part of patch 1/3 instead of cover
letter? Mostly given this helps understanding the rationale wrt exclusion
map which is otherwise lacking from just looking at the patch itself.

Assuming you have a bond, how does this look in practice for your mentioned
ovs-like data plane in XDP? The map for 'group A' is shared among all XDP
progs and the map for 'group B' is managed per prog? The BPF_F_EXCLUDE_INGRESS
is clear, but how would this look wrt forwarding from a phys dev /to/ the
bond iface w/ XDP?

Also, what about tc BPF helper support for the case where not every device
might have native XDP (but they could still share the maps)?

> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. If user
> don't want to use exclude map and just want simply stop redirecting back
> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
> 
> The 2nd and 3rd patches are for usage sample and testing purpose, so there
> is no effort has been made on performance optimisation. I did same tests
> with pktgen(pkt size 64) to compire with xdp_redirect_map(). Here is the
> test result(the veth peer has a dummy xdp program with XDP_DROP directly):
> 
> Version         | Test                                   | Native | Generic
> 5.8 rc1         | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> 5.8 rc1         | xdp_redirect_map       i40e->veth      |  12.7M |   1.6M
> 5.8 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.0M |   1.9M
> 5.8 rc1 + patch | xdp_redirect_map       i40e->veth      |  12.3M |   1.6M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   7.2M |   1.5M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->veth      |   8.5M |   1.3M
> 5.8 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.0M |  0.98M
> 
> The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
> the arrays and do clone skb/xdpf. The native path is slower than generic
> path as we send skbs by pktgen. So the result looks reasonable.
> 
> Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
> suggestions and help on implementation.
> 
> [0] https://xdp-project.net/#Handling-multicast
> 
> v6: converted helper return types from int to long
> 
> v5:
> a) Check devmap_get_next_key() return value.
> b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
> c) In function dev_map_enqueue_multi(), consume xdpf for the last
>     obj instead of the first on.
> d) Update helper description and code comments to explain that we
>     use NULL target value to distinguish multicast and unicast
>     forwarding.
> e) Update memory model, memory id and frame_sz in xdpf_clone().
> f) Split the tests from sample and add a bpf kernel selftest patch.
> 
> v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo
> 
> v3: Based on Toke's suggestion, do the following update
> a) Update bpf_redirect_map_multi() description in bpf.h.
> b) Fix exclude_ifindex checking order in dev_in_exclude_map().
> c) Fix one more xdpf clone in dev_map_enqueue_multi().
> d) Go find next one in dev_map_enqueue_multi() if the interface is not
>     able to forward instead of abort the whole loop.
> e) Remove READ_ONCE/WRITE_ONCE for ex_map.
> 
> v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
> include/exclude maps directly.
> 
> Hangbin Liu (3):
>    xdp: add a new helper for dev map multicast support
>    sample/bpf: add xdp_redirect_map_multicast test
>    selftests/bpf: add xdp_redirect_multi test
> 
>   include/linux/bpf.h                           |  20 ++
>   include/linux/filter.h                        |   1 +
>   include/net/xdp.h                             |   1 +
>   include/uapi/linux/bpf.h                      |  22 +++
>   kernel/bpf/devmap.c                           | 154 ++++++++++++++++
>   kernel/bpf/verifier.c                         |   6 +
>   net/core/filter.c                             | 109 ++++++++++-
>   net/core/xdp.c                                |  29 +++
>   samples/bpf/Makefile                          |   3 +
>   samples/bpf/xdp_redirect_map_multi_kern.c     |  57 ++++++
>   samples/bpf/xdp_redirect_map_multi_user.c     | 166 +++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  22 +++
>   tools/testing/selftests/bpf/Makefile          |   4 +-
>   .../bpf/progs/xdp_redirect_multi_kern.c       |  90 +++++++++
>   .../selftests/bpf/test_xdp_redirect_multi.sh  | 164 +++++++++++++++++
>   .../selftests/bpf/xdp_redirect_multi.c        | 173 ++++++++++++++++++
>   16 files changed, 1015 insertions(+), 6 deletions(-)
>   create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
>   create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
>   create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
>   create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c
> 

