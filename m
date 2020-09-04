Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC83125E39B
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgIDWOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgIDWOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 18:14:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728072083B;
        Fri,  4 Sep 2020 22:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599257683;
        bh=Ghhq5Gp5y9JBDA0hXM9EVOfgXHkYK/npcCPbvCa+d0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTAn5h5Y+a0GAfXKhQIO4q3HW4GOgIjJXX5QcCpOG3dltGe7BlglDvJpRHwyr3jna
         +38ZU0onZVIH1bvsokogDtK4YdLECNU6AfhhdiYEfb0wvRIfV9uE8iEZUwJ2FQ4ewk
         oxNu6B7pJgaWlxOOiu+Adj4Gwh1het9edZUCw5Ys=
Date:   Fri, 4 Sep 2020 15:14:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
Message-ID: <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903000658.89944-1-xie.he.0141@gmail.com>
References: <20200903000658.89944-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Sep 2020 17:06:58 -0700 Xie He wrote:
> PVC devices are virtual devices in this driver stacked on top of the
> actual HDLC device. They are the devices normal users would use.
> PVC devices have two types: normal PVC devices and Ethernet-emulating
> PVC devices.
> 
> When transmitting data with PVC devices, the ndo_start_xmit function
> will prepend a header of 4 or 10 bytes. Currently this driver requests
> this headroom to be reserved for normal PVC devices by setting their
> hard_header_len to 10. However, this does not work when these devices
> are used with AF_PACKET/RAW sockets. Also, this driver does not request
> this headroom for Ethernet-emulating PVC devices (but deals with this
> problem by reallocating the skb when needed, which is not optimal).
> 
> This patch replaces hard_header_len with needed_headroom, and set
> needed_headroom for Ethernet-emulating PVC devices, too. This makes
> the driver to request headroom for all PVC devices in all cases.

Since this is a tunnel protocol on top of HDLC interfaces, and
hdlc_setup_dev() sets dev->hard_header_len = 16; should we actually 
set the needed_headroom to 10 + 16 = 26? I'm not clear on where/if 
hdlc devices actually prepend 16 bytes of header, though.

CC: Willem as he was reviewing your similar patch recently.

> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index 9acad651ea1f..12b35404cd8e 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
>  {
>  	dev->type = ARPHRD_DLCI;
>  	dev->flags = IFF_POINTOPOINT;
> -	dev->hard_header_len = 10;
> +	dev->hard_header_len = 0;

Is there a need to set this to 0? Will it not be zero after allocation?

>  	dev->addr_len = 2;
>  	netif_keep_dst(dev);
>  }
> @@ -1093,6 +1093,7 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
>  	dev->mtu = HDLC_MAX_MTU;
>  	dev->min_mtu = 68;
>  	dev->max_mtu = HDLC_MAX_MTU;
> +	dev->needed_headroom = 10;
>  	dev->priv_flags |= IFF_NO_QUEUE;
>  	dev->ml_priv = pvc;
>  
