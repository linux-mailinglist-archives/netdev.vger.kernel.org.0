Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6C78D4B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfG2N66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:58:58 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6462 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfG2N66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 09:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564408737; x=1595944737;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=cUxl9HPeglUrqY3N6XLnCdGaKQ8sk/xXsU9ire04d4Y=;
  b=uF9OmGr+E5e1yBfi04YW5fn2S4p47RJGhblMHrl2BKTfo2n4XxkN/rJD
   8tmwpexpABP/taHXN9VOzf7Oq11+b5FdY1B8lUeG88rcNONrhQWiu6VJa
   6UqeJxW+dWuaKo8MSQ2TA5SRMq8CMdprlvqWG1V05jdWWfa8+VE5K+ryK
   8=;
X-IronPort-AV: E=Sophos;i="5.64,322,1559520000"; 
   d="scan'208";a="688845118"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 29 Jul 2019 13:53:48 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id E3143A1BA2;
        Mon, 29 Jul 2019 13:53:47 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 29 Jul 2019 13:53:47 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.219) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 29 Jul 2019 13:53:43 +0000
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
To:     Michal Kalderon <mkalderon@marvell.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182F4557BC042EE37A3C565A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <d632598e-0896-fa10-9148-73794a9a49d7@amazon.com>
Date:   Mon, 29 Jul 2019 16:53:38 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR18MB3182F4557BC042EE37A3C565A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.219]
X-ClientProxiedBy: EX13D14UWB004.ant.amazon.com (10.43.161.137) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2019 15:58, Michal Kalderon wrote:
>> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
>> owner@vger.kernel.org> On Behalf Of Jason Gunthorpe
>>
>>> +	xa_lock(&ucontext->mmap_xa);
>>> +	if (check_add_overflow(ucontext->mmap_xa_page,
>>> +			       (u32)(length >> PAGE_SHIFT),
>>> +			       &next_mmap_page))
>>> +		goto err_unlock;
>>
>> I still don't like that this algorithm latches into a permanent failure when the
>> xa_page wraps.
>>
>> It seems worth spending a bit more time here to tidy this.. Keep using the
>> mmap_xa_page scheme, but instead do something like
>>
>> alloc_cyclic_range():
>>
>> while () {
>>    // Find first empty element in a cyclic way
>>    xa_page_first = mmap_xa_page;
>>    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
>>
>>    // Is there a enough room to have the range?
>>    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
>>       mmap_xa_page = 0;
>>       continue;
>>    }
>>
>>    // See if the element before intersects
>>    elm = xa_find(xa, &zero, xa_page_end, 0);
>>    if (elm && intersects(xa_page_first, xa_page_last, elm->first, elm->last)) {
>>       mmap_xa_page = elm->last + 1;
>>       continue
>>    }
>>
>>    // xa_page_first -> xa_page_end should now be free
>>    xa_insert(xa, xa_page_start, entry);
>>    mmap_xa_page = xa_page_end + 1;
>>    return xa_page_start;
>> }
>>
>> Approximately, please check it.
> Gal & Jason, 
> 
> Coming back to the mmap_xa_page algorithm. I couldn't find some background on this. 
> Why do you need the length to be represented in the mmap_xa_page ?  
> Why not simply use xa_alloc_cyclic ( like in siw ) 
> This is simply a key to a mmap object... 

The intention was that the entry would "occupy" number of xarray elements
according to its size (in pages). It wasn't initially like this, but IIRC this
was preferred by Jason.
