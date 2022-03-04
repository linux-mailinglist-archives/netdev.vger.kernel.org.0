Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6394CDFF3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 22:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiCDVz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 16:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiCDVzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 16:55:55 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7426D579;
        Fri,  4 Mar 2022 13:54:58 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nQFt1-000G6t-Qi; Fri, 04 Mar 2022 22:54:55 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nQFt1-000A9c-G3; Fri, 04 Mar 2022 22:54:55 +0100
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220227142551.2349805-1-james.hilliard1@gmail.com>
 <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
 <CAEf4Bza84V1hwknb9XR+cNz8Sy4BK2EMYB-Oudq==pOYpqV0nw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c2d6db56-0381-d72c-2c9d-1e0ea324ceff@iogearbox.net>
Date:   Fri, 4 Mar 2022 22:54:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza84V1hwknb9XR+cNz8Sy4BK2EMYB-Oudq==pOYpqV0nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26471/Fri Mar  4 10:24:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/22 8:01 PM, Andrii Nakryiko wrote:
> On Mon, Feb 28, 2022 at 7:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 2/27/22 3:25 PM, James Hilliard wrote:
>>> This definition seems to be missing from some older toolchains.
>>>
>>> Note that the fcntl.h in libbpf_internal.h is not a kernel header
>>> but rather a toolchain libc header.
>>>
>>> Fixes:
>>> libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first use in this function); did you mean 'FD_CLOEXEC'?
>>>      fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
>>>                     ^~~~~~~~~~~~~~~
>>>                     FD_CLOEXEC
>>>
>>> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
>>
>> Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_CLOEXEC
>> was added back in 2.6.24 kernel. When did libc add it?
> 
> It seems like it's guarded by __USE_XOPEN2K8 in glibc (from a quick
> glance at glibc code). But it's been there since 2010 or so, at the
> very least.
> 
>> Should we instead just add an include for <linux/fcntl.h> to libbpf_internal.h
>> (given it defines F_DUPFD_CLOEXEC as well)?
> 
> yep, this is UAPI header so we can use it easily (we'll need to sync
> it into Github repo, but that's not a problem)

Sgtm, James, could you respin with using the include?

Thanks,
Daniel
