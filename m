Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3797549F6D3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbiA1KGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:06:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:48784 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242623AbiA1KGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:06:24 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDO8s-0002CD-7I; Fri, 28 Jan 2022 11:06:06 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDO8r-000FIC-Qb; Fri, 28 Jan 2022 11:06:05 +0100
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2dca37b0-6eed-38d5-3491-1febf80bd50d@iogearbox.net>
Date:   Fri, 28 Jan 2022 11:06:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220121135632.136976-3-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26436/Fri Jan 28 10:22:17 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/22 2:56 PM, Hou Tao wrote:
> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
> it only add support for x86-64, so support these atomic operations
> for arm64 as well.
> 
> Basically the implementation procedure is almost mechanical translation
> of code snippets in atomic_ll_sc.h & atomic_lse.h & cmpxchg.h located
> under arch/arm64/include/asm. An extra temporary register is needed
> for (BPF_ADD | BPF_FETCH) to save the value of src register, instead of
> adding TMP_REG_4 just use BPF_REG_AX instead.
> 
> For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
> both ./test_verifier and "./test_progs -t atomic" are exercised and
> passed correspondingly.

Please also make sure that lib/test_bpf.ko passes given it has the most
extensive tests around atomics.

Thanks,
Daniel
