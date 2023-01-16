Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A28A66C3D8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjAPP3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjAPP2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:28:39 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41335234DD;
        Mon, 16 Jan 2023 07:24:04 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pHRKw-0006CX-KC; Mon, 16 Jan 2023 16:23:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pHRKw-000XTn-29; Mon, 16 Jan 2023 16:23:50 +0100
Subject: Re: [bpf-next 00/10] samples/bpf: modernize BPF functionality test
 programs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
 <CAADnVQ+zP5bkjkSa97k+dK7=NabkdoLWQtZ1qRwRTUQgGdqhVA@mail.gmail.com>
 <CAEKGpzgzxabXqUKXz4A-dYx6B05vbDkGELadRDBnbCF_hLxMAQ@mail.gmail.com>
 <87ilh6eh51.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ccc12280-4e00-ab23-d948-05c7db8b8da1@iogearbox.net>
Date:   Mon, 16 Jan 2023 16:23:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87ilh6eh51.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26783/Mon Jan 16 09:28:30 2023)
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/23 2:35 PM, Toke Høiland-Jørgensen wrote:
> "Daniel T. Lee" <danieltimlee@gmail.com> writes:
>> On Mon, Jan 16, 2023 at 6:38 AM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Sat, Jan 14, 2023 at 11:16 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>>>>
>>>> Currently, there are many programs under samples/bpf to test the
>>>> various functionality of BPF that have been developed for a long time.
>>>> However, the kernel (BPF) has changed a lot compared to the 2016 when
>>>> some of these test programs were first introduced.
>>>>
>>>> Therefore, some of these programs use the deprecated function of BPF,
>>>> and some programs no longer work normally due to changes in the API.
>>>>
>>>> To list some of the kernel changes that this patch set is focusing on,
>>>> - legacy BPF map declaration syntax support had been dropped [1]
>>>> - bpf_trace_printk() always append newline at the end [2]
>>>> - deprecated styled BPF section header (bpf_load style) [3]
>>>> - urandom_read tracepoint is removed (used for testing overhead) [4]
>>>> - ping sends packet with SOCK_DGRAM instead of SOCK_RAW [5]*
>>>> - use "vmlinux.h" instead of including individual headers
>>>>
>>>> In addition to this, this patchset tries to modernize the existing
>>>> testing scripts a bit. And for network-related testing programs,
>>>> a separate header file was created and applied. (To use the
>>>> Endianness conversion function from xdp_sample and bunch of constants)
>>>
>>> Nice set of cleanups. Applied.
>>> As a follow up could you convert some of them to proper selftests/bpf ?
>>> Unfortunately samples/bpf will keep bit rotting despite your herculean efforts.
>>
>> I really appreciate for your compliment!
>> I'll try to convert the existing sample to selftest in the next patch.

This would be awesome, thanks a lot Daniel!

> Maybe this is a good time to mention that we recently ported some of the
> XDP utilities from samples/bpf to xdp-tools, in the form of the
> 'xdp-bench' utility:
> https://github.com/xdp-project/xdp-tools/tree/master/xdp-bench
> 
> It's basically a combination of all the xdp_redirect* samples, but also
> includes the functionality from the xdp_rxq_info sample program (i.e.,
> the ability to monitor RXQs and use other return codes).
> 
> I'm planning to submit a patch to remove those utilities from
> samples/bpf after we tag the next release of xdp-tools (have one or two
> outstanding issues to clear before we do that), but wanted to give you a
> head's up so you don't spend any time on those particular utilities when
> you're cleaning up samples :)

Nice! Once we're through with most relevant ones from samples/bpf, it would
be great to only have a readme in that dir (and that's really all) with pointers
for developers on how to get started.. including BPF selftests, xdp tools, links
to ebpf.io/applications and ebpf.io/infrastructure, etc where more resources
can be found, essentially a small getting started doc for BPF devs.
