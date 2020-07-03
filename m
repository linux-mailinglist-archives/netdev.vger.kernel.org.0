Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F902131DB
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 04:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGCCpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 22:45:04 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:6099
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbgGCCpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 22:45:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtKQ1+K5stMjudn0xa1oPy7vwonQUoU9qixldhKlGfVO033eP95ta1ikMHKWWd6uXDQQm035JJfZ1LOrh+PzNuLS3v2TIdwUoPllTreQIfoBJJBxyuVwl7lfX0tH7UCuPk08NdlXRV247q/CuHFti+sAM4fH83GOlI44I/gdLrmmezJVAVu0UG1/zF0ts6xF/uDXcXA2oDif8MvereJ76B94KxlR/oL53aJyKs7dqg12Tqrucgo+qVkHp0zH0OrDbNhrzAzFbdo0jWGMIxjDryVMhwDlT3J0SmXFy1lL+cc6phW5/FpPA1fpC8yJxTNcSsvcVPPV4tWjqFG956FspQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pj46Z77rAYGrbng3hxbKwM6y8P+nlwd2ccVnnuEKRaQ=;
 b=b14PW2FjLWI+idmZlYmzdUjUSfs0FPZAa3JASBeyWjCTl5VtuePIXz6VkfbQaEfsxwfJsZkOxQCwt1kpDsM3u8gPPtX90Pm+1A0/bYME2PG4Sthe7qLOYAAHK8B+EnE2cjbBkAfydimEDo0EvDvLn7szrAmiuroziQT3GJBkDhf8dX2DutUgCFhHIf5paNrj7/KjAgrrkTe7MsuLPftwcN41czsXJGbQXqfJsz8QGY+TBDAuot4vZr/FP5sGh8tOlYuruPc0pOt6PRS5f+ljJKEUbDTfOGhD2WyFCKk4KiDsaxzA9KarmVexW5eL8x/IzQ/ZCpJ80z0rFtN/ciQHSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pj46Z77rAYGrbng3hxbKwM6y8P+nlwd2ccVnnuEKRaQ=;
 b=gCMzrCYz8Yw7bSKO8GnJYnX6MS8O56iuUwNahGJ1wjzClmth62IlJV/gpxaDGx6gxFKQmUWeoXzFOMWU88Ge0J6olDxHdhzSUyrFa66D8sf1ntASAxjPksvHq76J93+btUff+muwElO0gHZ6JfghrzP2LribbUn90UXA/GlWiEE=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB6599.eurprd04.prod.outlook.com
 (2603:10a6:20b:fd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Fri, 3 Jul
 2020 02:45:00 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.027; Fri, 3 Jul 2020
 02:45:00 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Topic: [EXT] [PATCH v2 net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Index: AQHWULN44AyVysQJHEadhKXpxbm1faj1JULA
Date:   Fri, 3 Jul 2020 02:45:00 +0000
Message-ID: <AM6PR0402MB36074BB67E6704F82D2003FBFF6A0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200702205737.8283-1-tobias@waldekranz.com>
In-Reply-To: <20200702205737.8283-1-tobias@waldekranz.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8bad59c5-3ca6-4603-0d03-08d81efb14e2
x-ms-traffictypediagnostic: AM6PR04MB6599:
x-microsoft-antispam-prvs: <AM6PR04MB6599705C054AAA2CB621B4A9FF6A0@AM6PR04MB6599.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:628;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iUbpJsY+pL228vwqZDAEGFQkrNGFa+h7y5hFGlecEC9hsKGVUHUWYia6a7kAtmeVLOjtg9OsVYEQnC8yqFRVWQYVFscd7qKqb0la3fExHJQ7gbIDmVea2HquV/sBDvSONehxkM1Xck1PX5xYDHcakq/wjtOUtC9J6HbOiPk+a/UxCeUq+Ehaxeu7Y9fvY8cuv0BZnKBEdXmUVfU1245mmSPxbQb7w8QKRg+z7nFLjpii+/Q4Y9CUtaurCPEzsgBVfQNfl+l60N33dVASdwOrmv2y6ers43Jj4U5azFeS2o331Lirud4gl288EbtYZg9yjw+uc8IAeySvNeNxeMvv6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(26005)(5660300002)(186003)(76116006)(2906002)(9686003)(83380400001)(66946007)(66556008)(52536014)(110136005)(66446008)(66476007)(4326008)(64756008)(316002)(7696005)(478600001)(6506007)(8936002)(86362001)(71200400001)(55016002)(8676002)(66574015)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QAEpdWjIR8RLMc5f329SDsnutKjrTAMIXVWaJgP0p3hG7W6maul21TLHty0vy3AHzg7dI8OnMYWLf5KCixfI6zdpawjRyCfatJktpLDX8ROtbG4c3mhd41qyx988xOVfHUQRsKk+4h2P14z4yrW2A4DkRDW1aURDkpteLvt0RHJWA+2RYA9ukmaBqJUcyLO5lkq2sjVmn4ydTy4g4GY/M8LNwwQUhkM+TkEHAQvLI/vU7CT1QpdVeVuNt+YVCkkBVs4iIsRPge/4gtvrmV/L+g9MN7JstH069vPH/mGD1FNcqQel5g4zkDzCkkzA17mEKkyD3ZSR+tLGWl2xmCBhquk4A0u0K7BSH8piRKf1GI3tW03uLViyGQ9xzIQaj6iEzCdknE2wVOtWHR/uw2TQVZ9zUdDi5EjsKgH0xHKcQn5bodOxfQN+piCEM8g1VeTN1ea9Sas/S1epwxt7rSQrMJvUw7bYqzCId3HR2x8p7psz51Lnv2PngrG4cMcCVZJX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bad59c5-3ca6-4603-0d03-08d81efb14e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 02:45:00.7779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CGBC39AZUZrDgKypEjtd2N20iNSdsU6aI/CXY5JeLqvz3v/yonrIG6i3XwqTRYxGDRyQK7XyEEzoaJ+XkL9qKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Friday, July 3, 2020 =
4:58 AM
> In the ISR, we poll the event register for the queues in need of service =
and
> then enter polled mode. After this point, the event register will never b=
e read
> again until we exit polled mode.
>=20
> In a scenario where a UDP flow is routed back out through the same interf=
ace,
> i.e. "router-on-a-stick" we'll typically only see an rx queue event initi=
ally.
> Once we start to process the incoming flow we'll be locked polled mode, b=
ut
> we'll never clean the tx rings since that event is never caught.
>=20
> Eventually the netdev watchdog will trip, causing all buffers to be dropp=
ed and
> then the process starts over again.
>=20
> Rework the NAPI poll to keep trying to consome the entire budget as long =
as
> new events are coming in, making sure to service all rx/tx queues, in pri=
ority
> order, on each pass.
>=20
> Fixes: 4d494cdc92b3 ("net: fec: change data structure to support
> multiqueue")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>=20
> v1 -> v2:
> * Always do a full pass over all rx/tx queues as soon as any event is
>   received, as suggested by David.
> * Keep dequeuing packets as long as events keep coming in and we're
>   under budget.
>=20
>  drivers/net/ethernet/freescale/fec.h      |  5 --
>  drivers/net/ethernet/freescale/fec_main.c | 94 ++++++++---------------
>  2 files changed, 31 insertions(+), 68 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec.h
> b/drivers/net/ethernet/freescale/fec.h
> index a6cdd5b61921..d8d76da51c5e 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -525,11 +525,6 @@ struct fec_enet_private {
>         unsigned int total_tx_ring_size;
>         unsigned int total_rx_ring_size;
>=20
> -       unsigned long work_tx;
> -       unsigned long work_rx;
> -       unsigned long work_ts;
> -       unsigned long work_mdio;
> -
>         struct  platform_device *pdev;
>=20
>         int     dev_id;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 2d0d313ee7c5..84589d464850 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -75,8 +75,6 @@ static void fec_enet_itr_coal_init(struct net_device
> *ndev);
>=20
>  #define DRIVER_NAME    "fec"
>=20
> -#define FEC_ENET_GET_QUQUE(_x) ((_x =3D=3D 0) ? 1 : ((_x =3D=3D 1) ? 2 :=
 0))
> -
>  /* Pause frame feild and FIFO threshold */
>  #define FEC_ENET_FCE   (1 << 5)
>  #define FEC_ENET_RSEM_V        0x84
> @@ -1248,8 +1246,6 @@ fec_enet_tx_queue(struct net_device *ndev, u16
> queue_id)
>=20
>         fep =3D netdev_priv(ndev);
>=20
> -       queue_id =3D FEC_ENET_GET_QUQUE(queue_id);
> -
>         txq =3D fep->tx_queue[queue_id];
>         /* get next bdp of dirty_tx */
>         nq =3D netdev_get_tx_queue(ndev, queue_id); @@ -1340,17
> +1336,14 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>                 writel(0, txq->bd.reg_desc_active);  }
>=20
> -static void
> -fec_enet_tx(struct net_device *ndev)
> +static void fec_enet_tx(struct net_device *ndev)
>  {
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       u16 queue_id;
> -       /* First process class A queue, then Class B and Best Effort queu=
e */
> -       for_each_set_bit(queue_id, &fep->work_tx,
> FEC_ENET_MAX_TX_QS) {
> -               clear_bit(queue_id, &fep->work_tx);
> -               fec_enet_tx_queue(ndev, queue_id);
> -       }
> -       return;
> +       int i;
> +
> +       /* Make sure that AVB queues are processed first. */
> +       for (i =3D fep->num_rx_queues - 1; i >=3D 0; i--)

In fact, you already change the queue priority comparing before.
Before: queue1 (Audio) > queue2 (video) > queue0 (best effort)
Now: queue2 (video) > queue1 (Audio) > queue0 (best effort)

Other logic seems fine, but you should run stress test to avoid any
block issue since the driver cover more than 20 imx platforms.
