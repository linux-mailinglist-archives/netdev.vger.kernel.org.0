Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23625A7A7
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF1XdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:33:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:34138 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfF1XdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:33:09 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hh0Mc-0001Z2-Mt; Sat, 29 Jun 2019 01:33:06 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hh0Mc-0006o5-EN; Sat, 29 Jun 2019 01:33:06 +0200
Subject: Re: [PATCH bpf-next v6 0/5] xdp: Allow lookup into devmaps before
 redirect
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <56d5758b-fa9f-c727-1219-5e1318e34ce6@iogearbox.net>
Date:   Sat, 29 Jun 2019 01:33:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25494/Fri Jun 28 10:03:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/28/2019 11:12 AM, Toke Høiland-Jørgensen wrote:
> When using the bpf_redirect_map() helper to redirect packets from XDP, the eBPF
> program cannot currently know whether the redirect will succeed, which makes it
> impossible to gracefully handle errors. To properly fix this will probably
> require deeper changes to the way TX resources are allocated, but one thing that
> is fairly straight forward to fix is to allow lookups into devmaps, so programs
> can at least know when a redirect is *guaranteed* to fail because there is no
> entry in the map. Currently, programs work around this by keeping a shadow map
> of another type which indicates whether a map index is valid.
> 
> This series contains two changes that are complementary ways to fix this issue:
> 
> - Moving the map lookup into the bpf_redirect_map() helper (and caching the
>   result), so the helper can return an error if no value is found in the map.
>   This includes a refactoring of the devmap and cpumap code to not care about
>   the index on enqueue.
> 
> - Allowing regular lookups into devmaps from eBPF programs, using the read-only
>   flag to make sure they don't change the values.
> 
> The performance impact of the series is negligible, in the sense that I cannot
> measure it because the variance between test runs is higher than the difference
> pre/post series.
> 
> Changelog:
> 
> v6:
>   - Factor out list handling in maps to a helper in list.h (new patch 1)
>   - Rename variables in struct bpf_redirect_info (new patch 3 + patch 4)
>   - Explain why we are clearing out the map in the info struct on lookup failure
>   - Remove unneeded check for forwarding target in tracepoint macro
> 
> v5:
>   - Rebase on latest bpf-next.
>   - Update documentation for bpf_redirect_map() with the new meaning of flags.
> 
> v4:
>   - Fix a few nits from Andrii
>   - Lose the #defines in bpf.h and just compare the flags argument directly to
>     XDP_TX in bpf_xdp_redirect_map().
> 
> v3:
>   - Adopt Jonathan's idea of using the lower two bits of the flag value as the
>     return code.
>   - Always do the lookup, and cache the result for use in xdp_do_redirect(); to
>     achieve this, refactor the devmap and cpumap code to get rid the bitmap for
>     selecting which devices to flush.
> 
> v2:
>   - For patch 1, make it clear that the change works for any map type.
>   - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the return
>     value read-only.
> 
> ---
> 
> Toke Høiland-Jørgensen (5):
>       xskmap: Move non-standard list manipulation to helper
>       devmap/cpumap: Use flush list instead of bitmap
>       devmap: Rename ifindex member in bpf_redirect_info
>       bpf_xdp_redirect_map: Perform map lookup in eBPF helper
>       devmap: Allow map lookups from eBPF
> 
> 
>  include/linux/filter.h     |    3 +
>  include/linux/list.h       |   14 ++++++
>  include/trace/events/xdp.h |    5 +-
>  include/uapi/linux/bpf.h   |    7 ++-
>  kernel/bpf/cpumap.c        |  105 +++++++++++++++++++----------------------
>  kernel/bpf/devmap.c        |  112 ++++++++++++++++++++------------------------
>  kernel/bpf/verifier.c      |    7 +--
>  kernel/bpf/xskmap.c        |    3 -
>  net/core/filter.c          |   60 ++++++++++++------------
>  9 files changed, 157 insertions(+), 159 deletions(-)
> 

Applied, thanks!
