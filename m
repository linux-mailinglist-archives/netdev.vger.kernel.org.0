Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00177486A47
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243149AbiAFTFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:05:39 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.49]:45412 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232414AbiAFTFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:05:38 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.64.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C76D21C0085;
        Thu,  6 Jan 2022 19:05:36 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8E48C7800E6;
        Thu,  6 Jan 2022 19:05:36 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 0C29913C2B1;
        Thu,  6 Jan 2022 11:05:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0C29913C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1641495936;
        bh=TMZJyrA4IBUp4CWg/5rZkuiIp0p7mEwTfmdrPzbUvmM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oMsdxQ5UDxpfj5Y+XVU50tSELkkIqg+8oIDAMlI5OjkPFgXaYl4p3gjol90aIM2/0
         6hjsrbLQuySHkTKfFwPoF/8fk36clB8TzH9DQJ3o/ro98h2zSzDMAlTuL1OZYwa5E2
         95IPuy9XzweEFKy/1m/a2EnphyRll7YLouCVaTEQ=
Subject: Re: Debugging stuck tcp connection across localhost
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
 <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com>
Date:   Thu, 6 Jan 2022 11:05:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1641495937-yxBNkJ5sY-uC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/22 8:16 AM, Neal Cardwell wrote:
> On Thu, Jan 6, 2022 at 10:39 AM Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 1/6/22 7:20 AM, Neal Cardwell wrote:
>>> On Thu, Jan 6, 2022 at 10:06 AM Ben Greear <greearb@candelatech.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> I'm working on a strange problem, and could use some help if anyone has ideas.
>>>>
>>>> On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
>>>> traffic generation on the netdevs, etc), I see cases where two processes trying
>>>> to communicate across localhost with TCP seem to get a stuck network
>>>> connection:
>>>>
>>>> [greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
>>>> tcp        0 7988926 127.0.0.1:4004          127.0.0.1:23184         ESTABLISHED
>>>> tcp        0  59805 127.0.0.1:23184         127.0.0.1:4004          ESTABLISHED
>>>>
>>>> Both processes in question continue to execute, and as far as I can tell, they are properly
>>>> attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
>>>> are non blocking).  If one was stuck not reading, I would expect netstat
>>>> to show bytes in the rcv buffer, but it is zero as you can see above.
>>>>
>>>> Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
>>>> test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
>>>> but my code can grab logs at time it sees the problem.  Is there anything
>>>> more I can do to figure out why the TCP connection appears to be stuck?
>>>
>>> It could be very useful to get more information about the state of all
>>> the stuck connections (sender and receiver side) with something like:
>>>
>>>     ss -tinmo 'sport = :4004 or sport = :4004'
>>>
>>> I would recommend downloading and building a recent version of the
>>> 'ss' tool to maximize the information. Here is a recipe for doing
>>> that:
>>>
>>>    https://github.com/google/bbr/blob/master/Documentation/bbr-faq.md#how-can-i-monitor-linux-tcp-bbr-connections

Hello Neal,

Here is the ss output from when the problem was happening.  I think you can ignore the non-127.0.0.1
connections, but I left them in just in case it is somehow helpful.

In addition, the pcap capture file is uploaded here:

http://www.candelatech.com/downloads/trace-lo-4004.pcap

The problem was happening in this time frame:

[root@ct523c-0bdd ~]# date
Thu 06 Jan 2022 10:14:49 AM PST
[root@ct523c-0bdd ~]# ss -tinmo 'dport = :4004 or sport = :4004'
State       Recv-Q       Send-Q               Local Address:Port                Peer Address:Port 

ESTAB       0            222024                   127.0.0.1:57224                  127.0.0.1:4004         timer:(persist,1min23sec,9)
	 skmem:(r0,rb2000000,t0,tb2000000,f2232,w227144,o0,bl0,d0) ts sack reno wscale:10,4 rto:201 backoff:9 rtt:0.866/0.944 ato:40 mss:65483 pmtu:65535 rcvmss:65483 
advmss:65483 cwnd:10 bytes_sent:36810035 bytes_retrans:22025 bytes_acked:31729223 bytes_received:228063971 segs_out:20134 segs_in:17497 data_segs_out:11969 
data_segs_in:16642 send 6049237875bps lastsnd:3266 lastrcv:125252 lastack:125263 pacing_rate 12093239064bps delivery_rate 130966000000bps delivered:11863 
app_limited busy:275880ms rwnd_limited:21ms(0.0%) retrans:0/2 dsack_dups:2 rcv_rtt:0.671 rcv_space:1793073 rcv_ssthresh:934517 notsent:222024 minrtt:0.013
ESTAB       0            0                   192.168.200.34:4004              192.168.200.34:16906
	 skmem:(r0,rb19521831,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:10,10 rto:201 rtt:0.483/0.64 ato:40 mss:22016 pmtu:65535 rcvmss:65483 advmss:65483 
cwnd:5 ssthresh:5 bytes_sent:8175956 bytes_retrans:460 bytes_acked:8174668 bytes_received:20820708 segs_out:3635 segs_in:2491 data_segs_out:2377 
data_segs_in:2330 send 1823271222bps lastsnd:125253 lastrcv:125250 lastack:125251 pacing_rate 2185097952bps delivery_rate 70451200000bps delivered:2372 
busy:14988ms rwnd_limited:1ms(0.0%) retrans:0/5 rcv_rtt:1.216 rcv_space:779351 rcv_ssthresh:9759798 minrtt:0.003
ESTAB       0            139656              192.168.200.34:16908             192.168.200.34:4004         timer:(persist,1min52sec,2)
	 skmem:(r0,rb2000000,t0,tb2000000,f3960,w143496,o0,bl0,d0) ts sack reno wscale:10,10 rto:37397 backoff:2 rtt:4182.62/8303.35 ato:40 mss:65483 pmtu:65535 
rcvmss:22016 advmss:65483 cwnd:10 bytes_sent:22351275 bytes_retrans:397320 bytes_acked:20703982 bytes_received:7815946 segs_out:2585 segs_in:3642 
data_segs_out:2437 data_segs_in:2355 send 1252479bps lastsnd:7465 lastrcv:125250 lastack:125253 pacing_rate 2504952bps delivery_rate 15992bps delivered:2357 
busy:271236ms retrans:0/19 rcv_rtt:0.004 rcv_space:288293 rcv_ssthresh:43690 notsent:139656 minrtt:0.004
ESTAB       0            460                 192.168.200.34:4004              192.168.200.34:16908        timer:(on,1min23sec,9)
	 skmem:(r0,rb9433368,t0,tb2626560,f2356,w1740,o0,bl0,d0) ts sack reno wscale:10,10 rto:102912 backoff:9 rtt:0.741/1.167 ato:40 mss:22016 pmtu:65535 
rcvmss:65483 advmss:65483 cwnd:1 ssthresh:2 bytes_sent:7850211 bytes_retrans:33437 bytes_acked:7815486 bytes_received:20703981 segs_out:3672 segs_in:2504 
data_segs_out:2380 data_segs_in:2356 send 237689609bps lastsnd:19753 lastrcv:158000 lastack:125250 pacing_rate 854817384bps delivery_rate 115645432bps 
delivered:2355 busy:200993ms unacked:1 retrans:0/24 lost:1 rcv_rtt:1.439 rcv_space:385874 rcv_ssthresh:4715943 minrtt:0.003
ESTAB       0            147205              192.168.200.34:16906             192.168.200.34:4004         timer:(persist,1min46sec,9)
	 skmem:(r0,rb2000000,t0,tb2000000,f507,w151045,o0,bl0,d0) ts sack reno wscale:10,10 rto:223 backoff:9 rtt:11.4/18.962 ato:40 mss:65483 pmtu:65535 rcvmss:22016 
advmss:65483 cwnd:10 bytes_sent:23635760 bytes_retrans:220124 bytes_acked:20820709 bytes_received:8174668 segs_out:2570 segs_in:3625 data_segs_out:2409 
data_segs_in:2371 send 459529825bps lastsnd:7465 lastrcv:125253 lastack:125250 pacing_rate 918999184bps delivery_rate 43655333328bps delivered:2331 app_limited 
busy:185315ms retrans:0/14 rcv_rtt:0.005 rcv_space:220160 rcv_ssthresh:43690 notsent:147205 minrtt:0.003
ESTAB       0            3928980                  127.0.0.1:4004                   127.0.0.1:57224        timer:(persist,7.639ms,8)
	 skmem:(r0,rb50000000,t0,tb3939840,f108,w4005780,o0,bl0,d3) ts sack reno wscale:4,10 rto:251 backoff:8 rtt:13.281/25.84 ato:40 mss:65483 pmtu:65535 
rcvmss:65483 advmss:65483 cwnd:10 ssthresh:10 bytes_sent:312422779 bytes_retrans:245567 bytes_acked:228063971 bytes_received:31729222 segs_out:18944 
segs_in:20021 data_segs_out:18090 data_segs_in:11862 send 394446201bps lastsnd:56617 lastrcv:125271 lastack:125252 pacing_rate 709983112bps delivery_rate 
104772800000bps delivered:16643 app_limited busy:370468ms rwnd_limited:127ms(0.0%) retrans:0/26 rcv_rtt:7666.22 rcv_space:2279928 rcv_ssthresh:24999268 
notsent:3928980 minrtt:0.003
[root@ct523c-0bdd ~]# date
Thu 06 Jan 2022 10:14:57 AM PST
[root@ct523c-0bdd ~]# ss -tinmo 'dport = :4004 or sport = :4004'
State       Recv-Q       Send-Q               Local Address:Port                Peer Address:Port 

ESTAB       0            222208                   127.0.0.1:57224                  127.0.0.1:4004         timer:(persist,1min11sec,9)
	 skmem:(r0,rb2000000,t0,tb2000000,f2048,w227328,o0,bl0,d0) ts sack reno wscale:10,4 rto:201 backoff:9 rtt:0.866/0.944 ato:40 mss:65483 pmtu:65535 rcvmss:65483 
advmss:65483 cwnd:10 bytes_sent:36941001 bytes_retrans:22025 bytes_acked:31729223 bytes_received:228063971 segs_out:20136 segs_in:17497 data_segs_out:11971 
data_segs_in:16642 send 6049237875bps lastsnd:2663 lastrcv:136933 lastack:136944 pacing_rate 12093239064bps delivery_rate 130966000000bps delivered:11863 
app_limited busy:287561ms rwnd_limited:21ms(0.0%) retrans:0/2 dsack_dups:2 rcv_rtt:0.671 rcv_space:1793073 rcv_ssthresh:934517 notsent:222208 minrtt:0.013
ESTAB       0            0                   192.168.200.34:4004              192.168.200.34:16906
	 skmem:(r0,rb19521831,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:10,10 rto:201 rtt:0.483/0.64 ato:40 mss:22016 pmtu:65535 rcvmss:65483 advmss:65483 
cwnd:5 ssthresh:5 bytes_sent:8175956 bytes_retrans:460 bytes_acked:8174668 bytes_received:20820708 segs_out:3635 segs_in:2491 data_segs_out:2377 
data_segs_in:2330 send 1823271222bps lastsnd:136934 lastrcv:136931 lastack:136932 pacing_rate 2185097952bps delivery_rate 70451200000bps delivered:2372 
busy:14988ms rwnd_limited:1ms(0.0%) retrans:0/5 rcv_rtt:1.216 rcv_space:779351 rcv_ssthresh:9759798 minrtt:0.003
ESTAB       0            139656              192.168.200.34:16908             192.168.200.34:4004         timer:(persist,1min40sec,2)
	 skmem:(r0,rb2000000,t0,tb2000000,f3960,w143496,o0,bl0,d0) ts sack reno wscale:10,10 rto:37397 backoff:2 rtt:4182.62/8303.35 ato:40 mss:65483 pmtu:65535 
rcvmss:22016 advmss:65483 cwnd:10 bytes_sent:22351275 bytes_retrans:397320 bytes_acked:20703982 bytes_received:7815946 segs_out:2585 segs_in:3642 
data_segs_out:2437 data_segs_in:2355 send 1252479bps lastsnd:19146 lastrcv:136931 lastack:136934 pacing_rate 2504952bps delivery_rate 15992bps delivered:2357 
busy:282917ms retrans:0/19 rcv_rtt:0.004 rcv_space:288293 rcv_ssthresh:43690 notsent:139656 minrtt:0.004
ESTAB       0            460                 192.168.200.34:4004              192.168.200.34:16908        timer:(on,1min11sec,9)
	 skmem:(r0,rb9433368,t0,tb2626560,f2356,w1740,o0,bl0,d0) ts sack reno wscale:10,10 rto:102912 backoff:9 rtt:0.741/1.167 ato:40 mss:22016 pmtu:65535 
rcvmss:65483 advmss:65483 cwnd:1 ssthresh:2 bytes_sent:7850211 bytes_retrans:33437 bytes_acked:7815486 bytes_received:20703981 segs_out:3672 segs_in:2504 
data_segs_out:2380 data_segs_in:2356 send 237689609bps lastsnd:31434 lastrcv:169681 lastack:136931 pacing_rate 854817384bps delivery_rate 115645432bps 
delivered:2355 busy:212674ms unacked:1 retrans:0/24 lost:1 rcv_rtt:1.439 rcv_space:385874 rcv_ssthresh:4715943 minrtt:0.003
ESTAB       0            147205              192.168.200.34:16906             192.168.200.34:4004         timer:(persist,1min35sec,9)
	 skmem:(r0,rb2000000,t0,tb2000000,f507,w151045,o0,bl0,d0) ts sack reno wscale:10,10 rto:223 backoff:9 rtt:11.4/18.962 ato:40 mss:65483 pmtu:65535 rcvmss:22016 
advmss:65483 cwnd:10 bytes_sent:23635760 bytes_retrans:220124 bytes_acked:20820709 bytes_received:8174668 segs_out:2570 segs_in:3625 data_segs_out:2409 
data_segs_in:2371 send 459529825bps lastsnd:19146 lastrcv:136934 lastack:136931 pacing_rate 918999184bps delivery_rate 43655333328bps delivered:2331 app_limited 
busy:196996ms retrans:0/14 rcv_rtt:0.005 rcv_space:220160 rcv_ssthresh:43690 notsent:147205 minrtt:0.003
ESTAB       0            3928980                  127.0.0.1:4004                   127.0.0.1:57224        timer:(persist,1min57sec,9)
	 skmem:(r0,rb50000000,t0,tb3939840,f108,w4005780,o0,bl0,d3) ts sack reno wscale:4,10 rto:251 backoff:9 rtt:13.281/25.84 ato:40 mss:65483 pmtu:65535 
rcvmss:65483 advmss:65483 cwnd:10 ssthresh:10 bytes_sent:312488262 bytes_retrans:245567 bytes_acked:228063971 bytes_received:31729222 segs_out:18945 
segs_in:20021 data_segs_out:18091 data_segs_in:11862 send 394446201bps lastsnd:2762 lastrcv:136952 lastack:136933 pacing_rate 709983112bps delivery_rate 
104772800000bps delivered:16643 app_limited busy:382149ms rwnd_limited:127ms(0.0%) retrans:0/26 rcv_rtt:7666.22 rcv_space:2279928 rcv_ssthresh:24999268 
notsent:3928980 minrtt:0.003
[root@ct523c-0bdd ~]#


We can reproduce this readily at current, and I'm happy to try patches and/or do more debugging.  We also tried with a 5.12 kernel,
and saw same problems, but in all cases, we have local patches applied, and there is no way for us to do this test without
at least a fair bit of local patches applied.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
