Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642642A212E
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgKATys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:54:48 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:56296 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgKATyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:54:47 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 43C308195C;
        Sun,  1 Nov 2020 22:54:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blackbox.su;
        s=201811; t=1604260488;
        bh=oNZMqbgbsDMWxKYkOfEGxb9tRrpD4bAcxYCfempUXKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DB4Im3DydvbkO8IntZcKAQvHx1nDWsLQljNedXMBWp/7NORd8Ew3gx/2JXbTLyImg
         4I5k7y2vdnT7yGyM4+IQwH2AH/WL7RepfAwRR19LxRBLp6vzu35a1U5uPbPVLBv69W
         WE1j4VcfPfqtGmGfAdc1qdin2DqKqTS+aQ14hKKhQ90B8Scsv1zLtJEsgzVoFGuFV1
         aModXSN/t6E3LUX1RQFpzNSbh5/acfA6h9H5QArIQ/6tFsSPva0EniXa2LsduDi9fF
         Py7Q8VBIQ1JFm9jowY9Cj7lFW4dT4LRjm8sTHXKecI0shEnDZhpI4OykCbfWEb5MiZ
         kVJeaSCtjdInQ==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] lan743x: Fix for potential null pointer dereference
Date:   Sun, 01 Nov 2020 22:54:38 +0300
Message-ID: <145853726.prPdODYtnq@metabook>
In-Reply-To: <dabea6fc-2f2d-7864-721b-3c950265f764@web.de>
References: <20201031143619.7086-1-sbauer@blackbox.su> <dabea6fc-2f2d-7864-721b-3c950265f764@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
>=20
> * I miss a change description here.
The reason for the fix is when the device is down netdev->phydev will be NU=
LL=20
and there is no checking for this situation. So 'ethtool ethN' leads to ker=
nel=20
panic.

$ sudo ethtool eth7

[  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000=
340
[  103.510454] #PF: supervisor read access in kernel mode
[  103.510530] #PF: error_code(0x0000) - not-present page
[  103.510600] PGD 0 P4D 0=20
[  103.510635] Oops: 0000 [#1] SMP PTI
[  103.510675] CPU: 1 PID: 7182 Comm: ethtool Not tainted 5.9.0upstream+ #5
[  103.510737] Hardware name: Gigabyte Technology Co., Ltd. H110-D3/H110-D3-
CF, BIOS F24 04/11/2018
[  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
[  103.510892] Code: 00 48 85 c0 74 11 48 8b 80 40 01 00 00 48 85 c0 74 05 =
e9=20
8e 7a 6f dd b8 a1 ff ff ff c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <48> 8=
b 87=20
40 03 00 00 48 85 c0 74 11 48 8b 80 48 01 00 00 48 85 c0
[  103.511054] RSP: 0018:ffffb6cd85123cf0 EFLAGS: 00010286
[  103.511106] RAX: ffffffffc03f0d00 RBX: ffffb6cd85123d90 RCX: ffffffff9e6=
fdd20
[  103.511171] RDX: 0000000000000001 RSI: ffffb6cd85123d90 RDI: 00000000000=
00000
[  103.511237] RBP: ffff946f811b4000 R08: 0000000000001000 R09: 00000000000=
00000
[  103.511302] R10: 0000000000000000 R11: 0000000000000089 R12:=20
00007ffde92be040
[  103.511367] R13: 0000000000000005 R14: ffff946f811b4000 R15: 00000000000=
00000
[  103.511434] FS:  00007f54a9bc7740(0000) GS:ffff9470b6c80000(0000) knlGS:
0000000000000000
[  103.511508] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  103.511564] CR2: 0000000000000340 CR3: 000000011d366001 CR4:=20
00000000003706e0
[  103.511629] Call Trace:
[  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
[  103.511724]  dev_ethtool+0x1507/0x29d0
[  103.511769]  ? avc_has_extended_perms+0x17f/0x440
[  103.511820]  ? tomoyo_init_request_info+0x84/0x90
[  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
[  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
[  103.511973]  ? inet_ioctl+0x187/0x1d0
[  103.512016]  dev_ioctl+0xb5/0x560
[  103.512055]  sock_do_ioctl+0xa0/0x140
[  103.512098]  sock_ioctl+0x2cb/0x3c0
[  103.512139]  __x64_sys_ioctl+0x84/0xc0
[  103.512183]  do_syscall_64+0x33/0x80
[  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  103.512274] RIP: 0033:0x7f54a9cba427
[  103.512313] Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 =
c7=20
c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3=
d 01 f0=20
ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 f7 d8 64 89 01 48
=2E..
=2D--
So changes - is just to check a pointer for NULL;

> * Should a prefix be specified in the patch subject?
>=20
as far as I understand subject should be "[PATCH v2] lan743x: fix for poten=
tial=20
NULL pointer dereference with bare lan743x"?

ok, I've got it.

>=20
> =E2=80=A6
>=20
> > +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
>=20
> =E2=80=A6
>=20
> > @@ -809,9 +812,12 @@ static int lan743x_ethtool_set_wol(struct net_devi=
ce
> > *netdev,>=20
> >  	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
> >=20
> > -	phy_ethtool_set_wol(netdev->phydev, wol);
> > +	if (netdev->phydev)
> > +		ret =3D phy_ethtool_set_wol(netdev->phydev, wol);
> > +	else
> > +		ret =3D -EIO;
> >=20
> > -	return 0;
> > +	return ret;
> >=20
> >  }
> >  #endif /* CONFIG_PM */
>=20
> How do you think about to use the following code variant?
>=20
> +	return netdev->phydev ? phy_ethtool_set_wol(netdev->phydev, wol) : -EIO;
>=20
It will be quite shorter, thanks.

> Regards,
> Markus

                Regards.
                        Sergej.




