Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F78112C49
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 13:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfECLXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 07:23:51 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:6979 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfECLXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 07:23:50 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,425,1549954800"; 
   d="scan'208";a="29952556"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 May 2019 04:23:50 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch07.mchp-main.com
 (10.10.76.108) with Microsoft SMTP Server id 14.3.352.0; Fri, 3 May 2019
 04:23:29 -0700
Date:   Fri, 3 May 2019 13:23:28 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "James Hogan" <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
Subject: Re: [PATCH net-next 2/3] net: mscc: ocelot: Implement port policers
 via tc command
Message-ID: <20190503112327.he2unkak7rhm6ajk@soft-dev16>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-3-joergen.andreasen@microchip.com>
 <20190502123245.GB9844@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190502123245.GB9844@lunn.ch>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The 05/02/2019 14:32, Andrew Lunn wrote:
> External E-Mail
> 
> 
> Hi Joergen
> 
> > +
> > +#define MSCC_RC(expr)				\
> > +	do {					\
> > +		int __rc__ = (expr);		\
> > +		if (__rc__ < 0)			\
> > +			return __rc__;		\
> > +	}					\
> > +	while (0)
> 
> I'm sure checkpatch warned about this. A return inside a macros is a
> bad idea. I inherited code doing this, and broke it when adding
> locking, because it was not obvious there was a return.
>

I saw the warning but I assumed that it wasn't a problem in this small context.
The macro will be removed in v2.

> > +
> > +/* The following two functions do the same as in iproute2 */
> > +#define TIME_UNITS_PER_SEC	1000000
> > +static unsigned int tc_core_tick2time(unsigned int tick)
> > +{
> > +	return (tick * (u32)PSCHED_TICKS2NS(1)) / 1000;
> > +}
> > +
> > +static unsigned int tc_calc_xmitsize(u64 rate, unsigned int ticks)
> > +{
> > +	return div_u64(rate * tc_core_tick2time(ticks), TIME_UNITS_PER_SEC);
> > +}
> 
> Should these but put somewhere others can use them?
>

It would be nice to put them in a more public place, but I am in doubt where to
put them and what to call them.

Maybe they belong in the new file: include/net/tc_act/tc_police.h.
Would that be ok?

> > +
> > +enum mscc_qos_rate_mode {
> > +	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
> > +	MSCC_QOS_RATE_MODE_LINE, /* Measure line rate in kbps incl. IPG */
> > +	MSCC_QOS_RATE_MODE_DATA, /* Measures data rate in kbps excl. IPG */
> > +	MSCC_QOS_RATE_MODE_FRAME, /* Measures frame rate in fps */
> > +	__MSCC_QOS_RATE_MODE_END,
> > +	NUM_MSCC_QOS_RATE_MODE = __MSCC_QOS_RATE_MODE_END,
> > +	MSCC_QOS_RATE_MODE_MAX = __MSCC_QOS_RATE_MODE_END - 1,
> > +};
> > +
> > +/* Round x divided by y to nearest integer. x and y are integers */
> > +#define MSCC_ROUNDING_DIVISION(x, y) (((x) + ((y) / 2)) / (y))
> 
> linux/kernel.h defines DIV_ROUND_UP(). Maybe add DIV_ROUND_DOWN()?
>

This macro is currently not used and I will remove it in v2.

> > +
> > +/* Round x divided by y to nearest higher integer. x and y are integers */
> > +#define MSCC_DIV_ROUND_UP(x, y) (((x) + (y) - 1) / (y))
> 
> DIV_ROUND_UP() ?
>

I will use DIV_ROUND_UP() in v2.

> > +	/* Limit to maximum values */
> > +	pir = min_t(u32, GENMASK(15, 0), pir);
> > +	cir = min_t(u32, GENMASK(15, 0), cir);
> > +	pbs = min_t(u32, pbs_max, pbs);
> > +	cbs = min_t(u32, cbs_max, cbs);
> 
> If it does need to limit, maybe return -EOPNOTSUPP?
>

It seems fine to return -EOPBITSUPP here.
I will do that in v2.

> > +int ocelot_port_policer_add(struct ocelot_port *port,
> > +			    struct tcf_police *p)
> > +{
> > +	struct ocelot *ocelot = port->ocelot;
> > +	struct qos_policer_conf pp;
> > +
> > +	if (!p)
> > +		return -EINVAL;
> > +
> > +	netdev_dbg(port->dev,
> > +		   "result %d ewma_rate %u burst %lld mtu %u mtu_pktoks %lld\n",
> > +		   p->params->tcfp_result,
> > +		   p->params->tcfp_ewma_rate,
> > +		   p->params->tcfp_burst,
> > +		   p->params->tcfp_mtu,
> > +		   p->params->tcfp_mtu_ptoks);
> > +
> > +	if (p->params->rate_present)
> > +		netdev_dbg(port->dev,
> > +			   "rate: rate %llu mult %u over %u link %u shift %u\n",
> > +			   p->params->rate.rate_bytes_ps,
> > +			   p->params->rate.mult,
> > +			   p->params->rate.overhead,
> > +			   p->params->rate.linklayer,
> > +			   p->params->rate.shift);
> > +
> > +	if (p->params->peak_present)
> > +		netdev_dbg(port->dev,
> > +			   "peak: rate %llu mult %u over %u link %u shift %u\n",
> > +			   p->params->peak.rate_bytes_ps,
> > +			   p->params->peak.mult,
> > +			   p->params->peak.overhead,
> > +			   p->params->peak.linklayer,
> > +			   p->params->peak.shift);
> > +
> > +	memset(&pp, 0, sizeof(pp));
> 
> Rather than memset, you can do:
> 
> 	struct qos_policer_conf pp = { 0 };
>

I will do as you suggest in v2.

> 	Andrew
> 

-- 
Joergen Andreasen, Microchip
