Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC512A1346
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 04:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgJaDHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 23:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaDHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 23:07:06 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2504122249;
        Sat, 31 Oct 2020 03:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604113626;
        bh=8z+yhuEzYfQ18JMH9h3MjfzikhLM2WXKRTUD/3NPy7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=evG3yeoYMwWiFhINgBJaGpp28qWPWvGshgn+VwGDqNOFxSsr6e557mBB/ru3OBODy
         2xGEVNLuX5FCoPMEmwhowTtfGi7HRUA5iMI3DjMGRksFEY+i6CBp8WgWCZ4Ul+CX9D
         3fxuMuDm2noitSLvX0zRpKFMIQaC75S3Ta0KOcoQ=
Date:   Fri, 30 Oct 2020 20:07:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
Message-ID: <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028070504.362164-1-xie.he.0141@gmail.com>
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 00:05:04 -0700 Xie He wrote:
> I wish to deprecate the Frame Relay layer (dlci.c) in the kernel because
> we already have a newer and better "HDLC Frame Relay" layer (hdlc_fr.c).
> 
> Reasons why hdlc_fr.c is better than dlci.c include:
> 
> 1.
> dlci.c is dated 1997, while hdlc_fr.c is dated 1999 - 2006, so the later
> is newer than the former.
> 
> 2.
> hdlc_fr.c is working well (tested by me). For dlci.c, I cannot even find
> the user space problem needed to use it. The link provided in
> Documentation/networking/framerelay.rst (in the last paragraph) is no
> longer valid.
> 
> 3.
> dlci.c supports only one hardware driver - sdla.c, while hdlc_fr.c
> supports many hardware drivers through the generic HDLC layer (hdlc.c).
> 
> WAN hardware devices are usually able to support several L2 protocols
> at the same time, so the HDLC layer is more suitable for these devices.
> 
> The hardware devices that sdla.c supports are also multi-protocol
> (according to drivers/net/wan/Kconfig), so the HDLC layer is more
> suitable for these devices, too.
> 
> 4.
> hdlc_fr.c supports LMI and supports Ethernet emulation. dlci.c supports
> neither according to its code.
> 
> 5.
> include/uapi/linux/if_frad.h, which comes with dlci.c, contains two
> structs for ioctl configs (dlci_conf and frad_conf). According to the
> comments, these two structs are specially crafted for sdla.c (the only
> hardware driver dlci.c supports). I think this makes dlci.c not generic
> enough to support other hardware drivers.
> 
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

This code has only seen cleanup patches since the git era begun -
do you think that it may still have users? Or is it completely unused?

The usual way of getting rid of old code is to move it to staging/
for a few releases then delete it, like Arnd just did with wimax.

> diff --git a/Documentation/networking/framerelay.rst b/Documentation/networking/framerelay.rst
> index 6d904399ec6d..92e66fc3dffc 100644
> --- a/Documentation/networking/framerelay.rst
> +++ b/Documentation/networking/framerelay.rst
> @@ -4,6 +4,9 @@
>  Frame Relay (FR)
>  ================
>  
> +(Note that this Frame Relay layer is deprecated. New drivers should use the
> +HDLC Frame Relay layer instead.)
> +
>  Frame Relay (FR) support for linux is built into a two tiered system of device
>  drivers.  The upper layer implements RFC1490 FR specification, and uses the
>  Data Link Connection Identifier (DLCI) as its hardware address.  Usually these
> diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
> index 3ca4daf63389..1f0eee10c13f 100644
> --- a/drivers/net/wan/dlci.c
> +++ b/drivers/net/wan/dlci.c
> @@ -514,6 +514,8 @@ static int __init init_dlci(void)
>  	register_netdevice_notifier(&dlci_notifier);
>  
>  	printk("%s.\n", version);
> +	pr_warn("The DLCI driver (the Frame Relay layer) is deprecated.\n"
> +		"Please move your driver to the HDLC Frame Relay layer.\n");
>  
>  	return 0;
>  }
> diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
> index bc2c1c7fb1a4..21d602f698fc 100644
> --- a/drivers/net/wan/sdla.c
> +++ b/drivers/net/wan/sdla.c
> @@ -1623,6 +1623,9 @@ static int __init init_sdla(void)
>  	int err;
>  
>  	printk("%s.\n", version);
> +	pr_warn("The SDLA driver is deprecated.\n"
> +		"If you are still using the hardware,\n"
> +		"please help move this driver to the HDLC Frame Relay layer.\n");
>  
>  	sdla = alloc_netdev(sizeof(struct frad_local), "sdla0",
>  			    NET_NAME_UNKNOWN, setup_sdla);

