Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B657A48FC25
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 11:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiAPKS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 05:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiAPKS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 05:18:58 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C56C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 02:18:57 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n92cf-0002Co-0Q; Sun, 16 Jan 2022 11:18:53 +0100
Message-ID: <221e1da9-e1c4-10ee-332a-117dee0d913d@leemhuis.info>
Date:   Sun, 16 Jan 2022 11:18:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: xfrm regression: TCP MSS calculation broken by commit b515d263,
 results in TCP stall
Content-Language: en-BW
To:     Jiri Bohac <jbohac@suse.cz>, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1642328337;ceb021c3;
X-HE-SMSGID: 1n92cf-0002Co-0Q
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: I'm adding this regression to regzbot, the Linux kernel
regression tracking bot; most text you find below is compiled from a few
templates paragraphs some of you might have seen already.]

Top-posting for once, to make this easy accessible to everyone.

On 14.01.22 18:31, Jiri Bohac wrote:
> 
> our customer found that commit
> b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
> should return at least 1280 for ipv6") in v5.14 breaks the TCP
> MSS calculation in ipsec transport mode, resulting complete
> stalls of TCP connections. This happens when the (P)MTU is 1280
> or slighly larger.
> 
> The desired formula for the MSS is:
> 	MSS = (MTU - ESP_overhead) - IP header - TCP header
> 
> However, the above patch clamps the (MTU - ESP_overhead) to a
> minimum of 1280, turning the formula into
> 	MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header
> 
> With the (P)MTU near 1280, the calculated MSS is too large and
> the resulting TCP packets never make it to the destination
> because they are over the actual PMTU.
> 
> Trying to fix the exact same problem as the broken patch, which I
> was unaware of, I sent an alternative patch in this thread of
> April 2021:
> https://lore.kernel.org/netdev/20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz/
> (note the v1 is broken and followed by v2!)
> 
> In that thread I also found other problems with
> b515d2637276a3810d6595e10ab02c13bfd0b63a - in tunnel mode it
> causes suboptimal double fragmentation:
> https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/
> 
> I therefore propose to revert
> b515d2637276a3810d6595e10ab02c13bfd0b63a and
> apply the v2 version of my patch, which I'll re-send in reply to
> this e-mail.

Thanks for the report.

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced b515d2637276a3810d6595e10ab02c13bfd0b63a
#regzbot title xfrm: TCP MSS calculation broken by commit b515d263,
results in TCP stall
#regzbot ignore-activity

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail) using the kernel.org redirector,
as explained in 'Documentation/process/submitting-patches.rst'. Regzbot
then will automatically mark the regression as resolved once the fix
lands in the appropriate tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply, that's in everyone's interest.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c

