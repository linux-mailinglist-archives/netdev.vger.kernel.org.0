Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B1F1192F
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfEBMdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:33:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52163 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfEBMdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 08:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hIZ2r4SHmJaCkF2EdisXrrWwKAQXEwuZvn4QXzFxD7w=; b=zJCC6NV/LulBNFOyb7zANwOp7f
        2OjqNtVlSchdm8gSp8kJaAcCM+qtp5Cv+n4jZKNZUaWYtUVazU7MzLbfMSUMZDBlQuV+rdMSpPRiD
        MNI2CCar4Z/sWrAmBsfc1rZ4lgXhxtHQiaOStuqOtze/dYdAL/rnKQJ81TGhwghncOl8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hMAtJ-00087U-Bv; Thu, 02 May 2019 14:32:45 +0200
Date:   Thu, 2 May 2019 14:32:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: mscc: ocelot: Implement port policers
 via tc command
Message-ID: <20190502123245.GB9844@lunn.ch>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-3-joergen.andreasen@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502094029.22526-3-joergen.andreasen@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joergen

> +
> +#define MSCC_RC(expr)				\
> +	do {					\
> +		int __rc__ = (expr);		\
> +		if (__rc__ < 0)			\
> +			return __rc__;		\
> +	}					\
> +	while (0)

I'm sure checkpatch warned about this. A return inside a macros is a
bad idea. I inherited code doing this, and broke it when adding
locking, because it was not obvious there was a return.

> +
> +/* The following two functions do the same as in iproute2 */
> +#define TIME_UNITS_PER_SEC	1000000
> +static unsigned int tc_core_tick2time(unsigned int tick)
> +{
> +	return (tick * (u32)PSCHED_TICKS2NS(1)) / 1000;
> +}
> +
> +static unsigned int tc_calc_xmitsize(u64 rate, unsigned int ticks)
> +{
> +	return div_u64(rate * tc_core_tick2time(ticks), TIME_UNITS_PER_SEC);
> +}

Should these but put somewhere others can use them?

> +
> +enum mscc_qos_rate_mode {
> +	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
> +	MSCC_QOS_RATE_MODE_LINE, /* Measure line rate in kbps incl. IPG */
> +	MSCC_QOS_RATE_MODE_DATA, /* Measures data rate in kbps excl. IPG */
> +	MSCC_QOS_RATE_MODE_FRAME, /* Measures frame rate in fps */
> +	__MSCC_QOS_RATE_MODE_END,
> +	NUM_MSCC_QOS_RATE_MODE = __MSCC_QOS_RATE_MODE_END,
> +	MSCC_QOS_RATE_MODE_MAX = __MSCC_QOS_RATE_MODE_END - 1,
> +};
> +
> +/* Round x divided by y to nearest integer. x and y are integers */
> +#define MSCC_ROUNDING_DIVISION(x, y) (((x) + ((y) / 2)) / (y))

linux/kernel.h defines DIV_ROUND_UP(). Maybe add DIV_ROUND_DOWN()?

> +
> +/* Round x divided by y to nearest higher integer. x and y are integers */
> +#define MSCC_DIV_ROUND_UP(x, y) (((x) + (y) - 1) / (y))

DIV_ROUND_UP() ?

> +	/* Limit to maximum values */
> +	pir = min_t(u32, GENMASK(15, 0), pir);
> +	cir = min_t(u32, GENMASK(15, 0), cir);
> +	pbs = min_t(u32, pbs_max, pbs);
> +	cbs = min_t(u32, cbs_max, cbs);

If it does need to limit, maybe return -EOPNOTSUPP?

> +int ocelot_port_policer_add(struct ocelot_port *port,
> +			    struct tcf_police *p)
> +{
> +	struct ocelot *ocelot = port->ocelot;
> +	struct qos_policer_conf pp;
> +
> +	if (!p)
> +		return -EINVAL;
> +
> +	netdev_dbg(port->dev,
> +		   "result %d ewma_rate %u burst %lld mtu %u mtu_pktoks %lld\n",
> +		   p->params->tcfp_result,
> +		   p->params->tcfp_ewma_rate,
> +		   p->params->tcfp_burst,
> +		   p->params->tcfp_mtu,
> +		   p->params->tcfp_mtu_ptoks);
> +
> +	if (p->params->rate_present)
> +		netdev_dbg(port->dev,
> +			   "rate: rate %llu mult %u over %u link %u shift %u\n",
> +			   p->params->rate.rate_bytes_ps,
> +			   p->params->rate.mult,
> +			   p->params->rate.overhead,
> +			   p->params->rate.linklayer,
> +			   p->params->rate.shift);
> +
> +	if (p->params->peak_present)
> +		netdev_dbg(port->dev,
> +			   "peak: rate %llu mult %u over %u link %u shift %u\n",
> +			   p->params->peak.rate_bytes_ps,
> +			   p->params->peak.mult,
> +			   p->params->peak.overhead,
> +			   p->params->peak.linklayer,
> +			   p->params->peak.shift);
> +
> +	memset(&pp, 0, sizeof(pp));

Rather than memset, you can do:

	struct qos_policer_conf pp = { 0 };

	Andrew
