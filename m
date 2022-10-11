Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555405FAEDF
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJKJDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJKJDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:03:38 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865DB78BF9
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 02:03:29 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oiBAb-0003LK-Jg; Tue, 11 Oct 2022 11:03:25 +0200
Message-ID: <acc587a0-2c42-b039-fe2a-48f75e7ed462@leemhuis.info>
Date:   Tue, 11 Oct 2022 11:03:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Fw: [Bug 216557] New: tcp connection not working over ip_vti
 interface #forregzbot
Content-Language: en-US, de-DE
To:     netdev@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20221007141751.1336e50b@hermes.local>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221007141751.1336e50b@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1665479010;069b218f;
X-HE-SMSGID: 1oiBAb-0003LK-Jg
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Hi, this is your Linux kernel regression tracker.

On 07.10.22 23:17, Stephen Hemminger wrote:

> Begin forwarded message:
> 
> Date: Fri, 07 Oct 2022 20:51:12 +0000
> From: bugzilla-daemon@kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 216557] New: tcp connection not working over ip_vti interface
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=216557
> 
>             Bug ID: 216557
>            Summary: tcp connection not working over ip_vti interface
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.15.53
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: monil191989@gmail.com
>         Regression: No
> 
> TCP protocol is not working, when ipsec tunnel has been setup and ip_vti tunnel
> is used for route based ipsec.
> 
> After the below changes merged with latest kernel. xfrm4_policy_check in
> tcp_v4_rcv drops all packets except first syn packet under XfrmInTmplMismatch
> when local destined packets are received over ip_vti tunnel.
> 
> author  Eyal Birger <eyal.birger@gmail.com>     2022-05-13 23:34:02 +0300
> committer       Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2022-05-25
> 09:57:30 +0200
> commit  952c2464963895271c31698970e7ec1ad6f0fe45 (patch)
> tree    9e8300c45a0eb5a9555eae017f8ae561f3e8bc51 /include/net/xfrm.h
> parent  36d8cca5b46fe41b59f8011553495ede3b693703 (diff)
> download        linux-952c2464963895271c31698970e7ec1ad6f0fe45.tar.gz
> xfrm: fix "disable_policy" flag use when arriving from different devices
> 
> 
> setup:
> 1) create road warrior ipsec tunnel with local ip x.x.x.x remote ip y.y.y.y.
> 2) create vti interface using ip tunnel add vti_test local x.x.x.x remote
> y.y.y.y mode vti 
> 3) echo 1 > /proc/sys/net/ipv4/conf/vti_test/disable_policy
> 4) Add default route over vti_test.
> 5) ping remote ip, ping works.
> 6) ssh remote ip, ssh dont work. check tcp connection not working.
> 
> Root cause:
> -> with above mentioned commit, now xfrm4_policy_check depends on skb's  
> IPSKB_NOPOLICY flag which need to be set per skb and it only gets set in
> ip_route_input_noref .
> 
> -> before above change, xfrm4_policy_check was using DST_NOPOLICY which was  
> checked against dst set in skb.
> 
> -> ip_rcv_finish_core calls ip_route_input_noref only if dst is not valid in  
> skb.
> 
> -> By default in kernel sysctl_ip_early_demux = 1, which means when skb with  
> syn is received, tcp stack will set DST from skb to sk and in subsequent
> packets it will copy dst from sk to skb and skip calling ip_route_input_nore
> inside ip_rcv_finish_core.
> 
> -> so for all the subsequent  received packets, IPSKB_NOPOLICY will not get set  
> and they will get drop.
> 
> workaround:
> only work-aroud is to disable early tcp demux.
> echo 0 > /proc/sys/net/ipv4/ip_early_demux

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot introduced e6175a2ed1f1 ^
https://bugzilla.kernel.org/show_bug.cgi?id=216557
#regzbot title [Bug 216557] New: tcp connection not working over ip_vti
interface
#regzbot monitor:
https://lore.kernel.org/all/20221009191643.297623-1-eyal.birger@gmail.com/
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
