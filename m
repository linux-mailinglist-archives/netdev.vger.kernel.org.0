Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375C417D968
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 07:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCIGqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 02:46:42 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41043 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIGqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 02:46:42 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jBCBS-0006zG-Cn; Mon, 09 Mar 2020 07:46:38 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jBCBP-0004q9-Da; Mon, 09 Mar 2020 07:46:35 +0100
Date:   Mon, 9 Mar 2020 07:46:35 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address
 in device tree
Message-ID: <20200309064635.GB3335@pengutronix.de>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:37:26 up 18 days, 14:07, 26 users,  load average: 0.06, 0.12,
 0.15
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 07:08:57PM +0200, Madalin Bucur wrote:
> Allow the initialization of the MAC to be performed even if the
> device tree does not provide a valid MAC address. Later a random
> MAC address should be assigned by the Ethernet driver.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 10 ++++------
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++++------
>  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++++------
>  drivers/net/ethernet/freescale/fman/mac.c        | 13 ++++++-------
>  4 files changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> index f7aec507787f..004c266802a8 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
> @@ -514,8 +514,10 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
>  
>  	iowrite32be(0xffffffff, &regs->ievent);
>  
> -	MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
> -	set_mac_address(regs, (u8 *)eth_addr);
> +	if (addr) {
> +		MAKE_ENET_ADDR_FROM_UINT64(addr, eth_addr);
> +		set_mac_address(regs, (u8 *)eth_addr);
> +	}
>  
>  	/* HASH */
>  	for (i = 0; i < NUM_OF_HASH_REGS; i++) {
> @@ -553,10 +555,6 @@ static int check_init_parameters(struct fman_mac *dtsec)
>  		pr_err("1G MAC driver supports 1G or lower speeds\n");
>  		return -EINVAL;
>  	}
> -	if (dtsec->addr == 0) {
> -		pr_err("Ethernet MAC Must have a valid MAC Address\n");
> -		return -EINVAL;
> -	}
>  	if ((dtsec->dtsec_drv_param)->rx_prepend >
>  	    MAX_PACKET_ALIGNMENT) {
>  		pr_err("packetAlignmentPadding can't be > than %d\n",
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index e1901874c19f..f2b2bfcbb529 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -596,10 +596,6 @@ static void setup_sgmii_internal_phy_base_x(struct fman_mac *memac)
>  
>  static int check_init_parameters(struct fman_mac *memac)
>  {
> -	if (memac->addr == 0) {
> -		pr_err("Ethernet MAC must have a valid MAC address\n");
> -		return -EINVAL;
> -	}
>  	if (!memac->exception_cb) {
>  		pr_err("Uninitialized exception handler\n");
>  		return -EINVAL;
> @@ -1057,8 +1053,10 @@ int memac_init(struct fman_mac *memac)
>  	}
>  
>  	/* MAC Address */
> -	MAKE_ENET_ADDR_FROM_UINT64(memac->addr, eth_addr);
> -	add_addr_in_paddr(memac->regs, (u8 *)eth_addr, 0);
> +	if (memac->addr != 0) {
> +		MAKE_ENET_ADDR_FROM_UINT64(memac->addr, eth_addr);
> +		add_addr_in_paddr(memac->regs, (u8 *)eth_addr, 0);
> +	}
>  
>  	fixed_link = memac_drv_param->fixed_link;
>  
> diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
> index f75b9c11b2d2..8c7eb878d5b4 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
> @@ -273,10 +273,6 @@ static int check_init_parameters(struct fman_mac *tgec)
>  		pr_err("10G MAC driver only support 10G speed\n");
>  		return -EINVAL;
>  	}
> -	if (tgec->addr == 0) {
> -		pr_err("Ethernet 10G MAC Must have valid MAC Address\n");
> -		return -EINVAL;
> -	}
>  	if (!tgec->exception_cb) {
>  		pr_err("uninitialized exception_cb\n");
>  		return -EINVAL;
> @@ -706,8 +702,10 @@ int tgec_init(struct fman_mac *tgec)
>  
>  	cfg = tgec->cfg;
>  
> -	MAKE_ENET_ADDR_FROM_UINT64(tgec->addr, eth_addr);
> -	set_mac_address(tgec->regs, (u8 *)eth_addr);
> +	if (tgec->addr) {
> +		MAKE_ENET_ADDR_FROM_UINT64(tgec->addr, eth_addr);
> +		set_mac_address(tgec->regs, (u8 *)eth_addr);
> +	}
>  
>  	/* interrupts */
>  	/* FM_10G_REM_N_LCL_FLT_EX_10GMAC_ERRATA_SW005 Errata workaround */
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index 55f2122c3217..43427c5b9396 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -724,12 +724,10 @@ static int mac_probe(struct platform_device *_of_dev)
>  
>  	/* Get the MAC address */
>  	mac_addr = of_get_mac_address(mac_node);
> -	if (IS_ERR(mac_addr)) {
> -		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
> -		err = -EINVAL;
> -		goto _return_of_get_parent;
> -	}
> -	ether_addr_copy(mac_dev->addr, mac_addr);
> +	if (IS_ERR(mac_addr))
> +		dev_warn(dev, "of_get_mac_address(%pOF) failed\n", mac_node);

Why this warning? There's nothing wrong with not providing the MAC in
the device tree.

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
