Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A196C8198
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbjCXPmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjCXPlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:41:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D1D22009
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:41:31 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfjX0-00024Y-UF; Fri, 24 Mar 2023 16:40:43 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B88F619B9AC;
        Fri, 24 Mar 2023 15:40:38 +0000 (UTC)
Date:   Fri, 24 Mar 2023 16:40:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        michael@amarulasolutions.com, Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v7 5/5] can: bxcan: add support for ST bxCAN
 controller
Message-ID: <20230324154037.xpqh65ehhdryagaf@pengutronix.de>
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
 <20230315211040.2455855-6-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hurynxunpy2fobxu"
Content-Disposition: inline
In-Reply-To: <20230315211040.2455855-6-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hurynxunpy2fobxu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.03.2023 22:10:40, Dario Binacchi wrote:
> Add support for the basic extended CAN controller (bxCAN) found in many
> low- to middle-end STM32 SoCs. It supports the Basic Extended CAN
> protocol versions 2.0A and B with a maximum bit rate of 1 Mbit/s.
>=20
> The controller supports two channels (CAN1 as master and CAN2 as slave)
> and the driver can enable either or both of the channels. They share
> some of the required logic (e. g. clocks and filters), and that means
> you cannot use the slave CAN without enabling some hardware resources
> managed by the master CAN.
>=20
> Each channel has 3 transmit mailboxes, 2 receive FIFOs with 3 stages and
> 28 scalable filter banks.
> It also manages 4 dedicated interrupt vectors:
> - transmit interrupt
> - FIFO 0 receive interrupt
> - FIFO 1 receive interrupt
> - status change error interrupt
>=20
> Driver uses all 3 available mailboxes for transmission and FIFO 0 for
> reception. Rx filter rules are configured to the minimum. They accept
> all messages and assign filter 0 to CAN1 and filter 14 to CAN2 in
> identifier mask mode with 32 bits width. It enables and uses transmit,
> receive buffers for FIFO 0 and error and status change interrupts.
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>


[...]

> diff --git a/drivers/net/can/bxcan.c b/drivers/net/can/bxcan.c
> new file mode 100644
> index 000000000000..daf4d7ef00e7
> --- /dev/null
> +++ b/drivers/net/can/bxcan.c

[...]

> +
> +static inline void bxcan_rmw(struct bxcan_priv *priv, void __iomem *addr,
> +			     u32 clear, u32 set)
> +{
> +	unsigned long flags;
> +	u32 old, val;
> +
> +	spin_lock_irqsave(&priv->rmw_lock, flags);
> +	old =3D readl(addr);
> +	val =3D (old & ~clear) | set;
> +	if (val !=3D old)
> +		writel(val, addr);
> +
> +	spin_unlock_irqrestore(&priv->rmw_lock, flags);
> +}

I think you don't need the spin_lock anymore, but it's not in the hot
path, so leave it this way.

> +

[...]

> +static irqreturn_t bxcan_rx_isr(int irq, void *dev_id)
> +{
> +	struct net_device *ndev =3D dev_id;
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +
> +	can_rx_offload_irq_offload_fifo(&priv->offload);
> +	can_rx_offload_irq_finish(&priv->offload);
> +
> +	return IRQ_HANDLED;

This handler is not 100% shared IRQ safe, you have to return IRQ_NONE if
no IRQ is active.

> +}
> +
> +static irqreturn_t bxcan_tx_isr(int irq, void *dev_id)
> +{
> +	struct net_device *ndev =3D dev_id;
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +	struct bxcan_regs __iomem *regs =3D priv->regs;
> +	struct net_device_stats *stats =3D &ndev->stats;
> +	u32 tsr, rqcp_bit;
> +	int idx;
> +
> +	tsr =3D readl(&regs->tsr);
> +	if (!(tsr & (BXCAN_TSR_RQCP0 | BXCAN_TSR_RQCP1 | BXCAN_TSR_RQCP2)))
> +		return IRQ_HANDLED;

Is this a check for no IRQ? Then return IRQ_NONE.

> +
> +	while (priv->tx_head - priv->tx_tail > 0) {
> +		idx =3D bxcan_get_tx_tail(priv);
> +		rqcp_bit =3D BXCAN_TSR_RQCP0 << (idx << 3);
> +		if (!(tsr & rqcp_bit))
> +			break;
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes +=3D can_get_echo_skb(ndev, idx, NULL);
> +		priv->tx_tail++;
> +	}
> +
> +	writel(tsr, &regs->tsr);
> +
> +	if (bxcan_get_tx_free(priv)) {
> +		/* Make sure that anybody stopping the queue after
> +		 * this sees the new tx_ring->tail.
> +		 */
> +		smp_mb();
> +		netif_wake_queue(ndev);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void bxcan_handle_state_change(struct net_device *ndev, u32 esr)
> +{
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +	enum can_state new_state =3D priv->can.state;
> +	struct can_berr_counter bec;
> +	enum can_state rx_state, tx_state;
> +	struct sk_buff *skb;
> +	struct can_frame *cf;
> +
> +	/* Early exit if no error flag is set */
> +	if (!(esr & (BXCAN_ESR_EWGF | BXCAN_ESR_EPVF | BXCAN_ESR_BOFF)))
> +		return;
> +
> +	bec.txerr =3D FIELD_GET(BXCAN_ESR_TEC_MASK, esr);
> +	bec.rxerr =3D FIELD_GET(BXCAN_ESR_REC_MASK, esr);
> +
> +	if (esr & BXCAN_ESR_BOFF)
> +		new_state =3D CAN_STATE_BUS_OFF;
> +	else if (esr & BXCAN_ESR_EPVF)
> +		new_state =3D CAN_STATE_ERROR_PASSIVE;
> +	else if (esr & BXCAN_ESR_EWGF)
> +		new_state =3D CAN_STATE_ERROR_WARNING;
> +
> +	/* state hasn't changed */
> +	if (unlikely(new_state =3D=3D priv->can.state))
> +		return;
> +
> +	skb =3D alloc_can_err_skb(ndev, &cf);
> +
> +	tx_state =3D bec.txerr >=3D bec.rxerr ? new_state : 0;
> +	rx_state =3D bec.txerr <=3D bec.rxerr ? new_state : 0;
> +	can_change_state(ndev, cf, tx_state, rx_state);
> +
> +	if (new_state =3D=3D CAN_STATE_BUS_OFF) {
> +		can_bus_off(ndev);
> +	} else if (skb) {
> +		cf->can_id |=3D CAN_ERR_CNT;
> +		cf->data[6] =3D bec.txerr;
> +		cf->data[7] =3D bec.rxerr;
> +	}
> +
> +	if (skb) {
> +		int err;
> +
> +		err =3D can_rx_offload_queue_timestamp(&priv->offload, skb,
> +						     priv->timestamp);
> +		if (err)
> +			ndev->stats.rx_fifo_errors++;
> +	}
> +}
> +
> +static void bxcan_handle_bus_err(struct net_device *ndev, u32 esr)
> +{
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +	enum bxcan_lec_code lec_code;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +
> +	lec_code =3D FIELD_GET(BXCAN_ESR_LEC_MASK, esr);
> +
> +	/* Early exit if no lec update or no error.
> +	 * No lec update means that no CAN bus event has been detected
> +	 * since CPU wrote BXCAN_LEC_UNUSED value to status reg.
> +	 */
> +	if (lec_code =3D=3D BXCAN_LEC_UNUSED || lec_code =3D=3D BXCAN_LEC_NO_ER=
ROR)
> +		return;
> +
> +	/* Common for all type of bus errors */
> +	priv->can.can_stats.bus_error++;
> +
> +	/* Propagate the error condition to the CAN stack */
> +	skb =3D alloc_can_err_skb(ndev, &cf);
> +	if (skb)
> +		cf->can_id |=3D CAN_ERR_PROT | CAN_ERR_BUSERROR;
> +
> +	switch (lec_code) {
> +	case BXCAN_LEC_STUFF_ERROR:
> +		netdev_dbg(ndev, "Stuff error\n");
> +		ndev->stats.rx_errors++;
> +		if (skb)
> +			cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> +		break;
> +
> +	case BXCAN_LEC_FORM_ERROR:
> +		netdev_dbg(ndev, "Form error\n");
> +		ndev->stats.rx_errors++;
> +		if (skb)
> +			cf->data[2] |=3D CAN_ERR_PROT_FORM;
> +		break;
> +
> +	case BXCAN_LEC_ACK_ERROR:
> +		netdev_dbg(ndev, "Ack error\n");
> +		ndev->stats.tx_errors++;
> +		if (skb) {
> +			cf->can_id |=3D CAN_ERR_ACK;
> +			cf->data[3] =3D CAN_ERR_PROT_LOC_ACK;
> +		}
> +		break;
> +
> +	case BXCAN_LEC_BIT1_ERROR:
> +		netdev_dbg(ndev, "Bit error (recessive)\n");
> +		ndev->stats.tx_errors++;
> +		if (skb)
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT1;
> +		break;
> +
> +	case BXCAN_LEC_BIT0_ERROR:
> +		netdev_dbg(ndev, "Bit error (dominant)\n");
> +		ndev->stats.tx_errors++;
> +		if (skb)
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT0;
> +		break;
> +
> +	case BXCAN_LEC_CRC_ERROR:
> +		netdev_dbg(ndev, "CRC error\n");
> +		ndev->stats.rx_errors++;
> +		if (skb) {
> +			cf->data[2] |=3D CAN_ERR_PROT_BIT;
> +			cf->data[3] =3D CAN_ERR_PROT_LOC_CRC_SEQ;
> +		}
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	if (skb) {
> +		int err;
> +
> +		err =3D can_rx_offload_queue_timestamp(&priv->offload, skb,
> +						     priv->timestamp);
> +		if (err)
> +			ndev->stats.rx_fifo_errors++;
> +	}
> +}
> +
> +static irqreturn_t bxcan_state_change_isr(int irq, void *dev_id)
> +{
> +	struct net_device *ndev =3D dev_id;
> +	struct bxcan_priv *priv =3D netdev_priv(ndev);
> +	struct bxcan_regs __iomem *regs =3D priv->regs;
> +	u32 msr, esr;
> +
> +	msr =3D readl(&regs->msr);
> +	if (!(msr & BXCAN_MSR_ERRI))
> +		return IRQ_NONE;

No IRQ, the driver returns IRQ_NONE here? Looks good!

> +
> +	esr =3D readl(&regs->esr);
> +	bxcan_handle_state_change(ndev, esr);
> +
> +	if (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
> +		bxcan_handle_bus_err(ndev, esr);
> +
> +	msr |=3D BXCAN_MSR_ERRI;
> +	writel(msr, &regs->msr);
> +	can_rx_offload_irq_finish(&priv->offload);
> +
> +	return IRQ_HANDLED;
> +}

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hurynxunpy2fobxu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdxHIACgkQvlAcSiqK
BOgQMwgAhqpI0jAZ2dRqn5P/mLsnOX4aVIvI4E0PUfaZqZdPfrmRtYr2SDWkFrj3
LOHzYHnbYeBqELhwM3H+E5oRyPihf+rkBZg2WBoeRVKaCWXSFNm+QAuKpNkYGbDu
kCd5HlvWWcVJUN8ORSyVB2jH0laBS9eyqmuBAcYtGURrUEIz7LEBAhd97gykKxKv
m0PAQPbG6CPB43NTx06beGz8n6QIzDwiVs2EKju0/Ni4nlKWsE0u2GpKSf0PYkZz
5zdO20lWOc6OtEZ4uuQTdC4i8b3SvTo5fJq2416XSbaU0bRWR5RVCkKacdgHBiOs
ulHzE9NkcPO1teCJGnZF1Zcs7ZUX0w==
=5afL
-----END PGP SIGNATURE-----

--hurynxunpy2fobxu--
