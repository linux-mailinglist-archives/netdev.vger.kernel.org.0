Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335BE1796B7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:31:52 -0500
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:14657
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726748AbgCDRbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:31:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsB0KKZ0Pf6LLBNI84P/ZM6zJdXQjybmbtgDEqj9j4H3dKVRjuVe4CLSS2cwhg/mOcCx24jJr+W7y9UDVN9Q1vWgIg8BLlyyoTjjvy5LnFlWhGWzBrpxJA8nK4U1cJVnTTv6kcKqW+0zvZce0M95xXnkYFTeNP+EO6KS+YOY498QjSLG42nXJouvs7hIU5Ni0ZEDkA30L0nk6iTsEfx05ux54oheJwoMFIiq/ZhANRk/Dn1XPYwHmoLeLUKSb5AO/tlUGWKlWqYB4P+mxNjXk7aVyUQLN5Jbe4ad+CJiqaXeaUuMcV8LE6SW/px3gc8HuJ0vseRmCDzZG6XL5OKHeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUPV/JKbM9qSGqYwfahjEFdJPiV/U4v9qm5M6z2z8m4=;
 b=cTOGq/GRS8pdkQmpAjUF0ZrnlCdNyfNS/1BIGpB4iDMVhGYMyGZEBp9VW/sYAYAMhU84DwXGpcVy9dKwNflAJZYM08Ruq6RTkW0UnqVjKdwRmOE/fuE0tG9Qe1BCHHSBgyiLPWSgSKz1YejpMmxcROS4cBQAqO9kMMsE2SYCDl4ICP8ay2Mv1Tir4Vv6E/uhkwe1Ef9uXnSB3B5yxopecrg/GX1ZoG7XcxB7xfcXCgi6okSfXHleY7Eepa8f0rOtlJC0Q+WP2e/kVhMfJ4vhOdGNXeZxCkzCVau1jqZsb82KUudqbJmYxo0tG3YEVag0aV/O7KpbLrhaHHMSOmfZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUPV/JKbM9qSGqYwfahjEFdJPiV/U4v9qm5M6z2z8m4=;
 b=VpUrvN0m8qg+GKP/gHZqwI0lo3wFYEh3PzAMv6nUV4VcIuczcyMuChuhq0hI3lXi7yk6yDsL9hNTyOCgCRdVSrcL8jH2W14lPC141X6Z+TGMzuEpf2cppftkNp+r2icdVpT1rmNOSWtP3Maa8QDH6fsGV9TkEW1kEPfiAgT2pA0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5249.eurprd05.prod.outlook.com (20.178.19.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Wed, 4 Mar 2020 17:31:48 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 17:31:48 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] ionic: fix vf op lock usage
Thread-Topic: [PATCH net] ionic: fix vf op lock usage
Thread-Index: AQHV8klqMOE+hQbOjE6sz2+f5wHQrqg4sKMg
Date:   Wed, 4 Mar 2020 17:31:48 +0000
Message-ID: <AM0PR05MB48665FBFDB99A8BEEBC5182CD1E50@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200304172148.63593-1-snelson@pensando.io>
In-Reply-To: <20200304172148.63593-1-snelson@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70edda25-84c5-4b1f-6a17-08d7c061eb54
x-ms-traffictypediagnostic: AM0PR05MB5249:
x-microsoft-antispam-prvs: <AM0PR05MB5249E09CA0945194E7278120D1E50@AM0PR05MB5249.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:48;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(199004)(189003)(6506007)(64756008)(66476007)(9686003)(76116006)(66556008)(66446008)(55016002)(33656002)(186003)(7696005)(71200400001)(26005)(66946007)(316002)(81156014)(81166006)(8676002)(478600001)(110136005)(86362001)(5660300002)(52536014)(8936002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5249;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /W01X/HFRPAE79xd+xURxxfBCpmWeZSTdtH0izg9cU5iNxBhU1H5vmaRfe+x90lZio0LetTKzsn++ADn5msm39wG0wvAtge+49nO77DTZ2KON1whIVZ5cDXTtEw3ZFKNfAm0T3xi+XUsmvWG1CLqn4ynUiswmQwYsJLifSUzTwOAgy+Oe2RLlGortIZxYyLaLMpwvQY8ekg5SSBitofFaGOmgwU7KH7PD8JM9aBq33E/ek0XbuObeulmLNAYnF3n5vjUZZopx1miwAmKpEmcH3UAfA7AHegzUkG/6fu8e04Ya5NYmv19AhB7Vth0K1dlnKHF60JxK31+UH3jtsvm1/9Ab4dO0KGrI+IDaf7cHmFWwdubRTvZ5VfZ49yuhdctErOBeVsaGEec3MCn+uFe1LrqXJnx5DyZMld5SIjhwAfVMf5UNl7JsuhOZqHxdq7S
x-ms-exchange-antispam-messagedata: KyYifjjC2FFwgju0C0gwOML9CDb2CiT3U7aMl41zFcgJu5khWjfQtHwElIUGegPtfKer6yG3gvBSZDZ/ZMlZ6iDENabakoY14rAXtJBwDc2MsUcbl0vRfjk1nOG2DEdsXwYPkbyjAFoxo0hGBK7K1w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70edda25-84c5-4b1f-6a17-08d7c061eb54
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 17:31:48.7633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +N1PI7P7F0kTVpzDtHKncBqxGWHUe5kqRgHy0qtYdmm/Ut4Xy9YzQZFUxe4v9guNJMOeptAWm1z+gMVU+Zw6gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Sent: Wednesday, March 4, 2020 11:22 AM
> To: davem@davemloft.net; netdev@vger.kernel.org
> These are a couple of read locks that should be write locks.
>=20
> Fixes: commit fbb39807e9ae ("ionic: support sr-iov operations")
It should be,

Fixes: fbb39807e9ae ("ionic: support sr-iov operations")

> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 191271f6260d..c2f5b691e0fa 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1688,7 +1688,7 @@ static int ionic_set_vf_mac(struct net_device
> *netdev, int vf, u8 *mac)
>  	if (!(is_zero_ether_addr(mac) || is_valid_ether_addr(mac)))
>  		return -EINVAL;
>=20
> -	down_read(&ionic->vf_op_lock);
> +	down_write(&ionic->vf_op_lock);
>=20
>  	if (vf >=3D pci_num_vf(ionic->pdev) || !ionic->vfs) {
>  		ret =3D -EINVAL;
> @@ -1698,7 +1698,7 @@ static int ionic_set_vf_mac(struct net_device
> *netdev, int vf, u8 *mac)
>  			ether_addr_copy(ionic->vfs[vf].macaddr, mac);
>  	}
>=20
> -	up_read(&ionic->vf_op_lock);
> +	up_write(&ionic->vf_op_lock);
>  	return ret;
>  }
>=20
> @@ -1719,7 +1719,7 @@ static int ionic_set_vf_vlan(struct net_device
> *netdev, int vf, u16 vlan,
>  	if (proto !=3D htons(ETH_P_8021Q))
>  		return -EPROTONOSUPPORT;
>=20
> -	down_read(&ionic->vf_op_lock);
> +	down_write(&ionic->vf_op_lock);
>=20
>  	if (vf >=3D pci_num_vf(ionic->pdev) || !ionic->vfs) {
>  		ret =3D -EINVAL;
> @@ -1730,7 +1730,7 @@ static int ionic_set_vf_vlan(struct net_device
> *netdev, int vf, u16 vlan,
>  			ionic->vfs[vf].vlanid =3D vlan;
>  	}
>=20
> -	up_read(&ionic->vf_op_lock);
> +	up_write(&ionic->vf_op_lock);
>  	return ret;
>  }
>=20
> --
> 2.17.1

I missed to review this after Christmas break.

Reviewed-by: Parav Pandit <parav@mellanox.com>

