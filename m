Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5885660D6F7
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiJYWXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiJYWXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:23:35 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7277558A;
        Tue, 25 Oct 2022 15:23:32 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc24b.ko.seznam.cz (email-smtpc24b.ko.seznam.cz [10.53.18.33])
        id 757841dd91d492e374a5e0b3;
        Wed, 26 Oct 2022 00:22:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1666736562; bh=6GDtThpj3NN+LEEr3gicdW2ugccmoKw5NTQ1pWky2/A=;
        h=Received:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
        b=Qlmj0TV32seBqamYRxJ2A94bpCLO8ZRwPiGtRNxbscYV/tR2tJT+s4UGk6+GDi4qv
         L1OdsQ/fXVnNIgWQRf31Bl3WeUMXQZaC33Ns7Dp5CfXjpl4hApKeg8hjfdBeAH7S57
         rFGr7rWr77pEEZpu5lTamQ75f/swUihAZGf1sirU=
Received: from hopium (2a02:8308:900d:2600:d7fc:ccab:3140:290d [2a02:8308:900d:2600:d7fc:ccab:3140:290d])
        by email-relay5.ng.seznam.cz (Seznam SMTPD 1.3.138) with ESMTP;
        Wed, 26 Oct 2022 00:22:39 +0200 (CEST)  
Date:   Wed, 26 Oct 2022 00:22:37 +0200
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
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
Subject: Re: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20221025222237.GA4635@hopium>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
 <20221024200238.tgqkjjyagklglshu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024200238.tgqkjjyagklglshu@pengutronix.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,
thanks for another review from you.
I'll merge the responses for all three mails from you, so I don't spam
the mailing list too much.

On Mon, Oct 24, 2022 at 10:02:38PM +0200, Marc Kleine-Budde wrote:
> On 12.10.2022 08:25:56, Matej Vasilevski wrote:
> > This patch adds support for retrieving hardware timestamps to RX and
> 
> Later in the code you set struct ethtool_ts_info::tx_types but the
> driver doesn't set TX timestamps, does it?
> 

No, it doesn't explicitly. Unless something changed and I don't know about it,
all the drivers using can_put_echo_skb() (includes ctucanfd) now report
software (hardware if available) tx timestamps thanks to Vincent's patch.
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?id=12a18d79dc14c80b358dbd26461614b97f2ea4a6

> > error CAN frames. It uses timecounter and cyclecounter structures,
> > because the timestamping counter width depends on the IP core integration
> > (it might not always be 64-bit).
> > For platform devices, you should specify "ts" clock in device tree.
> > For PCI devices, the timestamping frequency is assumed to be the same
> > as bus frequency.
> > 
> > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> 
> [...]
> 
> > diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
> > index b8da15ea6ad9..079819d53e23 100644
> > --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> > +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> 
> [...]
> 
> > @@ -950,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, int quota)
> >  			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
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
> > @@ -1230,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
> >  		goto err_chip_start;
> >  	}
> >  
> > +	if (priv->timestamp_possible)
> > +		ctucan_timestamp_init(priv);
> > +
> 
> This is racy. You have to init the timestamping before the start of the
> chip, i.e. enabling the IRQs. I had the same problem with the gs_usb
> driver:
> 
> | https://lore.kernel.org/all/20220921081329.385509-1-mkl@pengutronix.de

Thanks for pointing this out, I'll fix this.

> 
> >  	netdev_info(ndev, "ctu_can_fd device registered\n");
> >  	napi_enable(&priv->napi);
> >  	netif_start_queue(ndev);
> > @@ -1262,6 +1306,8 @@ static int ctucan_close(struct net_device *ndev)
> >  	ctucan_chip_stop(ndev);
> >  	free_irq(ndev->irq, ndev);
> >  	close_candev(ndev);
> > +	if (priv->timestamp_possible)
> > +		ctucan_timestamp_stop(priv);
> 
> Can you make this symmetric with respect to the ctucan_open() function.

Yes, will do.

> >  
> >  	pm_runtime_put(priv->dev);
> >  
> > @@ -1294,15 +1340,88 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
> >  	return 0;
> >  }
> 
> [...]
> 
> > @@ -1385,15 +1534,29 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
> >  
> >  	/* Getting the can_clk info */
> >  	if (!can_clk_rate) {
> > -		priv->can_clk = devm_clk_get(dev, NULL);
> > +		priv->can_clk = devm_clk_get_optional(dev, "core");
> > +		if (!priv->can_clk)
> > +			/* For compatibility with (older) device trees without clock-names */
> > +			priv->can_clk = devm_clk_get(dev, NULL);
> >  		if (IS_ERR(priv->can_clk)) {
> > -			dev_err(dev, "Device clock not found.\n");
> > +			dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
> >  			ret = PTR_ERR(priv->can_clk);
> >  			goto err_free;
> >  		}
> >  		can_clk_rate = clk_get_rate(priv->can_clk);
> >  	}
> >  
> > +	if (!timestamp_clk_rate) {
> > +		priv->timestamp_clk = devm_clk_get(dev, "ts");
> > +		if (IS_ERR(priv->timestamp_clk)) {
> > +			/* Take the core clock instead */
> > +			dev_info(dev, "Failed to get ts clk\n");
> > +			priv->timestamp_clk = priv->can_clk;
> > +		}
> > +		clk_prepare_enable(priv->timestamp_clk);
> > +		timestamp_clk_rate = clk_get_rate(priv->timestamp_clk);
> > +	}
> > +
> >  	priv->write_reg = ctucan_write32_le;
> >  	priv->read_reg = ctucan_read32_le;
> >  
> > @@ -1424,6 +1587,50 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
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
> > +	if (priv->timestamp_possible) {
> > +		u64 max_cycles;
> > +		u64 work_delay_ns;
> > +		u32 maxsec;
> > +
> > +		priv->cc.read = ctucan_read_timestamp_cc_wrapper;
> > +		priv->cc.mask = CYCLECOUNTER_MASK(timestamp_bit_size);
> > +		maxsec = min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> > +			       div_u64(priv->cc.mask, timestamp_clk_rate));
> > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> > +				       timestamp_clk_rate, NSEC_PER_SEC, maxsec);
> > +
> > +		/* shortened copy of clocks_calc_max_nsecs() */
> > +		max_cycles = div_u64(ULLONG_MAX, priv->cc.mult);
> > +		max_cycles = min(max_cycles, priv->cc.mask);
> > +		work_delay_ns = clocksource_cyc2ns(max_cycles, priv->cc.mult,
> > +						   priv->cc.shift) >> 2;
> 
> I think we can use cyclecounter_cyc2ns() for this, see:
> 
> | https://elixir.bootlin.com/linux/v6.0.3/source/drivers/net/ethernet/ti/cpts.c#L642
> 
> BTW: This is the only networking driver using clocks_calc_mult_shift()
> (so far) :D
> 

I don't really see the benefit at the moment (I have to include
clocksource.h anyway due to the clocks_calc_mult_shift()), but sure,
I'll use cyclecounter_cyc2ns().

Fun fact :-D I might look into the cpts.c

> > +		priv->work_delay_jiffies = nsecs_to_jiffies(work_delay_ns);
> > +
> > +		if (priv->work_delay_jiffies == 0)
> > +			priv->timestamp_possible = false;
> > +	}
> > +
> 
> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

Mail 2:
>Regarding the timestamp_clk handling:
>
>If you prepare_enable the timestamp_clk during probe_common() and don't
>disable_unprepare it, it stays on the whole lifetime of the driver. So
>there's no need/reason for the runtime suspend/resume functions.
>
>So either keep the clock powered and remove the suspend/resume functions
>or shut down the clock after probe.
>
>If you want to make things 1000% clean, you can get the timestamp's
>clock rate during open() and re-calculate the mult and shift. The
>background is that the clock rate might change if the clock is not
>enabled (at least that's not guaranteed by the common clock framework).
>Actual HW implementations might differ.

Hmm, I thought that pm_runtime_put() will eventually run runtime suspend
callback, but now I see that it will run only the idle callback (which
I haven't defined).
I'll remove the runtime suspend/resume callbacks.

Best regards,
Matej
