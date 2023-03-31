Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168D36D171B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCaGC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCaGC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:02:28 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D42CA18
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=oTBeSyANGvYTvZGv/yjKbgHwqoOH
        PgLHtmNhf4S1oEo=; b=rPtmrypJ6xxitPxAbhDbTQYB8H5YJST13c52+PaCWJB9
        bJUxKakDT3sHhQf94TOxhoNZimxkEZiM7qnJrzRPl7CrZuju4WRrRxs5Alw44odP
        4niiDirM3GMLHqZy4TFBpvmJlJL9DKlH3goTK/fTJGhTehb1KRu7vvduUEyi19k=
Received: (qmail 1176182 invoked from network); 31 Mar 2023 08:02:22 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 31 Mar 2023 08:02:22 +0200
X-UD-Smtp-Session: l3s3148p1@drDW8yv4gokujnv6
Date:   Fri, 31 Mar 2023 08:02:21 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Steen.Hegelund@microchip.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        steve.glendinning@shawell.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        geert+renesas@glider.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Message-ID: <ZCZ3bSlOF9Sm4DJ2@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steen.Hegelund@microchip.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, steve.glendinning@shawell.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, geert+renesas@glider.be,
        linux-kernel@vger.kernel.org
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
 <CRIP4UR9M4IS.V7ZOZHKV9QRX@den-dk-m31857>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZPUO7quT3QOZiRXY"
Content-Disposition: inline
In-Reply-To: <CRIP4UR9M4IS.V7ZOZHKV9QRX@den-dk-m31857>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPUO7quT3QOZiRXY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +       if (pdata->is_open) {
>=20
> Couldn't you just use netif_carrier_ok() here and drop the is_open
> variable?

=46rom my research, I can't:

1) netif_carrier_ok() uses __LINK_STATE_NOCARRIER
2) __LINK_STATE_NOCARRIER gets cleared in netif_carrier_on()
3) netif_carrier_on() is this code:

	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
		if (dev->reg_state =3D=3D NETREG_UNINITIALIZED)
			return;
		atomic_inc(&dev->carrier_up_count);
		linkwatch_fire_event(dev);
		if (netif_running(dev))
			__netdev_watchdog_up(dev);
	}

4) Notice the last if. It checks netif_running(). So, it is possible to
have the carrier on and the device not opened yet.
5) Sadly, no cigar. If I didn't miss something...

But thanks for the suggestion! Happy hacking,

   Wolfram


--ZPUO7quT3QOZiRXY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQmd2kACgkQFA3kzBSg
KbaWBA//fNTM7DoeNK5082KA1GRiby93GS14IGQqwOJbugpYLk+36OilPukr+Egm
pRjLvfTjZ8Dw5r+DlxPopbMQpjWH2+vlTgFVa11AmZszqQI4P4l4HDLP/tHcBQ3w
o0GyFDzD3t/ZJArRXJJX9CytuVBnZQ5l06Uu+PPg6xjysxna+JKd+1SMxMVU+gA8
i/jWBkfstKjLQhp7x78n+wDTG/i2GBTlMo9SayQVxQbYk1h9XdWuq9vdaLe4xVgb
LLQ5DwFw+KrTQdHd0Va6+ESxYsD0hljd8I2ICjJrARELVzzb7ZMimArO1LVWaqPy
/OoBSgSJRSV/7pqoLm84E4Jdpr2lkI4AZM70t6HoXOF/DRubSanrx8/C23ATKzhx
mwL9iMm17+bYZELNG9Ny9QEYm5Sup1sprcyU2BBAH0TRRQ6w7KcHkv7eLwS8WCBj
mu0pf1gcDrNng2xO9CqdyXdPeiRGWWXAuqzdHqRxnxvxr0yqnlyR78g/stf2kmc5
ow0soo4idGQZPH2mkqZu9gw9HK6nikful1xY8gzv3rDZMfs70rnS53uN84qUmY63
kIkd+8EvDo8vTXr+dWeE/q2Wv8QN2AU29/Lj+IGs3OHf2UluumNioQliYHB7b+l7
TZ8hs/Bu8S6BQPNE4tZRiooHsgx7HRJSdXPPUgr7ykndQ5+G2pg=
=mITd
-----END PGP SIGNATURE-----

--ZPUO7quT3QOZiRXY--
