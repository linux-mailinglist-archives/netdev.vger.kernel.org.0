Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F09144BC00
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 08:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhKJHRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 02:17:23 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41084 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhKJHRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 02:17:22 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636528474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QYI7QecjnuG6GfxdL7j/OK7s1zjdjd+JXdxf/Anwd28=;
        b=JA+pnNN5pl09aLxL29MEYniyA8Xu1rTX+7i2DAzB5jI+Hsgp3Rnzr2wGEmD+N0ZKl07yND
        +POpOSGP226y+NiBgA+9fqZ6VhilXkGwW5mBBPMn55GP6XCNcxIcGAq56Ws3PkR4P/E+TN
        996vQo2zx/m+nh1IQbhTWXFg8T+QSXM7tncXFV6S6gl6T1Z3nyYhjYQpIhlQkPAAx03Bng
        qJrpsR8WcqCBs4WakzxS5srdMVL+XscV2lKrPm4cv5WAEY7TIo/JUDSd9po7XYhUWcZvsU
        ayaMhB6B0ZH1+OyH3JdB23E0aXJ499z6BeE8QYb1OX5rDQsYlVameOSkV011JA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636528474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QYI7QecjnuG6GfxdL7j/OK7s1zjdjd+JXdxf/Anwd28=;
        b=PlZUDTvGnYFz8eGYw1Kd/4NWTm6ysons3+Fay8IdiFO2RtvhiQGY6UmazJQTfSy9q59Y00
        d0j9Z13e027C8ZDQ==
To:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
In-Reply-To: <20211109111213.6vo5swdhxjvgmyjt@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-7-martin.kaistra@linutronix.de>
 <20211109111213.6vo5swdhxjvgmyjt@skbuf>
Date:   Wed, 10 Nov 2021 08:14:32 +0100
Message-ID: <87ee7o8otj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Tue Nov 09 2021, Vladimir Oltean wrote:
>> +void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
>> +{
>> +	struct b53_device *dev = ds->priv;
>> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
>> +	struct sk_buff *clone;
>> +	unsigned int type;
>> +
>> +	type = ptp_classify_raw(skb);
>> +
>> +	if (type != PTP_CLASS_V2_L2)
>> +		return;
>> +
>> +	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
>> +		return;
>> +
>> +	clone = skb_clone_sk(skb);
>> +	if (!clone)
>> +		return;
>> +
>> +	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
>
> Is it ok if you simply don't timestamp a second skb which may be sent
> while the first one is in flight, I wonder? What PTP profiles have you
> tested with? At just one PTP packet at a time, the switch isn't giving
> you a lot.

PTP only generates a couple of messages per second which need to be
timestamped. Therefore, this behavior shouldn't be a problem.

hellcreek (and mv88e6xxx) do the same thing, simply because the device
can only hold only one Tx timestamp. If we'd allow more than one PTP
packet in flight, there will be correlation problems. I've tested with
default and gPTP profile without any problems. What PTP profiles do have
in mind?

> Is it a hardware limitation?

Not for the b53. It will generate status frames for each to be
timestamped packet. However, I don't see the need to allow more than one
Tx packet per port to be timestamped at the moment.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGLcVgTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpohmD/9Fi3OzBODMKAMtxu4MdAKbvJaeHAqD
a/6agx8SRMlt0nJ7bw52jAoD6ky1WPaAgpmr4iYvwLqp5yTwAa7V1jMxC82PaxUp
DEo9E3HuTZiQD9s+w0UYE6JDcvG88QvZbRPvBc8k1r4vUTG13giPe6dYh8bAXmqB
A+fpvH1o24dNG2IstdSdkbQvj4oK5nkTxXx6q72dx2eZ8Ong+tI2Jor5htu+qBHZ
PdYU466Z2ov3KGd5Ne0zTZE4zDUEPJan5TeJoCy37zAjQSWj3VLeF2/MwoOZBGjk
e92jimwtWWi2knpaBR60NA6PL1qx9oztbzB0n9/jLKkYu7W0y201Hw/KDdz5r80D
RoIQ6c5z5e1GZztr4280dsFfGeL/rRph0sGiUMtKH7SXJOaU78bKa5P4BTGs6DQb
lNewiEMoTnP6to7pb0iVDlky1rafX/yu4kDrjHXaN0lLtxDqDzYvB74d1ExUoxog
opvhJr6UVCyt9wo+IYlheET5zjbMFRuS7L/NGismf7LwzBKogfzTrEIxjHieF0+m
Xi29P1SWNCOlH9TGMd3Sd48txcJVXX4mv7JLGtQ0gUF4h09M2wHHVa7WUsyB3zRT
G/K+1yicIt9T1VvkBRzRU4ggHPUbkBsuUacpRLcaxEggUwdD1vxBmBUOv17uHC1Q
bbEeE4JSnePfAg==
=JRT5
-----END PGP SIGNATURE-----
--=-=-=--
