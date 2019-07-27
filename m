Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256C977C61
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 01:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfG0XV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 19:21:29 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:57760 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbfG0XV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 19:21:29 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x6RNLNfd017876;
        Sun, 28 Jul 2019 00:21:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=rG9wpH+5dS3XkQEApJKVRr9HxbkNR2gEXf5GRIkYslU=;
 b=UnZPQEVx05ri99X64K8JjBQCWSvmP5n8AMbbJ3Dhj3XkB0TgOfOJgyQ0o5Kzqy5bgGJQ
 Ipq/McamqTVPrDOmvXv72/dP1SR3ZetvEV+yjpYlAgdYLlS7+CIj0L41DBFyitzHYJuz
 vljtxQBVutk0TjiS4vW+tqxJSK12RmnpKO9JQR8J3g8aKerqW7MSCjL9RnwMS5UA0QX/
 LYMpmt/ObIaaIFI5+amuxgrwAL5AzmD0KD1xjRG36jKg7WolfYU2QA+ir7hSqZ4h411y
 b6rZIybM1uCrBltMeDgEiW9AmwnostsoV5Yq8dMisC4Cq6FFKswCIxr5yJeQyzOrfKsX jQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2u0f18ats9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Jul 2019 00:21:23 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x6RNHfoJ016148;
        Sat, 27 Jul 2019 19:21:23 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2u0hxv8jqd-1;
        Sat, 27 Jul 2019 19:21:22 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 544321FC6B;
        Sat, 27 Jul 2019 23:21:22 +0000 (GMT)
Subject: Re: [PATCH] tcp: add new tcp_mtu_probe_floor sysctl
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
References: <1564194225-14342-1-git-send-email-johunt@akamai.com>
 <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <a9ec9cfd-c381-c02e-7d67-e24373c693d6@akamai.com>
Date:   Sat, 27 Jul 2019 16:21:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJtw_XrU-F0-frE=P6egH99kF0W0kTzReK701LmigcJ4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_18:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907270293
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-27_18:2019-07-26,2019-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1907270294
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/19 12:05 AM, Eric Dumazet wrote:
> On Sat, Jul 27, 2019 at 4:23 AM Josh Hunt <johunt@akamai.com> wrote:
>>
>> The current implementation of TCP MTU probing can considerably
>> underestimate the MTU on lossy connections allowing the MSS to get down to
>> 48. We have found that in almost all of these cases on our networks these
>> paths can handle much larger MTUs meaning the connections are being
>> artificially limited. Even though TCP MTU probing can raise the MSS back up
>> we have seen this not to be the case causing connections to be "stuck" with
>> an MSS of 48 when heavy loss is present.
>>
>> Prior to pushing out this change we could not keep TCP MTU probing enabled
>> b/c of the above reasons. Now with a reasonble floor set we've had it
>> enabled for the past 6 months.
> 
> And what reasonable value have you used ???

Reasonable for some may not be reasonable for others hence the new 
sysctl :) We're currently running with a fairly high value based off of 
the v6 min MTU minus headers and options, etc. We went conservative with 
our setting initially as it seemed a reasonable first step when 
re-enabling TCP MTU probing since with no configurable floor we saw a # 
of cases where connections were using severely reduced mss b/c of loss 
and not b/c of actual path restriction. I plan to reevaluate the setting 
at some point, but since the probing method is still the same it means 
the same clients who got stuck with mss of 48 before will land at 
whatever floor we set. Looking forward we are interested in trying to 
improve TCP MTU probing so it does not penalize clients like this.

A suggestion for a more reasonable floor default would be 512, which is 
the same as the min_pmtu. Given both mechanisms are trying to achieve 
the same goal it seems like they should have a similar min/floor.

> 
>>
>> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
>> administrators the ability to control the floor of MSS probing.
>>
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
>> ---
>>   Documentation/networking/ip-sysctl.txt | 6 ++++++
>>   include/net/netns/ipv4.h               | 1 +
>>   net/ipv4/sysctl_net_ipv4.c             | 9 +++++++++
>>   net/ipv4/tcp_ipv4.c                    | 1 +
>>   net/ipv4/tcp_timer.c                   | 2 +-
>>   5 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
>> index df33674799b5..49e95f438ed7 100644
>> --- a/Documentation/networking/ip-sysctl.txt
>> +++ b/Documentation/networking/ip-sysctl.txt
>> @@ -256,6 +256,12 @@ tcp_base_mss - INTEGER
>>          Path MTU discovery (MTU probing).  If MTU probing is enabled,
>>          this is the initial MSS used by the connection.
>>
>> +tcp_mtu_probe_floor - INTEGER
>> +       If MTU probing is enabled this caps the minimum MSS used for search_low
>> +       for the connection.
>> +
>> +       Default : 48
>> +
>>   tcp_min_snd_mss - INTEGER
>>          TCP SYN and SYNACK messages usually advertise an ADVMSS option,
>>          as described in RFC 1122 and RFC 6691.
>> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>> index bc24a8ec1ce5..c0c0791b1912 100644
>> --- a/include/net/netns/ipv4.h
>> +++ b/include/net/netns/ipv4.h
>> @@ -116,6 +116,7 @@ struct netns_ipv4 {
>>          int sysctl_tcp_l3mdev_accept;
>>   #endif
>>          int sysctl_tcp_mtu_probing;
>> +       int sysctl_tcp_mtu_probe_floor;
>>          int sysctl_tcp_base_mss;
>>          int sysctl_tcp_min_snd_mss;
>>          int sysctl_tcp_probe_threshold;
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index 0b980e841927..59ded25acd04 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -820,6 +820,15 @@ static struct ctl_table ipv4_net_table[] = {
>>                  .extra2         = &tcp_min_snd_mss_max,
>>          },
>>          {
>> +               .procname       = "tcp_mtu_probe_floor",
>> +               .data           = &init_net.ipv4.sysctl_tcp_mtu_probe_floor,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dointvec_minmax,
>> +               .extra1         = &tcp_min_snd_mss_min,
>> +               .extra2         = &tcp_min_snd_mss_max,
>> +       },
>> +       {
>>                  .procname       = "tcp_probe_threshold",
>>                  .data           = &init_net.ipv4.sysctl_tcp_probe_threshold,
>>                  .maxlen         = sizeof(int),
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index d57641cb3477..e0a372676329 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -2637,6 +2637,7 @@ static int __net_init tcp_sk_init(struct net *net)
>>          net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
>>          net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
>>          net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
>> +       net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
>>
>>          net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
>>          net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
>> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
>> index c801cd37cc2a..dbd9d2d0ee63 100644
>> --- a/net/ipv4/tcp_timer.c
>> +++ b/net/ipv4/tcp_timer.c
>> @@ -154,7 +154,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
>>          } else {
>>                  mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
>>                  mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
>> -               mss = max(mss, 68 - tcp_sk(sk)->tcp_header_len);
>> +               mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
>>                  mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
>>                  icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
>>          }
> 
> 
> Existing sysctl should be enough ?

I don't think so. Changing tcp_min_snd_mss could impact clients that 
really want/need a small mss. When you added the new sysctl I tried to 
analyze the mss values we're seeing to understand what we could possibly 
raise it to. While not a huge amount, we see more clients than I 
expected announcing mss values in the 180-512 range. Given that I would 
not feel comfortable setting tcp_min_snd_mss to say 512 as I suggested 
above.

> 
> tcp_min_snd_mss  documentation could be slightly updated.
> 
> And maybe its default value could be raised a bit.
> 

Thanks
Josh
