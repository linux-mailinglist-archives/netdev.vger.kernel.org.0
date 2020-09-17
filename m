Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119E326E45F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgIQSqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:46:33 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:8373 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIQSqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600368365; x=1631904365;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=Tm6gn1QtyihovfasjUSGoayf+a5O6HkeWrW+15QsqjE=;
  b=tFJ+Rw8jfhygNIeZS+dHB/QMCmHE2Jh1v+L4I/UM4TUynw/ZwDNQ2Vfo
   PVXqnGNxaFg6RN0NOSAYPUe5VhC5ENKEegJGJ+RtkeGQTqZ/aJ5PVIXZX
   zgPxaf4zYUEnWqFDOQnyl6t4oXXLMpIChMvKtwc2OCIwO8koWkDknvKWq
   8=;
X-IronPort-AV: E=Sophos;i="5.77,271,1596499200"; 
   d="scan'208";a="56094228"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 17 Sep 2020 18:46:03 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 727E8A18D1;
        Thu, 17 Sep 2020 18:46:02 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.137) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Sep 2020 18:45:53 +0000
References: <20200913081640.19560-1-shayagr@amazon.com> <20200913081640.19560-3-shayagr@amazon.com> <20200913.143022.1949357995189636518.davem@davemloft.net>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>,
        <amitbern@amazon.com>
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log prefix to files
In-Reply-To: <20200913.143022.1949357995189636518.davem@davemloft.net>
Date:   Thu, 17 Sep 2020 21:45:36 +0300
Message-ID: <pj41zlk0wsdyy7.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D46UWC003.ant.amazon.com (10.43.162.119) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Shay Agroskin <shayagr@amazon.com>
> Date: Sun, 13 Sep 2020 11:16:34 +0300
>
>> ENA logs are adjusted to display the full ENA representation to
>> distinct each ENA device in case of multiple interfaces.
>> Using dev_err/warn/info function family for logging provides 
>> uniform
>> printing with clear distinction of the driver and device.
>> 
>> This patch changes all printing in ena_com files to use dev_* 
>> logging
>> messages. It also adds some log messages to make driver 
>> debugging
>> easier.
>> 
>> Signed-off-by: Amit Bernstein <amitbern@amazon.com>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>
> This device prefix is so much less useful than printing the 
> actual
> networking adapter that the ena_com operations are for.
>
> So if you are going to do this, go all the way and pass the 
> ena_adapter
> or the netdev down into these ena_com routines so that you can 
> use
> the netdev_*() message helpers.
>
> Thank you.

Hi David, I researched the possibility to use netdev_* functions 
in this patch. Currently our driver initializes the net_device 
only after calling some functions in ena_com files.
Although netdev_* log family functions can be used before 
allocating a net_device struct, the print it produces in such a 
case is less informative than the dev_* log print (which at least 
specifies what pcie device made the print).

I would rather change the allocation order for the net_device 
struct in our driver, so that when calling ena_com device it would 
always be allocated (and this way all ena_com prints could be 
transformed into netdev/netif_* log family).
This change seems doable, but requires us to do some internal 
testing before sending it. I could remove this whole patch, but 
then our driver would be left with pr_err() functions in it which 
is even less informative than dev_err().

Can we go through with this patch, and send a future patch which 
changes all dev_* functions into netif/netdev_* along with the 
change in the allocation order of the net_device struct ? I know 
it sounds like a procrastination attempt, but I would really 
prefer not to drop the patch and leave the driver with pr_* log 
prints.

Thanks,
Shay
