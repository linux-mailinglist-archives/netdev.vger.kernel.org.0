Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050381D22F7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732639AbgEMXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:24:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:39596 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732374AbgEMXYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:24:22 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ0jb-0000nW-H0; Thu, 14 May 2020 01:24:19 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZ0jb-0007qv-2t; Thu, 14 May 2020 01:24:19 +0200
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bgregg@netflix.com
References: <20200513160038.2482415-1-hch@lst.de>
 <20200513160038.2482415-12-hch@lst.de>
 <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
 <20200513192804.GA30751@lst.de>
 <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
 <CAHk-=wiivWJ70PotzCK-j7K4Y612NJBA2d+iN6Rz-bfMxCpwjQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2a03633b-419d-643f-b787-ca1520e2229b@iogearbox.net>
Date:   Thu, 14 May 2020 01:24:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiivWJ70PotzCK-j7K4Y612NJBA2d+iN6Rz-bfMxCpwjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25811/Wed May 13 14:11:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 1:03 AM, Linus Torvalds wrote:
> On Wed, May 13, 2020 at 3:36 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> It's used for both.
> 
> Daniel, BPF real;ly needs to make up its mind about that.
> 
> You *cannot* use ti for both.
> 
> Yes, it happens to work on x86 and some other architectures.
> 
> But on other architectures, the exact same pointer value can be a
> kernel pointer or a user pointer.

Right, it has the same issue as with the old probe helper. I was merely stating that
there are existing users (on x86) out there that use it this way, even though broken
generally.

>> Given this is enabled on pretty much all program types, my
>> assumption would be that usage is still more often on kernel memory than user one.
> 
> You need to pick one.
> 
> If you know it is a user pointer, use strncpy_from_user() (possibly
> with disable_pagefault() aka strncpy_from_user_nofault()).
> 
> And if you know it is a kernel pointer, use strncpy_from_unsafe() (aka
> strncpy_from_kernel_nofault()).
> 
> You really can't pick the "randomly one or the other guess what I mean " option.

My preference would be to have %s, %sK, %sU for bpf_trace_printk() where the latter two
result in an explicit strncpy_from_kernel_nofault() or strncpy_from_user_nofault()
choice while the %s is converted as per your suggestion and it would still allow for a
grace period to convert existing users to the new variants, similar with what we did on
the bpf_probe_read_kernel() and bpf_probe_read_user() helpers to get this sorted out.

Thanks,
Daniel
