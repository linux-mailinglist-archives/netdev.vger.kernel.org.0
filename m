Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF87598181
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbiHRKas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbiHRKaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:30:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40397E80C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:30:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oOcnL-0005Pa-2u; Thu, 18 Aug 2022 12:30:35 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1B924CD6BB;
        Thu, 18 Aug 2022 10:30:33 +0000 (UTC)
Date:   Thu, 18 Aug 2022 12:30:31 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com, Dario Binacchi <dariobin@libero.it>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] can: bxcan: add support for ST bxCAN controller
Message-ID: <20220818103031.m7bl6gbzcc76etig@pengutronix.de>
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
 <20220817143529.257908-5-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pdvj4caxzadjx4i4"
Content-Disposition: inline
In-Reply-To: <20220817143529.257908-5-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pdvj4caxzadjx4i4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

One step at a time, let's look at the TX path:

On 17.08.2022 16:35:29, Dario Binacchi wrote:
> +static netdev_tx_t bxcan_start_xmit(struct sk_buff *skb,
> +				    struct net_device *ndev)
> +{
> +	struct bxcan_priv *priv = netdev_priv(ndev);
> +	struct can_frame *cf = (struct can_frame *)skb->data;
> +	struct bxcan_regs *regs = priv->regs;
> +	struct bxcan_mb *mb_regs;

__iomem?

> +	unsigned int mb_id;
> +	u32 id, tsr;
> +	int i, j;
> +
> +	if (can_dropped_invalid_skb(ndev, skb))
> +		return NETDEV_TX_OK;
> +
> +	tsr = readl(&regs->tsr);
> +	mb_id = ffs((tsr & BXCAN_TSR_TME) >> BXCAN_TSR_TME_SHIFT);

We want to send the CAN frames in the exact order they are pushed into
the driver, so don't pick the first free mailbox you find. How a
priorities for the TX mailboxes handled?

Is the mailbox with the lowest number send first? Is there a priority
field in the mailbox?

If the mail with the lowest number is transmitted first, it's best to
have a tx_head and tx_tail counter, e.g:

struct bxcan_priv {
        ...
        unsigned int tx_head;
        unsigned int tx_tail;
        ...
};

They both start with 0. The xmit function pushes the CAN frame into the
"priv->tx_head % 3" mailbox. Before triggering the xmit in hardware the
tx_head is incremented.

In your TX complete ISR look at priv->tx_tail % 3 for completion,
increment tx_tail, loop.

> +	if (mb_id == 0)
> +		return NETDEV_TX_BUSY;
> +
> +	mb_id -= 1;
> +	mb_regs = &regs->tx_mb[mb_id];
> +
> +	if (cf->can_id & CAN_EFF_FLAG)
> +		id = BXCAN_TIxR_EXID(cf->can_id & CAN_EFF_MASK) |
> +			BXCAN_TIxR_IDE;
> +	else
> +		id = BXCAN_TIxR_STID(cf->can_id & CAN_SFF_MASK);
> +
> +	if (cf->can_id & CAN_RTR_FLAG)
> +		id |= BXCAN_TIxR_RTR;
> +
> +	bxcan_rmw(&mb_regs->dlc, BXCAN_TDTxR_DLC_MASK,
> +		  BXCAN_TDTxR_DLC(cf->len));
> +	priv->tx_dlc[mb_id] = cf->len;

Please use can_put_echo_skb() for this.

> +
> +	for (i = 0, j = 0; i < cf->len; i += 4, j++)
> +		writel(*(u32 *)(cf->data + i), &mb_regs->data[j]);
> +
> +	/* Start transmission */
> +	writel(id | BXCAN_TIxR_TXRQ, &mb_regs->id);
> +	/* Stop the queue if we've filled all mailbox entries */
> +	if (!(readl(&regs->tsr) & BXCAN_TSR_TME))
> +		netif_stop_queue(ndev);

This is racy. You have to stop the queue before triggering the
transmission.

Have a look at the mcp251xfd driver:

| https://elixir.bootlin.com/linux/latest/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c#L187

The check for NETDEV_TX_BUSY is a bit more complicated, too:

| https://elixir.bootlin.com/linux/latest/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c#L178

The mcp251xfd has a proper hardware FIFO ring buffer for TX, the bxcan
probably doesn't. The get_tx_free() check is a bit different. Look at
c_can_get_tx_free() in:

| https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=28e86e9ab522e65b08545e5008d0f1ac5b19dad1

This patch is a good example for the relevant changes.

> +
> +	return NETDEV_TX_OK;
> +}

[...]

> +static irqreturn_t bxcan_tx_isr(int irq, void *dev_id)
> +{
> +	struct net_device *ndev = dev_id;
> +	struct bxcan_priv *priv = netdev_priv(ndev);
> +	struct bxcan_regs __iomem *regs = priv->regs;
> +	struct net_device_stats *stats = &ndev->stats;
> +	u32 tsr, rqcp_bit = BXCAN_TSR_RQCP0;
> +	int i;
> +
> +	tsr = readl(&regs->tsr);
> +	for (i = 0; i < BXCAN_TX_MB_NUM; rqcp_bit <<= 8, i++) {

This might break the order of TX completion CAN frames.

> +		if (!(tsr & rqcp_bit))
> +			continue;
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes += priv->tx_dlc[i];

Use can_get_echo_skb() here.

> +	}
> +
> +	writel(tsr, &regs->tsr);
> +
> +	if (netif_queue_stopped(ndev))
> +		netif_wake_queue(ndev);

With tx_head and tx_tail this should look like this:

| https://elixir.bootlin.com/linux/v5.19/source/drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c#L251

> +
> +	return IRQ_HANDLED;
> +}

Marc

--
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pdvj4caxzadjx4i4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL+FMUACgkQrX5LkNig
0106dQgAo2rMUTt1kopLbWrAtOMPOEZUJovNqrwB3AfWul/nZ02JCSbx1YUzFTSH
EYvaqWdbEMXcMGeUg23m59IQKCHvROCtNI1WiznlqwARz8hlR1ElEa8kGm+V86W+
DrBkf04DhIKU/ni+ykU4xBgxbR3/K0EmT9uuatq29rN8UtM9ZGOy6Khd4fEgqj0u
BP9ncUjSb2qhMqZVJ2csWUSXIIjOuZ2NplECgddfhQCW51AkygdEEwDI+zDUyS+F
5V1U8Ca0dTdjSBPO3hoGVLlFSrKlHw955HPk3wUfDP5WMx+W1igIwaROGpfmecuc
WiLxU9NazC+j3Uz8THRt48ZtycmvEQ==
=fPoa
-----END PGP SIGNATURE-----

--pdvj4caxzadjx4i4--
