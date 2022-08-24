Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B392859F87B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbiHXLQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbiHXLQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 07:16:55 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF8D61D7D;
        Wed, 24 Aug 2022 04:16:52 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oQoNN-0004hc-4u; Wed, 24 Aug 2022 13:16:49 +0200
Message-ID: <339e2f94-213c-d707-b792-86d53329b3e5@leemhuis.info>
Date:   Wed, 24 Aug 2022 13:16:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: Commit 'r8152: fix a WOL issue' makes Ethernet port on Lenovo
 Thunderbolt 3 dock go crazy
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <3745745afedb2eff890277041896356149a8f2bf.camel@redhat.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <3745745afedb2eff890277041896356149a8f2bf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1661339814;474960c6;
X-HE-SMSGID: 1oQoNN-0004hc-4u
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

Quick note before the boilerplate: there is another report about issues
caused by cdf0b86b250fd3 also involving a dock, but apparently it's
ignored so far:
https://bugzilla.kernel.org/show_bug.cgi?id=216333

Anyway, moving on:

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

CCing the regression mailing list, as it should be in the loop for all
regressions, as explained here:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

On 23.08.22 11:20, Maxim Levitsky wrote:
> 
> I recently bisected an issue on my Lenovo P1 gen3, which is connected to the Lenovo Thunderbolt 3 dock.
> 
> After I suspend the laptop to ram, the ethernet port led on the dock starts to blink like crazy,
> its peer port on my ethernet switch blinks as well, and eventually the switch stops forwarding packets,
> bringing all my network down.
> 
> Likely the ethernet card in the dock sends some kind of a garbage over the wire.
> 
> Resuming the laptop, "fixes" the issue (leds stops blinking, and the network starts working again
> after a minute or so).
> 
> I also tried to connect the dock directly to my main desktop over a dedicated usb network card
> and try to capture the packets that are sent, but no packets were captured. I will soon retry
> this test with another network card. I did use promicious mode.
> 
> 
> This is the offending commit, and reverting it helps:
> 
> commit cdf0b86b250fd3c1c3e120c86583ea510c52e4ce
> Author: Hayes Wang <hayeswang@realtek.com>
> Date:   Mon Jul 18 16:21:20 2022 +0800
> 
>     r8152: fix a WOL issue
>     
>     This fixes that the platform is waked by an unexpected packet. The
>     size and range of FIFO is different when the device enters S3 state,
>     so it is necessary to correct some settings when suspending.
>     
>     Regardless of jumbo frame, set RMS to 1522 and MTPS to MTPS_DEFAULT.
>     Besides, enable MCU_BORW_EN to update the method of calculating the
>     pointer of data. Then, the hardware could get the correct data.
>     
>     Fixes: 195aae321c82 ("r8152: support new chips")
>     Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>     Link: https://lore.kernel.org/r/20220718082120.10957-391-nic_swsd@realtek.com
>     Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> 
> WOL from dock was enabled in BIOS, but I tested with it disabled as well, and
> no change in behavier.
> 
> Any help is welcome. I can test patches if needed, the laptop currently runs 6.0-rc2
> with this commit reverted.
> 
> When I find some time I can also narrow the change down by reverting only parts
> of the patch.
> 
> Best regards,
> 	Maxim Levitsky
> 


Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced cdf0b86b250fd3c1c3e120c86583ea510c52e4ce
#regzbot title net: r8152: ehernet port on Lenovo Thunderbolt 3 dock
goes crazy
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; above webpage explains why this is
important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
