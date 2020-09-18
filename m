Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27C626FB9C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgIRLgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:36:31 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42773 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 07:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600428991; x=1631964991;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nljtf6hdR/qE6PkJVRvJ0+HS2IaDJRrBUTD9DTWwKQY=;
  b=gIPmWXHdIHMiT+cJK7Qlr6RTABmiJL80td+vn4HzE0FHHvmfn1ijcDOh
   5ZcX5DKhsqRb46xr60vZHeTCaSiSx9/0wLeKRMKmDoiTC5s+R4BNk+kSF
   MNzZgpabMYkbetaOakZKYob8pejVBGE1fGeVGBL/MBRdNdfl8MFM4PVbE
   0=;
X-IronPort-AV: E=Sophos;i="5.77,274,1596499200"; 
   d="scan'208";a="76049645"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 18 Sep 2020 11:36:27 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 8C8E6A1CA6;
        Fri, 18 Sep 2020 11:36:23 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.162.73) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 18 Sep 2020 11:36:16 +0000
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>, Oded Gabbay <oded.gabbay@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-rdma@vger.kernel.org>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
Date:   Fri, 18 Sep 2020 14:36:10 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917171833.GJ8409@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D16UWB001.ant.amazon.com (10.43.161.17) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2020 20:18, Jason Gunthorpe wrote:
> On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
>> infrastructure for communication between multiple accelerators. Same
>> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
>> The RDMA implementation we did does NOT support some basic RDMA
>> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
>> library or to connect to the rdma infrastructure in the kernel. 
> 
> You can't create a parallel RDMA subsystem in netdev, or in misc, and
> you can't add random device offloads as IOCTL to nedevs.
> 
> RDMA is the proper home for all the networking offloads that don't fit
> into netdev.
> 
> EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> all. I'm sure this can too.

Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
was suggested to go through the vfio subsystem instead.

I think this comes back to the discussion we had when EFA was upstreamed, which
is what's the bar to get accepted to the RDMA subsystem.
IIRC, what we eventually agreed on is having a userspace rdma-core provider and
ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).

Does GAUDI fit these requirements? If not, should it be in a different subsystem
or should we open the "what qualifies as an RDMA device" question again?
