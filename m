Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29FE1386CC
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbgALOTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 09:19:42 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35203 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733007AbgALOTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 09:19:42 -0500
Received: by mail-pj1-f67.google.com with SMTP id s7so3134636pjc.0
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 06:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=R7sO8Z1fKrm9CVhOQLHixdNPmIbE6/2Uqp5xP6UOvoE=;
        b=OsCHDeq00v/0KyUmEDHLMsv5P/7Bka2MNH8aNdRWoqRDSSBYDxSOS4zI8zMFf+fJhQ
         MnlMDxnAtEGw3Gwy5aTlfC0UensLNZ1zB7PdAfhCah6uG2W9FIIogK3wdPZaO05mHCU4
         MTdTP2yuDeijYYEOQ31B1QMKZtnKDxSe4JCCYq3ScmALBNKSFG4HjP9kvE09/zdXQH4i
         gjmf2Lo/S2y+6EF7A6DIRKlA5QVV4k+6RoH35hhg9e0kM7I4pzfF7CLbxzYFZj6U/Cg0
         NheiOxQtwbJPVAZwKtMVfSc9QI6w3O2gbf1fs4vaextLVe/lOYl9xtKHC93OiPuf6eQ7
         QaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=R7sO8Z1fKrm9CVhOQLHixdNPmIbE6/2Uqp5xP6UOvoE=;
        b=t90APsq8WDqtS9Kclr6RqQ3CrRSsKeVAge2DmOmff74OveIz1pH9cgDRdfg1x5Y+wj
         0tojjxB/e2gs/iU3C2NT0kY44WB+Gu+YOBymY6Y5hpJ1mw9xdXNhx14Zx7LWdy/UErFO
         4eOg37ubwcml5+snsGkZbrZYSf3BoEntQrDyjzNXMEHXxpFGFN0kkJJCkx4a4ISkj0lw
         lk0NdfWH9vFdVUISxTNsgvuiCEEuWKhAqcHDvMBDmRerY4NMWEyY6+Hr9Vk3yf6qQ8zi
         2qCDiLQbNvZWVJ+b+uvk2T05ckI44okQCie2EHBnL1RncpyY39guK9svtsAsH16KK8/L
         EGEA==
X-Gm-Message-State: APjAAAX5cSDa2EfmeiyyEPFBN+A9gz24xA243/o3fzyeyuy9OWJLHYb7
        JwQfs0IihywHQzzwKiNGh2aEy/BdMrY=
X-Google-Smtp-Source: APXvYqyFiMRwrFuKzu3xJc28ijX4zJVNdYkUy3rS4lGp5i+/H2w7qpP0b2hfVmPOm5go68yWaY9NzA==
X-Received: by 2002:a17:90a:fe02:: with SMTP id ck2mr17184529pjb.10.1578838781483;
        Sun, 12 Jan 2020 06:19:41 -0800 (PST)
Received: from cakuba ([2601:646:8e00:1ed::3])
        by smtp.gmail.com with ESMTPSA id f127sm10499749pfa.112.2020.01.12.06.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 06:19:41 -0800 (PST)
Date:   Sun, 12 Jan 2020 06:19:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim
 operations
Message-ID: <20200112061937.171f6d88@cakuba>
In-Reply-To: <20200111163655.4087-1-ap420073@gmail.com>
References: <20200111163655.4087-1-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jan 2020 16:36:55 +0000, Taehee Yoo wrote:
> netdevsim basic operations are called with sysfs.
> 
> Create netdevsim device:
> echo "1 1" > /sys/bus/netdevsim/new_device
> Delete netdevsim device:
> echo 1 > /sys/bus/netdevsim/del_device
> Create netdevsim port:
> echo 4 > /sys/devices/netdevsim1/new_port
> Delete netdevsim port:
> echo 4 > /sys/devices/netdevsim1/del_port
> Set sriov number:
> echo 4 > /sys/devices/netdevsim1/sriov_numvfs
> 
> These operations use the same resource so they should acquire a lock for
> the whole resource not only for a list.
> 
> Test commands:
>     #SHELL1
>     modprobe netdevsim
>     while :
>     do
>         echo "1 1" > /sys/bus/netdevsim/new_device
>         echo "1 1" > /sys/bus/netdevsim/del_device
>     done
> 
>     #SHELL2
>     while :
>     do
>         echo 1 > /sys/devices/netdevsim1/new_port
>         echo 1 > /sys/devices/netdevsim1/del_port
>     done
> 
> Splat looks like:
> [  151.623634][ T1165] kasan: CONFIG_KASAN_INLINE enabled
> [  151.626503][ T1165] kasan: GPF could be caused by NULL-ptr deref or user memory access


> In this patch, __init and __exit function also acquire a lock.
> operations could be called while __init and __exit functions are
> processing. If so, uninitialized or freed resources could be used.
> So, __init() and __exit function also need lock.
> 
> Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")

I don't think that's the correct Fixes tag, the first version of the
driver did not use the sysfs interface.

> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -16,7 +16,8 @@
>  
>  static DEFINE_IDA(nsim_bus_dev_ids);
>  static LIST_HEAD(nsim_bus_dev_list);
> -static DEFINE_MUTEX(nsim_bus_dev_list_lock);
> +/* mutex lock for netdevsim operations */
> +DEFINE_MUTEX(nsim_bus_dev_ops_lock);
>  
>  static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
>  {
> @@ -51,9 +52,14 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,

Could the vf handling use the device lock like PCI does?

But actually, we free VF info from the release function, which IIUC is
called after all references to the device are gone. So this should be
fine, no?

Perhaps the entire bus dev structure should be freed from release?

>  	unsigned int num_vfs;
>  	int ret;
>  
> +	if (!mutex_trylock(&nsim_bus_dev_ops_lock))
> +		return -EBUSY;

Why the trylocks? Are you trying to catch the races between unregister
and other ops?

>  	ret = kstrtouint(buf, 0, &num_vfs);
> -	if (ret)
> +	if (ret) {
> +		mutex_unlock(&nsim_bus_dev_ops_lock);
>  		return ret;
> +	}
>  
>  	rtnl_lock();
>  	if (nsim_bus_dev->num_vfs == num_vfs)
