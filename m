Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A144B1C9C11
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgEGUTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:19:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:33822 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgEGUTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:19:41 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWmzZ-0000uo-43; Thu, 07 May 2020 22:19:37 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWmzY-000Pq5-CQ; Thu, 07 May 2020 22:19:36 +0200
Subject: Re: [RFC PATCH bpf-next 2/3] bpf, arm64: Optimize AND,OR,XOR,JSET
 BPF_K using arm64 logical immediates
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Enrico Weigelt <info@metux.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
 <20200507010504.26352-3-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2b05950b-5f7a-e5e7-81fe-27703c3ef77f@iogearbox.net>
Date:   Thu, 7 May 2020 22:19:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200507010504.26352-3-luke.r.nels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25805/Thu May  7 14:14:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/20 3:05 AM, Luke Nelson wrote:
> The current code for BPF_{AND,OR,XOR,JSET} BPF_K loads the immediate to
> a temporary register before use.
> 
> This patch changes the code to avoid using a temporary register
> when the BPF immediate is encodable using an arm64 logical immediate
> instruction. If the encoding fails (due to the immediate not being
> encodable), it falls back to using a temporary register.
> 
> Example of generated code for BPF_ALU32_IMM(BPF_AND, R0, 0x80000001):
> 
> without optimization:
> 
>    24: mov  w10, #0x8000ffff
>    28: movk w10, #0x1
>    2c: and  w7, w7, w10
> 
> with optimization:
> 
>    24: and  w7, w7, #0x80000001
> 
> Since the encoding process is quite complex, the JIT reuses existing
> functionality in arch/arm64/kernel/insn.c for encoding logical immediates
> rather than duplicate it in the JIT.
> 
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Great find, thanks! Given Will wanted to queue them:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
