Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4974EA36ED
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfH3Mk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:40:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727603AbfH3Mk7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:40:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E000018C427D;
        Fri, 30 Aug 2019 12:40:58 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06111100194E;
        Fri, 30 Aug 2019 12:40:54 +0000 (UTC)
Date:   Fri, 30 Aug 2019 14:40:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190830144052.11d23ec3.cohuck@redhat.com>
In-Reply-To: <20190829111904.16042-3-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 30 Aug 2019 12:40:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 06:19:00 -0500
Parav Pandit <parav@mellanox.com> wrote:

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
> +			mutex_unlock(&mdev_list_lock);
> +			ret = -EEXIST;
> +			dev_dbg_ratelimited(dev, "Hash collision in alias creation for UUID %pUl\n",
> +					    uuid);
> +			goto mdev_fail;
> +		}
>  	}
>  
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);

Any reason not to merge this into the first patch?
