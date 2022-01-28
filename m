Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B679C49FA73
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 14:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiA1NRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 08:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348693AbiA1NRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 08:17:46 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A71C061714;
        Fri, 28 Jan 2022 05:17:46 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nDR8H-0000Yc-Jl; Fri, 28 Jan 2022 14:17:41 +0100
Message-ID: <afaa879e-c888-100e-ff2e-429a2457a014@leemhuis.info>
Date:   Fri, 28 Jan 2022 14:17:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
Content-Language: en-BW
To:     Jakub Kicinski <kuba@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
 <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
 <CAKXUXMygcVJ2v5enu-KY9_2reC6+aAk8F9q5RiwwNp4wO-prug@mail.gmail.com>
 <20220110082949.3a14a738@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220110082949.3a14a738@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1643375866;4d6407e0;
X-HE-SMSGID: 1nDR8H-0000Yc-Jl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.22 17:29, Jakub Kicinski wrote:
> On Mon, 10 Jan 2022 17:19:56 +0100 Lukas Bulwahn wrote:
>> It's a regression if some application or practical use case running fine on one
>> Linux kernel works worse or not at all with a newer version compiled using a
>> similar configuration.
>>
>> The af_unix functionality without oob support works before
>> 314001f0bf92 ("af_unix: Add OOB support").
>> The af_unix functionality without oob support works after 314001f0bf92
>> ("af_unix: Add OOB support").
>> The af_unix with oob support after the new feature with 314001f0bf92
>> ("af_unix: Add OOB support") makes a memory leak visible; we do not
>> know if this feature even triggers it or just makes it visible.
>>
>> Now, if we disable oob support we get a kernel without an observable
>> memory leak. However, oob support is added by default, and this makes
>> this memory leak visible. So, if oob support is turned into a
>> non-default option or nobody ever made use of the oob support before,
>> it really does not count as regression at all. The oob support did not
>> work before and now it works but just leaks a bit of memory---it is
>> potentially a bug, but not a regression. Of course, maybe oob support
>> is also just intended to make this memory leak observable, who knows?
>> Then, it is not even a bug, but a feature.
> I see, thanks for the explanation. It wasn't clear from the "does not
> repro on 5.15, does repro on net-next" type of wording that the repro
> actually uses the new functionality.

Thx from my side, too.

>> Thorsten's database is still quite empty, so let us keep tracking the
>> progress with regzbot. I guess we cannot mark "issues" in regzbot as a
>> true regression or as a bug (an issue that appears with a new
>> feature).

Yeah, I definitely don't want regzbot to be used to track ordinary
issues, but sometimes it's hard to find clear boundaries between issue
and regression. This is one, but I tend to say it's an issue, as users s
won't notice the leak in practice afaics. But there are other areas that
are greyish; an kernel Oops/Warning/BUG or a hang sometimes might also
not strictly be a regression, but I guess tracking them might be a good
idea, so I'm open to those.

Anyway:

>> Also, this reproducer is automatically generated, so it barely
>> qualifies as "some application or practical use case", but at best as
>> some derived "stress test program" or "micro benchmark".

I left it tracked until now, but after Jakub's reply nothing to actually
address the issue seem to have happened. I guess in that case it's not
that important and it's time to remove it from the list of open
regressions tracked by regzbot, if that is okay for everyone:

#regzbot invalid: not strictly a regression

Ciao, Thorsten
