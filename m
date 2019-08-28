Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00EA0C73
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfH1Vg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:36:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbfH1Vg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 17:36:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 819EC75752;
        Wed, 28 Aug 2019 21:36:58 +0000 (UTC)
Received: from x1.home (ovpn-116-131.phx2.redhat.com [10.3.116.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDAA6600CD;
        Wed, 28 Aug 2019 21:36:57 +0000 (UTC)
Date:   Wed, 28 Aug 2019 15:36:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     jiri@mellanox.com, kwankhede@nvidia.com, cohuck@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 2/5] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190828153652.7eb6d6d6@x1.home>
In-Reply-To: <20190827191654.41161-3-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190827191654.41161-1-parav@mellanox.com>
        <20190827191654.41161-3-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 28 Aug 2019 21:36:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 14:16:51 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Mdev alias should be unique among all the mdevs, so that when such alias
> is used by the mdev users to derive other objects, there is no
> collision in a given system.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> ---
> Changelog:
> v0->v1:
>  - Fixed inclusiong of alias for NULL check
>  - Added ratelimited debug print for sha1 hash collision error
> ---
>  drivers/vfio/mdev/mdev_core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 62d29f57fe0c..4b9899e40665 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -375,6 +375,13 @@ int mdev_device_create(struct kobject *kobj, struct device *dev,
>  			ret = -EEXIST;
>  			goto mdev_fail;
>  		}
> +		if (tmp->alias && alias && strcmp(tmp->alias, alias) == 0) {

Nit, test if the device we adding has an alias before the device we're
testing against.  The compiler can better optimize keeping alias hot.
Thanks,

Alex

> +			mutex_unlock(&mdev_list_lock);
> +			ret = -EEXIST;
> +			dev_dbg_ratelimited(dev, "Hash collision in alias creation for UUID %pUl\n",
> +					    uuid);
> +			goto mdev_fail;
> +		}
>  	}
>  
>  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);

