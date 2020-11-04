Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D262A6A0D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbgKDQlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:41:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60138 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKDQlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:41:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4GfPjk112120;
        Wed, 4 Nov 2020 16:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gabS+7pi80QTYAiYxuXmgtvj8rFk8z5xZp9KfDf5fKk=;
 b=yXAKp3kIOlo30ABMWu1JgtUOoPx1y5NFlrUVXBqpQWCLO/51NgUOldAxvLB7YUfGDTr+
 7NUL5lkicvGzY5AtNDp8InUqkkg3RgMdbYbHKyHsFZnn42X3NaucDPJHZxkIAbfteKoj
 XrfXOLRYqjyRP7EdUM5D4hAW8Ga1BuLpO0OFa/fJ8B8VF75EQK01ArebUC2nuVSrljIU
 tFG224jCDuKYvSardhNCI+PXOEOLKSPsfEpcD50cUhDwx44T0TyQXMF9TmdA3lJMuS/E
 5vgQm8HWi4tqdsxVR8wj4vIyCSv1DK4PqcWcZkE4A76DYusp4BRu1cQu5mxOuhScVorZ ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb27qf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 16:41:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4Gdlqo152386;
        Wed, 4 Nov 2020 16:41:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34hvry2kfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 16:41:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A4GfVT3031320;
        Wed, 4 Nov 2020 16:41:31 GMT
Received: from [10.159.134.50] (/10.159.134.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 08:41:31 -0800
Subject: Re: [PATCH 1/1] mm: avoid re-using pfmemalloc page in
 page_frag_alloc()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, aruna.ramakrishna@oracle.com,
        bert.barbe@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com
References: <20201103193239.1807-1-dongli.zhang@oracle.com>
 <20201103203500.GG27442@casper.infradead.org>
 <7141038d-af06-70b2-9f50-bf9fdf252e22@oracle.com>
 <20201103211541.GH27442@casper.infradead.org>
 <20201104011640.GE2445@rnichana-ThinkPad-T480>
 <2bce996a-0a62-9d14-4310-a4c5cb1ddeae@gmail.com>
 <20201104123659.GA17076@casper.infradead.org>
 <053d1d51-430a-2fa9-fb72-fee5d2f9785c@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <2bb0d1dd-5b40-e0e1-9fed-7bfcbc3de6a6@oracle.com>
Date:   Wed, 4 Nov 2020 08:41:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <053d1d51-430a-2fa9-fb72-fee5d2f9785c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/20 4:51 AM, Eric Dumazet wrote:
> 
> 
> On 11/4/20 1:36 PM, Matthew Wilcox wrote:
>> On Wed, Nov 04, 2020 at 09:50:30AM +0100, Eric Dumazet wrote:
>>> On 11/4/20 2:16 AM, Rama Nichanamatlu wrote:
>>>>> Thanks for providing the numbers.  Do you think that dropping (up to)
>>>>> 7 packets is acceptable?
>>>>
>>>> net.ipv4.tcp_syn_retries = 6
>>>>
>>>> tcp clients wouldn't even get that far leading to connect establish issues.
>>>
>>> This does not really matter. If host was under memory pressure,
>>> dropping a few packets is really not an issue.
>>>
>>> Please do not add expensive checks in fast path, just to "not drop a packet"
>>> even if the world is collapsing.
>>
>> Right, that was my first patch -- to only recheck if we're about to
>> reuse the page.  Do you think that's acceptable, or is that still too
>> close to the fast path?
> 
> I think it is totally acceptable.
> 
> The same strategy is used in NIC drivers, before recycling a page.
> 
> If page_is_pfmemalloc() returns true, they simply release the 'problematic'page
> and attempt a new allocation.
> 
> ( git grep -n page_is_pfmemalloc -- drivers/net/ethernet/ )

While the drivers may implement their own page_frag_cache to manage skb->frags ...

... the skb->data is usually allocated via __netdev_alloc_skb() or
napi_alloc_skb(), which end up to the global this_cpu_ptr(&netdev_alloc_cache)
or this_cpu_ptr(&napi_alloc_cache.page).

> 
> 
>>
>>> Also consider that NIC typically have thousands of pre-allocated page/frags
>>> for their RX ring buffers, they might all have pfmemalloc set, so we are speaking
>>> of thousands of packet drops before the RX-ring can be refilled with normal (non pfmemalloc) page/frags.
>>>
>>> If we want to solve this issue more generically, we would have to try
>>> to copy data into a non pfmemalloc frag instead of dropping skb that
>>> had frags allocated minutes ago under memory pressure.
>>
>> I don't think we need to copy anything.  We need to figure out if the
>> system is still under memory pressure, and if not, we can clear the
>> pfmemalloc bit on the frag, as in my second patch.  The 'least change'
>> way of doing that is to try to allocate a page, but the VM could export
>> a symbol that says "we're not under memory pressure any more".
>>
>> Did you want to move checking that into the networking layer, or do you
>> want to keep it in the pagefrag allocator?
> 
> I think your proposal is fine, thanks !

Hi Matthew, are you going to send out the patch to avoid pfmemalloc recycle?

Thank you very much!

Dongli Zhang
