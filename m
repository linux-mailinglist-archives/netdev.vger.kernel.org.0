Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677D79E5AF
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfH0K3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:29:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfH0K3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 06:29:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D8613C93;
        Tue, 27 Aug 2019 10:29:36 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C98A45CB;
        Tue, 27 Aug 2019 10:29:31 +0000 (UTC)
Date:   Tue, 27 Aug 2019 12:29:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190827122928.752e763b.cohuck@redhat.com>
In-Reply-To: <20190826204119.54386-3-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 27 Aug 2019 10:29:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 15:41:17 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Mdev alias should be unique among all the mdevs, so that when such alias
> is used by the mdev users to derive other objects, there is no
> collision in a given system.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index e825ff38b037..6eb37f0c6369 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
>  			ret = -EEXIST;
>  			goto mdev_fail;
>  		}
> +		if (tmp->alias && strcmp(tmp->alias, alias) == 0) {

Any way we can relay to the caller that the uuid was fine, but that we
had a hash collision? Duplicate uuids are much more obvious than a
collision here.

> +			mutex_unlock(&mdev_list_lock);
> +			ret = -EEXIST;
> +			goto mdev_fail;
> +		}
>  	}
>  
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);

