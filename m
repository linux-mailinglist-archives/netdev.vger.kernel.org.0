Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AEE255DD4
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgH1P12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:27:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:36308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgH1P1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:27:25 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBgHj-0001fb-A1; Fri, 28 Aug 2020 17:27:23 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBgHj-000NoF-4C; Fri, 28 Aug 2020 17:27:23 +0200
Subject: Re: [PATCH v3 bpf-next 0/3] bpf: Relax the max_entries check for
 inner map
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200828011800.1970018-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86ec022e-d533-d4d9-b95d-72f0880c9e63@iogearbox.net>
Date:   Fri, 28 Aug 2020 17:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200828011800.1970018-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 3:18 AM, Martin KaFai Lau wrote:
> v3:
> - Add map_meta_equal to bpf_map_ops and use it as an explict
>    opt-in support for map-in-map
>    
> v2:
> - New BPF_MAP_TYPE_FL to minimize code churns (Alexei)
> - s/capabilities/properties/ (Andrii)
> - Describe WHY in commit log (Andrii)
> 
> People has a use case that starts with a smaller inner map first and then
> replaces it with a larger inner map later when it is needed.
> 
> This series allows the outer map to be updated with inner map in different
> size as long as it is safe (meaning the max_entries is not used in the
> verification time during prog load).
> 
> Please see individual patch for details.
> 
> Martin KaFai Lau (3):
>    bpf: Add map_meta_equal map ops
>    bpf: Relax max_entries check for most of the inner map types
>    bpf: selftests: Add test for different inner map size
> 
>   include/linux/bpf.h                           | 16 +++++++++
>   kernel/bpf/arraymap.c                         | 16 +++++++++
>   kernel/bpf/bpf_inode_storage.c                |  1 +
>   kernel/bpf/cpumap.c                           |  1 +
>   kernel/bpf/devmap.c                           |  2 ++
>   kernel/bpf/hashtab.c                          |  4 +++
>   kernel/bpf/lpm_trie.c                         |  1 +
>   kernel/bpf/map_in_map.c                       | 24 +++++--------
>   kernel/bpf/map_in_map.h                       |  2 --
>   kernel/bpf/queue_stack_maps.c                 |  2 ++
>   kernel/bpf/reuseport_array.c                  |  1 +
>   kernel/bpf/ringbuf.c                          |  1 +
>   kernel/bpf/stackmap.c                         |  1 +
>   kernel/bpf/syscall.c                          |  1 +
>   net/core/bpf_sk_storage.c                     |  1 +
>   net/core/sock_map.c                           |  2 ++
>   net/xdp/xskmap.c                              |  8 +++++
>   .../selftests/bpf/prog_tests/btf_map_in_map.c | 35 ++++++++++++++++++-
>   .../selftests/bpf/progs/test_btf_map_in_map.c | 31 ++++++++++++++++
>   19 files changed, 132 insertions(+), 18 deletions(-)

Looks good to me, applied thanks!
