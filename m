Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE9D6F402C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjEBJ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbjEBJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:29:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238BE4C07
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683019740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EA89Mu2bFSBvYrAFwxo01YZgtY9Jypho3d/0E2qf64o=;
        b=eeAB1zFs8Nx6HAPCtqjDEVHkD2Efhi5+pEO1p558/V7pOCEP0Cq7i950MtrdvGdwW5NVVx
        vV3xAFgFbZNdwtwY05y2hrJg6DMyGzVWBrO2OX+9wEelyGGJyV8z4mncUB8LDAh1YKlM/+
        bZV08oDGrIkH1loUlTYHP1bg+8v4mtw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-HtkwbEUbNsOEZjEmLL5_3g-1; Tue, 02 May 2023 05:28:59 -0400
X-MC-Unique: HtkwbEUbNsOEZjEmLL5_3g-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-61acaa32164so6999756d6.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 02:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683019739; x=1685611739;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EA89Mu2bFSBvYrAFwxo01YZgtY9Jypho3d/0E2qf64o=;
        b=M6C/VsLTAfn0AsSRCVw4XhiYALqls/DwoXMZbNaF+qtARmILHgQqL5zH4elQ/BPB9O
         aFixeglKz3RJjBVPRvwd5wUVSf/qBujA5HW7Q9CjjwpCsMNa82UXpIrdIykwYWBwiTwp
         9n+tm2/dV/Q7PIy/NMvUH+oN++7iDbt3ca+i50FId7U43Bf3fvToZccExaHwG/qlPXFU
         pn6l+spOypKK0cycraCE/jVuYpf17JpciSpAP9P08fGQrb8VtX7rBRMGGoNmTsJJKuzb
         aqKry6o2JomIPsb5scQNoqB/4IDJZGZULYJxaxmKS70GrwXyEuy1DjxMoKVzADHevuNd
         kwSA==
X-Gm-Message-State: AC+VfDzenlsnyb1+Wsn1oig5CJlcN1sU0XJz+s84GesIErFb1iLFpR42
        zk5aoqClAHDJfeHo59oJ+iLQPLJ1MLOQC05bqPw9/4BRpib9mvQOzZOZNCdjXuCh4QcdSTiZm+e
        UtEc5bi60nZ6vI1eAYG1V4zY+
X-Received: by 2002:ac8:5ad0:0:b0:3ef:37fa:e1d6 with SMTP id d16-20020ac85ad0000000b003ef37fae1d6mr3272513qtd.2.1683019739143;
        Tue, 02 May 2023 02:28:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5EnCPwFHmto6yRv4uLS88cpI4qnSJd41ZM2L9flKNyNKTQo587E0dmQkD1hxRKxVNcM65zdQ==
X-Received: by 2002:ac8:5ad0:0:b0:3ef:37fa:e1d6 with SMTP id d16-20020ac85ad0000000b003ef37fae1d6mr3272482qtd.2.1683019738763;
        Tue, 02 May 2023 02:28:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-253-104.dyn.eolo.it. [146.241.253.104])
        by smtp.gmail.com with ESMTPSA id h6-20020a05620a244600b0074a1d2a17c8sm9551193qkn.29.2023.05.02.02.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 02:28:58 -0700 (PDT)
Message-ID: <5a1c7de53daaa6180b207ff42d1736f50b5d90b9.camel@redhat.com>
Subject: Re: [PATCH v2 net] bonding: add xdp_features support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
        mykolal@fb.com, ast@kernel.org, martin.lau@linux.dev,
        alardam@gmail.com, memxor@gmail.com, sdf@google.com,
        brouer@redhat.com, toke@redhat.com, Jussi Maki <joamaki@gmail.com>
Date:   Tue, 02 May 2023 11:28:53 +0200
In-Reply-To: <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
References: <e82117190648e1cbb2740be44de71a21351c5107.1682848658.git.lorenzo@kernel.org>
         <1260d53a-1a05-9615-5a39-4c38171285fd@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-05-01 at 15:33 +0200, Daniel Borkmann wrote:
> On 4/30/23 12:02 PM, Lorenzo Bianconi wrote:
> > Introduce xdp_features support for bonding driver according to the slav=
e
> > devices attached to the master one. xdp_features is required whenever w=
e
> > want to xdp_redirect traffic into a bond device and then into selected
> > slaves attached to it.
> >=20
> > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Please also keep Jussi in Cc for bonding + XDP reviews [added here].

Perhaps worth adding such info to the maintainer file for future
memory?

> > ---
> > Change since v1:
> > - remove bpf self-test patch from the series
>=20
> Given you targeted net tree, was this patch run against BPF CI locally fr=
om
> your side to avoid breakage again?
>=20
> Thanks,
> Daniel
>=20
> > ---
> >   drivers/net/bonding/bond_main.c    | 48 +++++++++++++++++++++++++++++=
+
> >   drivers/net/bonding/bond_options.c |  2 ++
> >   include/net/bonding.h              |  1 +
> >   3 files changed, 51 insertions(+)
> >=20
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond=
_main.c
> > index 710548dbd0c1..c98121b426a4 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -1789,6 +1789,45 @@ static void bond_ether_setup(struct net_device *=
bond_dev)
> >   	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> >   }
> >  =20
> > +void bond_xdp_set_features(struct net_device *bond_dev)
> > +{
> > +	struct bonding *bond =3D netdev_priv(bond_dev);
> > +	xdp_features_t val =3D NETDEV_XDP_ACT_MASK;
> > +	struct list_head *iter;
> > +	struct slave *slave;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	if (!bond_xdp_check(bond)) {
> > +		xdp_clear_features_flag(bond_dev);
> > +		return;
> > +	}
> > +
> > +	bond_for_each_slave(bond, slave, iter) {
> > +		struct net_device *dev =3D slave->dev;
> > +
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_BASIC)) {
> > +			xdp_clear_features_flag(bond_dev);
> > +			return;
> > +		}
> > +
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_REDIRECT))
> > +			val &=3D ~NETDEV_XDP_ACT_REDIRECT;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT))
> > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY))
> > +			val &=3D ~NETDEV_XDP_ACT_XSK_ZEROCOPY;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_HW_OFFLOAD))
> > +			val &=3D ~NETDEV_XDP_ACT_HW_OFFLOAD;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_RX_SG))
> > +			val &=3D ~NETDEV_XDP_ACT_RX_SG;
> > +		if (!(dev->xdp_features & NETDEV_XDP_ACT_NDO_XMIT_SG))
> > +			val &=3D ~NETDEV_XDP_ACT_NDO_XMIT_SG;

Can we expect NETDEV_XDP_ACT_MASK changing in the future (e.g. new
features to be added)? If so the above code will break silently, as the
new features will be unconditionally enabled. What about adding a
BUILD_BUG() to catch such situation?=20

>=20
Cheers,

Paolo

