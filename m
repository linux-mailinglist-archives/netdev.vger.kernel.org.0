Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE6557A139
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbiGSOVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238647AbiGSOUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:20:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 570C21183E
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658239365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OazogUGaTCAKTxUDesSa7xd7vVnLXoIUVapwa9DLQ2s=;
        b=RJ1iTTa428S8m67jOfziGRp0FyZHOquJTVT31FVxDwIb9DcrJgceMCsPkgbAqot7YvGnJ5
        cMKHpcBAgPYM4SeWltWFGu+wFyUGuqKXs27tFXRpcgh+/GvRO+pcvl56hiY2i6i2Rx2K88
        +A0UlbwamQmyjJlYaqnO/sTlkOxBjZc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-UKmM2uJyODm_Wb6RkDRu6A-1; Tue, 19 Jul 2022 10:02:43 -0400
X-MC-Unique: UKmM2uJyODm_Wb6RkDRu6A-1
Received: by mail-wm1-f70.google.com with SMTP id az39-20020a05600c602700b003a321d33238so1182973wmb.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OazogUGaTCAKTxUDesSa7xd7vVnLXoIUVapwa9DLQ2s=;
        b=h3tssWMp/EPJgcUIAhWh4uLZ1mqShNBwTdoBWvM7RANn2wcqM0p/k/6asuqvbj1+Xp
         LouLrRnE2ecI/jlwZ4H2kqhAu1tslBAJRzHQqa17d/cs96zYVVA3hdWsMgPJyV7VbQfG
         SeHUHhy4sPmISYckeY78ns6s9+SPECUm9F5mcgQhA1A9VVTvw6LhEo68DvxHoZ0aGQ3m
         1gOFjTmHlxXbLevPdmsnDY9zLheQgqCeg4Zg4TT7SJuBXYEaMY/1/vUTeCPVl4txZziX
         fuxXVbh8icMBs6PRBc6tizQ1AHBF54oADVQtS4QNgj7ZBZr2LVIvpDpMVp9FwJZaVriM
         Uhdw==
X-Gm-Message-State: AJIora8/r+n3cAeDxVDeq057vxyzRkVN3IeeKuIGrNoaFUdvHzF/H1bd
        wM0eAqfBBQCdGKMYtVUDcuZ8e4uyvqnn989V+BEDwxfLFBPADMofI6hmHIcoPA7vJdi1OI+60ZR
        ZEL1a5UNlVv+YaVmf
X-Received: by 2002:a7b:cd15:0:b0:3a3:1d69:5201 with SMTP id f21-20020a7bcd15000000b003a31d695201mr7195521wmj.10.1658239362450;
        Tue, 19 Jul 2022 07:02:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tDezm8A92mTd+muf5BeHpRsDPK7Fgy5dwBdOS7SZtDj/NGlv5bszF4tZKQLWnulPN2pQwHPA==
X-Received: by 2002:a7b:cd15:0:b0:3a3:1d69:5201 with SMTP id f21-20020a7bcd15000000b003a31d695201mr7195489wmj.10.1658239362223;
        Tue, 19 Jul 2022 07:02:42 -0700 (PDT)
Received: from localhost (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id m9-20020adfe949000000b0021d4694fcaesm13424818wrn.107.2022.07.19.07.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:02:41 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:02:38 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com
Subject: Re: [PATCH v3 net-next 5/5] net: ethernet: mtk_eth_soc: add support
 for page_pool_get_stats
Message-ID: <Yta5fsw0U6KWMmTL@localhost.localdomain>
References: <cover.1657956652.git.lorenzo@kernel.org>
 <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
 <43ff0071f0ce4b958f27427acebcf2c6ace52ba0.camel@redhat.com>
 <YtaE/KJDNOqkvLml@localhost.localdomain>
 <d432c897a8eef451bdd65cfdf5b1da0d866a9a5b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5EMNoz+9F+nqgqFZ"
Content-Disposition: inline
In-Reply-To: <d432c897a8eef451bdd65cfdf5b1da0d866a9a5b.camel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5EMNoz+9F+nqgqFZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 2022-07-19 at 12:18 +0200, Lorenzo Bianconi wrote:
> > > On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> > > > Introduce support for the page_pool stats API into mtk_eth_soc
> > > > driver.
> > > > Report page_pool stats through ethtool.
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > > =A0drivers/net/ethernet/mediatek/Kconfig       |  1 +
> > > > =A0drivers/net/ethernet/mediatek/mtk_eth_soc.c | 40
> > > > +++++++++++++++++++--
> > > > =A02 files changed, 38 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/mediatek/Kconfig
> > > > b/drivers/net/ethernet/mediatek/Kconfig
> > > > index d2422c7b31b0..97374fb3ee79 100644
> > > > --- a/drivers/net/ethernet/mediatek/Kconfig
> > > > +++ b/drivers/net/ethernet/mediatek/Kconfig
> > > > @@ -18,6 +18,7 @@ config NET_MEDIATEK_SOC
> > > > =A0	select PHYLINK
> > > > =A0	select DIMLIB
> > > > =A0	select PAGE_POOL
> > > > +	select PAGE_POOL_STATS
> > > > =A0	help
> > > > =A0	  This driver supports the gigabit ethernet MACs in the
> > > > =A0	  MediaTek SoC family.
> > > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > index abb8bc281015..eba95a86086d 100644
> > > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > @@ -3517,11 +3517,19 @@ static void mtk_get_strings(struct
> > > > net_device *dev, u32 stringset, u8 *data)
> > > > =A0	int i;
> > > > =A0
> > > > =A0	switch (stringset) {
> > > > -	case ETH_SS_STATS:
> > > > +	case ETH_SS_STATS: {
> > > > +		struct mtk_mac *mac =3D netdev_priv(dev);
> > > > +		struct mtk_eth *eth =3D mac->hw;
> > > > +
> > > > =A0		for (i =3D 0; i < ARRAY_SIZE(mtk_ethtool_stats);
> > > > i++) {
> > > > =A0			memcpy(data, mtk_ethtool_stats[i].str,
> > > > ETH_GSTRING_LEN);
> > > > =A0			data +=3D ETH_GSTRING_LEN;
> > > > =A0		}
> > > > +		if (!eth->hwlro)
> > >=20
> > > I see the page_pool is enabled if and only if !hwlro, but I think
> > > it
> > > would be more clear if you explicitly check for page_pool here (and
> > > in
> > > a few other places below), so that if the condition to enable
> > > page_pool
> > > someday will change, this code will still be fine.
> >=20
> > Hi Paolo,
> >=20
> > page_pool pointer is defined in mtk_rx_ring structure, so
> > theoretically we can have a
> > page_pool defined for queue 0 but not for queues {1, 2, 3}.
>=20
> I see. I missed hwlro is a per device setting.
>=20
> > "!eth->hwlro" means
> > there is at least one page_pool allocated. Do you prefer to do
> > something like:
> >=20
> > bool mtk_is_pp_enabled(struct mtk_eth *eth)
> > {
>=20
> > 	for (i =3D 0; i < ARRAY_SIZE(eth->rx_ring); i++) {
> > 		struct mtk_rx_ring *ring =3D &eth->rx_ring[i];
> >=20
> > 		if (ring->page_pool)
> > 			return true;
> > 	}
> > 	return false;
> > }
>=20
> Even:
>=20
> bool mtk_is_pp_enabled(struct mtk_eth *eth)
> {
> 	return !eth->hwlro;
> }
>=20
> will suffice to encaspulate the logic behind page pool enabling in a
> single place.

ack, I am fine with it. I will fix in v4.

Regards,
Lorenzo

>=20
> /P
>=20

--5EMNoz+9F+nqgqFZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYta5ewAKCRA6cBh0uS2t
rKuZAQCoCiT1JxTElHC3iJAa4jRFWpzrzUrdHO0YZcFySGakagEAnfzhbDRFauBQ
FtsqE623N2etCj2VpVdGQz7s7LXAUAQ=
=RmXr
-----END PGP SIGNATURE-----

--5EMNoz+9F+nqgqFZ--

