Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD7781DC
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 23:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfG1VcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 17:32:10 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:31070 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfG1VcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 17:32:10 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6SLVssd025053;
        Sun, 28 Jul 2019 22:32:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=vXeSUzKExp7oiAa0kC7JmwY3XAdAxGd1fpVmMZ3gIQk=;
 b=CXR+JILwPLaCyCw0y4kDm9Tqw2jiy56o4o70kX7q8YfvObg55JwSfuXp9PQxSQssd6Zb
 pt/r745LeOuyCAIZPU9Mto+pjflemDFne0VMnllVSTyWtD6iUJ/XBVOOE7eWXZiQQdIW
 WSSrwDuofCjfRm+pA4Ulc+oyw0xFkfYHwz2GkK5zwVdPIbXlrBuX/YXML2C0pUwdzFh1
 JVlcieyBmOHBfxsD2KGx6i/J/o0AHrxFPJbNDmAhYnM+8Ky++NHmW8UGVHGdwgo/r/b+
 vhNZ8cfmG7VQzhUW7wx+HV/PYljE4Gv5feq3lyakZIF5NmQgv1L3lbQi7D+Hw8BNWzDQ XQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2u0e8ve1jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jul 2019 22:32:06 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x6SLVmF8016574;
        Sun, 28 Jul 2019 17:32:05 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2u0hxv9f6g-1;
        Sun, 28 Jul 2019 17:32:05 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id F24392293E;
        Sun, 28 Jul 2019 21:32:04 +0000 (GMT)
Subject: Re: [PATCH] tcp: add new tcp_mtu_probe_floor sysctl
From:   Josh Hunt <johunt@akamai.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
References: <1564194225-14342-1-git-send-email-johunt@akamai.com>
 <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com>
 <a9ec9cfd-c381-c02e-7d67-e24373c693d6@akamai.com>
 <CANn89iLqeixzZkop8tqOQka_9ZiKurZL9Vj05bgU99M5Pbenqw@mail.gmail.com>
 <5a054ca5-4077-5e91-69d5-f1add8dc8bfa@akamai.com>
Message-ID: <ee60e78b-993d-f7cc-6cf1-eea7a6e98c8a@akamai.com>
Date:   Sun, 28 Jul 2019 14:32:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5a054ca5-4077-5e91-69d5-f1add8dc8bfa@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-28_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907280268
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-28_15:2019-07-26,2019-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1907280268
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/19 2:14 PM, Josh Hunt wrote:
> On 7/28/19 6:54 AM, Eric Dumazet wrote:
>> On Sun, Jul 28, 2019 at 1:21 AM Josh Hunt <johunt@akamai.com> wrote:
>>>
>>> On 7/27/19 12:05 AM, Eric Dumazet wrote:
>>>> On Sat, Jul 27, 2019 at 4:23 AM Josh Hunt <johunt@akamai.com> wrote:
>>>>>
>>>>> The current implementation of TCP MTU probing can considerably
>>>>> underestimate the MTU on lossy connections allowing the MSS to get 
>>>>> down to
>>>>> 48. We have found that in almost all of these cases on our networks 
>>>>> these
>>>>> paths can handle much larger MTUs meaning the connections are being
>>>>> artificially limited. Even though TCP MTU probing can raise the MSS 
>>>>> back up
>>>>> we have seen this not to be the case causing connections to be 
>>>>> "stuck" with
>>>>> an MSS of 48 when heavy loss is present.
>>>>>
>>>>> Prior to pushing out this change we could not keep TCP MTU probing 
>>>>> enabled
>>>>> b/c of the above reasons. Now with a reasonble floor set we've had it
>>>>> enabled for the past 6 months.
>>>>
>>>> And what reasonable value have you used ???
>>>
>>> Reasonable for some may not be reasonable for others hence the new
>>> sysctl :) We're currently running with a fairly high value based off of
>>> the v6 min MTU minus headers and options, etc. We went conservative with
>>> our setting initially as it seemed a reasonable first step when
>>> re-enabling TCP MTU probing since with no configurable floor we saw a #
>>> of cases where connections were using severely reduced mss b/c of loss
>>> and not b/c of actual path restriction. I plan to reevaluate the setting
>>> at some point, but since the probing method is still the same it means
>>> the same clients who got stuck with mss of 48 before will land at
>>> whatever floor we set. Looking forward we are interested in trying to
>>> improve TCP MTU probing so it does not penalize clients like this.
>>>
>>> A suggestion for a more reasonable floor default would be 512, which is
>>> the same as the min_pmtu. Given both mechanisms are trying to achieve
>>> the same goal it seems like they should have a similar min/floor.
>>>
>>>>
>>>>>
>>>>> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
>>>>> administrators the ability to control the floor of MSS probing.
>>>>>
>>>>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>>>>> ---
>>>>>    Documentation/networking/ip-sysctl.txt | 6 ++++++
>>>>>    include/net/netns/ipv4.h               | 1 +
>>>>>    net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
>>>>>    net/ipv4/tcp_ipv4.c                    | 1 +
>>>>>    net/ipv4/tcp_timer.c                   | 2 +-
>>>>>    5 files changed, 18 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/networking/ip-sysctl.txt 
>>>>> b/Documentation/networking/ip-sysctl.txt
>>>>> index df33674799b5..49e95f438ed7 100644
>>>>> --- a/Documentation/networking/ip-sysctl.txt
>>>>> +++ b/Documentation/networking/ip-sysctl.txt
>>>>> @@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
>>>>>           Path MTU discovery (MTU probing).  If MTU probing is 
>>>>> enabled,
>>>>>           this is the initial MSS used by the connection.
>>>>>
>>>>> +tcp_mtu_probe_floor - INTEGER
>>>>> +       If MTU probing is enabled this caps the minimum MSS used 
>>>>> for search_low
>>>>> +       for the connection.
>>>>> +
>>>>> +       Default : 48
>>>>> +
>>>>>    tcp_min_snd_mss - INTEGER
>>>>>           TCP SYN and SYNACK messages usually advertise an ADVMSS 
>>>>> option,
>>>>>           as described in RFC 1122 and RFC 6691.
>>>>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>>>>> index bc24a8ec1ce5..c0c0791b1912 100644
>>>>> --- a/include/net/netns/ipv4.h
>>>>> +++ b/include/net/netns/ipv4.h
>>>>> @@ -116,6 +116,7 @@ struct netns_ipv4 {
>>>>>           int sysctl_tcp_l3mdev_accept;
>>>>>    #endif
>>>>>           int sysctl_tcp_mtu_probing;
>>>>> +       int sysctl_tcp_mtu_probe_floor;
>>>>>           int sysctl_tcp_base_mss;
>>>>>           int sysctl_tcp_min_snd_mss;
>>>>>           int sysctl_tcp_probe_threshold;
>>>>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>>>>> index 0b980e841927..59ded25acd04 100644
>>>>> --- a/net/ipv4/sysctl_net_ipv4.c
>>>>> +++ b/net/ipv4/sysctl_net_ipv4.c
>>>>> @@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
>>>>>                   .extra2         = &tcp_min_snd_mss_max,
>>>>>           },
>>>>>           {
>>>>> +               .procname       = "tcp_mtu_probe_floor",
>>>>> +               .data           = 
>>>>> &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
>>>>> +               .maxlen         = sizeof(int),
>>>>> +               .mode           = 0644,
>>>>> +               .proc_handler   = proc_dointvec_minmax,
>>>>> +               .extra1         = &tcp_min_snd_mss_min,
>>>>> +               .extra2         = &tcp_min_snd_mss_max,
>>>>> +       },
>>>>> +       {
>>>>>                   .procname       = "tcp_probe_threshold",
>>>>>                   .data           = 
>>>>> &init_net.ipv4.sysctl_tcp_probe_threshold,
>>>>>                   .maxlen         = sizeof(int),
>>>>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>>>>> index d57641cb3477..e0a372676329 100644
>>>>> --- a/net/ipv4/tcp_ipv4.c
>>>>> +++ b/net/ipv4/tcp_ipv4.c
>>>>> @@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net 
>>>>> *net)
>>>>>           net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>>>>>           net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>>>>>           net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>>>>> +       net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
>>>>>
>>>>>           net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>>>>>           net->ipv4.sysctl_tcp_keepalive_probes = 
>>>>> TCP_KEEPALIVE_PROBES;
>>>>> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
>>>>> index c801cd37cc2a..dbd9d2d0ee63 100644
>>>>> --- a/net/ipv4/tcp_timer.c
>>>>> +++ b/net/ipv4/tcp_timer.c
>>>>> @@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct 
>>>>> inet_connection_sock *icsk, struct sock *sk)
>>>>>           } else {
>>>>>                   mss = tcp_mtu_to_mss(sk, 
>>>>> icsk->icsk_mtup.search_low) >> 1;
>>>>>                   mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
>>>>> -               mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
>>>>> +               mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
>>>>>                   mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
>>>>>                   icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, 
>>>>> mss);
>>>>>           }
>>>>
>>>>
>>>> Existing sysctl should be enough ?
>>>
>>> I don't think so. Changing tcp_min_snd_mss could impact clients that
>>> really want/need a small mss. When you added the new sysctl I tried to
>>> analyze the mss values we're seeing to understand what we could possibly
>>> raise it to. While not a huge amount, we see more clients than I
>>> expected announcing mss values in the 180-512 range. Given that I would
>>> not feel comfortable setting tcp_min_snd_mss to say 512 as I suggested
>>> above.
>>
>> If these clients need mss values in 180-512 ranges, how MTU probing
>> would work for them,
>> if you set a floor to 512 ?
> 
> First, we already seem to be fine with ignoring these paths with ICMP 
> based PMTU discovery b/c of our min_pmtu default of 512 and that is 
> configurable. Second by adding this sysctl we're giving administrators 
> the choice to decide if they'd like to attempt to support these very 
> very small # of paths which may be below 512 (MSS <= 512 does not mean 
> MTU <= 512) or cover themselves by being able to raise the floor to not 
> penalize clients who may be on very lossy networks.
> 
>>
>> Are we sure the intent of tcp_base_mss was not to act as a floor ?
> 
> My understanding is that tcp_base_mss is meant to be the initial value 
> of search_low (as per Docs). Then in RFC 4821 [1] Sections 7.2, shows 
> search_low should be configurable, and 7.7 we see that in response to 
> successive black hole detection search_low should be halved. So I don't 
> think it was meant to be a floor, but just the initial search_low param. 
> Also note that in that same section they suggest a floor of 68 for v4, 
> but a floor of 1280 for v6 which we do not adhere to currently.
> 

Clarification. We == Akamai in regards to setting tcp_base_mss to 
1400-overheads. Upstream default is 1024.

> We actually set tcp_base_mss to something close to the value suggested 
> towards the end of section 7.2 of the RFC of 1400 bytes minus IP and 
> Transport overheads and options. This way we have more realistic 
> searching based on the majority of clients that we see. The kernel winds 
> up using initial search_low/tcp_base_mss as initial eff_pmtu, so we see 
> something like:
> 
> 21:03:41.314612 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:41.670307 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:42.030308 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:42.534307 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:43.198308 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:44.478307 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [P.], seq 
> 1:1461, ack 1, win 229, length 1460: HTTP
> 21:03:47.742310 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [.], seq 
> 1:1349, ack 1, win 229, length 1348: HTTP
> 21:03:56.702310 IP 192.168.0.1.8080 > 192.0.2.1.41523: Flags [.], seq 
> 1:675, ack 1, win 229, length 674: HTTP
> 
> For further evidence this is a real problem here's a sample of mss 
> values I found when originally investigating this problem for us:
> 
> I dug up some #s I found when originally investigating this problem:
> 
> # ss -emoitn | grep mss | sed "s/.*mss:\([0-9]*\).*/\1/" | sort -u | 
> sort -g | head -5
> 
> 36:11
> 64:7
> 72:1
> 128:13
> 144:4
> 
>  From what I could tell these connections were on paths much larger than 
> the mss they were being forced to use. I determined this by looking at 
> the mss used for other objects fetched from the same IPs.
> 
> Josh
> 
> [1] - https://www.ietf.org/rfc/rfc4821.txt
> 
>>
>> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
>> index 
>> c801cd37cc2a9c11f2dd4b9681137755e501a538..6d15895e9dcfb2eff51bbcf3608c7e68c1970a9e 
>>
>> 100644
>> --- a/net/ipv4/tcp_timer.c
>> +++ b/net/ipv4/tcp_timer.c
>> @@ -153,7 +153,7 @@ static void tcp_mtu_probing(struct
>> inet_connection_sock *icsk, struct sock *sk)
>>                  icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
>>          } else {
>>                  mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) 
>> >> 1;
>> -               mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
>> +               mss = max(net->ipv4.sysctl_tcp_base_mss, mss);
>>                  mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
>>                  mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
>>                  icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
>>
>>
>>
>>>
>>>>
>>>> tcp_min_snd_mss  documentation could be slightly updated.
>>>>
>>>> And maybe its default value could be raised a bit.
>>>>
>>>
>>> Thanks
>>> Josh
