Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7C141C522
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhI2NEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:04:14 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:25568
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343988AbhI2NEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaEPTbMRPF8SyE7/8rn6ar6PodlPvbBu+AiPw7Jh1rum2pwz6Ejkdza/+3GX9Gb2U0A/wkZJforldE/qJr/qO4B975JWeQl0SKg2bdxmCt36XX8F7fthZwxrKUQRN5gKrAiNeJbEXgJq6aHk/+j4Sx3pNK9Pvx+ZatqAAiOjpIUteaDesPZjO/8aHyjjovAUgptQBpB2kfCql/TRJxLp1AinrrW+BLOAqPUQLTuOr9EcQ9oSywjSopIn1aLV9TYoiR1uvGL/0w8RRb+X/w1Dgb4mN03PxriQVnm8Yr9RHGeKWJ0lsd9hXK4gDyO79TioZvxp31lwCrk+vU2rNaUqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bMvFxcqKfKPm16YtrJpARLfNSP9d+LPt+P0vflHhlqA=;
 b=LqZALc9R1J+ROpaof/VMy3oclV14nlArdJO655JlTle2zuwOY8+OqYOqWkxy56589x3sgV+qhUCONPa4dQW4BHiUoiYuGbLKMKxOYOF6Cs2a44CRUQj8rjm/cnvFlDm2F0m9R4y5t8xt04eLmNXm8iVM8mn9Dyz0uh4HdhwOifJDfNXoX4v+7YIEMKkUuV8lxJTXqVaXRw3WgQZ8hK8+S8NZ5R8HwynMgZLKEnilXmRpJRONoRRMerIJfIii+BKfkq2BOIsy1O8pEK5UZuUtZXNOCe8u3B5hGbLsBGnqZ9QdI850847/6riZaZYSVqckZSQCV+vlmMv+NsX2y0sjGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMvFxcqKfKPm16YtrJpARLfNSP9d+LPt+P0vflHhlqA=;
 b=k+mr/8JQOjDEMmfNK1uq6jksG0riurvY4rIGEwhzOPg3wFv9/JAT15+Os0GeBl+zi8PbmnNKG0yhA+Pj0OKTjoRV+Vpx3r+vA58bCMoBz0Twg+9njs5HGNMh1SWmqpNZ6mfXLKh3+TtpcwS1w5Oh82wjsvBrhNOnMjamcOZMUb8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 13:02:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 13:02:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v1 21/21] net: dsa: Move devlink registration to
 be last devlink command
Thread-Topic: [PATCH net-next v1 21/21] net: dsa: Move devlink registration to
 be last devlink command
Thread-Index: AQHXsf/jDUQggLoXsECBC/w3h2dcLKu7AIAA
Date:   Wed, 29 Sep 2021 13:02:27 +0000
Message-ID: <20210929130226.j53fcztm6utpt3tu@skbuf>
References: <cover.1632565508.git.leonro@nvidia.com>
 <66dd7979b44ac307711c382054f428f9287666a8.1632565508.git.leonro@nvidia.com>
In-Reply-To: <66dd7979b44ac307711c382054f428f9287666a8.1632565508.git.leonro@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e64c117f-2173-4cc4-7163-08d983496375
x-ms-traffictypediagnostic: VI1PR04MB6270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB62702D378FC423490324C449E0A99@VI1PR04MB6270.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2fdx1HLooQ0AbKL6hBbjx+q5usyCqjDTMwBFI2Do/0DTzFezGLAgfzGAOtjGQL7ctycQvLwj4LPM8h7HR59G+6L+baUe4godKfLuLfBqntAeN7GlhdzoGMkokyrAiwqMbKOB8hNRfNLx+HbuwTDG0y7D3d0NA/VMXdlhqgTvoKZBjCPNTZJFEfqY3QBwP676wTv8nCkTROF8gCFdu5OfnApxTbQNBGtkHrLkAt8pTSE2iIeDjLcARoOgqOslWacDO2kbCYCrIyl86rWlmVWsKZ4cDV73+wWu83559A6fW1fPhFaQUDPLmXawPH/m1lIzS+1Ky37gYQrTm4Sqp/DWiWTtR1jUOVdq1K5HuGwhTI/HNi0KEwwXGkNlQiTn2WXHtw+rxtd43NFLHNS+p4MA2qPrdAxR+VJG6MX1tpa7KG3y437p1GrzmazBd526XE+ej3irLwEup/20LAPgX2nJcCmi3KdiK4owl4C+4FUZnqyr4Z0b+t3OZ1AUZqbQUIXXB/5FB6Rditb3BI7AIdJOvhoj98P6SgAmpo3DGKuiqfI/qv84063SyVHlDejQrsB3L79fxIIeOlg2DhevWvWDLvniUJ0YSFogMREOkoA8bqkSokVy0eyI0Cf9u2ra8EAMagiS6pQF5u3h3IElziJSEFg1qLSLlnuFjBll7EzdHSRiBQ4TTAw/ZrIh0fQ06/2Bfr+rXxGdlEc723Caoa/mVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(76116006)(91956017)(8676002)(7416002)(2906002)(7406005)(7366002)(4326008)(6486002)(66946007)(66476007)(66446008)(316002)(64756008)(66556008)(9686003)(6512007)(6506007)(38100700002)(86362001)(1076003)(122000001)(5660300002)(45080400002)(8936002)(71200400001)(38070700005)(54906003)(33716001)(44832011)(6916009)(26005)(186003)(83380400001)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TCZN91UX3ffjpf5xXer15tHhokrf3A0HBNI6/dkv6hdBjtr5p47J6iUzRJvU?=
 =?us-ascii?Q?rEjDk6IFdxD9VbyfaTN6s3a/mozDWfIb8uPaP4IJQnZOOwRos0PTVUGfcqed?=
 =?us-ascii?Q?nxEXVfsj6xcHhkhs8W5icZCVCScz29CPo7II8B4jqvRMZZ5ZenyfXqn0vxVb?=
 =?us-ascii?Q?C5gsa4gLRxug8OGUA36eIw0GIzIUgmRB92Syb2+X/F20hsu7QuC0Wr417uiX?=
 =?us-ascii?Q?nuTrUlhKA03iAbxX5dinC+kg6Rmw6oSw/Zqk8ewrGutZCT3GI6ogOEFi91AV?=
 =?us-ascii?Q?zMbj6zadWvKRh4xmmEnPyABY3XnANvm7MfVY8A2MAHCPwxqf4kVzkl1CGXC1?=
 =?us-ascii?Q?hLa7Wj0Lg5qghia+iVpkdcTHtK26oajTk96f1su7CJ0K0l5odwIXz1i4/M/i?=
 =?us-ascii?Q?JVr+rZejQEIb97mgq/Ci+JAxGVHn6WKHwd+YtEMC2Qo1JiBFv0gC791fpsGk?=
 =?us-ascii?Q?J1FDL7o88TETZVuf86aBGahMItfMiyL9Spnq3wjAtVcMyQZZ7uuecZi2KLs8?=
 =?us-ascii?Q?KCHGfNcAVbtEyE3Yf0XxBku7TmuYPWDoRYru8YgOUc00Ah86tvEQoBqYh7x3?=
 =?us-ascii?Q?61xs4D3/OaBPRYCtv1YwKTQ3IBw+eviJz1mR3LWa5YLPxfMEB31Fp4g80XQq?=
 =?us-ascii?Q?x84xXBPmhKKSlhqZEi2D8I7G8SqlsiH27DGyQs+kxssd4sykYRWICVf+5lrH?=
 =?us-ascii?Q?cx8bGApqzRIX+wrxcBF+cQZsw+iOUBJDTri17QAgIK8tpVV1POEsilhASkpL?=
 =?us-ascii?Q?tWQWWbmCXFo3fzXb1D3Wn4neTFwtrv+Gfp8+UIjfRfdzjPPavlaQGGwJu2Hi?=
 =?us-ascii?Q?79FzCVv1vtevQ3pCdQ+jS3g7S0hzKl7Z90YMs12L9ND4nP9skKye9Ewi4S1/?=
 =?us-ascii?Q?xOEB3lSn1EVWwy/X4YSPCu5nzqv87m4DNZ28ydRmS77IL1E86biqJoS7ASUU?=
 =?us-ascii?Q?scpIdn5gYzSCNBVQF2F28D24kdvIjhqBuazuBi4sDvp6E9StBs6e5t4UKfYY?=
 =?us-ascii?Q?SnFYm/di/7Utdo2K9Vda/BO7iWdNJ7V3Bkmt6ndxWnj2DmFQ5SWluKjyJlPu?=
 =?us-ascii?Q?N+9JD4DKvAjCusAT8lWjfMu9clbcymEhf1pJ3nvfbIEWlwuUVMreC4qvpKbk?=
 =?us-ascii?Q?p52fZt4Jq5y3U/tFp3xQirYMDGF05od8/vmMQwfE5u9I421FJ9S+LdDFfNRG?=
 =?us-ascii?Q?Yc4eIaoJhMbKOBxii7pM2TY+Blj+MjTCH94TwU/PbLCAYYO3YeQP31APj/SN?=
 =?us-ascii?Q?89Qr8gAmwlnjUaSK/CsE8ObkWdq6z/sdD0i3L/75ckDKbxTuG9XeXXJRWTKx?=
 =?us-ascii?Q?VfGu6cjI0jH+He1NkZeZr6Uz?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59CDFF54EC25CA4CA449F68A8083757C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64c117f-2173-4cc4-7163-08d983496375
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 13:02:27.3218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GuQXl14czK/MVPcyn80p2iOMorfZ7brQSmRu34Gz6z3YMg42XEQEYAoCTqhP51r08KCSbVjsnNEcos7S/9FWHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Sat, Sep 25, 2021 at 02:23:01PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> This change prevents from users to access device before devlink
> is fully configured.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  net/dsa/dsa2.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index a020339e1973..8ca6a1170c9d 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -848,7 +848,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	dl_priv =3D devlink_priv(ds->devlink);
>  	dl_priv->ds =3D ds;
>
> -	devlink_register(ds->devlink);
>  	/* Setup devlink port instances now, so that the switch
>  	 * setup() can register regions etc, against the ports
>  	 */
> @@ -874,8 +873,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (err)
>  		goto teardown;
>
> -	devlink_params_publish(ds->devlink);
> -
>  	if (!ds->slave_mii_bus && ds->ops->phy_read) {
>  		ds->slave_mii_bus =3D mdiobus_alloc();
>  		if (!ds->slave_mii_bus) {
> @@ -891,7 +888,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	}
>
>  	ds->setup =3D true;
> -
> +	devlink_register(ds->devlink);
>  	return 0;
>
>  free_slave_mii_bus:
> @@ -906,7 +903,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	list_for_each_entry(dp, &ds->dst->ports, list)
>  		if (dp->ds =3D=3D ds)
>  			dsa_port_devlink_teardown(dp);
> -	devlink_unregister(ds->devlink);
>  	devlink_free(ds->devlink);
>  	ds->devlink =3D NULL;
>  	return err;
> @@ -919,6 +915,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds=
)
>  	if (!ds->setup)
>  		return;
>
> +	if (ds->devlink)
> +		devlink_unregister(ds->devlink);
> +
>  	if (ds->slave_mii_bus && ds->ops->phy_read) {
>  		mdiobus_unregister(ds->slave_mii_bus);
>  		mdiobus_free(ds->slave_mii_bus);
> @@ -934,7 +933,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds=
)
>  		list_for_each_entry(dp, &ds->dst->ports, list)
>  			if (dp->ds =3D=3D ds)
>  				dsa_port_devlink_teardown(dp);
> -		devlink_unregister(ds->devlink);
>  		devlink_free(ds->devlink);
>  		ds->devlink =3D NULL;
>  	}
> --
> 2.31.1
>

Sorry, I did not have time to review/test this change earlier.
I now see this WARN_ON being triggered when I boot a board:

[    6.731180] WARNING: CPU: 1 PID: 79 at net/core/devlink.c:5158 devlink_n=
l_region_notify+0xa8/0xc0
[    6.740123] Modules linked in:
[    6.743217] CPU: 1 PID: 79 Comm: kworker/u4:2 Tainted: G        W       =
  5.15.0-rc2-07010-ga9b9500ffaac-dirty #876
[    6.759155] Workqueue: events_unbound deferred_probe_work_func
[    6.765048] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    6.772060] pc : devlink_nl_region_notify+0xa8/0xc0
[    6.776978] lr : devlink_nl_region_notify+0x3c/0xc0
[    6.781893] sp : ffff8000108b38b0
[    6.785235] x29: ffff8000108b38b0 x28: ffff6fce86e53780 x27: ffff6fce86e=
525c8
[    6.792453] x26: ffff6fce86e69b00 x25: ffff6fce86e57600 x24: 00000000000=
17528
[    6.799668] x23: 0000000000000001 x22: ffff6fce86e57400 x21: 00000000000=
0002c
[    6.806883] x20: 0000000000000000 x19: ffff6fce86e69b00 x18: 00000000fff=
ffff8
[    6.814098] x17: 000000000000013f x16: 000000000000017f x15: fffffffffff=
fffff
[    6.821313] x14: ffffff0000000000 x13: ffffffffffffffff x12: 00000000000=
0000b
[    6.828528] x11: ffffc1141c2fce38 x10: 0000000000000005 x9 : 659dd6f9176=
4a956
[    6.835742] x8 : ffff6fce851ce100 x7 : ffffc1141c6bf000 x6 : 00000000302=
0805e
[    6.842956] x5 : 00ffffffffffffff x4 : ffffaebaddb5a000 x3 : 00000000000=
00000
[    6.850169] x2 : 0000000000000000 x1 : ffff6fce851ce100 x0 : 00000000000=
00000
[    6.857383] Call trace:
[    6.859854]  devlink_nl_region_notify+0xa8/0xc0
[    6.864422]  devlink_region_create+0x110/0x150
[    6.868902]  dsa_devlink_region_create+0x14/0x20
[    6.873563]  sja1105_devlink_setup+0x54/0xa0
[    6.877871]  sja1105_setup+0x144/0x1390
[    6.881742]  dsa_register_switch+0x978/0x1010
[    6.886139]  sja1105_probe+0x628/0x644
[    6.889920]  spi_probe+0x84/0xe4
[    6.893180]  really_probe.part.0+0x9c/0x31c
[    6.897402]  __driver_probe_device+0x98/0x144
[    6.901797]  driver_probe_device+0xc8/0x160
[    6.906019]  __device_attach_driver+0xb8/0x120
[    6.910501]  bus_for_each_drv+0x78/0xd0
[    6.914373]  __device_attach+0xd8/0x180
[    6.918243]  device_initial_probe+0x14/0x20
[    6.922466]  bus_probe_device+0x9c/0xa4
[    6.926337]  deferred_probe_work_func+0x88/0xc4
[    6.930906]  process_one_work+0x288/0x6f0
[    6.934952]  worker_thread+0x74/0x470
[    6.938646]  kthread+0x160/0x170
[    6.941909]  ret_from_fork+0x10/0x20
[    6.945519] irq event stamp: 64656=
