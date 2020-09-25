Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE7D2795CC
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgIZBCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:02:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgIZBCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 21:02:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PJwrTW138022;
        Fri, 25 Sep 2020 20:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Nq0+GVuXX49BrrGR5jVT3CHPb2ZHAO9+Zi+Yc3edtOU=;
 b=nG47WxTzvgzNcv0/dJ9QM1jrSr5sXyQg3yX5btqU38Y3xmikKnSSQ9CrdEjiTEV/2vNl
 M5PDfLIejBZshLaFF9eswImFQ0Le85iiSj7a0zrO3sFzZH9h4UFe5nOYOkhMyA0/xaY5
 xfHh06M2Oa18uRv0sTs+N3kNS+w332OsmCw5WJGUiu4z6BvPyChCDF+pnv5saydGsWSI
 Jj35oBTnSz+b8NA9I674BKjW6n6hGBn0vT03xQu5olExBqbxu7UZEPg5SGHimMQIGQr9
 pBXkw0N2LLnLjxtdtcvdgcuOhqpBfi1s4a9whJqlvWcX4K2sYWwcIXWcAd4dFKbLR8gs zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33ndnuym2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 20:03:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PK0Ytn033521;
        Fri, 25 Sep 2020 20:03:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nury86hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 20:03:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08PK34fC007803;
        Fri, 25 Sep 2020 20:03:04 GMT
Received: from [10.74.86.146] (/10.74.86.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 13:03:04 -0700
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
 <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
Date:   Fri, 25 Sep 2020 16:02:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/25/20 3:04 PM, Anchal Agarwal wrote:
> On Tue, Sep 22, 2020 at 11:17:36PM +0000, Anchal Agarwal wrote:
>> On Tue, Sep 22, 2020 at 12:18:05PM -0400, boris.ostrovsky@oracle.com wrote:
>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>
>>>
>>>
>>> On 9/21/20 5:54 PM, Anchal Agarwal wrote:
>>>> Thanks for the above suggestion. You are right I didn't find a way to declare
>>>> a global state either. I just broke the above check in 2 so that once we have
>>>> support for ARM we should be able to remove aarch64 condition easily. Let me
>>>> know if I am missing nay corner cases with this one.
>>>>
>>>> static int xen_pm_notifier(struct notifier_block *notifier,
>>>>       unsigned long pm_event, void *unused)
>>>> {
>>>>     int ret = NOTIFY_OK;
>>>>     if (!xen_hvm_domain() || xen_initial_domain())
>>>>       ret = NOTIFY_BAD;
>>>>     if(IS_ENABLED(CONFIG_ARM64) && (pm_event == PM_SUSPEND_PREPARE || pm_event == HIBERNATION_PREPARE))
>>>>       ret = NOTIFY_BAD;
>>>>
>>>>     return ret;
>>>> }
>>>
>>>
>>> This will allow PM suspend to proceed on x86.
>> Right!! Missed it.
>> Also, wrt KASLR stuff, that issue is still seen sometimes but I haven't had
>> bandwidth to dive deep into the issue and fix it.


So what's the plan there? You first mentioned this issue early this year and judged by your response it is not clear whether you will ever spend time looking at it.


>>  I seem to have lost your email
>> in my inbox hence covering the question here.
>>>
> Can I add your Reviewed-by or Signed-off-by to it?


Are you asking me to add my R-b to the broken code above?


-boris

