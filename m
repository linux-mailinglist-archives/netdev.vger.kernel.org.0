Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA5529114B
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 12:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437162AbgJQKG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 06:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437116AbgJQKG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 06:06:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202FC061755;
        Sat, 17 Oct 2020 03:06:26 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602929184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Jpx06sdw7AFizQi916UteqhwbQ8BMSqlX+F+TFC5Dg=;
        b=GuDiwuamGcQ4z+FegCCRIgYjuZze8HKBWZKIwDuSlrth7laeica3Tp67LkvcD2RYlL6Gl2
        +Szx/xV/2R8W6LIkFVpePFoVYjCC7wb3cfJU9CQlPqMTmL4w1k5TOVsFUqeCoKZuT/kawW
        564lcTQ/rebzHgRfFfaJZBQ98S51R0qz8Q7r8BWWK/mjlZ9BmyzjPIJdgVx/Suae/QNY+K
        S/UrjjoirEEC8V7AtPJMuJKDTOS/B0cxNPIOz+gjAkISfL2PG6/DjQ8N2v9X88MwlTOoHW
        pse5UNZO5RgJ26boO7BQxMqX/baspb80u3e0z41Xk/v7FOYS12fUn9Tsu2vtZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602929184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Jpx06sdw7AFizQi916UteqhwbQ8BMSqlX+F+TFC5Dg=;
        b=T4qUt18gVsPvRtfDs/J5WvczHQ+c4dvk4Vjg9MKkoRLk8EsOIIJV79dNx2RXqpzebEfJLa
        4yyb0obyVxpbsdAQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <6cf8acc5-a6aa-5e77-f0a3-09d7d7af1a82@gmail.com>
References: <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf> <87362lt08b.fsf@kurt> <20201011153055.gottyzqv4hv3qaxv@skbuf> <87r1q4f1hq.fsf@kurt> <87sgaee5gl.fsf@kurt> <20201016154336.s2acp5auctn2zzis@skbuf> <6cf8acc5-a6aa-5e77-f0a3-09d7d7af1a82@gmail.com>
Date:   Sat, 17 Oct 2020 12:06:21 +0200
Message-ID: <87eelxp3oi.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Oct 16 2020, Florian Fainelli wrote:
> I probably missed parts of this long discussion, but for this generation
> of switches, does that mean that you will only allow a bridge with
> vlan_filtering=1 to be configured and also refuse toggling of
> vlan_filtering at run time?

Nope. To sum up the driver will use "private" VLANs for the port
separation. That will lead to certain restrictions. These are:

 * Private VLANs cannot be used by the user or other kernel modules (one
   per port)
 * Mixed vlan_filtering bridges are not supported, as there's only a
   global VLAN awareness flag (ds->vlan_filtering_is_global)
 * vlan_filtering=0 bridges and having standalone ports is not
   supported
 * Same VLANs on top of standalone ports such as lan0.100 and lan1.100
   will break port separation and are also not supported

Most of these restrictions are not important at the moment, because
there are only two user ports. Either they're in a bridge or not. The
"mixed" cases are interesting.

However, as Vladimir suggested, I'll point these limitation to the hw
engineers when they start to develop these switches with more than two
user ports.

Hope that summary makes it clear.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+Kwh0ACgkQeSpbgcuY
8KYAdA/+JVD9ZiPLNgUEC9P+vmirCd2eN8h4dzbj4zKfwVyZdXNlsgq289F+74gk
VxJwrJ5F3qfOEtt3ozmcwUjOgP/TQroNfVD6XLxSHTZTGQTwBQd1UUr0tazFoFkv
6Os/CcuvHasUfaAllmEFpkhqJiaPPEi5LafJmYY87WSzIva9/JdtO2+UJC3+Ohgq
UiB5CwaiowiFBnsb5oC8T/UQUSAuP/OAVH1Kooj+Sl4640snNbHmqj0mE59jnP77
qpd8dPH3GSf7VLMuFQZWf+59BStjooeVWJH8KCY4uvKTrHdlFMSfvrrcGbQ9IReQ
HT9uVOFugbNP2DEr20BN7NZXvW5Swpng7hagv9jQwKv53PZRU31REA5LOVSY6bgL
qX4BIX5AW7Ux5xlvJcKzK8c1u2gc1eBpeRM/a83/sTse8k/DJ818xF9nJt0xCi/i
s9v2yeXVo0lv9otP9VQBXsg93RwZWrSjjoBJvSs6LlVlFWeRSOa91ucm5+yZsm0n
MswZ/aTcDQqYvZGtVa9u4AJXgV4a+fBABx1U+IbPMPUHmHm/BD7iz2+eb07WpC+D
a+f8O60Cu/r+HW77XixlB/qxHmvT4gGFu+Y+7IItIhE6GSKd/3A0url0Rwzit9t6
On7tct5+b69zc7Lyv+umSWZ8FOXiIs1hX/JXBxnuUaLtYB5CG3s=
=/5aX
-----END PGP SIGNATURE-----
--=-=-=--
