Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90ED53BC375
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhGEUoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 16:44:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:57664 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhGEUoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 16:44:05 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0VP9-0000KK-8J; Mon, 05 Jul 2021 22:41:23 +0200
Received: from [85.5.47.65] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0VP9-000GWr-2z; Mon, 05 Jul 2021 22:41:23 +0200
Subject: Re: [PATCH bpf-next] libbpf: ignore .eh_frame sections when parsing
 elf files
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, yhs@fb.com
References: <20210629110923.580029-1-toke@redhat.com>
 <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net> <87czrxyrru.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e8385d06-ac0a-de99-de92-c91d5970b7e8@iogearbox.net>
Date:   Mon, 5 Jul 2021 22:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87czrxyrru.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26222/Mon Jul  5 13:05:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/21 12:33 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 6/29/21 1:09 PM, Toke Høiland-Jørgensen wrote:
>>> The .eh_frame and .rel.eh_frame sections will be present in BPF object
>>> files when compiled using a multi-stage compile pipe like in samples/bpf.
>>> This produces errors when loading such a file with libbpf. While the errors
>>> are technically harmless, they look odd and confuse users. So add .eh_frame
>>> sections to is_sec_name_dwarf() so they will also be ignored by libbpf
>>> processing. This gets rid of output like this from samples/bpf:
>>>
>>> libbpf: elf: skipping unrecognized data section(32) .eh_frame
>>> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh_frame
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> For the samples/bpf case, could we instead just add a -fno-asynchronous-unwind-tables
>> to clang as cflags to avoid .eh_frame generation in the first place?
> 
> Ah, great suggestion! Was trying, but failed, to figure out how to do
> that. Just tested it, and yeah, that does fix samples; will send a
> separate patch to add that.

Sounds good, just applied.

> I still think filtering this section name in libbpf is worthwhile,
> though, as the error message is really just noise... WDYT?

No strong opinion from my side, I can also see the argument that Andrii made some
time ago [0] in that normally you should never see these in a BPF object file.
But then ... there's BPF samples giving a wrong sample. ;( And I bet some users
might have copied from there, and it's generally confusing from a user experience
in libbpf on whether it's harmless or not.

Side-question: Did you check if it is still necessary in general to have this
multi-stage compile pipe in samples with the native clang frontend invocation
(instead of bpf target one)? (Maybe it's time to get rid of it in general.)

Anyway, would be nice to add further context/description about it to the commit
message at least for future reference on what the .eh_frame sections contain
exactly and why it's harmless. (Right now it only states that it is but without
more concrete rationale, would be good to still add.)

Thanks,
Daniel

   [0] https://lore.kernel.org/bpf/CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com/
