Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8611D2CAC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgENK1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:27:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:33820 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgENK1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:27:47 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZB5c-0007ik-1o; Thu, 14 May 2020 12:27:44 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZB5b-000K33-L4; Thu, 14 May 2020 12:27:43 +0200
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
 <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <20200514082054.f817721ce196f134e6820644@kernel.org>
 <CAHk-=wjBKGLyf1d53GwfUTZiK_XPdujwh+u2XSpD2HWRV01Afw@mail.gmail.com>
 <20200514100009.a8e6aa001f0ace5553c7904f@kernel.org>
 <CAHk-=wjP8ysEZnNFi_+E1ZEFGpcbAN8kbYHrCnC93TX6XX+jEQ@mail.gmail.com>
 <20200514184419.0fbf548ccf883c097d94573a@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9c2f90fd-9cac-67c3-4d96-4f873c7649e7@iogearbox.net>
Date:   Thu, 14 May 2020 12:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200514184419.0fbf548ccf883c097d94573a@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 11:44 AM, Masami Hiramatsu wrote:
> On Wed, 13 May 2020 19:43:24 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Wed, May 13, 2020 at 6:00 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>>>
>>>> But we should likely at least disallow it entirely on platforms where
>>>> we really can't - or pick one hardcoded choice. On sparc, you really
>>>> _have_ to specify one or the other.
>>>
>>> OK. BTW, is there any way to detect the kernel/user space overlap on
>>> memory layout statically? If there, I can do it. (I don't like
>>> "if (CONFIG_X86)" thing....)
>>> Or, maybe we need CONFIG_ARCH_OVERLAP_ADDRESS_SPACE?
>>
>> I think it would be better to have a CONFIG variable that
>> architectures can just 'select' to show that they are ok with separate
>> kernel and user addresses.
>>
>> Because I don't think we have any way to say that right now as-is. You
>> can probably come up with hacky ways to approximate it, ie something
>> like
>>
>>      if (TASK_SIZE_MAX > PAGE_OFFSET)
>>          .... they overlap ..
>>
>> which would almost work, but..
> 
> It seems TASK_SIZE_MAX is defined only on x86 and s390, what about
> comparing STACK_TOP_MAX with PAGE_OFFSET ?
> Anyway, I agree that the best way is introducing a CONFIG.

Agree, CONFIG knob that archs can select feels cleanest. Fwiw, I've cooked
up fixes for bpf side locally here and finishing up testing, will push out
later today.

Thanks,
Daniel
