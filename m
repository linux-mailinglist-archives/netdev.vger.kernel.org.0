Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FC22193EF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgGHW6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:58:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:34048 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHW6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:58:40 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtJ1S-0000SC-LY; Thu, 09 Jul 2020 00:58:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtJ1S-000NfG-ET; Thu, 09 Jul 2020 00:58:38 +0200
Subject: Re: [PATCH bpf-next 0/6] Improve libbpf support of old kernels
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Matthew Lim <matthewlim@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7851cece-001e-40d2-a9b0-3689d4be2e5e@iogearbox.net>
Date:   Thu, 9 Jul 2020 00:58:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25867/Wed Jul  8 15:50:39 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 3:53 AM, Andrii Nakryiko wrote:
> This patch set improves libbpf's support of old kernels, missing features like
> BTF support, global variables support, etc.
> 
> Most critical one is a silent drop of CO-RE relocations if libbpf fails to
> load BTF (despite sanitization efforts). This is frequently the case for
> kernels that have no BTF support whatsoever. There are still useful BPF
> applications that could work on such kernels and do rely on CO-RE. To that
> end, this series revamps the way BTF is handled in libbpf. Failure to load BTF
> into kernel doesn't prevent libbpf from using BTF in its full capability
> (e.g., for CO-RE relocations) internally.
> 
> Another issue that was identified was reliance of perf_buffer__new() on
> BPF_OBJ_GET_INFO_BY_FD command, which is more recent that perf_buffer support
> itself. Furthermore, BPF_OBJ_GET_INFO_BY_FD is needed just for some sanity
> checks to provide better user errors, so could be safely omitted if kernel
> doesn't provide it.
> 
> Perf_buffer selftest was adjusted to use skeleton, instead of bpf_prog_load().
> The latter uses BPF_F_TEST_RND_HI32 flag, which is a relatively recent
> addition and unnecessary fails selftest in libbpf's Travis CI tests. By using
> skeleton we both get a shorter selftest and it work on pretty ancient kernels,
> giving better libbpf test coverage.
> 
> One new selftest was added that relies on basic CO-RE features, but otherwise
> doesn't expect any recent features (like global variables) from kernel. Again,
> it's good to have better coverage of old kernels in libbpf testing.
> 
> Cc: Matthew Lim <matthewlim@fb.com>
> 
> Andrii Nakryiko (6):
>    libbpf: make BTF finalization strict
>    libbpf: add btf__set_fd() for more control over loaded BTF FD
>    libbpf: improve BTF sanitization handling
>    selftests/bpf: add test relying only on CO-RE and no recent kernel
>      features
>    libbpf: handle missing BPF_OBJ_GET_INFO_BY_FD gracefully in
>      perf_buffer
>    selftests/bpf: switch perf_buffer test to tracepoint and skeleton
> 
>   tools/lib/bpf/btf.c                           |   7 +-
>   tools/lib/bpf/btf.h                           |   1 +
>   tools/lib/bpf/libbpf.c                        | 150 ++++++++++--------
>   tools/lib/bpf/libbpf.map                      |   1 +
>   .../selftests/bpf/prog_tests/core_retro.c     |  33 ++++
>   .../selftests/bpf/prog_tests/perf_buffer.c    |  42 ++---
>   .../selftests/bpf/progs/test_core_retro.c     |  30 ++++
>   .../selftests/bpf/progs/test_perf_buffer.c    |   4 +-
>   8 files changed, 167 insertions(+), 101 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/core_retro.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_core_retro.c
> 

Applied, thanks!
