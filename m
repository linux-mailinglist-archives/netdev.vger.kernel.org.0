Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7827FF69
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgJAMp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:45:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47218 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731891AbgJAMp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 08:45:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091Chq1s130044;
        Thu, 1 Oct 2020 12:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dRio5ZMU9WDz6PjNY704BdYKLFPP9TtV0vYjDf32cpI=;
 b=L1tXWifpPI2khL7ZWsxd+W1OzbP5uZquW/uyQ5eKyU/GjTGSHQi30vn6r3rT7PpE/9Jd
 1UCv0ETLyOoJYqF9c0WsJVQJTp/y2FpkcoVBlK+ec42xTHc/LafZA0UXKAYkLtOY7ujM
 Gnxq5MbZIjL3GsNTAhwyceyOtdjSI5kJioc9HSNhxr64tFD9dCRDFWuAMO30IbelxaDN
 LVKCtugIDxlclIM7JSu/2UKbH9tOGUVemGFchOa5of7QiKH2ySYHPjihtWRlaI5ETzwu
 VKdojWeV1D7mXjHmrrlmUo3Mi/+h9yjiL8I62ff7BIPsaxYMYEVVGWMnND2ps+MGeZ4i kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkm5pva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 12:44:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091CQ6ec104197;
        Thu, 1 Oct 2020 12:44:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33tfk1gcdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 12:44:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091Ci4s6018950;
        Thu, 1 Oct 2020 12:44:05 GMT
Received: from [10.74.86.152] (/10.74.86.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 05:44:04 -0700
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
References: <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
 <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
 <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <8cd59d9c-36b1-21cf-e59f-40c5c20c65f8@oracle.com>
Date:   Thu, 1 Oct 2020 08:43:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930212944.GA3138@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=980 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=979 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>>>>> Also, wrt KASLR stuff, that issue is still seen sometimes but I haven't had
>>>>>>> bandwidth to dive deep into the issue and fix it.
>>>> So what's the plan there? You first mentioned this issue early this year and judged by your response it is not clear whether you will ever spend time looking at it.
>>>>
>>> I do want to fix it and did do some debugging earlier this year just haven't
>>> gotten back to it. Also, wanted to understand if the issue is a blocker to this
>>> series?
>>
>> Integrating code with known bugs is less than ideal.
>>
> So for this series to be accepted, KASLR needs to be fixed along with other
> comments of course? 


Yes, please.



>>> I had some theories when debugging around this like if the random base address picked by kaslr for the
>>> resuming kernel mismatches the suspended kernel and just jogging my memory, I didn't find that as the case.
>>> Another hunch was if physical address of registered vcpu info at boot is different from what suspended kernel
>>> has and that can cause CPU's to get stuck when coming online.
>>
>> I'd think if this were the case you'd have 100% failure rate. And we are also re-registering vcpu info on xen restore and I am not aware of any failures due to KASLR.
>>
> What I meant there wrt VCPU info was that VCPU info is not unregistered during hibernation,
> so Xen still remembers the old physical addresses for the VCPU information, created by the
> booting kernel. But since the hibernation kernel may have different physical
> addresses for VCPU info and if mismatch happens, it may cause issues with resume. 
> During hibernation, the VCPU info register hypercall is not invoked again.


I still don't think that's the cause but it's certainly worth having a look.


-boris

