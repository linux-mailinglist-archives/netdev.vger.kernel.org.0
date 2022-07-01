Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57708562ACC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 07:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiGAFSz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Jul 2022 01:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiGAFSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 01:18:53 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DD1403C;
        Thu, 30 Jun 2022 22:18:51 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o793J-000344-Co; Fri, 01 Jul 2022 07:18:49 +0200
Message-ID: <ba461782-a4a7-87f1-bbd4-74fc403d0bb2@leemhuis.info>
Date:   Fri, 1 Jul 2022 07:18:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Intermittent performance regression related to ipset between 5.10
 and 5.15 #forregzbot
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
 <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
In-Reply-To: <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1656652731;1bf9c0fc;
X-HE-SMSGID: 1o793J-000344-Co
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 16.03.22 10:17, Thorsten Leemhuis wrote:
> [TLDR: I'm adding the regression report below to regzbot, the Linux
> kernel regression tracking bot; all text you find below is compiled from
> a few templates paragraphs you might have encountered already already
> from similar mails.]
> 
> On 16.03.22 00:15, McLean, Patrick wrote:
>> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16) series, we encountered an intermittent performance regression that appears to be related to iptables / ipset. This regression was noticed on Kubernetes hosts that run kube-router and experience a high amount of churn to both iptables and ipsets. Specifically, when we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables wrapper xtables-nft-multi on the 5.15 series kernel, we end up getting extremely laggy response times when iptables attempts to lookup information on the ipsets that are used in the iptables definition. This issue isn’t reproducible on all hosts. However, our experience has been that across a fleet of ~50 hosts we experienced this issue on ~40% of the hosts. When the problem evidences, the time that it takes to run unrestricted iptables list commands like iptables -L or iptables-save gradually increases over the course of about 1 - 2 hours. Growing from less than a second to run, to taking sometimes over 2 minutes to run. After that 2 hour mark it seems to plateau and not grow any longer. Flushing tables or ipsets doesn’t seem to have any affect on the issue. However, rebooting the host does reset the issue. Occasionally, a machine that was evidencing the problem may no longer evidence it after being rebooted.
>>
>> We did try to debug this to find a root cause, but ultimately ran short on time. We were not able to perform a set of bisects to hopefully narrow down the issue as the problem isn’t consistently reproducible. We were able to get some straces where it appears that most of the time is spent on getsockopt() operations. It appears that during iptables operations, it attempts to do some work to resolve the ipsets that are linked to the iptables definitions (perhaps getting the names of the ipsets themselves?). Slowly that getsockopt request takes more and more time on affected hosts. Here is an example strace of the operation in question:
> [...]
> #regzbot ^introduced v5.10..v5.15
> #regzbot title net: netfilter: Intermittent performance regression
> related to ipset
> #regzbot ignore-activity

#regzbot introduced 3976ca101990ca11ddf51f38bec7b86c19d0ca

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
