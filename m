Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0984C633E9E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbiKVOOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiKVOOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:14:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D214F2CE39;
        Tue, 22 Nov 2022 06:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fPPV6bHHJk7Bs+EMqqf8ix0CTVkJxWliUb6bnx5zXTg=; b=HdO+Bn2qho/Fg02s5a+yFi5L/z
        s0NtsK38g/aax/ZAJqb3zpsAMqYq7+Q7tadhZHCFcDv1F8NGUS7eMrvUVi6gO0Se6McQOvAq3EGvL
        2kViVT7V7FMmfwuik/UpbfWf7ZfBgB0Sd8aBtzOA1ZGU4sFgBdRLOLdVIpDDIBDRCL0BgV3NB5s8H
        VKjVRBdnpccjyfxP0D+XRHZnKynxW/A+W7CgX/YFu2injmmqoGzfKseis/z+POMQ258gzMv/SBjZb
        vxn2zgiGmmQ5uxX+zUys8Q1Tg/lPY+AiXkiTSXv5kRITvA/tjn3PL2mSG0brgGwDC2ZTeZl0fGh8O
        RnnjkvdA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxU2k-006RC4-4S; Tue, 22 Nov 2022 14:14:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DDB44300322;
        Tue, 22 Nov 2022 15:14:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 885B22D69A8AA; Tue, 22 Nov 2022 15:14:26 +0100 (CET)
Date:   Tue, 22 Nov 2022 15:14:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Chen Hu <hu1.chen@intel.com>, jpoimboe@kernel.org,
        memxor@gmail.com, bpf@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for
 destructor kfunc
Message-ID: <Y3zZQpHNQ8cRjKQY@hirez.programming.kicks-ass.net>
References: <20221122073244.21279-1-hu1.chen@intel.com>
 <Y3zTF0CjQFt/dR2M@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3zTF0CjQFt/dR2M@krava>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:48:07PM +0100, Jiri Olsa wrote:
> On Mon, Nov 21, 2022 at 11:32:43PM -0800, Chen Hu wrote:
> > With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
> > following BUG:
> > 
> >   traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
> >   ------------[ cut here ]------------
> >   kernel BUG at arch/x86/kernel/traps.c:254!
> >   invalid opcode: 0000 [#1] PREEMPT SMP
> >   <TASK>
> >    asm_exc_control_protection+0x26/0x50
> >   RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
> >   Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
> > 	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
> >        <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
> >    bpf_map_free_kptrs+0x2e/0x70
> >    array_map_free+0x57/0x140
> >    process_one_work+0x194/0x3a0
> >    worker_thread+0x54/0x3a0
> >    ? rescuer_thread+0x390/0x390
> >    kthread+0xe9/0x110
> >    ? kthread_complete_and_exit+0x20/0x20
> > 
> > This is because there are no compile-time references to the destructor
> > kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
> > them sealable and ENDBR in the functions were sealed (converted to NOP)
> > by apply_ibt_endbr().

If there is no compile time reference to it, what stops an LTO linker
from throwing it out in the first place?

