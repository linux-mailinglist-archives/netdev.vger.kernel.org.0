Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094BD4B2819
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiBKOkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:40:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiBKOkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:40:03 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1962A188;
        Fri, 11 Feb 2022 06:40:02 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX5R-00064w-Rf; Fri, 11 Feb 2022 15:39:49 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIX5R-0009z4-Dh; Fri, 11 Feb 2022 15:39:49 +0100
Subject: Re: [PATCH bpf-next v3 2/4] arm64: insn: add encoders for atomic
 operations
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
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
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20220129220452.194585-1-houtao1@huawei.com>
 <20220129220452.194585-3-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
Date:   Fri, 11 Feb 2022 15:39:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220129220452.194585-3-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26450/Fri Feb 11 10:24:09 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/22 11:04 PM, Hou Tao wrote:
> It is a preparation patch for eBPF atomic supports under arm64. eBPF
> needs support atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and
> atomic[64]_{xchg|cmpxchg}. The ordering semantics of eBPF atomics are
> the same with the implementations in linux kernel.
> 
> Add three helpers to support LDCLR/LDEOR/LDSET/SWP, CAS and DMB
> instructions. STADD/STCLR/STEOR/STSET are simply encoded as aliases for
> LDADD/LDCLR/LDEOR/LDSET with XZR as the destination register, so no extra
> helper is added. atomic_fetch_add() and other atomic ops needs support for
> STLXR instruction, so extend enum aarch64_insn_ldst_type to do that.
> 
> LDADD/LDEOR/LDSET/SWP and CAS instructions are only available when LSE
> atomics is enabled, so just return AARCH64_BREAK_FAULT directly in
> these newly-added helpers if CONFIG_ARM64_LSE_ATOMICS is disabled.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Hey Mark / Ard / Will / Catalin or others, could we get an Ack on patch 1 & 2
at min if it looks good to you?

Thanks a lot,
Daniel
