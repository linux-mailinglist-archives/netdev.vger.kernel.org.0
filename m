Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214321373A8
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgAJQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:30:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:56808 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgAJQaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:30:05 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipxAW-0006L3-Gj; Fri, 10 Jan 2020 17:29:57 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipxAW-000Fxw-8h; Fri, 10 Jan 2020 17:29:52 +0100
Subject: Re: [PATCH v3 bpf-next 0/6] bpf: Introduce global functions
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20200110064124.1760511-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ba36dd3-f9f0-a7c3-e9cf-88bc7c1dce88@iogearbox.net>
Date:   Fri, 10 Jan 2020 17:29:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200110064124.1760511-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25690/Fri Jan 10 11:02:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/20 7:41 AM, Alexei Starovoitov wrote:
> v2->v3:
> - cleaned up a check spotted by Song.
> - rebased and dropped patch 2 that was trying to improve BTF based on ELF.
> - added one more unit test for scalar return value from global func.
> 
> v1->v2:
> - addressed review comments from Song, Andrii, Yonghong
> - fixed memory leak in error path
> - added modified ctx check
> - added more tests in patch 7
> 
> v1:
> Introduce static vs global functions and function by function verification.
> This is another step toward dynamic re-linking (or replacement) of global
> functions. See patch 2 for details.
> 
> Alexei Starovoitov (6):
>    libbpf: Sanitize global functions
>    bpf: Introduce function-by-function verification
>    selftests/bpf: Add fexit-to-skb test for global funcs
>    selftests/bpf: Add a test for a large global function
>    selftests/bpf: Modify a test to check global functions
>    selftests/bpf: Add unit tests for global functions
> 
>   include/linux/bpf.h                           |   7 +-
>   include/linux/bpf_verifier.h                  |  10 +-
>   include/uapi/linux/btf.h                      |   6 +
>   kernel/bpf/btf.c                              | 175 +++++++++---
>   kernel/bpf/verifier.c                         | 252 ++++++++++++++----
>   tools/include/uapi/linux/btf.h                |   6 +
>   tools/lib/bpf/libbpf.c                        |  35 ++-
>   .../bpf/prog_tests/bpf_verif_scale.c          |   2 +
>   .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   1 +
>   .../bpf/prog_tests/test_global_funcs.c        |  82 ++++++
>   .../selftests/bpf/progs/fexit_bpf2bpf.c       |  15 ++
>   tools/testing/selftests/bpf/progs/pyperf.h    |   9 +-
>   .../selftests/bpf/progs/pyperf_global.c       |   5 +
>   .../selftests/bpf/progs/test_global_func1.c   |  45 ++++
>   .../selftests/bpf/progs/test_global_func2.c   |   4 +
>   .../selftests/bpf/progs/test_global_func3.c   |  65 +++++
>   .../selftests/bpf/progs/test_global_func4.c   |   4 +
>   .../selftests/bpf/progs/test_global_func5.c   |  31 +++
>   .../selftests/bpf/progs/test_global_func6.c   |  31 +++
>   .../selftests/bpf/progs/test_global_func7.c   |  18 ++
>   .../selftests/bpf/progs/test_pkt_access.c     |  28 ++
>   .../selftests/bpf/progs/test_xdp_noinline.c   |   4 +-
>   22 files changed, 746 insertions(+), 89 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
>   create mode 100644 tools/testing/selftests/bpf/progs/pyperf_global.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_global_func7.c
> 

Applied, thanks!
