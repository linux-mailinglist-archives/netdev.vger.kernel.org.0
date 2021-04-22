Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9742C367F0A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 12:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhDVKuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 06:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235800AbhDVKuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 06:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C8D61452;
        Thu, 22 Apr 2021 10:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619088576;
        bh=L4VyomxmbGQvJRnBwxrzKMAjbER+ODVjPhNRkTmCL18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WiyZHUkDt6lTkMgFX2mROlI6MmKohfSE9/YMdQVe9vjTTwc9442w0H8vGLHlgLRqe
         +70Hjp7wvwkfLmwK7nuEA5Xvf8zKFQkAB+zB7iMjUv9/A3yNPGnmj51P6C+IJK0h1C
         C4oVRMubBN9kBEpHHoHZx5vno2mT7r1xbnwvazZG2D7fsKxw7cYFWtQveabj+2lymY
         yWyvC3xLx394Kc3BmgZRKKbhNm3G7nmMjHARPu0FqQwK/W2TRDR/OOOMq9/DPP5GwS
         ewInPasiaATqU7iRr92Rh8tqzMmCF6X1kli9JNSJeHyQwevi33V3v+ntu0pG8PZOwM
         ZhUcqrgOjveLQ==
Date:   Thu, 22 Apr 2021 13:49:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: wwan: core: Return poll error in case of
 port removal
Message-ID: <YIFUvMCCivi62Rb4@unreal>
References: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 11:43:34AM +0200, Loic Poulain wrote:
> Ensure that the poll system call returns error flags when port is
> removed, allowing user side to properly fail, without trying read
> or write. Port removal leads to nullified port operations, add a
> is_port_connected() helper to safely check the status.
> 
> Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index 5be5e1e..c965b21 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
>  	return ret;
>  }
>  
> +static bool is_port_connected(struct wwan_port *port)
> +{
> +	bool connected;
> +
> +	mutex_lock(&port->ops_lock);
> +	connected = !!port->ops;
> +	mutex_unlock(&port->ops_lock);
> +
> +	return connected;
> +}

The above can't be correct. What prevents to change the status of
port->ops right before or after your mutex_lock/mutex_unlock?

> +
>  static bool is_read_blocked(struct wwan_port *port)
>  {
> -	return skb_queue_empty(&port->rxq) && port->ops;
> +	return skb_queue_empty(&port->rxq) && is_port_connected(port);
>  }
>  
>  static bool is_write_blocked(struct wwan_port *port)
>  {
> -	return test_bit(WWAN_PORT_TX_OFF, &port->flags) && port->ops;
> +	return test_bit(WWAN_PORT_TX_OFF, &port->flags) && is_port_connected(port);
>  }
>  
>  static int wwan_wait_rx(struct wwan_port *port, bool nonblock)
> @@ -508,6 +519,8 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
>  		mask |= EPOLLOUT | EPOLLWRNORM;
>  	if (!is_read_blocked(port))
>  		mask |= EPOLLIN | EPOLLRDNORM;
> +	if (!is_port_connected(port))
> +		mask |= EPOLLHUP | EPOLLERR;
>  
>  	return mask;
>  }
> -- 
> 2.7.4
> 
