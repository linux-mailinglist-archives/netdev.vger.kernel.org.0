Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99C614F8A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiKAQjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiKAQjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C818A1D674;
        Tue,  1 Nov 2022 09:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63BD561697;
        Tue,  1 Nov 2022 16:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB66C433C1;
        Tue,  1 Nov 2022 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667320626;
        bh=CfLRi8SMrIYow/n0js9CDF7UyIXZ1oBR2ZrAsCVNJcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6nc+pY110FruaYqR13lJlCQyprBfgsQqh3YOIAc/orKJVYNr6nEyeoKhBi0u49qn
         67fdF06aFKFjW2h7hoSD5UQ545HtFUs563FYzA7ynrGmFcJ3G1oFR9p4Z/1AE9yHI0
         QQMWfGrTC1aLih+p0ZwYWyoFHMwAmh7P74UAQ74LoioQKf7KgMs55Bpp1HVXmk7Nc0
         u2VQkpSUpqfiVS3hi4ikClMvcUmzgRhm3AHsDYsuAIJ8QBpL2tY2dtODLv/pCuF36J
         U/P/TpPPkl1g8+fLcMsMrSyXMaLGRO4mJixJMnGgYFNFdQIYp0IbmO4zS7ffRnXDOb
         LLHk+MDdVDhbg==
Date:   Tue, 1 Nov 2022 09:37:04 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, x86@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH bpf] bpf: Mark bpf_arch_init_dispatcher_early() as
 __init_or_module
Message-ID: <Y2FLMLvDwTvjqlxf@dev-arch.thelio-3990X>
References: <20221031173819.2344270-1-nathan@kernel.org>
 <Y2DRVwI4bNUppmXJ@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2DRVwI4bNUppmXJ@krava>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 08:57:11AM +0100, Jiri Olsa wrote:
> On Mon, Oct 31, 2022 at 10:38:19AM -0700, Nathan Chancellor wrote:
> > After commit dbe69b299884 ("bpf: Fix dispatcher patchable function entry
> > to 5 bytes nop"), building kernel/bpf/dispatcher.c in certain
> > configurations with LLVM's integrated assembler results in a known
> > recordmcount bug:
> > 
> >   Cannot find symbol for section 4: .init.text.
> >   kernel/bpf/dispatcher.o: failed
> > 
> > This occurs when there are only weak symbols in a particular section in
> > the translation unit; in this case, bpf_arch_init_dispatcher_early() is
> > marked '__weak __init' and it is the only symbol in the .init.text
> > section. recordmcount expects there to be a symbol for a particular
> > section but LLVM's integrated assembler (and GNU as after 2.37) do not
> > generated section symbols. This has been worked around in the kernel
> > before in commit 55d5b7dd6451 ("initramfs: fix clang build failure")
> > and commit 6e7b64b9dd6d ("elfcore: fix building with clang").
> > 
> > Fixing recordmcount has been brought up before but there is no clear
> > solution that does not break ftrace outright.
> > 
> > Unfortunately, working around this issue by removing the '__init' from
> > bpf_arch_init_dispatcher_early() is not an option, as the x86 version of
> > bpf_arch_init_dispatcher_early() calls text_poke_early(), which is
> > marked '__init_or_module', meaning that when CONFIG_MODULES is disabled,
> > bpf_arch_init_dispatcher_early() has to be marked '__init' as well to
> > avoid a section mismatch warning from modpost.
> > 
> > However, bpf_arch_init_dispatcher_early() can be marked
> > '__init_or_module' as well, which would resolve the recordmcount warning
> > for configurations that support modules (i.e., the vast majority of
> > them) while not introducing any new warnings for all configurations. Do
> > so to clear up the build failure for CONFIG_MODULES=y configurations.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/981
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> LGTM but the whole thing might be actually going away:
>   https://lore.kernel.org/bpf/Y2BD6xZ108lv3j7J@krava/T/#u
> 
> because it won't compile on gcc 7

Ah, if that is the case, I suppose we can just wait until it is reverted
and replaced with the better fix. It seems like that will be the case
based on Bjorn's testing:

https://lore.kernel.org/87iljyyes6.fsf@all.your.base.are.belong.to.us/

Cheers,
Nathan

> > ---
> >  arch/x86/net/bpf_jit_comp.c | 2 +-
> >  include/linux/bpf.h         | 2 +-
> >  kernel/bpf/dispatcher.c     | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 00127abd89ee..4145939bbb6a 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -389,7 +389,7 @@ static int __bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
> >  	return ret;
> >  }
> >  
> > -int __init bpf_arch_init_dispatcher_early(void *ip)
> > +int __init_or_module bpf_arch_init_dispatcher_early(void *ip)
> >  {
> >  	const u8 *nop_insn = x86_nops[5];
> >  
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 0566705c1d4e..4aa7bde406f5 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -971,7 +971,7 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
> >  					  struct bpf_attach_target_info *tgt_info);
> >  void bpf_trampoline_put(struct bpf_trampoline *tr);
> >  int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
> > -int __init bpf_arch_init_dispatcher_early(void *ip);
> > +int __init_or_module bpf_arch_init_dispatcher_early(void *ip);
> >  
> >  #define BPF_DISPATCHER_INIT(_name) {				\
> >  	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
> > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > index 04f0a045dcaa..e14a68e9a74f 100644
> > --- a/kernel/bpf/dispatcher.c
> > +++ b/kernel/bpf/dispatcher.c
> > @@ -91,7 +91,7 @@ int __weak arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int n
> >  	return -ENOTSUPP;
> >  }
> >  
> > -int __weak __init bpf_arch_init_dispatcher_early(void *ip)
> > +int __weak __init_or_module bpf_arch_init_dispatcher_early(void *ip)
> >  {
> >  	return -ENOTSUPP;
> >  }
> > 
> > base-commit: 8bdc2acd420c6f3dd1f1c78750ec989f02a1e2b9
> > -- 
> > 2.38.1
> > 
