Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712E49091E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 14:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiAQNAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 08:00:38 -0500
Received: from mail-db8eur05on2062.outbound.protection.outlook.com ([40.107.20.62]:39969
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229563AbiAQNAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 08:00:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SN2k/HRUMCGMj0k4+6IuDhTZox4lo46thQvSuPQiCUsE0xRmQ3swraXt3B9r8LL2geZby3Px5V4JbY5uE5CQFey1HnWSEzno6Xauysw4IRRrXBfciJVYZBjI4Qtl4t1zqlZtTY03dKMiVFwr2S3MZWdHFKiRzYrEaLvBzFpIRNWWgL7gXNRYBtS2pFZrB/GhDwb+rNlWHdXcn62uZfh0mB4E8Pv/r96ufShllpSVYq4DvT37bkNGrFL2PCBAUjEdZrRRfumUYCKjrrjnQMCh5NB4iVgvyiteUsw00FsbGcAoj97Di7FcJNoO+FSEAQZAm6UPUHn+h8tFcmgZmfioQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1CaXDhLBfvLt6OgALKuKOTAujOp4J51eFKHMZjQ93mM=;
 b=Qb+eAu+/bALnpGGOE5vqltEET2/R1Y6060zOrv+cafXt0drkQ/gKdDAAJTqKwZ1dVT6DmnZOlYElzwt5OsxG4OfsP96BZKSHYt+RVUfNPxektEQp+8eRvfuSnNWCrkXrjo9bpz4yvfgtkWVXIXOFiipQ+FoE0ZeeUiupfIqbknkfDXPn/oaAHWtSmxjRpHjlJUU/+5gAnKM0slCcCPvVSInwlTpeslL4AsoTWtd8sXDZ03MJoyF4YMVpEoRGugWv/Uhu27PRhi2JuSwmkMZusOfjVZHcVIo1g6+vn7YiDBz1NEaNk6+A0jcpqIHeOy/PTcf8fktqVfgQTVo8PnEsag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CaXDhLBfvLt6OgALKuKOTAujOp4J51eFKHMZjQ93mM=;
 b=MN6NiMutNHbym0RcCeNTbc5dtMOVwt5bq9FDbaftO9cG3nd9xN1VNF18GNxbGiBmJrxM7AMdMNiWkx2qhlocUBgXUj0aM8sJJCWvLrOdSnPU8nNoCyAWzJkUWnEG2LaplpyaUQdDVUFD1MNVBjvOwlLaEAfIb4lBtnVLQy8XSSs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 17 Jan
 2022 13:00:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4888.013; Mon, 17 Jan 2022
 13:00:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net] net: ocelot: Fix the call to
 switchdev_bridge_port_offload
Thread-Topic: [PATCH net] net: ocelot: Fix the call to
 switchdev_bridge_port_offload
Thread-Index: AQHYC6D0ZcgPGGB5b02M9wrfL+TskaxnLSsA
Date:   Mon, 17 Jan 2022 13:00:35 +0000
Message-ID: <20220117130034.jzm72mj42354y6fe@skbuf>
References: <20220117125300.2399394-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220117125300.2399394-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4474083a-428b-4dc7-1941-08d9d9b95a32
x-ms-traffictypediagnostic: VI1PR0402MB3407:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB340777C6F7ABDF8BCC4D6829E0579@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bmO+N5N4EMO9GHipUYfI6+BxHapwRwi2bRAduBds7DoWtN6kMD7ySm5g73t/3L6l0/zO0tMiv9wZari1lTUlCLdk/fp5UCeeMu+9IEehkTSfTyl0+VufmQ5zahhMZAvAwg8/TW+8m97QM/qCAOs3lKeLDF3docAN9uDMJIdE38JHnUiVSVsVjACnIWGDkNYokF34tNQMm6iClTvoWUUnq7gddxEqObRQFTuPW9D100lfhsMNrbZkWDSCJ2Se9e7elu+P2oOrsudpnKw8TiEQG6bhAFdVmdiDuejsBjx1TQNfPYOW4lLKyPcmPhcXCz/r6TELLo6N+lNoVuUkdGmJEwWmLRq85pOGgsnlek4hh0AOVnb2p5nJwJkLjwKT/BBdw2du+YuyKR42QwTWtzWhP0DdiL+Gq8sGRTRWpI07fMjHfeW2Hrjc8irIIGyaqwDbL6nF/FiuXARYmM5ElaOe3M7UlSO8zFKvzSGWVBseSNxyG07bhuN78j24+vPk12tXs28JSJKDXfHOknxIGgOg2dPsUUWrFxmvV2FeAeWzQj/IU3yGQjqOiPEE0UbZWsd5rSH0ZKyWByGjDPgC6OVTFkZ9KX0EuIlZXzI3xbb6U/Ufn1bILsffvBrz9kq8rGl2Y78ISW/dSyDSRtKgt2yLbYSHUKPZE0MVXvDjwYZFPpFpIMP+GOv2ZEacA1iOG39qOt2BVqrLkiAekkTTx3V5ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(91956017)(26005)(83380400001)(508600001)(6916009)(8936002)(66476007)(1076003)(6512007)(5660300002)(6506007)(66946007)(86362001)(76116006)(38070700005)(122000001)(44832011)(71200400001)(64756008)(186003)(66446008)(8676002)(66556008)(54906003)(316002)(33716001)(38100700002)(6486002)(2906002)(9686003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ebrCjUSqqPbjfhnp+tir7mdgG5C9ReePlg+mlu74Br3qoxgeTo2P5v29TDMe?=
 =?us-ascii?Q?tJTevws0kDVWN6oI+HkICGsJYV/OwxIEzS3YHzVUsUvrg13Ygk/alITO1Vwt?=
 =?us-ascii?Q?pmnC99gPRCl6MdKV1BsysECybWRFkA7Nwxlji/IpdoI7WjB2E6V8KWjWhvAa?=
 =?us-ascii?Q?x4vDQadMU67vH550+1VJzWtKQ3i4tsLrbWR8t0lg1NgzdCjHzmkPpylNgB1O?=
 =?us-ascii?Q?TfiKGq7GAoa+cHKyNJORr8yZq6/xxH8mkTm4GJ/TcQJqGwR4JWYHnPAtNGxC?=
 =?us-ascii?Q?jOL2/XRM0HhBVb6ITRlLeaMKd7lPAWBQFDWnSug6LSWW1AXzOJq+OX95DFu/?=
 =?us-ascii?Q?DzFLES4tIB0DPKy6kgAoLZYzpKQ2ua14K04uNGeg+QyBuMpH1OvdbOjtd0bE?=
 =?us-ascii?Q?nNxlPikjN4LyZE66mQhWRMOkgtH5pvmmSu8kIMieUz+D1TctvA9NNc5Fir1/?=
 =?us-ascii?Q?T9ZZpNcz1iHsyCw8hcXqcsWiFQOAFM6UN/e/FefVlYvlDIjSCpOvrd1KFuOZ?=
 =?us-ascii?Q?wxh2y3MlJ4Fq9HCibegoAfmpB1NaAvp+1NSsxIc8PrxSdX7PFBFOk8mEwYC3?=
 =?us-ascii?Q?cEfOIgc76AyGjGEbWF85OUT4ZU3e0p3YNmLzeE/wjRNZ6EUAXHSXQtp52xAS?=
 =?us-ascii?Q?/okf0c1a9zcZRP6Bmlq4qcC/5RH8DuMAjdZ7Unjdxg5BTsCwCYwERcdFECr/?=
 =?us-ascii?Q?04kRo50a+IFQemcJd7if+6FUk4dOoi2yQDUgM6l2wuhhLz0bk8AcwjgATVRI?=
 =?us-ascii?Q?VISy8MQMsw44c5/WfUdGeAjTbnIsQan6lN1zVzaVFlM24N8YXj1B5CBgCiGD?=
 =?us-ascii?Q?tuan0p+KfEiIqyjrXc4/3+sr3EaUxd1B9CxH7BVtpxgt7g/pbSPnImFd70//?=
 =?us-ascii?Q?fEZ3sSrPOzg06zPUhMELflq4izeGo4guqn26mQybCerSDsbl3lTnbz0MD2jg?=
 =?us-ascii?Q?cX6c7dQeg41AhTdcT7SHeKheOVPpYy2c4btJ6OPacK5Fkh3VaKZufXOp9AaL?=
 =?us-ascii?Q?Dq+7UNQ9LeMo5UnyQxm/7SYiegs7SO2Iph92E9E0TDVlzdc0jFHI7Q9Xa11k?=
 =?us-ascii?Q?W//TT4ysRUwphjmo4JXOW38vrl9CgvgvdZ4Sa8vuP0IO5LU4Fz/Flum6JXpQ?=
 =?us-ascii?Q?jALUWCJjE6Noz26H4GD2fCIefdxoknK2tj2baSF9i/WNTYi3opFPdrDRJa78?=
 =?us-ascii?Q?j/NCVyzpEb53+zPQKpwL6UUN/EqBtw28Hw+zXjuv3JCDcE7Twx7tByEfq1nQ?=
 =?us-ascii?Q?Wkz+atXb/j5EjS6brMQ0/hlW/G+RDs0s8n1zlwjTifvD34olDQju/5TvhDW+?=
 =?us-ascii?Q?//CKAR+5JGat4gWl5M5U8WOlpFFpDiI4eYFTZO2KTc9uI68liAXLELRSIK1V?=
 =?us-ascii?Q?43VpanLnforjVypMXRWDNaSbgAzkKdwHUaUFqJiHxVAUU27HNZOUO8Clrah4?=
 =?us-ascii?Q?YKFOXsZEkUnjjN5ZILuXdFZySE80mkSQ6K1gAhYLtKwIWYhoq9TJ2rGlYNbr?=
 =?us-ascii?Q?xNPSrAC7GhCNS1XBenuDNzhGkC3/wWrwRaKu20BG/iZqlYIO3J3SYpgpX1Ey?=
 =?us-ascii?Q?QxwdpQFCl5QTuTppImm9pDbloVIHnlUUjCbkuJ5YyyBKRLPYDUjDKAJKv1Od?=
 =?us-ascii?Q?POQzkOL2PayOU5MFs0HTIN4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F22B98968113FE47B2A9F9A52AD6AADC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4474083a-428b-4dc7-1941-08d9d9b95a32
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 13:00:35.3639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jdnX1t1MIPXRli7UEuKUTZJYslwRRWfJC6nTVkgZTC0eSOqw3TCaLg5iUGchOsqqSKyd0TDl3DwRLOmbAy575g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 01:53:00PM +0100, Horatiu Vultur wrote:
> In the blamed commit, the call to the function
> switchdev_bridge_port_offload was passing the wrong argument for
> atomic_nb. It was ocelot_netdevice_nb instead of ocelot_swtchdev_nb.
> This patch fixes this issue.
>=20
> Fixes: 4e51bf44a03af6 ("net: bridge: move the switchdev object replay hel=
pers to "push" mode")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index 8115c3db252e..e271b6225b72 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1187,7 +1187,7 @@ static int ocelot_netdevice_bridge_join(struct net_=
device *dev,
>  	ocelot_port_bridge_join(ocelot, port, bridge);
> =20
>  	err =3D switchdev_bridge_port_offload(brport_dev, dev, priv,
> -					    &ocelot_netdevice_nb,
> +					    &ocelot_switchdev_nb,
>  					    &ocelot_switchdev_blocking_nb,
>  					    false, extack);
>  	if (err)
> @@ -1201,7 +1201,7 @@ static int ocelot_netdevice_bridge_join(struct net_=
device *dev,
> =20
>  err_switchdev_sync:
>  	switchdev_bridge_port_unoffload(brport_dev, priv,
> -					&ocelot_netdevice_nb,
> +					&ocelot_switchdev_nb,
>  					&ocelot_switchdev_blocking_nb);
>  err_switchdev_offload:
>  	ocelot_port_bridge_leave(ocelot, port, bridge);
> @@ -1214,7 +1214,7 @@ static void ocelot_netdevice_pre_bridge_leave(struc=
t net_device *dev,
>  	struct ocelot_port_private *priv =3D netdev_priv(dev);
> =20
>  	switchdev_bridge_port_unoffload(brport_dev, priv,
> -					&ocelot_netdevice_nb,
> +					&ocelot_switchdev_nb,
>  					&ocelot_switchdev_blocking_nb);
>  }
> =20
> --=20
> 2.33.0
>

Oh my... I remember noticing this issue when preparing those patches,
and also noticed that ocelot doesn't implement SWITCHDEV_FDB_{ADD,DEL}_TO_D=
EVICE
anyway. So I wanted to pass NULL anyway. I don't know what happened,
I must have made the fixup on a branch which wasn't the branch that I poste=
d.
Anyway.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
