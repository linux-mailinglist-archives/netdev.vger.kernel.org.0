Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FC4293066
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbgJSVWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbgJSVWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:22:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 106E522246;
        Mon, 19 Oct 2020 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603142549;
        bh=XfamQnzOuHXtb2xKfCzFkOlu+JDj24CRCKFBhgQ886g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F/Jyde13dU7Z2kMfbu14Y3HfmicK7XWZ7+5WH+6ZlAUj43q0zNwtg9zTalkKAdxuP
         LGGSGZzwSZJJ7cyYO46ZVfITpAF/F9bxVChtQiiAAl+t56qur+l2WB2+ge0FH0zzNK
         bckyt6Vxrk4TijP4Cmr8r/ZqFjp32Kk2nKE0CJFw=
Date:   Mon, 19 Oct 2020 14:22:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] drivers/net/wan/hdlc: In hdlc_rcv, check to make
 sure dev is an HDLC device
Message-ID: <20201019142226.4503ed65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019104942.364914-1-xie.he.0141@gmail.com>
References: <20201019104942.364914-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 03:49:42 -0700 Xie He wrote:
> The hdlc_rcv function is used as hdlc_packet_type.func to process any
> skb received in the kernel with skb->protocol == htons(ETH_P_HDLC).
> The purpose of this function is to provide second-stage processing for
> skbs not assigned a "real" L3 skb->protocol value in the first stage.
> 
> This function assumes the device from which the skb is received is an
> HDLC device (a device created by this module). It assumes that
> netdev_priv(dev) returns a pointer to "struct hdlc_device".
> 
> However, it is possible that some driver in the kernel (not necessarily
> in our control) submits a received skb with skb->protocol ==
> htons(ETH_P_HDLC), from a non-HDLC device. In this case, the skb would
> still be received by hdlc_rcv. This will cause problems.
> 
> hdlc_rcv should be able to recognize and drop invalid skbs. It should
> first make sure "dev" is actually an HDLC device, before starting its
> processing.
> 
> To reliably check if a device is an HDLC device, we can check if its
> dev->netdev_ops->ndo_start_xmit == hdlc_start_xmit, because all HDLC
> devices are required to set their ndo_start_xmit to hdlc_start_xmit
> (and all non-HDLC devices would not set their ndo_start_xmit to this).
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  drivers/net/wan/hdlc.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
> index 9b00708676cf..0a392fb9aff8 100644
> --- a/drivers/net/wan/hdlc.c
> +++ b/drivers/net/wan/hdlc.c
> @@ -46,7 +46,15 @@ static struct hdlc_proto *first_proto;
>  static int hdlc_rcv(struct sk_buff *skb, struct net_device *dev,
>  		    struct packet_type *p, struct net_device *orig_dev)
>  {
> -	struct hdlc_device *hdlc = dev_to_hdlc(dev);
> +	struct hdlc_device *hdlc;
> +
> +	/* First make sure "dev" is an HDLC device */
> +	if (dev->netdev_ops->ndo_start_xmit != hdlc_start_xmit) {

Looks correct to me. I spotted there is also IFF_WAN_HDLC added by 
7cdc15f5f9db ("WAN: Generic HDLC now uses IFF_WAN_HDLC private flag.")
would using that flag also be correct and cleaner potentially? 

Up to you, just wanted to make sure you considered it.

> +		kfree_skb(skb);
> +		return NET_RX_SUCCESS;
> +	}
> +
> +	hdlc = dev_to_hdlc(dev);
>  
>  	if (!net_eq(dev_net(dev), &init_net)) {
>  		kfree_skb(skb);

