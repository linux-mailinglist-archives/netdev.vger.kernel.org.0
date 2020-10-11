Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D59328A759
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 14:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387828AbgJKM3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 08:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387744AbgJKM3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 08:29:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24307C0613CE;
        Sun, 11 Oct 2020 05:29:15 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602419352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJdfEiY4PfN/AFpvryhGU/5LSIFVk3RfEZa1/Sumoe4=;
        b=bO+F2xe02c1f7d8lSe+vg0IynY4IcWkuwQltUf0m8vBr9/YRdV48u/PsCr8wRJ8hidUoID
        k1pnA6X8TbYxD2z3mS538Aa8cUzXx5Go2cvmTc68udVg+yV6MPO/VC32QRXDcPkjmB3XZe
        /Gb3lD3A12/EVTxZmHSN4NQRRnNQhnZCJjCeNOhWcxdpLV2WjWxBUvmAwI8NCGcr1Oa1Qk
        XTG8aGQHHbTd/n9FTakCZ1F/N8hoN0z/Rt2Bv1KlIlF3dkPVX+LPzY648i2AxQspQY518I
        58spl23CIlDMbyy/NiSSy62a8JOFdzhFcBxPAdZatCvEMp3r8hsCb48MVQoxiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602419352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJdfEiY4PfN/AFpvryhGU/5LSIFVk3RfEZa1/Sumoe4=;
        b=3EWsKYr1tmKSqW2zf/7zx/SkPRqLInhX95082zDmQxsmuUJlPGHqEERUuRKUWbh7Wv2MMf
        ORmlpy8if2aBBJBA==
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
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201006135631.73rm3gka7r7krwca@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf>
Date:   Sun, 11 Oct 2020 14:29:08 +0200
Message-ID: <87362lt08b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 03:23:36PM +0200, Kurt Kanzenbach wrote:
>> So you're saying private VLANs can be used but the user or the other
>> kernel modules shouldn't be allowed to use them to simplify the
>> implementation?  Makes sense to me.
>
> It would be interesting to see if you could simply turn off VLAN
> awareness in standalone mode, and still use unique pvids per port.

That doesn't work, just tested. When VLAN awareness is disabled,
everything is switched regardless of VLAN tags and table. Therefore, the
implementation could look like this:

 * bridge without filtering:
   * vlan_awareness=0
   * drop private vlans
 * bridge with vlan filtering:
   * vlan_awareness=1
   * drop private vlans
 * standalone:
   * vlan_awareness=1
   * use private vlans
   * forbid other users to use private vlans to allow
     configure_vlans_while_not_filtering behavior in .vlan_prepare()
   * forbid use of lan0.<X> and lan1.<X> in .port_prechangeupper()

So, this should work, or?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+C+pQACgkQeSpbgcuY
8KaOhQ/+LUNWORnLGdWaAt9Bxg+UNEUCDGMNKl7XkzEOD9Ew6RFPIKGZCh8bt782
56t8msbcwFyHehAELJOdpOX5wGmhfSGjDjtxN0D/QnSiWKs/qZ+VhwC8EX+bmmfZ
fq/Sw2gzcu8xWM9gPcsoTBMfosNP2HPIUwVG0VCzzLRT6tRLXIA7DyYArrXdNPWv
NVC+b3Rf2c/nBGW6ayaaPk7yIJZKH6rNctGdL7HCL857px2yINZU8xlkiMyvGxeh
asapR6YWqblqFhM6CUaXhh0xFOAuTwZGh1MIqjrJ+BZ0mQrTvANYFzIboT+8SfYi
WCeUhLGr/9YG1t/jw4yjvN5UkKhdQFgniqVbuZQvnOFy9OrmQP7mVx01ysSrzxQa
pgQc26LCEhaIfC2XRWTuAHcaq07CxWZ72XPyKnbzxLyJgM2qTzvoErBJ12rgbwlr
rUbXbqzYepR1MlvR/3am+aK6YeQW+EloCtgWKtWlFgsVvscKfIUGJ+bzylJo2zbH
LimrYkHwRAwoItWSsgJO6km0qJp4NttPDZaxf5jrVnOMfEbFS9SSU0TdFkv1Yscw
qAaybIunOh2NVqaC7viU79v4x8TSgzCsr6U3irygZ/ItD7gZwhvaqC7qnYk/02jr
VKnzthgRkqHkVNvtgsdLJeyxUxn8JVex/Dpoa3vR2mOkBAkgidE=
=iNiJ
-----END PGP SIGNATURE-----
--=-=-=--
