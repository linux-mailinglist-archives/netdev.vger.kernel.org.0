Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846C736E4F5
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbhD2GlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:41:21 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61846 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhD2GlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619678436; x=1651214436;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bGZnl5Autqk5xCTAmoNMi/8tyswLwmLsZMcIoriWLEM=;
  b=dUK3eH0N7HmXCOdLA+5jYa7wHdUfVU8znhQaXMJycj8km240cLG/XYZh
   ZLtcvuZZ7trawZf2vDrHc2NW8nA9Cr/630qHkWvl/fSCy39cqvSXSzZAJ
   h5gDX3OFizkU8oq/guLAOpV2OSHiz+j/gj8qoYCOoA52EKmr4xVrSzjx1
   U=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="106199253"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 29 Apr 2021 06:40:29 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 155B1A21BD;
        Thu, 29 Apr 2021 06:40:26 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.161.85) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 06:40:22 +0000
Subject: Re: [PATCH iproute2-next 2/2] rdma: Add copy-on-fork to get sys
 command
To:     Leon Romanovsky <leon@kernel.org>
CC:     David Ahern <dsahern@gmail.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20210428114231.96944-1-galpress@amazon.com>
 <20210428114231.96944-3-galpress@amazon.com> <YIlObZNuu8TBxHLH@unreal>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <920dc792-dd72-f125-5546-fff9edb4b9a5@amazon.com>
Date:   Thu, 29 Apr 2021 09:40:16 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIlObZNuu8TBxHLH@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D49UWC004.ant.amazon.com (10.43.162.106) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2021 15:00, Leon Romanovsky wrote:
> On Wed, Apr 28, 2021 at 02:42:31PM +0300, Gal Pressman wrote:
>> The new attribute indicates that the kernel copies DMA pages on fork,
>> hence fork support through madvise and MADV_DONTFORK is not needed.
>>
>> If the attribute is not reported (expected on older kernels),
>> copy-on-fork is disabled.
>>
>> Example:
>> $ rdma sys
>> netns shared
>> copy-on-fork on
> 
> I don't think that we need to print them on separate lines.
> $ rdma sys
> netns shared copy-on-fork on

Ack.

>> Signed-off-by: Gal Pressman <galpress@amazon.com>
>> ---
>>  rdma/sys.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/rdma/sys.c b/rdma/sys.c
>> index 8fb565d70598..dd9c6da33e2a 100644
>> --- a/rdma/sys.c
>> +++ b/rdma/sys.c
>> @@ -38,6 +38,15 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
>>  		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
>>  				   mode_str);
>>  	}
>> +
>> +	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
>> +		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
>> +				   "copy-on-fork %s\n",
>> +				   mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]));
>> +	else
>> +		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
>> +				   "copy-on-fork %s\n", false);
> 
> Let's simplify it
>         bool cow = false;
> 
>  +	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
>  +		cow = mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]);
>  +
>  +	print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork", "copy-on-fork %s", cow);

Ack (changed cow -> cof).

Thanks
