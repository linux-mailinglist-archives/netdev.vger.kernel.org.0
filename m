Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69301363BE4
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhDSGrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:47:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhDSGrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 02:47:05 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618814794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qXQLGERhsSNeIwqSxvWOuT357Vy3ZJhmHq0+8ZCeYcc=;
        b=pPii5bN9MwHpzibsWOaN/JQEYaLDuLXw8jrKabJy4RtMt4LZ2+R3sMCrnEXHp3Ez1BqS06
        ka7zL9xK5q7REX5n5a5za3A0vt3ovBkgZ8OGLw7BQlQfbJ6CPJWymI5uJvl9q8Z5Zg0LZY
        qe6c7XFv/1aSf+SDmHGOrOkvkYKAX7Ziv2f9Q7xlSlzUyfp0JqG6Ym6L2wI3ue0EqVYZpI
        jsMNp/AMuduxYYNRVHvg1zXvN3cizxzpZy36RMfw8gjJSjuOiwo6AebJeYBmyrjVuF+akW
        CYmCp2+sKqStCtJaBTNO6CSAjO4ItOYwpI0/E62/kLIclIvXPQ8ORe+tEd4Xjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618814794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qXQLGERhsSNeIwqSxvWOuT357Vy3ZJhmHq0+8ZCeYcc=;
        b=arsPGNtl1GtiP4AXseM/lEYzZ9mbyMPldbujH4Mf0NFPFrpyu98yi4CjQDpa8H0FVkK8+R
        JoC9CcefFtZ8mzCA==
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/3] net: dsa: optimize tx timestamp request handling
In-Reply-To: <20210416123655.42783-2-yangbo.lu@nxp.com>
References: <20210416123655.42783-1-yangbo.lu@nxp.com> <20210416123655.42783-2-yangbo.lu@nxp.com>
Date:   Mon, 19 Apr 2021 08:46:33 +0200
Message-ID: <87k0oyzs8m.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Apr 16 2021, Yangbo Lu wrote:
> Optimization could be done on dsa_skb_tx_timestamp(), and dsa device
> drivers should adapt to it.
>
> - Check SKBTX_HW_TSTAMP request flag at the very beginning, instead of in
>   port_txtstamp, so that most skbs not requiring tx timestamp just return.
>
> - No longer to identify PTP packets, and limit tx timestamping only for PTP
>   packets. If device driver likes, let device driver do.
>
> - It is a waste to clone skb directly in dsa_skb_tx_timestamp().
>   For one-step timestamping, a clone is not needed. For any failure of
>   port_txtstamp (this may usually happen), the skb clone has to be freed.
>   So put skb cloning into port_txtstamp where it really needs.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

PTP still works.

Tested-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmB9J0kACgkQeSpbgcuY
8KZ8txAAnfpbhXSCEuUfR4ACDZwTqdlJxqHz1GE6AIuKLCcK6G1HuTLRN4f/Vjcq
JKIZAJWN+OMSuAx4OrHqMaE79mlYxsd10gWybHoHbBliTWZt2QCMjpZ3kcqpgYHk
QCWOAuuFq1DNENqRS+BL47W86OlhaPns37BAW+O8+4j3QxPfHAL2aYOlq9DZgEVP
5klbziOUS4Dg0Mvxc6k7gtm/ecJMZGG6PdvVnWRv9rllvTBsgJi4TrpXt/maZF7Y
I1vsc8g755sXe6ds6EpppUsyXALVLv+/5ABGU+q5HvY5lXVTw4x3ohUmtG3+PLaq
eH7cNBKrFuU5yvQupWOG3Fq5KA5d4WdD7izhBNYWyTxCnXsc6g4oUgsj/+Y/f48+
BtM3/mWJuYPIW4IL0JJP4OtB/OtTPrIfMyUFlNgwhc1NtQaojOS4KRhlkGLgjNeF
oOSWt2c/CLAyq13VkubQAsFOP3/ro2fKqCUQ+fdr7w6ovRPywqlvDJKIF0gQ9dSI
0+XMkN1dhlpwrkyd8AyB4tcEaI8QgIBj7DILZSPNjXXbsIm8wMfnztPXJZEjM/Z0
ND9ET4vCIB6SxW3ctZdF0sICB8qEjnNNuJzQ1QEeNjK8ZUOizY9ijxLxwsNIFzs8
+RanrIUm043DUOcz6iPVr1h9myLlvMpI9qnxbiFtv7iKlui9vbs=
=5c3T
-----END PGP SIGNATURE-----
--=-=-=--
