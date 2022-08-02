Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2115879EC
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbiHBJfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiHBJez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:34:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07574D4C0
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:34:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIoIA-0005wP-Ok; Tue, 02 Aug 2022 11:34:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A8CD8C14AC;
        Tue,  2 Aug 2022 09:29:08 +0000 (UTC)
Date:   Tue, 2 Aug 2022 11:29:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mpyxooqxypbx3d4e"
Content-Disposition: inline
In-Reply-To: <20220801184656.702930-2-matej.vasilevski@seznam.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mpyxooqxypbx3d4e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.08.2022 20:46:54, Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts_clk" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.
>=20
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  drivers/net/can/ctucanfd/Makefile             |   2 +-
>  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
>  drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 +++++++++++++++++-
>  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
>  4 files changed, 315 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
>=20
> diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd=
/Makefile
> index 8078f1f2c30f..a36e66f2cea7 100644
> --- a/drivers/net/can/ctucanfd/Makefile
> +++ b/drivers/net/can/ctucanfd/Makefile
> @@ -4,7 +4,7 @@
>  #
> =20
>  obj-$(CONFIG_CAN_CTUCANFD) :=3D ctucanfd.o
> -ctucanfd-y :=3D ctucanfd_base.o
> +ctucanfd-y :=3D ctucanfd_base.o ctucanfd_timestamp.o
> =20
>  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
>  obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucan=
fd/ctucanfd.h
> index 0e9904f6a05d..43d9c73ce244 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd.h
> +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> @@ -23,6 +23,10 @@
>  #include <linux/netdevice.h>
>  #include <linux/can/dev.h>
>  #include <linux/list.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>
> +
> +#define CTUCANFD_MAX_WORK_DELAY_SEC 86400U	/* one day =3D=3D 24 * 3600 s=
econds */

For higher precision we can limit this to 3600s, as the sched_clock does
it
:
| https://elixir.bootlin.com/linux/v5.19/source/kernel/time/sched_clock.c#L=
169

>  enum ctu_can_fd_can_registers;
> =20
> @@ -51,6 +55,15 @@ struct ctucan_priv {
>  	u32 rxfrm_first_word;
> =20
>  	struct list_head peers_on_pdev;
> +
> +	struct cyclecounter cc;
> +	struct timecounter tc;
> +	struct delayed_work timestamp;
> +
> +	struct clk *timestamp_clk;
> +	u32 work_delay_jiffies;

schedule_delayed_work() takes an "unsigned long" not a u32.

> +	bool timestamp_enabled;
> +	bool timestamp_possible;
>  };
> =20
>  /**
> @@ -79,4 +92,11 @@ int ctucan_probe_common(struct device *dev, void __iom=
em *addr,
>  int ctucan_suspend(struct device *dev) __maybe_unused;
>  int ctucan_resume(struct device *dev) __maybe_unused;
> =20
> +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
> +u32 ctucan_calculate_work_delay(const u32 timestamp_bit_size, const u32 =
timestamp_freq);
> +void ctucan_skb_set_timestamp(const struct ctucan_priv *priv, struct sk_=
buff *skb,
> +			      u64 timestamp);
> +void ctucan_timestamp_init(struct ctucan_priv *priv);
> +void ctucan_timestamp_stop(struct ctucan_priv *priv);
>  #endif /*__CTUCANFD__*/
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/c=
tucanfd/ctucanfd_base.c
> index 3c18d028bd8c..35b37de51811 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> @@ -18,6 +18,7 @@
>   ***********************************************************************=
*******/
> =20
>  #include <linux/clk.h>
> +#include <linux/clocksource.h>
>  #include <linux/errno.h>
>  #include <linux/ethtool.h>
>  #include <linux/init.h>
> @@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv =
*priv, enum ctu_can_fd_can_r
>  	priv->write_reg(priv, buf_base + offset, val);
>  }
> =20
> +static u64 concatenate_two_u32(u32 high, u32 low)

static inline?

> +{
> +	return ((u64)high << 32) | ((u64)low);
> +}
> +
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> +{
> +	u32 ts_low;
> +	u32 ts_high;
> +	u32 ts_high2;
> +
> +	ts_high =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +	ts_low =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> +	ts_high2 =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +
> +	if (ts_high2 !=3D ts_high)
> +		ts_low =3D priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> +
> +	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
> +}
> +
>  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read=
32(priv, CTUCANFD_STATUS)))
>  #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read3=
2(priv, CTUCANFD_MODE)))

please make these static inline bool functions.

> =20
> @@ -640,12 +662,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff=
 *skb, struct net_device *nde
>   * @priv:	Pointer to CTU CAN FD's private data
>   * @cf:		Pointer to CAN frame struct
>   * @ffw:	Previously read frame format word
> + * @skb:	Pointer to buffer to store timestamp
>   *
>   * Note: Frame format word must be read separately and provided in 'ffw'.
>   */
> -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf, u32 ffw)
> +static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf,
> +				 u32 ffw, u64 *timestamp)
>  {
>  	u32 idw;
> +	u32 tstamp_high;
> +	u32 tstamp_low;
>  	unsigned int i;
>  	unsigned int wc;
>  	unsigned int len;
> @@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv =
*priv, struct canfd_frame *c
>  	if (unlikely(len > wc * 4))
>  		len =3D wc * 4;
> =20
> -	/* Timestamp - Read and throw away */
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	/* Timestamp */
> +	tstamp_low =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	tstamp_high =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	*timestamp =3D concatenate_two_u32(tstamp_high, tstamp_low) & priv->cc.=
mask;
> =20
>  	/* Data */
>  	for (i =3D 0; i < len; i +=3D 4) {
> @@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
>  	struct net_device_stats *stats =3D &ndev->stats;
>  	struct canfd_frame *cf;
>  	struct sk_buff *skb;
> +	u64 timestamp;
>  	u32 ffw;
> =20
>  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
>  		return 0;
>  	}
> =20
> -	ctucan_read_rx_frame(priv, cf, ffw);
> +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> +	if (priv->timestamp_enabled)
> +		ctucan_skb_set_timestamp(priv, skb, timestamp);

Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counter()
happen concurrently? AFAICS they are all called from ctucan_rx_poll(),
right?

> =20
>  	stats->rx_bytes +=3D cf->len;
>  	stats->rx_packets++;
> @@ -906,6 +936,11 @@ static void ctucan_err_interrupt(struct net_device *=
ndev, u32 isr)
>  	if (skb) {
>  		stats->rx_packets++;
>  		stats->rx_bytes +=3D cf->can_dlc;
> +		if (priv->timestamp_enabled) {
> +			u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +			ctucan_skb_set_timestamp(priv, skb, tstamp);
> +		}
>  		netif_rx(skb);
>  	}
>  }
> @@ -951,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, =
int quota)
>  			cf->data[1] |=3D CAN_ERR_CRTL_RX_OVERFLOW;
>  			stats->rx_packets++;
>  			stats->rx_bytes +=3D cf->can_dlc;
> +			if (priv->timestamp_enabled) {
> +				u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +				ctucan_skb_set_timestamp(priv, skb, tstamp);
> +			}
>  			netif_rx(skb);
>  		}
> =20
> @@ -1231,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
>  		goto err_chip_start;
>  	}
> =20
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_init(priv);
> +
>  	netdev_info(ndev, "ctu_can_fd device registered\n");
>  	napi_enable(&priv->napi);
>  	netif_start_queue(ndev);
> @@ -1263,6 +1306,9 @@ static int ctucan_close(struct net_device *ndev)
>  	ctucan_chip_stop(ndev);
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_stop(priv);
> +

Nitpick: Don't add an extra newline here.

> =20
>  	pm_runtime_put(priv->dev);
> =20
> @@ -1295,15 +1341,117 @@ static int ctucan_get_berr_counter(const struct =
net_device *ndev, struct can_ber
>  	return 0;
>  }
> =20
> +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(dev);
> +	struct hwtstamp_config cfg;
> +
> +	if (!priv->timestamp_possible)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +		return -EFAULT;
> +
> +	if (cfg.flags)
> +		return -EINVAL;
> +
> +	if (cfg.tx_type !=3D HWTSTAMP_TX_OFF)
> +		return -ERANGE;
> +
> +	switch (cfg.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		priv->timestamp_enabled =3D false;
> +		break;
> +	case HWTSTAMP_FILTER_ALL:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
> +		fallthrough;
> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> +		priv->timestamp_enabled =3D true;
> +		cfg.rx_filter =3D HWTSTAMP_FILTER_ALL;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}
> +
> +static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(dev);
> +	struct hwtstamp_config cfg;
> +
> +	if (!priv->timestamp_possible)
> +		return -EOPNOTSUPP;
> +
> +	cfg.flags =3D 0;
> +	cfg.tx_type =3D HWTSTAMP_TX_OFF;
> +	cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL : HWTST=
AMP_FILTER_NONE;
> +
> +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> +}
> +
> +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int c=
md)
> +{
> +	switch (cmd) {
> +	case SIOCSHWTSTAMP:
> +		return ctucan_hwtstamp_set(dev, ifr);
> +	case SIOCGHWTSTAMP:
> +		return ctucan_hwtstamp_get(dev, ifr);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int ctucan_ethtool_get_ts_info(struct net_device *ndev, struct et=
htool_ts_info *info)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +	ethtool_op_get_ts_info(ndev, info);
> +
> +	if (!priv->timestamp_possible)
> +		return 0;
> +
> +	info->so_timestamping |=3D SOF_TIMESTAMPING_RX_HARDWARE |
> +				 SOF_TIMESTAMPING_RAW_HARDWARE;
> +	info->tx_types =3D BIT(HWTSTAMP_TX_OFF);
> +	info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE) |
> +			   BIT(HWTSTAMP_FILTER_ALL);
> +
> +	return 0;
> +}
> +
>  static const struct net_device_ops ctucan_netdev_ops =3D {
>  	.ndo_open	=3D ctucan_open,
>  	.ndo_stop	=3D ctucan_close,
>  	.ndo_start_xmit	=3D ctucan_start_xmit,
>  	.ndo_change_mtu	=3D can_change_mtu,
> +	.ndo_eth_ioctl	=3D ctucan_ioctl,
>  };
> =20
>  static const struct ethtool_ops ctucan_ethtool_ops =3D {
> -	.get_ts_info =3D ethtool_op_get_ts_info,
> +	.get_ts_info =3D ctucan_ethtool_get_ts_info,
>  };
> =20
>  int ctucan_suspend(struct device *dev)
> @@ -1345,6 +1493,8 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
>  	struct ctucan_priv *priv;
>  	struct net_device *ndev;
>  	int ret;
> +	u32 timestamp_freq =3D 0;
> +	u32 timestamp_bit_size =3D 0;

Nitpick: please move the u32 between the struct and the int.

> =20
>  	/* Create a CAN device instance */
>  	ndev =3D alloc_candev(sizeof(struct ctucan_priv), ntxbufs);
> @@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
> =20
>  	/* Getting the can_clk info */
>  	if (!can_clk_rate) {
> -		priv->can_clk =3D devm_clk_get(dev, NULL);
> +		priv->can_clk =3D devm_clk_get_optional(dev, "core-clk");
> +		if (!priv->can_clk)
> +			priv->can_clk =3D devm_clk_get(dev, NULL);

Please add a comment here, that the NULL clock is for compatibility with
older DTs.

>  		if (IS_ERR(priv->can_clk)) {
>  			dev_err(dev, "Device clock not found.\n");
>  			ret =3D PTR_ERR(priv->can_clk);
> @@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
> =20
>  	priv->can.clock.freq =3D can_clk_rate;
> =20
> +	priv->timestamp_enabled =3D false;
> +	priv->timestamp_possible =3D true;
> +	priv->timestamp_clk =3D NULL;

priv is allocated and initialized with 0

> +
> +	/* Obtain timestamping frequency */
> +	if (pm_enable_call) {
> +		/* Plaftorm device: get tstamp clock from device tree */
> +		priv->timestamp_clk =3D devm_clk_get(dev, "ts-clk");
> +		if (IS_ERR(priv->timestamp_clk)) {
> +			/* Take the core clock frequency instead */
> +			timestamp_freq =3D can_clk_rate;
> +		} else {
> +			timestamp_freq =3D clk_get_rate(priv->timestamp_clk);
> +		}

Who prepares/enabled the timestamp clock? clk_get_rate() is only valid if
the clock is enabled. I know, we violate this for the CAN clock. :/

> +	} else {
> +		/* PCI device: assume tstamp freq is equal to bus clk rate */
> +		timestamp_freq =3D can_clk_rate;
> +	}
> +
> +	/* Obtain timestamping counter bit size */
> +	timestamp_bit_size =3D (ctucan_read32(priv, CTUCANFD_ERR_CAPT) & REG_ER=
R_CAPT_TS_BITS) >> 24;
> +	timestamp_bit_size +=3D 1;	/* the register value was bit_size - 1 */

Please move the +1 into the else of the following if() which results in:

| if (timestamp_bit_size)

which is IMHO easier to read.

> +
> +	/* For 2.x versions of the IP core, we will assume 64-bit counter
> +	 * if there was a 0 in the register.
> +	 */
> +	if (timestamp_bit_size =3D=3D 1) {
> +		u32 version_reg =3D ctucan_read32(priv, CTUCANFD_DEVICE_ID);
> +		u32 major =3D (version_reg & REG_DEVICE_ID_VER_MAJOR) >> 24;
> +
> +		if (major =3D=3D 2)
> +			timestamp_bit_size =3D 64;
> +		else
> +			priv->timestamp_possible =3D false;
> +	}
> +
> +	/* Setup conversion constants and work delay */
> +	priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> +	priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);

Does the driver use these 2 if timestamping is not possible?

> +	if (priv->timestamp_possible) {
> +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq,
> +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> +		priv->work_delay_jiffies =3D
> +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> +		if (priv->work_delay_jiffies =3D=3D 0)
> +			priv->timestamp_possible =3D false;

You'll get a higher precision if you take the mask into account, at
least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:

        maxsec =3D min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask / timesta=
mp_freq);
=09
        clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_f=
req, NSEC_PER_SEC,  maxsec);
        work_delay_in_ns =3D clocks_calc_max_nsecs(&priv->cc.mult, &priv->c=
c.shift, 0, &priv->cc.mask, NULL);

You can use clocks_calc_max_nsecs() to calculate the work delay.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mpyxooqxypbx3d4e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLo7mAACgkQrX5LkNig
010eSAf9GLcmFdUbzbaQx9p7QrnRyEeMgeIF8Ox0MI6KH/0Q4VpkGhVgm7yyiR+x
Z4bLN5vm1f8pSyQHeN4xGUjOz3h24bjU6Db8YS9AZXMuhBrJdIWS3Hxpd5b5qN7C
8iNDMOJEmKt7I+XTskWqBxRJDNI5bmnyYNORDvTWZ1ouBNSHvDMOehrvDhuRG/jC
xTxc5/8zL+wDN4gwa0+HX1+kRn1bG9LrG0VNaEXBIWQrGAZ1mMbAvDp3ELuI693O
tqTYSSgWkxLMdS6Fklboko0azKo9mH/gMe1ob1WdyT6MZ69bXtfWIiFaBpVnST3+
NEdROPsIGWAGb9U9XLOr+H+ZDXvskw==
=RbLG
-----END PGP SIGNATURE-----

--mpyxooqxypbx3d4e--
