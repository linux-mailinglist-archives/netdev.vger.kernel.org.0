Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052302A5BC0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgKDBTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:19:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbgKDBTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 20:19:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A41GC9u166601;
        Wed, 4 Nov 2020 01:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gJQLTwlXCcujwtSP+cbUgq0oYqCQI1AU9Frvz2gh8FI=;
 b=PJnONpOgcYuW+XADb68dFOF3/T0ODsobWtBqJEicKZLyVKYPkucTryXWrVuQcbe862eT
 e4P/ptmibWR9I8TBCf8MttYcKeVdutK5KLkgesBvay+kXLZnxNClSnFooRrZKhCHFPvu
 5dH+i0MIbYtUwJQRDTIlq7HqcdZ9+yU0b37Ex7lRlaZeHuRgIixhIHIdsXnK9cMYvOI+
 98qp1OdVFkqgmgQyDNkRsG5vY1xKRssQOvAkoFHQ4hZPrBo6W0tQBIo7x5+bGJV4sbbA
 IKeyayG8526XPPNc+JYs6ecxL/FNeIBJjZiUaZg5ShLrYnnqN2uFoQi2ZCHknHfVuDqw Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34hhvccbky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 01:18:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A41Egji013517;
        Wed, 4 Nov 2020 01:16:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34hw0ee1g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 01:16:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A41GmI1009435;
        Wed, 4 Nov 2020 01:16:49 GMT
Received: from rnichana-ThinkPad-T480 (/10.159.241.204)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 17:16:48 -0800
Date:   Tue, 3 Nov 2020 17:16:40 -0800
From:   Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
Message-ID: <20201104011640.GE2445@rnichana-ThinkPad-T480>
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201103211541.GH27442@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011040006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Thanks for providing the numbers.  Do you think that dropping (up to)
>7 packets is acceptable?

net.ipv4.tcp_syn_retries = 6

tcp clients wouldn't even get that far leading to connect establish issues.

-rama
On Tue, Nov 03, 2020 at 09:15:41PM +0000, Matthew Wilcox wrote:
>On Tue, Nov 03, 2020 at 12:57:33PM -0800, Dongli Zhang wrote:
>> On 11/3/20 12:35 PM, Matthew Wilcox wrote:
>> > On Tue, Nov 03, 2020 at 11:32:39AM -0800, Dongli Zhang wrote:
>> >> However, once kernel is not under memory pressure any longer (suppose large
>> >> amount of memory pages are just reclaimed), the page_frag_alloc() may still
>> >> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
>> >> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
>> >> re-allocated, even the kernel is not under memory pressure any longer.
>> >> +	/*
>> >> +	 * Try to avoid re-using pfmemalloc page because kernel may already
>> >> +	 * run out of the memory pressure situation at any time.
>> >> +	 */
>> >> +	if (unlikely(nc->va && nc->pfmemalloc)) {
>> >> +		page = virt_to_page(nc->va);
>> >> +		__page_frag_cache_drain(page, nc->pagecnt_bias);
>> >> +		nc->va = NULL;
>> >> +	}
>> >
>> > I think this is the wrong way to solve this problem.  Instead, we should
>> > use up this page, but refuse to recycle it.  How about something like this (not even compile tested):
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
>My thinking is that if the kernel is under memory pressure then freeing
>the page and allocating a new one is likely to put even more strain
>on the memory allocator, so we want to do this "soon", rather than at
>each allocation.
>
>Thanks for providing the numbers.  Do you think that dropping (up to)
>7 packets is acceptable?
>
>We could also do something like ...
>
>        if (unlikely(nc->pfmemalloc)) {
>                page = alloc_page(GFP_NOWAIT | __GFP_NOWARN);
>                if (page)
>                        nc->pfmemalloc = 0;
>                put_page(page);
>        }
>
>to test if the memory allocator has free pages at the moment.  Not sure
>whether that's a good idea or not -- hopefully you have a test environment
>set up where you can reproduce this condition on demand and determine
>which of these three approaches is best!
