Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108D111D889
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfLLV3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:29:09 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:48208 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730811AbfLLV3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:29:08 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 7A02113C283;
        Thu, 12 Dec 2019 13:29:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 7A02113C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1576186147;
        bh=1gtuydINIwsIZMa+/eWNaF7yM91GiVdaDA6M+mF7eZI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jKUYz1LLddiojTZbxkrO1Lo5FuYND6EJdaB1MMpF2lMKTa6YihLQm3Qmw6iXsyvQg
         b13MxK6lKq+/gfJ72ytZGoRhPXGRdVj3b+jGORSqEwIhUDbcaa4ytMPvckBvzxFlKd
         uJOC2FF9GNfqO8o5gc/EKxgHp1w3Y3qzAXweiqSo=
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <04dc171a-7385-6544-6cc6-141aae9f2782@candelatech.com>
Date:   Thu, 12 Dec 2019 13:29:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/19 1:11 PM, Johannes Berg wrote:
> Hi Eric,
> 
> Thanks for looking :)
> 
>>> I'm not sure how to do headers-only, but I guess -s100 will work.
>>>
>>> https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
>>>
>>
>> Lack of GRO on receiver is probably what is killing performance,
>> both for receiver (generating gazillions of acks) and sender
>> (to process all these acks)
> Yes, I'm aware of this, to some extent. And I'm not saying we should see
> even close to 1800 Mbps like we have with UDP...
> 
> Mind you, the biggest thing that kills performance with many ACKs isn't
> the load on the system - the sender system is only moderately loaded at
> ~20-25% of a single core with TSO, and around double that without TSO.
> The thing that kills performance is eating up all the medium time with
> small non-aggregated packets, due to the the half-duplex nature of WiFi.
> I know you know, but in case somebody else is reading along :-)
> 
> But unless somehow you think processing the (many) ACKs on the sender
> will cause it to stop transmitting, or something like that, I don't
> think I should be seeing what I described earlier: we sometimes (have
> to?) reclaim the entire transmit queue before TCP starts pushing data
> again. That's less than 2MB split across at least two TCP streams, I
> don't see why we should have to get to 0 (which takes about 7ms) until
> more packets come in from TCP?
> 
> Or put another way - if I free say 400kB worth of SKBs, what could be
> the reason we don't see more packets be sent out of the TCP stack within
> the few ms or so? I guess I have to correlate this somehow with the ACKs
> so I know how much data is outstanding for ACKs. (*)
> 
> The sk_pacing_shift is set to 7, btw, which should give us 8ms of
> outstanding data. For now in this setup that's enough(**), and indeed
> bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
> anything. So I think this part we actually solved - I get basically the
> same performance and behaviour with two streams (needed due to GBit LAN
> on the other side) as with 20 streams.
> 
> 
>> I had a plan about enabling compressing ACK as I did for SACK
>> in commit
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e
>>
>> But I have not done it yet.
>> It is a pity because this would tremendously help wifi I am sure.
> 
> Nice :-)
> 
> But that is something the *receiver* would have to do.
> 
> The dirty secret here is that we're getting close to 1700 Mbps TCP with
> Windows in place of Linux in the setup, with the same receiver on the
> other end (which is actually a single Linux machine with two GBit
> network connections to the AP). So if we had this I'm sure it'd increase
> performance, but it still wouldn't explain why we're so much slower than
> Windows :-)
> 
> Now, I'm certainly not saying that TCP behaviour is the only reason for
> the difference, we already found an issue for example where due to a
> small Windows driver bug some packet extension was always used, and the
> AP is also buggy in that it needs the extension but didn't request it
> ... so the two bugs cancelled each other out and things worked well, but
> our Linux driver believed the AP ... :) Certainly there can be more
> things like that still, I just started on the TCP side and ran into the
> queueing behaviour that I cannot explain.
> 
> 
> In any case, I'll try to dig deeper into the TCP stack to understand the
> reason for this transmit behaviour.
> 
> Thanks,
> johannes
> 
> 
> (*) Hmm. Now I have another idea. Maybe we have some kind of problem
> with the medium access configuration, and we transmit all this data
> without the AP having a chance to send back all the ACKs? Too bad I
> can't put an air sniffer into the setup - it's a conductive setup.

splitter/combiner?

If it is just delayed acks coming back, which would slow down a stream, then
multiple streams would tend to work around that problem?

I would actually expect similar speedup with multiple streams if some TCP socket
was blocked on waiting for ACKs too.

Even if you can't sniff the air, you could sniff the wire or just look at packet
in/out counts.  If you have a huge number of ACKs, that would show up in raw pkt
counters.

I'm not sure it matters these days, but this patch greatly helped TCP throughput on
ath10k for a while, and we are still using it.  Maybe your sk_pacing change already
tweaked the same logic:

https://github.com/greearb/linux-ct-5.4/commit/65651d4269eb2b0d4b4952483c56316a7fbe2f48

if [ -w /proc/sys/net/ipv4/tcp_tsq_limit_output_interval ]
		then
		# This helps TCP tx throughput when using ath10k.  Setting > 1 likely
		# increases latency in some cases, but on average, seems a win for us.
		TCP_TSQ=200
		echo -n "Setting TCP-tsq limit to $TCP_TSQ....................................... "
		echo $TCP_TSQ > /proc/sys/net/ipv4/tcp_tsq_limit_output_interval
		echo "DONE"
	    fi


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

