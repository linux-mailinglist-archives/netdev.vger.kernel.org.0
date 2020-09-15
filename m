Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D036E26AE57
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgIOUBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:01:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgIOT7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 15:59:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FJsYdd148170;
        Tue, 15 Sep 2020 19:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zszz4Wk0Z8hYu0e6GbpBILedfHLAamVV3KpsQALk+MY=;
 b=cYabd4XRLzwlPu6EI22Jl3KW8FThCr3NHJRiRVIFuiWBisN/7ig7eIjuQJLSO7XmRVoJ
 wxyif9kkcBZVUoUeICjdq33ky2ESTX66AwH8EickV/S+oNJ0dHnKUuybQt36q0qpWk2K
 cgh0zggcNZsbxuvU6Lh2mMl+TcDdDigeaEUmVy/c55Xb4sXm2pPlHH7InMVxAjRgR12G
 gvZtb5xpz6yHLqOpLyOKYaNupCnvf0aF6rMxShvXHL8uQzgV8K63N/gyFP4JPPOgtagD
 lHoFX63R9IERITY1rCk08FhC/CIkyjWOJiPNJwNUm24KKp4pBZjgADEs0Fge+Sq5aqPp lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dgxat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 19:58:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FJtpB5041155;
        Tue, 15 Sep 2020 19:58:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm315t7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:58:54 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FJwpf6030579;
        Tue, 15 Sep 2020 19:58:51 GMT
Received: from [10.74.86.196] (/10.74.86.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 19:58:50 +0000
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
 <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
 <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
Date:   Tue, 15 Sep 2020 15:58:45 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>>
>>
>>>>> +
>>>>> +static int xen_setup_pm_notifier(void)
>>>>> +{
>>>>> +     if (!xen_hvm_domain() || xen_initial_domain())
>>>>> +             return -ENODEV;
>>>>
>>>> I don't think this works anymore.
>>> What do you mean?
>>> The first check is for xen domain types and other is for architecture support.
>>> The reason I put this check here is because I wanted to segregate the two.
>>> I do not want to register this notifier at all for !hmv guest and also if its
>>> an initial control domain.
>>> The arm check only lands in notifier because once hibernate() api is called ->
>>> calls pm_notifier_call_chain for PM_HIBERNATION_PREPARE this will fail for
>>> aarch64.
>>> Once we have support for aarch64 this notifier can go away altogether.
>>>
>>> Is there any other reason I may be missing why we should move this check to
>>> notifier?
>>
>>
>> Not registering this notifier is equivalent to having it return NOTIFY_OK.
>>
> How is that different from current behavior?
>>
>> In your earlier versions just returning NOTIFY_OK was not sufficient for
>> hibernation to proceed since the notifier would also need to set
>> suspend_mode appropriately. But now your notifier essentially filters
>> out unsupported configurations. And so if it is not called your
>> configuration (e.g. PV domain) will be considered supported.
>>
> I am sorry if I am having a bit of hard time understanding this. 
> How will it be considered supported when its not even registered? My
> understanding is if its not registered, it will not land in notifier call chain
> which is invoked in pm_notifier_call_chain().


Returning an error from xen_setup_pm_notifier() doesn't have any effect
on whether hibernation will start. It's the notifier that can stop it.

> 
> As Roger, mentioned in last series none of this should be a part of PVH dom0 
> hibernation as its not tested but this series should also not break anything.
> If I register this notifier for PVH dom0 and return error later that will alter
> the current behavior right?
> 
> If a pm_notifier for pvh dom0 is not registered then it will not land in the
> notifier call chain and system will work as before this series.
> If I look for unsupported configurations, then !hvm domain is also one but we
> filter that out at the beginning and don't even bother about it.
> 
> Unless you mean guest running VMs itself? [Trying to read between the lines may
> not be the case though]



In hibernate():

        error = __pm_notifier_call_chain(PM_HIBERNATION_PREPARE, -1,
&nr_calls);
        if (error) {
                nr_calls--;
                goto Exit;
        }


Is you don't have notifier registered (as will be the case with PV
domains and dom0) you won't get an error and proceed with hibernation.
(And now I actually suspect it didn't work even with your previous patches)


But something like this I think will do what you want:


static int xen_pm_notifier(struct notifier_block *notifier,
	unsigned long pm_event, void *unused)

{

       if (IS_ENABLED(CONFIG_ARM64) ||
	   !xen_hvm_domain() || xen_initial_domain() ||
	   (pm_event == PM_SUSPEND_PREPARE)) {
		if ((pm_event == PM_SUSPEND_PREPARE) || (pm_event ==
PM_HIBERNATION_PREPARE))
			pr_warn("%s is not supported for this guest",
				(pm_event == PM_SUSPEND_PREPARE) ?
				"Suspend" : "Hibernation");
                return NOTIFY_BAD;

        return NOTIFY_OK;

}

static int xen_setup_pm_notifier(void)
{
	return register_pm_notifier(&xen_pm_notifier_block);
}


I tried to see if there is a way to prevent hibernation without using
notifiers (like having a global flag or something) but didn't find
anything obvious. Perhaps others can point to a simpler way of doing this.


-boris

