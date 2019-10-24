Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2FE3D50
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 22:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfJXU32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 16:29:28 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:32385
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727967AbfJXU30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 16:29:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDs3M3Hu3zy2InnV9gTOQy2+no/XgjK7DqPYmC8ccBBdBr/XUWJFSNLvI488Y55pm6kDqKtQFY/zxdXvwzav6nq0uLd+YKYzXiwQDnS7HVJHl3cHSGwU6bomv9B3YGCV2sku6Id3G1fi/V1r4WOl5J4jrk1wc7+8qkUX2gOt13rhttdv4s2GKzqOfXWwaUBEp5H+erUgFdO8ZkVPOyA/Wdcc2tcaEkKVD8PGsCyCzgk/HkDhJ4JErjFl1vwVGtKb6RgQMkdC6zFnIYCpT+scU4dn2VDxsLGg7po/RN7elb4d/HhSj89yjdX4C/BTDRGGzVUSGZFZfd02IKCwIMZN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHPXTnZ6rBkNUDLFPqPyLeqVu0Uz7Z4udfrVSlQARc=;
 b=aHkXv8XO5riHsDDSKzuMtxvsCJ8kPlf6VPQdQsg+FItVbsjI/vA+FRgt2piwho+EWnryFetPl1d0RR5b6I3QOfSb8+ryrH58GgGwpLRXcN70UqDY2yjV1g6l2jbekUzt0e1hFBr7FvUBSqujIVvhU+JG0B/EVjoPKK/5ohyIr5l9VFhqGf3FmQfRTXB2OIosUEUxXehpbrY9XvlvyGNHgIV7QddD0j7QeEtso+l6ZzCRZ+7Y7d+UFxdoXHwKVaNUaMMhmHwsjPaYVCnsvbsrg/1prxoBCzFLUb9GVi8Pwa2U0pq3lAAHkSK+n9KDj8nNWGaGI9br9SgMtJjndsPauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHPXTnZ6rBkNUDLFPqPyLeqVu0Uz7Z4udfrVSlQARc=;
 b=fdMHE+zARw0SWMgv20tYqRlN6yYBSkRV4i1o9wWuHgRCROx+8bJFoQtTO+B4xoemqXzNY4dqmIvnZru7eTAXmtjxj6aGJOuEXtJTOv05oFzmMwnQ1R07ijsFTAfEKrG6/AxbcZbT9K/E7NrQ5rApKGsoKU7QO4jtcZTTf1gzKkU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6290.eurprd05.prod.outlook.com (20.179.32.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 20:29:22 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2387.019; Thu, 24 Oct 2019
 20:29:22 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net 06/11] net/mlx5: Fix rtable reference leak
Thread-Topic: [net 06/11] net/mlx5: Fix rtable reference leak
Thread-Index: AQHViqKrx5aMHTC3aUe4gsaPKDOR/adqPauA
Date:   Thu, 24 Oct 2019 20:29:22 +0000
Message-ID: <AM0PR05MB48665232E60A046B83AC86F2D16A0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
 <20191024193819.10389-7-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-7-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22d83b46-8e6d-4d4f-40fe-08d758c0db13
x-ms-traffictypediagnostic: AM0PR05MB6290:|AM0PR05MB6290:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6290379AC56C56BBA51DBB5CD16A0@AM0PR05MB6290.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(13464003)(189003)(199004)(11346002)(86362001)(33656002)(66556008)(66946007)(66446008)(66476007)(99286004)(64756008)(76116006)(186003)(486006)(476003)(446003)(6506007)(26005)(53546011)(14454004)(71190400001)(66066001)(110136005)(76176011)(316002)(5660300002)(6436002)(52536014)(229853002)(3846002)(9686003)(6116002)(6246003)(2906002)(55016002)(74316002)(7736002)(305945005)(7696005)(102836004)(256004)(8676002)(81156014)(8936002)(81166006)(25786009)(478600001)(4326008)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6290;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJZK5vsj8jlX6g/iTYGa3USqao1KC2ght1IuvKKGmY+jK1JQKjnXVxlmBdynKB07trDEETd6s0ZShOEP7NRdtZDmkOkg/BlmfndrqogW2yL0JER6KuLwZ3EXwutJLTwGcDGn+2KDeyk54PelH+yEyxbCKKDgT6k8WnfboQ3nSp6NDwpJ8rs+pK+9Aq06zoo8ts6NrgprZfOI6S2ZcFodspXXohK7KEHLktr6sZngewqJetKB6nRKtdbhNKSMV8THXZDqSs0JtrFy7pYPnAiwYpdJJNyL4ozUBmiOD/riCsggXVfFM+DaVYvwZB0PXCmZ2shpMRR2vQZv33B60UP4f36fPjO390Z9DyyqYdJ4dz+zmNspjmpIRBeK+wlsN995xpEhWnyLjeyq8PbynFDVWfgQyp1ssDnyE18ghpP6lQ69KKwSkGcqwwT/s3QFDVrp
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d83b46-8e6d-4d4f-40fe-08d758c0db13
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 20:29:22.7072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sb0vak28xNMPjE3FE89j6ahmApDJc49jS90ST7rTIa13wETpZIR4yB0BXG2AvE/7qpoBnXcKMi+gcmuN+kAngQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6290
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Saeed Mahameed <saeedm@mellanox.com>
> Sent: Thursday, October 24, 2019 2:39 PM
> To: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>; Saeed
> Mahameed <saeedm@mellanox.com>
> Subject: [net 06/11] net/mlx5: Fix rtable reference leak
>=20
> From: Parav Pandit <parav@mellanox.com>
>=20
> If the rt entry gateway family is not AF_INET for multipath device, rtabl=
e
> reference is leaked.
> Hence, fix it by releasing the reference.
>=20
> Fixes: 5fb091e8130b ("net/mlx5e: Use hint to resolve route when in HW
> multipath mode")
> Fixes: e32ee6c78efa ("net/mlx5e: Support tunnel encap over tagged Etherne=
t")
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> index f8ee18b4da6f..13af72556987 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
> @@ -97,15 +97,19 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv
> *priv,
>  	if (ret)
>  		return ret;
>=20
> -	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family !=3D AF_INET)
> +	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family !=3D AF_INET) {
> +		ip_rt_put(rt);
>  		return -ENETUNREACH;
> +	}
>  #else
>  	return -EOPNOTSUPP;
>  #endif
>=20
>  	ret =3D get_route_and_out_devs(priv, rt->dst.dev, route_dev, out_dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		ip_rt_put(rt);
>  		return ret;
> +	}
>=20
>  	if (!(*out_ttl))
>  		*out_ttl =3D ip4_dst_hoplimit(&rt->dst); @@ -149,8 +153,10 @@
> static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
>  		*out_ttl =3D ip6_dst_hoplimit(dst);
>=20
>  	ret =3D get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dst_release(dst);
>  		return ret;
> +	}
>  #else
>  	return -EOPNOTSUPP;
>  #endif
> --
> 2.21.0

This patch is missing two RB signatures that we had in internal review.
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
