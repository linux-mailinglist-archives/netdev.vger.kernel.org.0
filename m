Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31144352FCD
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbhDBTd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBTd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 15:33:57 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDD4C0613E6;
        Fri,  2 Apr 2021 12:33:55 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132JSfXB024238;
        Fri, 2 Apr 2021 20:33:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=v92gebLFRntrWcKfwv3ITHL0Gz5UJtZWckv/T7wA7AE=;
 b=Ps7Jyb+XpvIStwxWPTUgGGptK2Y+5StYXXQZJt5iV6kmQn0KIrdwWdCKRFi8j1UBcQT8
 BIp2x//GWIn6ueSAFtQdSdEFmmXRbAfmgnQ9UrLCbWsQ/z3vqzrbR6HXl5Dz1b+mzvPI
 0IMQYHDss/QHndhY4JOyvNCMU328D9fs9Vn7g3ChZtnRTQ0rmKhHC0Sowbu4/s21tfqs
 jl8cjwsCSa4PBHEG3yTzhPKtHFwxk4tLQIiwtiRRtXZJlM7Yq6/sDcoNf29eAjigdsCM
 2x0CnEX7ivuVJ8Nj6CNmT4lNVWjyy/GngVfJsOdk/dVmLN/uGy8CFKSwWrHKs5cvB1Og yw== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 37p3wsb14k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 20:33:41 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 132J7IbO010293;
        Fri, 2 Apr 2021 15:33:40 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com with ESMTP id 37n2ewn0b9-1;
        Fri, 02 Apr 2021 15:33:40 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id B97F025C2A;
        Fri,  2 Apr 2021 19:33:38 +0000 (GMT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Jiri Kosina <jikos@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com>
 <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <39c837d3-0435-a5a7-ac48-975a4d2f170e@akamai.com>
Date:   Fri, 2 Apr 2021 12:33:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_12:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxlogscore=631 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020129
X-Proofpoint-ORIG-GUID: r74LgAYT9aiHAOLff8Ok-4_CfL6KgaS2
X-Proofpoint-GUID: r74LgAYT9aiHAOLff8Ok-4_CfL6KgaS2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_14:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=568 priorityscore=1501
 bulkscore=0 adultscore=0 clxscore=1011 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020131
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.19)
 smtp.mailfrom=johunt@akamai.com smtp.helo=prod-mail-ppoint2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/21 12:25 PM, Jiri Kosina wrote:
> On Thu, 3 Sep 2020, John Fastabend wrote:
> 
>>>> At this point I fear we could consider reverting the NOLOCK stuff.
>>>> I personally would hate doing so, but it looks like NOLOCK benefits are
>>>> outweighed by its issues.
>>>
>>> I agree, NOLOCK brings more pains than gains. There are many race
>>> conditions hidden in generic qdisc layer, another one is enqueue vs.
>>> reset which is being discussed in another thread.
>>
>> Sure. Seems they crept in over time. I had some plans to write a
>> lockless HTB implementation. But with fq+EDT with BPF it seems that
>> it is no longer needed, we have a more generic/better solution.  So
>> I dropped it. Also most folks should really be using fq, fq_codel,
>> etc. by default anyways. Using pfifo_fast alone is not ideal IMO.
> 
> Half a year later, we still have the NOLOCK implementation
> present, and pfifo_fast still does set the TCQ_F_NOLOCK flag on itself.
> 
> And we've just been bitten by this very same race which appears to be
> still unfixed, with single packet being stuck in pfifo_fast qdisc
> basically indefinitely due to this very race that this whole thread began
> with back in 2019.
> 
> Unless there are
> 
> 	(a) any nice ideas how to solve this in an elegant way without
> 	    (re-)introducing extra spinlock (Cong's fix) or
> 
> 	(b) any objections to revert as per the argumentation above
> 
> I'll be happy to send a revert of the whole NOLOCK implementation next
> week.
> 

Jiri

If you have a reproducer can you try 
https://lkml.org/lkml/2021/3/24/1485 ? If that doesn't work I think your 
suggestion of reverting nolock makes sense to me. We've moved to using 
fq as our default now b/c of this bug.

Josh
