Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946DB3F6364
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhHXQw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42778 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232862AbhHXQwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O7c7dB001614;
        Tue, 24 Aug 2021 09:51:58 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0b-0016f401.pphosted.com with ESMTP id 3amkrkbtjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 09:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czAfMb0AwPnBj2JVIrDRau8L33UOUOK15XONVbpelNmZ7G34UQTHj1EFN1w+7CnaeHMNpGWu2sDngQW655+zHs0IpY4drh6HkYuao58+GifgDMvvqWDKt+xEknuCgsQ8bSzlB0/dhRZVEKdrQopj/FnmzPtdbBhA+/9gst1TCwi1l8pXyY1LCcAJha9gzfcy6hjOJ/GFHSC1ggbtx2+0zJxh5l10tvoOg5h9qqGAsby1wJv+PDbwb08SaJqSfMA2H6WNeWEA0aLJoJon5QdPExFEKiGAlzokIoktXonaJ+Fz8Yv3t29Xnjz4pcPJ/54+RKnKd7d+vgTPj7ttAzvRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKAc/sib8ICeu1v/im8JhK0QCORsA7jtiVGn75aZW78=;
 b=F7GsmEgfJ4t7Lzjy8qGQNfxRmD4hrwmuAxpNRoJSmNzzDBDLE0JkloOSAGKupNYwTqFdtHLFNlMJ4oV2nMkuTfWBbhJmCW43gqVufwuF8hlJTlOqfiFJHuo/lMCTl9nun2/iGUpP9n9oYjNmP877eThQ+no405ECrXHkCbrSghm7U/fIAOEQBF1aoA3AtYEHcvM9YNFsG5yBF17lczfUM5UlLndrdIK4WC0gGRYa8Hrm7TLPWquBDKSgabuEnSEiD+Y1I9QOnXCFf3AhH26oNpCD6W+QzdGAPfV4+IkeQ76gHXf9C1pLF9+hDHM7RcxsWVdpn1CfXM+5ioCuvyw/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKAc/sib8ICeu1v/im8JhK0QCORsA7jtiVGn75aZW78=;
 b=vHGngrrceGG/uEJy1M5OzOidhkIBKUa+GTngkwCigWqEo152yj97f15/a8+u97iPtsaCLNjxDaedDgIDin4A2N4TB7tCEuV9qL521HJJRl0ajZCmt7EgqBEnfw+IsyLMGdPQrDvEyqcJTfCu5lWZxWHSPqIusUNd1z/xPrNDpnE=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2357.namprd18.prod.outlook.com (2603:10b6:a03:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 16:51:56 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184%4]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 16:51:56 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v2 43/63] net: qede: Use memset_startat() for counters
Thread-Topic: [PATCH v2 43/63] net: qede: Use memset_startat() for counters
Thread-Index: AdeZBCugI6aPxGdIRAaponLK1gPaLw==
Date:   Tue, 24 Aug 2021 16:51:55 +0000
Message-ID: <SJ0PR18MB3882AEDD1D855866DFE7AC00CCC59@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26aacfcf-831e-4bb7-9721-08d9671f7b6a
x-ms-traffictypediagnostic: BYAPR18MB2357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB23579C10D306910C29F001D2CCC59@BYAPR18MB2357.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHuhiTw6XfRX+jE5RnJTmtGoHwVl8zqhT3XIsN37LDr9qdxIWuLpoCDEzSWFR0KwbZJbxQ8PFiE6rsKeNnzXIF64J/MnPfIix/j+j1avxYIauL5ml6ErtFg8A1njP7iRopMWNo47gYLHClKRauiOCiKilwCp8Q3C+W9LbPF3jGpYAxisxbbGJfG0YjGE7Qrjks5ANfv42Npq79Thqcn2rXzINb/UvfROqRPQrWUceaOshvshNi7duxa/lbEwAhz6QL6NXr5Q/HbTM+zAk3mA8MUe+s3hC7XYnsVPBfRcqUnN5IFiv7GDbfUHIE0fkXpsrbTbu/wu63uO1Oq6oBClfFsKjSQ/jiaaCKeQ4E64HPbQlesSYlowLq6/n+54GvXOuRWlnbacYQKjU+flvgjFhS870xf4AANbjZkjrCI/y+Eb1FT0A23PgNne6DRlTlY77Px3U81QQHVIzQveFVQhUNVZRfL6zPphOGaKr9eF4ClcQVHkCzPWoF3XTvUz6d5YsuXiwH/N3qATF4gPsJqqW7zJoVrUbhQo9o2pAEnbCJ6KHyiBuba5cXvCbyGsHQecj46bdJTp0AWm2lX8nt3dvrDwqSn80vgi+RU4Zf1TOpyku8ZTT39yc3FIuAUwlJ4nxGqVIeIgBJekIug6VSwSJbrExj2PEUr+u1uKaFEQp/b8J/7wb0X7YrEy5bITXcXNTFojS44qu20qvgga2EejEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(38100700002)(33656002)(64756008)(38070700005)(6506007)(66446008)(5660300002)(7696005)(83380400001)(478600001)(76116006)(186003)(26005)(110136005)(52536014)(55016002)(9686003)(8676002)(8936002)(122000001)(2906002)(7416002)(4326008)(54906003)(316002)(66476007)(66556008)(86362001)(66946007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qJK/dfG8HcfFlGtkPt/SZjGfzn+hzFe7qIZ/x8NuF4k2D5+jaVmgA1Z/f+Lc?=
 =?us-ascii?Q?s2rdrMcLA++2Sk1yf1rC8/L2a99pgjri9eNQW8DbbRRC+nW1WERrvhpefVUP?=
 =?us-ascii?Q?C9TwVTYOh7qeGmqMitTWmRmhlImiw7GbBp5jDZrGtcqnIKMlcmBn0XFe3vcE?=
 =?us-ascii?Q?nLvMIrx8j6v4DnvJZU7OrDWnO8Zi6oxvqLArX08I+xHbLWHya0xypPfbfxxG?=
 =?us-ascii?Q?FQqmekGdo/WBGvfzbD+LLuFonp2pKyXcJRx7ChslxPQjR+G2ermVaGZyNtdl?=
 =?us-ascii?Q?JGe3QdHXaf5H9G2SVtAPvmlBpn0+DBGJc/MlI0SBMMxClIWONz/3k5Ka8uvW?=
 =?us-ascii?Q?Kr4yIezPBuHquSiWyRFfOpBvFgHqIxOWoBRVIUg+wd+rhZg3WnvprJqZ3bvi?=
 =?us-ascii?Q?tdf7TsuKfbsfLwlP4GXztXouEO0HookJvj05PmG8tgF4p8CivqNCdzYK+34i?=
 =?us-ascii?Q?RBDIHzhX6lVgoiZWxh5smxUSCUxial0o4l0Lo3zAeH2G2goV5OcMgNebJ4X/?=
 =?us-ascii?Q?jnah8+cHW0Qv4/PnrV/4BzCti1vi4UgzGbawuC2lhtNU5AhW0CwCeFI/+Df+?=
 =?us-ascii?Q?9/L5+KXKki0QxcTJrsm3IPic6zEUp38luXTu96fg3W+A3wu07Gb18VMDfzpl?=
 =?us-ascii?Q?BaW3qLimrgRON8RcMN/t6P38LYQnl56IrSBzFmtSfkLscXn31GIslw6DnmNM?=
 =?us-ascii?Q?j9+rDb1LVk1Pm9mWrsS54L4Ioyg4lkRiPSsPODHXg2pd+DX5sIoJxUYqG6D9?=
 =?us-ascii?Q?hZnAWgfbwF6GMpYNU0gUNEAK7/MNcHFfkge7zZQS6G9R1MjqO2cSzJEJLuxU?=
 =?us-ascii?Q?W7BRuN4s6sxmUE78xNHDR+OgR9aKRdkogwNqPLZnPbi1Qiy8z7Ma60BW9Adb?=
 =?us-ascii?Q?sAOpEzVvKcry8bj3BDMAQQOc1H1aMStgbRatTMsAnlR1Qzs6co51rZIWFDZg?=
 =?us-ascii?Q?h5ZHx8KY8ALctH+pD4LNUX9HqfR8otm5tNMwc0peRKj9tIGc+7oKa2jRc4Hn?=
 =?us-ascii?Q?WqXdD44qCuXgTHMVl5sb9bvCBozwRTBo+5K0ELhj/Jz29/6CSw29rjabQGW7?=
 =?us-ascii?Q?iekHTe8ggUdSHdVhWqSlRSAVV0Ufwy+NMqwlCFn8ZHsi5YgXTjNfmRPrb9cS?=
 =?us-ascii?Q?2QOgYWmz/6eO9O/wtKQCFQolvRa30H6tl8xi2NuBOOwaZ3R3A9VDXoWsC6z8?=
 =?us-ascii?Q?ojLMixE0dgpUntBVpXgt/lkaGiC8Gi6h0sDpyClEk9UKk1zd0c/qpZWLRW2F?=
 =?us-ascii?Q?RrM54slvMrjDlCFrKOf4OayWRiXzcn1TlEVaZJIDulAlm7UzOPz1M67wTPSw?=
 =?us-ascii?Q?P/B6srbyxZiEjZUGLpijntM/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26aacfcf-831e-4bb7-9721-08d9671f7b6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 16:51:55.9904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YodOmbgsWUOIyimZguZIW1V6PLbduYypyHuaJWcJUluqg3MLJQoB+QZdkw8tOD8YNzaaPhtWnCy2WveA9ATlrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2357
X-Proofpoint-GUID: 2qz3__2YNzO1xVZPNRbqpM4Jgj5emVW-
X-Proofpoint-ORIG-GUID: 2qz3__2YNzO1xVZPNRbqpM4Jgj5emVW-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-24_05,2021-08-24_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On August 18, 2021 9:05 AM -0300, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>=20
> Use memset_startat() so memset() doesn't get confused about writing
> beyond the destination member that is intended to be the starting point
> of zeroing through the end of the struct.
>=20
> The old code was doing the wrong thing: it starts from the second member
> and writes beyond int_info, clobbering qede_lock:
>=20
> struct qede_dev {
> 	...
>         struct qed_int_info             int_info;
>=20
>         /* Smaller private variant of the RTNL lock */
>         struct mutex                    qede_lock;
> 	...
>=20
> struct qed_int_info {
>         struct msix_entry       *msix;
>         u8                      msix_cnt;
>=20
>         /* This should be updated by the protocol driver */
>         u8                      used_cnt;
> };
>=20
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index d400e9b235bf..0ed9a0c8452c 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -2419,7 +2419,7 @@ static int qede_load(struct qede_dev *edev, enum
> qede_load_mode mode,
>  	goto out;
>  err4:
>  	qede_sync_free_irqs(edev);
> -	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
> +	memset_startat(&edev->int_info, 0, msix_cnt);

As I commented on V1:
"[PATCH 42/64] net: qede: Use memset_after() for counters",
the memset is redundant and it should clear only the msix_cnt.

We will fix it.

>  err3:
>  	qede_napi_disable_remove(edev);
>  err2:
> --
> 2.30.2

