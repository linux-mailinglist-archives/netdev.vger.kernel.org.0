Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364C164BF16
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbiLMWGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236813AbiLMWGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:06:38 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B4EEE3D;
        Tue, 13 Dec 2022 14:06:36 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id m4so1344998pls.4;
        Tue, 13 Dec 2022 14:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3P8+fmlFT4yhtE4PFHqszJb/OdQRA5x5lH9d2KNq6fg=;
        b=VDgCfOPPh3Dez2V702FiW9sWEczCvVpOadPaJjKhQyxQ+cDVzaUSnvRGyHzasyV8YE
         onfVcH71E8dx5ZCBL0Fn8EjDSfvhQ1FsFFK4k9qig2n7zJw9JydGDP9FH6Cvhd3MSRqd
         1lmT5jwGpDC4HoM7TZqdhc5ptbd/hzV0wcPRrTSTSq8f4SUjAG4A4h/TVJOwSbpPwkGh
         TTgd8BwWWHx6wB8wuBfirhcUD0IQ66VuSNt9ogoMkqepSxPw+xeq8Sf2Oc0n6QOvNAtT
         f5YUH9K30XHxAET1u0bjHllNnx3p/PzYgZtvLLplXUoLdqRh1USs4tiZw4aqDPdkmwaW
         q4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3P8+fmlFT4yhtE4PFHqszJb/OdQRA5x5lH9d2KNq6fg=;
        b=KqIgqazbnTO/V75+hzgX7HO7H6NPT14Q7UcTcoU/qmUQGaDAAwF2C/f+ljk4G1/Hhb
         tbryPfvgtv9FRPQKrkOg1RWHzqY4+rHSeckARfID7PVUhBCb/PQmZO1XTasXyGeV4wP2
         YQeACo2fBiYdDXJgBQL8MqhlsY6Cf5QEmaGO1/amKw87TUka/nISZwawAAuo3Bd8Q9Y5
         Q2/kXOGWVDPW0JHFupRqRVTbSzMABRZWFFHfv4TTdQxTUxA+3W3XnzLF4rPy1Bjjsi4E
         ncmNgV2Qprp0dsgDNWVFitpxUzo5leIKPIgV0hR5tYVYQbZZKSaZ7HOQvEoe0SMmEcOH
         +fnw==
X-Gm-Message-State: ANoB5pnkXDMSQU+/IloHIb6uNYJxfC8NKTmFibhKoLp8GtSEE3uSB+fj
        mQEhUc7Exif+mV31tExWcRjDue34+co=
X-Google-Smtp-Source: AA0mqf5+My1KMnfxezazmOJwrZzXmTiSo0UQgisY3Zj4etX6aQs0nTfM1azYODLSujjXbo1mcsHkMg==
X-Received: by 2002:a17:903:4cd:b0:189:c57c:9a19 with SMTP id jm13-20020a17090304cd00b00189c57c9a19mr20114453plb.58.1670969195803;
        Tue, 13 Dec 2022 14:06:35 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id b5-20020a170902650500b00186a437f4d7sm369916plk.147.2022.12.13.14.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 14:06:35 -0800 (PST)
Message-ID: <e94f4967a770b7004686155291c885e61a3403b2.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 2/3] net: dsa: mv88e6xxx: disable hold of
 chip lock for handling
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 13 Dec 2022 14:06:33 -0800
In-Reply-To: <20221213174650.670767-3-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
         <20221213174650.670767-3-netdev@kapio-technology.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-13 at 18:46 +0100, Hans J. Schultz wrote:
> As functions called under the interrupt handler will need to take the
> netlink lock, we need to release the chip lock before calling those
> functions as otherwise double lock deadlocks will occur as userspace
> calls towards the driver often take the netlink lock and then the
> chip lock.
>=20
> The deadlock would look like:
>=20
> Interrupt handler: chip lock taken, but cannot take netlink lock as
>                    userspace config call has netlink lock.
> Userspace config: netlink lock taken, but cannot take chip lock as
>                    the interrupt handler has the chip lock.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>

Just to confirm, in order to see the deadlocks I would imagine you need
something in the tracepoints that is taking the netlink lock?

If so you might want to reference the commit that switched out the
dev_err_ratelimited for the tracepoints 8646384d80f3 ("net: dsa:
mv88e6xxx: replace ATU violation prints with trace points") so that
this patch can be found an applied to any kernels that pull in those
tracepoints.

> ---
>  drivers/net/dsa/mv88e6xxx/global1_atu.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv=
88e6xxx/global1_atu.c
> index 61ae2d61e25c..34203e112eef 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -409,11 +409,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread=
_fn(int irq, void *dev_id)
> =20
>  	err =3D mv88e6xxx_g1_read_atu_violation(chip);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> =20
>  	err =3D mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &val);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> =20
>  	err =3D mv88e6xxx_g1_atu_fid_read(chip, &fid);
>  	if (err)
> @@ -421,11 +421,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread=
_fn(int irq, void *dev_id)
> =20
>  	err =3D mv88e6xxx_g1_atu_data_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> =20
>  	err =3D mv88e6xxx_g1_atu_mac_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> +
> +	mv88e6xxx_reg_unlock(chip);
> =20
>  	spid =3D entry.state;
> =20
> @@ -449,13 +451,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread=
_fn(int irq, void *dev_id)
>  						   fid);
>  		chip->ports[spid].atu_full_violation++;
>  	}
> -	mv88e6xxx_reg_unlock(chip);
> =20
>  	return IRQ_HANDLED;
> =20
> -out:
> +out_unlock:
>  	mv88e6xxx_reg_unlock(chip);
> =20
> +out:
>  	dev_err(chip->dev, "ATU problem: error %d while handling interrupt\n",
>  		err);
>  	return IRQ_HANDLED;

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
