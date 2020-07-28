Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A3D230B9C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgG1Nll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:41:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34722 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgG1Nll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 09:41:41 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595943698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rdyjzq49qh0o1k2eHrosv/rRh5Wf4b1+KgFekA4u2eU=;
        b=ArvVGunSApCYmSyxqEc8yoj+V9pKmDYbcoSTA4KKly/Uv56l0fY0ZIwcBNa7stbFeMztW4
        2bAOQWPIaqPfKgOZFfJgD0uq9+0xCdk/8bcKYYKvGRm/ba8j29mE5XOfgBDorQcU2uvIKJ
        tWtAKTRwULxi+G2eKjPrWuw+m7WDrlU1IoWImnsya9uGCaZqfHJ0OvJeOXgZtBIRepw9IZ
        NQlOlx9rP4Kwk1Em9ZCf88HEAuQczdILDU6sMZj4eEZ/ZAyvHDHimJiNnnEEGSarf6kXGi
        Ba6ySskannPPzJ5oCLAMNboi6FEe+69yLgKuPrhnrcidpM3TDWCzMMSe2SqEhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595943698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rdyjzq49qh0o1k2eHrosv/rRh5Wf4b1+KgFekA4u2eU=;
        b=Ytih5aNv8QLoOhoIkTVjOrUblZ7duenSqs9p3pLHvHC6HwTZxKbktM/Xo7IjP4ZuAOgkZz
        m2sJ+uTEnO9SYBBA==
To:     Petr Machata <petrm@mellanox.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-Reply-To: <875za7sr7b.fsf@kurt>
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com> <875za7sr7b.fsf@kurt>
Date:   Tue, 28 Jul 2020 15:41:37 +0200
Message-ID: <87365bsqni.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Jul 28 2020, Kurt Kanzenbach wrote:
> On Mon Jul 27 2020, Petr Machata wrote:
>> So this looks good, and works, but I'm wondering about one thing.
>
> Thanks for testing.
>
>>
>> Your code (and evidently most drivers as well) use a different check
>> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
>> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
>> this:
>>
>>     00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..^...........E.
>>     000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H..@....Y......
>>     00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ...?.?.4.....,..
>>                             ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
>>     00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ................
>>     000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ................
>>     000000000b98156e: 00 00 00 00 00 00                                ......
>>
>> Both UDP and PTP length fields indicate that the payload ends exactly at
>> the end of the dump. So apparently skb->len contains all the payload
>> bytes, including the Ethernet header.
>>
>> Is that the case for other drivers as well? Maybe mlxsw is just missing
>> some SKB magic in the driver.
>
> So I run some tests (on other hardware/drivers) and it seems like that
> the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
> added to the check.
>
> Looking at the driver code:
>
> |static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local_port,
> |					void *trap_ctx)
> |{
> |	[...]
> |	/* The sample handler expects skb->data to point to the start of the
> |	 * Ethernet header.
> |	 */
> |	skb_push(skb, ETH_HLEN);
> |	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
> |}

Sorry, that was the wrong function. I meant this one here:

|static void mlxsw_sp_rx_ptp_listener(struct sk_buff *skb, u8 local_port,
|				     void *trap_ctx)
|{
|	[...]
|	/* The PTP handler expects skb->data to point to the start of the
|	 * Ethernet header.
|	 */
|	skb_push(skb, ETH_HLEN);
|	mlxsw_sp_ptp_receive(mlxsw_sp, skb, local_port);
|}

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8gKxEACgkQeSpbgcuY
8Kbu3g//bQmiBYriOq5mPl+QFMMfIMoKe7iHXBHS1nb0SAlb8xup0kmBP8HBcGaR
GRlxe/5rJnPp0eo2x1Fz5K0bn85lHmG3L/Yb7zsuzEKB4A7YX9OPCaA5OvSAgJnS
I5h5yx8zLwfA9tFdEOXoIwtAzj2uzsSayEvOXlqMQv8SwaNTcet6SOAJDqLfU3Te
NIgY1gGjfCD3lOw+ESbwsqnFxoXi5ZOJachUdqgRqMtiY327mpq6j3yi3PFm19lJ
m5czbNlod+vy9G8uHlVPzViM2ml+aq2JVZdRUbQi6ep4rTKwBwjeuWlyAV9dViyA
LWoSxgfLyn3gTWwrA4XMJQB+cQcjznTHLMUS54smUe7iZYWGqZtXW+qEPaJiErEH
f6/IEbTMS9lw1M2fFXr/xEtcKuVjcucAgOFGRVvwXqfR2PoNPcgweWLAPnCHUtVP
S1yaCOfLzwIoX5OZz1HjVUc5wGh929JRqnhm0k5RIbn6iTN5XH4auqzz2V8puqEy
LnRBEC1ZU2oWKnlb/Fx4NENTukgVCOLUejlfQm/DaVB0GrfBvrRKupkjvmcrUuzq
tNaP4A7DIwbgJfY6urfEvyOKvkqCnpva2NMF0Ot2RnqdiQiRJfiemvygCjjbUBlO
PXA9SzZhOMoJZqRIY6KAtLXuNJgsQPM6Tp+lRla9LYUgK4qEoP4=
=P+TX
-----END PGP SIGNATURE-----
--=-=-=--
