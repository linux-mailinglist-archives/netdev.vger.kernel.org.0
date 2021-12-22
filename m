Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC347D273
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 13:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbhLVMuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 07:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbhLVMuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 07:50:14 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E6BC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 04:50:14 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n014K-000732-3z; Wed, 22 Dec 2021 13:50:08 +0100
Message-ID: <24afef0d-84de-5eb7-3a2f-000b3e462278@leemhuis.info>
Date:   Wed, 22 Dec 2021 13:50:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
Content-Language: en-BW
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc:     "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
 <edb8c052-9d20-d190-54e2-ed9bb03ba204@leemhuis.info>
 <b4be04bbd6a20855526b961ef80669bd2647564c.camel@intel.com>
 <ab998a12-9230-04b6-8875-884b9eb1a11e@leemhuis.info>
In-Reply-To: <ab998a12-9230-04b6-8875-884b9eb1a11e@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1640177414;001fa69f;
X-HE-SMSGID: 1n014K-000732-3z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scratch that mail, I was totally wrong, as I accidentally looked at
yesterdays linux-next tree, which due to an error of a local cron job
looked like todays linux-next tree to me.

The real one from today is out now and contains the patch. I apologise
for the noise.

Ciao, Thorsten

On 22.12.21 06:17, Thorsten Leemhuis wrote:
> On 20.12.21 20:56, Nguyen, Anthony L wrote:
>> On Sun, 2021-12-19 at 09:31 +0100, Thorsten Leemhuis wrote:
>>> Hi, this is your Linux kernel regression tracker speaking.
>>>
>>> On 29.11.21 22:14, Heiner Kallweit wrote:
>>>> Recent net core changes caused an issue with few Intel drivers
>>>> (reportedly igb), where taking RTNL in RPM resume path results in a
>>>> deadlock. See [0] for a bug report. I don't think the core changes
>>>> are wrong, but taking RTNL in RPM resume path isn't needed.
>>>> The Intel drivers are the only ones doing this. See [1] for a
>>>> discussion on the issue. Following patch changes the RPM resume
>>>> path
>>>> to not take RTNL.
>>>>
>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>>> [1]
>>>> https://lore.kernel.org/netdev/20211125074949.5f897431@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/t/
>>>>
>>>> Fixes: bd869245a3dc ("net: core: try to runtime-resume detached
>>>> device in __dev_open")
>>>> Fixes: f32a21376573 ("ethtool: runtime-resume netdev parent before
>>>> ethtool ioctl ops")
>>>> Tested-by: Martin Stolpe <martin.stolpe@gmail.com>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>
>>> Long story short: what is taken this fix so long to get mainlined? It
>>> to
>>> me seems progressing unnecessary slow, especially as it's a
>>> regression
>>> that made it into v5.15 and thus for weeks now seems to bug more and
>>> more people.
>>>
>>>
>>> The long story, starting with the background details:
>>>
>>> The quoted patch fixes a regression among others caused by
>>> f32a21376573
>>> ("ethtool: runtime-resume netdev parent before ethtool ioctl ops"),
>>> which got merged for v5.15-rc1.
>>>
>>> The regression ("kernel hangs during power down") was afaik first
>>> reported on Wed, 24 Nov (IOW: nearly a month ago) and forwarded to
>>> the
>>> list shortly afterwards:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>> https://lore.kernel.org/netdev/20211124144505.31e15716@hermes.local/
>>>
>>> The quoted patch to fix the regression was posted on Mon, 29 Nov (thx
>>> Heiner for providing it!). Obviously reviewing patches can take a few
>>> days when they are complicated, as the other messages in this thread
>>> show. But according to
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129#c8 the patch was
>>> ACKed by Thu, 7 Dec. To quote: ```The patch is on its way via the
>>> Intel
>>> network driver tree:
>>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/tnguy/net-queue/+/refs/heads/dev-queue```
>>>
>>> And that's where the patch afaics still is. It hasn't even reached
>>> linux-next yet, unless I'm missing something. A merge into mainline
>>> thus
>>> is not even in sight; this seems especially bad with the holiday
>>> season
>>> coming up, as getting the fix mainlined is a prerequisite to get it
>>> backported to 5.15.y, as our latest stable kernel is affected by
>>> this.
>>
>> I've been waiting for our validation team to get to this patch to do
>> some additional testing. However, as you mentioned, with the holidays
>> coming up, it seems the tester is now out. As it looks like some in the
>> community have been able to do some testing on this, I'll go ahead and
>> send this on.
> 
> Thx. I see the patch now in addition to dev-queue is also in master of
> this repo:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue.git/
> 
> But the fix still didn't make it in todays linux-next. Seems neither
> your master branch nor branches like '1GbE' (which seem to be the ones
> from which such fixes later get send to the net tree) are in linux-next
> afaic.
> 
> Just wondering: Wouldn't it be better if they were? This would allow the
> users of linux-next and CIs checking it to test the fix before it's send
> to the net tree, which last week seems to have happened only a few hours
> (6209dd778f66) before net was merged into mainline (180f3bcfe362).
> 
> Ciao, Thorsten
