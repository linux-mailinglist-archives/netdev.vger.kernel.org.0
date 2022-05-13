Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D254525BA5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 08:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377385AbiEMGhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbiEMGhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:37:12 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F83C606FD;
        Thu, 12 May 2022 23:37:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KzzTG1XWDz4xXJ;
        Fri, 13 May 2022 16:37:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652423827;
        bh=wBZd5augCd9NCYq5BTfS1YbWd+KJyjpYKVecpVbN/6g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SI15G+ne6/Z/NZFtvbriZ6NWicBjyIg3iO8mQ+glJzXsMTiVVJ/wUhDE7z3qiV8Hu
         WB9rE6cXIUDANJg4KFDmQkBUa5O8UkjcMe+cIbxBhbP8yOeg6wcNeSfJRXVsjl8jDc
         HZM6WqnE/B8Mt3FXefXZ+829wteXDp6hcBzM19fCRu80T7TWwu4/tQ+8UxtdUeG8Y9
         DmKkrv5BJxLSATPjYVMW/mNfgZRPdZSCcsPbrLPK8mJbjVxjYWnAka8DfOIXICZ/6T
         6fXK96g0A2uTyhaPuJRDtZwfM0DZ0zU4sLRaxySXmIbX1snWwJzhC6gKrdNZciiNUY
         oaOKcwnOIWKjw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
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
Subject: Re: [PATCH 0/5] Atomics support for eBPF on powerpc
In-Reply-To: <21577e77-9860-7746-235e-8c241b4a8a7a@iogearbox.net>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
 <21577e77-9860-7746-235e-8c241b4a8a7a@iogearbox.net>
Date:   Fri, 13 May 2022 16:37:04 +1000
Message-ID: <87h75u6ir3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:
> On 5/12/22 9:45 AM, Hari Bathini wrote:
>> This patchset adds atomic operations to the eBPF instruction set on
>> powerpc. The instructions that are added here can be summarised with
>> this list of kernel operations for ppc64:
>> 
>> * atomic[64]_[fetch_]add
>> * atomic[64]_[fetch_]and
>> * atomic[64]_[fetch_]or
>> * atomic[64]_[fetch_]xor
>> * atomic[64]_xchg
>> * atomic[64]_cmpxchg
>> 
>> and this list of kernel operations for ppc32:
>> 
>> * atomic_[fetch_]add
>> * atomic_[fetch_]and
>> * atomic_[fetch_]or
>> * atomic_[fetch_]xor
>> * atomic_xchg
>> * atomic_cmpxchg
>> 
>> The following are left out of scope for this effort:
>> 
>> * 64 bit operations on ppc32.
>> * Explicit memory barriers, 16 and 8 bit operations on both ppc32
>>    & ppc64.
>> 
>> The first patch adds support for bitwsie atomic operations on ppc64.
>> The next patch adds fetch variant support for these instructions. The
>> third patch adds support for xchg and cmpxchg atomic operations on
>> ppc64. Patch #4 adds support for 32-bit atomic bitwise operations on
>> ppc32. patch #5 adds support for xchg and cmpxchg atomic operations
>> on ppc32.
>
> Thanks for adding these, Hari! I presume they'll get routed via Michael,
> right?

Yeah I'm happy to take them if they are OK by you.

I do wonder if the BPF jit code should eventually move out of arch/, but
that's a discussion for another day.

> One thing that may be worth adding to the commit log as well is
> the test result from test_bpf.ko given it has an extensive suite around
> atomics useful for testing corner cases in JITs.

Yes please, test results make me feel much better about merging things :)

cheers
