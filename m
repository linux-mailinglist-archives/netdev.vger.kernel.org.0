Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4885BC042
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 00:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIRWD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 18:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIRWDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 18:03:24 -0400
X-Greylist: delayed 102 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Sep 2022 15:03:21 PDT
Received: from mxd2.seznam.cz (unknown [IPv6:2a02:598:64:8a00::19b5:5600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B62E15810;
        Sun, 18 Sep 2022 15:03:21 -0700 (PDT)
Received: from email.seznam.cz
        by smtpc-mxd-798f79c48f-4bkmz
        (smtpc-mxd-798f79c48f-4bkmz [2a02:598:64:8a00::19b5:5600])
        id 15ca9d23f1664e1d14173c4d;
        Mon, 19 Sep 2022 00:03:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1663538599; bh=QN2NfIyMJvnoAACCJTqhrZv+ZqdWCilLJCQfNGE7v5c=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
        b=DapBB+I5Yd71YVUvSGNFi0wrdXzGM+nHVVIXzBjmAzMyrD+eM1fA73ypU5ZlCARnc
         vbAYZf8vWNt3qOcikwrUkeOA00KQEHwjKC9AcLK3Uo5Qvxh4CfrejKBwETBe1ldGPY
         KTv9F+X0CdkMTi35FXw+clLd9mXL5bRevIRR8AqM=
Received: from hopium (2a02:8308:900d:2400:fbff:92a3:70c4:3597 [2a02:8308:900d:2400:fbff:92a3:70c4:3597])
        by email-relay24.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 19 Sep 2022 00:00:37 +0200 (CEST)  
Date:   Mon, 19 Sep 2022 00:00:35 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220918220035.GA14576@hopium>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
 <20220914233944.598298-3-matej.vasilevski@seznam.cz>
 <202209151250.27948.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202209151250.27948.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 12:50:27PM +0200, Pavel Pisa wrote:
> Dear Matej Vasilevski,
> 
> thanks much for the work on HW timestamping. For others, there
> is a little wider view and summary of our long term work available
> in CAN in a recent Automation Newletter magazine article.
> 
>   https://can-newsletter.org/uploads/media/raw/a9abe317ae034be55d99fee4410ad70e.pdf
> 
> I am happy that you have studied and added clock and power management
> support based on discussion with Marc Kleine-Budde.
> I see you have added these for "ts-clk". I am not sure if
> there are not missing some more calls for "core-clk".
> It is questionable if these clocks needs to be prepared
> by device, because these clock drive AXI/APB/... bus interface
> on which is CTU CAN FD core mapped so clocks has to be enabled
> by bus driver anyway to make given address range accessible.
> 
> It is not strictly HW timestamping related either. So if the patch
> is accepted in the current form I can prepare follow up patch
> if the result of discussion is that additional calls are required.
> 
> The position to discuss are highlighted inline
> 
Hello Pavel,

thanks for your review.
This patch manages only the timestamping clock, because I wanted to keep
the patch scope small, in order to finally merge this.
I'm already dragging this patch for almost 4 months, and I don't want to
miss another merge window.

> 
> On Thursday 15 of September 2022 01:39:43 Matej Vasilevski wrote:
> > This patch adds support for retrieving hardware timestamps to RX and
> > error CAN frames. It uses timecounter and cyclecounter structures,
> > because the timestamping counter width depends on the IP core integration
> > (it might not always be 64-bit).
> > For platform devices, you should specify "ts-clk" clock in device tree.
> > For PCI devices, the timestamping frequency is assumed to be the same
> > as bus frequency.
> >
> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > ---
> >  drivers/net/can/ctucanfd/Makefile             |   2 +-
> >  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
> >  drivers/net/can/ctucanfd/ctucanfd_base.c      | 239 ++++++++++++++++--
> >  drivers/net/can/ctucanfd/ctucanfd_pci.c       |   5 +-
> >  drivers/net/can/ctucanfd/ctucanfd_platform.c  |   5 +-
> >  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  70 +++++
> >  6 files changed, 318 insertions(+), 23 deletions(-)
> >  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> >
> > diff --git a/drivers/net/can/ctucanfd/Makefile
> > b/drivers/net/can/ctucanfd/Makefile index 8078f1f2c30f..a36e66f2cea7 100644
> > --- a/drivers/net/can/ctucanfd/Makefile
> > +++ b/drivers/net/can/ctucanfd/Makefile
> > @@ -4,7 +4,7 @@
> >  #
> >
> >  obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
> > -ctucanfd-y := ctucanfd_base.o
> > +ctucanfd-y := ctucanfd_base.o ctucanfd_timestamp.o
> >
> >  obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
> >  obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd.h
> > b/drivers/net/can/ctucanfd/ctucanfd.h index 0e9904f6a05d..b3ee583234b0
> > 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd.h
> > +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> > @@ -23,6 +23,10 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/can/dev.h>
> >  #include <linux/list.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/workqueue.h>
> > +
> > +#define CTUCANFD_MAX_WORK_DELAY_SEC 3600U
> >
> >  enum ctu_can_fd_can_registers;
> >
> > @@ -51,6 +55,15 @@ struct ctucan_priv {
> >  	u32 rxfrm_first_word;
> >
> >  	struct list_head peers_on_pdev;
> > +
> > +	struct cyclecounter cc;
> > +	struct timecounter tc;
> > +	spinlock_t tc_lock; /* spinlock to guard access tc->cycle_last */
> > +	struct delayed_work timestamp;
> > +	struct clk *timestamp_clk;
> > +	unsigned long work_delay_jiffies;
> > +	bool timestamp_enabled;
> > +	bool timestamp_possible;
> >  };
> >
> >  /**
> > @@ -78,5 +91,12 @@ int ctucan_probe_common(struct device *dev, void __iomem
> > *addr,
> >
> >  int ctucan_suspend(struct device *dev) __maybe_unused;
> >  int ctucan_resume(struct device *dev) __maybe_unused;
> > +int ctucan_runtime_resume(struct device *dev) __maybe_unused;
> > +int ctucan_runtime_suspend(struct device *dev) __maybe_unused;
> >
> > +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
> > +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
> > +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff
> > *skb, u64 timestamp); +void ctucan_timestamp_init(struct ctucan_priv
> > *priv);
> > +void ctucan_timestamp_stop(struct ctucan_priv *priv);
> >  #endif /*__CTUCANFD__*/
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c
> > b/drivers/net/can/ctucanfd/ctucanfd_base.c index 3c18d028bd8c..ba1a27c62ff1
> > 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> > @@ -18,6 +18,7 @@
> >  
> > ***************************************************************************
> >***/
> >
> >  #include <linux/clk.h>
> > +#include <linux/clocksource.h>
> >  #include <linux/errno.h>
> >  #include <linux/ethtool.h>
> >  #include <linux/init.h>
> > @@ -25,6 +26,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> >  #include <linux/kernel.h>
> > +#include <linux/math64.h>
> >  #include <linux/module.h>
> >  #include <linux/skbuff.h>
> >  #include <linux/string.h>
> > @@ -148,6 +150,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv
> > *priv, enum ctu_can_fd_can_r priv->write_reg(priv, buf_base + offset, val);
> >  }
> >
> > +static inline u64 ctucan_concat_tstamp(u32 high, u32 low)
> > +{
> > +	return ((u64)high << 32) | ((u64)low);
> > +}
> > +
> > +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> > +{
> > +	u32 ts_low;
> > +	u32 ts_high;
> > +	u32 ts_high2;
> > +
> > +	ts_high = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> > +	ts_low = ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> > +	ts_high2 = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> > +
> > +	if (ts_high2 != ts_high)
> > +		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> > +
> > +	return ctucan_concat_tstamp(ts_high2, ts_low) & priv->cc.mask;
> > +}
> > +
> >  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF,
> > ctucan_read32(priv, CTUCANFD_STATUS))) #define CTU_CAN_FD_ENABLED(priv)
> > (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
> >
> > @@ -640,12 +663,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff
> > *skb, struct net_device *nde * @priv:	Pointer to CTU CAN FD's private data
> >   * @cf:		Pointer to CAN frame struct
> >   * @ffw:	Previously read frame format word
> > + * @skb:	Pointer to buffer to store timestamp
> >   *
> >   * Note: Frame format word must be read separately and provided in 'ffw'.
> >   */
> > -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct
> > canfd_frame *cf, u32 ffw) +static void ctucan_read_rx_frame(struct
> > ctucan_priv *priv, struct canfd_frame *cf, +				 u32 ffw, u64 *timestamp)
> >  {
> >  	u32 idw;
> > +	u32 tstamp_high;
> > +	u32 tstamp_low;
> >  	unsigned int i;
> >  	unsigned int wc;
> >  	unsigned int len;
> > @@ -682,9 +709,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv
> > *priv, struct canfd_frame *c if (unlikely(len > wc * 4))
> >  		len = wc * 4;
> >
> > -	/* Timestamp - Read and throw away */
> > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	/* Timestamp */
> > +	tstamp_low = ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	tstamp_high = ctucan_read32(priv, CTUCANFD_RX_DATA);
> > +	*timestamp = ctucan_concat_tstamp(tstamp_high, tstamp_low) &
> > priv->cc.mask;
> >
> >  	/* Data */
> >  	for (i = 0; i < len; i += 4) {
> > @@ -713,6 +741,7 @@ static int ctucan_rx(struct net_device *ndev)
> >  	struct net_device_stats *stats = &ndev->stats;
> >  	struct canfd_frame *cf;
> >  	struct sk_buff *skb;
> > +	u64 timestamp;
> >  	u32 ffw;
> >
> >  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> > @@ -736,7 +765,9 @@ static int ctucan_rx(struct net_device *ndev)
> >  		return 0;
> >  	}
> >
> > -	ctucan_read_rx_frame(priv, cf, ffw);
> > +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> > +	if (priv->timestamp_enabled)
> > +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> >
> >  	stats->rx_bytes += cf->len;
> >  	stats->rx_packets++;
> > @@ -906,6 +937,11 @@ static void ctucan_err_interrupt(struct net_device
> > *ndev, u32 isr) if (skb) {
> >  		stats->rx_packets++;
> >  		stats->rx_bytes += cf->can_dlc;
> > +		if (priv->timestamp_enabled) {
> > +			u64 tstamp = ctucan_read_timestamp_counter(priv);
> > +
> > +			ctucan_skb_set_timestamp(priv, skb, tstamp);
> > +		}
> >  		netif_rx(skb);
> >  	}
> >  }
> > @@ -951,6 +987,11 @@ static int ctucan_rx_poll(struct napi_struct *napi,
> > int quota) cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
> >  			stats->rx_packets++;
> >  			stats->rx_bytes += cf->can_dlc;
> > +			if (priv->timestamp_enabled) {
> > +				u64 tstamp = ctucan_read_timestamp_counter(priv);
> > +
> > +				ctucan_skb_set_timestamp(priv, skb, tstamp);
> > +			}
> >  			netif_rx(skb);
> >  		}
> >
> > @@ -1200,9 +1241,9 @@ static int ctucan_open(struct net_device *ndev)
> >  	struct ctucan_priv *priv = netdev_priv(ndev);
> >  	int ret;
> >
> > -	ret = pm_runtime_get_sync(priv->dev);
> > +	ret = pm_runtime_resume_and_get(priv->dev);
> >  	if (ret < 0) {
> > -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> > +		netdev_err(ndev, "%s: pm_runtime_resume_and_get failed(%d)\n",
> >  			   __func__, ret);
> >  		pm_runtime_put_noidle(priv->dev);
> >  		return ret;
> > @@ -1231,6 +1272,9 @@ static int ctucan_open(struct net_device *ndev)
> >  		goto err_chip_start;
> >  	}
> >
> > +	if (priv->timestamp_possible)
> > +		ctucan_timestamp_init(priv);
> > +
> >  	netdev_info(ndev, "ctu_can_fd device registered\n");
> >  	napi_enable(&priv->napi);
> >  	netif_start_queue(ndev);
> > @@ -1263,6 +1307,8 @@ static int ctucan_close(struct net_device *ndev)
> >  	ctucan_chip_stop(ndev);
> >  	free_irq(ndev->irq, ndev);
> >  	close_candev(ndev);
> > +	if (priv->timestamp_possible)
> > +		ctucan_timestamp_stop(priv);
> >
> >  	pm_runtime_put(priv->dev);
> >
> > @@ -1282,9 +1328,9 @@ static int ctucan_get_berr_counter(const struct
> > net_device *ndev, struct can_ber struct ctucan_priv *priv =
> > netdev_priv(ndev);
> >  	int ret;
> >
> > -	ret = pm_runtime_get_sync(priv->dev);
> > +	ret = pm_runtime_resume_and_get(priv->dev);
> >  	if (ret < 0) {
> > -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
> > +		netdev_err(ndev, "%s: pm_runtime_resume_and_get failed(%d)\n", __func__,
> > ret); pm_runtime_put_noidle(priv->dev);
> >  		return ret;
> >  	}
> > @@ -1295,15 +1341,83 @@ static int ctucan_get_berr_counter(const struct
> > net_device *ndev, struct can_ber return 0;
> >  }
> >
> > +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +	struct ctucan_priv *priv = netdev_priv(dev);
> > +	struct hwtstamp_config cfg;
> > +
> > +	if (!priv->timestamp_possible)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> > +		return -EFAULT;
> > +
> > +	if (cfg.flags)
> > +		return -EINVAL;
> > +
> > +	if (cfg.rx_filter == HWTSTAMP_FILTER_NONE && cfg.tx_type ==
> > HWTSTAMP_TX_OFF) { +		priv->timestamp_enabled = false;
> > +		return 0;
> > +	} else if (cfg.rx_filter == HWTSTAMP_FILTER_ALL && cfg.tx_type ==
> > HWTSTAMP_TX_ON) { +		priv->timestamp_enabled = true;
> > +		return 0;
> > +	} else {
> > +		return -ERANGE;
> > +	}
> > +}
> > +
> > +static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> > +{
> > +	struct ctucan_priv *priv = netdev_priv(dev);
> > +	struct hwtstamp_config cfg;
> > +
> > +	if (!priv->timestamp_possible)
> > +		return -EOPNOTSUPP;
> > +
> > +	cfg.flags = 0;
> > +	cfg.tx_type = priv->timestamp_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
> > +	cfg.rx_filter = priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL :
> > HWTSTAMP_FILTER_NONE; +
> > +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
> > +}
> > +
> > +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int
> > cmd) +{
> > +	switch (cmd) {
> > +	case SIOCSHWTSTAMP:
> > +		return ctucan_hwtstamp_set(dev, ifr);
> > +	case SIOCGHWTSTAMP:
> > +		return ctucan_hwtstamp_get(dev, ifr);
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +}
> > +
> > +static int ctucan_ethtool_get_ts_info(struct net_device *ndev,
> > +				      struct ethtool_ts_info *info)
> > +{
> > +	struct ctucan_priv *priv = netdev_priv(ndev);
> > +
> > +	if (!priv->timestamp_possible)
> > +		return ethtool_op_get_ts_info(ndev, info);
> > +
> > +	can_ethtool_op_get_ts_info_hwts(ndev, info);
> > +	info->rx_filters |= BIT(HWTSTAMP_FILTER_NONE);
> > +	info->tx_types |= BIT(HWTSTAMP_TX_OFF);
> > +
> > +	return 0;
> > +}
> > +
> >  static const struct net_device_ops ctucan_netdev_ops = {
> >  	.ndo_open	= ctucan_open,
> >  	.ndo_stop	= ctucan_close,
> >  	.ndo_start_xmit	= ctucan_start_xmit,
> >  	.ndo_change_mtu	= can_change_mtu,
> > +	.ndo_eth_ioctl	= ctucan_ioctl,
> >  };
> >
> >  static const struct ethtool_ops ctucan_ethtool_ops = {
> > -	.get_ts_info = ethtool_op_get_ts_info,
> > +	.get_ts_info = ctucan_ethtool_get_ts_info,
> >  };
> >
> >  int ctucan_suspend(struct device *dev)
> > @@ -1338,12 +1452,42 @@ int ctucan_resume(struct device *dev)
> >  }
> >  EXPORT_SYMBOL(ctucan_resume);
> >
> > +int ctucan_runtime_suspend(struct device *dev)
> > +{
> > +	struct net_device *ndev = dev_get_drvdata(dev);
> > +	struct ctucan_priv *priv = netdev_priv(ndev);
> > +
> > +	if (!IS_ERR_OR_NULL(priv->timestamp_clk))
> > +		clk_disable_unprepare(priv->timestamp_clk);
> 
> How is it with the the other common clock used for memory space
> IO bus and CAN bittimmig? 
> 
> +	if (!IS_ERR_OR_NULL(priv->can_clk))
> +		clk_disable_unprepare(priv->can_clk);
> 
> Question is even if there should be prepare or disable
> only.
> 
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ctucan_runtime_suspend);
> > +
> > +int ctucan_runtime_resume(struct device *dev)
> > +{
> > +	struct net_device *ndev = dev_get_drvdata(dev);
> > +	struct ctucan_priv *priv = netdev_priv(ndev);
> > +	int ret;
> > +
> 
> Then equivalent there ???
> 
> +	if (!IS_ERR_OR_NULL(priv->can_clk)) {
> +		ret = clk_prepare_enable(priv->can_clk);
> +		if (ret) {
> +			dev_err(dev, "Cannot enable core clock: %d\n", ret);
> +			return ret;
> +		}
> +	}
> 
> In the general, we have discussion with Marc about possibility unprepared
> and again prepared clocks there could lead to the frequency change
> when some wakeup order etc.. does not correspond to the initial drivers
> and devices enumeration order. This is generic problem and I am not prepared
> to solve and test it in this round. But may it be clock should be only
> disabled over standby or there should be run full recalculation of bitimming
> and even timestamps...
> 
> > +	if (!IS_ERR_OR_NULL(priv->timestamp_clk)) {
> > +		ret = clk_prepare_enable(priv->timestamp_clk);
> > +		if (ret) {
> > +			dev_err(dev, "Cannot enable timestamping clock: %d\n", ret);
> > +			return ret;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ctucan_runtime_resume);
> > +
> >  int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,
> > unsigned int ntxbufs, unsigned long can_clk_rate, int pm_enable_call,
> >  			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
> >  {
> >  	struct ctucan_priv *priv;
> >  	struct net_device *ndev;
> > +	u32 timestamp_freq = 0;
> > +	u32 timestamp_bit_size = 0;
> >  	int ret;
> >
> >  	/* Create a CAN device instance */
> > @@ -1373,6 +1517,7 @@ int ctucan_probe_common(struct device *dev, void
> > __iomem *addr, int irq, unsigne
> >
> >  					| CAN_CTRLMODE_FD_NON_ISO
> >  					| CAN_CTRLMODE_ONE_SHOT;
> >
> >  	priv->mem_base = addr;
> > +	priv->timestamp_possible = true;
> >
> >  	/* Get IRQ for the device */
> >  	ndev->irq = irq;
> > @@ -1386,27 +1531,39 @@ int ctucan_probe_common(struct device *dev, void
> > __iomem *addr, int irq, unsigne
> >
> >  	/* Getting the can_clk info */
> >  	if (!can_clk_rate) {
> > -		priv->can_clk = devm_clk_get(dev, NULL);
> > +		priv->can_clk = devm_clk_get_optional(dev, "core-clk");
> > +		if (!priv->can_clk)
> > +			/* For compatibility with (older) device trees without clock-names */
> > +			priv->can_clk = devm_clk_get(dev, NULL);
> >  		if (IS_ERR(priv->can_clk)) {
> > -			dev_err(dev, "Device clock not found.\n");
> > +			dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
> >  			ret = PTR_ERR(priv->can_clk);
> >  			goto err_free;
> >  		}
> 
> Not problem in our case, FPGA clocks are prepared and running because in another case
> whole AXI, APB etc accesses would stuck the core, but the prepare should be there
> as well??? 
> 
> +		clk_prepare_enable(priv->timestamp_clk);
> 
> >  		can_clk_rate = clk_get_rate(priv->can_clk);
> >  	}
> >
> > +	/* If it's a platform device - get the timestamping clock */
> > +	if (pm_enable_call) {
> > +		priv->timestamp_clk = devm_clk_get(dev, "ts-clk");
> > +		if (IS_ERR(priv->timestamp_clk)) {
> > +			/* Take the core clock instead */
> > +			dev_info(dev, "Failed to get ts clk\nl");
> > +			priv->timestamp_clk = priv->can_clk;
> > +		}
> > +		clk_prepare_enable(priv->timestamp_clk);
> 
> I hope that prepare twice the same clock when "core-clk" is used
> instead of separate "ts-clk" is not problem and that enables and prepares
> are counted.
> 

Seems like it might work, but I should guard it with an 'if' anyways:
if (ts_clk != core_clk && !IS_ERR_OR_NULL(ts_clk))

> > +		timestamp_freq = clk_get_rate(priv->timestamp_clk);
> > +	} else {
> > +		/* PCI device: assume tstamp freq is equal to bus clk rate */
> > +		timestamp_freq = can_clk_rate;
> > +	}
> > +
> >  	priv->write_reg = ctucan_write32_le;
> >  	priv->read_reg = ctucan_read32_le;
> >
> > +	pm_runtime_get_noresume(dev);
> >  	if (pm_enable_call)
> >  		pm_runtime_enable(dev);
> > -	ret = pm_runtime_get_sync(dev);
> > -	if (ret < 0) {
> > -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> > -			   __func__, ret);
> > -		pm_runtime_put_noidle(priv->dev);
> > -		goto err_pmdisable;
> > -	}
> >
> >  	/* Check for big-endianity and set according IO-accessors */
> >  	if ((ctucan_read32(priv, CTUCANFD_DEVICE_ID) & 0xFFFF) != CTUCANFD_ID) {
> > @@ -1425,6 +1582,49 @@ int ctucan_probe_common(struct device *dev, void
> > __iomem *addr, int irq, unsigne
> >
> >  	priv->can.clock.freq = can_clk_rate;
> >
> > +	/* Obtain timestamping counter bit size */
> > +	timestamp_bit_size = FIELD_GET(REG_ERR_CAPT_TS_BITS,
> > +				       ctucan_read32(priv, CTUCANFD_ERR_CAPT));
> > +
> > +	/* The register value is actually bit_size - 1 */
> > +	if (timestamp_bit_size) {
> > +		timestamp_bit_size += 1;
> > +	} else {
> > +		/* For 2.x versions of the IP core, we will assume 64-bit counter
> > +		 * if there was a 0 in the register.
> > +		 */
> > +		u32 version_reg = ctucan_read32(priv, CTUCANFD_DEVICE_ID);
> > +		u32 major = FIELD_GET(REG_DEVICE_ID_VER_MAJOR, version_reg);
> > +
> > +		if (major == 2)
> > +			timestamp_bit_size = 64;
> > +		else
> > +			priv->timestamp_possible = false;
> > +	}
> > +
> > +	/* Setup conversion constants and work delay */
> > +	priv->cc.mask = CYCLECOUNTER_MASK(timestamp_bit_size);
> > +	if (priv->timestamp_possible) {
> > +		u64 max_cycles;
> > +		u64 work_delay_ns;
> > +		u32 maxsec = min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> > +				   div_u64(priv->cc.mask, timestamp_freq));
> > +
> > +		priv->cc.read = ctucan_read_timestamp_cc_wrapper;
> > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> > +				       timestamp_freq, NSEC_PER_SEC, maxsec);
> > +
> > +		/* shortened copy of clocks_calc_max_nsecs() */
> > +		max_cycles = div_u64(ULLONG_MAX, priv->cc.mult);
> > +		max_cycles = min(max_cycles, priv->cc.mask);
> > +		work_delay_ns = clocksource_cyc2ns(max_cycles, priv->cc.mult,
> > +						   priv->cc.shift) >> 1;
> > +		priv->work_delay_jiffies = nsecs_to_jiffies(work_delay_ns);
> > +
> > +		if (priv->work_delay_jiffies == 0)
> > +			priv->timestamp_possible = false;
> > +	}
> > +
> >  	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
> >
> >  	ret = register_candev(ndev);
> > @@ -1442,7 +1642,6 @@ int ctucan_probe_common(struct device *dev, void
> > __iomem *addr, int irq, unsigne
> >
> >  err_deviceoff:
> >  	pm_runtime_put(priv->dev);
> > -err_pmdisable:
> >  	if (pm_enable_call)
> >  		pm_runtime_disable(dev);
> >  err_free:
> 
> 
> How is this in the driver remove?
> 
> The device managed devm_clk_get takes care about clock release
> (clk_put)
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/clk/clk-devres.c#L12  
> 
> But I expect that clk_put does not take care about disable
> and unprepare which has to be in ballance to the calls inside probe.
> 
> We probably will need something like
> 
> int ctucan_remove_common(struct ctucan_priv *priv)
> 
> with
> 
> 	if (!IS_ERR_OR_NULL(priv->timestamp_clk))
> 		clk_disable_unprepare(priv->timestamp_clk);
> 
> 	if (!IS_ERR_OR_NULL(priv->can_clk))
> 		clk_disable_unprepare(priv->can_clk);
> 
> 
> called from the both
> 
>   ctucan_platform_remove(struct platform_device *pdev)
>   ctucan_pci_remove(struct pci_dev *pdev)
> 

Hmm, good catch, thank you.
Maybe instead of some common remove function, I would put in
ctucanfd_platform_remove():
	if (pm_runtime_enabled(pdev->dev))
		pm_runtime_disable(pdev->dev);
		// assuming pm_runtime_disable automagically calls the
		// runtime_suspend callback
	else
		{... disable_unprepare clocks ...};
and in ctucanfd_pci_remove() call disable_unprepare only for the
timestamping clock.

> > diff --git a/drivers/net/can/ctucanfd/ctucanfd_pci.c
> > b/drivers/net/can/ctucanfd/ctucanfd_pci.c index 8f2956a8ae43..bdb7cf789776
> > 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
> > @@ -271,7 +271,10 @@ static void ctucan_pci_remove(struct pci_dev *pdev)
> >  	kfree(bdata);
> >  }
> >
> > -static SIMPLE_DEV_PM_OPS(ctucan_pci_pm_ops, ctucan_suspend,
> > ctucan_resume); +static const struct dev_pm_ops ctucan_pci_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
> > +	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
> > +};
> >
> >  static const struct pci_device_id ctucan_pci_tbl[] = {
> >  	{PCI_DEVICE_DATA(TEDIA, CTUCAN_VER21,
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> > b/drivers/net/can/ctucanfd/ctucanfd_platform.c index
> > 89d54c2151e1..1b2052aec2ab 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> > @@ -104,7 +104,10 @@ static int ctucan_platform_remove(struct
> > platform_device *pdev) return 0;
> >  }
> >
> > -static SIMPLE_DEV_PM_OPS(ctucan_platform_pm_ops, ctucan_suspend,
> > ctucan_resume); +static const struct dev_pm_ops ctucan_platform_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
> > +	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
> > +};
> >
> >  /* Match table for OF platform binding */
> >  static const struct of_device_id ctucan_of_match[] = {
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> > b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c new file mode 100644
> > index 000000000000..77e461d1962d
> > --- /dev/null
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> > @@ -0,0 +1,70 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*************************************************************************
> >****** + *
> > + * CTU CAN FD IP Core
> > + *
> > + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE
> > CTU + *
> > + * Project advisors:
> > + *     Jiri Novak <jnovak@fel.cvut.cz>
> > + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> > + *
> > + * Department of Measurement         (http://meas.fel.cvut.cz/)
> > + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> > + * Czech Technical University        (http://www.cvut.cz/)
> > +
> > ***************************************************************************
> >***/ +
> > +#include "linux/spinlock.h"
> > +#include <linux/bitops.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/math64.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/workqueue.h>
> > +
> > +#include "ctucanfd.h"
> > +#include "ctucanfd_kregs.h"
> > +
> > +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc)
> > +{
> > +	struct ctucan_priv *priv;
> > +
> > +	priv = container_of(cc, struct ctucan_priv, cc);
> > +	return ctucan_read_timestamp_counter(priv);
> > +}
> > +
> > +static void ctucan_timestamp_work(struct work_struct *work)
> > +{
> > +	struct delayed_work *delayed_work = to_delayed_work(work);
> > +	struct ctucan_priv *priv = container_of(delayed_work, struct ctucan_priv,
> > timestamp); +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&priv->tc_lock, flags);
> > +	timecounter_read(&priv->tc);
> > +	spin_unlock_irqrestore(&priv->tc_lock, flags);
> > +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> > +}
> > +
> > +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff
> > *skb, u64 timestamp) +{
> > +	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
> > +	u64 ns;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&priv->tc_lock, flags);
> > +	ns = timecounter_cyc2time(&priv->tc, timestamp);
> > +	spin_unlock_irqrestore(&priv->tc_lock, flags);
> > +	hwtstamps->hwtstamp = ns_to_ktime(ns);
> > +}
> > +
> > +void ctucan_timestamp_init(struct ctucan_priv *priv)
> > +{
> > +	spin_lock_init(&priv->tc_lock);
> > +	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
> > +	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
> > +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> > +}
> > +
> > +void ctucan_timestamp_stop(struct ctucan_priv *priv)
> > +{
> > +	cancel_delayed_work_sync(&priv->timestamp);
> > +}
> 
> Best wishes and thanks for suggestions and review
> in advance,
> 
> 
>                 Pavel
> 
> -- 
>                 Pavel Pisa
>     phone:      +420 603531357
>     e-mail:     pisa@cmp.felk.cvut.cz
>     Department of Control Engineering FEE CVUT
>     Karlovo namesti 13, 121 35, Prague 2
>     university: http://control.fel.cvut.cz/
>     personal:   http://cmp.felk.cvut.cz/~pisa
>     projects:   https://www.openhub.net/accounts/ppisa
>     CAN related:http://canbus.pages.fel.cvut.cz/
>     RISC-V education: https://comparch.edu.cvut.cz/
>     Open Technologies Research Education and Exchange Services
>     https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home
> 
