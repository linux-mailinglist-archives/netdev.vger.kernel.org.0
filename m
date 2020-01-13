Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717001393F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgAMOtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:49:50 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:18657
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbgAMOtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 09:49:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M07o4/DXcxhBi3un8YXzB4JS6MWtLuw6gkKKl3ku/+e74NdB+Usu4X8QV678jQkMOYhzb7WpVVFV3Osq3/BNpz0t+vcgAL8tAcs2geXsrkVB9hMnRa6IoxGC7FEkoDZ3O806UkyB5TDVYFknLAtmH5yFRBxmWC4eylisMd7E7r/jaQk+SnUeBvLdazDt3Ojyd+lUm9jIu35p8Ysk339jbf/tCFY+x+vN+wpWB/LtOXxqulDTe9Cqy2rVwp9z+lWiXbZVp2mZ2Tx9Zt6sZL6MRRZay8Loy9cZA4+3SaZnN3meuxFsif1zvfmmlWiiOmV0MCt8+aKMagqB4W4Ik9MrHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cZpObHY6B0VESApGlV4qduJ3OM5B2Aips0Q5xpDqE0=;
 b=EGAr3e5LL8aoWUa3JJUQ6XbUFVMJ7k40QmqPuiEtiIXuGQ9CQt4YO/r+m489d4KpAkWYVORwoA1Y5/y2GL3/sm+G7Dj4H4G15LcX/+ib18X0pUsLCupDYuhrqSzl2hn+tyeuIW3jk/ZI14bQENbzvKm0dLs4Diw+URDdRgrzo8fBcIhZWnng3NyGXHauSCWbA0jbO565cg8l2HA978M0h2tpO/J3d5vYapdF1GWLmOrv5B11iNcIltvT+SEp6HSXnLy9T13V7AvL4XC7UiiAr35VapVQT2TZ0BAoeofU/tbUywkTtNVg2TpKbyu1NHMWloYca1r+pvv3CPA2kiFvag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cZpObHY6B0VESApGlV4qduJ3OM5B2Aips0Q5xpDqE0=;
 b=Ek4459e5DmGxvGqP6PW7wdvE8SOZIvNBeijx+nSqsFFVLB+nu5DuNIZvmnse3XX8UIde5hrTklctj5IPtZ5wV+uOiIHTyDXEl1C2rwkWe6mvaR1Xku8hSu8zMcucCxfzp8jaHgnHaAh2C/HmwxORGVzzCLEW/S3eZC5DHL4nvxc=
Received: from HE1PR0501MB2249.eurprd05.prod.outlook.com (10.168.34.19) by
 HE1PR0501MB2220.eurprd05.prod.outlook.com (10.168.36.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.16; Mon, 13 Jan 2020 14:49:46 +0000
Received: from HE1PR0501MB2249.eurprd05.prod.outlook.com
 ([fe80::75b5:4765:e4d5:8501]) by HE1PR0501MB2249.eurprd05.prod.outlook.com
 ([fe80::75b5:4765:e4d5:8501%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 14:49:45 +0000
From:   Alex Vesker <valex@mellanox.com>
To:     Cengiz Can <cengiz@kernel.wtf>, Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mellanox: prevent resource leak on htbl
Thread-Topic: [PATCH] net: mellanox: prevent resource leak on htbl
Thread-Index: AQHVyhfXnbgha6qN0UO7Z+hw8A09HA==
Date:   Mon, 13 Jan 2020 14:49:45 +0000
Message-ID: <HE1PR0501MB22490CD10A5A258E8C08DE86C3350@HE1PR0501MB2249.eurprd05.prod.outlook.com>
References: <20200113134415.86110-1-cengiz@kernel.wtf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=valex@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83661a75-57e5-47c9-0b5d-08d79837d4f3
x-ms-traffictypediagnostic: HE1PR0501MB2220:|HE1PR0501MB2220:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB22200C83049DE30DC349441FC3350@HE1PR0501MB2220.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(199004)(189003)(7696005)(26005)(91956017)(110136005)(76116006)(66946007)(5660300002)(66556008)(66476007)(186003)(66446008)(64756008)(4326008)(2906002)(54906003)(316002)(478600001)(86362001)(53546011)(55016002)(6506007)(9686003)(52536014)(71200400001)(8676002)(33656002)(8936002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2220;H:HE1PR0501MB2249.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d9zFE6/1V3vaLfNdvgZCR+bMr6RxOQrWHjRGD3vHq4KdIndNBvL8LhW8Keppz5i1lyQfs3/zobtmcdBJQW+RO+CQZ8r822z01qYLuxST1VqE6wZgce1U5ZO9yuCETmeedc5Ul4EWhvuoAChBXFNfvbnIoPu0aDeCZdUja2Ume/GcohLWSwXGMHiJ9dIo2YlSj8RHr1SnqSc4JTNrEq0X2X6xMLeGG22TWVIxxbIJM5kYYREdoKMFQ7ZOKUah5J8ui6JxwieM0W0DbPelybiUt0Z+LTsPHa/fGwXD5MgH+RamH4AZF8yDzpkgFQiBxxkXe0h+gX2F+lpoVhA5NZgpM0Lkn8JwCtICvEjqnx53xFk6DXt3liNic/zozS5mnnxXg8bTshkH/AAaQVq2MJD5xeFV9H69c70/lSACSqJ3+PU2QEX7FoWwqNsGaXUiMbZc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83661a75-57e5-47c9-0b5d-08d79837d4f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 14:49:45.7336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x940VeNSu89pQS0PwPAs4vDLvoZd3mynoshJ1uPi6rz8SdR7ZwN0yCo4kd46kFLpKNzl9SyDIl4QpvC4x3pV2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2220
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/2020 3:46 PM, Cengiz Can wrote:=0A=
> According to a Coverity static analysis tool,=0A=
> `drivers/net/mellanox/mlx5/core/steering/dr_rule.c#63` leaks a=0A=
> `struct mlx5dr_ste_htbl *` named `new_htbl` while returning from=0A=
> `dr_rule_create_collision_htbl` function.=0A=
>=0A=
> A annotated snippet of the possible resource leak follows:=0A=
>=0A=
> ```=0A=
> static struct mlx5dr_ste *=0A=
> dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,=0A=
>                               struct mlx5dr_matcher_rx_tx *nic_matcher,=
=0A=
>                               u8 *hw_ste)=0A=
>    /* ... */=0A=
>    /* ... */=0A=
>=0A=
>    /* Storage is returned from allocation function mlx5dr_ste_htbl_alloc.=
 */=0A=
>    /* Assigning: new_htbl =3D storage returned from mlx5dr_ste_htbl_alloc=
(..) */=0A=
>         new_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,=0A=
>                                          DR_CHUNK_SIZE_1,=0A=
>                                          MLX5DR_STE_LU_TYPE_DONT_CARE,=0A=
>                                          0);=0A=
>    /* Condition !new_htbl, taking false branch. */=0A=
>         if (!new_htbl) {=0A=
>                 mlx5dr_dbg(dmn, "Failed allocating collision table\n");=
=0A=
>                 return NULL;=0A=
>         }=0A=
>=0A=
>         /* One and only entry, never grows */=0A=
>         ste =3D new_htbl->ste_arr;=0A=
>         mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->ic=
m_addr);=0A=
>    /* Resource new_htbl is not freed or pointed-to in mlx5dr_htbl_get */=
=0A=
>         mlx5dr_htbl_get(new_htbl);=0A=
>=0A=
>    /* Variable new_htbl going out of scope leaks the storage it points to=
. */=0A=
>         return ste;=0A=
> ```=0A=
>=0A=
> There's a caller of this function which does refcounting and free'ing by=
=0A=
> itself but that function also skips free'ing `new_htbl` due to missing=0A=
> jump to error label. (referring to `dr_rule_create_collision_entry lines=
=0A=
> 75-77. They don't jump to `free_tbl`)=0A=
>=0A=
> Added a `kfree(new_htbl)` just before returning `ste` pointer to fix the=
=0A=
> leak.=0A=
>=0A=
> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>=0A=
> ---=0A=
>=0A=
> This might be totally breaking the refcounting logic in the file so=0A=
> please provide any feedback so I can evolve this into something more=0A=
> suitable.=0A=
>=0A=
> For the record, Coverity scan id is CID 1457773.=0A=
>=0A=
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 ++=0A=
>  1 file changed, 2 insertions(+)=0A=
>=0A=
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c=0A=
> index e4cff7abb348..047b403c61db 100644=0A=
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c=0A=
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c=0A=
> @@ -60,6 +60,8 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *ma=
tcher,=0A=
>  	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr=
);=0A=
>  	mlx5dr_htbl_get(new_htbl);=0A=
>=0A=
> +	kfree(new_htbl);=0A=
> +=0A=
>  	return ste;=0A=
>  }=0A=
>=0A=
> --=0A=
> 2.24.1=0A=
>=0A=
>=0A=
The fix looks incorrect to me.=0A=
The table is pointed by each ste in the ste_arr, ste->new_htbl and being=0A=
freed on mlx5dr_htbl_put.=0A=
We tested kmemleak a few days ago and came clean.=0A=
usually coverity is not wrong, but in this case I don't see the bug...=0A=
=0A=
