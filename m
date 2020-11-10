Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E6A2AE418
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbgKJXar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:30:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:37412 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731234AbgKJXar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 18:30:47 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcd61-0003PG-DP; Wed, 11 Nov 2020 00:30:41 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcd61-000PfB-3r; Wed, 11 Nov 2020 00:30:41 +0100
Subject: Re: [PATCHv5 bpf] bpf: Move iterator functions into special init
 section
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20201109185754.377373-1-jolsa@kernel.org>
 <9205a69f-95db-6bc3-51f8-8b6f79c5e8fd@iogearbox.net>
 <20201110103509.GD387652@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <073f2234-b3ce-aa6d-f1d9-e216aeede68a@iogearbox.net>
Date:   Wed, 11 Nov 2020 00:30:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201110103509.GD387652@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25984/Tue Nov 10 14:18:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 11:35 AM, Jiri Olsa wrote:
> On Mon, Nov 09, 2020 at 11:04:34PM +0100, Daniel Borkmann wrote:
> 
> SNIP
> 
>>> index 7b53cb3092ee..a7c71e3b5f9a 100644
>>> --- a/include/linux/init.h
>>> +++ b/include/linux/init.h
>>> @@ -52,6 +52,7 @@
>>>    #define __initconst	__section(".init.rodata")
>>>    #define __exitdata	__section(".exit.data")
>>>    #define __exit_call	__used __section(".exitcall.exit")
>>> +#define __init_bpf_preserve_type __section(".init.bpf.preserve_type")
>>
>> Small nit, why this detour via BPF_INIT define? Couldn't we just:
>>
>> #ifdef CONFIG_DEBUG_INFO_BTF
>> #define __init_bpf_preserve_type   __section(".init.bpf.preserve_type")
>> #else
>> #define __init_bpf_preserve_type   __init
>> #endif
>>
>> Also, the comment above the existing defines says '/* These are for everybody (although
>> not all archs will actually discard it in modules) */' ... We should probably not add
>> the __init_bpf_preserve_type right under this listing as-is in your patch, but instead
>> 'separate' it by adding a small comment on top of its definition by explaining its
>> purpose more clearly for others.
> 
> ok, for some reason I thought I needed to add it to init.h,
> but as it's bpf specific, perhaps we can omit init.h change
> completely.. how about the change below?

Agree, that looks much better, thanks!
