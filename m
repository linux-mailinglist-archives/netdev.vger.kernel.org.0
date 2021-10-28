Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E197543E2FB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhJ1OD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhJ1ODS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF74B610F8;
        Thu, 28 Oct 2021 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429652;
        bh=befpioNaBoCsU26abS9DdkNYMXPxAUWRWsMO1jqOJXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uyXe9ZVLedivH5p6YcQejSc5sgHFh0v2znTJYBaLZ9tRQ7gYrOmgcBoTu2d/pmzo3
         lFwSeDHXDmA5q3wcAM+GoZQUGsfVje8RFD3pQq/7O6WEIYcgXG+e98Eyi+a9X64EAu
         F0VJ4PzcuPa4Pl1zzH3ysT7DsKS7yoFcYBhWSxTNC4i6vW5AbQf9vXrZP7yizsRt1F
         kgPaGdcx+Ci0B/1rd05hnxx5+IMaCQuM21NfMnEhibyKeBFG1eRS3CqcJFBTrTB4I2
         DsNgrUs/w3x7T4K2vpaMuZWxFPy7XPdrrGXRq8o5YaGBuWm3zST5DozCuyWJprU/N4
         wIwcobLz84KXQ==
Date:   Thu, 28 Oct 2021 07:00:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028114503.GM2744544@nvidia.com>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
        <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211028114503.GM2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 08:45:03 -0300 Jason Gunthorpe wrote:
> > But will make all the callers of vlan_dev_real_dev() feel like they
> > should NULL-check the result, which is not necessary.  
> 
> Isn't it better to reliably return NULL instead of a silent UAF in
> this edge case? 

I don't know what the best practice is for maintaining sanity of
unregistered objects.

If there really is a requirement for the real_dev pointer to be sane we
may want to move the put_device(real_dev) to vlan_dev_free(). There
should not be any risk of circular dependency but I'm not 100% sure.

> > RDMA must be calling this helper on a vlan which was already
> > unregistered, can we fix RDMA instead?  
> 
> RDMA holds a get on the netdev which prevents unregistration, however
> unregister_vlan_dev() does:
> 
>         unregister_netdevice_queue(dev, head);
>         dev_put(real_dev);
> 
> Which corrupts the still registered vlan device while it is sitting in
> the queue waiting to unregister. So, it is not true that a registered
> vlan device always has working vlan_dev_real_dev().

That's not my reading, unless we have a different definition of
"registered". The RDMA code in question runs from a workqueue, at the
time the UNREGISTER notification is generated all objects are still
alive and no UAF can happen. Past UNREGISTER extra care is needed when
accessing the object.

Note that unregister_vlan_dev() may queue the unregistration, without
running it. If it clears real_dev the UNREGISTER notification will no
longer be able to access real_dev, which used to be completely legal.
