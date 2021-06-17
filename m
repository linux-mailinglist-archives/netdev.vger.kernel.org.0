Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245E93AB26A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhFQLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:24:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:53624 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhFQLYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 07:24:51 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltq6U-0001yQ-U2; Thu, 17 Jun 2021 13:22:34 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltq6U-000Wjz-M3; Thu, 17 Jun 2021 13:22:34 +0200
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
To:     Jiri Olsa <jolsa@redhat.com>, Mark Wielaard <mark@klomp.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Frank Eigler <fche@redhat.com>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com> <YMopCb5CqOYsl6HR@krava>
 <YMp68Dlqwu+wuHV9@wildebeest.org> <YMsPnaV798ICuMbv@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <37f69a50-5b83-22e5-d54b-bea79ad3adec@iogearbox.net>
Date:   Thu, 17 Jun 2021 13:22:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YMsPnaV798ICuMbv@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26203/Wed Jun 16 13:07:58 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 11:02 AM, Jiri Olsa wrote:
> On Thu, Jun 17, 2021 at 12:28:00AM +0200, Mark Wielaard wrote:
>> On Wed, Jun 16, 2021 at 06:38:33PM +0200, Jiri Olsa wrote:
>>>>> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
>>>>> index d636643ddd35..f32c059fbfb4 100644
>>>>> --- a/tools/bpf/resolve_btfids/main.c
>>>>> +++ b/tools/bpf/resolve_btfids/main.c
>>>>> @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
>>>>>    	if (sets_patch(obj))
>>>>>    		return -1;
>>>>> +	/* Set type to ensure endian translation occurs. */
>>>>> +	obj->efile.idlist->d_type = ELF_T_WORD;
>>>>
>>>> The change makes sense to me as .BTF_ids contains just a list of
>>>> u32's.
>>>>
>>>> Jiri, could you double check on this?
>>>
>>> the comment in ELF_T_WORD declaration suggests the size depends on
>>> elf's class?
>>>
>>>    ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
>>>
>>> data in .BTF_ids section are allways u32
>>>
>>> I have no idea how is this handled in libelf (perhaps it's ok),
>>> but just that comment above suggests it could be also 64 bits,
>>> cc-ing Frank and Mark for more insight
>>
>> It is correct to use ELF_T_WORD, which means a 32bit unsigned word.
>>
>> The comment is meant to explain that, but is really confusing if you
>> don't know that Elf32_Word and Elf64_Word are the same thing (a 32bit
>> unsigned word). This comes from being "too consistent" in defining all
>> data types for both 32bit and 64bit ELF, even if those types are the
>> same in both formats...
>>
>> Only Elf32_Addr/Elf64_Addr and Elf32_Off/Elf64_Off are different
>> sizes. But Elf32/Elf_64_Half (16 bit), Elf32/Elf64_Word (32 bit),
>> Elf32/Elf64_Xword (64 bit) and their Sword/Sxword (signed) variants
>> are all identical data types in both the Elf32 and Elf64 formats.
>>
>> I don't really know why. It seems the original ELF spec was 32bit only
>> and when introducing the ELF64 format "they" simply duplicated all
>> data types whether or not those data type were actually different
>> between the 32 and 64 bit format.
> 
> nice, thanks for details
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Tony, could you do a v2 and summarize the remainder of the discussion in
here for the commit message? Would be good to explicitly document the
assumptions made and why they work.

Thanks everyone,
Daniel
