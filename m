Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D71C3E77
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgEDP2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:28:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbgEDP2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:28:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044F3Ro6056614;
        Mon, 4 May 2020 11:28:04 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5c6d2rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 11:28:03 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 044F3XYN057374;
        Mon, 4 May 2020 11:28:03 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s5c6d2pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 11:28:03 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044FHJaN016446;
        Mon, 4 May 2020 15:25:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g621jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 15:25:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044FP1ME38731878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 15:25:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C781611C05C;
        Mon,  4 May 2020 15:25:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85C3711C050;
        Mon,  4 May 2020 15:25:01 +0000 (GMT)
Received: from [9.145.24.39] (unknown [9.145.24.39])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 15:25:01 +0000 (GMT)
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>
References: <20200422161329.56026-1-edumazet@google.com>
 <20200422161329.56026-2-edumazet@google.com>
 <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
 <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
 <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com>
 <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <dd7d271f-ce45-5783-45a0-e89a6c428428@linux.ibm.com>
Date:   Mon, 4 May 2020 17:25:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_09:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.05.20 18:24, Eric Dumazet wrote:
> 
> 
> On 5/2/20 9:10 AM, Julian Wiedmann wrote:
>> On 02.05.20 17:40, Eric Dumazet wrote:
>>> On Sat, May 2, 2020 at 7:56 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>>>>
>>>> On 22.04.20 18:13, Eric Dumazet wrote:

[...]

>>>>
>>>>
>>>>> By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
>>>>>
>>>>> This patch does not change the prior behavior of gro_flush_timeout
>>>>> if used alone : NIC hard irqs should be rearmed as before.
>>>>>
>>>>> One concrete usage can be :
>>>>>
>>>>> echo 20000 >/sys/class/net/eth1/gro_flush_timeout
>>>>> echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
>>>>>
>>>>> If at least one packet is retired, then we will reset napi counter
>>>>> to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
>>>>> of the queue.
>>>>>
>>>>> On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
>>>>> avoidance was only possible if napi->poll() was exhausting its budget
>>>>> and not call napi_complete_done().
>>>>>
>>>>
>>>> I was confused here for a second, so let me just clarify how this is intended
>>>> to look like for pure TX completion IRQs:
>>>>
>>>> napi->poll() calls napi_complete_done() with an accurate work_done value, but
>>>> then still returns 0 because TX completion work doesn't consume NAPI budget.
>>>
>>>
>>> If the napi budget was consumed, the driver does _not_ call
>>> napi_complete() or napi_complete_done() anyway.
>>>
>>
>> I was thinking of "TX completions are cheap and don't consume _any_ NAPI budget, ever"
>> as the current consensus, but looking at the mlx4 code that evidently isn't true
>> for all drivers.
> 
> TX completions are not cheap in many cases.
> 
> Doing the unmap stuff can be costly in IOMMU world, and freeing skb
> can be also expensive.
> Add to this that TCP stack might be called back (via skb->destructor()) to add more packets to the qdisc/device.
> 
> So using effectively the budget as a limit might help in some stress situations,
> by not re-enabling NIC interrupts, even before napi_defer_hard_irqs addition.
> 

Neat, thanks for sharing this. Now I also see the tricks that mlx4 plays to still
get netpoll working.... fun.

>>
>>> If the budget is consumed, then napi_complete_done(napi, X>0) allows
>>> napi_complete_done()
>>> to return 0 if napi_defer_hard_irqs is not 0
>>>
>>> This means that the NIC hard irq will stay disabled for at least one more round.
>>>

