Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC272A5730
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731741AbgKCViV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:38:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731989AbgKCVh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:37:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3LXgvb135931;
        Tue, 3 Nov 2020 21:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pjGTZnVPVMo+UEn55PVlTgrdUWSHrBw1ub5JyNbZy+0=;
 b=IlDe3XwPB/vgR9VYxtOf48IbhvcbWIbtH2reWESlQlFnDEG5EipX9/34FLgeAc0zYlVM
 cg9tNgO7mK3pptqwpS1vVU7cExXG6AME5TiYCJmITHdOfMI6DlbE3S6UfyttZAgSqRhx
 8r7GH2yWD/upAC7KhcmnQ5X1gr+qpH5sYawyXlj07rXOTlI10S3tit3umX/ZC3a+YK4a
 0lTalB64JZHV4wyuwUK6SeVNyZctNXsFPGUMUnNBEeSbLqJOv3T2oCoIBGg445OtrBer
 8XlZpCcBnlJj3SeJLHOkbyYgBgaqUdBlci0v9KBUT7ZoTDlxdZNEcyc0V7j36jT2xtoP fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvcbqxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 21:37:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3LYnRs182419;
        Tue, 3 Nov 2020 21:37:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34jf493kuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 21:37:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3LblCY000901;
        Tue, 3 Nov 2020 21:37:47 GMT
Received: from [10.159.227.161] (/10.159.227.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 13:37:47 -0800
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, aruna.ramakrishna@oracle.com,
        bert.barbe@oracle.com, rama.nichanamatlu@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <7fc532c3-8780-4484-6932-6bfabecda189@oracle.com>
Date:   Tue, 3 Nov 2020 13:37:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103211541.GH27442@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/20 1:15 PM, Matthew Wilcox wrote:
> On Tue, Nov 03, 2020 at 12:57:33PM -0800, Dongli Zhang wrote:
>> On 11/3/20 12:35 PM, Matthew Wilcox wrote:
>>> On Tue, Nov 03, 2020 at 11:32:39AM -0800, Dongli Zhang wrote:
>>>> However, once kernel is not under memory pressure any longer (suppose large
>>>> amount of memory pages are just reclaimed), the page_frag_alloc() may still
>>>> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
>>>> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
>>>> re-allocated, even the kernel is not under memory pressure any longer.
>>>> +	/*
>>>> +	 * Try to avoid re-using pfmemalloc page because kernel may already
>>>> +	 * run out of the memory pressure situation at any time.
>>>> +	 */
>>>> +	if (unlikely(nc->va && nc->pfmemalloc)) {
>>>> +		page = virt_to_page(nc->va);
>>>> +		__page_frag_cache_drain(page, nc->pagecnt_bias);
>>>> +		nc->va = NULL;
>>>> +	}
>>>
>>> I think this is the wrong way to solve this problem.  Instead, we should
>>> use up this page, but refuse to recycle it.  How about something like this (not even compile tested):
>>
>> Thank you very much for the feedback. Yes, the option is to use the same page
>> until it is used up (offset < 0). Instead of recycling it, the kernel free it
>> and allocate new one.
>>
>> This depends on whether we will tolerate the packet drop until this page is used up.
>>
>> For virtio-net, the payload (skb->data) is of size 128-byte. The padding and
>> alignment will finally make it as 512-byte.
>>
>> Therefore, for virtio-net, we will have at most 4096/512-1=7 packets dropped
>> before the page is used up.
> 
> My thinking is that if the kernel is under memory pressure then freeing
> the page and allocating a new one is likely to put even more strain
> on the memory allocator, so we want to do this "soon", rather than at
> each allocation.
> 
> Thanks for providing the numbers.  Do you think that dropping (up to)
> 7 packets is acceptable?>
> We could also do something like ...
> 
>         if (unlikely(nc->pfmemalloc)) {
>                 page = alloc_page(GFP_NOWAIT | __GFP_NOWARN);
>                 if (page)
>                         nc->pfmemalloc = 0;
>                 put_page(page);
>         }
> 
> to test if the memory allocator has free pages at the moment.  Not sure
> whether that's a good idea or not -- hopefully you have a test environment
> set up where you can reproduce this condition on demand and determine
> which of these three approaches is best!
> 


From mm's perspective, we expect to reduce the number of page allocation
(especially under memory pressure).

From networking's perspective, we expect to reduce the number of skb drop.

That's why I CCed netdev folks (including David and Jakub), although the patch
is for mm/page_alloc.c. The page_frag_alloc() is primarily used by networking
and nvme-tcp.


Unfortunately, so far I do not have the env to reproduce. I reproduced with a
patch to fail page allocation and set nc->pfmemalloc on purpose.

From mm's perspective, I think to use up the page is a good option. Indeed tt is
system administrator's duty to avoid memory pressure, in order to avoid the
extra packet drops.

Dongli Zhang
