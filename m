Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A7C2ABDFD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbgKIN7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbgKIN7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:59:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEFCC0613CF;
        Mon,  9 Nov 2020 05:59:16 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604930354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gx1dZtY4s40fZGpLWlgSmlwGQXS2k49I1CpAIoGxYi0=;
        b=N2tTi6nXOFn22gACX1XPBavm5cxHI2att4A3QQkY/T0dqYe/TMrs9v50whSIg0/JLvvfJJ
        cWDXtHzcRXenYPeNDiH7AfnTpDHMZQPqkzs5nhuyR+Hph5PWuFGFmnUoUPgKWZKhL4PJZ2
        Mb0Nrt0bQCOhMkdrRFyZ9f9kqCnM9KrmOgkFu3VHfI+3POA78JK3yivnH1InwpihB0SD4+
        uRvTIrbfqY3SsI3DA9SP0RvS5LZa9rWoY32TgEO4TFM7C+mCa1xG9RuoE6t/WO0OW7a124
        y3jwHUFkSlwI7crqhLYZthNP53Tcq4kjinaKhW+hGUmsgVaZmim7bjNmW7Cbsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604930354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gx1dZtY4s40fZGpLWlgSmlwGQXS2k49I1CpAIoGxYi0=;
        b=7+tVPw+tiV+trCg5Kx0Cs5rR0HIodWU8Tfionl4H3D7pnMJBcc08TUWq9riekfCxbfBegD
        0I6NG+3DbXev3eBw==
To:     Colin Ian King <colin.king@canonical.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        ivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: re: net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <7c4b526c-b229-acdf-d22a-2bf4a206be5b@canonical.com>
References: <7c4b526c-b229-acdf-d22a-2bf4a206be5b@canonical.com>
Date:   Mon, 09 Nov 2020 14:59:13 +0100
Message-ID: <87v9eer5qm.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Colin,

On Mon Nov 09 2020, Colin Ian King wrote:
> Hi
>
> Static analysis on linux-next with Coverity has detected a potential
> null pointer dereference issue on the following commit:
>
> commit f0d4ba9eff75a79fccb7793f4d9f12303d458603
> Author: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
> Date:   Tue Nov 3 08:10:58 2020 +0100
>
>     net: dsa: hellcreek: Add support for hardware timestamping
>
> The analysis is as follows:
>
> 323                /* Get nanoseconds from ptp packet */
> 324                type = SKB_PTP_TYPE(skb);
>
>    4. returned_null: ptp_parse_header returns NULL (checked 10 out of 12
> times).
>    5. var_assigned: Assigning: hdr = NULL return value from
> ptp_parse_header.
>
> 325                hdr  = ptp_parse_header(skb, type);
>
>    Dereference null return value (NULL_RETURNS)
>    6. dereference: Dereferencing a pointer that might be NULL hdr when
> calling hellcreek_get_reserved_field.
>
> 326                ns   = hellcreek_get_reserved_field(hdr);
> 327                hellcreek_clear_reserved_field(hdr);
>
> This issue can only occur if the type & PTP_CLASS_PMASK is not one of
> PTP_CLASS_IPV4, PTP_CLASS_IPV6 or PTP_CLASS_L2.  I'm not sure if this is
> a possibility or not, but I'm assuming that it would be useful to
> perform the null check just in case, but I'm not sure how this affects
> the hw timestamping code in this function.

I don't see how the null pointer dereference could happen. That's the
Rx path you showed above.

The counter part code is:

hellcreek_port_rxtstamp:

	/* Make sure the message is a PTP message that needs to be timestamped
	 * and the interaction with the HW timestamping is enabled. If not, stop
	 * here
	 */
	hdr = hellcreek_should_tstamp(hellcreek, port, skb, type);
	if (!hdr)
		return false;

	SKB_PTP_TYPE(skb) = type;

Here the type is stored and hellcreek_should_tstamp() also calls
ptp_parse_header() internally. Only when ptp_parse_header() didn't
return NULL the first time the timestamping continues. It should be
safe.

Also the error handling would be interesting at that point. What should
happen if the header is null then? Returning an invalid timestamp?
Ignore it?

Hm. I think we have to make sure that it is a valid ptp packet before
reaching this code and that's what we've implemented. So, I guess it's
OK.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+pSzEACgkQeSpbgcuY
8KZ8EBAAm/4dgOrAeBt+h1tsagNnblF2Vida2GZ8a9QdSyx/VQGNY9Rhs8qWNmFL
tGUguEzb42oE4qwXO+d5j4KTbl2XyDY6d27/L2ysuq+dWVTPSTNfGimgtdeG8/42
/oShPfDf1pfNN4V9pxIWbcTCY+boqO2xN1JeCa4ukgDvKZ5jLRNfR5H1hjDA5LOY
sKADTTaRrEfXnmWcc8rYjEXhTqvEuun8ec4AGRRNSkhMqs61cdZH19dMTROrzKx1
IViapTg4Hm9OCe8yH3nlH2DJA4oLu8Vu8gWmjPlwM5KL9p5kjhjo/vaPTcjtYqbq
+aszNsBtVYwcnw4jkn/jbBoHljY1CwSYNY6hzrZ1cZnXksCnVULQoQf42XP0i8YB
oQjgwpWFDkdfW7vOkJIffONC6dJZzztiIW+iLek6/evh7pnflJ0QvZkaoNkdxb5g
DMKFNrbCP/bjTO0k7MLNkGRL9zESX4m5XohOyHpMN+qdA1qmqsJzMjRmZc0oJ6mE
WoRkHbO776rHFE0vXraga4GFCgWOMIpqGaqejqDeK4dj7/4pUIp6Jd8AYhPSIIxJ
cn9cbWGG1sA6vOclqP5vOSJ/mPsF7MYLcM67ocVgYDNKP0HXk/TFPC/Ov6UyG8sa
fUx4/jnq4lokp/bluVpEdFGSQ7SN1qbY7KP7l7EZoj1I9xXlwz0=
=wkcn
-----END PGP SIGNATURE-----
--=-=-=--
