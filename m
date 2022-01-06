Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDD3486700
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbiAFPqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:46:17 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39042 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240699AbiAFPqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:46:09 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 10:46:08 EST
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CB4122454EA
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 15:39:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.28])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 90E9420074;
        Thu,  6 Jan 2022 15:39:04 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 43FB03800A0;
        Thu,  6 Jan 2022 15:39:04 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 65A9113C2B0;
        Thu,  6 Jan 2022 07:39:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 65A9113C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1641483543;
        bh=dPYWdrWh3HrHP0PFktguMeHByWr/9i1b+JUMiuF79tc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=amKNGgcokCmCVg+SevGq46onKeOFZhAdg+S4TuYce0csdPP/3fzsIDP3qIGE1URC4
         Kv1ayXJPFT3zL3PXHkjD7DEkfQjsEMJYqt5iuo7/82VZ2fVM2JkMRLNMREZOF6ip0V
         5rIMKewlQQUJ+mZ2oH0UegfbNRjIwVin34BlO7MY=
Subject: Re: Debugging stuck tcp connection across localhost
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
Date:   Thu, 6 Jan 2022 07:39:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1641483545-HLDTg-RtUUW2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/22 7:20 AM, Neal Cardwell wrote:
> On Thu, Jan 6, 2022 at 10:06 AM Ben Greear <greearb@candelatech.com> wrote:
>>
>> Hello,
>>
>> I'm working on a strange problem, and could use some help if anyone has ideas.
>>
>> On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
>> traffic generation on the netdevs, etc), I see cases where two processes trying
>> to communicate across localhost with TCP seem to get a stuck network
>> connection:
>>
>> [greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
>> tcp        0 7988926 127.0.0.1:4004          127.0.0.1:23184         ESTABLISHED
>> tcp        0  59805 127.0.0.1:23184         127.0.0.1:4004          ESTABLISHED
>>
>> Both processes in question continue to execute, and as far as I can tell, they are properly
>> attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
>> are non blocking).  If one was stuck not reading, I would expect netstat
>> to show bytes in the rcv buffer, but it is zero as you can see above.
>>
>> Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
>> test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
>> but my code can grab logs at time it sees the problem.  Is there anything
>> more I can do to figure out why the TCP connection appears to be stuck?
> 
> It could be very useful to get more information about the state of all
> the stuck connections (sender and receiver side) with something like:
> 
>    ss -tinmo 'sport = :4004 or sport = :4004'
> 
> I would recommend downloading and building a recent version of the
> 'ss' tool to maximize the information. Here is a recipe for doing
> that:
> 
>   https://github.com/google/bbr/blob/master/Documentation/bbr-faq.md#how-can-i-monitor-linux-tcp-bbr-connections

Thanks for the suggestions!

Here is output from a working system of same OS, the hand-compiled ss seems to give similar output,
do you think it is still worth building ss manually on my system that shows the bugs?

[root@ct523c-3b29 iproute2]# ss -tinmo 'sport = :4004 or sport = :4004'
State             Recv-Q             Send-Q                         Local Address:Port                         Peer Address:Port
ESTAB             0                  0                                  127.0.0.1:4004                            127.0.0.1:40902
	 skmem:(r0,rb87380,t0,tb2626560,f12288,w0,o0,bl0,d0) ts sack reno wscale:4,10 rto:201 rtt:0.009/0.004 ato:40 mss:65483 pmtu:65535 rcvmss:1196 advmss:65483 
cwnd:10 bytes_sent:654589126 bytes_acked:654589126 bytes_received:1687846 segs_out:61416 segs_in:72611 data_segs_out:61406 data_segs_in:11890 send 
582071111111bps lastsnd:163 lastrcv:62910122 lastack:163 pacing_rate 1088548571424bps delivery_rate 261932000000bps delivered:61407 app_limited busy:42494ms 
rcv_rtt:1 rcv_space:43690 rcv_ssthresh:43690 minrtt:0.002
[root@ct523c-3b29 iproute2]# ./misc/ss -tinmo 'sport = :4004 or sport = :4004'
State          Recv-Q          Send-Q                    Local Address:Port                     Peer Address:Port           Process
ESTAB          0               0                             127.0.0.1:4004                        127.0.0.1:40902
	 skmem:(r0,rb87380,t0,tb2626560,f0,w0,o0,bl0,d0) ts sack reno wscale:4,10 rto:201 rtt:0.009/0.003 ato:40 mss:65483 pmtu:65535 rcvmss:1196 advmss:65483 cwnd:10 
bytes_sent:654597556 bytes_acked:654597556 bytes_received:1687846 segs_out:61418 segs_in:72613 data_segs_out:61408 data_segs_in:11890 send 582071111111bps 
lastsnd:219 lastrcv:62916882 lastack:218 pacing_rate 1088548571424bps delivery_rate 261932000000bps delivered:61409 app_limited busy:42495ms rcv_rtt:1 
rcv_space:43690 rcv_ssthresh:43690 minrtt:0.002

> 
> It could also be very useful to collect and share packet traces, as
> long as taking traces does not consume an infeasible amount of space,
> or perturb timing in a way that makes the buggy behavior disappear.
> For example, as root:
> 
>    tcpdump -w /tmp/trace.pcap -s 120 -c 100000000 -i any port 4004 &

I guess this could be  -i lo ?

I sometimes see what is likely a similar problem to an external process, but easiest thing to
reproduce is the localhost stuck connection, and my assumption is that it would be easiest
to debug.

I should have enough space for captures, I'll give that a try.

Thanks,
Ben

> 
> If space is an issue, you might start taking traces once things get
> stuck to see what the retry behavior, if any, looks like.
> 
> thanks,
> neal
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
