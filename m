Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2FC403650
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350654AbhIHItW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 04:49:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:57512 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351110AbhIHItS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 04:49:18 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mNtEj-0000Bf-62; Wed, 08 Sep 2021 10:47:17 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mNtEi-000Wu5-Jx; Wed, 08 Sep 2021 10:47:16 +0200
Subject: Re: [RFC PATCH bpf-next] bpf: Make actual max tail call count as
 MAX_TAIL_CALL_CNT
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Paul Chaignon <paul@cilium.io>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
References: <1631089206-5931-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e05e7407-74bb-3ba3-aab7-f62ca16a59ba@iogearbox.net>
Date:   Wed, 8 Sep 2021 10:47:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1631089206-5931-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26287/Tue Sep  7 10:26:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ You have a huge Cc list, but forgot to add Paul and Johan who recently
   looked into this. Added here. ]

On 9/8/21 10:20 AM, Tiezhu Yang wrote:
> In the current code, the actual max tail call count is 33 which is greater
> than MAX_TAIL_CALL_CNT, this is not consistent with the intended meaning
> in the commit 04fd61ab36ec ("bpf: allow bpf programs to tail-call other
> bpf programs"):
> 
> "The chain of tail calls can form unpredictable dynamic loops therefore
> tail_call_cnt is used to limit the number of calls and currently is set
> to 32."
> 
> Additionally, after commit 874be05f525e ("bpf, tests: Add tail call test
> suite"), we can see there exists failed testcase.
> 
> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>   # echo 0 > /proc/sys/net/core/bpf_jit_enable
>   # modprobe test_bpf
>   # dmesg | grep -w FAIL
>   Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
> 
> On some archs:
>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>   # modprobe test_bpf
>   # dmesg | grep -w FAIL
>   Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
> 
> with this patch, make the actual max tail call count as MAX_TAIL_CALL_CNT,
> at the same time, the above failed testcase can be fixed.
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> 
> Hi all,
> 
> This is a RFC patch, if I am wrong or I missed something,
> please let me know, thank you!

Yes, the original commit from 04fd61ab36ec ("bpf: allow bpf programs to tail-call
other bpf programs") got the counting wrong, but please also check f9dabe016b63
("bpf: Undo off-by-one in interpreter tail call count limit") where we agreed to
align everything to 33 in order to avoid changing existing behavior, and if we
intend to ever change the count, then only in terms of increasing but not decreasing
since that ship has sailed. Tiezhu, do you still see any arch that is not on 33
from your testing? Last time Paul fixed the remaining ones in 96bc4432f5ad ("bpf,
riscv: Limit to 33 tail calls") and e49e6f6db04e ("bpf, mips: Limit to 33 tail calls").

Thanks,
Daniel
