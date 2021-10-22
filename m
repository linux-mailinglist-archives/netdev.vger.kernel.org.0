Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A4B437526
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhJVJ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 05:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232592AbhJVJ4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 05:56:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECED611CB;
        Fri, 22 Oct 2021 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634896469;
        bh=MC3s6fkOJ8srBw1zUECAeCotlnm/k18G42TigAIezpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NuUNcWBek2mTXSgmN3h5NVlyUtaFQnfLS3500sOO4527EI1/dSh1o0/NfJ89k5J7W
         GoETd3D7gxwqNgTM8wCwQ92DD13L8dYWO/ZZFnfujLaTvd23QjJzBgT7zUl88gY10G
         NmmN8Im89gKD6HoazL+nRlKjQngfuNNFmuiUa9aLSzr+Mj0pe6isqdLdiMoRcKO4iW
         r59vrAHDiZt/d1ifwdOR8mI1Ov+Pi4fsl6VygQCNapN0gKKG0YrN6d2B76LlDg+4LD
         JriRNm8a2aqM5aX7suiga75RA63QYm6Co+JnqjBhwFTwUm/J6vhpXF+tAAv8nqeorq
         MyJF99Ys0UxPw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mdrFf-0002X4-Ee; Fri, 22 Oct 2021 11:54:15 +0200
Date:   Fri, 22 Oct 2021 11:54:15 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/usb: potential fix divide error: 0000
Message-ID: <YXKKR6evg66Ip4UB@hovoldconsulting.com>
References: <20211022063238.21800-1-bernard@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022063238.21800-1-bernard@vivo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:32:38PM -0700, Bernard Zhao wrote:
> This patch try to fix divide error in drivers/net/usb/usbnet.c.
> This bug is reported by google syzbot,
> divide error: 0000 [#1] SMP KASAN
> CPU: 0 PID: 1315 Comm: kworker/0:6 Not tainted 5.15.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: mld mld_ifc_work
> RIP: 0010:usbnet_start_xmit+0x3f1/0x1f70 drivers/net/usb/usbnet.c:1404
> Call Trace:
>  __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5002 [inline]
>  xmit_one net/core/dev.c:3576 [inline]
>  dev_hard_start_xmit+0x1df/0x890 net/core/dev.c:3592
>  sch_direct_xmit+0x25b/0x790 net/sched/sch_generic.c:342
>  __dev_xmit_skb net/core/dev.c:3803 [inline]
>  __dev_queue_xmit+0xf25/0x2d40 net/core/dev.c:4170
>  neigh_resolve_output net/core/neighbour.c:1492 [inline]
>  neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1472
>  neigh_output include/net/neighbour.h:510 [inline]
>  ip6_finish_output2+0xdbe/0x1b20 net/ipv6/ip6_output.c:126
>  __ip6_finish_output.part.0+0x387/0xbb0 net/ipv6/ip6_output.c:191
>  __ip6_finish_output include/linux/skbuff.h:982 [inline]
>  ip6_finish_output net/ipv6/ip6_output.c:201 [inline]
>  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>  ip6_output+0x3d2/0x810 net/ipv6/ip6_output.c:224
>  dst_output include/net/dst.h:450 [inline]
>  NF_HOOK include/linux/netfilter.h:307 [inline]
>  NF_HOOK include/linux/netfilt
> the link is:
> https://syzkaller.appspot.com/bug?id=e829c15b6c30d4680cf3198f72b0414adc907911
> 
> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  drivers/net/usb/usbnet.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 840c1c2ab16a..ada1b8242498 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -397,7 +397,7 @@ int usbnet_change_mtu (struct net_device *net, int new_mtu)
>  	int		old_rx_urb_size = dev->rx_urb_size;
>  
>  	// no second zero-length packet read wanted after mtu-sized packets
> -	if ((ll_mtu % dev->maxpacket) == 0)
> +	if (dev->maxpacket && ((ll_mtu % dev->maxpacket) == 0))
>  		return -EDOM;
>  	net->mtu = new_mtu;
>  
> @@ -1401,7 +1401,7 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
>  	 * handling ZLP/short packets, so cdc_ncm driver will make short
>  	 * packet itself if needed.
>  	 */
> -	if (length % dev->maxpacket == 0) {
> +	if (dev->maxpacket && (length % dev->maxpacket == 0)) {
>  		if (!(info->flags & FLAG_SEND_ZLP)) {
>  			if (!(info->flags & FLAG_MULTI_PACKET)) {
>  				length++;

This was fixed properly yesterday:

	https://lore.kernel.org/r/20211021122944.21816-1-oneukum@suse.com

Johan
