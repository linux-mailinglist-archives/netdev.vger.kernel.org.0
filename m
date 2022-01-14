Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037FC48E33B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiANEVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiANEVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:21:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C35C061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 20:21:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 259666171D
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 04:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488CEC36AE9;
        Fri, 14 Jan 2022 04:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642134098;
        bh=K8rVDTrL8ekMJTmZz7hTGjg4/bALqUZU+kMCsh3aWxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezl71945hwdnf1Iahw6K2BK+nuP7D6d7D8ptZ9mlSLZ7kqxak9qsI/kbpvs22Aj5T
         jXDDaC6X2lA5hM0HFbtMByvbYtQ0IrAfeidD8ut4TDXSTSZekJz6pXSlPr1OrQB1Ax
         21joaN26D+QBcvyEF0LPdoefHw5qZ1Yse66+w5aSfYWSjYDZwxVPODuLUWPFa9g8o9
         HcIsDPP3YHKN5OjLeAjFaX5S80el6rAPyVfAsWilx1yH1MQEVJ4htIg2csSHMXy4Zp
         9MEVSU28dB/BRW29xacgY+xG1/Xq8ppIUpZHZ6ZAbMxGkt8y9rCLWcO/i5jvq4AjH6
         ccto0Jw3Z93Jg==
Date:   Thu, 13 Jan 2022 20:21:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] net: apple: mace: Fix build since dev_addr
 constification
Message-ID: <20220113202137.65ea4d41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220114031252.2419042-1-mpe@ellerman.id.au>
References: <20220114031252.2419042-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 14:12:52 +1100 Michael Ellerman wrote:
> Since commit adeef3e32146 ("net: constify netdev->dev_addr") the mace
> driver no longer builds with various errors (pmac32_defconfig):
>=20
>   linux/drivers/net/ethernet/apple/mace.c: In function =E2=80=98mace_prob=
e=E2=80=99:
>   linux/drivers/net/ethernet/apple/mace.c:170:20: error: assignment of re=
ad-only location =E2=80=98*(dev->dev_addr + (sizetype)j)=E2=80=99
>     170 |   dev->dev_addr[j] =3D rev ? bitrev8(addr[j]): addr[j];
>         |                    ^
>   linux/drivers/net/ethernet/apple/mace.c: In function =E2=80=98mace_rese=
t=E2=80=99:
>   linux/drivers/net/ethernet/apple/mace.c:349:32: warning: passing argume=
nt 2 of =E2=80=98__mace_set_address=E2=80=99 discards =E2=80=98const=E2=80=
=99 qualifier from pointer target type
>     349 |     __mace_set_address(dev, dev->dev_addr);
>         |                             ~~~^~~~~~~~~~
>   linux/drivers/net/ethernet/apple/mace.c:93:62: note: expected =E2=80=98=
void *=E2=80=99 but argument is of type =E2=80=98const unsigned char *=E2=
=80=99
>      93 | static void __mace_set_address(struct net_device *dev, void *ad=
dr);
>         |                                                        ~~~~~~^~=
~~
>   linux/drivers/net/ethernet/apple/mace.c: In function =E2=80=98__mace_se=
t_address=E2=80=99:
>   linux/drivers/net/ethernet/apple/mace.c:388:36: error: assignment of re=
ad-only location =E2=80=98*(dev->dev_addr + (sizetype)i)=E2=80=99
>     388 |  out_8(&mb->padr, dev->dev_addr[i] =3D p[i]);
>         |                                    ^
>=20
> Fix it by making the modifications to a local macaddr variable and then
> passing that to eth_hw_addr_set(), as well as adding some missing const
> qualifiers.
>=20
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
