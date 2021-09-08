Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE394031CD
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 02:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347218AbhIHAQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 20:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233183AbhIHAQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 20:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 008F761106;
        Wed,  8 Sep 2021 00:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631060130;
        bh=mLK2mslF15Ypxz1D2oBb3kEiUHXrHMc9DdR+3MEhRNU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Y8maA05tCVqJ0vKYCiL5aMdQ3MglFAavIv8T21ZT0uDFelPEpMlEEV8uR5VNDzuKy
         noZ4Z5zVh8I1hT2tI8d8gpJyO35gY+anOcUd3Nqgh5SzqpfqbvJDxvuRWi/cRLTvJ8
         R30A+5NjTFQbKWb4f1k0eughlGZ7f5bywy8EwpjmoG9K/sWlhnIqTC1kpeYfEz/IlC
         iT8cJQHkHQIWlKjolGOAqfUgntUUfzM2aqVi3evovuNrKy9MH64aPmHx1AEaHA7T/2
         XJZEcpWsyb14ZTSmSfmTyAZu0Xhi8Ooxc4MLDoOPp4RLljYxq21JGFhWRzJskwywQw
         XF893w6G9g/6A==
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org>
 <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <a2c18c6b-ff13-a887-dd52-4f0aeeb25c27@kernel.org>
Date:   Tue, 7 Sep 2021 17:15:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/2021 4:49 PM, Linus Torvalds wrote:
> On Tue, Sep 7, 2021 at 4:35 PM Nathan Chancellor <nathan@kernel.org> wrote:
>>
>> Won't your example only fix the issue with CONFIG_CPUMASK_OFFSTACK=y
> 
> Yes, but..
> 
>> or am I misreading the gigantic comment in include/linux/cpumask.h?
> 
> you're not misreading the comment, but you are missing this important fact:
> 
>    config NR_CPUS_RANGE_END
>          int
>          depends on X86_64
>          default 8192 if  SMP && CPUMASK_OFFSTACK
>          default  512 if  SMP && !CPUMASK_OFFSTACK
>          default    1 if !SMP
> 
> so basically you can't choose more than 512 CPU's unless
> CPUMASK_OFFSTACK is set.
> 
> Of course, we may have some bug in the Kconfig elsewhere, and I didn't
> check other architectures. So maybe there's some way to work around
> it.

Ah, okay, that is an x86-only limitation so I missed it. I do not think 
there is any bug with that Kconfig logic but it is only used on x86.

> But basically the rule is that CPUMASK_OFFSTACK and NR_CPUS are linked.
> 
> That linkage is admittedly a bit hidden and much too subtle. I think
> the only real reason why it's done that way is because people wanted
> to do test builds with CPUMASK_OFFSTACK even without having to have
> some ludicrous number of NR_CPUS.
> 
> You'll notice that the question "CPUMASK_OFFSTACK" is only enabled if
> DEBUG_PER_CPU_MAPS is true.
> 
> That whole "for debugging" reason made more sense a decade ago when
> this was all new and fancy.
> 
> It might make more sense to do that very explicitly, and make
> CPUMASK_OFFSTACK be just something like
> 
>    config NR_CPUS_RANGE_END
>          def_bool NR_CPUS <= 512
> 
> and get rid of the subtlety and choice in the matter.

Indeed. Grepping around the tree, I see that arc, arm64, ia64, powerpc, 
and sparc64 all support NR_CPUS up to 4096 (8192 for PPC) but none of 
them select CPUMASK_OFFSTACK so it seems like they should test support 
for CPUMASK_OFFSTACK and adopt similar logic to x86 to limit how much 
stack space cpumask variables can use. Like you mentioned, it probably 
has not come up before because most of those are 64-bit platforms that 
have a higher default FRAME_WARN value (and the default NR_CPUS values 
on all of them is small). I only noticed because Fedora sets NR_CPUS to 
4096 for arm64 and has a FRAME_WARN value of 1024, meaning two cpumask 
variables in the same frame puts that frame right at the 1024 limit.

Cheers,
Nathan
