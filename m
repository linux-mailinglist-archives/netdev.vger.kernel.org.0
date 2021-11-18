Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027F545630F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhKRTDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:03:16 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:10105
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233955AbhKRTDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 14:03:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rzn7IwzkBFEmWLTIbk1uUT2cDaYLFxhED9/vFjayLTZndsv5gLQcijb0t+y+XZ1yIBCmUutDTmwcKL/s53StvOG3zQaoHEvhXgIbQ9Ev2OOVjH44iHfteNF5JU4RgQSVpHCPv/FbFqP0PxQdhtJaUiSHvZot5fBu/jcRUz0jPa89gcIjocgXgJlnUCGMRu1otoN9M9bw5V57ZpIAUm8ePlmAeM4XLEZTfzHmiPmh3BeKgiY1Ph97hMNkqG/lS+kOOpPrqH1Hf8JwjbrW39of1v0YCFYRAzoymQXcmk7fbFecALtLHVsj3drmK509f4VCpF/b1Xo9N8x7LB7IZULtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rL5GuEcwhYOFaXOsFKoXPyD9mk5jjwozdyza2QUwK5A=;
 b=Mxv+BagOOOjGNtiTzIJzt9QQ9ABp83o+E3DNrnaMFsIo9CdRXUXzbhQVSaYDgRlfyw4i0mdvOTg9pnu1xbUOwsKkptHo0LcPmmRTuvZM+91OnyJxwOfjx2PC1TFR1OSojOCRr4CJ2brJifNib23ZTwBC0wH55gsrpNO3edhKez6cKJHbsFZJHnddu6EmNmLRYRb0HED22n5zo9BvXYM44ZGbkF3EN+CQ/lAgFQGffCi7Enm7hq4dPQ8Iw2YMth+ONk5Y/BkXanvN4FUC1S/CgxDgnPTj9g2wDyOk06srggT37EpQ6Bfy7yzXNEfa51h1tgRD3aEUdtoamW1XeN01Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL5GuEcwhYOFaXOsFKoXPyD9mk5jjwozdyza2QUwK5A=;
 b=oWsGpHzm5+bsmirW5bACmVHodsZxRQrTiE5yc1P/5WVzLRy0zzZKAeqyTry/i/pm0BEO0ELAi0kplBTmZWRgmIGaXsHk25OFlFfRi1/0VMpEKhGzvm10ZShVQRPIP0XqZh9gAaEvzZfUXyyXiwOw64Vswa5TyCz10WvYsLxp0aA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 19:00:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 19:00:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: felix: enable cut-through forwarding
 between ports by default
Thread-Topic: [PATCH net-next] net: dsa: felix: enable cut-through forwarding
 between ports by default
Thread-Index: AQHX3K3cxGGrwwaPrkmUPx6r0o3O1awJo6sA
Date:   Thu, 18 Nov 2021 19:00:13 +0000
Message-ID: <20211118190012.dvmdrw7upisna2na@skbuf>
References: <20211118185352.2504417-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211118185352.2504417-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db3f0091-24e7-4fe5-bf1d-08d9aac5a71d
x-ms-traffictypediagnostic: VI1PR0402MB3549:
x-microsoft-antispam-prvs: <VI1PR0402MB35496C6E6F7356EF0065C5ECE09B9@VI1PR0402MB3549.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GKUOM3v9vRzzWG7uTM1WITUUNQAhU9JMJymhDyGGxvWB1crfLiEL8164qphqDHQGncqvXBefGcfCNA8+dcLbeVnLTQwQYsK7OzgX/D74RJy4qlydxBjokoc+kZzfwJU0bsU0CZ0SqfMajxLWsOfznSk7JmCG7M8nLlsM1jTKLu5ad4MJNxREEYd0ZNHgah1MpnGPHQDQloCS5Dkvo7F3GXJ/FTKgpqlj6dYxXqy9GyeGXcz1r0NNjDmHq/jx7ptwONhXauyDpXysx3dYpec2ylps3PwNqAzOfEQ+blNjsEXxmP4zvXdQ/m+cUo8RYvkKad7719VKQOBF3bJMA+jVzwfjHo+vxsd0YuexVvR2eIKV8lCWVx9iws7CIKON5DrpTtzs2BKkCdq4u+mYX56dpv26aoENohrlqEBKee13n8FDCEyye+RbgQ+eYUDMud8papTDxafVOpLQ9eDGICGHKz20olVpQRdX6w5Pguy0GUDyOqY8dUqMheDC4XfF/pnpRmd0v0QClKgRKHsMonEh/qWkr+MszyltvtMPNB3rhv5dRQ4jmfalhz5Fj/oKfRDSDzD71OQpLETT1tOP8PlD3RMbsYEoBzpEqWiTBQpotgUdFukTiGp5c4tmggdXKH0krovn6vmWqtLTV4BbczmT/Q3r8zUILvLfedQ1OIyd0uufAJkOTFfAcKfBHGI2+HaHE5tAldNB1TqI1DvCm9BPKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(44832011)(508600001)(4326008)(9686003)(86362001)(2906002)(83380400001)(33716001)(316002)(38070700005)(54906003)(66476007)(186003)(6506007)(8676002)(66946007)(66556008)(6512007)(6916009)(5660300002)(1076003)(38100700002)(122000001)(66446008)(8936002)(6486002)(76116006)(91956017)(71200400001)(26005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gQ3TuCj5j6hjI5OuMVwEtnEMO43kYGyJ0xqDrSrEAT5ytij7Yw3c5sMTXP+h?=
 =?us-ascii?Q?T6Khh3y69yt5PMI4uroUjpYqhpVlpJIs1eWEMK6Njr4ZKuAEn7s7yaXSWhKW?=
 =?us-ascii?Q?H5co6hhTCviqlQnRTebMIYJ1wLlWAna4Lm6Vm2neVVBpXr610x/sOfd4/9cy?=
 =?us-ascii?Q?tyJBxAAXAATWzc+NT91+o+V4Er6rwTuokASqQJa9gB6j/5RV+HwHqCgMoC9a?=
 =?us-ascii?Q?mpHXavjRGwq4/Q5Ml1p84ENu66CdxwzuGs+iokxuwDewFuFb4ojJFfaVK2Fn?=
 =?us-ascii?Q?CiadfDkr3DVZnDLccddMn1xm4xUXCOZ20ofcZY2P7+kqbXy5DNoTqOFt9ScP?=
 =?us-ascii?Q?ncqNQq3i+LV9e4TeuOLXuvZa4DpPYR8DBPOBEEfNmeRJe3ERUbS7vNDGBqSH?=
 =?us-ascii?Q?KGE+DxB6nUwLsnLKtCQvcmZPDox4RlFc+Tk8L1Y0CbA7sVtWXalCk3wHJ0gP?=
 =?us-ascii?Q?vGJaGVZDbcWXZm1dvKfAfBd1I62QA34AcISnEQsEa0jPUtMa7fJiX2ECNfcP?=
 =?us-ascii?Q?+KhIqC74vHl2if5eLFEEYs8FHyjlUUPiiMdugpO0DnHvq61f/+YxUKbci13J?=
 =?us-ascii?Q?hA+dCD+sQD2T8atkHOjusAgHbehXIoWEsjZQD0xgsL4ShjbrOW1Cyf1U1WQG?=
 =?us-ascii?Q?dW3mwOFMDS0ugGRSEkHFKosGMks+4T5i3QrXITNBnRmw7dLR9Svz4eB6Oh22?=
 =?us-ascii?Q?iKSlYqFLxgWy1XcWeqL5c/heHdYOFKnfvA6nTuX0sockFKWGXc/4melEKZM7?=
 =?us-ascii?Q?ggvHcRfg3UkEjayHEBrn9tblydEqee0k8kI0fFF7K0AJZiIAl32hbzyanrwl?=
 =?us-ascii?Q?lvAqvMJ2fOvM+iZzET9EX5clatR22u6dFyqq3Ulm+URBvrCJLsmrhLA8khzP?=
 =?us-ascii?Q?1KUfQ+CO3GxrVioSlcAOhXI8dPVKO1cWwa6HFdmjSvUDlk8WD3zgEiu6yjOX?=
 =?us-ascii?Q?XL9wun54TbHTGpWNJjBUS0eT3f7yeWYZUHiGUq7C+gsMs16q//Mqv9+zPN1N?=
 =?us-ascii?Q?fLQ1k6KEfNeErhxPrCoXV/Dbh+R1hyUTPi6q6lHpQc7tnNLs7A2P44f0i4LC?=
 =?us-ascii?Q?KyBX1XdLy6zJHdkP3rQ+5wB4A4Uej8cVJ3soTTO/FemTCogv/7LHaekRc+wv?=
 =?us-ascii?Q?nDqOcUoamDK4ERDaQONcppc8VSGvTg/DiNwdoBoSI+/uj47ytkrjq7+Yy/9b?=
 =?us-ascii?Q?G2X+hz8jkc7ilJMjY6zZevrejlblocagmAzwdRNxbqkZh4rI1Aex/SJZ73I1?=
 =?us-ascii?Q?2wrsbOGzV0nVx/o/rykiaFNAnhRIMA/phbCm9k10uLYIDZReXf02QvG5Bmz4?=
 =?us-ascii?Q?0BivPATuZx7aT1ynBkukHPigNJayrMuJJY1dUmRnW0h69ewdZBqUymDZRyht?=
 =?us-ascii?Q?BoPLfMO8+o4Njy6wGVUA0zPNBwOLOBzVF1tyiZbCQ3l5m14pNCor5Y8e/3ZV?=
 =?us-ascii?Q?zafblyVaET1q+cbju7+bvsK3xUJKEr/lNgmP4LTsuuEBvj0YVS7Ku85Fx8pg?=
 =?us-ascii?Q?l4cEHSL62WhvrQDzSVEySRs/sHMJSb/KcB7/hk45Qgm5gSdYYvsnMOgTkgZ1?=
 =?us-ascii?Q?lPBLs447JXIHS59xOg8FQStTUzQDWXKOvbfyjicEW/eE6EkWjH4S9b9PpWVM?=
 =?us-ascii?Q?WdsMJoQ3fVxP3NcoI9A4Yx4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB7CE70F3505754AACC3450CA54B92A7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3f0091-24e7-4fe5-bf1d-08d9aac5a71d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 19:00:13.7010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pdz/WWVvdXQVE3eM2aox5m3et9A4B9wyjcd8oTMIKMWAo9LVe2hpoQsiHWT0yCh74bBO7/TV7B5494fQHAl4lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 08:53:52PM +0200, Vladimir Oltean wrote:
> The VSC9959 switch embedded within NXP LS1028A (and that version of
> Ocelot switches only) supports cut-through forwarding - meaning it can
> start the process of looking up the destination ports for a packet, and
> forward towards those ports, before the entire packet has been received
> (as opposed to the store-and-forward mode).
>=20
> The up side is having lower forwarding latency for large packets. The
> down side is that frames with FCS errors are forwarded instead of being
> dropped. However, erroneous frames do not result in incorrect updates of
> the FDB or incorrect policer updates, since these are processes are
> deferred inside the switch to the end of frame. Since the switch starts
> the cut-through forwarding process after all packet headers (including
> IP, if any) have been processed, packets with large headers and small
> payload do not see the benefit of lower forwarding latency.
>=20
> There are two cases that need special attention.
>=20
> The first is when a packet is multicast (or flooded) to multiple
> destinations, one of which doesn't have cut-through forwarding enabled.
> The switch deals with this automatically by disabling cut-through
> forwarding for the frame towards all destination ports.
>=20
> The second is when a packet is forwarded from a port of lower link speed
> towards a port of higher link speed. This is not handled by the hardware
> and needs software intervention.
>=20
> Enabling cut-through forwarding is done per {egress port, traffic class}.
> I don't see any reason why this would be a configurable option as long
> as it works without issues, and there doesn't appear to be any user
> space configuration tool to toggle this on/off, so this patch enables
> cut-through forwarding on all eligible ports and traffic classes.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I forgot to mark this as such, but please treat it as RFC (aka do not
apply just yet).=
