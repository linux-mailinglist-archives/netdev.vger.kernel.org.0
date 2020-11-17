Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3D2B7022
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKQUeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:34:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKQUeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:34:03 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D7621D40;
        Tue, 17 Nov 2020 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605645242;
        bh=oLQ4EsohtAxWxNHJ/oFI/daW3UgKfR6MiORs1T+jAQE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkEY3+klokRzvum/NnxlsXLkB6vxO0S1dGE5tHnXmTbeD8fwQYE/d1KRUdsi77+kp
         PKBTSmkTeI8esV4eATRWjfOnlXmRgmlR4HKQ/XHNHJ2aeNOLSApKa6agCOpYRfEiJv
         j6FO0/plDoyIPQi7lq4Wqz/DvkgisQKN4qe7d5MY=
Date:   Tue, 17 Nov 2020 12:34:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamie Iles <jamie@nuviainc.com>
Cc:     netdev@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2] bonding: wait for sysfs kobject destruction before
 freeing struct slave
Message-ID: <20201117123401.2ed2270e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201113171244.15676-1-jamie@nuviainc.com>
References: <d4b96330-4ee1-6393-1096-03a06abd3889@gmail.com>
        <20201113171244.15676-1-jamie@nuviainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 17:12:44 +0000 Jamie Iles wrote:
> syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> struct slave device could result in the following splat:

> This is a potential use-after-free if the sysfs nodes are being accessed
> whilst removing the struct slave, so wait for the object destruction to
> complete before freeing the struct slave itself.
> 
> Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
> Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")

This code looks surprising, although admittedly my kobj understanding
is cursory at best. So CCing Greg to keep me honest.

kobj itself is a refcounting mechanism. Adding another refcount and
then releasing the reference from .release method of kobject looks like
a pointless duplication.

Just free the object from the .release method. Why not?

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 84ecbc6fa0ff..66e56642e6c2 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1478,11 +1478,14 @@ static struct slave *bond_alloc_slave(struct bonding *bond)
>  	}
>  	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
>  
> +	kref_init(&slave->ref);
> +
>  	return slave;
>  }
>  
> -static void bond_free_slave(struct slave *slave)
> +static void __bond_free_slave(struct kref *ref)
>  {
> +	struct slave *slave = container_of(ref, struct slave, ref);
>  	struct bonding *bond = bond_get_bond_by_slave(slave);
>  
>  	cancel_delayed_work_sync(&slave->notify_work);
> @@ -1492,6 +1495,16 @@ static void bond_free_slave(struct slave *slave)
>  	kfree(slave);
>  }
>  
> +void bond_slave_put_ref(struct slave *slave)
> +{
> +	kref_put(&slave->ref, __bond_free_slave);
> +}
> +
> +void bond_slave_get_ref(struct slave *slave)
> +{
> +	kref_get(&slave->ref);
> +}
> +
>  static void bond_fill_ifbond(struct bonding *bond, struct ifbond *info)
>  {
>  	info->bond_mode = BOND_MODE(bond);
> @@ -2007,7 +2020,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>  	dev_set_mtu(slave_dev, new_slave->original_mtu);
>  
>  err_free:
> -	bond_free_slave(new_slave);
> +	bond_slave_put_ref(new_slave);
>  
>  err_undo_flags:
>  	/* Enslave of first slave has failed and we need to fix master's mac */
> @@ -2187,7 +2200,7 @@ static int __bond_release_one(struct net_device *bond_dev,
>  	if (!netif_is_bond_master(slave_dev))
>  		slave_dev->priv_flags &= ~IFF_BONDING;
>  
> -	bond_free_slave(slave);
> +	bond_slave_put_ref(slave);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
> index 9b8346638f69..5f8aac715ee8 100644
> --- a/drivers/net/bonding/bond_sysfs_slave.c
> +++ b/drivers/net/bonding/bond_sysfs_slave.c
> @@ -136,7 +136,15 @@ static const struct sysfs_ops slave_sysfs_ops = {
>  	.show = slave_show,
>  };
>  
> +static void slave_release(struct kobject *kobj)
> +{
> +	struct slave *slave = to_slave(kobj);
> +
> +	bond_slave_put_ref(slave);
> +}
> +
>  static struct kobj_type slave_ktype = {
> +	.release = slave_release,
>  #ifdef CONFIG_SYSFS
>  	.sysfs_ops = &slave_sysfs_ops,
>  #endif
> @@ -147,22 +155,26 @@ int bond_sysfs_slave_add(struct slave *slave)
>  	const struct slave_attribute **a;
>  	int err;
>  
> +	bond_slave_get_ref(slave);
> +
>  	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
>  				   &(slave->dev->dev.kobj), "bonding_slave");
> -	if (err) {
> -		kobject_put(&slave->kobj);
> -		return err;
> -	}
> +	if (err)
> +		goto out_put_slave;
>  
>  	for (a = slave_attrs; *a; ++a) {
>  		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
> -		if (err) {
> -			kobject_put(&slave->kobj);
> -			return err;
> -		}
> +		if (err)
> +			goto out_put_slave;
>  	}
>  
>  	return 0;
> +
> +out_put_slave:
> +	kobject_put(&slave->kobj);
> +	bond_slave_put_ref(slave);
> +
> +	return err;
>  }
>  
>  void bond_sysfs_slave_del(struct slave *slave)
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index 7d132cc1e584..e286ff4e0882 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -25,6 +25,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/reciprocal_div.h>
>  #include <linux/if_link.h>
> +#include <linux/kref.h>
>  
>  #include <net/bond_3ad.h>
>  #include <net/bond_alb.h>
> @@ -157,6 +158,7 @@ struct bond_parm_tbl {
>  struct slave {
>  	struct net_device *dev; /* first - useful for panic debug */
>  	struct bonding *bond; /* our master */
> +	struct kref ref;
>  	int    delay;
>  	/* all three in jiffies */
>  	unsigned long last_link_up;
> @@ -649,6 +651,8 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
>  int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave);
>  void bond_slave_arr_work_rearm(struct bonding *bond, unsigned long delay);
>  void bond_work_init_all(struct bonding *bond);
> +void bond_slave_get_ref(struct slave *slave);
> +void bond_slave_put_ref(struct slave *slave);
>  
>  #ifdef CONFIG_PROC_FS
>  void bond_create_proc_entry(struct bonding *bond);

