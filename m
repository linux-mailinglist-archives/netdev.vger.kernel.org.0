Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BA50EB90
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiDYWYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbiDYVix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:38:53 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058643878A;
        Mon, 25 Apr 2022 14:35:47 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj6Mz-0008B2-Gx; Mon, 25 Apr 2022 23:35:45 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj6Mz-000Nev-21; Mon, 25 Apr 2022 23:35:45 +0200
Subject: Re: [PATCH 1/4] tools/bpf/runqslower: musl compat: explicitly link
 with libargp if found
To:     Dominique Martinet <asmadeus@codewreck.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
 <20220424051022.2619648-2-asmadeus@codewreck.org>
 <YmT1GxK1HimY2Os9@codewreck.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <80728495-e1fe-21bb-9814-6251648f8359@iogearbox.net>
Date:   Mon, 25 Apr 2022 23:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YmT1GxK1HimY2Os9@codewreck.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/22 8:58 AM, Dominique Martinet wrote:
> Dominique Martinet wrote on Sun, Apr 24, 2022 at 02:10:19PM +0900:
>> After having done this work I noticed runqslower is not actually
>> installed, so ideally instead of all of this it'd make more sense to
>> just not build it: would it make sense to take it out of the defaults
>> build targets?
>> I could just directly build the appropriate targets from tools/bpf
>> directory with 'make bpftool bpf_dbg bpf_asm bpf_jit_disasm', but
>> ideally I'd like to keep alpine's build script way of calling make from
>> the tools parent directory, and 'make bpf' there is all or nothing.
> 
> Well, it turns out runqslower doesn't build if the current kernel or
> vmlinux in tree don't have BTF enabled, so the current alpine builder
> can't build it.
> 
> I've dropped this patch from my alpine MR[1] and built things directly
> with make bpftool etc as suggested above, so my suggestion to make it
> more easily buildable that way is probably the way to go?
> [1] https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/33554

Thanks for looking into this, Dominique! I slightly massaged patch 3 & 4
and applied it to bpf-next tree.

I don't really mind about patch 1 & 2, though out of tools/bpf/ the only
one you /really/ might want to package is bpftool. The other tools are on
the legacy side of things and JIT disasm you can also get via bpftool anyway.

Given this is not covered by BPF CI, are you planning to regularly check
for musl compatibility before a new kernel is cut?

Thanks,
Daniel
