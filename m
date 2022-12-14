Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344FB64C82F
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 12:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbiLNLkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 06:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiLNLkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 06:40:14 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E7FE87
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:40:09 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ud5so43835675ejc.4
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pA2Qc1TKP9+xwTKN23fg8F02GKaPyU8IlVAB1N0ATTg=;
        b=P/h+lKYEtw8lSVgE9FUjk7IEHFagJBDiutxlE78hP70N3O3yiDKrEmm+/ALk5kt9cw
         6C0N2r6iEgffKcp1s4/1wwezBfWZxdg6hN44WMjoILJfVmuH8GGidAKwvQw7X1VW5+yz
         KHdeFedmp8yy0/0HHvU1iXLLSreJJ3Ttay7SHDL5xNLrQDbcAYGpt2iARSB6gf7unk/A
         AA5HFRz5ZRBmMjfIB4hln3pmSIJI28RSf6zwnX5WhbljTqdg5g5v/lmarrL8KPfbS2uy
         ydNW5cWT+diXjXpmOcST8aX/8TsxlT5rCLHljDkEZ8lI/jKXSzs3wMIuMu+JGqYeFX93
         hMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pA2Qc1TKP9+xwTKN23fg8F02GKaPyU8IlVAB1N0ATTg=;
        b=qcFk/CuSa9k1eF/Kwdg6Za9YRWbULRC9UIvqgvEU3LU24eAe8CN3RCT1xm49YACbgc
         17H7XY0tMy1/kCpumssu1jdK/Nw9xNN+Hm9+KaPmqBZDLuN7yShFzHmikfqLyV/myVhg
         m66yhTB6MZImL+oReEQ/ljg/gCPe1EiwpfzQrtXPEQ+QgGAqm4IgLu9SgyrrflrIFWLd
         OZbNPOD57Qo4PvZJHzfScl++q3iifH9EbenYOa/nCze28Gyx1O4Dtc7qjTo2WgjAQiYa
         oeqfoQEr0jZbgrfKkyjHLlNzUymEfHyBMYj3BgyDQpggoJCa+Z1Y/TKdZQBGWvKdZ1XR
         nPOA==
X-Gm-Message-State: ANoB5pndq9xl0S8tiYby0PmoMxXszzFpxHKHxalfRo7VvajsGZ+I1Emp
        MYp/bPh9R++pV6jOkmJXFVqhdyWQGBK4TqXWkGs=
X-Google-Smtp-Source: AA0mqf6LJmgm4ta/c9jaM4tDCXvPYGP4W0gJ/NjyMYPiCjN0UGRSPWxcfOFEK5HDUkwNwvP+/1ayoHOf0tf/nrCAzOo=
X-Received: by 2002:a17:907:728c:b0:7c1:10cf:b81c with SMTP id
 dt12-20020a170907728c00b007c110cfb81cmr9224412ejc.315.1671018007366; Wed, 14
 Dec 2022 03:40:07 -0800 (PST)
MIME-Version: 1.0
References: <20221214110120.3368472-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221214110120.3368472-1-vladimir.oltean@nxp.com>
From:   Maxim Kiselev <bigunclemax@gmail.com>
Date:   Wed, 14 Dec 2022 14:39:55 +0300
Message-ID: <CALHCpMjB1SuK2sTRO3beaT2om6Td5YhAYVdBzps97Gi8Q3omHw@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: cc1049ccee20 ("net: dsa: mv88e6xxx: fix speed setting for CPU/DSA =
ports")
> Reported-by: Maksim Kiselev <bigunclemax@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Maksim Kiselev <bigunclemax@gmail.com>

=D1=81=D1=80, 14 =D0=B4=D0=B5=D0=BA. 2022 =D0=B3. =D0=B2 14:01, Vladimir Ol=
tean <vladimir.oltean@nxp.com>:
>
> In the blamed commit, it was not noticed that one implementation of
> chip->info->ops->phylink_get_caps(), called by mv88e6xxx_get_caps(),
> may access hardware registers, and in doing so, it takes the
> mv88e6xxx_reg_lock(). Namely, this is mv88e6352_phylink_get_caps().
>
> This is a problem because mv88e6xxx_get_caps(), apart from being
> a top-level function (method invoked by dsa_switch_ops), is now also
> directly called from mv88e6xxx_setup_port(), which runs under the
> mv88e6xxx_reg_lock() taken by mv88e6xxx_setup(). Therefore, when running
> on mv88e6352, the reg_lock would be acquired a second time and the
> system would deadlock on driver probe.
>
> The things that mv88e6xxx_setup() can compete with in terms of register
> access with are the IRQ handlers and MDIO bus operations registered by
> mv88e6xxx_probe(). So there is a real need to acquire the register lock.
>
> The register lock can, in principle, be dropped and re-acquired pretty
> much at will within the driver, as long as no operations that involve
> waiting for indirect access to complete (essentially, callers of
> mv88e6xxx_smi_direct_wait() and mv88e6xxx_wait_mask()) are interrupted
> with the lock released. However, I would guess that in mv88e6xxx_setup(),
> the critical section is kept open for such a long time just in order to
> optimize away multiple lock/unlock operations on the registers.
>
> We could, in principle, drop the reg_lock right before the
> mv88e6xxx_setup_port() -> mv88e6xxx_get_caps() call, and
> re-acquire it immediately afterwards. But this would look ugly, because
> mv88e6xxx_setup_port() would release a lock which it didn't acquire, but
> the caller did.
>
> A cleaner solution to this issue comes from the observation that struct
> mv88e6xxxx_ops methods generally assume they are called with the
> reg_lock already acquired. Whereas mv88e6352_phylink_get_caps() is more
> the exception rather than the norm, in that it acquires the lock itself.
>
> Let's enforce the same locking pattern/convention for
> chip->info->ops->phylink_get_caps() as well, and make
> mv88e6xxx_get_caps(), the top-level function, acquire the register lock
> explicitly, for this one implementation that will access registers for
> port 4 to work properly.
>
> This means that mv88e6xxx_setup_port() will no longer call the top-level
> function, but the low-level mv88e6xxx_ops method which expects the
> correct calling context (register lock held).
>
> Compared to chip->info->ops->phylink_get_caps(), mv88e6xxx_get_caps()
> also fixes up the supported_interfaces bitmap for internal ports, since
> that can be done generically and does not require per-switch knowledge.
> That's code which will no longer execute, however mv88e6xxx_setup_port()
> doesn't need that. It just needs to look at the mac_capabilities bitmap.
>
> Fixes: cc1049ccee20 ("net: dsa: mv88e6xxx: fix speed setting for CPU/DSA =
ports")
> Reported-by: Maksim Kiselev <bigunclemax@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index ba4fff8690aa..242b8b325504 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -689,13 +689,12 @@ static void mv88e6352_phylink_get_caps(struct mv88e=
6xxx_chip *chip, int port,
>
>         /* Port 4 supports automedia if the serdes is associated with it.=
 */
>         if (port =3D=3D 4) {
> -               mv88e6xxx_reg_lock(chip);
>                 err =3D mv88e6352_g2_scratch_port_has_serdes(chip, port);
>                 if (err < 0)
>                         dev_err(chip->dev, "p%d: failed to read scratch\n=
",
>                                 port);
>                 if (err <=3D 0)
> -                       goto unlock;
> +                       return;
>
>                 cmode =3D mv88e6352_get_port4_serdes_cmode(chip);
>                 if (cmode < 0)
> @@ -703,8 +702,6 @@ static void mv88e6352_phylink_get_caps(struct mv88e6x=
xx_chip *chip, int port,
>                                 port);
>                 else
>                         mv88e6xxx_translate_cmode(cmode, supported);
> -unlock:
> -               mv88e6xxx_reg_unlock(chip);
>         }
>  }
>
> @@ -831,7 +828,9 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds,=
 int port,
>  {
>         struct mv88e6xxx_chip *chip =3D ds->priv;
>
> +       mv88e6xxx_reg_lock(chip);
>         chip->info->ops->phylink_get_caps(chip, port, config);
> +       mv88e6xxx_reg_unlock(chip);
>
>         if (mv88e6xxx_phy_is_internal(ds, port)) {
>                 __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> @@ -3307,7 +3306,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_ch=
ip *chip, int port)
>                 struct phylink_config pl_config =3D {};
>                 unsigned long caps;
>
> -               mv88e6xxx_get_caps(ds, port, &pl_config);
> +               chip->info->ops->phylink_get_caps(chip, port, &pl_config)=
;
>
>                 caps =3D pl_config.mac_capabilities;
>
> --
> 2.34.1
>
