Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28786628B7F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiKNVoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiKNVoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:44:06 -0500
X-Greylist: delayed 326 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 13:44:04 PST
Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23E7AE03;
        Mon, 14 Nov 2022 13:44:03 -0800 (PST)
Message-ID: <00e8e836-7a5e-3c65-b09b-b1e71d79a6c6@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1668461912;
        bh=CaEb5TL7mi3Z7BL8t/8RHyqhrExer6WZWRCfyITK1C8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=tDBtN0PM1x8QOQ6yKExzpG8AX7MTCVMXcnV/vP9Dbw6MqAKXvoHuWIlZBNPVqd9ue
         dA1szTe4LhYRK9vPuMQCBtsyi9a5I13o6MEBB8RlzmBKzs+WPDWVkuOOePnH86/gjz
         gOylCDAbNNdpebsxs3YDYS8uRG/FaY9Z1C4bHAL4=
Date:   Mon, 14 Nov 2022 22:38:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Regression] Bug 216672 - soft lockup in ieee80211_select_queue
 -- system freezing random time on msi laptop
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, misac1987@gmail.com
References: <83b28e2d-7af7-f91a-7e67-7f224bcf0557@leemhuis.info>
Content-Language: en-US
From:   Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <83b28e2d-7af7-f91a-7e67-7f224bcf0557@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.11.22 09:22, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> I noticed a slightly vague regression report in bugzilla.kernel.org. As
> many (most?) kernel developer don't keep an eye on it, I decided to
> forward it by mail. Quoting from
> https://bugzilla.kernel.org/show_bug.cgi?id=216672 :
> 

I've tried to extrapolate the info in mail/ticket to get something we 
can work with. But the result is insane: The CPU can't get stuck where 
the trace claims it does. Not without some really strange and unlikely 
HW defect.

Based on the loaded modules the issue must be with the rtl8723ae card 
and - according to the bug content - affect at least the kernels 5.19 
and 6.0.6. (which are not supporting wake_tx_queue in 6.0.6)

The core error message from a 6.0.6 (Ubuntu?) kernel is:
   watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [ksoftirqd/1:23]
   RIP: 0010:ieee80211_select_queue+0x1b/0x110 [mac80211]

According to the trace history and the identified driver the problematic 
softirg should be a scheduled run of _rtl_pci_irq_tasklet().
And it looks like a RX packet triggered a TCP RST reply. Which then 
triggered the issue.

I ten checked with a Gentoo 6.0.6 mac80211 module the reference to 
ieee80211_select_queue+0x1b:

And at least in my build that's the local->ops->wake_tx_queue *check* in 
ieee80211_select_queue(). Which of course does not make any sense short 
of some fundamental assumption to be wrong...

185             struct sta_info *sta = NULL;
186             const u8 *ra = NULL;
187             u16 ret;
188
189             /* when using iTXQ, we can do this later */
190             if (local->ops->wake_tx_queue)
191                     return 0;
192

Now my module is for sure far from the original but 
ieee80211_select_queue() looks pretty harmless:
No obvious way how we can get stuck in there...

CPU broken? Strange compiler bug?
Some stupid error from my site reading the trace?

Are the traces all looking the same? Any other strange errors on the system?

And can you verify that the error is indeed a regression by going back 
to a kernel "known" to be not affected in the past?

Other extreme would be to try the wireless development kernel 
git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git 
and hope, that it also shows a more sane problem.
(ieee80211_select_queue() has been dropped, changing the tx flow 
drastically when compared to 6.0.6)

In short, I'm also stuck what that can be. We can try some different 
angles and hope to hit something.


Alexander

