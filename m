Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C74474C69
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 21:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhLNUB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 15:01:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:45154 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhLNUB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 15:01:57 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mxDzc-0008RQ-Hd; Tue, 14 Dec 2021 21:01:44 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mxDzc-000ANW-4m; Tue, 14 Dec 2021 21:01:44 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix building error when using
 userspace pt_regs
To:     Pu Lehui <pulehui@huawei.com>, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211214135555.125348-1-pulehui@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9063be69-fbd9-c0a5-9271-c6d4281c71ef@iogearbox.net>
Date:   Tue, 14 Dec 2021 21:01:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211214135555.125348-1-pulehui@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26387/Tue Dec 14 10:33:30 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 2:55 PM, Pu Lehui wrote:
> When building bpf selftests on arm64, the following error will occur:
> 
> progs/loop2.c:20:7: error: incomplete definition of type 'struct
> user_pt_regs'
> 
> Some archs, like arm64 and riscv, use userspace pt_regs in
> bpf_tracing.h, which causes build failure when bpf prog use
> macro in bpf_tracing.h. So let's use vmlinux.h directly.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Looks like this lets CI fail, did you run the selftests also with vmtest.sh to
double check?

https://github.com/kernel-patches/bpf/runs/4521708490?check_suite_focus=true :

[...]
#189 verif_scale_loop6:FAIL
libbpf: prog 'trace_virtqueue_add_sgs': BPF program load failed: Argument list too long
libbpf: prog 'trace_virtqueue_add_sgs': -- BEGIN PROG LOAD LOG --
R1 type=ctx expected=fp
BPF program is too large. Processed 1000001 insn
verification time 12250995 usec
stack depth 88
processed 1000001 insns (limit 1000000) max_states_per_insn 107 total_states 21739 peak_states 2271 mark_read 6
-- END PROG LOAD LOG --
libbpf: failed to load program 'trace_virtqueue_add_sgs'
libbpf: failed to load object 'loop6.o'
scale_test:FAIL:expect_success unexpected error: -7 (errno 7)
Summary: 221/986 PASSED, 8 SKIPPED, 1 FAILED
[...]

Please take a look and fix in your patch, thanks!
