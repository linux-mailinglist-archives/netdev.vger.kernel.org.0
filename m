Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD334B7717
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242395AbiBORmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:42:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiBORma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AF08B6D1;
        Tue, 15 Feb 2022 09:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD2561651;
        Tue, 15 Feb 2022 17:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDDAC340EB;
        Tue, 15 Feb 2022 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644946939;
        bh=y4/0WALBAgMw+vh7sL/5UQNUr1iIGC7riSstyuBt2r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S6j4gwEzVZlTl+OW2H9SqCTUkRYsDan9kqgPcZichzYh0rui2rpRcqTT2tgsZCq1a
         r4/iAeB0TI+6aktFW6DREQydjhqp8ESSTHKbX7yuNTG8J2XEW9kxIh6crdqgaeN6dc
         TEMRAyjB3TzEEqWfLQFnQpuCxlZZokkdoLsPLk3CzIq8vCU9nsKMj5lpgpGWGwIfed
         fu7aIPjo3RZL/0D3zU7andAjBjGspxdFKwkC/M8SkNDUNnORgeu7oewTBKfjyAYpr5
         1w7hQV/FgQbzUjW54aDKcU/VEGd6gvXWse9yE93azbu7Xby1qLkcxb1OXE2b1WdG3r
         AJHP+6HjdHnIQ==
Date:   Tue, 15 Feb 2022 17:42:13 +0000
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
Message-ID: <20220215174213.GB8706@willie-the-truck>
References: <20220129220452.194585-1-houtao1@huawei.com>
 <20220129220452.194585-3-houtao1@huawei.com>
 <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hi Daniel,

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

Sorry for the delay, for some reason this series has all ended up in my
spam! I'll take a look this week. If it looks good, do you mind if I queue
those two patches in arm64 on a stable branch for you to pull as well? We've
got a few other (non-BPF) changes pending to the instruction decoder, and
I'd like to avoid conflicts if we can.

Cheers,

Will
