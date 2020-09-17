Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42E126E6DB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIQUmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:42:36 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:30861 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgIQUmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:42:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600375356; x=1631911356;
  h=references:from:to:cc:subject:message-id:in-reply-to:
   date:mime-version;
  bh=Xw3SbsX0I6fHN7+dBF4HZ0B+m5MossERQUlwNKM92ns=;
  b=kO+ltg+9Qbl9oaOjS286cLCPoMmFjHLR4BygWmENS5i3Tq4fm/lH95pf
   thMtxqdpbWVIv2D8KVfPJEaD1grUsI1a50e2VcKjtcJb1Qw75Bri5a85v
   krBo8W9ZnwdTqwcWyVYYhME2F+r3byPDXa9PwIhgZrQ6mSlwC+s2CVlQe
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,272,1596499200"; 
   d="scan'208";a="54495380"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 17 Sep 2020 20:42:34 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id A6B6DA18B8;
        Thu, 17 Sep 2020 20:42:33 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Sep 2020 20:42:24 +0000
References: <20200913.143022.1949357995189636518.davem@davemloft.net> <pj41zlk0wsdyy7.fsf@u68c7b5b1d2d758.ant.amazon.com> <339bb56eebdddbefb5da87d4f97b7bbe74e9f4b4.camel@kernel.org> <20200917.131223.1581791862348029357.davem@davemloft.net>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     <saeed@kernel.org>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>, <amitbern@amazon.com>
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log prefix to files
Message-ID: <pj41zlimccdudx.fsf@u68c7b5b1d2d758.ant.amazon.com>
In-Reply-To: <20200917.131223.1581791862348029357.davem@davemloft.net>
Date:   Thu, 17 Sep 2020 23:42:11 +0300
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D45UWB004.ant.amazon.com (10.43.161.54) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Saeed Mahameed <saeed@kernel.org>
> Date: Thu, 17 Sep 2020 12:38:28 -0700
>
>> allocated but unregistered netdevices also do not help much as 
>> the name
>> of the netdev is not assigned yet.
>> 
>> why don't use dev_info(pci_dev) macors  for low level functions 
>> when
>> netdev is not available or not allocated yet.
>
> The problem in this case is that they have this huge suite of
> functions that operate on a specific ena sub-object.  Most of 
> the time
> the associated netdev is fully realized, but in the few calls 
> made
> during early probe it is not.
>
> To me it is a serious loss that just because a small number of 
> times
> the interface lacks a fully realized netdev object, we can't use 
> the
> netdev_*() routines.
>
> Most users aren't going to understand that an error message for 
> PCI
> device XyZ means eth0 is having problems.

I agree that netdev_* functions would be more useful, which is why 
we're working on a patch to transform ena_com functions to use 
them as well.
For the time being, switching to dev_* functions makes the 
driver's logs more informative than pr_* functions.

I would rather not divide ena_com functions to use netdev_* and 
dev_* according to net_device allocative state just for this 
patch. Doing so, besides doing quite some work for a temporary 
solution, wouldn't provide a full solution (same as it doesn't in 
this patch).
As stated, a more complete solution is in the works. We can look 
at the glass as being half full, and decide that this patch 
improves the previous situation even if not in the most optimal 
solution.

thanks,
Shay
