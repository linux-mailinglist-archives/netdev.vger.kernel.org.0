Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C11F2B1D83
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgKMOc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:32:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:46634 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMOc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 09:32:26 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kda7j-0002Xg-Ge; Fri, 13 Nov 2020 15:32:23 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kda7j-0008Cr-9w; Fri, 13 Nov 2020 15:32:23 +0100
Subject: Re: csum_partial() on different archs (selftest/bpf)
To:     Al Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
 <20201113122440.GA2164@myrica>
 <CAJ+HfNiE5Oa25QgdAdKzfk-=X45hXLKk_t+ZCiSaeFVTzgzsrw@mail.gmail.com>
 <20201113141542.GJ3576660@ZenIV.linux.org.uk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f634b437-aa51-736b-e2f3-f6210fc6a711@iogearbox.net>
Date:   Fri, 13 Nov 2020 15:32:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201113141542.GJ3576660@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25987/Fri Nov 13 14:19:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 3:15 PM, Al Viro wrote:
> On Fri, Nov 13, 2020 at 02:22:16PM +0100, Björn Töpel wrote:
> 
>> Folding Al's input to this reply.
>>
>> I think the bpf_csum_diff() is supposed to be used in combination with
>> another helper(s) (e.g. bpf_l4_csum_replace) so I'd guess the returned
>> __wsum should be seen as an opaque value, not something BPF userland
>> can rely on.
> 
> Why not reduce the sucker modulo 0xffff before returning it?  Incidentally,
> implementation is bloody awful:
> 
>          /* This is quite flexible, some examples:
>           *
>           * from_size == 0, to_size > 0,  seed := csum --> pushing data
>           * from_size > 0,  to_size == 0, seed := csum --> pulling data
>           * from_size > 0,  to_size > 0,  seed := 0    --> diffing data
>           *
>           * Even for diffing, from_size and to_size don't need to be equal.
>           */
>          if (unlikely(((from_size | to_size) & (sizeof(__be32) - 1)) ||
>                       diff_size > sizeof(sp->diff)))
>                  return -EINVAL;
> 
>          for (i = 0; i < from_size / sizeof(__be32); i++, j++)
>                  sp->diff[j] = ~from[i];
>          for (i = 0; i <   to_size / sizeof(__be32); i++, j++)
>                  sp->diff[j] = to[i];
> 
>          return csum_partial(sp->diff, diff_size, seed);
> 
> What the hell is this (copying, scratchpad, etc.) for?  First of all,
> _if_ you want to use csum_partial() at all (and I'm not at all sure
> that it won't be cheaper to just go over two arrays, doing csum_add()
> and csum_sub() resp. - depends upon the realistic sizes), you don't
> need to copy anything.  Find the sum of from, find the sum of to and
> then subtract (csum_sub()) the old sum from the seed and and add the
> new one...
> 
> And I would strongly recommend to change the calling conventions of that
> thing - make it return __sum16.  And take __sum16 as well...
> 
> Again, exposing __wsum to anything that looks like a stable ABI is
> a mistake - it's an internal detail that can be easily abused,
> causing unpleasant compat problems.

I'll take a look at both, removing the copying and also wrt not breaking
existing users for cascading the helper when fixing.

Thanks,
Daniel
