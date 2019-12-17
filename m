Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E38123AFB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfLQXh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:37:58 -0500
Received: from www62.your-server.de ([213.133.104.62]:45226 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLQXh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:37:57 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihMPa-0007cg-DR; Wed, 18 Dec 2019 00:37:54 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihMPa-000NWh-22; Wed, 18 Dec 2019 00:37:54 +0100
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box>
 <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
 <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
 <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
 <e569134e-68a9-9c69-e894-b21640334bb0@iogearbox.net>
 <20191217201613.iccqsqwuhitsyqyl@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6be56761-5e4c-2922-bd93-761c0dbd773f@iogearbox.net>
Date:   Wed, 18 Dec 2019 00:37:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191217201613.iccqsqwuhitsyqyl@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 9:16 PM, Alexei Starovoitov wrote:
> On Tue, Dec 17, 2019 at 08:50:31PM +0100, Daniel Borkmann wrote:
>>>
>>> Yes, name collision is a possibility, which means users should
>>> restrain from using LINUX_KERNEL_VERSION and CONFIG_XXX names for
>>> their variables. But if that is ever actually the problem, the way to
>>> resolve this collision/ambiguity would be to put externs in a separate
>>> sections. It's possible to annotate extern variable with custom
>>> section.
>>>
>>> But I guess putting Kconfig-provided externs into ".extern.kconfig"
>>> might be a good idea, actually. That will make it possible to have
>>> writable externs in the future.
>>
>> Yep, and as mentioned it will make it more clear that these get special
>> loader treatment as opposed to regular externs we need to deal with in
>> future. A '.extern.kconfig' section sounds good to me and the BPF helper
>> header could provide a __kconfig annotation for that as well.
> 
> I think annotating all extern vars into special section name will be quite
> cumbersome from bpf program writer pov.
> imo capital case extern variables LINUX_KERNEL_VERSION and CONFIG_XXX are
> distinct enough and make it clear they should come from something other than
> normal C. Traditional C coding style uses all capital letters for macroses. So
> all capital extern variables are unlikely to conflict with any normal extern
> vars. Like vars in vmlinux and vars in other bpf elf files.

But still, how many of the LINUX_KERNEL_VERSION or CONFIG_XXX vars are actually
used per program. I bet just a handful. And I don't think adding a __kconfig is
cumbersome, it would make it more self-documenting in fact, denoting that this
var is not treated the usual way once prog linking is in place. Even if all
capital letters. Tomorrow, we'd be adding 'extern unsigned long jiffies' as
another potential example, and then it gets even more confusing on the 'collision'
side with regular BPF ELF. Same here, instead of __kconfig, this could have a
__vmlinux or __kernel annotation in order to document its source for the loader
(and developer) more clearly and also gives flexibility wrt ".extern.xyz"
subsections on how we want to map them.
