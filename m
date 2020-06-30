Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69EE20EE74
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgF3G2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:28:45 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:15492
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730183AbgF3G2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 02:28:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kD1D11AnZiRWJ/viKLwa00gHnjxsxfskVQxg0HXPLTQep7IaAZbMUV+BzcCKD5Grx58M9hVlkpYrYGbXjMAgqxf2fIPXVEW25+jiKAM9gF4Vh53JyULgt4uUBGXxyD+oH7tGe/yqs/Xk7hUfM658xL13lcDSOQvvmvi8S8D/v/lhe+zyMJEjtFmbrlLoJANeI+Ng+2r+lXtQDVhH7TncHkoizFpSBvOs+Wz1gc6bBwVyFl4Ti0nmFZGXqTO42u3hUnI8vezL+cKk7W4x2GE985VoZJK/RGEiISP8rV44tZxERqUW9XV33UD2PIilqbtJt0ZdGbE+YlVexUwNsJmlnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nREQFEoZ/pRFU21TyTVo/ID7wYtbCMIleuMnZcODtg4=;
 b=CdbFFlVOME2cmzGoxe3Ij5py0VvdNifrQerxYLmzSy3AXinIuUFn1iQ5cpxpLbOnYrxq3YTt4FQrMIXMSycw3mrYHmSrtC2KgokJA/NmiwWdLU3vn+Afv/HI7NVswseR0e8Wd0+7sqm7Fqt0QWFzYo4tpJlJqrtrh3ppNfYK+HWUSk9oPSDwYuUEoLEO0HgBH/LGzFqwtlt2OnjtquJApUahRq7TOsRZXK5mTm7N1ySIyn4z9BBQXEAO7wPt143k91N66qapt/b/EK8f3bK4c1An62yoX6SzENC1vIVIQQa5FYezxmqHBFPuuWOwI6eJysszrBnGM6SLr9q9qNrFow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nREQFEoZ/pRFU21TyTVo/ID7wYtbCMIleuMnZcODtg4=;
 b=sbC+J8DaO+tV12RxiE1cgvfhU90Hbnq+Uof4/bhgB/w/hCu6sMjkrRN4xm80K221bOE49hkE1A6C9JeAWgLczjAk+UatSkIAX/V80/PBAXXPTC9XSMZaE0RjA/dwM326LQpbNfQCsO94dEY2FzN/OSW+X+wo2bPCOJ0/HJedVh0=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR04MB3076.eurprd04.prod.outlook.com
 (2603:10a6:206:5::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 06:28:40 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 06:28:40 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net] net: ethernet: fec: prevent tx starvation under
 high rx load
Thread-Topic: [EXT] [PATCH net] net: ethernet: fec: prevent tx starvation
 under high rx load
Thread-Index: AQHWTknFHMHqp68YKUK5XJTc9NGIyqjwspVg
Date:   Tue, 30 Jun 2020 06:28:40 +0000
Message-ID: <AM6PR0402MB3607A57923BA5997C79E9082FF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200629191601.5169-1-tobias@waldekranz.com>
In-Reply-To: <20200629191601.5169-1-tobias@waldekranz.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12751b33-f3c2-43bd-e9f7-08d81cbed430
x-ms-traffictypediagnostic: AM5PR04MB3076:
x-microsoft-antispam-prvs: <AM5PR04MB3076D4888C980687F07BE69DFF6F0@AM5PR04MB3076.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GkmuurxHiw3j/sIc6JPzxpGYMXmmUz496BdjkYO3yiSvRVD4ZsV1duXjA366hc3HFdyqSCP2g12Xmfc9SQbHJp0N1XpMBk3ls6A2gYNQaTdiGGaOs9htiYGZTo95bqJT/VDpcOZeRBWWawJXtJcDsRd068Pw2Kbnx/SXwc+OmFk5+g6a7KRwtZyfA86XYvVsq3XkGiYW+NVZQud8HU8MvkdFQsTi+9NWKUZuX4G+ZVYyLVukzxz9C4YMNbCpOOD6onpqrYW0zbBMVe+4SBfFnFMJTmhPiL3cBnOaNu/p26DCVsYdU7jBERrZxfBwrgvZ1rlcGVUfEFbZdzuVAlzoBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(52536014)(76116006)(5660300002)(55016002)(66946007)(66446008)(64756008)(66556008)(66476007)(186003)(7696005)(6506007)(9686003)(316002)(26005)(110136005)(4326008)(71200400001)(2906002)(8676002)(8936002)(478600001)(33656002)(83380400001)(86362001)(66574015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PIO6LHm1ywKFOkFB05yqt4xuYYO1TNR6MTeYDVn70V41OUJait77VZxo7vl6vqfXEpHykjmxGj+p3v/BeXHOB8ggPbcl9KMn7zFfRyOL0Vrs9DRthXX1ScrmYu6epdUSrJ0Ij8jsPvr9hG/I9FQEYlOBHTl40sipqnzfg+vcCLR82sJNArzkg+Z8jtRpoFlKF5/hMOn90QvxxhJYeBaUFehHpimXfr4q63GEBFqYeOzP6Z0+HQfbGRMbPRA8zVJA+PLxYVVk+CjlOSIT76jUIDT/ssTt8RqZniZ8R9WdqCqNaZsBH7ALk5JK3Ec/yoeeYWRja8+D+czNfCNfiKtxewo6CW1VWs+u3i6BXNlOxsr5AHB4IChWLk3xU4/IW55bzSz2nIdBhXLa9V1QEJyV2z7SW6B/w9BhTAeyLWKXqN/kmbJw/9Zi4/niNVl27FpcsT6QgESPQjQ+ZuYSsE7Cs9niQWE7F5GVn62qHLHkM3o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12751b33-f3c2-43bd-e9f7-08d81cbed430
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 06:28:40.1466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AyAES7JuFNNriVNkueYOGa06Z8AjEkWfnUpNegdsqpoOVyDhq8aQoNGTPVZ+WDp07vmb+hQAFOE0Adrad1Abrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June 30, 202=
0 3:16 AM
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
> By adding a poll of the active events at each NAPI call, we avoid the
> starvation.
>=20
> Fixes: 4d494cdc92b3 ("net: fec: change data structure to support
> multiqueue")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 2d0d313ee7c5..f6e25c2d2c8c 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1617,8 +1617,17 @@ fec_enet_rx(struct net_device *ndev, int
> budget)  }
>=20
>  static bool
> -fec_enet_collect_events(struct fec_enet_private *fep, uint int_events)
> +fec_enet_collect_events(struct fec_enet_private *fep)
>  {
> +       uint int_events;
> +
> +       int_events =3D readl(fep->hwp + FEC_IEVENT);
> +
> +       /* Don't clear MDIO events, we poll for those */
> +       int_events &=3D ~FEC_ENET_MII;
> +
> +       writel(int_events, fep->hwp + FEC_IEVENT);
> +
>         if (int_events =3D=3D 0)
>                 return false;
>=20
> @@ -1644,16 +1653,9 @@ fec_enet_interrupt(int irq, void *dev_id)  {
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
> +       fec_enet_collect_events(fep);
>=20
>         if ((fep->work_tx || fep->work_rx) && fep->link) {
>                 ret =3D IRQ_HANDLED;
> @@ -1674,6 +1676,8 @@ static int fec_enet_rx_napi(struct napi_struct
> *napi, int budget)
>         struct fec_enet_private *fep =3D netdev_priv(ndev);
>         int pkts;
>=20
> +       fec_enet_collect_events(fep);
> +
>         pkts =3D fec_enet_rx(ndev, budget);
>=20
>         fec_enet_tx(ndev);
> --
> 2.17.1

