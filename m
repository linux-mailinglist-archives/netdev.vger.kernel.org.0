Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B58DA1A15
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfH2Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:31:50 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36572 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727069AbfH2Mbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 08:31:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3226DFB200799E2FEAAB;
        Thu, 29 Aug 2019 20:31:48 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Thu, 29 Aug 2019
 20:31:45 +0800
Subject: Re: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
To:     Parav Pandit <parav@mellanox.com>, <alex.williamson@redhat.com>,
        <jiri@mellanox.com>, <kwankhede@nvidia.com>, <cohuck@redhat.com>,
        <davem@davemloft.net>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190829111904.16042-1-parav@mellanox.com>
 <20190829111904.16042-3-parav@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <56a88778-c90e-1ac6-9a31-d1aaa5dec97b@huawei.com>
Date:   Thu, 29 Aug 2019 20:31:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190829111904.16042-3-parav@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/29 19:19, Parav Pandit wrote:
> Mdev alias should be unique among all the mdevs, so that when such alias
> is used by the mdev users to derive other objects, there is no
> collision in a given system.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v1->v2:
>  - Moved alias NULL check at beginning
> v0->v1:
>  - Fixed inclusiong of alias for NULL check
>  - Added ratelimited debug print for sha1 hash collision error
> ---
>  drivers/vfio/mdev/mdev_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 3bdff0469607..c9bf2ac362b9 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -388,6 +388,13 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
>  			ret = -EEXIST;
>  			goto mdev_fail;
>  		}
> +		if (alias && tmp->alias && strcmp(alias, tmp->alias) == 0) {

!strcmp(alias, tmp->alias) is a more common kernel pattern.

Also if we limit max len of the alias in patch 1, maybe use that to limit the
string compare too.

> +			mutex_unlock(&mdev_list_lock);
> +			ret = -EEXIST;
> +			dev_dbg_ratelimited(dev, "Hash collision in alias creation for UUID %pUl\n",
> +					    uuid);
> +			goto mdev_fail;
> +		}
>  	}
>  
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> 

