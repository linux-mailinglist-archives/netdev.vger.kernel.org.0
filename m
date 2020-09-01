Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F0F2590FE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgIAOnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgIAOQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:16:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C28C061247;
        Tue,  1 Sep 2020 07:05:46 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598969144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z8QqyLda18GvzgzEa2BZRAqbRhiaUAxD4HcskwEK9y8=;
        b=OA/2WXHYfEL1UR/++jUzmCJejoAGIwlRpnMjkUSVgubq1FeRHr3OfZ9USQ1gE/CI5PT7Lj
        RQoIowDNkgN2P3pGTSOfIn/h1ejWaWrGDqhrIiJRW8d2O63VzqJ3Zv27hezntXkpSjpwUo
        mzXh2yi8rhhOx7j//aop9Z2O4794QHgiG6XvfTUhXZ+3mLcD2JdGee4KzM+hUfvshbu383
        9re5Ckx1XS2hN9v0blaNStaXIjoZ5QeC9vzCGYVMPiuaVJqoDSSKw7Snx3Y+9B3/01cqNI
        MPtCGDjI+6cboSqfFLsZtHFgP6DKpc+QKFYLNPnT09e9HoEuWyYgH8O6Wx8GWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598969144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z8QqyLda18GvzgzEa2BZRAqbRhiaUAxD4HcskwEK9y8=;
        b=VfTHIMCqtnFBoB0HPkuNE5jEiWNFnb6IXieWGVDnItFZKuERS7C5XshV7FxiY73RqYCouS
        SEgC49JeOGSoU0Cg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200901134020.53vob6fis5af7nig@skbuf>
References: <20200901125014.17801-1-kurt@linutronix.de> <20200901125014.17801-3-kurt@linutronix.de> <20200901134020.53vob6fis5af7nig@skbuf>
Date:   Tue, 01 Sep 2020 16:05:42 +0200
Message-ID: <87y2ltegnd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Tue Sep 01 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Tue, Sep 01, 2020 at 02:50:09PM +0200, Kurt Kanzenbach wrote:
[snip]
>> +struct hellcreek {
>> +	const struct hellcreek_platform_data *pdata;
>> +	struct device *dev;
>> +	struct dsa_switch *ds;
>> +	struct hellcreek_port *ports;
>> +	struct mutex reg_lock;	/* Switch IP register lock */
>
> Pardon me asking, but I went back through the previous review comments
> and I didn't see this being asked.

It was asked multiple times, why there was a spinlock without interrupts
being registered (see e.g. [1], [2]). I've used the spinlock variant,
because the previously used hrtimers act like interrupts. As there are
no timers anymore, there's no need for spinlocks and mutexes can be
used.

Florian Fainelli also asked if the reg lock can be removed
completely. See below.

>
> What is the register lock protecting against, exactly?

A lot of the register operations work by:

 * Select port, priority, vlan or counter
 * Configure it

These sequences have to be atomic. That's what I wanted to ensure.

Thanks,
Kurt

[1] - https://lkml.kernel.org/netdev/def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com/
[2] - https://lkml.kernel.org/netdev/20200624130318.GD7247@localhost/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9OVTYACgkQeSpbgcuY
8KZR9A//fUpNGkg2ivJeRvLXtvr4FbLG0ASFeE+pyc9dVBWa1RY+yP6H0fpOP9jR
jlPqYVUlqxtiqlwHOd8GJ/PbnBlmKHcdf8BKnbM75fffeJjZm3Y+cl+CFJwJXkGe
sKWFxGzQVbNmUsblEUWVOpuiU8XRRD8RjPCxMBW8FC5bVbhMKK1Fw7AT5K5M2e+d
J3hhEa3qHsIqTSQhcb27N5Z94C6k9oKcRpkyTECngcX1IfNqcit6+OY7h5u4lqLz
RVva3j1+tQJk7TgDWG+emcY5T7dpmnC2EgquPh3fs/peF1rfNswO2QqleFM8NHkI
1nHanLeutnkIrs5sGPHU5VM9Cb3ctnLIAQh/VpB5cUdAXfDSN/qJvlTo/ATN4rBM
3eL9dslrMt1dBXMteI4YMBj/CMHnQOP2HE0V2AXgAs4MRUn5ZWPInap/MCUMCWQC
L0sOgb4Ye5k8uJH8dNS5j+sPqI6oeRBeTyZixLe9uTLdbH74o7nGpN4TGlQvpO04
OZ2vvDwoyRKVnYqsbYySZo7b6phqK5nUmDzzZRuGZKW9b/q0WWxCbJYgIjSBUVhU
h/JrGFrnZ2uQ6B/VhbS0E5moFHob92uItlwFVl9tH81jn64cDg2Z4gI2E9WUNve6
enD+VGtnu4+BLbZ4a6wM6mmO9m2GdXaId6sKBQzs4nVvDC4AOHk=
=Ww3M
-----END PGP SIGNATURE-----
--=-=-=--
