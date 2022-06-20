Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA9551139
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 09:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbiFTHQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 03:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiFTHQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 03:16:39 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE9E0B3;
        Mon, 20 Jun 2022 00:16:35 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1o3BeB-0006ZV-1H; Mon, 20 Jun 2022 09:16:31 +0200
Message-ID: <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
Date:   Mon, 20 Jun 2022 09:16:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Intermittent performance regression related to ipset between 5.10
 and 5.15
Content-Language: en-US
To:     "U'ren, Aaron" <Aaron.U'ren@sony.com>
Cc:     "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
 <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
 <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
 <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
 <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
 <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
 <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1655709396;c96a449e;
X-HE-SMSGID: 1o3BeB-0006ZV-1H
X-Spam-Status: No, score=-1.5 required=5.0 tests=APOSTROPHE_TOCC,BAYES_00,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> On Mon, 30 May 2022, Thorsten Leemhuis wrote:
>> On 04.05.22 21:37, U'ren, Aaron wrote:
>>>  It’s good to have the confirmation about why iptables list/save 
>>> perform so many getsockopt() calls.
> 
> Every set lookups behind "iptables" needs two getsockopt() calls: you can 
> see them in the strace logs. The first one check the internal protocol 
> number of ipset and the second one verifies/gets the processed set (it's 
> an extension to iptables and therefore there's no internal state to save 
> the protocol version number).

Hi Aaron! Did any of the suggestions from Jozsef help to track down the
root case? I have this issue on the list of tracked regressions and
wonder what the status is. Or can I mark this as resolved?

Side note: this is not a "something breaks" regressions and it seems to
progress slowly, so I'm putting it on the backburner:

#regzbot backburner: performance regression where the culprit is hard to
track down

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.

>>>  In terms of providing more information to locate the source of the 
>>> slowdown, do you have any recommendations on what information would be 
>>> helpful?
>>>  The only thing that I was able to think of was doing a git bisect on 
>>> it, but that’s a pretty large range, and the problem isn’t always 100% 
>>> reproducible. It seems like something about the state of the system 
>>> needs to trigger the issue. So that approach seemed non-optimal.
>>>  I’m reasonably certain that if we took enough of our machines back to 
>>> 5.15.16 we could get some of them to evidence the problem again. If we 
>>> reproduced the problem, what types of diagnostics or debug could we 
>>> give you to help further track down this issue?
> 
> In your strace log
> 
> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]) = 0 <0.000024>
> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-DST-VBH27M7NWLDOZIE"..., [40]) = 0 <0.1$
> 0.109456 close(4)                  = 0 <0.000022>
> 
> the only things which happen in the second sockopt function are to lock 
> the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the 
> setname, save the result in the case of a match and unlock the mutex. 
> Nothing complicated, no deep, multi-level function calls. Just a few line 
> of codes which haven't changed.
> 
> The only thing which can slow down the processing is the mutex handling. 
> Don't you have accidentally wait/wound mutex debugging enabled in the 
> kernel? If not, then bisecting the mutex related patches might help.
> 
> You wrote that flushing tables or ipsets didn't seem to help. That 
> literally meant flushing i.e. the sets were emptied but not destroyed? Did 
> you try both destroying or flushing?
> 
>> Jozsef, I still have this issue on my list of tracked regressions and it
>> looks like nothing happens since above mail (or did I miss it?). Could
>> you maybe provide some guidance to Aaron to get us all closer to the
>> root of the problem?
> 
> I really hope it's an accidentally enabled debugging option in the kernel. 
> Otherwise bisecting could help to uncover the issue.
> 
> Best regards,
> Jozsef
> 
>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>> reports and sometimes miss something important when writing mails like
>> this. If that's the case here, don't hesitate to tell me in a public
>> reply, it's in everyone's interest to set the public record straight.
>>
>>
>>> From: Thorsten Leemhuis <regressions@leemhuis.info>
>>> Date: Wednesday, May 4, 2022 at 8:15 AM
>>> To: McLean, Patrick <Patrick.Mclean@sony.com>
>>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel.org>, U'ren, Aaron <Aaron.U'ren@sony.com>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Kadlecsik <kadlec@netfilter.org>
>>> Subject: Re: Intermittent performance regression related to ipset between 5.10 and 5.15
>>> Hi, this is your Linux kernel regression tracker. Top-posting for once,
>>> to make this easily accessible to everyone.
>>>
>>> Patrick, did you see the comment from Jozsef? Are you having trouble
>>> providing additional data or what's the status here from your side? Or
>>> is that something we can forget?
>>>
>>> Ciao, Thorsten
>>>
>>> #regzbot poke
>>>
>>> On 11.04.22 13:47, Jozsef Kadlecsik wrote:
>>>> Hi,
>>>>
>>>> On Mon, 11 Apr 2022, Thorsten Leemhuis wrote:
>>>>
>>>>> On 16.03.22 10:17, Thorsten Leemhuis wrote:
>>>>>> [TLDR: I'm adding the regression report below to regzbot, the Linux
>>>>>> kernel regression tracking bot; all text you find below is compiled from
>>>>>> a few templates paragraphs you might have encountered already already
>>>>>> from similar mails.]
>>>>>>
>>>>>> On 16.03.22 00:15, McLean, Patrick wrote:
>>>>>
>>>>>>> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16) 
>>>>>>> series, we encountered an intermittent performance regression that 
>>>>>>> appears to be related to iptables / ipset. This regression was 
>>>>>>> noticed on Kubernetes hosts that run kube-router and experience a 
>>>>>>> high amount of churn to both iptables and ipsets. Specifically, when 
>>>>>>> we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables 
>>>>>>> wrapper xtables-nft-multi on the 5.15 series kernel, we end up 
>>>>>>> getting extremely laggy response times when iptables attempts to 
>>>>>>> lookup information on the ipsets that are used in the iptables 
>>>>>>> definition. This issue isn’t reproducible on all hosts. However, our 
>>>>>>> experience has been that across a fleet of ~50 hosts we experienced 
>>>>>>> this issue on ~40% of the hosts. When the problem evidences, the time 
>>>>>>> that it takes to run unrestricted iptables list commands like 
>>>>>>> iptables -L or iptables-save gradually increases over the course of 
>>>>>>> about 1 - 2 hours. Growing from less than a second to run, to takin
>>>>>   g sometimes over 2 minutes to run. After that 2 hour mark it seems to 
>>>>>   plateau and not grow any longer. Flushing tables or ipsets doesn’t seem 
>>>>>   to have any affect on the issue. However, rebooting the host does reset 
>>>>>   the issue. Occasionally, a machine that was evidencing the problem may 
>>>>>   no longer evidence it after being rebooted.
>>>>>>>
>>>>>>> We did try to debug this to find a root cause, but ultimately ran 
>>>>>>> short on time. We were not able to perform a set of bisects to 
>>>>>>> hopefully narrow down the issue as the problem isn’t consistently 
>>>>>>> reproducible. We were able to get some straces where it appears that 
>>>>>>> most of the time is spent on getsockopt() operations. It appears that 
>>>>>>> during iptables operations, it attempts to do some work to resolve 
>>>>>>> the ipsets that are linked to the iptables definitions (perhaps 
>>>>>>> getting the names of the ipsets themselves?). Slowly that getsockopt 
>>>>>>> request takes more and more time on affected hosts. Here is an 
>>>>>>> example strace of the operation in question:
>>>>
>>>> Yes, iptables list/save have to get the names of the referenced sets and 
>>>> that is performed via getsockopt() calls.
>>>>
>>>> I went through all of the ipset related patches between 5.10.6 (copy&paste 
>>>> error but just the range is larger) and 5.15.16 and as far as I see none 
>>>> of them can be responsible for the regression. More data is required to 
>>>> locate the source of the slowdown.
>>>>
>>>> Best regards,
>>>> Jozsef
>>>>
>>>>>>>
>>>>>>> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=S_IFREG|0644, st_size=539, ...}, 0) = 0 <0.000017>
>>>>>>> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory) <0.000017>
>>>>>>> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) = 4 <0.000013>
>>>>>>> 0.000034 newfstatat(4, "", {st_mode=S_IFREG|0644, st_size=6108, ...}, AT_EMPTY_PATH) = 0 <0.000009>
>>>>>>> 0.000032 lseek(4, 0, SEEK_SET)     = 0 <0.000008>
>>>>>>> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) = 4096 <0.000010>
>>>>>>> 0.000036 close(4)                  = 0 <0.000008>
>>>>>>> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) = 4096 <0.000028>
>>>>>>> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) = 4 <0.000015>
>>>>>>> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) = 0 <0.000008>
>>>>>>> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]) = 0 <0.000024>
>>>>>>> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-DST-VBH27M7NWLDOZIE"..., [40]) = 0 <0.109384>
>>>>>>> 0.109456 close(4)                  = 0 <0.000022>
>>>>>>>
>>>>>>> On a host that is not evidencing the performance regression we 
>>>>>>> normally see that operation take ~ 0.00001 as opposed to 
>>>>>>> 0.109384.Additionally, hosts that were evidencing the problem we also 
>>>>>>> saw high lock times with `klockstat` (unfortunately at the time we 
>>>>>>> did not know about or run echo "0" > /proc/sys/kernel/kptr_restrict 
>>>>>>> to get the callers of the below commands).
>>>>>>>
>>>>>>> klockstat -i 5 -n 10 (on a host experiencing the problem)
>>>>>>> Caller   Avg Hold  Count   Max hold Total hold
>>>>>>> b'[unknown]'  118490772     83  179899470 9834734132
>>>>>>> b'[unknown]'  118416941     83  179850047 9828606138
>>>>>>> # or somewhere later while iptables -vnL was running:
>>>>>>> Caller   Avg Hold  Count   Max hold Total hold
>>>>>>> b'[unknown]'  496466236     46 17919955720 22837446860
>>>>>>> b'[unknown]'  496391064     46 17919893843 22833988950
>>>>>>>
>>>>>>> klockstat -i 5 -n 10 (on a host not experiencing the problem)
>>>>>>> Caller   Avg Hold  Count   Max hold Total hold
>>>>>>> b'[unknown]'     120316   1510   85537797  181677885
>>>>>>> b'[unknown]'    7119070     24   85527251  170857690
>>>>>>
>>>>>> Hi, this is your Linux kernel regression tracker.
>>>>>>
>>>>>> Thanks for the report.
>>>>>>
>>>>>> CCing the regression mailing list, as it should be in the loop for all
>>>>>> regressions, as explained here:
>>>>>> https://urldefense.com/v3/__https:/www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html__;!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6NoNdYH6BxvEi_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpZdwVIY5$ 
>>>>>>
>>>>>> To be sure below issue doesn't fall through the cracks unnoticed, I'm
>>>>>> adding it to regzbot, my Linux kernel regression tracking bot:
>>>>>>
>>>>>> #regzbot ^introduced v5.10..v5.15
>>>>>> #regzbot title net: netfilter: Intermittent performance regression
>>>>>> related to ipset
>>>>>> #regzbot ignore-activity
>>>>>>
>>>>>> If it turns out this isn't a regression, free free to remove it from the
>>>>>> tracking by sending a reply to this thread containing a paragraph like
>>>>>> "#regzbot invalid: reason why this is invalid" (without the quotes).
>>>>>>
>>>>>> Reminder for developers: when fixing the issue, please add a 'Link:'
>>>>>> tags pointing to the report (the mail quoted above) using
>>>>>> lore.kernel.org/r/, as explained in
>>>>>> 'Documentation/process/submitting-patches.rst' and
>>>>>> 'Documentation/process/5.Posting.rst'. Regzbot needs them to
>>>>>> automatically connect reports with fixes, but they are useful in
>>>>>> general, too.
>>>>>>
>>>>>> I'm sending this to everyone that got the initial report, to make
>>>>>> everyone aware of the tracking. I also hope that messages like this
>>>>>> motivate people to directly get at least the regression mailing list and
>>>>>> ideally even regzbot involved when dealing with regressions, as messages
>>>>>> like this wouldn't be needed then. And don't worry, if I need to send
>>>>>> other mails regarding this regression only relevant for regzbot I'll
>>>>>> send them to the regressions lists only (with a tag in the subject so
>>>>>> people can filter them away). With a bit of luck no such messages will
>>>>>> be needed anyway.
>>>>>>
>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>>>>>
>>>>>> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
>>>>>> reports on my table. I can only look briefly into most of them and lack
>>>>>> knowledge about most of the areas they concern. I thus unfortunately
>>>>>> will sometimes get things wrong or miss something important. I hope
>>>>>> that's not the case here; if you think it is, don't hesitate to tell me
>>>>>> in a public reply, it's in everyone's interest to set the public record
>>>>>> straight.
>>>>>>
>>>>>
>>>>
>>>> -
>>>> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
>>>> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public_key.txt__;fg!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6NoNdYH6BxvEi_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpRHTvk29$ 
>>>> Address : Wigner Research Centre for Physics
>>>>            H-1525 Budapest 114, POB. 49, Hungary
>>>
>>>
>>
> 
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary
