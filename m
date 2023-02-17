Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B669B42E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBQUtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQUtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:49:13 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69815CF34;
        Fri, 17 Feb 2023 12:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=woFSv3R0qx1mhW59+7gl0uUf67xuCRJwLoN/Zfd9ruk=; b=RcESBVvpUrfUvxdrwJrM7G3WHb
        QhseaDc1FDtaaEXuFc2umZwc+VWmT5kelH75/Yyj4swAybyWgd1nSHfiXmygWCf+RiLzXfqn0r+Z8
        4eJGJvO2ui4ndQD2Nzme0V+yKx+ZgrfXIDKmDCkm+y+JTyE4ZdiJOWgjSSByWhtQuP2lJHrKj1gf3
        U6bZXohE27FAXgq32fKAoO2319QnPEbug8DE1+Epb4TpiUYGJC0hW8HvWhB5Ytk9p044qSJ0kfG1o
        pe7TvPviflGVxt+gvpE5u7yzGlOJWHYuaDfsh1I60HAQSXMKIzYbMpZ6IfSc0EFMSjzuGaPcG4qP8
        PImKh4xw==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7fB-000Eb5-SU; Fri, 17 Feb 2023 21:49:01 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT7fB-000QjW-3a; Fri, 17 Feb 2023 21:49:01 +0100
Subject: Re: [PATCH bpf-next v1 0/4] Support bpf trampoline for RV64
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Pu Lehui <pulehui@huaweicloud.com>, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Pu Lehui <pulehui@huawei.com>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
 <8735763pcu.fsf@all.your.base.are.belong.to.us>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <091287c6-5121-58e5-b1b2-76277d2f1b1a@iogearbox.net>
Date:   Fri, 17 Feb 2023 21:49:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8735763pcu.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26815/Fri Feb 17 09:41:01 2023)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 10:56 AM, Björn Töpel wrote:
> Pu Lehui <pulehui@huaweicloud.com> writes:
> 
>> BPF trampoline is the critical infrastructure of the bpf
>> subsystem, acting as a mediator between kernel functions
>> and BPF programs. Numerous important features, such as
>> using ebpf program for zero overhead kernel introspection,
>> rely on this key component. We can't wait to support bpf
>> trampoline on RV64. Since RV64 does not support ftrace
>> direct call yet, the current RV64 bpf trampoline is only
>> used in bpf context.
>>
>> As most of riscv cpu support unaligned memory accesses,
>> we temporarily use patch [1] to facilitate testing. The
>> test results are as follow, and test_verifier with no
>> new failure ceses.
>>
>> - fexit_bpf2bpf:OK
>> - dummy_st_ops:OK
>> - xdp_bpf2bpf:OK
>>
>> [1] https://lore.kernel.org/linux-riscv/20210916130855.4054926-2-chenhuang5@huawei.com/
>>
>> v1:
>> - Remove the logic of bpf_arch_text_poke supported for
>>    kernel functions. (Kuohai and Björn)
>> - Extend patch_text for multiple instructions. (Björn)
>> - Fix OOB issue when image too big. (Björn)
> 
> This series is ready to go in as is.

Ok.

> @Palmer I'd like to take this series via the bpf-next tree (as usual),
> but note that there are some non-BPF changes as well, related to text
> poking.
> 
> @Lehui I'd like to see two follow-up patches:
> 
> 1. Enable kfunc for RV64, by adding:
>   | bool bpf_jit_supports_kfunc_call(void)
>   | {
>   |         return true;
>   | }
> 
> 2. Remove the checkpatch warning on patch 4:
>   | WARNING: kfree(NULL) is safe and this check is probably not required
>   | #313: FILE: arch/riscv/net/bpf_jit_comp64.c:984:
>   | +	if (branches_off)
>   | +		kfree(branches_off);
> 
> 
> For the series:
> 
> Tested-by: Björn Töpel <bjorn@rivosinc.com>
> Acked-by: Björn Töpel <bjorn@rivosinc.com>

Thanks, I fixed up issue 2 and cleaned up the commit msgs while applying.
For issue 1, pls send a follow-up.
