Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B9251545
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgHYJYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:24:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48256 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHYJYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:24:02 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598347438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRNKMEQGP/oxKMIBwg2FMgejXTXp0qu327EEThRhFoU=;
        b=m+RehNr2luN8m/xEougOS1ofSnMT+WtSW/4Cvj8iTkiZcp2BMqtrpDP2UzQtZy9W1916ex
        IDxYtRcKfLhexK2BeiWtPUkPipb/rQ3Q/mjtyuHsEA47GkT8w8rtXu/lBL9WNKFgnwlhU+
        oHGFu6DtP2MSYvCkDfrH5m7ExLCajv5gKu8oZZt+SQ18m9Joq3x6fEach+B4YbMFLD9zZ5
        rnSieUaenCKiMsfNVsUS9nppPk8sCNiEx76kbNq8bBkwe60dwoYajkAGfBlK/7pdgtZRiD
        j/hFUgPvSLNZF6GV/sPfA4ZPbTJnN+ZPbuCVjTr5M1XxmkEqt55aBNQUpQszcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598347438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRNKMEQGP/oxKMIBwg2FMgejXTXp0qu327EEThRhFoU=;
        b=rozxMcs0LnO6Yb4Bpx8jojLFZOQKkwQlkMzAmgBMpQ1/qkn1mmMSg6RQ9L4GTellRmwJoy
        /mmEZkrdwRjGncCw==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <87pn7ftx6b.fsf@intel.com>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <87pn7ftx6b.fsf@intel.com>
Date:   Tue, 25 Aug 2020 11:23:56 +0200
Message-ID: <87bliz13kj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Aug 24 2020, Vinicius Costa Gomes wrote:
> Hi,
>
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
[snip]
>> +	/* Setup timer for schedule switch: The IP core only allows to set a
>> +	 * cycle start timer 8 seconds in the future. This is why we setup the
>> +	 * hritmer to base_time - 5 seconds. Then, we have enough time to
>> +	 * activate IP core's EST timer.
>> +	 */
>> +	start = ktime_sub_ns(schedule->base_time, (u64)5 * NSEC_PER_SEC);
>> +	hrtimer_start_range_ns(&hellcreek_port->cycle_start_timer, start,
>> +			       NSEC_PER_SEC, HRTIMER_MODE_ABS);
>
> If we are talking about seconds here, I don't think you need to use a
> hrtimer, you could use a workqueue/delayed_work. Should make things a
> bit simpler.

I've used hrtimers for one reason: The hrtimer provides a way to fire at
an absolute base time based on CLOCK_TAI. All the other facilities such
as workqueues, timer list timers, etc do not.

In the typical setup, we run ptp4l as boundary clock (or as TAB which is
work in progress) and phc2sys to synchronize the ptp clock to the Linux
system. Let's assume we setup a TAPRIO schedule with a base time X. Now,
the grand master time changes meaning the timer has to go off earlier or
later.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E2KwACgkQeSpbgcuY
8KZI1hAAxZyBTPvX3bOspeP4+mTNo1MOcA5ebZrtgulz4qjSjElJ4qWF1/YO+BBe
In4z0AKaydFU7jJQLvVV1bkhusxmnjgQDF4tPi4z+IuY+OANJcNoARPWrRLWhUW5
Bqy2XbOsS4dFiq3HFrG248N5zr0pp9pqhvQmhoNoMzTF8vw/y8IogkRn2H8vrPpZ
K7TfOtPi4t1N8R4bOG7PT1H8KxP6mDNp2tH3ZBObbqhsJu7K1vDb25FnZl1yRkEt
DDJLm//1gM4Kabd1F0CgCHIaV8FvQ5X3QIBC8f8JtElpJIO6nh43nDsiQkuQWgaO
TXwm6FIDCM2PUValKCaUet1GvX+KSCLQg6GUX3j6itJJeElINZFqTdmKwNsbrQzN
jLqW8YYU7aBYUyV1+8zNv4KMSbossoKZ9GrYYdGwMKKEBL0RRCNFgMhccWFK1Zw4
5MdII5cdNl4KSsM6IQ0XfUOlyUaQuPYySEP5Kpqzf6NW9fcFVCwV/97EUOOfhQKO
Jk7hOCI8+ANWf8UqD+pS7HRlaHd7E2V++ScS2ivN93bphdtYPVFtWdhg9VkqgXQR
NmerMw8OosflJFnTL0EZxD19+j8t042Uy4n9PrXThzGxwUm4sVXu8l6zhTjpXMrg
0cTLP23Rq62eAXZUxpDH9Tr79snC4m0xv/mAX0/kiEeuODffRac=
=0oB8
-----END PGP SIGNATURE-----
--=-=-=--
