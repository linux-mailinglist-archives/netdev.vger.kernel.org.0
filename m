Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E34E482154
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242516AbhLaBt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:49:58 -0500
Received: from mail-dm6nam08on2069.outbound.protection.outlook.com ([40.107.102.69]:16160
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229890AbhLaBt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 20:49:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFqzpZb98Jh/PmXO4o9wp0YPohpIYhieeIrD9iwcLJZtDVGb+DfxxFuLN3ya06G08tBlFtF53wQ4PXOhGOSSpMsU0xd86fdh8D7iM75+bGha7usQsD0xK/xrgA7S0HEZm5XxEzBspWfT86jd1LLxJCmSyXhviORRgl4Sy9KHia1wMZGGL9uIKd88DQH3ybVb61NbgEKmOYOmIRcDAxfXHPaPy6CcYdKdHYOq1Z4VGtUP4+Esfm5X9BiowoaThxj0J7I7GaSJnBEnk69fNb4npI1se+TMTefkcAPwKzMQg2VEIwi3u8LuNbJpF5+Gluk0U4QTujnwguHfNDe7xeCsHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ntI4lkQvjtL3vhgywJ5GHmCUGx3u/XryuVrZaQFWdpM=;
 b=HOXEAmBHOUfGQo6qHMJZpQV5laEusFoCaqlryDxR8Eph+uKClIGIwfjVLbLaRPjhZx7OLB2hMsKH7VOQx/LGntK1pSsOI0MAZ0TjSOmwyIbz8h//PTQQUKLxl0YHN1U4zijKgL6Q0B4auE0zFeArzvwNWkIBiMMMvte4GpZzDcGTtNJnom0TdQWWleXjEqPbOlQyI9ml8H1Ol42hmFkhoOxbJiJo5SOa/w0uMhnP0ol52/LOr08G7T9n+dyK9YI4efAuZUvEa0FTCXdMXlZMdivl+p8v79OaDRYLnEpJoW07EYGk1dmmRVe/ZkHZnHgBFr7K0XgyTEwdiGohB5lOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntI4lkQvjtL3vhgywJ5GHmCUGx3u/XryuVrZaQFWdpM=;
 b=A+j/AT7AmKyH4tDnEz4cKkEWpdPbTY2iPcIU7Ms6LnY999vHrdVOZMpCVn4nLoY2iftJL5dYp331n4mBbWU0mHchlYDjv2RqVKOFUQx0w8CZr0frg09NbATVLnKxzIzcFFoxCJruuX0QO5oB6yybk/OZaBBcf1P2iyJK0rbgRfUQ4yKXRVSN1VmCNbhPRdVbeuK/gzYXzw27jMn+06yJL/AWjrXYoR/f+2xcolax7AAOLJ3uiYX1MSiNkPhEk5OJ2c/Wg5SGqXOTHwVtkUX9J6PnYiaSnsdfMNiA64JaZ/aBXpptXZ30CBsbmSrVuufq/zsXWz20lv6sYAcVtq0VgA==
Received: from MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25)
 by MWHPR12MB1486.namprd12.prod.outlook.com (2603:10b6:301:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Fri, 31 Dec
 2021 01:49:55 +0000
Received: from MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::9c0d:5311:e246:2be6]) by MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::9c0d:5311:e246:2be6%7]) with mapi id 15.20.4844.013; Fri, 31 Dec 2021
 01:49:54 +0000
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next  07/16] net/mlx5: DR, Add support for dumping steering
 info
Thread-Topic: [net-next  07/16] net/mlx5: DR, Add support for dumping steering
 info
Thread-Index: AQHX/HzVEbuXNicCrEuBCpMFakiqA6xKTaEAgAGKGTA=
Date:   Fri, 31 Dec 2021 01:49:54 +0000
Message-ID: <MW2PR12MB2489C8551828CFE500F4492EC0469@MW2PR12MB2489.namprd12.prod.outlook.com>
References: <20211229062502.24111-1-saeed@kernel.org>
        <20211229062502.24111-8-saeed@kernel.org>
 <20211229181650.33978893@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211229181650.33978893@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f7ca4c9-8f00-46c7-e046-08d9cbffd7d5
x-ms-traffictypediagnostic: MWHPR12MB1486:EE_
x-microsoft-antispam-prvs: <MWHPR12MB14863B6BF04CC62CE7946B1BC0469@MWHPR12MB1486.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ahrQcw6ldsaN8BVCHq9mpCNJ/0yrsmbKzi4XHVDYjGYV6Te285CHaVBZc3T/pP+eTvyTHkQumEjU7I1Nbj/vpxPByDNfAW/0X7vOX/scVFDQVIp/Ff1+TP7LAIWEjeYuluuuAl/nOwc9Ht05MBQeC0Uq++qNcwJSr7kgFYxoB8IrRJeAJo+7sRYhQ8PaNppc+AJZ5kDBm9V6711+KzKRZCE4RbalCEM7Z6/kJfc0JCo26fg/8pOD+PX0KION/Fcx2CuqMAHvf5GFM/HVvV1dZAoa4xv1tn+9fsK/w69kTH53B7IOlFiw5Zom3RCBW9lfg7Ciil4tdpZq6XmfSiz91H42JwoX0AOfHgrvIraknWzE9B1mb+SC1hJfQM0/Rn9tHVbPaJNIie1upFNlFdUizsNdzzMrmtYVeTPhg9LdlBu0eJNgtf8DAG99NNw8MuZ6Qvr/PbPOqpmGFahNnuuQzIupq8boulNaCBTpbhxnQJivlJ4xCZf89S9TI651+HQPfpe/qmdSDgjpv+BNHVcFwFcA+km4SkybOvZQUCoufw1DixSm9Tg5XODMDcYpVjqowNexC3XGui5cT8N6Vm3qe+HyNRC7I4AQcfO4ZLMeByH6qzXEqI+hAzWrAtR6m62UwJq5WudMzlh6QXEHgBF2/Cqcs8AOP9TErU1UmWT6nJkXuA2ZCzrbh/al0kSHqC3TNvSXaM42IMt/P7v9i155r5jSHYWE7+0KPuJ1m3rm/m7QcUMc544ikd/LwEVexB0C5h5+cMqlsccgFQ34TABf6+zyd+OJIH/fMZRtH6RpvHA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(508600001)(71200400001)(38070700005)(966005)(86362001)(7696005)(110136005)(2906002)(4326008)(107886003)(122000001)(33656002)(9686003)(55016003)(5660300002)(26005)(55236004)(38100700002)(66446008)(66476007)(66556008)(64756008)(76116006)(186003)(52536014)(316002)(8936002)(66946007)(83380400001)(8676002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HynDKza1uJqWsgMTMvydvWNPQHdmAy+JYDbmNIwJRXeFR8hBpsrW4miHeiOG?=
 =?us-ascii?Q?MTvdY2XPZrIpyFUmR4Tlw2DPmkPoxtMd5XSiuUfstQtLDP5RcNFJVPYZulEX?=
 =?us-ascii?Q?T4Nc2ALKaHuSJvNvX8go5ZpjGuJkcPh8zQztnrCsGwxCTD4LPT7WROs2a3ff?=
 =?us-ascii?Q?ed9hWXT5DMQxPr8kwD6xDzIRI1h9YErAcC44qKrIuswkgD2i6rOt2oAAG5kv?=
 =?us-ascii?Q?/mgJAH2F6kkYQEHB7nh/OZWO9N6kBPLIibJ8IdJ14OXwmiQMyQn71OE2ol4c?=
 =?us-ascii?Q?u0WgIaQ3dSVMnQJc07V6jxN26M7ORV+XKYy3jQ0UCRl4m8ZP/g3aT4TKAJ5+?=
 =?us-ascii?Q?4spRlHyyq00Ts7MiukPNB9DHVz04AfEd3n+CnXeYh4dSZQ5QevIxptxI2Lrs?=
 =?us-ascii?Q?3yT5TAc9hi7CH/doIrOtCPdorPts87o5wQNqnrszGIr404ZH8gNT6Q8F1nCG?=
 =?us-ascii?Q?kPaXTJQ1Kmkcbw4WHiD+iahBpDBFMFPb2jr6LIDqtvybOK+5VZbz5rhWs2cw?=
 =?us-ascii?Q?hkQQjpyGa5rM9KdansaVM1M+K8lpkAabAtILpr9I4v6mmk14Rx3kOZ2GA5Q6?=
 =?us-ascii?Q?9Kl2uV+VAq0j22rTu5qODSarbRBcwabLLJu9OxB5jtcTPSGnJGtlUnFCYc4Z?=
 =?us-ascii?Q?IrQBagylNleSJ29n1//yNwmHegTT6Sx9UQVON0/affMoEBUmk9V/gVMq7l4E?=
 =?us-ascii?Q?trX3LAfvMeXTbGyKkCxTlok3vFTnLWyRw9hJz1slL43Bxqfej8/3AxWO4UNO?=
 =?us-ascii?Q?tG+VnfirNHw5ANeukahJIqKosKqGlLUzFoRy7kjPISPxiimQKatOjQpNOOFj?=
 =?us-ascii?Q?qqS+rVQCPcEJEE1AIM2VBN4orTGZaV0l3BiqyJDrCy+GQM09nR6xqKqPAd90?=
 =?us-ascii?Q?LWjYalYyJG4v/E0mExiewU87lOf8263b6fhy/pw2vOy0AszEeKwCNX6U8WwV?=
 =?us-ascii?Q?K8rAMnVGvelPFr1HUXTC5utoKsfzuqnUcob7kcuzzhB7PzTuaH7DF+BJdJww?=
 =?us-ascii?Q?wDU2Fa6Lyk+g9Y/MDryw/EjhDSR2g4Vbku4/XJmgMs7fP6At6Bmxa52dOcmW?=
 =?us-ascii?Q?fC8PtqmKsicN8hYSNgmhrQMgABabNdiKIlbhT0ymE8STwO2hWJ4b8o9lhXnW?=
 =?us-ascii?Q?m0zbduAh/ljYHqL8MmPOSqDz2i72eqdxB6CZPE/Yz5EdrvPopaTu7a2AISdL?=
 =?us-ascii?Q?olPpIChLk1UBAxXbXnrkSjfSGW+o0vK4i1mBSlYSN1uhwOKRtnGLQzDcwd67?=
 =?us-ascii?Q?LifvqHkptSE6Zkp6ZH8CNGJgOYjZoJ19F5CW+o6hK2AcIeesS/iIO54CAeNv?=
 =?us-ascii?Q?c5WaaMcJjjLxoRpXiEM3l3TSr3eC2E2L89XQNAkyCwmIGzt2mYeu6Nu2epRy?=
 =?us-ascii?Q?ovUcsPyZTPhMq42EgeKbK5ha5Z6sin7sv8dq2mORtZlfyDiH5YWDO0q1UjW4?=
 =?us-ascii?Q?uZVX+CbxAa7Qu3Ybdxt5OiZTwzWfgp3nMIaNjBibi4nmZOWNprS1MgVuLqSP?=
 =?us-ascii?Q?stpsA/+eS9xmFBRbSu4d+RtSUwNgCI3dgjBqSlwjniCpvnq3GhU2SeidkZ0b?=
 =?us-ascii?Q?HChR4gyTq0rwGpC7RBdaDbpNzuhifWlR78v7tPqt8mZ8rAYw6WWYScmwFqZk?=
 =?us-ascii?Q?Dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7ca4c9-8f00-46c7-e046-08d9cbffd7d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2021 01:49:54.6915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lAE+RKUZt3so+DgNnqWRZitGF4MM2NIduyxOtlb2nLjmyOKhek3bJKCf5wWcx/bHDmaZh4N92RBFXXz6g8hCEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

Thanks for the review and the comments.
V2 will be sent shortly.

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 30, 2021 04:17
>=20
> On Tue, 28 Dec 2021 22:24:53 -0800 Saeed Mahameed wrote:
> > From: Muhammad Sammar <muhammads@nvidia.com>
> >
> > Extend mlx5 debugfs support to present Software Steering resources:
> > dr_domain including it's tables, matchers and rules.
> > The interface is read-only. While dump is being presented, new steering
> rules cannot be inserted/deleted.
>=20
> Looks possibly written against debugfs API as it was a few releases ago?
> The return values have changed, see below.

It appears that you're right.
Actually, this was written based on debugfs functions documentation, where
it states that "if an error occurs, NULL will be returned"

https://www.kernel.org/doc/htmldocs/filesystems/API-debugfs-create-dir.html

Looking at the code, I see that it's no longer the case.

> > +static void
> > +dr_dump_hex_print(char *dest, u32 dest_size, char *src, u32 src_size)
> > +{
> > +     int i;
> > +
> > +     if (dest_size < 2 * src_size)
> > +             return;
> > +
> +     for (i =3D 0; i < src_size; i++)
> +             snprintf(&dest[2 * i], BUF_SIZE, "%02x", (u8)src[i]);
>=20
> bin2hex()

Good idea.

> > +}
>=20
> > +static int
> > +dr_dump_rule_mem(struct seq_file *file, struct mlx5dr_ste *ste,
> > +              bool is_rx, const u64 rule_id, u8 format_ver)
> > +{
> > +     char hw_ste_dump[BUF_SIZE] =3D {};
>=20
> seems a little wasteful to zero-init this entire buffer

Ack.

> > +void mlx5dr_dbg_init_dump(struct mlx5dr_domain *dmn)
> > +{
> > +     struct mlx5_core_dev *dev =3D dmn->mdev;
> > +     char file_name[128];
> > +
> > +     if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_FDB) {
> > +             mlx5_core_warn(dev,
> > +                            "Steering dump is not supported for NIC RX=
/TX domains\n");
> > +             return;
> > +     }
> > +
> > +     if (!dmn->dump_info.steering_debugfs) {
> > +             dmn->dump_info.steering_debugfs =3D debugfs_create_dir("s=
teering",
> > +                                                                  dev-=
>priv.dbg_root);
> > +             if (!dmn->dump_info.steering_debugfs)
>=20
> debugfs functions no longer return NULL.

Ack.
=20
> > +                     return;
> > +     }
> > +
> > +     if (!dmn->dump_info.fdb_debugfs) {
> > +             dmn->dump_info.fdb_debugfs =3D debugfs_create_dir("fdb",
> > +                                                             dmn->dump=
_info.steering_debugfs);
> > +             if (!dmn->dump_info.fdb_debugfs) {
> >=20
> > ditto, in fact you're not supposed to check the return values of these
> > functions at all, they all check if parent is an error pointer an exit
> > cleanly, so since this is a debug feature just carry on without error
> > checking

Indeed, this is true both for debugfs_create_dir and debugfs_create_file.
This makes the code much cleaner here. Thanks!

-- YK



