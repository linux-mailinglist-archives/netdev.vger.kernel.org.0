Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7417A46819A
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 01:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383931AbhLDBBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:01:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34514 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354600AbhLDBBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:01:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96A3D62C49;
        Sat,  4 Dec 2021 00:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98653C341C1;
        Sat,  4 Dec 2021 00:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638579469;
        bh=BO0A14QvdxOco1MToTU7UoxsRX6rp+stunCYa4CcvQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kG21PKb7tDDmzOv3CgyB7TtkPfefmCb2tTpnfKaYiOysQ/miDFq0sDlUHqqOfmj/Y
         +1OVMAikrDmbgKmnhGS/SD54xjnFNXkMLkVfQ9jAthj8MYC3JV7jMMbs8KV6l+a+iC
         DW4MdUmwbfxyo35AkYqtxvJ70yvd2eNxxjB3Zm8IA+tIqQ5EriYSJL8I0LrKPqAYut
         OqrSnTdojANxf+YWwG3yMKyvlCcDsDeyUqeqxmUz610i7Slgidjs5K5tplipKr/SvX
         2b3wFh50k9FmzaweHB1UlwC6ZtQlS4wfTW5NrKH0rwHdnhbCE0APT2qPZoHMtgeTeU
         vUYtrtvhzZi6A==
Date:   Fri, 3 Dec 2021 16:57:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Message-ID: <20211203165747.7e1e7554@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87wnklivun.fsf@miraculix.mork.no>
References: <20211202143437.1411410-1-lee.jones@linaro.org>
        <87wnklivun.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021 15:52:48 +0100 Bj=C3=B8rn Mork wrote:
> Lee Jones <lee.jones@linaro.org> writes:
>=20
> > diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> > index 24753a4da7e60..e303b522efb50 100644
> > --- a/drivers/net/usb/cdc_ncm.c
> > +++ b/drivers/net/usb/cdc_ncm.c
> > @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev,=
 u32 new_tx)
> >  		min =3D ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct u=
sb_cdc_ncm_nth32);
> > =20
> >  	max =3D min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm=
.dwNtbOutMaxSize));
> > +	if (max =3D=3D 0)
> > +		max =3D CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
> > =20
> >  	/* some devices set dwNtbOutMaxSize too low for the above default */
> >  	min =3D min(min, max); =20
>=20
> I believe this is the best possible fix, considering the regressions
> anything stricter might cause.
>=20
> We know of at least one MBIM device where dwNtbOutMaxSize is as low as
> 2048.
>=20
> According to the MBIM spec, the minimum and default value for
> wMaxSegmentSize is also 2048.  This implies that the calculated "min"
> value is at least 2076, which is why we need that odd looking
>=20
>   min =3D min(min, max);
>=20
> So let's just fix this specific zero case without breaking the
> non-conforming devices.
>=20
>=20
> Reviewed-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Applied to net, thanks!
