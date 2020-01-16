Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC013DCAE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgAPN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:57:09 -0500
Received: from mail-eopbgr00064.outbound.protection.outlook.com ([40.107.0.64]:4149
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgAPN5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:57:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrRaiU8QOzCgb9ZzHf70RnhwnScsrNGifl5g7E1kykZfgihLJ//B1zg8Lidzb9uw/L4Epe3m8Apck2lBygv3w/eMdganL0dOL017/DF5sIjJL1KPxpjY+VzpXNGJ1YFDSGfmxqf9tbgj+RuxApurw4v/9b/2BRfdxNlblHbV9EsglGMAgvvcvxnLO5vhlHJixs4mEQdKTY/ev3ru05vbZtnugSbTGg+tx5RDTKgUsUk+3Tuzrf7OnFKb4JP41ZohyCbGOWRUNy1+yvgrSsPPwVFYVjQkNj651nhuM1ShW4X/L9VuK5u4lIE3a2bxg2B2DZ1xVPQdgACxr3dsw67j2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOwLcVZKc8TbUbZwLicV1NV74FPSo9TATICmKUrjOUw=;
 b=hBqLKSvvFH7I1MaK6kD6knLdk/cOmp8a63BpwUaUOq7BZCcpz21gdmVn/GtjYPI7jnYpYhb3G0OTzwCM9d4AhGvhNcWhuyro+cTMoSPdPqHYxbwcFdCMPYD73eOQI7cBjxNgh8ighetJYY+Zi5UzAFf6nReQ4we4xqi9Fi+vs7VhtWBt2SMpu2bItmlbByIs5NPJRc2bScf5wrk9Q+34MzLudsioH4WH2H3MU1chJn9CcjlKlxcvCbwDM6lnIR3JvQXL7SgP1U6eAKrgfjV3/LTshICzCXyu2pXMnYIQ2Ax4xziJy6rX39F+fzOsEUsAf1YMUIEURwhQMjKmVaPb6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOwLcVZKc8TbUbZwLicV1NV74FPSo9TATICmKUrjOUw=;
 b=b+pUCympriR7KxWXpHNezAmvIP4tlv5djHxkMRfzG8q+RcChhjZWpi9/W1XGLT0ffdFoKnC1Pzf9M5rBHcOSNWewyN5cKTVDUEQpfDwMH3XepNkyfFoJ0VxKzhCUjZ9W0S5OcIWGlSruDa0aTM0zzxEXxI6XafJMzXd8ax3eYgg=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4669.eurprd05.prod.outlook.com (20.176.3.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 16 Jan 2020 13:57:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 13:57:05 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:208:15e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Thu, 16 Jan 2020 13:57:05 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1is5dt-0003ix-Sm; Thu, 16 Jan 2020 09:57:01 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Topic: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Index: AQHVy6FvxnMGsXYFhEqsZB6HjluKCafs3buAgAB0qIA=
Date:   Thu, 16 Jan 2020 13:57:05 +0000
Message-ID: <20200116135701.GG20978@mellanox.com>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200116065926.GD76932@unreal>
In-Reply-To: <20200116065926.GD76932@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:208:15e::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c417e9c6-b2c5-444f-46b0-08d79a8bf87a
x-ms-traffictypediagnostic: VI1PR05MB4669:|VI1PR05MB4669:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4669D267A60F9DDEFF522EEECF360@VI1PR05MB4669.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(189003)(199004)(37006003)(186003)(36756003)(4326008)(81166006)(8676002)(81156014)(71200400001)(316002)(26005)(66946007)(66446008)(66556008)(64756008)(1076003)(66476007)(4744005)(478600001)(6862004)(54906003)(2616005)(86362001)(6636002)(5660300002)(8936002)(33656002)(9786002)(2906002)(52116002)(9746002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4669;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K9Dnyaq6FiEa5LdZvTmO6KVG42aYQAvgpKf7OFiNlZUk8SDqF1ZUWDMBQKGtbWzT2PSVcoswULY4rNS02xmH2U/WQKEwjlbpQmgWBfk/xC5cfXVFevbzro8j07qOWR7AHWtiXn/D6PzztRbUOHN8ElGtqqnukQzQgvC05gXDD+JeKaTJ4fdTCJzzKEh6ZEvlyI9dYjdFAqAIEznjlurpCBd+s4Mc5OFPK8qudfHz8TndUr9ZmHJQTV+dDPv9SK0zt8jeDJ7IVr6HhWvTZ5aC2OiEnrKzBjhgEJweUrhPo8XneHwEEFGWopmClp/KBy0FRCdnFtqGRdCq7nLA3JQikYGtZ/AwCSNhHfN/pPaTO93bHvtqgTHeSI/cdu2THESB3i6/YC8o4I3TtVMw57Xf9gYxShWzCKLHMH+f4Ll0GjAOjB+Fwi3kSf2HCwDOEvow1RUhDfc4RoAKhv/cOaCnvOrFRixNNzPIVbB2av/eIfCFDJkbY8iei0ezqLa/03B6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C06D25BBED1E84C900B1F1185314F17@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c417e9c6-b2c5-444f-46b0-08d79a8bf87a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 13:57:05.7748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+gXIiM+5Yk5MmHQe278av0Yc7Ub8RxzxzBr0XPeZpz8mAjllrF8DdaaKH9G9Z7SdtgK9+Gx0n8fTDVRrFB7jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4669
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 06:59:29AM +0000, Leon Romanovsky wrote:
> >  45 files changed, 559 insertions(+), 256 deletions(-)
>=20
> Thanks Santosh for your review.
>=20
> David,
> Is it ok to route those patches through RDMA tree given the fact that
> we are touching a lot of files in drivers/infiniband/* ?
>=20
> There is no conflict between netdev and RDMA versions of RDS, but to be
> on safe side, I'll put all this code to mlx5-next tree.

Er, lets not contaminate the mlx5-next with this..

It looks like it applies clean to -rc6 so if it has to be in both
trees a clean PR against -rc5/6 is the way to do it.

Santos, do you anticipate more RDS patches this cycle?

Jason
