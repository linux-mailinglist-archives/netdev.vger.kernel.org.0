Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D9CCBFB4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390056AbfJDPsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389794AbfJDPsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 11:48:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287A020830;
        Fri,  4 Oct 2019 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570204098;
        bh=S2WPOl/0NG3P+Mug85lHlPzdbG1nDs6G5hw05L4rq7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gogeOTWhbb1G6lu8oXCbTK9S5PfIvspwQwfnbqhWBqa+hQQ8IKcyDwvPGeG08EnqQ
         qzDzKdG8vwYJM4Gn4OJSHW/FacZhCbzhEfQh8si6Yf/+0VN2jz5CTXRMRZd1ZleDh3
         vIJiykQYVLi5JEY2ueqXlhGTh0sp5nL6lh/SrZDY=
Date:   Fri, 4 Oct 2019 11:48:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "himadri18.07" <himadri18.07@gmail.com>
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
Message-ID: <20191004154817.GL17454@sasha-vm>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
 <MWHPR21MB078479F82BBA6D3E6527ECECD7DF0@MWHPR21MB0784.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MWHPR21MB078479F82BBA6D3E6527ECECD7DF0@MWHPR21MB0784.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 01:02:03AM +0000, Michael Kelley wrote:
>From: Himadri Pandya <himadrispandya@gmail.com> Sent: Wednesday, July 24, 2019 10:11 PM
>>
>> Older windows hosts require the hv_sock ring buffer to be defined
>> using 4K pages. This was achieved by using the symbol PAGE_SIZE_4K
>> defined specifically for this purpose. But now we have a new symbol
>> HV_HYP_PAGE_SIZE defined in hyperv-tlfs which can be used for this.
>>
>> This patch removes the definition of symbol PAGE_SIZE_4K and replaces
>> its usage with the symbol HV_HYP_PAGE_SIZE. This patch also aligns
>> sndbuf and rcvbuf to hyper-v specific page size using HV_HYP_PAGE_SIZE
>> instead of the guest page size(PAGE_SIZE) as hyper-v expects the page
>> size to be 4K and it might not be the case on ARM64 architecture.
>>
>> Signed-off-by: Himadri Pandya <himadri18.07@gmail.com>
>> ---
>>  net/vmw_vsock/hyperv_transport.c | 21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>> index f2084e3f7aa4..ecb5d72d8010 100644
>> --- a/net/vmw_vsock/hyperv_transport.c
>> +++ b/net/vmw_vsock/hyperv_transport.c
>> @@ -13,15 +13,16 @@
>>  #include <linux/hyperv.h>
>>  #include <net/sock.h>
>>  #include <net/af_vsock.h>
>> +#include <asm/hyperv-tlfs.h>
>>
>
>Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
>
>This patch depends on a prerequisite patch in
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/hyperv
>
>that defines HV_HYP_PAGE_SIZE.

David, the above prerequisite patch is now upstream, so this patch
should be good to go. Would you take it through the net tree or should I
do it via the hyperv tree?

--
Thanks,
Sasha
