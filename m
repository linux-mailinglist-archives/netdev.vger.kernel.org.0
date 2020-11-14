Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E752B315D
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgKNXTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgKNXTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 18:19:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B425524102;
        Sat, 14 Nov 2020 23:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605395950;
        bh=ehgWnI06o9R35nT4rZ/7ncnW5naNXaQhZJQ9o2x2Ubc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sAlff0d8j+1cS4sq6GLJo56bONRqYbCXjiWbcelL0ORnkzsDfLINDEgr7MqgMPRbN
         tTqfdNuz55j/cbIuijS4ZjkyuZzfZedqDNjwzmGxLgT54WUCnPfUT5/ncQqmwJJ2a4
         bU5QIzn2sT6SIs8tuVk09m4quKdP4HltYYBmJI9s=
Date:   Sat, 14 Nov 2020 15:19:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] lan743x: fix issue causing intermittent kernel
 log warnings
Message-ID: <20201114151908.7e7a05b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112185949.11315-1-TheSven73@gmail.com>
References: <20201112185949.11315-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 13:59:49 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> When running this chip on arm imx6, we intermittently observe
> the following kernel warning in the log, especially when the
> system is under high load:

> The driver is calling dev_kfree_skb() from code inside a spinlock,
> where h/w interrupts are disabled. This is forbidden, as documented
> in include/linux/netdevice.h. The correct function to use
> dev_kfree_skb_irq(), or dev_kfree_skb_any().
> 
> Fix by using the correct dev_kfree_skb_xxx() functions:
> 
> in lan743x_tx_release_desc():
>   called by lan743x_tx_release_completed_descriptors()
>     called by in lan743x_tx_napi_poll()
>     which holds a spinlock
>   called by lan743x_tx_release_all_descriptors()
>     called by lan743x_tx_close()
>     which can-sleep
> conclusion: use dev_kfree_skb_any()
> 
> in lan743x_tx_xmit_frame():
>   which holds a spinlock
> conclusion: use dev_kfree_skb_irq()
> 
> in lan743x_tx_close():
>   which can-sleep
> conclusion: use dev_kfree_skb()
> 
> in lan743x_rx_release_ring_element():
>   called by lan743x_rx_close()
>     which can-sleep
>   called by lan743x_rx_open()
>     which can-sleep
> conclusion: use dev_kfree_skb()
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied, thanks.

The _irq() cases look a little strange, are you planning a refactor in
net-next? Seems like the freeing can be moved outside the lock.

Also the driver could stop the queue when there is less than
MAX_SKB_FRAGS + 2 descriptors left, so it doesn't need the
"overflow_skb" thing.
