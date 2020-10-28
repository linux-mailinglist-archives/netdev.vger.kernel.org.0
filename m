Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C3E29DA60
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbgJ1XVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:21:05 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1455 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390129AbgJ1XVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:21:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99728e0002>; Wed, 28 Oct 2020 06:30:54 -0700
Received: from [172.27.12.9] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 13:31:06 +0000
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>,
        "Max Gurtovoy" <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
 <4401b7b1-5d05-a715-4701-957fd09f34c9@nvidia.com>
 <20201028121437.GU1523783@nvidia.com>
From:   Maor Gottlieb <maorg@nvidia.com>
Message-ID: <8306260b-ce24-3803-7d39-42f5d2209af7@nvidia.com>
Date:   Wed, 28 Oct 2020 15:31:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.3
MIME-Version: 1.0
In-Reply-To: <20201028121437.GU1523783@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603891854; bh=fKN2cuSU18H4ENLzpHtOq1/kruo8GahizM1U701HZ08=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=dfLB2rsS1jUeLVi1EHeqpVPZWc/4tQtRWeoiQezb8WagHM2EcW7c/0f1dboAtSOG6
         IXyLr9NhAuGTFluamN3ynArryMwcDQwtPhZ0TYR+nRvXYYVOtTAx4X7GZg/tot7M2p
         7ruyD2L7GnnqM30XK6BApKEHUxrN9la+USpL5oMPyaNTpbvi0ccrfmEUZUPqymKFHJ
         glkEMEt11eJbAhHl3+SV+3ancTya0jEfZNi7WAyrlOwKhz0fflBOj3KL2DMnBJocIV
         mYY8+o9QX8TuAIyH+N13YrhDQwAsY2/WLdDl6I60N9sKzqgDkQpjdMR4wQEVVccX+7
         dv4Or74fAEf/A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/28/2020 2:14 PM, Jason Gunthorpe wrote:
> On Wed, Oct 28, 2020 at 11:19:14AM +0200, Maor Gottlieb wrote:
>>> +			struct rdma_conn_param *conn_param)
>>>    {
>>>    	struct rdma_id_private *id_priv =
>>>    		container_of(id, struct rdma_id_private, id);
>>>    	int ret;
>>> -	mutex_lock(&id_priv->handler_mutex);
>> You need to delete the mutex_unlock in success path too.
> Gaaaaah. Just goes to prove I shouldn't write patches with a child on
> my lap :\
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index f58d19881524dc..a77750b8954db0 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4072,7 +4072,6 @@ int rdma_connect_locked(struct rdma_cm_id *id,
>   		ret = -ENOSYS;
>   	if (ret)
>   		goto err_state;
> -	mutex_unlock(&id_priv->handler_mutex);
>   	return 0;
>   err_state:
>   	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
>
> Thanks,
> Jason

Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
