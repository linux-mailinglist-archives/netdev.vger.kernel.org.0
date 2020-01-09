Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC75E136403
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgAIXtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:49:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39028 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgAIXtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:49:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Nmqum179731;
        Thu, 9 Jan 2020 23:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2019-08-05;
 bh=d9JtxMjLZbVfmlyhMLAFcumf9Weh4khNDXMC9OowByU=;
 b=NecdLtd9CrIf1BHCVKW+DxXL8AZg4MWZI62vwXbOuT8SE/lP2jl2QAuQZBrguc0IhnEi
 wpnMbnArM4eNOp7hMEI9cxuMPvWyHwHp0fY+AYrTHART5KEi54GPypiC6WZEXsa74xRP
 tkcMkSPzldfNzutjAzFI5l2iqTR5j4LlYj0CW03iACV4t9vuawIsnkDZhU1wft+pky7q
 P0HNvFAAyz294RoLaTsVua0artLyWdddzqsUsjzuzHQjLGPuZF+jbe2t3PU0J4ARXQDZ
 iBWA8+wx9vK0PiJa3iQDz/f/RVjAE3DpjKF+FE5qH2ZxK0Omc3qzcpRshaK1tWkpRboJ ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnqe4dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 23:49:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009NmnwJ105792;
        Thu, 9 Jan 2020 23:49:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xdms0bcgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 23:49:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 009Nn9AW008309;
        Thu, 9 Jan 2020 23:49:09 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 15:49:09 -0800
Subject: Re: [RFC PATCH V2 01/11] xen/manage: keep track of the on-going
 suspend mode
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        jgross@suse.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        kamatam@amazon.com, sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        dwmw@amazon.co.uk, fllinden@amaozn.com
References: <20200107233720.GA17906@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <88721569-d425-8df3-2ab2-3aa9155b326c@oracle.com>
Message-ID: <b0392e02-c783-8aaa-ab5e-8e29385fa281@oracle.com>
Date:   Thu, 9 Jan 2020 18:49:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <88721569-d425-8df3-2ab2-3aa9155b326c@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/20 6:46 PM, Boris Ostrovsky wrote:
>
>
> On 1/7/20 6:37 PM, Anchal Agarwal wrote:
>> +
>> +static int xen_setup_pm_notifier(void)
>> +{
>> +    if (!xen_hvm_domain())
>> +        return -ENODEV;
>
> ARM guests are also HVM domains. Is it OK for them to register the 
> notifier? The diffstat suggests that you are supporting ARM.

I obviously meant *not* supporting ARM, sorry.

-boris

>
> -boris
>
>> +
>> +    return register_pm_notifier(&xen_pm_notifier_block);
>> +}
>>
>

