Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1806269A67
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgIOA1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:27:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgIOA1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:27:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F0PmqX086919;
        Tue, 15 Sep 2020 00:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/lp3ssLFIF9grSJMfNvaz6HxSc4T07AGymekTnSNWLo=;
 b=D/M2X9A5slRKJGp/rXq/kiEFcmcwXxFp2tHp1UdyuCxEDowoaMk+WSsA5KDBiQfu0BbF
 IxAjf2DV3zJt5aie3at8QvzeCnyGBMvJCcpLlD8eBGkkYEHnszRIv034FamClD4HTlCe
 GPZjnzW/wx52Di89jiafv788Bm/pGFxTkkFcjKMtds5YKGJv+ppHMR7hXnY4Q4xHaoTo
 mdw6yK6SZ0RuFlRNmkAa0tjTL4Ra4U+YaUT9/frt3SPn0RMctWTZyvzpuc/5zgLlE9n8
 QMDjM5ZkbTrfnFMoneGIiAkTa8dq+6KCbiC3LC5LPwqhRaFmI9dIO+dMCtr8RQnVB7G0 yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m1r7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 00:26:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F09toZ049766;
        Tue, 15 Sep 2020 00:24:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wn3qga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 00:24:35 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F0OSfW003043;
        Tue, 15 Sep 2020 00:24:28 GMT
Received: from [10.74.107.135] (/10.74.107.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 00:24:28 +0000
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, jgross@suse.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, kamatam@amazon.com, sstabellini@kernel.org,
        konrad.wilk@oracle.com, roger.pau@citrix.com, axboe@kernel.dk,
        davem@davemloft.net, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, peterz@infradead.org, eduval@amazon.com,
        sblbir@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
References: <cover.1598042152.git.anchalag@amazon.com>
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
 <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
 <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
Date:   Mon, 14 Sep 2020 20:24:22 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/20 5:47 PM, Anchal Agarwal wrote:
> On Sun, Sep 13, 2020 at 11:43:30AM -0400, boris.ostrovsky@oracle.com wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> On 8/21/20 6:25 PM, Anchal Agarwal wrote:
>>> Though, accquirng pm_mutex is still right thing to do, we may
>>> see deadlock if PM hibernation is interrupted by Xen suspend.
>>> PM hibernation depends on xenwatch thread to process xenbus state
>>> transactions, but the thread will sleep to wait pm_mutex which is
>>> already held by PM hibernation context in the scenario. Xen shutdown
>>> code may need some changes to avoid the issue.
>>
>>
>> Is it Xen's shutdown or suspend code that needs to address this? (Or I
>> may not understand what the problem is that you are describing)
>>
> Its Xen suspend code I think. If we do not take the system_transition_mutex
> in do_suspend then if hibernation is triggered in parallel to xen suspend there
> could be issues. 


But you *are* taking this mutex to avoid this exact race, aren't you?


> Now this is still theoretical in my case and I havent been able
> to reproduce such a race. So the approach the original author took was to take
> this lock which to me seems right.
> And its Xen suspend and not Xen Shutdown. So basically if this scenario
> happens I am of the view one of other will fail to occur then how do we recover
> or avoid this at all.
>
> Does that answer your question?
>


>>> +
>>> +static int xen_setup_pm_notifier(void)
>>> +{
>>> +     if (!xen_hvm_domain() || xen_initial_domain())
>>> +             return -ENODEV;
>>
>> I don't think this works anymore.
> What do you mean?
> The first check is for xen domain types and other is for architecture support. 
> The reason I put this check here is because I wanted to segregate the two.
> I do not want to register this notifier at all for !hmv guest and also if its
> an initial control domain.
> The arm check only lands in notifier because once hibernate() api is called ->
> calls pm_notifier_call_chain for PM_HIBERNATION_PREPARE this will fail for
> aarch64. 
> Once we have support for aarch64 this notifier can go away altogether. 
>
> Is there any other reason I may be missing why we should move this check to
> notifier?


Not registering this notifier is equivalent to having it return NOTIFY_OK.


In your earlier versions just returning NOTIFY_OK was not sufficient for
hibernation to proceed since the notifier would also need to set
suspend_mode appropriately. But now your notifier essentially filters
out unsupported configurations. And so if it is not called your
configuration (e.g. PV domain) will be considered supported.


>> In the past your notifier would set suspend_mode (or something) but now
>> it really doesn't do anything except reports an error in some (ARM) cases.
>>
>> So I think you should move this check into the notifier.
>> (And BTW I still think PM_SUSPEND_PREPARE should return an error too.
>> The fact that we are using "suspend" in xen routine names is irrelevant)
>>
> I may have send "not-updated" version of the notifier's function change.
>
> +    switch (pm_event) {
> +       case PM_HIBERNATION_PREPARE:
> +        /* Guest hibernation is not supported for aarch64 currently*/
> +        if (IS_ENABLED(CONFIG_ARM64)) {
> +             ret = NOTIFY_BAD;                                                                                                                                                                                                                                                    
> +             break;                                                                                                                                                                                                                                                               
> +     }               
> +       case PM_RESTORE_PREPARE:
> +       case PM_POST_RESTORE:
> +       case PM_POST_HIBERNATION:
> +       default:
> +           ret = NOTIFY_OK;
> +    }


There is no difference on x86 between this code and what you sent
earlier. In both instances PM_SUSPEND_PREPARE will return NOTIFY_OK.


On ARM this code will allow suspend to proceed (which is not what we want).


-boris


>
> With the above path PM_SUSPEND_PREPARE will go all together. Does that
> resolves this issue? I wanted to get rid of all SUSPEND_* as they are not needed
> here clearly.
> The only reason I kept it there is if someone tries to trigger hibernation on
> ARM instances they should get an error. As I am not sure about the current
> behavior. There may be a better way to not invoke hibernation on ARM DomU's and
> get rid of this block all together.
>
> Again, sorry for sending in the half baked fix. My workspace switch may have
> caused the error.
>>
>>
>> -boris
>>
> Anchal
>>
>>> +     return register_pm_notifier(&xen_pm_notifier_block);
>>> +}
>>> +
