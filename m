Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F1040318F
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 01:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241953AbhIGXgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 19:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhIGXgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 19:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25E1610C8;
        Tue,  7 Sep 2021 23:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631057730;
        bh=vWnttUTlF72LyMrYjIe/78FyUtshVhZy/pfLSh7SFiY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=U6bhbq/e7swGtHS4elAaebisMP4udNQk1DmHur/UmRfOzJP287/22Sl7MnFX2t3m0
         H5mdMXeCMhgSw7InBrFmEYhKNE7fqIYXLp8N57IqHvU+6essRsQUqYeslpAnZ3O2v4
         EfjPXh4NGH5AMFduknEvWv9grbxsdHlyGvHetBy7UxNRcNcGOgvEAzwJNROk6U7HQg
         3HCGqr1MhAm7ZpTuR/80Yj9r4/zqLTlBLBhpvQ4g/X3s7GSTi7X04hnNGoZmr8dp+H
         mQBaVmu19EFA/kLtF85BSAotL0eJB+eYtyzb3tRYt2cXjDyTspNW85j9zAgxqzXbcC
         c8obvu7titLiA==
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org>
Date:   Tue, 7 Sep 2021 16:35:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/2021 4:14 PM, Linus Torvalds wrote:
> There are many more of these cases. I've seen Hyper-V allocate 'struct
> cpumask' on the stack, which is once again an absolute no-no that
> people have apparently just ignored the warning for. When you have
> NR_CPUS being the maximum of 8k, those bits add up, and a single
> cpumask is 1kB in size. Which is why you should never do that on
> stack, and instead use '
> 
>         cpumask_var_t mask;
>         alloc_cpumask_var(&mask,..)
> 
> which will do a much more reasonable job. But the reason I call out
> hyperv is that as far as I know, hyperv itself doesn't actually
> support 8192 CPU's. So all that apic noise with 'struct cpumask' that
> uses 1kB of data when NR_CPUS is set to 8192 is just wasted. Maybe I'm
> wrong. Adding hyperv people to the cc too.

I am only commenting on this because I was looking into an instance of 
this warning yesterday with Fedora's arm64 config, which has 
CONFIG_NR_CPUS=4096:

https://lore.kernel.org/r/YTZyMx91zV9kfDkQ@Ryzen-9-3900X.localdomain/

Won't your example only fix the issue with CONFIG_CPUMASK_OFFSTACK=y or 
am I misreading the gigantic comment in include/linux/cpumask.h? As far 
as I can tell, only x86 selects it and it is not user configurable 
unless CONFIG_DEBUG_PER_CPU_MAPS is set, which is buried in the debug 
options so most people won't bother trying to enable it. If I understand 
correctly, how should these be dealt with in the case of 
CONFIG_CPUMASK_OFFSTACK=n?

Cheers,
Nathan
