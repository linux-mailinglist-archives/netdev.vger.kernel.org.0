Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5EB253989
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 23:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHZVJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 17:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgHZVJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 17:09:24 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2021F20737;
        Wed, 26 Aug 2020 21:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598476164;
        bh=yU3fj5clSGfwThxlKldKdhlN+mvMCK4Xg0b31VusCMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ez5dXCV9qf5X3dbZeHsIlWUycStnRewVQqGt7t20M+JG4/PbGDn7fvnxFTHF6QSmG
         JBKG0bW+iFnnnomw6/bpwHjTzfb7laSFZqGlb8IvG6uTRmjT4oVhivc50vauKCSI9j
         w8UcIv5R5GZA48tAODXHLpdj3w8dLqh33VSR6ROs=
Date:   Wed, 26 Aug 2020 14:09:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 09/12] ionic: change mtu without full queue
 rebuild
Message-ID: <20200826140922.0f1fb9fd@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200826164214.31792-10-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
        <20200826164214.31792-10-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020 09:42:11 -0700 Shannon Nelson wrote:
> +	mutex_lock(&lif->queue_lock);
> +	netif_device_detach(lif->netdev);
> +	ionic_stop_queues(lif);
> +	ionic_txrx_deinit(lif);
>  
> +	err = ionic_txrx_init(lif);
> +	if (err)
> +		goto err_out;
> +
> +	/* don't start the queues until we have link */
> +	if (netif_carrier_ok(netdev)) {
> +		err = ionic_start_queues(lif);
> +		if (err)
> +			goto err_out;
> +	}
> +
> +err_out:
> +	netif_device_attach(lif->netdev);
> +	mutex_unlock(&lif->queue_lock);

Looks a little racy, since the link state is changed before queue_lock
is taken:

                if (!netif_carrier_ok(netdev)) { u32 link_speed; 
                        ionic_port_identify(lif->ionic);                        
                        link_speed = le32_to_cpu(lif->info->status.link_speed); 
                        netdev_info(netdev, "Link up - %d Gbps\n",              
                                    link_speed / 1000);                         
                        netif_carrier_on(netdev);                               
                }                                                               
                                                                                
                if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) \
{                                                                               
                        mutex_lock(&lif->queue_lock);                           
                        ionic_start_queues(lif);                                
                        mutex_unlock(&lif->queue_lock);                         
                }    
