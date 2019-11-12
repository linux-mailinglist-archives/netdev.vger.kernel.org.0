Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB73F962C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfKLQyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:54:18 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:8587 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfKLQyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:54:17 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 11:54:17 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2698; q=dns/txt; s=iport;
  t=1573577657; x=1574787257;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tTiF5mRXb2EbMlZI8NJ8Bn9suidU/mLTC+kCFVPC5W0=;
  b=d38Qjj00/7nFAVyhixllpQWwARJu/5/baX7qrLdNxr9OgO1yQFA6OQRz
   IRiRIMPiUfrk7Gb/bJXlcvFtBB6U8AWRdzh7s9xMVbCR9/1kaOxnD6dRI
   +Z4EbSfKclNHbJW4AJ+KUBVKluPVERQRnE1zkGnntbdbakgKk41p0GX/6
   s=;
X-IronPort-AV: E=Sophos;i="5.68,297,1569283200"; 
   d="scan'208";a="369088095"
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Nov 2019 16:47:10 +0000
Received: from zorba ([10.156.154.25])
        by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xACGl86b015678
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 12 Nov 2019 16:47:09 GMT
Date:   Tue, 12 Nov 2019 08:47:07 -0800
From:   Daniel Walker <danielwa@cisco.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        sjarugum@cisco.com, hramdasi@cisco.com
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Message-ID: <20191112164707.GQ18744@zorba>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Outbound-SMTP-Client: 10.156.154.25, [10.156.154.25]
X-Outbound-Node: alln-core-6.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Just adding HEMANT who was involved in the original debug.
Also Sathish did the current debug.


On Tue, Nov 12, 2019 at 04:55:11PM +0200, Claudiu Manoil wrote:
> We received reports that forcing the MAC into RGMII (1 Gbps)
> interface mode after MAC reset occasionally disrupts operation
> of PHYs capable only of 100Mbps, even after adjust_link kicks
> in and re-adjusts the interface mode in MACCFG2 accordingly.
> Instead of forcing MACCFG2 into RGMII mode, let's use the default
> reset value of MACCFG2 (that leaves the IF_Mode field unset) and
> let adjust_link configure the correct mode from the beginning.
> MACCFG2_INIT_SETTINGS is dropped, only the PAD_CRC bit is preserved,
> the remaining fields (IF_Mode and Duplex) are left for adjust_link.
> Tested on boards with gigabit PHYs.
> 
> MACCFG2_INIT_SETTINGS is there since day one, but the issue
> got visible after introducing the MAC reset and reconfig support,
> which added MAC reset at runtime, at interface open.
> 
> Fixes: a328ac92d314 ("gianfar: Implement MAC reset and reconfig procedure")
> 
> Reported-by: Daniel Walker <danielwa@cisco.com>
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/gianfar.c | 3 ++-
>  drivers/net/ethernet/freescale/gianfar.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 51ad864..0f4d13d 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -3173,7 +3173,8 @@ void gfar_mac_reset(struct gfar_private *priv)
>  	gfar_write(&regs->minflr, MINFLR_INIT_SETTINGS);
>  
>  	/* Initialize MACCFG2. */
> -	tempval = MACCFG2_INIT_SETTINGS;
> +	tempval = gfar_read(&regs->maccfg2);
> +	tempval |= MACCFG2_PAD_CRC;
>  
>  	/* eTSEC74 erratum: Rx frames of length MAXFRM or MAXFRM-1
>  	 * are marked as truncated.  Avoid this by MACCFG2[Huge Frame]=1,
> diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
> index f472a6d..cc70e03 100644
> --- a/drivers/net/ethernet/freescale/gianfar.h
> +++ b/drivers/net/ethernet/freescale/gianfar.h
> @@ -150,8 +150,8 @@ extern const char gfar_driver_version[];
>  #define MACCFG1_SYNCD_TX_EN	0x00000002
>  #define MACCFG1_TX_EN		0x00000001
>  
> -#define MACCFG2_INIT_SETTINGS	0x00007205
>  #define MACCFG2_FULL_DUPLEX	0x00000001
> +#define MACCFG2_PAD_CRC         0x00000004
>  #define MACCFG2_IF              0x00000300
>  #define MACCFG2_MII             0x00000100
>  #define MACCFG2_GMII            0x00000200
> -- 
> 2.7.4
> 
