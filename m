Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB803245DB
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhBXViB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:38:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:35486 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhBXViA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:38:00 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF1qP-000Gov-VM; Wed, 24 Feb 2021 22:37:18 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF1qP-000VTc-O9; Wed, 24 Feb 2021 22:37:17 +0100
Subject: Re: [PATCH bpf-next 0/8] PROG_TEST_RUN support for sk_lookup programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20210216105713.45052-1-lmb@cloudflare.com>
 <CAEf4BzYuvE-RsT5Ee+FstZ=vuy3AMd+1j7DazFSb56+hfPKPig@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <76aa7c94-939f-b370-0ff0-03af3865c5f9@iogearbox.net>
Date:   Wed, 24 Feb 2021 22:37:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYuvE-RsT5Ee+FstZ=vuy3AMd+1j7DazFSb56+hfPKPig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26090/Wed Feb 24 13:09:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/21 8:29 AM, Andrii Nakryiko wrote:
> On Tue, Feb 16, 2021 at 2:58 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>>
>> We don't have PROG_TEST_RUN support for sk_lookup programs at the
>> moment. So far this hasn't been a problem, since we can run our
>> tests in a separate network namespace. For benchmarking it's nice
>> to have PROG_TEST_RUN, so I've gone and implemented it.
>>
>> Multiple sk_lookup programs can be attached at once to the same
>> netns. This can't be expressed with the current PROG_TEST_RUN
>> API, so I'm proposing to extend it with an array of prog_fd.
>>
>> Patches 1-2 are clean ups. Patches 3-4 add the new UAPI and
>> implement PROG_TEST_RUN for sk_lookup. Patch 5 adds a new
>> function to libbpf to access multi prog tests. Patches 6-8 add
>> tests.
>>
>> Andrii, for patch 4 I decided on the following API:
>>
>>      int bpf_prog_test_run_array(__u32 *prog_fds, __u32 prog_fds_cnt,
>>                                  struct bpf_test_run_opts *opts)
>>
>> To be consistent with the rest of libbpf it would be better
>> to take int *prog_fds, but I think then the function would have to
>> convert the array to account for platforms where
>>
>>      sizeof(int) != sizeof(__u32)
> 
> Curious, is there any supported architecture where this is not the
> case? I think it's fine to be consistent, tbh, and use int. Worst
> case, in some obscure architecture we'd need to create a copy of an
> array. Doesn't seem like a big deal (and highly unlikely anyways).

Given __u32 are kernel UAPI exported types for user space (e.g. used in
syscall APIs), you can check where / how they are defined. Mainly here:

   include/uapi/asm-generic/int-l64.h:27:typedef unsigned int __u32;
   include/uapi/asm-generic/int-ll64.h:27:typedef unsigned int __u32;

Thanks,
Daniel
