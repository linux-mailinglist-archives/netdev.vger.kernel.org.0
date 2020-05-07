Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF31C9C33
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgEGUWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:22:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:34222 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbgEGUWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:22:19 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWn26-0001Dl-GF; Thu, 07 May 2020 22:22:14 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWn21-0002Yj-BR; Thu, 07 May 2020 22:22:09 +0200
Subject: Re: [RFC PATCH bpf-next 3/3] bpf, arm64: Optimize ADD,SUB,JMP BPF_K
 using arm64 add/sub immediates
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
        Enrico Weigelt <info@metux.net>, Torsten Duwe <duwe@suse.de>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
 <20200507010504.26352-4-luke.r.nels@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f93a921e-58d2-b7c4-0d3f-b76091c6b208@iogearbox.net>
Date:   Thu, 7 May 2020 22:22:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200507010504.26352-4-luke.r.nels@gmail.com>
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
> The current code for BPF_{ADD,SUB} BPF_K loads the BPF immediate to a
> temporary register before performing the addition/subtraction. Similarly,
> BPF_JMP BPF_K cases load the immediate to a temporary register before
> comparison.
> 
> This patch introduces optimizations that use arm64 immediate add, sub,
> cmn, or cmp instructions when the BPF immediate fits. If the immediate
> does not fit, it falls back to using a temporary register.
> 
> Example of generated code for BPF_ALU64_IMM(BPF_ADD, R0, 2):
> 
> without optimization:
> 
>    24: mov x10, #0x2
>    28: add x7, x7, x10
> 
> with optimization:
> 
>    24: add x7, x7, #0x2
> 
> The code could use A64_{ADD,SUB}_I directly and check if it returns
> AARCH64_BREAK_FAULT, similar to how logical immediates are handled.
> However, aarch64_insn_gen_add_sub_imm from insn.c prints error messages
> when the immediate does not fit, and it's simpler to check if the
> immediate fits ahead of time.
> 
> Co-developed-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Same here:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Thanks!
