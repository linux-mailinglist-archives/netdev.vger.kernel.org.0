Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78359642E4B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLERG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiLERGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:06:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCA4167CD
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670259954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b7DJBD9damnXune0Kig2UnZuVv4B+QVYF3QsLQNl4lw=;
        b=UUsNwlmKz2+h9+R1HXpjHrWWM1WQ9r1Vll2R9Cd7mBU8N3O6VoUAdkZUkz5iCMGIZEB4Zl
        dbdK9BintL35ymKvl6nvAEWqIDgueTFxx76NHZjnNxPZmPSd+EJPPXzVNzkiwosP4AWO5x
        CEfBNcdU+Nrw6HofsSLePq/gOT68B3Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-jlmXkEInPzKBl1L85InULw-1; Mon, 05 Dec 2022 12:05:53 -0500
X-MC-Unique: jlmXkEInPzKBl1L85InULw-1
Received: by mail-wr1-f71.google.com with SMTP id a7-20020adfbc47000000b002421f817287so2513398wrh.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 09:05:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7DJBD9damnXune0Kig2UnZuVv4B+QVYF3QsLQNl4lw=;
        b=MX4Ivqbq6o4wya7HcUFFqFSzZGLGmbTsDG1H9SypRBG6cSKtWJGGAkLi17BpEUmsZx
         iQd4o2r+cQ4zsGkVnFdsvFjMlT8rnFw0ZKUuIApUSoKOSyD+35QE6WHCsqW5bFe6SkgG
         G3vAEwtewtIH4MPYJMeteHNJUkJoT9iM4RwZDBidb7p9uKA2E3SftGGAub2uKIKjyei0
         JzGbzqfTJJoasKf33TJotk2jk2LahFMD1ZP0XNLMZJ76XDuRMVLQb1s8vJsyX8Ogg27X
         OQU4ZfNpm9V8Q978yQbvkD8oOSM127D3c19ejA1AwIuEdabBpH2g345F1FpcQ6DEzNYC
         HyIQ==
X-Gm-Message-State: ANoB5pln0omBx/1KWhja6HjGaqSx1BcYf1fpQkIGqh5qGFzbIMmtahZ4
        twcZBlK/mFiRCgs9C8XwTd1B3HNJH7CZ+Acop+L8szIycNO3yxRpzmDSY61hgFuZk2AZFt+I85O
        /uTPJip17mG7FERH6
X-Received: by 2002:adf:f5c3:0:b0:242:3427:bb51 with SMTP id k3-20020adff5c3000000b002423427bb51mr12712964wrp.635.1670259952261;
        Mon, 05 Dec 2022 09:05:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6gLa1e/CtnmUdAsov448g+X+01PUiazUSLlfkKZnHFzLMa2kEDqD+6fmSR4sa3jKiCKSwh/w==
X-Received: by 2002:adf:f5c3:0:b0:242:3427:bb51 with SMTP id k3-20020adff5c3000000b002423427bb51mr12712943wrp.635.1670259951991;
        Mon, 05 Dec 2022 09:05:51 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id g16-20020a7bc4d0000000b003d1b4d957aasm6318137wmk.36.2022.12.05.09.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:05:51 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:05:49 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: fix possible
 deadlock if mtk_wed_wo_init fails
Message-ID: <Y44k7X5YYbuSntd2@lore-desk>
References: <5a29aae6c4a26e807844210d4ddac7950ca5f63d.1670238731.git.lorenzo@kernel.org>
 <Y44jO1ZT9RgqYtxF@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tHgY236u4P316zYr"
Content-Disposition: inline
In-Reply-To: <Y44jO1ZT9RgqYtxF@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tHgY236u4P316zYr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Dec 05, 2022 at 12:14:41PM +0100, Lorenzo Bianconi wrote:
> > Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
> > mtk_wed_attach routine if mtk_wed_wo_init fails.
> > Check wo pointer is properly allocated before running mtk_wed_wo_reset()
> > and mtk_wed_wo_deinit() in __mtk_wed_detach routine.
> > Honor mtk_wed_mcu_send_msg return value in mtk_wed_wo_reset().
> >=20
> > Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo supp=
ort")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - move wo pointer checks in __mtk_wed_detach()
> > ---
> >  drivers/net/ethernet/mediatek/mtk_wed.c     | 30 ++++++++++++++-------
> >  drivers/net/ethernet/mediatek/mtk_wed_mcu.c |  3 +++
> >  2 files changed, 23 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethe=
rnet/mediatek/mtk_wed.c
> > index d041615b2bac..2ce9fbb1c66d 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed.c
> > @@ -174,9 +174,10 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
> >  	mtk_wdma_tx_reset(dev);
> >  	mtk_wed_reset(dev, MTK_WED_RESET_WED);
> > =20
> > -	mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
> > -			     MTK_WED_WO_CMD_CHANGE_STATE, &state,
> > -			     sizeof(state), false);
> > +	if (mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
> > +				 MTK_WED_WO_CMD_CHANGE_STATE, &state,
> > +				 sizeof(state), false))
> > +		return;
> > =20
> >  	if (readx_poll_timeout(mtk_wed_wo_read_status, dev, val,
> >  			       val =3D=3D MTK_WED_WOIF_DISABLE_DONE,
> > @@ -576,12 +577,10 @@ mtk_wed_deinit(struct mtk_wed_device *dev)
> >  }
> > =20
> >  static void
> > -mtk_wed_detach(struct mtk_wed_device *dev)
> > +__mtk_wed_detach(struct mtk_wed_device *dev)
> >  {
> >  	struct mtk_wed_hw *hw =3D dev->hw;
> > =20
> > -	mutex_lock(&hw_lock);
> > -
> >  	mtk_wed_deinit(dev);
> > =20
> >  	mtk_wdma_rx_reset(dev);
> > @@ -590,9 +589,11 @@ mtk_wed_detach(struct mtk_wed_device *dev)
> >  	mtk_wed_free_tx_rings(dev);
> > =20
> >  	if (mtk_wed_get_rx_capa(dev)) {
> > -		mtk_wed_wo_reset(dev);
> > +		if (hw->wed_wo)
> > +			mtk_wed_wo_reset(dev);
> >  		mtk_wed_free_rx_rings(dev);
> > -		mtk_wed_wo_deinit(hw);
> > +		if (hw->wed_wo)
> > +			mtk_wed_wo_deinit(hw);
> >  	}
> > =20
> >  	if (dev->wlan.bus_type =3D=3D MTK_WED_BUS_PCIE) {
> > @@ -612,6 +613,13 @@ mtk_wed_detach(struct mtk_wed_device *dev)
> >  	module_put(THIS_MODULE);
> > =20
> >  	hw->wed_dev =3D NULL;
> > +}
> > +
> > +static void
> > +mtk_wed_detach(struct mtk_wed_device *dev)
> > +{
> > +	mutex_lock(&hw_lock);
> > +	__mtk_wed_detach(dev);
> >  	mutex_unlock(&hw_lock);
> >  }
> > =20
> > @@ -1490,8 +1498,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
> >  		ret =3D mtk_wed_wo_init(hw);
> >  	}
> >  out:
> > -	if (ret)
> > -		mtk_wed_detach(dev);
> > +	if (ret) {
> > +		dev_err(dev->hw->dev, "failed to attach wed device\n");
> > +		__mtk_wed_detach(dev);
> > +	}
> >  unlock:
> >  	mutex_unlock(&hw_lock);
> > =20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/=
ethernet/mediatek/mtk_wed_mcu.c
> > index f9539e6233c9..3dd02889d972 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> > @@ -207,6 +207,9 @@ int mtk_wed_mcu_msg_update(struct mtk_wed_device *d=
ev, int id, void *data,
> >  	if (dev->hw->version =3D=3D 1)
> >  		return 0;
> > =20
> > +	if (!wo)
> > +		return -ENODEV;
> > +
>=20
> Can you please help me to understand how and when this mtk_wed_mcu_msg_up=
date()
> function is called?
>=20
> I see this line .msg_update =3D mtk_wed_mcu_msg_update, and
> relevant mtk_wed_device_update_msg() define, but nothing calls to this
> define.

mtk_wed_device_update_msg() is currently run by mt7915 driver in
mt7915_mcu_wed_enable_rx_stats() and in mt76_connac_mcu_sta_wed_update().
At the moment we always run mtk_wed_mcu_msg_update with non-NULL wo pointer,
but I would prefer to add this safety check.

Regards,
Lorenzo

>=20
>=20
>=20
> >  	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO, id, data, len,
> >  				    true);
> >  }
> > --=20
> > 2.38.1
> >=20
>=20

--tHgY236u4P316zYr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY44k7QAKCRA6cBh0uS2t
rNOxAQC8q/k7mo1XbnKQjrPmumhdva9w1PIRQTguMeFrdfq49gEAz4D/Ss1vGRP3
ASHrz5HBFxuwDrzOuG8Y6oFRoOAHvQo=
=PUML
-----END PGP SIGNATURE-----

--tHgY236u4P316zYr--

