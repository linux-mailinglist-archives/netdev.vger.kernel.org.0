Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C65541BB88
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhI2AER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhI2AEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 20:04:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BCEF6134F;
        Wed, 29 Sep 2021 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632873750;
        bh=pRZhM6vwGVNs6ndAZ4kGqQtEexJ5L59zhNySB68IA/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVb5gCVaKmgEzEo1081cDZN2qlOwnlyoN6MvbGWS8UdOEoIgr0NljuKIy/H3r4mqk
         faH93LkUQomf8yND59aTIr6JsAx8hzuHnTNS1hkSFESlt4QACGSG27UGGFYFMlEBvh
         uF6Qqq7Q3HWDQwIk3D1Chegm73mDj74PAjPLz9FG+6T5Q9gtjkGqEzEN+ZcM617QLf
         l6s8q3WQQFEnYpk9WK+3QBIEly6Raj1fTRz2ZAdOBpQPkL9YP0MbCcLTG9HE1KJjh8
         7lBofVhp05K3ZivrJtwoMq2T+eNZIqd6hvVJJ076+0XKlaOl+cOL+Tf+s13+5o+r34
         qe3hen0JdNDlg==
Date:   Tue, 28 Sep 2021 17:02:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
Message-ID: <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928125500.167943-9-atenart@kernel.org>
References: <20210928125500.167943-1-atenart@kernel.org>
        <20210928125500.167943-9-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Sep 2021 14:54:59 +0200 Antoine Tenart wrote:
> The sysfs removal is done in device_del, and moving it outside of the
> rtnl lock does fix the initial deadlock. With that the trylock/restart
> logic can be removed in a following-up patch.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index a1eab120bb50..d774fbec5d63 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10593,6 +10593,8 @@ void netdev_run_todo(void)
>  			continue;
>  		}
>  
> +		device_del(&dev->dev);
> +
>  		dev->reg_state = NETREG_UNREGISTERED;
>  
>  		netdev_wait_allrefs(dev);
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 21c3fdeccf20..e754f00c117b 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1955,8 +1955,6 @@ void netdev_unregister_kobject(struct net_device *ndev)
>  	remove_queue_kobjects(ndev);
>  
>  	pm_runtime_set_memalloc_noio(dev, false);
> -
> -	device_del(dev);
>  }
>  
>  /* Create sysfs entries for network device. */

Doesn't this mean there may be sysfs files which are accessible 
for an unregistered netdevice? Isn't the point of having device_del()
under rtnl_lock() to make sure we sysfs handlers can't run on dead
devices?
