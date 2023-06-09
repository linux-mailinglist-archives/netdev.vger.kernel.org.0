Return-Path: <netdev+bounces-9606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E7972A02E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B9B22819B6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7241A200D7;
	Fri,  9 Jun 2023 16:27:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8B19509
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:27:57 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF263C07;
	Fri,  9 Jun 2023 09:27:36 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686328055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bau/fUGOJLojWM3PE7bfcAQ0rkMC2s1G9G3cfSaF4L0=;
	b=Kbhq8KZIWGVcAwb6A6dYRpKK0bvPTypTfwGWnD1I323xMebBWp5AuhPHzsSSJQj4KSYyvv
	9cmB7zfqHf1SHFgIMEn4GS/++058bQdegDXJuSpEn88OAKbyZdTs89ZdNUKYnmq2vm9dD5
	f1bY9oL3tmcYCARJo8vOIJVIagmwG49ohv5IkmgyFjmqreKFj3bzrwKxexettxWwggoBWw
	9i8ad2dbc3T2maLtRkwUwEaTgwLNozxZcmKpddyXGui7j1Fc/cKSlEHMJyFeWeg0t5ieTU
	4ufCEQGmSGTGGbom0JBEdP/3MTqiXg72B+11NRFRwCUKSvXbvjAu/YrIPtjErA==
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
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8D29820004;
	Fri,  9 Jun 2023 16:27:33 +0000 (UTC)
Message-ID: <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com>
Date: Fri, 9 Jun 2023 18:27:57 +0200
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
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, paul.arola@telus.com,
 scott.roberts@telus.com
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
Content-Language: en-US
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andrew, thanks for the review,

On 6/9/23 16:53, Andrew Lunn wrote:
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
>> +
>> +	/* Switch supports only max rate configuration. There is no
>> +	 * configurable burst/max size nor latency.
> 
> Can you return -EOPNOTSUPP if these values are not 0? That should make
> it clear to the user they are not supported.

Yes, I can do that (or maybe -EINVAL to match Vladimir's comment ?). I think
it's worth mentioning that I encountered an issue regarding those values during
tests: I use tc program to set the tbf, and I observed that tc does not even
reach kernel to set the qdisc if we pass no burst/latency value OR if we set it
to 0. So tc enforces right on userspace side non-zero value for those
parameters, and I have passed random values and ignored them on kernel side.
Checking available doc about tc-tbf makes me feel like that indeed a TBF qdisc
command without burst or latency value makes no sense, except my use case can
not have such values. That's what I struggled a bit to find a proper qdisc to
match hardware cap. I may fallback to a custom netlink program to improve testing.
> 
>>  /* Offset 0x09: Egress Rate Control */
>> -#define MV88E6XXX_PORT_EGRESS_RATE_CTL1		0x09
>> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1				0x09
>> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_64_KBPS		0x1E84
>> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_1_MBPS		0x01F4
>> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_10_MBPS		0x0032
>> +#define MV88E6XXX_PORT_EGRESS_RATE_CTL1_STEP_100_MBPS		0x0005
>> +#define MV88E6XXXw_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT	8
> 
> Are they above values specific to the 6393? Or will they also work for
> other families? You use the MV88E6XXX prefix which means they should
> be generic across all devices.

I have no idea about EGRESS_RATE_CTL1 and EGRESSE_RATE_CTL2 registers layout or
features for other switches supported in mv88e6xxx, and it is likely risky to
assume it is identical, so indeed I will rename those defines to make them
specific to 6393 (+ nasty typo in
MV88E6XXXw_PORT_EGRESS_RATE_CTL1_FRAME_OVERHEAD_SHIFT)

Thanks,
Alexis

> 
> 	Andrew

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


