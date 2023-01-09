Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DC86620F9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbjAIJHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjAIJHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:07:13 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A073D2DC5;
        Mon,  9 Jan 2023 01:00:55 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B53BA84FB4;
        Mon,  9 Jan 2023 10:00:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673254853;
        bh=a+4QwOuUmaTbvJetlOvc9AOPWkq2ZOV1kvMU/WJF0p8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YVYBrQyl7vR/k/ArgwoZd/YgN2bs2hnw4rimqEcyugTpXvew6JyEr8wmIBA5pZXoV
         AU3h9b6Cfm7377QMm78zSs+6jyj71jlvCvm5aR4ggK2ZWr0IHoNND9MCNt+H78vFsH
         TZx6wCalJEFNviIh1Czna4G2COIiuRvLut3RzNXJ5VFJGgUXXxnV21mHE+VlQkEk4y
         0U3/wy4oyldunFhLPzQbyPSna9r4nwxdRjbu9MyBxvW/7J71wIFLihs0sWbJ2rscJo
         iAkyULo/wWZgo6ZlCo12g/dZH018MFpiRL6G9H9w0jOeQqFHRoaUj03u522XwnxHqk
         4BBlty6/xrRVw==
Date:   Mon, 9 Jan 2023 10:00:40 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230109100040.413ad300@wsk>
In-Reply-To: <Y7gdNlrKkfi2JvQk@lunn.ch>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y7gdNlrKkfi2JvQk@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TH1M=ns0E649FyQgXNMY3jy";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TH1M=ns0E649FyQgXNMY3jy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent. This value corresponds to the memory allocated
> > in switch to store single frame.
> >=20
> > For example mv88e6185 supports max 1632 bytes, which is now
> > in-driver standard value. On the other hand - mv88e6250 supports
> > 2048 bytes. To be more interresting - devices supporting jumbo
> > frames - use yet another value (10240 bytes)
> >=20
> > As this value is internal and may be different for each switch IC,
> > new entry in struct mv88e6xxx_info has been added to store it.
> >=20
> > This commit doesn't change the code functionality - it just provides
> > the max frame size value explicitly - up till now it has been
> > assigned depending on the callback provided by the IC driver
> > (e.g. .set_max_frame_size, .port_set_jumbo_size).
> >=20
> > Signed-off-by: Lukasz Majewski <lukma@denx.de> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> FYI: It is normal to include a patch 0/X for a patchset, which
> explains the big picture of the patchset. Please try to remember this
> for your next patchset.

Ok. I will. Thanks for the tip.

>=20
>     Andrew
>=20
>=20




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/TH1M=ns0E649FyQgXNMY3jy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmO717gACgkQAR8vZIA0
zr3DCQf/QaiDx0uezvotUgHY62zPc59mlvQkC0fBiUW/GuhON/++zPW33wpzhFMm
9L2rEUnECYBmXSlTthLOnS3lyqCSxCLlzZeDCbuZsNnV4sYBM2jQI/VeJfH55REU
/p6WyAF68fH0gjaniL99AAYuJiKEWA/xUdp8PEJqPgF0RYOEu5dR0ug5O6yNZ/HC
21II3Jat8J5auyTxK+K1C0ATT8zF832sUXhh+X5aXEIGBbOKWclsJ7/oA0mon4Kr
BC3mGrhNKHRr0kAJ1SnDis+AscZjtaVSkAsH25rQPuoaTYL02tZzgLXxS67ejJXT
exVEOHTiFAfZz6b3Y/7dc8ibMnJ17w==
=A5dN
-----END PGP SIGNATURE-----

--Sig_/TH1M=ns0E649FyQgXNMY3jy--
