Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8C5525509
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357684AbiELSlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357805AbiELSlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:41:02 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4392B1A6;
        Thu, 12 May 2022 11:41:00 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1npDk7-000CtV-Cb; Thu, 12 May 2022 20:40:55 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1npDk6-000UcN-U2; Thu, 12 May 2022 20:40:54 +0200
Subject: Re: [PATCH 0/5] Atomics support for eBPF on powerpc
To:     Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <21577e77-9860-7746-235e-8c241b4a8a7a@iogearbox.net>
Date:   Thu, 12 May 2022 20:40:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220512074546.231616-1-hbathini@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26539/Thu May 12 10:04:41 2022)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/22 9:45 AM, Hari Bathini wrote:
> This patchset adds atomic operations to the eBPF instruction set on
> powerpc. The instructions that are added here can be summarised with
> this list of kernel operations for ppc64:
> 
> * atomic[64]_[fetch_]add
> * atomic[64]_[fetch_]and
> * atomic[64]_[fetch_]or
> * atomic[64]_[fetch_]xor
> * atomic[64]_xchg
> * atomic[64]_cmpxchg
> 
> and this list of kernel operations for ppc32:
> 
> * atomic_[fetch_]add
> * atomic_[fetch_]and
> * atomic_[fetch_]or
> * atomic_[fetch_]xor
> * atomic_xchg
> * atomic_cmpxchg
> 
> The following are left out of scope for this effort:
> 
> * 64 bit operations on ppc32.
> * Explicit memory barriers, 16 and 8 bit operations on both ppc32
>    & ppc64.
> 
> The first patch adds support for bitwsie atomic operations on ppc64.
> The next patch adds fetch variant support for these instructions. The
> third patch adds support for xchg and cmpxchg atomic operations on
> ppc64. Patch #4 adds support for 32-bit atomic bitwise operations on
> ppc32. patch #5 adds support for xchg and cmpxchg atomic operations
> on ppc32.

Thanks for adding these, Hari! I presume they'll get routed via Michael,
right? One thing that may be worth adding to the commit log as well is
the test result from test_bpf.ko given it has an extensive suite around
atomics useful for testing corner cases in JITs.

> Hari Bathini (5):
>    bpf ppc64: add support for BPF_ATOMIC bitwise operations
>    bpf ppc64: add support for atomic fetch operations
>    bpf ppc64: Add instructions for atomic_[cmp]xchg
>    bpf ppc32: add support for BPF_ATOMIC bitwise operations
>    bpf ppc32: Add instructions for atomic_[cmp]xchg
> 
>   arch/powerpc/net/bpf_jit_comp32.c | 62 +++++++++++++++++-----
>   arch/powerpc/net/bpf_jit_comp64.c | 87 +++++++++++++++++++++----------
>   2 files changed, 108 insertions(+), 41 deletions(-)
> 

