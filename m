Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90C16F4054
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfKHG0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:26:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfKHG0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 01:26:37 -0500
Received: from localhost (unknown [77.137.81.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67072222C2;
        Fri,  8 Nov 2019 06:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573194397;
        bh=qjfE54URHfqvAnEJ7EoYiqEN8S0J3N3H4YuveiHQSKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AcI81P3oOyPrnpkVnjUtpSm+gjKFBvYwbZbByB3cIQPH7iPuwEX5EYFMdzKiBdZP7
         Q764JMMCLNjQ2g10HXb4lyP4LoajlXwZYNIQTmlaeCZMHyryD3sTshaC4ot2cE5fyY
         s1pNkcBeg17krSTMOI9U4MlgcZJGhIQLxznbCYZY=
Date:   Fri, 8 Nov 2019 08:26:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Message-ID: <20191108062632.GO6763@unreal>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-19-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107160834.21087-19-parav@mellanox.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:08:34AM -0600, Parav Pandit wrote:
> Provide a module parameter to set alias length to optionally generate
> mdev alias.

Why do we need it?

>
> Example to request mdev alias.
> $ modprobe mtty alias_length=12
>
> Make use of mtty_alias() API when alias_length module parameter is set.
>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  samples/vfio-mdev/mtty.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index ce84a300a4da..5a69121ed5ec 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -150,6 +150,10 @@ static const struct file_operations vd_fops = {
>  	.owner          = THIS_MODULE,
>  };
>
> +static unsigned int mtty_alias_length;
> +module_param_named(alias_length, mtty_alias_length, uint, 0444);
> +MODULE_PARM_DESC(alias_length, "mdev alias length; default=0");
> +
>  /* function prototypes */
>
>  static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
> @@ -755,6 +759,9 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
>  	list_add(&mdev_state->next, &mdev_devices_list);
>  	mutex_unlock(&mdev_list_lock);
>
> +	if (mtty_alias_length)
> +		dev_dbg(mdev_dev(mdev), "alias is %s\n", mdev_alias(mdev));
> +
>  	return 0;
>  }
>
> @@ -1387,6 +1394,11 @@ static struct attribute_group *mdev_type_groups[] = {
>  	NULL,
>  };
>
> +static unsigned int mtty_get_alias_length(void)
> +{
> +	return mtty_alias_length;
> +}
> +
>  static const struct mdev_parent_ops mdev_fops = {
>  	.owner                  = THIS_MODULE,
>  	.dev_attr_groups        = mtty_dev_groups,
> @@ -1399,6 +1411,7 @@ static const struct mdev_parent_ops mdev_fops = {
>  	.read                   = mtty_read,
>  	.write                  = mtty_write,
>  	.ioctl		        = mtty_ioctl,
> +	.get_alias_length	= mtty_get_alias_length
>  };
>
>  static void mtty_device_release(struct device *dev)
> --
> 2.19.2
>
