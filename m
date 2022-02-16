Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5A44B7BD9
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbiBPAVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:21:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiBPAVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:21:50 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACCBDFE6;
        Tue, 15 Feb 2022 16:21:39 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK84P-000Gip-Fp; Wed, 16 Feb 2022 01:21:21 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK84P-000CPf-1a; Wed, 16 Feb 2022 01:21:21 +0100
Subject: Re: [PATCH bpf-next v3 2/4] arm64: insn: add encoders for atomic
 operations
To:     Will Deacon <will@kernel.org>
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
References: <20220129220452.194585-1-houtao1@huawei.com>
 <20220129220452.194585-3-houtao1@huawei.com>
 <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
 <20220215174213.GB8706@willie-the-truck>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dbf95c48-fccf-653f-cb8d-05a0637c4b38@iogearbox.net>
Date:   Wed, 16 Feb 2022 01:21:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220215174213.GB8706@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26454/Tue Feb 15 10:32:17 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On 2/15/22 6:42 PM, Will Deacon wrote:
> On Fri, Feb 11, 2022 at 03:39:48PM +0100, Daniel Borkmann wrote:
>> On 1/29/22 11:04 PM, Hou Tao wrote:
>>> It is a preparation patch for eBPF atomic supports under arm64. eBPF
>>> needs support atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and
>>> atomic[64]_{xchg|cmpxchg}. The ordering semantics of eBPF atomics are
>>> the same with the implementations in linux kernel.
>>>
>>> Add three helpers to support LDCLR/LDEOR/LDSET/SWP, CAS and DMB
>>> instructions. STADD/STCLR/STEOR/STSET are simply encoded as aliases for
>>> LDADD/LDCLR/LDEOR/LDSET with XZR as the destination register, so no extra
>>> helper is added. atomic_fetch_add() and other atomic ops needs support for
>>> STLXR instruction, so extend enum aarch64_insn_ldst_type to do that.
>>>
>>> LDADD/LDEOR/LDSET/SWP and CAS instructions are only available when LSE
>>> atomics is enabled, so just return AARCH64_BREAK_FAULT directly in
>>> these newly-added helpers if CONFIG_ARM64_LSE_ATOMICS is disabled.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>
>> Hey Mark / Ard / Will / Catalin or others, could we get an Ack on patch 1 & 2
>> at min if it looks good to you?
> 
> Sorry for the delay, for some reason this series has all ended up in my
> spam! I'll take a look this week. If it looks good, do you mind if I queue
> those two patches in arm64 on a stable branch for you to pull as well? We've
> got a few other (non-BPF) changes pending to the instruction decoder, and
> I'd like to avoid conflicts if we can.

Yes, that should be totally fine.

Thanks,
Daniel
