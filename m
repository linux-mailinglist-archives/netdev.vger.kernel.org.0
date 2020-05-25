Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657291E0C1C
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbgEYKs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389484AbgEYKs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 06:48:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DBCC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 03:48:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jdAf8-0007hT-7s; Mon, 25 May 2020 12:48:54 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jdAf3-0005hQ-V1; Mon, 25 May 2020 12:48:49 +0200
Date:   Mon, 25 May 2020 12:48:49 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     fugang.duan@nxp.com
Cc:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net v2 1/4] net: ethernet: fec: move GPR register offset
 and bit into DT
Message-ID: <20200525104849.GQ11869@pengutronix.de>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
 <1590390569-4394-2-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590390569-4394-2-git-send-email-fugang.duan@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:34:52 up 95 days, 18:05, 115 users,  load average: 0.11, 0.12,
 0.14
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 03:09:26PM +0800, fugang.duan@nxp.com wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> The commit da722186f654 (net: fec: set GPR bit on suspend by DT
> configuration) set the GPR reigster offset and bit in driver for
> wake on lan feature.
> 
> But it introduces two issues here:
> - one SOC has two instances, they have different bit
> - different SOCs may have different offset and bit
> 
> So to support wake-on-lan feature on other i.MX platforms, it should
> configure the GPR reigster offset and bit from DT.
> 
> So the patch is to improve the commit da722186f654 (net: fec: set GPR
> bit on suspend by DT configuration) to support multiple ethernet
> instances on i.MX series.
> 
> v2:
>  * switch back to store the quirks bitmask in driver_data
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 103 ++++++++++--------------------
>  1 file changed, 34 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2e20914..4f55d30 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -86,56 +86,6 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
>  #define FEC_ENET_OPD_V	0xFFF0
>  #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
>  
> -struct fec_devinfo {
> -	u32 quirks;
> -	u8 stop_gpr_reg;
> -	u8 stop_gpr_bit;
> -};

Honestly I like the approach of having a struct fec_devinfo for
abstracting differences between different hardware variants. It gives
you more freedom to describe the differences. Converting this back to a
single bitfield is a step backward, even when currently struct
fec_devinfo only contains a single value.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
