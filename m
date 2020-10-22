Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2B296265
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896162AbgJVQMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895999AbgJVQMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 12:12:13 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA05824182;
        Thu, 22 Oct 2020 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603383133;
        bh=eJVSOn8Oqy+L/zRqcwCFZVv32OM/ZwNLPnS+CsjA1q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V/nkcAz9gUtrgfJMEToeUNW3zJ99V2amJpgd1IOXluaghpeaSFQwuWpBLIbCUMgA1
         2ERCg63W1JAbFGfWSZu/XYjw1klosk3Jztw791cHxG4EgIccP7jbYl8v9oiDmHhuUe
         JDaWh/noy1VSmXrlUPUg6vDDdXro5tUt01v8J+Bs=
Date:   Thu, 22 Oct 2020 09:12:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-veth: Fix memleak in veth_newlink
Message-ID: <20201022091211.2a86355c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022054233.17326-1-dinghao.liu@zju.edu.cn>
References: <20201022054233.17326-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 13:42:33 +0800 Dinghao Liu wrote:
> When rtnl_configure_link() fails, peer needs to be
> freed just like when register_netdevice() fails.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Can you see this leak or are you just sending this based on your
reading of the code?

netdev should be freed by the core:

static void veth_setup(struct net_device *dev)                                  
{                                                                               
        ether_setup(dev);                                                       
                                                                                
	[...]                    
        dev->needs_free_netdev = true;    

> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 8c737668008a..6c68094399cc 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1405,8 +1405,6 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
>  	/* nothing to do */
>  err_configure_peer:
>  	unregister_netdevice(peer);
> -	return err;
> -
>  err_register_peer:
>  	free_netdev(peer);
>  	return err;

