Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEBF60D0A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfGEVPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:15:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:44052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfGEVPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:15:53 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjVYb-0008Qa-8J; Fri, 05 Jul 2019 23:15:49 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjVYb-000NNi-2X; Fri, 05 Jul 2019 23:15:49 +0200
Subject: Re: [PATCH v5 bpf-next 0/4] capture integers in BTF type info for map
 defs
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, ast@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20190705155012.3539722-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86f8f511-655c-bf9e-8d78-f2e3f65efdb9@iogearbox.net>
Date:   Fri, 5 Jul 2019 23:15:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190705155012.3539722-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2019 05:50 PM, Andrii Nakryiko wrote:
> This patch set implements an update to how BTF-defined maps are specified. The
> change is in how integer attributes, e.g., type, max_entries, map_flags, are
> specified: now they are captured as part of map definition struct's BTF type
> information (using array dimension), eliminating the need for compile-time
> data initialization and keeping all the metadata in one place.
> 
> All existing selftests that were using BTF-defined maps are updated, along
> with some other selftests, that were switched to new syntax.
> 
> v4->v5:
> - revert sample_map_ret0.c, which is loaded with iproute2 (kernel test robot);
> v3->v4:
> - add acks;
> - fix int -> uint type in commit message;
> v2->v3:
> - rename __int into __uint (Yonghong);
> v1->v2:
> - split bpf_helpers.h change from libbpf change (Song).
> 
> Andrii Nakryiko (4):
>   libbpf: capture value in BTF type info for BTF-defined map defs
>   selftests/bpf: add __uint and __type macro for BTF-defined maps
>   selftests/bpf: convert selftests using BTF-defined maps to new syntax
>   selftests/bpf: convert legacy BPF maps to BTF-defined ones
> 
>  tools/lib/bpf/libbpf.c                        |  58 +++++----
>  tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 ++---
>  .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
>  .../testing/selftests/bpf/progs/netcnt_prog.c |  20 ++--
>  tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
>  .../selftests/bpf/progs/socket_cookie_prog.c  |  13 +--
>  .../bpf/progs/sockmap_verdict_prog.c          |  48 ++++----
>  .../testing/selftests/bpf/progs/strobemeta.h  |  68 +++++------
>  .../selftests/bpf/progs/test_btf_newkv.c      |  13 +--
>  .../bpf/progs/test_get_stack_rawtp.c          |  39 +++----
>  .../selftests/bpf/progs/test_global_data.c    |  37 +++---
>  tools/testing/selftests/bpf/progs/test_l4lb.c |  65 ++++-------
>  .../selftests/bpf/progs/test_l4lb_noinline.c  |  65 ++++-------
>  .../selftests/bpf/progs/test_map_in_map.c     |  30 ++---
>  .../selftests/bpf/progs/test_map_lock.c       |  26 ++---
>  .../testing/selftests/bpf/progs/test_obj_id.c |  12 +-
>  .../bpf/progs/test_select_reuseport_kern.c    |  67 ++++-------
>  .../bpf/progs/test_send_signal_kern.c         |  26 ++---
>  .../bpf/progs/test_sock_fields_kern.c         |  78 +++++--------
>  .../selftests/bpf/progs/test_spin_lock.c      |  36 +++---
>  .../bpf/progs/test_stacktrace_build_id.c      |  55 ++++-----
>  .../selftests/bpf/progs/test_stacktrace_map.c |  52 +++------
>  .../selftests/bpf/progs/test_tcp_estats.c     |  13 +--
>  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  26 ++---
>  .../selftests/bpf/progs/test_tcpnotify_kern.c |  28 ++---
>  tools/testing/selftests/bpf/progs/test_xdp.c  |  26 ++---
>  .../selftests/bpf/progs/test_xdp_loop.c       |  26 ++---
>  .../selftests/bpf/progs/test_xdp_noinline.c   |  81 +++++--------
>  .../selftests/bpf/progs/xdp_redirect_map.c    |  12 +-
>  .../testing/selftests/bpf/progs/xdping_kern.c |  12 +-
>  .../selftests/bpf/test_queue_stack_map.h      |  30 ++---
>  .../testing/selftests/bpf/test_sockmap_kern.h | 110 +++++++++---------
>  33 files changed, 559 insertions(+), 760 deletions(-)

LGTM, applied, thanks! Shouldn't we also move __uint and __type macros
into libbpf as otherwise people tend to redefine this over and over?
