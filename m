Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4154157CB12
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiGUNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiGUNBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:01:08 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18DEF6A;
        Thu, 21 Jul 2022 06:01:06 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oEVnW-0000Ad-8A; Thu, 21 Jul 2022 15:00:58 +0200
Received: from [2a01:118f:505:3400:57f9:d43a:5622:24a8] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oEVnV-000UrP-QQ; Thu, 21 Jul 2022 15:00:57 +0200
Subject: Re: [PATCH bpf-next 0/4] destructive bpf kfuncs (was: bpf_panic)
To:     Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
References: <20220720114652.3020467-1-asavkov@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d6a19eb9-92ca-eeda-ff72-8f9250d754b8@iogearbox.net>
Date:   Thu, 21 Jul 2022 15:00:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220720114652.3020467-1-asavkov@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26608/Thu Jul 21 09:57:36 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/22 1:46 PM, Artem Savkov wrote:
> eBPF is often used for kernel debugging, and one of the widely used and
> powerful debugging techniques is post-mortem debugging with a full memory dump.
> Triggering a panic at exactly the right moment allows the user to get such a
> dump and thus a better view at the system's state. Right now the only way to
> do this in BPF is to signal userspace to trigger kexec/panic. This is
> suboptimal as going through userspace requires context changes and adds
> significant delays taking system further away from "the right moment". On a
> single-cpu system the situation is even worse because BPF program won't even be
> able to block the thread of interest.
> 
> This patchset tries to solve this problem by allowing properly marked tracing
> bpf programs to call crash_kexec() kernel function.
> 
> This is a continuation of bpf_panic patchset with initial feedback taken into
> account.
> 
> Changes from RFC:
>   - sysctl knob dropped
>   - using crash_kexec() instead of panic()
>   - using kfuncs instead of adding a new helper
> 
> Artem Savkov (4):
>    bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
>    bpf: add destructive kfunc set
>    selftests/bpf: add destructive kfunc tests
>    bpf: export crash_kexec() as destructive kfunc

First and second patch ccould be folded together into one. The selftest
should be last in series so that if people bisect the test won't fail due
to missing functionality. First one also has a stale comment wrt bpf_panic()
helper.

>   include/linux/bpf.h                           |  1 +
>   include/linux/btf.h                           |  2 +
>   include/uapi/linux/bpf.h                      |  6 +++
>   kernel/bpf/syscall.c                          |  4 +-
>   kernel/bpf/verifier.c                         | 12 ++++++
>   kernel/kexec_core.c                           | 22 ++++++++++
>   net/bpf/test_run.c                            | 12 +++++-
>   tools/include/uapi/linux/bpf.h                |  6 +++
>   .../selftests/bpf/prog_tests/kfunc_call.c     | 41 +++++++++++++++++++
>   .../bpf/progs/kfunc_call_destructive.c        | 14 +++++++
>   10 files changed, 118 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
> 

