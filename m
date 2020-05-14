Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999BD1D3F93
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgENVF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:05:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:53756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgENVF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:05:58 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZL3B-0002Gf-U6; Thu, 14 May 2020 23:05:53 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZL3B-0008J0-Ja; Thu, 14 May 2020 23:05:53 +0200
Subject: Re: [PATCH bpf 3/3] bpf: restrict bpf_trace_printk()'s %s usage and
 add %psK, %psU specifier
To:     Yonghong Song <yhs@fb.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com
References: <20200514161607.9212-1-daniel@iogearbox.net>
 <20200514161607.9212-4-daniel@iogearbox.net>
 <34e9da6e-1f1e-30c2-5863-55f7d8506eb8@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2c8efc5a-cab4-67ff-13f2-aa98f13e9f4b@iogearbox.net>
Date:   Thu, 14 May 2020 23:05:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <34e9da6e-1f1e-30c2-5863-55f7d8506eb8@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25812/Thu May 14 14:13:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 8:10 PM, Yonghong Song wrote:
> On 5/14/20 9:16 AM, Daniel Borkmann wrote:
>> Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
>> very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
>> archs with overlapping address ranges.
>>
>> While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
>> probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
>> an option for bpf_trace_printk() as well to fix it.
>>
>> Similarly as with the helpers, force users to make an explicit choice by adding
>> %psK and %psU specifier to bpf_trace_printk() which will then pick the corresponding
>> strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.
> 
> In bpf_trace_printk(), we only print strings.

Right ...

> In bpf-next bpf_iter bpf_seq_printf() helper, introduced by
> commit 492e639f0c22 ("bpf: Add bpf_seq_printf and bpf_seq_write helpers"), print strings and ip addresses %p{i,I}{4,6}.

... and here only kernel buffers.

> Alan in
> https://lore.kernel.org/bpf/alpine.LRH.2.21.2005141738050.23867@localhost/T
> proposed BTF based type printing with a new format specifier
> %pT, which potentially will be used in bpf_trace_printk() and bpf_seq_printf().
> 
> In the future, we may want to support more %p<...> format in these helpers. I am wondering whether we can have generic way so we only need to change lib/vsprintf.c once.
> 
> Maybe using %pk<...> to specify the kernel address and %pu<...> to
> specify user address space. In the above example, we will have
> %pks, %pus, %pki4 or %pui4, etc. Does this make sense?

Ah, right, once bpf merges back into bpf-next, we should consolidate these. I didn't want
to add the strncpy_from_unsafe*() right into lib/vsprintf.c since then we'd open it up to
all possible call-sites whereas it's really just needed out of bpf_trace_printk() for the
fix. I think it probably might make sense to add a generic lightweight layer to consolidate
all the bpf-related printk handling where we can statically specify a config e.g. as flags
of allowed specifiers which then internally takes care of checking the fmt specifiers for
sanity and does the probe read handling before passing down into lower layers. Thinking of
the case of adding %p{i,I}{4,6} to bpf_trace_printk(), for example, and assuming we'd had
a case where it needs to be probed out of both, then %pk<...> and %pu<...> modifier feels
reasonable indeed. I'll do a v2 to implement %pks and %pus instead.

Thanks,
Daniel
