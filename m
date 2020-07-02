Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DAF212BF4
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGBSMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:12:52 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:55856 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbgGBSMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:12:51 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062I6xWf021265;
        Thu, 2 Jul 2020 19:08:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=dHBJESfsfuoreJg+hXrfxFFWunh4+79b75TiWxqM97A=;
 b=g383Rgq9sti6Bn+cu+UTO/3GFFBS8CFYQnf7IglyV8CnzwDzucMDpgzOWgQa9bZz7p6W
 W9gqs9cX+NufeX/UECsCx0pdFW7NMGfqCRzE5a5zQ+pQTclvgGgPOxKYoA/7h+vNU9FL
 owC9M0AjwCaQua1A63VIxxLHxQaFTRg8j3mA0D6N9y9u6l5h3Zrx6xlB2bLDCz35H4mR
 775TeCH9PfRc81WY8k7cEg8ot4zybMhYHtqjpJxIpAgSnOHlEXzbGZPxuHk4Q2KVP9ye
 r8vZsJFX8v5fivTU8goxhBSUcrleOBnpZFwdAeww0N5OVD7iBvfEQSs+bMRE2kT90gk1 QA== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 31xkj2nbpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 19:08:46 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 062I69SV014747;
        Thu, 2 Jul 2020 14:08:45 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint6.akamai.com with ESMTP id 31x1ey2v9p-1;
        Thu, 02 Jul 2020 14:08:45 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 268F26036B;
        Thu,  2 Jul 2020 18:08:44 +0000 (GMT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
 <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
Date:   Thu, 2 Jul 2020 11:08:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020123
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 cotscore=-2147483648 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=2 impostorscore=0 adultscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/20 2:45 AM, Paolo Abeni wrote:
> Hi all,
> 
> On Thu, 2020-07-02 at 08:14 +0200, Jonas Bonn wrote:
>> Hi Cong,
>>
>> On 01/07/2020 21:58, Cong Wang wrote:
>>> On Wed, Jul 1, 2020 at 9:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>> On Tue, Jun 30, 2020 at 2:08 PM Josh Hunt <johunt@akamai.com> wrote:
>>>>> Do either of you know if there's been any development on a fix for this
>>>>> issue? If not we can propose something.
>>>>
>>>> If you have a reproducer, I can look into this.
>>>
>>> Does the attached patch fix this bug completely?
>>
>> It's easier to comment if you inline the patch, but after taking a quick
>> look it seems too simplistic.
>>
>> i)  Are you sure you haven't got the return values on qdisc_run reversed?
> 
> qdisc_run() returns true if it was able to acquire the seq lock. We
> need to take special action in the opposite case, so Cong's patch LGTM
> from a functional PoV.
> 
>> ii) There's a "bypass" path that skips the enqueue/dequeue operation if
>> the queue is empty; that needs a similar treatment:  after releasing
>> seqlock it needs to ensure that another packet hasn't been enqueued
>> since it last checked.
> 
> That has been reverted with
> commit 379349e9bc3b42b8b2f8f7a03f64a97623fff323
> 
> ---
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 90b59fc50dc9..c7e48356132a 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -3744,7 +3744,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>>
>>   	if (q->flags & TCQ_F_NOLOCK) {
>>   		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
>> -		qdisc_run(q);
>> +		if (!qdisc_run(q) && rc == NET_XMIT_SUCCESS)
>> +			__netif_schedule(q);
> 
> I fear the __netif_schedule() call may cause performance regression to
> the point of making a revert of TCQ_F_NOLOCK preferable. I'll try to
> collect some data.

Initial results with Cong's patch look promising, so far no stalls. We 
will let it run over the long weekend and report back on Tuesday.

Paolo - I have concerns about possible performance regression with the 
change as well. If you can gather some data that would be great. If 
things look good with our low throughput test over the weekend we can 
also try assessing performance next week.

Josh
