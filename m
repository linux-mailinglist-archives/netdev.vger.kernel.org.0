Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7712A56BD
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbgKCVap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:30:45 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53116 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732086AbgKCU5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 15:57:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3KrlH4171947;
        Tue, 3 Nov 2020 20:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YI6BkSHLxwvNyqU9vC512qENvgOQlE4vTsZXoXMup2M=;
 b=gWkzGabsOUaJkP5mU4M55FvVqzW8Hk7v32dUgiDVsLWT/4RYzY6IZVSzBC1nNdkXT3mc
 dzTHuJ/FSzeKrpOlUcUmYf1LQJ+kFUwSB2Fhh0RFaleH/GPOBOr12Tc3+4pgKwDESHVr
 Yt7ZYG11UdcfDQJI4i/C00jrWI9Mbf7FFLjRUPfqYDMjHMSmWY2qjPnQ9H8oHxrU3Yh0
 riAkt90BHogQ0uKuSMEdwqAqVLHDczZz4n9c2lJapTxSN2sIW7PHKacRWu+TiA2JgWwF
 5gPLevGpD2d/mQgsG7q6IEyO2qKAUZTOoZyJyDc8bWc9ZF9WhQ6P5p1wRyJB0wj0ip+z xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34hhb23hmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 20:57:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3Ksglb121385;
        Tue, 3 Nov 2020 20:57:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34hw0e66dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 20:57:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A3KvZNJ031275;
        Tue, 3 Nov 2020 20:57:36 GMT
Received: from [10.159.227.161] (/10.159.227.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 12:57:35 -0800
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
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
Date:   Tue, 3 Nov 2020 12:57:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201103203500.GG27442@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 clxscore=1011 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

On 11/3/20 12:35 PM, Matthew Wilcox wrote:
> On Tue, Nov 03, 2020 at 11:32:39AM -0800, Dongli Zhang wrote:
>> The ethernet driver may allocates skb (and skb->data) via napi_alloc_skb().
>> This ends up to page_frag_alloc() to allocate skb->data from
>> page_frag_cache->va.
>>
>> During the memory pressure, page_frag_cache->va may be allocated as
>> pfmemalloc page. As a result, the skb->pfmemalloc is always true as
>> skb->data is from page_frag_cache->va. The skb will be dropped if the
>> sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
>> under memory pressure.
>>
>> However, once kernel is not under memory pressure any longer (suppose large
>> amount of memory pages are just reclaimed), the page_frag_alloc() may still
>> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
>> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
>> re-allocated, even the kernel is not under memory pressure any longer.
>>
>> Here is how kernel runs into issue.
>>
>> 1. The kernel is under memory pressure and allocation of
>> PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
>> the pfmemalloc page is allocated for page_frag_cache->va.
>>
>> 2: All skb->data from page_frag_cache->va (pfmemalloc) will have
>> skb->pfmemalloc=true. The skb will always be dropped by sock without
>> SOCK_MEMALLOC. This is an expected behaviour.
>>
>> 3. Suppose a large amount of pages are reclaimed and kernel is not under
>> memory pressure any longer. We expect skb->pfmemalloc drop will not happen.
>>
>> 4. Unfortunately, page_frag_alloc() does not proactively re-allocate
>> page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
>> skb->pfmemalloc is always true even kernel is not under memory pressure any
>> longer.
>>
>> Therefore, this patch always checks and tries to avoid re-using the
>> pfmemalloc page for page_frag_alloc->va.
>>
>> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>> Cc: Bert Barbe <bert.barbe@oracle.com>
>> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
>> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
>> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Cc: SRINIVAS <srinivas.eeda@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  mm/page_alloc.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 23f5066bd4a5..291df2f9f8f3 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5075,6 +5075,16 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>>  	struct page *page;
>>  	int offset;
>>  
>> +	/*
>> +	 * Try to avoid re-using pfmemalloc page because kernel may already
>> +	 * run out of the memory pressure situation at any time.
>> +	 */
>> +	if (unlikely(nc->va && nc->pfmemalloc)) {
>> +		page = virt_to_page(nc->va);
>> +		__page_frag_cache_drain(page, nc->pagecnt_bias);
>> +		nc->va = NULL;
>> +	}
> 
> I think this is the wrong way to solve this problem.  Instead, we should
> use up this page, but refuse to recycle it.  How about something like this (not even compile tested):

Thank you very much for the feedback. Yes, the option is to use the same page
until it is used up (offset < 0). Instead of recycling it, the kernel free it
and allocate new one.

This depends on whether we will tolerate the packet drop until this page is used up.

For virtio-net, the payload (skb->data) is of size 128-byte. The padding and
alignment will finally make it as 512-byte.

Therefore, for virtio-net, we will have at most 4096/512-1=7 packets dropped
before the page is used up.

Dongli Zhang

> 
> +++ b/mm/page_alloc.c
> @@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  
>                 if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>                         goto refill;
> +               if (nc->pfmemalloc) {
> +                       free_the_page(page);
> +                       goto refill;
> +               }
>  
>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>                 /* if size can vary use size else just use PAGE_SIZE */
> 
