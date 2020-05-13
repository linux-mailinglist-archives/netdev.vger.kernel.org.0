Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D457C1D221C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgEMWge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:36:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:60982 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgEMWgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:36:33 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYzzJ-0003yk-NJ; Thu, 14 May 2020 00:36:29 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYzzJ-000Svu-Af; Thu, 14 May 2020 00:36:29 +0200
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200513160038.2482415-1-hch@lst.de>
 <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
Date:   Thu, 14 May 2020 00:36:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200513192804.GA30751@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 9:28 PM, Christoph Hellwig wrote:
> On Wed, May 13, 2020 at 12:11:27PM -0700, Linus Torvalds wrote:
>> On Wed, May 13, 2020 at 9:01 AM Christoph Hellwig <hch@lst.de> wrote:
>>>
>>> +static void bpf_strncpy(char *buf, long unsafe_addr)
>>> +{
>>> +       buf[0] = 0;
>>> +       if (strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
>>> +                       BPF_STRNCPY_LEN))
>>> +               strncpy_from_user_nofault(buf, (void __user *)unsafe_addr,
>>> +                               BPF_STRNCPY_LEN);
>>> +}
>>
>> This seems buggy when I look at it.
>>
>> It seems to think that strncpy_from_kernel_nofault() returns an error code.
>>
>> Not so, unless I missed where you changed the rules.
> 
> I didn't change the rules, so yes, this is wrong.
> 
>> Also, I do wonder if we shouldn't gate this on TASK_SIZE, and do the
>> user trial first. On architectures where this thing is valid in the
>> first place (ie kernel and user addresses are separate), the test for
>> address size would allow us to avoid a pointless fault due to an
>> invalid kernel access to user space.
>>
>> So I think this function should look something like
>>
>>    static void bpf_strncpy(char *buf, long unsafe_addr)
>>    {
>>            /* Try user address */
>>            if (unsafe_addr < TASK_SIZE) {
>>                    void __user *ptr = (void __user *)unsafe_addr;
>>                    if (strncpy_from_user_nofault(buf, ptr, BPF_STRNCPY_LEN) >= 0)
>>                            return;
>>            }
>>
>>            /* .. fall back on trying kernel access */
>>            buf[0] = 0;
>>            strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
>> BPF_STRNCPY_LEN);
>>    }
>>
>> or similar. No?
> 
> So on say s390 TASK_SIZE_USUALLy is (-PAGE_SIZE), which means we'd alway
> try the user copy first, which seems odd.
> 
> I'd really like to here from the bpf folks what the expected use case
> is here, and if the typical argument is kernel or user memory.

It's used for both. Given this is enabled on pretty much all program types, my
assumption would be that usage is still more often on kernel memory than user one.
