Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7595C4B8EF0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiBPRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:16:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiBPRQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:16:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2362AED9B;
        Wed, 16 Feb 2022 09:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7957BB81DD2;
        Wed, 16 Feb 2022 17:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2545DC340E8;
        Wed, 16 Feb 2022 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645031770;
        bh=H8UzL8cAWXsf7LlwEbF/oBmPBoQ/jM+fAqEB1ENwlTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCJxZWtmlxBfPdaYYXaEiu1ET6Zfkb3z6DZ3Mv+Xgg6BuSO9SAXboaeKo4vpQJRYL
         u89kcDmK8UCOVLqV3Yby+J9O9jHW8U4wGTEi9Rejt0daCOsEmSKKjXYxh8S/jKXOzb
         5bNCoFLwjInMq69o5aOeNhLlQm9lqT7AIk93GPeVhYbrJDOD51c3Bt+s9cv/JfqGEj
         pti01SRHyuCotOcPEjp9uN4kmXxpKLsIrBRh3vpFDn/J7Wxly5m1DWcB0UlrT9tExk
         6F8wPA/57ugsh0i8446d6SKex0V9tIOXnPuYbYxvZf14WJMvF9qip3Fu4RltTPBgl5
         /3EEsFDbwKbdA==
Date:   Wed, 16 Feb 2022 17:16:02 +0000
From:   Will Deacon <will@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH bpf-next v3 2/4] arm64: insn: add encoders for atomic
 operations
Message-ID: <20220216171602.GA10877@willie-the-truck>
References: <20220129220452.194585-1-houtao1@huawei.com>
 <20220129220452.194585-3-houtao1@huawei.com>
 <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 03:39:48PM +0100, Daniel Borkmann wrote:
> On 1/29/22 11:04 PM, Hou Tao wrote:
> > It is a preparation patch for eBPF atomic supports under arm64. eBPF
> > needs support atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and
> > atomic[64]_{xchg|cmpxchg}. The ordering semantics of eBPF atomics are
> > the same with the implementations in linux kernel.
> > 
> > Add three helpers to support LDCLR/LDEOR/LDSET/SWP, CAS and DMB
> > instructions. STADD/STCLR/STEOR/STSET are simply encoded as aliases for
> > LDADD/LDCLR/LDEOR/LDSET with XZR as the destination register, so no extra
> > helper is added. atomic_fetch_add() and other atomic ops needs support for
> > STLXR instruction, so extend enum aarch64_insn_ldst_type to do that.
> > 
> > LDADD/LDEOR/LDSET/SWP and CAS instructions are only available when LSE
> > atomics is enabled, so just return AARCH64_BREAK_FAULT directly in
> > these newly-added helpers if CONFIG_ARM64_LSE_ATOMICS is disabled.
> > 
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> 
> Hey Mark / Ard / Will / Catalin or others, could we get an Ack on patch 1 & 2
> at min if it looks good to you?

I checked the instruction encodings in patches 1 and 2 and they all look
fine to me. However, after applying those two locally I get a build failure:

  | In file included from arch/arm64/net/bpf_jit_comp.c:23:
  | arch/arm64/net/bpf_jit_comp.c: In function ‘build_insn’:
  | arch/arm64/net/bpf_jit.h:94:2: error: implicit declaration of function ‘aarch64_insn_gen_stadd’; did you mean ‘aarch64_insn_gen_adr’? [-Werror=implicit-function-declaration]
  |    94 |  aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
  |       |  ^~~~~~~~~~~~~~~~~~~~~~
  | arch/arm64/net/bpf_jit_comp.c:912:9: note: in expansion of macro ‘A64_STADD’
  |   912 |    emit(A64_STADD(isdw, reg, src), ctx);
  |       |         ^~~~~~~~~
  | cc1: some warnings being treated as errors

Will
