Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7774B224E92
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgGSBux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 21:50:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgGSBuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 21:50:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06J1gVUj104805;
        Sun, 19 Jul 2020 01:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EaYL3Q9q6QNFTsvFEQW1LskL6r73jcbI3lEAanfcPTk=;
 b=E2fwWQu2Q5dkhtuwVH5Y2Z2unfGCUoCMV6BXjJKvXnmibNWZcABC11FQYejv+oyjHLBN
 vrCAM6xBhwmK0c4Eo5V/E3ai6h9XLmBBywUUBX9U1y6dkiPLqgXW6uJqCFiQTZ7q7/wJ
 sLuE1aPoSPEL2prhFotkVJZFdjR/zINp5hdp0h7a7UNAvVPR6lS+Cxxs0T/bxiaBtpbc
 lbuJaZH2oyM8kOSWfMQlBZRnQodmyksJRBR3rKOvs1jfKcvjcYGhsgMh3fcJMcmOq1mH
 G7bLP72vcVlBMIUipDMLYu4iNnu21ffwfzh9zrFCro+tL5JubkUUXrDQtZ85qOvxs2Qr Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgr258a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 19 Jul 2020 01:49:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06J1loiU070561;
        Sun, 19 Jul 2020 01:47:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32canj2wcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jul 2020 01:47:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06J1lAXW028549;
        Sun, 19 Jul 2020 01:47:14 GMT
Received: from [10.39.198.189] (/10.39.198.189)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 19 Jul 2020 01:47:09 +0000
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend
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
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Autocrypt: addr=boris.ostrovsky@oracle.com; keydata=
 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
 Jg6OxFYd01z+a+oL
Message-ID: <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
Date:   Sat, 18 Jul 2020 21:47:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9686 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=100 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=100 mlxscore=100 bulkscore=0 adultscore=0
 mlxlogscore=-1000 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007190011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9686 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=100 malwarescore=0 bulkscore=0
 spamscore=100 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015
 mlxlogscore=-1000 priorityscore=1501 phishscore=0 lowpriorityscore=0
 mlxscore=100 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007190010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Roger, question for you at the very end)

On 7/17/20 3:10 PM, Anchal Agarwal wrote:
> On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
>> CAUTION: This email originated from outside of the organization. Do no=
t click links or open attachments unless you can confirm the sender and k=
now the content is safe.
>>
>>
>>
>> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
>>> On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
>>>> CAUTION: This email originated from outside of the organization. Do =
not click links or open attachments unless you can confirm the sender and=
 know the content is safe.
>>>>
>>>>
>>>>
>>>> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
>>>>> +
>>>>> +bool xen_is_xen_suspend(void)
>>>> Weren't you going to call this pv suspend? (And also --- is this sus=
pend
>>>> or hibernation? Your commit messages and cover letter talk about fix=
ing
>>>> hibernation).
>>>>
>>>>
>>> This is for hibernation is for pvhvm/hvm/pv-on-hvm guests as you may =
call it.
>>> The method is just there to check if "xen suspend" is in progress.
>>> I do not see "xen_suspend" differentiating between pv or hvm
>>> domain until later in the code hence, I abstracted it to xen_is_xen_s=
uspend.
>>
>> I meant "pv suspend" in the sense that this is paravirtual suspend, no=
t
>> suspend for paravirtual guests. Just like pv drivers are for both pv a=
nd
>> hvm guests.
>>
>>
>> And then --- should it be pv suspend or pv hibernation?
>>
>>
> Ok so I think I am lot confused by this question. Here is what this
> function for, function xen_is_xen_suspend() just tells us whether=20
> the guest is in "SHUTDOWN_SUSPEND" state or not. This check is needed
> for correct invocation of syscore_ops callbacks registered for guest's
> hibernation and for xenbus to invoke respective callbacks[suspend/resum=
e
> vs freeze/thaw/restore].
> Since "shutting_down" state is defined static and is not directly avail=
able
> to other parts of the code, the function solves the purpose.
>
> I am having hard time understanding why this should be called pv
> suspend/hibernation unless you are suggesting something else?
> Am I missing your point here?=20



I think I understand now what you are trying to say --- it's whether we
are going to use xen_suspend() routine, right? If that's the case then
sure, you can use "xen_suspend" term. (I'd probably still change
xen_is_xen_suspend() to is_xen_suspend())


>>>>> +{
>>>>> +     return suspend_mode =3D=3D XEN_SUSPEND;
>>>>> +}
>>>>> +
>>>> +static int xen_setup_pm_notifier(void)
>>>> +{
>>>> +     if (!xen_hvm_domain())
>>>> +             return -ENODEV;
>>>>
>>>> I forgot --- what did we decide about non-x86 (i.e. ARM)?
>>> It would be great to support that however, its  out of
>>> scope for this patch set.
>>> I=E2=80=99ll be happy to discuss it separately.
>>
>> I wasn't implying that this *should* work on ARM but rather whether th=
is
>> will break ARM somehow (because xen_hvm_domain() is true there).
>>
>>
> Ok makes sense. TBH, I haven't tested this part of code on ARM and the =
series
> was only support x86 guests hibernation.
> Moreover, this notifier is there to distinguish between 2 PM
> events PM SUSPEND and PM hibernation. Now since we only care about PM
> HIBERNATION I may just remove this code and rely on "SHUTDOWN_SUSPEND" =
state.
> However, I may have to fix other patches in the series where this check=
 may
> appear and cater it only for x86 right?


I don't know what would happen if ARM guest tries to handle hibernation
callbacks. The only ones that you are introducing are in block and net
fronts and that's arch-independent.


You do add a bunch of x86-specific code though (syscore ops), would
something similar be needed for ARM?


>>>> And PVH dom0.
>>> That's another good use case to make it work with however, I still
>>> think that should be tested/worked upon separately as the feature its=
elf
>>> (PVH Dom0) is very new.
>>
>> Same question here --- will this break PVH dom0?
>>
> I haven't tested it as a part of this series. Is that a blocker here?


I suspect dom0 will not do well now as far as hibernation goes, in which
case you are not breaking anything.


Roger?


-boris



