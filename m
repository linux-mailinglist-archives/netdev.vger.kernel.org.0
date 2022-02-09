Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2344AF0E8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiBIMHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiBIMGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:06:10 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30058.outbound.protection.outlook.com [40.107.3.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F0BC0219F3;
        Wed,  9 Feb 2022 03:14:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nn/JInRXaTLrd8SyDEayG0cMttSDzCqWCnst4rWKIjCI1wNLFb5wQlwx4XiLBhglopgSAjEd+hSaMeig1/fY/P082yhkhAERrPXxCTdl2yg+CSjUgK8dpnSYTrDJc7FCez8ezUPmbYlMLkVP5hDm1HX8thPl35e45ioH7NzogAKEJc+zaZH3/jht4CV7FRdzVv9NrYK3fxF6E+G7SZ0lbJslgvmmL3387l4KrlCYOkXT5XkZ9gLTovXSHeTarAakzA31UWE2lQPB/EX5Y+1+npcQ5SHWqlg8ngR2b9Jw652+DZ0DZSbCmpu2gkoSwVmDv/GqmGSHpuj7x2+yQhnxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naluj9FFpJHEWOBQAX3vq6zKXscC1l5iYw/TjPDg2wE=;
 b=dyUkTknLPoDS0j5vhOp4aCoZz8cya03EbVd58RcrvjMb6Jfvm/wXc97aoSND5md2mMCkeY3GTjYK0IYHBiQSUUT1kQG3RdMeItDLozegbCbfGANqwJ9uwzfvroqTVPI4HECfspCd0dVxoNO4DiHNvQyNiNVQxgaPr0ifjIj+dSOojxD98jv7KuXwfyKv7kSExYWWf7ceQAY4H1arzuHhsMWueELIaNaFefgzEYNfcbDkr9pfpONJad81IJxrO9lIJUDJk1dNz0v9pQ29EiP2OIo9IRhP+Riwrhv9xAH03ib0JUGbTN7yd0VB6sgumyGcrqEP3W38gWaM5cfFPryyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naluj9FFpJHEWOBQAX3vq6zKXscC1l5iYw/TjPDg2wE=;
 b=ZRPlbUZFIrfj34Eww8PRwSEFaFGRSzgpc9KG85mLA9JRscLBaMt5wc8CmfopsU2TABawViHHKefRwGvhgduy5mNT1Yr7TIFPZCrhadHNcRwbAALUtD3fwO7xMgujJUtNSQjC04bNU1fE2VTwKRgs4UFsla1WRjWh3b+rh0aHXJw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6579.eurprd04.prod.outlook.com (2603:10a6:208:17a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 11:14:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 11:14:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Qing Wang <wangqing@vivo.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: ocelot: use div64_u64() instead of do_div()
Thread-Topic: [PATCH] net: dsa: ocelot: use div64_u64() instead of do_div()
Thread-Index: AQHYHZCIgJv9QyxGa0GdYVat4ijKrKyLEV2A
Date:   Wed, 9 Feb 2022 11:14:47 +0000
Message-ID: <20220209111447.qbugjb5kr3jlhz5i@skbuf>
References: <1644395942-4186-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1644395942-4186-1-git-send-email-wangqing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8136f86d-ffab-47a6-372b-08d9ebbd6239
x-ms-traffictypediagnostic: AM0PR04MB6579:EE_
x-microsoft-antispam-prvs: <AM0PR04MB657924B75F0900C84285E0E4E02E9@AM0PR04MB6579.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WiQR/mBUU9/HV+DhJkBJA5s3+ZdQCwxa8uDZLH/M0mgEON3sos1pdyCRhPh/cHmzjqVNhvXjJqemp6XSsbEKZeZGlROolhYj4VPvKo56V8kFJaggN2SsKv2ytfTOm7j04miLNvfNM59dyczXRk/pZETzER4VSh+lMAD5ce+lxfeBltGZJSRA2sZK0ZYljDoFG3tB6K3XuhLrINTotDwzl2rnPDUPoywSmKhSnA79rOadKol3MVpEHYQsu7tD6iPHdjUDRh7VJ0PwbxeVwUifVbmJnSlX0NWTL9MZsrnC4W8CtCsT8S4SKPcdEHcTSAbtwic2/f7xS0a8XfWrIjEfopGDdDDDrJfgJCR1BuTiwMikSAd8q68HkKlZcynD40BWB36yiAsSKBx/TkRwYz71lrB+K/c3S3kNip7rHPN77mHKsOm73gSwukkOQ7B15N8UVSoGYuug5DX6Hduoyga3io8AA5K3YXYlhZg8pt+o2fwWc1pXEKcHhoniFp7ltDAaKOeAMLUSJ2Rk2BIVMZqaPO/WGeH/LpaUQjjJXdVh63DdAsqaklJB0FKgkaw0kVn4hY7Ngf5Pt8iYJJouI7ym3khcbpna5pS8VKNcEKPWLgmPYnvp07mWYGL05oJKhVTPrPCtGKqRIV4X67QKu2/VevdW0Seg7fztFaBPI18ClQ6eH+Sm9fM94TvxomWTMufgBzLvFp3imKBWhI1nInU4hA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(26005)(83380400001)(6512007)(9686003)(1076003)(186003)(71200400001)(54906003)(6916009)(6506007)(6486002)(316002)(76116006)(44832011)(66556008)(66476007)(66446008)(64756008)(8936002)(8676002)(7416002)(4326008)(5660300002)(66946007)(33716001)(2906002)(86362001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/pLkYotQYeh/399mu6ZOtfHw0xMLQIYH/r+rgRtbzYozlHMjas4M/zHeX3Pq?=
 =?us-ascii?Q?Ditpa4fPIb1x550TMm0kuLFWDRt7Q0zj9ZmKKyk8AfqmI29iQ9eE85jI7qTC?=
 =?us-ascii?Q?B49anMN8zSfKm/15lIT8hjgHVVY7DSPcaamKvTNdVIM6DNIh/vK3fPbVPU52?=
 =?us-ascii?Q?y+T0QbSEoRdhm1UeSmQjZJ/pbrEr9aVGzxI2RzUKh/tTOQIuzIrp/Yh7M8TT?=
 =?us-ascii?Q?AC6KBWNsGwp1spUfmR5avOMynrq3BX7Qx2CxIqlfEePR0PV9XQ0IM9tlF+UN?=
 =?us-ascii?Q?I85fIbyiAH8L6UsrFxhB6iavHnhsT/+M39RKXSEasXMtg6IA6wc/FE3NU8LG?=
 =?us-ascii?Q?Ehizs6XKV+N0fFMtke1XNl3LH+uPhAWCpsF6A7Ec/SDQkWb4YPTLBB23GNWS?=
 =?us-ascii?Q?33p2BiXG7inDqFkQ8a0hBOs687sWhpOcYnB+7Tl6Cfl13BRO6syH7dkCNgVn?=
 =?us-ascii?Q?HrPGl9ahWBeeGcjucuHQmkkAyqY6AyZ61tYdN1qL0nRIIuVhNhJzrZs7WWHp?=
 =?us-ascii?Q?Be3+5PhwvhppzLMCqVWsbhVPpe9vbLeC0Xesr6mHjZ9TiKSWVA/DqMcTr0oz?=
 =?us-ascii?Q?+bUwJ3NmMjl/VhCnIklosvSCB2knOD7A8zHwOIduofimcNr/Os8pcqPYUIet?=
 =?us-ascii?Q?VQwC3bPSIn+YtAxDILasnmcj1FU6XsWq4lK624oIUr6a1aAPR0EFNbRo2anH?=
 =?us-ascii?Q?Q7CCnKuKgISeprqt14Y7JyGWwuwIMuNicF2yft4g1KDbs0Kwipqo0R2Ilrhe?=
 =?us-ascii?Q?z3Vt5VKhRwCwb2lvlijSrJ0dZI/4zwSYu+sFSe9LE8GhrTMCl32rANii5CG4?=
 =?us-ascii?Q?uulX6R+L1nPeG7b7qAeoD++kNSvfaeKDPgu6JO9O14Vz/atQseHS03x0cQrm?=
 =?us-ascii?Q?QpLHHy/57LmpQPAfevWbY7eVCTS2Cw5lf/GwFJLZnGZvMvPciFwV8KIqH987?=
 =?us-ascii?Q?CkqSBsHFC9Os6K7OijwapNbeuImbbFACXD0SnuYGTW3BLup7BLsM6w7RP1Zu?=
 =?us-ascii?Q?X8TQdKpg27k0jOALnd3jjocGcwAWY8iOY7styhAHFss50fgx/FHCJ/dRGohH?=
 =?us-ascii?Q?+jzoxWflzpxdr8w0mwQkzDwPopFbxdMZzikWDILw1WRXTNDJgGswAO0AQ3pq?=
 =?us-ascii?Q?cwqNMk7BTzcogrVd8x7adMmaBT5Xyb1vyrSoc2oYlbjLtryWfKzzzFnHxdb+?=
 =?us-ascii?Q?2pqrOzXOMVxYy9TbcwTXbL23gA+StLKHiMouc2s5RS020zBwowsM60ULZqAE?=
 =?us-ascii?Q?1RR3wn669AWcAqwAjx2+0QUC52qTOsUHZ9DF/9XqMa6x9XO3rJ7YVgMQ6i7d?=
 =?us-ascii?Q?P/q6rS67bKqUsKprPTrO8aoZ5OkwNZJfIP4FiIir11c22Y1B6bA974G6mfSd?=
 =?us-ascii?Q?ksEuR1jsdBo/SHIXDTF9rUNpjXtIX2keRjHsdIDhfEw38/o6RoGe7CEhV/yX?=
 =?us-ascii?Q?0QrMoR2gJej3bY2owah6+ss8FtGaCXTauXvHSewFSEw97XeZdPoCI+6FQO3Y?=
 =?us-ascii?Q?ta/nAJM2RfCOeUDe3DnxPn7P//I4hvbuYHzHkkocXM1N8cJ+6g9uS3/XM/N6?=
 =?us-ascii?Q?PROsomHDTqcMSlXZzLBllnKA/nBqRA9u20CNO5w4+RskFqbgeN6wRdydbT/B?=
 =?us-ascii?Q?ZTfOBBwpV88ih+25tbtbQMM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E3C1EBB177A694C8E14E5EC82437F18@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8136f86d-ffab-47a6-372b-08d9ebbd6239
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 11:14:47.7961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l/FZtgAbxWmW7hpP2Lf5FJNrf1YT/+Hqbi2be3PRrb7RQy+WOUBCkQTUnASJ25eOBmuGqPob1DGheEYENS3peA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

On Wed, Feb 09, 2022 at 12:39:02AM -0800, Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
>=20
> do_div() does a 64-by-32 division.
> When the divisor is u64, do_div() truncates it to 32 bits, this means it
> can test non-zero and be truncated to zero for division.
>=20
> fix do_div.cocci warning:
> do_div() does a 64-by-32 division, please consider using div64_u64 instea=
d.
>=20
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index bf8d382..5c2482f
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1178,7 +1178,7 @@ static void vsc9959_new_base_time(struct ocelot *oc=
elot, ktime_t base_time,
>  	if (base_time < current_time) {
>  		u64 nr_of_cycles =3D current_time - base_time;
> =20
> -		do_div(nr_of_cycles, cycle_time);
> +		div64_u64(nr_of_cycles, cycle_time);
>  		new_base_time +=3D cycle_time * (nr_of_cycles + 1);
>  	}
> =20
> --=20
> 2.7.4
>

I would prefer that you teach your scripts that, if a range check exists
for the divisor prior to the division, it gets taken into consideration.

vsc9959_qos_port_tas_set:

	if (taprio->cycle_time > NSEC_PER_SEC ||
	    taprio->cycle_time_extension >=3D NSEC_PER_SEC)
		return -EINVAL;

	vsc9959_new_base_time(ocelot, taprio->base_time,
			      taprio->cycle_time, &base_ts);

vsc9959_psfp_sgi_set:

	if (sgi->cycletime < VSC9959_PSFP_GATE_CYCLETIME_MIN ||
	    sgi->cycletime > NSEC_PER_SEC)
		return -EINVAL;

	vsc9959_new_base_time(ocelot, sgi->basetime, sgi->cycletime, &base_ts);

So all callers provide a cycle_time argument that is smaller than
NSEC_PER_SEC (1000000000L =3D 0x3B9ACA00 =3D> fits on 32 bits).=
