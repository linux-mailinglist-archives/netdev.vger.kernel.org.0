Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2335F6E8EC9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjDTKBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbjDTKBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:01:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5455C10E3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:01:36 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ppR6F-0003P8-0I; Thu, 20 Apr 2023 12:01:11 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C903A1B3D36;
        Thu, 20 Apr 2023 10:01:07 +0000 (UTC)
Date:   Thu, 20 Apr 2023 12:01:07 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] dt-bindings: net: can: Make interrupt attributes
 optional for MCAN
Message-ID: <20230420-zoom-demystify-c31d6bf25295-mkl@pengutronix.de>
References: <20230419223323.20384-1-jm@ti.com>
 <20230419223323.20384-3-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o65i4erlcrvj4ggl"
Content-Disposition: inline
In-Reply-To: <20230419223323.20384-3-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--o65i4erlcrvj4ggl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.04.2023 17:33:21, Judith Mendez wrote:
> For MCAN, remove interrupt and interrupt names from the required
> section.
>=20
> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
> routed to A53 Linux, instead they will use software interrupt
> by hrtimer. Make interrupt attributes optional in MCAN node
> by removing from required section.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>

This series basically adds polling support to the driver, which is
needed due to HW limitations.

The proposed logic in the driver is to use polling if
platform_get_irq_byname() fails (due to whatever reason) use polling
with a hard-coded interval.

In the kernel I've found the following properties that describe the
polling interval:

bindings/input/input.yaml:

|   poll-interval:
|     description: Poll interval time in milliseconds.
|     $ref: /schemas/types.yaml#/definitions/uint32


bindings/thermal/thermal-zones.yaml:

|       polling-delay:
|         $ref: /schemas/types.yaml#/definitions/uint32
|         description:
|           The maximum number of milliseconds to wait between polls when
|           checking this thermal zone. Setting this to 0 disables the poll=
ing
|           timers setup by the thermal framework and assumes that the ther=
mal
|           sensors in this zone support interrupts.

bindings/regulator/dlg,da9121.yaml

|   dlg,irq-polling-delay-passive-ms:
|     minimum: 1000
|     maximum: 10000
|     description: |
|       Specify the polling period, measured in milliseconds, between inter=
rupt status
|       update checks. Range 1000-10000 ms.

=46rom my point of view the poll-interval from the input subsystem looks
good. Any objections to use it to specify the polling interval for
IRQ-less devices, too?

> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b=
/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 67879aab623b..43f1aa9addc0 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -122,8 +122,6 @@ required:
>    - compatible
>    - reg
>    - reg-names
> -  - interrupts
> -  - interrupt-names
>    - clocks
>    - clock-names
>    - bosch,mram-cfg
> --=20
> 2.17.1
>=20
>=20

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--o65i4erlcrvj4ggl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRBDWAACgkQvlAcSiqK
BOgXTQf/a2tgk8HJj9aGY01UCY7qxZI15vq+GQKZTz2NdrdOQvE7dor75W3b4Nsr
XXfwCNcz+sZYKc4AyM82uELkd1hY9nZ4GDyv2Vy/3+z3lTqY9jU0poapxCxnY4CQ
zNT05yiZA8THyUWTlAOvLICvCDRw4BswbMigvavw/0uWls6KbegRsP4+aMcs9snd
vhDNK8Ab/vmpKjVxVo/Vkaf/B8bq7UkmyOXsbwYEeTHqjfTGQwZcWvg0YZ1svvyS
haxZ3+T5AccASnr2aztH8Ke6UZvHczoQTlRJpByUo3soZGy4BXaOdk18WjT+lzpZ
vdy5RYmDDQiJ1DK+sQaI/oDEWGAeUQ==
=LuRH
-----END PGP SIGNATURE-----

--o65i4erlcrvj4ggl--
