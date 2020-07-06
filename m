Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE25215344
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgGFHXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 03:23:35 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:5358
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728192AbgGFHXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 03:23:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4S9b2qP1MOD65XfywnQf+oMK47eGxpmXUcp3qja7XxBp3tus27ikzJCMG9BGvPi8cOVrxLmI2HcmQGHM0vZrWFP+9puPxpR7/GO071briRjvgNjllg/70PbggyrXkS69nKFwLS14T7ULFTCwDNZwlt0PDRBxHfsjT7ik/5QO7nE+dNrDURLMsfqsWkqZwX5BtTbuEqY37lgdX2M51Bisrk9a7YWEcWAvRWMXRMaUl++4des/1VZI+xo74DU4pxYQoUeTzSbMt6KWo6tXBHQPDeMoxdUmHVZGpSh6wsvwQGY46KSai5hq89os8Zjf/pG1qrrCeRueci73F5c0VZLyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD9qiAAkTqF5eUbnSpWi4chS+v/T8m8IhczVuSEG8vg=;
 b=QArqmr5gRUFbwcdEtLyKcyvvEzOS0xY4o8STmf1DCrzyO3DRxFfyLoWkK9eLkwknOoGiR0lJVfL0xksP8IIETNdIGaAItYZhUTqVgiQYA6/BR9LAqb5JYaXOUnI9rn7PzxSmekMyGLj6Nj3c4oJBSjT0ocEXwOAuxjba6xj5VRBjDlpF+HzNavQLpkSzTKKReDnf2sdNelnp6F6Q4u0DeMzrlAGq5mo2aO1ksNw3zS71MH30ZQMqlblIu6yOlPC5KqrZkwbS1CLQizjr3BnJ3Y5n6osnnOevsRBOusakAyAkcxEe+W+y5N1oQ9e98ZHSXQmw2yIxJ4EkeRclP5NtmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HD9qiAAkTqF5eUbnSpWi4chS+v/T8m8IhczVuSEG8vg=;
 b=UbazitchMM6fA4vqOCdFoXJk1ytRgeQoxW6xM5yDcAiTMuu6bj3S58sYwFunJjI2ZaTs3DY6lXS3ahZYAa2lnixahMXVjQI5fdZMKRoVtT1O/0aREdWmeZrGUb3CYR2wlwnwgH+TejN/+BYcZMMXdseSJdlgONkqaqHJrAT7OZk=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB4728.eurprd04.prod.outlook.com
 (2603:10a6:20b:10::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Mon, 6 Jul
 2020 07:23:29 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 07:23:29 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH v3 net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Topic: [EXT] [PATCH v3 net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Index: AQHWUUPJv6WQUCTq40++mcAzQBLKBKj6KIhw
Date:   Mon, 6 Jul 2020 07:23:29 +0000
Message-ID: <AM6PR0402MB360782EE60EDE1B62809FC5EFF690@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200703141058.11320-1-tobias@waldekranz.com>
In-Reply-To: <20200703141058.11320-1-tobias@waldekranz.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb8dcddd-32f4-42df-3b51-08d8217d7b09
x-ms-traffictypediagnostic: AM6PR04MB4728:
x-microsoft-antispam-prvs: <AM6PR04MB472802FFEB1E39F126510F2AFF690@AM6PR04MB4728.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D3zHqE7MmPcUEG38tBa9n5YH6sMI7NUVLUO3AceKI2TWB3YGifwy9bNYDcSPYq+oZAKXbVlWaISDxxs4lxOs3g0ZeTNx4dBzhm6rV3Kp91gLFhR3dgeSUsxRyFWu/4DnQ41TqeKDtd62xN71ETt+vDl5UJV2cCOW3DViRkKaFk27/Y9npgBfaRSIpB7ULhqyJSJuITvVjdG2nzLYC1LZQi1lRSGr4BjGLcLKQmYow0Mi9XiKEDPidFCQjSMovTV/CfLvjQ+w1YfL/n9w2eAc1dXET8Dcu3IGltZqBlxi8sFIqa2gPEYhd00wPNVcJud+p4eDfbvqVWPBxidyMfR21w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(110136005)(2906002)(8936002)(478600001)(8676002)(4326008)(7696005)(52536014)(5660300002)(55016002)(86362001)(66574015)(26005)(186003)(6506007)(9686003)(316002)(64756008)(33656002)(83380400001)(71200400001)(66476007)(66446008)(66556008)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SvGu4rLmuSqyrC4tbo4iUtXzoGmJaUVar6A9JzBN8dCx2gT+EwNwVBo4VtrsdVoScFu0w/UD6Rjmhd7NFV4xydT04nQZeYS87y9lnYW8f9LWamjT/rU872t41GEjE9x9kG0e5VJ2nsEnk1yrTF0zBRelGA8teI9M98S3C7St4U538jPOZ8K9Mzoi3dyz4VWX5PA6DRtUlmjfqeAWMQKLxUliqc53aAf8JqoBUV+uI2xmDnVoLiau3pUmpcXOgM8Utuq0Uyh2M7zqv/U+xcM6Wbfe6gNpX4QS0x1URnuEkFRHrIXA9DvOeK/Zx/FKLpvNebtXjSigE9yx4b0/A2lUwkA1WoSv4jo5HJKVo3SJGuB3cKgenwLneMOYwpu/HnCq33pjFYaxzvdlra4fPY9FDyvZXDIiSCxTqvLJOGfz26vrl0EObrBrD7qqDEkcbURm+cGAEkjYcQj6wwre+oT6AhFWB/scJiNUZi4OkeO4TXo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8dcddd-32f4-42df-3b51-08d8217d7b09
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 07:23:29.0607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DMwPYpwgA8lP3PNOWq+FcmP1ZBS7ZsB6X2BUHHSBg2GjnO7OAc7vUILOr7OQzW2nLp4ekhQCT57qdiiazROcbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4728
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Friday, July 3, 2020 =
10:11 PM
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

Tested on imx6qp and imx8mp platforms.

Tested-by: Fugang Duan <fugang.duan@nxp.com>
Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>=20
> v2 -> v3:
> * Actually iterate over number of tx queues in the tx path, not number
>   of rx queues.
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
> index 2d0d313ee7c5..3982285ed020 100644
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
> +       for (i =3D fep->num_tx_queues - 1; i >=3D 0; i--)
> +               fec_enet_tx_queue(ndev, i);
>  }
>=20
>  static int
> @@ -1426,7 +1419,6 @@ fec_enet_rx_queue(struct net_device *ndev, int
> budget, u16 queue_id)  #ifdef CONFIG_M532x
>         flush_cache_all();
>  #endif
> -       queue_id =3D FEC_ENET_GET_QUQUE(queue_id);
>         rxq =3D fep->rx_queue[queue_id];
>=20
>         /* First, grab all of the stats for the incoming packet.
> @@ -1550,6 +1542,7 @@ fec_enet_rx_queue(struct net_device *ndev, int
> budget, u16 queue_id)
>=20
> htons(ETH_P_8021Q),
>                                                vlan_tag);
>=20
> +               skb_record_rx_queue(skb, queue_id);
>                 napi_gro_receive(&fep->napi, skb);
>=20
>                 if (is_copybreak) {
> @@ -1595,48 +1588,30 @@ fec_enet_rx_queue(struct net_device *ndev, int
> budget, u16 queue_id)
>         return pkt_received;
>  }
>=20
> -static int
> -fec_enet_rx(struct net_device *ndev, int budget)
> +static int fec_enet_rx(struct net_device *ndev, int budget)
>  {
> -       int     pkt_received =3D 0;
> -       u16     queue_id;
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> +       int i, done =3D 0;
>=20
> -       for_each_set_bit(queue_id, &fep->work_rx,
> FEC_ENET_MAX_RX_QS) {
> -               int ret;
> -
> -               ret =3D fec_enet_rx_queue(ndev,
> -                                       budget - pkt_received,
> queue_id);
> +       /* Make sure that AVB queues are processed first. */
> +       for (i =3D fep->num_rx_queues - 1; i >=3D 0; i--)
> +               done +=3D fec_enet_rx_queue(ndev, budget - done, i);
>=20
> -               if (ret < budget - pkt_received)
> -                       clear_bit(queue_id, &fep->work_rx);
> -
> -               pkt_received +=3D ret;
> -       }
> -       return pkt_received;
> +       return done;
>  }
>=20
> -static bool
> -fec_enet_collect_events(struct fec_enet_private *fep, uint int_events)
> +static bool fec_enet_collect_events(struct fec_enet_private *fep)
>  {
> -       if (int_events =3D=3D 0)
> -               return false;
> +       uint int_events;
> +
> +       int_events =3D readl(fep->hwp + FEC_IEVENT);
>=20
> -       if (int_events & FEC_ENET_RXF_0)
> -               fep->work_rx |=3D (1 << 2);
> -       if (int_events & FEC_ENET_RXF_1)
> -               fep->work_rx |=3D (1 << 0);
> -       if (int_events & FEC_ENET_RXF_2)
> -               fep->work_rx |=3D (1 << 1);
> +       /* Don't clear MDIO events, we poll for those */
> +       int_events &=3D ~FEC_ENET_MII;
>=20
> -       if (int_events & FEC_ENET_TXF_0)
> -               fep->work_tx |=3D (1 << 2);
> -       if (int_events & FEC_ENET_TXF_1)
> -               fep->work_tx |=3D (1 << 0);
> -       if (int_events & FEC_ENET_TXF_2)
> -               fep->work_tx |=3D (1 << 1);
> +       writel(int_events, fep->hwp + FEC_IEVENT);
>=20
> -       return true;
> +       return int_events !=3D 0;
>  }
>=20
>  static irqreturn_t
> @@ -1644,18 +1619,9 @@ fec_enet_interrupt(int irq, void *dev_id)  {
>         struct net_device *ndev =3D dev_id;
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       uint int_events;
>         irqreturn_t ret =3D IRQ_NONE;
>=20
> -       int_events =3D readl(fep->hwp + FEC_IEVENT);
> -
> -       /* Don't clear MDIO events, we poll for those */
> -       int_events &=3D ~FEC_ENET_MII;
> -
> -       writel(int_events, fep->hwp + FEC_IEVENT);
> -       fec_enet_collect_events(fep, int_events);
> -
> -       if ((fep->work_tx || fep->work_rx) && fep->link) {
> +       if (fec_enet_collect_events(fep) && fep->link) {
>                 ret =3D IRQ_HANDLED;
>=20
>                 if (napi_schedule_prep(&fep->napi)) { @@ -1672,17
> +1638,19 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int bud=
get)
> {
>         struct net_device *ndev =3D napi->dev;
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
> -       int pkts;
> +       int done =3D 0;
>=20
> -       pkts =3D fec_enet_rx(ndev, budget);
> -
> -       fec_enet_tx(ndev);
> +       do {
> +               done +=3D fec_enet_rx(ndev, budget - done);
> +               fec_enet_tx(ndev);
> +       } while ((done < budget) && fec_enet_collect_events(fep));
>=20
> -       if (pkts < budget) {
> -               napi_complete_done(napi, pkts);
> +       if (done < budget) {
> +               napi_complete_done(napi, done);
>                 writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
>         }
> -       return pkts;
> +
> +       return done;
>  }
>=20
>  /* ---------------------------------------------------------------------=
---- */
> --
> 2.17.1

