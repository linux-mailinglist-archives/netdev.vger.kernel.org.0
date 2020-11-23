Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BD42C1670
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbgKWURk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731265AbgKWURV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:17:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004AAC0613CF;
        Mon, 23 Nov 2020 12:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=91SXVfrzcwQmOXV/JRM2Sz+9cjXrCZiDoPH+NJY7MEg=; b=iL4zpMjX5W5m0T4WyGp+pXC+i
        ydoZcuF/TpPdcLBopuashFo5lrXmQiEjmRCgfkP3hY/femY7sJi67cGqQ6Jx7C4ZuGYgBxfXZ7od3
        UlIGU83gka38q1JzgJ9VEv7sHo6RN/TUrsdO8WIr/SqRTM1pQ5IMNSmHehY2EfufwvUTlzsO1lTpI
        3hjnACUlTRtTZh4zSGQ3xpG4VuPFxkIWzJ5+q46JpXAy4sMWR4KKM2/+897ouaAUyrPV0cxFiwFNh
        6ZoLYev+gEQ+ZVogYdQ4Ok9GAhyc9x96wwHySg//jXch1w41B7xfLdmRV4tobbnz6cRRDj2W1U/Tq
        PAd10sg8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35196)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khIGz-0006ZS-V2; Mon, 23 Nov 2020 20:17:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khIGx-0006cZ-UL; Mon, 23 Nov 2020 20:17:15 +0000
Date:   Mon, 23 Nov 2020 20:17:15 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch
Subject: Re: [PATCH v2] net: mvpp2: divide fifo for dts-active ports only
Message-ID: <20201123201715.GZ1551@shell.armlinux.org.uk>
References: <1606154073-28267-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606154073-28267-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 07:54:33PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Tx/Rx FIFO is a HW resource limited by total size, but shared
> by all ports of same CP110 and impacting port-performance.
> Do not divide the FIFO for ports which are not enabled in DTS,
> so active ports could have more FIFO.
> No change in FIFO allocation if all 3 ports on the communication
> processor enabled in DTS.
> 
> The active port mapping should be done in probe before FIFO-init.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>

Thanks.

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

One thing I didn't point out is that netdev would like patch submissions
to indicate which tree they are targetting. Are you intending this for
net or net-next?

[PATCH net vX] ...

or

[PATCH net-next vX] ...

in the subject line please.

> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  23 +++--
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 129 +++++++++++++++++-------
>  2 files changed, 108 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> index 8347758..6bd7e40 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
> @@ -695,6 +695,9 @@
>  /* Maximum number of supported ports */
>  #define MVPP2_MAX_PORTS			4
>  
> +/* Loopback port index */
> +#define MVPP2_LOOPBACK_PORT_INDEX	3
> +
>  /* Maximum number of TXQs used by single port */
>  #define MVPP2_MAX_TXQ			8
>  
> @@ -729,22 +732,21 @@
>  #define MVPP2_TX_DESC_ALIGN		(MVPP2_DESC_ALIGNED_SIZE - 1)
>  
>  /* RX FIFO constants */
> +#define MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB	0xb000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB	0x8000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB	0x2000
>  #define MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB	0x1000
> -#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB	0x200
> -#define MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB	0x80
> +#define MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size)	((data_size) >> 6)
>  #define MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB	0x40
>  #define MVPP2_RX_FIFO_PORT_MIN_PKT		0x80
>  
>  /* TX FIFO constants */
> -#define MVPP22_TX_FIFO_DATA_SIZE_10KB		0xa
> -#define MVPP22_TX_FIFO_DATA_SIZE_3KB		0x3
> -#define MVPP2_TX_FIFO_THRESHOLD_MIN		256
> -#define MVPP2_TX_FIFO_THRESHOLD_10KB	\
> -	(MVPP22_TX_FIFO_DATA_SIZE_10KB * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
> -#define MVPP2_TX_FIFO_THRESHOLD_3KB	\
> -	(MVPP22_TX_FIFO_DATA_SIZE_3KB * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
> +#define MVPP22_TX_FIFO_DATA_SIZE_16KB		16
> +#define MVPP22_TX_FIFO_DATA_SIZE_10KB		10
> +#define MVPP22_TX_FIFO_DATA_SIZE_3KB		3
> +#define MVPP2_TX_FIFO_THRESHOLD_MIN		256 /* Bytes */
> +#define MVPP2_TX_FIFO_THRESHOLD(kb)	\
> +		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
>  
>  /* RX buffer constants */
>  #define MVPP2_SKB_SHINFO_SIZE \
> @@ -946,6 +948,9 @@ struct mvpp2 {
>  	/* List of pointers to port structures */
>  	int port_count;
>  	struct mvpp2_port *port_list[MVPP2_MAX_PORTS];
> +	/* Map of enabled ports */
> +	unsigned long port_map;
> +
>  	struct mvpp2_tai *tai;
>  
>  	/* Number of Tx threads used */
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index f6616c8..08c237a 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6601,32 +6601,56 @@ static void mvpp2_rx_fifo_init(struct mvpp2 *priv)
>  	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
>  }
>  
> -static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
> +static void mvpp22_rx_fifo_set_hw(struct mvpp2 *priv, int port, int data_size)
>  {
> -	int port;
> +	int attr_size = MVPP2_RX_FIFO_PORT_ATTR_SIZE(data_size);
>  
> -	/* The FIFO size parameters are set depending on the maximum speed a
> -	 * given port can handle:
> -	 * - Port 0: 10Gbps
> -	 * - Port 1: 2.5Gbps
> -	 * - Ports 2 and 3: 1Gbps
> -	 */
> +	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port), data_size);
> +	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port), attr_size);
> +}
>  
> -	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(0),
> -		    MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
> -	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(0),
> -		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_32KB);
> +/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2.
> + * 4kB fixed space must be assigned for the loopback port.
> + * Redistribute remaining avialable 44kB space among all active ports.
> + * Guarantee minimum 32kB for 10G port and 8kB for port 1, capable of 2.5G
> + * SGMII link.
> + */
> +static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
> +{
> +	int remaining_ports_count;
> +	unsigned long port_map;
> +	int size_remainder;
> +	int port, size;
> +
> +	/* The loopback requires fixed 4kB of the FIFO space assignment. */
> +	mvpp22_rx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
> +			      MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
> +	port_map = priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
> +
> +	/* Set RX FIFO size to 0 for inactive ports. */
> +	for_each_clear_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX)
> +		mvpp22_rx_fifo_set_hw(priv, port, 0);
> +
> +	/* Assign remaining RX FIFO space among all active ports. */
> +	size_remainder = MVPP2_RX_FIFO_PORT_DATA_SIZE_44KB;
> +	remaining_ports_count = hweight_long(port_map);
> +
> +	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
> +		if (remaining_ports_count == 1)
> +			size = size_remainder;
> +		else if (port == 0)
> +			size = max(size_remainder / remaining_ports_count,
> +				   MVPP2_RX_FIFO_PORT_DATA_SIZE_32KB);
> +		else if (port == 1)
> +			size = max(size_remainder / remaining_ports_count,
> +				   MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
> +		else
> +			size = size_remainder / remaining_ports_count;
>  
> -	mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(1),
> -		    MVPP2_RX_FIFO_PORT_DATA_SIZE_8KB);
> -	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(1),
> -		    MVPP2_RX_FIFO_PORT_ATTR_SIZE_8KB);
> +		size_remainder -= size;
> +		remaining_ports_count--;
>  
> -	for (port = 2; port < MVPP2_MAX_PORTS; port++) {
> -		mvpp2_write(priv, MVPP2_RX_DATA_FIFO_SIZE_REG(port),
> -			    MVPP2_RX_FIFO_PORT_DATA_SIZE_4KB);
> -		mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port),
> -			    MVPP2_RX_FIFO_PORT_ATTR_SIZE_4KB);
> +		mvpp22_rx_fifo_set_hw(priv, port, size);
>  	}
>  
>  	mvpp2_write(priv, MVPP2_RX_MIN_PKT_SIZE_REG,
> @@ -6634,24 +6658,53 @@ static void mvpp22_rx_fifo_init(struct mvpp2 *priv)
>  	mvpp2_write(priv, MVPP2_RX_FIFO_INIT_REG, 0x1);
>  }
>  
> -/* Initialize Tx FIFO's: the total FIFO size is 19kB on PPv2.2 and 10G
> - * interfaces must have a Tx FIFO size of 10kB. As only port 0 can do 10G,
> - * configure its Tx FIFO size to 10kB and the others ports Tx FIFO size to 3kB.
> +static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size)
> +{
> +	int threshold = MVPP2_TX_FIFO_THRESHOLD(size);
> +
> +	mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
> +	mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), threshold);
> +}
> +
> +/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2.
> + * 3kB fixed space must be assigned for the loopback port.
> + * Redistribute remaining avialable 16kB space among all active ports.
> + * The 10G interface should use 10kB (which is maximum possible size
> + * per single port).
>   */
>  static void mvpp22_tx_fifo_init(struct mvpp2 *priv)
>  {
> -	int port, size, thrs;
> -
> -	for (port = 0; port < MVPP2_MAX_PORTS; port++) {
> -		if (port == 0) {
> +	int remaining_ports_count;
> +	unsigned long port_map;
> +	int size_remainder;
> +	int port, size;
> +
> +	/* The loopback requires fixed 3kB of the FIFO space assignment. */
> +	mvpp22_tx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
> +			      MVPP22_TX_FIFO_DATA_SIZE_3KB);
> +	port_map = priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
> +
> +	/* Set TX FIFO size to 0 for inactive ports. */
> +	for_each_clear_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX)
> +		mvpp22_tx_fifo_set_hw(priv, port, 0);
> +
> +	/* Assign remaining TX FIFO space among all active ports. */
> +	size_remainder = MVPP22_TX_FIFO_DATA_SIZE_16KB;
> +	remaining_ports_count = hweight_long(port_map);
> +
> +	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
> +		if (remaining_ports_count == 1)
> +			size = min(size_remainder,
> +				   MVPP22_TX_FIFO_DATA_SIZE_10KB);
> +		else if (port == 0)
>  			size = MVPP22_TX_FIFO_DATA_SIZE_10KB;
> -			thrs = MVPP2_TX_FIFO_THRESHOLD_10KB;
> -		} else {
> -			size = MVPP22_TX_FIFO_DATA_SIZE_3KB;
> -			thrs = MVPP2_TX_FIFO_THRESHOLD_3KB;
> -		}
> -		mvpp2_write(priv, MVPP22_TX_FIFO_SIZE_REG(port), size);
> -		mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), thrs);
> +		else
> +			size = size_remainder / remaining_ports_count;
> +
> +		size_remainder -= size;
> +		remaining_ports_count--;
> +
> +		mvpp22_tx_fifo_set_hw(priv, port, size);
>  	}
>  }
>  
> @@ -6952,6 +7005,12 @@ static int mvpp2_probe(struct platform_device *pdev)
>  			goto err_axi_clk;
>  	}
>  
> +	/* Map DTS-active ports. Should be done before FIFO mvpp2_init */
> +	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
> +		if (!fwnode_property_read_u32(port_fwnode, "port-id", &i))
> +			priv->port_map |= BIT(i);
> +	}
> +
>  	/* Initialize network controller */
>  	err = mvpp2_init(pdev, priv);
>  	if (err < 0) {
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
