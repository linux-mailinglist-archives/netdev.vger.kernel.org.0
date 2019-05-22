Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCD82629E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfEVK7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:59:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:45034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfEVK7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 06:59:24 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTOxq-0000nY-NU; Wed, 22 May 2019 12:59:18 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTOxq-000E2y-Hp; Wed, 22 May 2019 12:59:18 +0200
Subject: Re: [PATCH net] net: sched: sch_ingress: do not report ingress filter
 info in egress path
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        alexei.starovoitov@gmail.com
References: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
 <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
 <365843b0b605d272a7ec3cf4ebf4cb5ea70b42e6.camel@redhat.com>
 <20190522102013.GA3467@localhost.localdomain>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ac3120ae-245b-05ab-2abf-6c0710827fc5@iogearbox.net>
Date:   Wed, 22 May 2019 12:59:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190522102013.GA3467@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25457/Wed May 22 09:57:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22/2019 12:20 PM, Lorenzo Bianconi wrote:
>> On Tue, 2019-05-21 at 14:59 +0200, Lorenzo Bianconi wrote:
>>> Currently if we add a filter to the ingress qdisc (e.g matchall) the
>>> filter data are reported even in the egress path. The issue can be
>>> triggered with the following reproducer:
> 
> [...]
> 
>>> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
>>> index 0bac926b46c7..1825347fed3a 100644
>>> --- a/net/sched/sch_ingress.c
>>> +++ b/net/sched/sch_ingress.c
>>> @@ -31,7 +31,7 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch, unsigned long arg)
>>>  
>>>  static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
>>>  {
>>> -	return TC_H_MIN(classid) + 1;
>>> +	return TC_H_MIN(classid);
>>
>> probably this breaks a command that was wrong before, but it's worth
>> mentioning. Because of the above hunk, the following command
>>
>> # tc qdisc add dev test0 ingress
>> # tc filter add dev test0 parent ffff:fff1 matchall action drop
>> # tc filter add dev test0 parent ffff: matchall action continue
>>
>> gave no errors, and dropped packets on unpatched kernel. With this patch,
>> the kernel refuses to add the 'matchall' rules (and because of that,
>> traffic passes).
>>
>> running TDC, it seems that a patched kernel does not pass anymore
>> some of the test cases belonging to the 'filter' category:
>>
>> # ./tdc.py -e 901f
>> Test 901f: Add fw filter with prio at 32-bit maxixum
>> exit: 2
>> exit: 0
>> RTNETLINK answers: Invalid argument
>> We have an error talking to the kernel, -1
>>
>> All test results:
>> 1..1
>> not ok 1 901f - Add fw filter with prio at 32-bit maxixum
>>         Command exited with 2, expected 0
>> RTNETLINK answers: Invalid argument
>> We have an error talking to the kernel, -1
>>
>> (the same test is passing on a unpatched kernel)
>>
>> Do you think it's worth fixing those test cases too?
>>
>> thanks a lot!
>> -- 
>> davide
> 
> Hi Davide,
> 
> thx to point this out. Applying this patch the ingress qdisc has the same
> behaviour of clsact one.
> 
> $tc qdisc add dev lo clsact
> $tc filter add dev lo parent ffff:fff1 matchall action drop
> Error: Specified class doesn't exist.
> We have an error talking to the kernel, -1
> $tc filter add dev lo parent ffff:fff2 matchall action drop
> 
> $tc qdisc add dev lo ingress
> $tc filter add dev lo parent ffff:fff2 matchall action drop
> 
> is it acceptable? If so I can fix the tests as well
> If not, is there another way to verify the filter is for the ingress path if
> parent identifier is not constant? (ingress_find() reports the TC_H_MIN of
> parent identifier)

As far as I know this would break sch_ingress users ... For sch_ingress
any minor should be accepted. For sch_clsact, only 0xFFF2U and 0xFFF3U
are accepted, so it can be extended in future if needed. For old sch_ingress
that ship has sailed, which is why sch_clsact was needed in order to have
such selectors, see also 1f211a1b929c ("net, sched: add clsact qdisc").
Meaning, minors for sch_ingress are a superset of sch_clsact and not
compatible in that sense. If you adapt sch_ingress to the same behavior
as sch_clsact, things might break indeed as Davide pointed out.

> Regards,
> Lorenzo
> 
>>
>>>  }
>>>  
>>>  static unsigned long ingress_bind_filter(struct Qdisc *sch,
>>> @@ -53,7 +53,12 @@ static struct tcf_block *ingress_tcf_block(struct Qdisc *sch, unsigned long cl,
>>>  {
>>>  	struct ingress_sched_data *q = qdisc_priv(sch);
>>>  
>>> -	return q->block;
>>> +	switch (cl) {
>>> +	case TC_H_MIN(TC_H_MIN_INGRESS):
>>> +		return q->block;
>>> +	default:
>>> +		return NULL;
>>> +	}
>>>  }
>>>  
>>>  static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)
>>
>>

