Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FCD29ACC7
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751832AbgJ0NHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:07:11 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18747 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbgJ0NHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 09:07:10 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f981b850000>; Tue, 27 Oct 2020 06:07:17 -0700
Received: from [172.27.0.89] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 27 Oct
 2020 13:07:05 +0000
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>
CC:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <5b4368f9-c231-bcf4-28af-7a9bcac02eb4@nvidia.com>
Date:   Tue, 27 Oct 2020 15:06:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603804037; bh=6Q/IdCWw38YxALtmasbIeodS+QkH/1f5Xs2g0ojNtug=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=dO8XL3Inf54YR8XkHIfCgLVYwUP6+sbCHyysJElERfn38mZYsxUulhQDkvBP0+hhn
         t5B3UnB65Y2ZPOCcCfdOXZt+om6cU4kaHzeQZjKtFAaFUMl0QJms6REmu3QVemlLXI
         PMfOVkz/bNsKUYO73NIPOCi/Nu8+Sylur1e/7pNum9EmwKK+Hghiy/ChMBH8ieAbFJ
         CFVdD1sm5yM6L9jpUT9asr3Bm/RHXfS8b37wdLRFMrOgu03DIXFL+gh+RagvJY2TI+
         33Skylc/CMEBpp9JI2Juza/vGW25XVlz2tcAw6LN681v3pXp6KrqfeXBCDppHDTRFd
         2j5KeEDTYOgxw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/27/2020 2:20 PM, Jason Gunthorpe wrote:
> There are two flows for handling RDMA_CM_EVENT_ROUTE_RESOLVED, either the
> handler triggers a completion and another thread does rdma_connect() or
> the handler directly calls rdma_connect().
>
> In all cases rdma_connect() needs to hold the handler_mutex, but when
> handler's are invoked this is already held by the core code. This causes
> ULPs using the 2nd method to deadlock.
>
> Provide a rdma_connect_locked() and have all ULPs call it from their
> handlers.
>
> Link: https://lore.kernel.org/r/0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com
> Reported-and-tested-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> Fixes: 2a7cec538169 ("RDMA/cma: Fix locking for the RDMA_CM_CONNECT state")
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/infiniband/core/cma.c            | 40 +++++++++++++++++++++---
>   drivers/infiniband/ulp/iser/iser_verbs.c |  2 +-
>   drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  4 +--
>   drivers/nvme/host/rdma.c                 |  4 +--
>   include/rdma/rdma_cm.h                   | 14 ++-------
>   net/rds/ib_cm.c                          |  5 +--
>   6 files changed, 46 insertions(+), 23 deletions(-)
>
> v2:
>   - Remove extra code from nvme (Chao)
>   - Fix long lines (CH)
>
> I've applied this version to rdma-rc - expecting to get these ULPs unbroken for rc2
> release
>
> Thanks,
> Jason
>
iser and nvme/rdma looks good to me,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

