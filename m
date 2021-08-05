Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2C3E157A
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbhHENQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241669AbhHENQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:16:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACE76113C;
        Thu,  5 Aug 2021 13:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628169348;
        bh=NKOdBi5LCVktqhqbGVO0HTVgbk79WKuxHR0n5nw3Nao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LVGBNfSz9qhU6j+rz13QAlSMKJV+aP/abgwgX5hxCpGuRewpyDUqH7v1jgGZcf9fj
         ZBhLNCJMuPu9SnU6xPpVhtg0eBHX60o9BOmAjiHV7KtumXZ52SpMKyxmJI0RfGp++g
         I9xICzBDz0XvbGo24nCSANEa2N4L2cKaXv8aPyk4+IYhn/ZdpocsQ+xPSHOJhWrK14
         cIwE5v2OqbqIEDLDJyWsqof2IOEr0crcyL6mvBxnEp4vuBEcgLjWFEeIq9vqszyoMA
         7O/Szsq5BFa7i4zyumxNgw22zryxgPHChOScmz+U1eiUJcxfTfVDYSp6BE1U0w/nId
         duEYl3vF8xNWw==
Date:   Thu, 5 Aug 2021 06:15:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when
 adding or deleting ports
Message-ID: <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Aug 2021 14:05:41 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In order to remove complexity in devlink core related to
> devlink_reload_enable/disable, let's rewrite new_port/del_port
> logic to rely on internal to netdevsim lock.
> 
> We should protect only reload_down flow because it destroys nsim_dev,
> which is needed for nsim_dev_port_add/nsim_dev_port_del to hold
> port_list_lock.

I don't understand why we only have to protect reload_down.

What protects us from adding a port right after down? That'd hit a
destroyed mutex, up wipes the port list etc...

> +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> +	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
> +		return -EOPNOTSUPP;

Why not -EBUSY?
