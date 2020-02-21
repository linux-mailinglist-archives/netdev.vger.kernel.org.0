Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA115167EA2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 14:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgBUNaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 08:30:05 -0500
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:52545
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727213AbgBUNaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 08:30:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGlu7G02+7eVdC+5vujdqfdxzLTPzu/f7zfVgoc9p5hxRA0a6zOwXweC1P8MiJZGrDEYN/AUw1Qj3qyDUMBhSVSD/0D+uORjDZVeGJ5wofSw8sRVCdXsq2/4Xsac83S7z+a/yLaS+htsn7cWaDmatSlGenlNMkPNg2zyIkpKZNLsvnwecY0AUQVbKMRK2gsxfl4YJFjKBB/HEBftUhZi7uEnbEVNNvO/zIw4+VJ7uwKSkNrPHn2dMFN6nktuKX3BO1yCgqXzapNfitq2/WO2LBpaiE/x9fqZN6sbVJ2O6ud1uEXICZ1A3p4BlbCwe+R9oED4L1VB+NSJ38SKZt5HDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2lG73Dfc9pfN5uo2c0xlXXVl4G5Z7jyD3WkW2m+CuA=;
 b=OjcfPAFiEPJO9Waopdisj2CnwThsgIgIOX4QtaLJlnDOJKD2KYZTjWaoY3U3l2KZNLvLzdrHFLQ7RwacexlMMg1Bcyq95vYR757LNq9jc/yPsLvg29epSptPhpXJUQc3sziaEP+OuUI0eyyTKMqB9dJkh5QxKadlpWhqC5MgldzDpY7cNibgHKOF1+WvPnq+HycEGi0ntdT9e88c18+74iCC6i/47nIYGMhPC52ofAwmc+YInGdB7aGeZS2bH1sln9s1EbSyApwC/6g3J6GzRhDF0YEYx1WCpaBpWrlteaixkdJEz0yFnH4AXyoDkUR6CUo6G2yM5oIOMMZSQ02Exw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2lG73Dfc9pfN5uo2c0xlXXVl4G5Z7jyD3WkW2m+CuA=;
 b=jFP4gHowMN8zEWX14V6q9gnu6hV4N+LkKWWfPqKKgY9m2z2rK0ztxWGkX5aeWvunTagDEx7elkJWFb3I/KzvMO7zJVFsy+BRVwSbNH4Wusv2ZsrcCcd+vIFetu0CCzoKPTwUCso742iiIwebeQTrMG8zB/MuO3WqRnpB68GTsbM=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5392.eurprd05.prod.outlook.com (20.177.201.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 21 Feb 2020 13:30:01 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 13:30:01 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0046.namprd02.prod.outlook.com (2603:10b6:207:3d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 13:30:00 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j58NP-0008Cb-9D; Fri, 21 Feb 2020 09:29:55 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix header guard in rsc_dump.h
Thread-Topic: [PATCH net-next] net/mlx5: Fix header guard in rsc_dump.h
Thread-Index: AQHV6LsE8xwjf/8iO0OS/aKAEPk75Q==
Date:   Fri, 21 Feb 2020 13:30:00 +0000
Message-ID: <20200221132955.GG31668@ziepe.ca>
References: <20200221052437.2884-1-natechancellor@gmail.com>
In-Reply-To: <20200221052437.2884-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a54afecd-6743-4f9b-899c-08d7b6d226e1
x-ms-traffictypediagnostic: VI1PR05MB5392:|VI1PR05MB5392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5392E510BFA3FCAFA044A067CF120@VI1PR05MB5392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:38;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(396003)(39850400004)(366004)(189003)(199004)(64756008)(4326008)(66556008)(66476007)(52116002)(5660300002)(66446008)(4744005)(26005)(186003)(6916009)(71200400001)(9686003)(6666004)(478600001)(66946007)(1076003)(8676002)(81156014)(8936002)(81166006)(33656002)(86362001)(9786002)(316002)(36756003)(54906003)(2906002)(9746002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5392;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1AGz9pcePRLGylvwO/satUiJ+bKfP5JBpECL7xVOTrMrSO4SXOIaMwTkoEGTR+PDQPm3ZL0ygQZ7S9eKw0kF5jikRhMWig+hKFWsOEM/rcu0muhrdKyDaLuZwYgPpsKAoPDF+S7GM/b7bB9ydgp071hnE+yQRrvv7ec0p4KcOp8n7MfMpQh1+CC4I2tXtwLLfJK7eHVT7PhX9RtpdMz4gQEchyuKUN7mDS4zvadwzKHyjlYYRbq0/W7RcsyJNQLtRupJMJa0nnbVZ7obVvhWdL0H7DSuOdBK2d9eyoCV0UGp+/Wg4T9hMwQDGQwSRHuQ9zNIiasj74wCw45qwcjVHsdjKQrwgBdD/Tv5vPz8PX1RSyeYAyJ9q1yI0wDb7bfyfGF6oGX7oQ+FdN0SpRiz4TTZoE8MpqsLq90Y+BR4xz0/Y8Yl88T7WCUIlZGJ+TakZ21o0lhgiZwWkSYzvLc3H1QF/e4GHoXyrUXLa/uGbq8nHMdX5yZwfyxGGtQILs9k
x-ms-exchange-antispam-messagedata: ivPDiEgcpKZJYKSOIwatorFmjCqfs9P21oVV2A+ei5D5qGOFUbFRUv0SGUwTS2cPEOiT/fl1Cbg7r9Y9eT6RuS8gGsP1gNgF7SWLI5KWf5YCJUbAtc76/Rj9+BK2dEJ2/JrrCccQYgYGDX9Hw1nQKw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <48F8E0500442464EACAB3B57E17FCEF9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54afecd-6743-4f9b-899c-08d7b6d226e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 13:30:01.0345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izA57u8IGLIut9rYxTsq7q4UxIUNwEAa0S1TAghrF2OCm+c4IZwSFCY/8u3NW/4uEAiIOd4sChBLEIhECoFJbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 10:24:37PM -0700, Nathan Chancellor wrote:
> Clang warns:
>=20
>  In file included from
>  ../drivers/net/ethernet/mellanox/mlx5/core/main.c:73:
>  ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:4:9: warning:
>  '__MLX5_RSC_DUMP_H' is used as a header guard here, followed by #define
>  of a different macro [-Wheader-guard]
>  #ifndef __MLX5_RSC_DUMP_H
>          ^~~~~~~~~~~~~~~~~
>  ../drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h:5:9: note:
>  '__MLX5_RSC_DUMP__H' is defined here; did you mean '__MLX5_RSC_DUMP_H'?
>  #define __MLX5_RSC_DUMP__H
>          ^~~~~~~~~~~~~~~~~~
>          __MLX5_RSC_DUMP_H
>  1 warning generated.

Wow, that is a neat warning

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
