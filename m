Return-Path: <netdev+bounces-9605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF1272A02B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 071642819A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA69200CE;
	Fri,  9 Jun 2023 16:27:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C419509
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:27:51 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246933AB1;
	Fri,  9 Jun 2023 09:27:25 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686328044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3zUqH0qaNcKfB3fn4Ga2+WqqZ6TvHzReJVMUaOXjOyY=;
	b=Bkoinid12OBg/0k/Ja+YAFM8fbn0wbBDY4Y30w6KU7gufROQs+6DoG3Aq7ffjQYc8NLhtv
	+ftUlEN+lQkYA0UlBcvzHZh4D8qTzpz0bkopCa4wFb9SfIKrYcymLgNsmFxUHzc/oO/2//
	KCxcdsz047IgfVEDM8qW8V+XJ2jX64Icac31hzhQ1Y+eqrbYSHk47eGces9TsEkBKEmrM0
	d0U2XgY8eUqdD3SjqVYZnHDKW2GsyhRl4m3CMfI7TL3kNjJHgwidv43Tl81BZY6j4BbpjS
	8018w1zC0oodiIfL8TKAs5ToKOZ9YUVJlsB6IEfB3kdG5KLD09Yplo+UPNux1w==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 51A6040005;
	Fri,  9 Jun 2023 16:27:23 +0000 (UTC)
Message-ID: <2c11201b-9cb5-cbf1-a53b-559dd6ab331e@bootlin.com>
Date: Fri, 9 Jun 2023 18:27:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, paul.arola@telus.com,
 scott.roberts@telus.com
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <20230609145727.qt6qvyoheepstpz7@skbuf>
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <20230609145727.qt6qvyoheepstpz7@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vladimir, thanks for the feedback,

On 6/9/23 16:57, Vladimir Oltean wrote:
> On Fri, Jun 09, 2023 at 04:18:12PM +0200, alexis.lothore@bootlin.com wrote:
>> +int mv88e6393x_tbf_add(struct mv88e6xxx_chip *chip, int port,
>> +		       struct tc_tbf_qopt_offload_replace_params *replace_params)
>> +{
>> +	int rate_kbps = DIV_ROUND_UP(replace_params->rate.rate_bytes_ps * 8, 1000);
>> +	int overhead = DIV_ROUND_UP(replace_params->rate.overhead, 4);
>> +	int rate_step, decrement_rate, err;
>> +	u16 val;
>> +
>> +	if (rate_kbps < MV88E6393X_PORT_EGRESS_RATE_MIN_KBPS ||
>> +	    rate_kbps >= MV88E6393X_PORT_EGRESS_RATE_MAX_KBPS)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (replace_params->rate.overhead > MV88E6393X_PORT_EGRESS_MAX_OVERHEAD)
>> +		return -EOPNOTSUPP;
> 
> How does tbf react to the driver returning -EOPNOTSUPP? I see tbf_offload_change()
> returns void and doesn't check the ndo_setup_tc() return code.
> 
> Should we resolve that so that the error code is propagated to the user?

Indeed, checking some other TC Qdisc, some reports ndo_setup_tc errors (htb,
taprio, ...) to caller, some others do not (red, ets...). I can give it a try
and see the impact
> 
> Also, it would be nice to extend struct tc_tbf_qopt_offload with a
> netlink extack, for the driver to state exactly the reason for the
> offload failure.

ACK, I will add the extack struct

> 
> Not sure if EOPNOTSUPP is the return code to use here for range checks,
> rather than ERANGE.

I was not sure about proper error codes on all those checks. Since all those
errors are about what hardware can handle/can not handle, I felt like EOPNOTSUPP
was the most relevant one. But indeed it may make more sense for user to get
ERANGE here, I will update accordingly
>> +
>> +	/* Switch supports only max rate configuration. There is no
>> +	 * configurable burst/max size nor latency.
>> +	 * Formula defining registers value is:
>> +	 * EgressRate = 8 * EgressDec / (16ns * desired Rate)
>> +	 * EgressRate is a set of fixed values depending of targeted range
>> +	 */
>> +	if (rate_kbps < MBPS_TO_KBPS(1)) {
>> +		decrement_rate = rate_kbps / 64;
>> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS;
>> +	} else if (rate_kbps < MBPS_TO_KBPS(100)) {
>> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(1);
>> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS;
>> +	} else if (rate_kbps < GBPS_TO_KBPS(1)) {
>> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(10);
>> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS;
>> +	} else {
>> +		decrement_rate = rate_kbps / MBPS_TO_KBPS(100);
>> +		rate_step = MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS;
>> +	}
>> +
>> +	dev_dbg(chip->dev, "p%d: adding egress tbf qdisc with %dkbps rate",
>> +		port, rate_kbps);
>> +	val = decrement_rate;
>> +	val |= (overhead << MV88E6XXX_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT);
>> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
>> +				   val);
>> +	if (err)
>> +		return err;
>> +
>> +	val = rate_step;
>> +	/* Configure mode to bits per second mode, on layer 1 */
>> +	val |= MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_L1_BYTES;
>> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
>> +				   val);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +int mv88e6393x_tbf_del(struct mv88e6xxx_chip *chip, int port)
>> +{
>> +	int err;
>> +
>> +	dev_dbg(chip->dev, "p%d: removing tbf qdisc", port);
>> +	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
>> +				   0x0000);
>> +	if (err)
>> +		return err;
>> +	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
>> +				    0x0001);
> 
> I guess this should return void and proceed on errors, rather than exit early.
> Maybe shout out loud that things went wrong.

ACK

> 
>> +}
>> +
>> +static int mv88e6393x_tc_setup_qdisc_tbf(struct mv88e6xxx_chip *chip, int port,
>> +					 struct tc_tbf_qopt_offload *qopt)
>> +{
>> +	/* Device only supports per-port egress rate limiting */
>> +	if (qopt->parent != TC_H_ROOT)
>> +		return -EOPNOTSUPP;
>> +
>> +	switch (qopt->command) {
>> +	case TC_TBF_REPLACE:
>> +		return mv88e6393x_tbf_add(chip, port, &qopt->replace_params);
>> +	case TC_TBF_DESTROY:
>> +		return mv88e6393x_tbf_del(chip, port);
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	return -EOPNOTSUPP;
>> +}

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


