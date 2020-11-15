Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E502B32C3
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 07:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKOGr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 01:47:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgKOGr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 01:47:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF6lbKr097574;
        Sun, 15 Nov 2020 06:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qT34ZQmBn15aH/VFvkS7hE3enEiAXnqBdbhLuAultTo=;
 b=Z3WqJ0Be6NA91gXjoJJ1+Ap4JNQVb04hsGLlbMP5mLJPKb0+NG19GcLXsaGMmVUIkG+v
 VsXwmwioZVqni5yQz65sjp63Qkbmlkp5nk3IGKkteaYc9WBooEV/Fx6sFY6mjOtSYXpD
 bL8Kz/hcd1ZaKu5ObduqNecl/1e28jOfLHf998Je9Rt+zxjOib1A1c720XeZuyzZygVq
 qEnT/UFBCLOCkDAxz4Xz4g1OIPdX1Wt3p6qAItpfeCht4NowTcjJrrezl97Pj28pSoEH
 m6dnlCOGazWUprNj5WRjUHqMyi9P+UbUZxsCE/clQ8oXdkf/Udkzd1KIwo8PjcxX48GZ Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vmsqc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 06:47:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF6jJuA150882;
        Sun, 15 Nov 2020 06:47:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ts0n74qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 06:47:36 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AF6lZGU019587;
        Sun, 15 Nov 2020 06:47:35 GMT
Received: from [10.159.239.67] (/10.159.239.67)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 22:47:34 -0800
Subject: Re: [PATCH] page_frag: Recover from memory pressure
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org,
        vbabka@suse.cz
References: <20201105042140.5253-1-willy@infradead.org>
 <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
 <20201105140224.GK17076@casper.infradead.org>
 <20201109143249.GB17076@casper.infradead.org>
 <a8dd751d-2777-6821-47d2-b3d11a569f70@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <615096a5-56df-6de3-6d2f-2028c259c2f0@oracle.com>
Date:   Sat, 14 Nov 2020 22:47:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a8dd751d-2777-6821-47d2-b3d11a569f70@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011150042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From linux-next, this patch is not in akpm branch.

According to discussion with Matthew offline, I will take the author of this
patch as Matthew was providing review for patch and suggesting a better
alternative.

Therefore, it will be much more easier or me to track this patch.

I will re-send the patch as v2 with:

1. change author from Matthew to Dongli
2. Add references to all prior discussions
3. Add more details to commit message so that it is much more easier to search
online when this issue is encountered by other people again.
4. Add "Acked-by: Vlastimil Babka <vbabka@suse.cz>".

Thank you very much!

Dongli Zhang

On 11/9/20 6:37 AM, Eric Dumazet wrote:
> 
> 
> On 11/9/20 3:32 PM, Matthew Wilcox wrote:
>> On Thu, Nov 05, 2020 at 02:02:24PM +0000, Matthew Wilcox wrote:
>>> On Thu, Nov 05, 2020 at 02:21:25PM +0100, Eric Dumazet wrote:
>>>> On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
>>>>> When the machine is under extreme memory pressure, the page_frag allocator
>>>>> signals this to the networking stack by marking allocations with the
>>>>> 'pfmemalloc' flag, which causes non-essential packets to be dropped.
>>>>> Unfortunately, even after the machine recovers from the low memory
>>>>> condition, the page continues to be used by the page_frag allocator,
>>>>> so all allocations from this page will continue to be dropped.
>>>>>
>>>>> Fix this by freeing and re-allocating the page instead of recycling it.
>>>>>
>>>>> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>>> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>>>>> Cc: Bert Barbe <bert.barbe@oracle.com>
>>>>> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
>>>>> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
>>>>> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
>>>>> Cc: Joe Jin <joe.jin@oracle.com>
>>>>> Cc: SRINIVAS <srinivas.eeda@oracle.com>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
>>>>
>>>> Your patch looks fine, although this Fixes: tag seems incorrect.
>>>>
>>>> 79930f5892e ("net: do not deplete pfmemalloc reserve") was propagating
>>>> the page pfmemalloc status into the skb, and seems correct to me.
>>>>
>>>> The bug was the page_frag_alloc() was keeping a problematic page for
>>>> an arbitrary period of time ?
>>>
>>> Isn't this the commit which unmasks the problem, though?  I don't think
>>> it's the buggy commit, but if your tree doesn't have 79930f5892e, then
>>> you don't need this patch.
>>>
>>> Or are you saying the problem dates back all the way to
>>> c93bdd0e03e8 ("netvm: allow skb allocation to use PFMEMALLOC reserves")
>>>
>>>>> +		if (nc->pfmemalloc) {
>>>>
>>>>                 if (unlikely(nc->pfmemalloc)) {
>>>
>>> ACK.  Will make the change once we've settled on an appropriate Fixes tag.
>>
>> Which commit should I claim this fixes?
> 
> Hmm, no big deal, lets not waste time on tracking precise bug origin.
> 
