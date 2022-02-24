Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AACA4C2294
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiBXDow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiBXDov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:44:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC6C25A307;
        Wed, 23 Feb 2022 19:44:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chx8lZ63t3PXKRfLupvux09KVDnyl6HaAewIdNdGxyk8vmtxWkpsvnw/dUWdustqk64FwzWZURdatNGUdvuGfUf3Whn5hoWDVAPJzN/o3VMGLvxlp9+7dT7+ag/ttEASeT2hbb6lIvOCP92i7CbXnSmyOch0H7spRTqwIbMgcArAHwc/med0C6deYIIW9Bmao2qv2PsHPfXeq4dDhFWizde88N3Qq3l28Pb5rMZYYyEDzqreZfrf0EcYdJasKgysL++z1IjD04/S7FXiezWRxCWwVfErVx8VbaWFPTW96EN/8blGL/WHYfMScHrRkAhLzRBzGoPlbDs+VXuG2greHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoZde5qx1lMrDvzqP38rXW6f751S4FCzCQVGeScmF84=;
 b=U1ztv5KnGQVXcu5gpghHsH3Gm051uDPeeFynlTK/GH8HxsonY9KwkhONeU5Mvamgj9uP51WNYMGQVN6OLmf6Hi7adhiCplVd9d5bk+vGxp8X/RR4X7nlWI8GwbfRvLn5vKGzScH4p2BptBk4SAffPXPfTlzzRvncV00SOoCemh3TE9nCo27cVsiE3b81satkyrV8q3agJpwWbENhZqqM06VU2qw76zYDNudyeY9zD9QSYb0JQquP0thj0RSwkkncba+4OhBN5U+h3r0/Jor3lykWGMNwOscqSaR2s863WIi1X9SntkFDEds5j5BmtFGdNMNCrdhiF5Qxaax00vmjqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoZde5qx1lMrDvzqP38rXW6f751S4FCzCQVGeScmF84=;
 b=CG4iCY1eVRtzAFNmtbEiLqA8Ug8LomQTHIMu9ybfWScy8VEojp9aACMLYG+w06mhqllHMILuSSIdJDZtlrh5f7D+aG8oNMc6TSbll6FjdbYKyi+Yb6WVz4wiMRxDtNRbN+UJ/PwZhb0cAn+O2Qxq30HJxmcXWr0f+2wqWfJMzjeI2px/OK+MLuyha638Zm/8W/4Bff08DN3vZ3Kca1pNe/jq3KPu9IQ6yb3lN1VM5spfYU2MabG9GTg2KGCOQ80OiQPLkIlSyh5GKH8RojAaFrUQieciyYylQzTmijfmuCykH19fhj9lwWSFLMHk2luDRwqnUrwauznhoxCUNRT7rQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN6PR1201MB0228.namprd12.prod.outlook.com (2603:10b6:405:57::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 03:44:20 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b%7]) with mapi id 15.20.5017.022; Thu, 24 Feb 2022
 03:44:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Moshe Shemesh <moshe@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Thread-Topic: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Thread-Index: AQHYHyi7LP1bSM9810iOk5A08UDRx6yPHP2AgAPzdgCADw+mAA==
Date:   Thu, 24 Feb 2022 03:44:20 +0000
Message-ID: <PH0PR12MB5481DCB01F443BFC559430C4DC3D9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
 <20220211171251.29c7c241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR12MB548137BB5A70195983DFF74EDC339@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB548137BB5A70195983DFF74EDC339@PH0PR12MB5481.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e206e14-3489-49b1-fba5-08d9f747f0df
x-ms-traffictypediagnostic: BN6PR1201MB0228:EE_
x-microsoft-antispam-prvs: <BN6PR1201MB0228588580F5AB3FB282E153DC3D9@BN6PR1201MB0228.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrEIbpHKaEa/T5pyQWXYz+gcMN3HsvfdGXzGQbBnj8aJ67ifSbsbKQR3Iw1ELZcm/ETrsuyepEju5X7c3NNKBrKFIhUza8TLid+nLvnI/FwL3qXGqIyyAjtnVai1+jGgerCXpHWBUH6cwBZyIzEeX+DIYuRjsBRYSUEi0sjK5G71XpMywAVsMJfao44UYGO3qD4CsCufdVIbLemjc5vEUmWvyLnN1XJE4amd+OZzflieVzZjedJhbGq41myvwPkJFDpZZ4O1oVzb9EOCe+cGm8UxJdoMtL4ziUdtN15FQ1+8A7gLbjDWAk5q+un17scofMyfoUdfQadIePbAnfkVfeqvyJWaDm3jPZ9oQhcJvmHkjEImwTP0cTGzKMMW5KDxXWkH86pEbRkAC0Qf3fDMyykJi2BqwDED+zQjKa25x9MwR5sNj87+Iy2J6foVVjXTSLxWNqYpP1oC+LN9MyyIK9t3Rly303z+0hbMvg1N6qCB7osVSq3pUnE/yyHt4v3kLLLKLfK4zcHqAOvlr2/ptXCXscP0rdPRgv4B30DJFZhsqbFESDpRowTE3Bb4394/VFI2StCuA/PWNF5CWAzNbsZnQBPz/z0y+2UKZt02y1jaJMaISCY4tlHwxtlFGuka8fdJR6O/XQ+QsyswQ3/lXQYXPCAF8bEwLqlW1Wlw8NBVTEwl1RN7GFr081R9a5Ioi7DTITw+o+HodcaC1v/0Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(52536014)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(110136005)(54906003)(5660300002)(6636002)(316002)(8676002)(2906002)(86362001)(9686003)(7696005)(6506007)(4326008)(55016003)(508600001)(71200400001)(38100700002)(83380400001)(26005)(186003)(33656002)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QBPMsk1ZgeRfOvVnXUeNgWR2sQdrrM25arlNrs62UxdemVMzZatVv6bO2vmH?=
 =?us-ascii?Q?n1QFP4v8OT4AoVjHtjzqPRDe0chQuwhuocqgqrLUNrZs1DgRh0aB57Vo5aHk?=
 =?us-ascii?Q?1yX8Ny11Wur8xJy4X4S6LQ/+ZiDqkYFCz2VxxT3OtbZGD2vimNhFZc9/urpu?=
 =?us-ascii?Q?c89DrL6BBGbE0vi8egwsjxsiO+K4t2+VUeiB75rnOlG0lAab/LUFEMPlPpzH?=
 =?us-ascii?Q?m+e9pi3Vd3M3k4vvusnluwMnIMtksY37xaWwPtDOn8QRLZGZxwcQvnUiGmCP?=
 =?us-ascii?Q?uBMxStIRUFrW4UgPyCezFaFXO/5IrNHkqsNqr/wwLB6qlKrhXBD1VAn20Gm9?=
 =?us-ascii?Q?Cpwgn1SlSpqbkhXNkb9n0hCvetHztQBKp5b+Qp3hWSYUBmR5WJAfZ1WkaMcx?=
 =?us-ascii?Q?EeFf9RN1t0qYr/eeJxZ0g4J+rz4jTrrSoJrN6rXHTo37RSagBGWHiIOOICCR?=
 =?us-ascii?Q?uivLeDzF6HsKV/ZCCqcLTOmKZ8272XllY8Eh8B60DgNetTZO5Vikrn05wh5J?=
 =?us-ascii?Q?aAlhKTJMuSQyD2FEEOKs9iNxvgDaXFW2RcZ9q8fTuOioqVxEl91RgQwOuq2K?=
 =?us-ascii?Q?VCCCWh+MMmLpkJVcHnmFwLb9gdXerrlC3G0eAZX4WprFvBI8NNm6YfVkXSeP?=
 =?us-ascii?Q?/ZP1SSZ/sGEpzEE1+4cIXOh8Q4mz7T/lSVhkUZJ58lGi4ZYqcJoAlvdieHXS?=
 =?us-ascii?Q?x2ThcvDcieoTV6DF/diniYy6BpCcPgVBdhEVX2nJObyShklpgWjQr/Ojt1Jf?=
 =?us-ascii?Q?WPv6XUWOd2i2cIHD5uUkEHo+7NBN17PjRIXSBEujnSp7vlui26zfEBFprha8?=
 =?us-ascii?Q?0u+k14G4FZTHHGSWPaTfcnarFzK1Nj3supcjVFK2LK2wm40sPrzdYkpnYnH0?=
 =?us-ascii?Q?PH1v5LC6f+4/I4E5sMwgqLLgdqYb5cTAasx2lxl8WjfWUsrwQ5DEtTH52u7y?=
 =?us-ascii?Q?GYU8IzZ0eRNZvx6IyoR8D2DpveQ1xfc59L/SynQfi6nyt8SFIlWAIqxQh+7j?=
 =?us-ascii?Q?f5mc+4BdOMhK07+spTADuTHqegQA2WgPPjtfNB3eOU3CRXednIY/tNi1Qqxg?=
 =?us-ascii?Q?xo3/84hQCLMa08OYf3GbQiGJkwWC17v7co8eNkVcZILzFt3VpxEEcTCkVVKb?=
 =?us-ascii?Q?5HnUulrqsA1zCaRyQDxefVgl+Uz+gW3isTR11Qv5R2Qv5fg/vMOeYr3yrrGv?=
 =?us-ascii?Q?qgwNEucb6lmoIc4C59ZtwxfoDnxcqm31z0mPLx0OV2SYl5Ktr/pUpxuKfOG7?=
 =?us-ascii?Q?kyhdenV0+iipdhu4Gl0nXkkmhgz9hv9e9dim9Zt5xCIJMUoeqOs2G77tYZ55?=
 =?us-ascii?Q?gvo8CJ8lEef63d8jza03HDIxNqc5KZVyzw3tUk6j/QaAw64SOLXUjol5x+wj?=
 =?us-ascii?Q?svT+jNXsq1TXLUC4EVIvje4OFI8N6crFh7RLZ25MmX/G9u75Cjq8kH54yyZV?=
 =?us-ascii?Q?TAqYFXMjHIcFmeKnwj75PoZtz9FGcewvLOmFN89ZUGFu7+A+YOVnhCo3ZdZv?=
 =?us-ascii?Q?OmrQ+wqnAr2Cc53SohvBbLA+UCyUxhoWQzLbv6j89i9Uedd25sTRvnm+ha8g?=
 =?us-ascii?Q?G+GXFe1o/hSskFwo564PAnn4+sw5SRoxauumMTD52leZ7nrU3hXFnnlatdzj?=
 =?us-ascii?Q?hK0O+/X+s4b0yjciOqZycqs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e206e14-3489-49b1-fba5-08d9f747f0df
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2022 03:44:20.4491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bn5LUjFS9sKIEFlULinW7Cr6Bny5YBF0zzko1RD+u/vZPwe5kd40t704SE9YxnzhyuiAwuvRUemiBNXCHQ7ZoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0228
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Parav Pandit
> Sent: Monday, February 14, 2022 8:16 PM
>=20
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Saturday, February 12, 2022 6:43 AM
> >
> > On Fri, 11 Feb 2022 11:20:17 +0200 Moshe Shemesh wrote:
> > > v1->v2:
> > >  - updated example to make clear SF port and SF device creation PFs
> > >  - added example when SF port and device creation PFs are on
> > > different hosts
> >
> > How does this address my comments?
> >
> Which one?
> Your suggestion in [1] to specify vnet during port function spawning time=
?
> Or
> Your suggestion in [2] to add "noprobe" option?

> Saeed is offline this week, and I want to gather his feedback as well on =
passing
> hints from port spawning side to host side.

Saeed is back. Saeed, others and I discussed the per SF knob further.
The option to indicate to not initialize the SF device during port spawning=
 time is very useful to users.

So, how about crafting below UAPI?
Example:

Esw side:
$ devlink port add <dev> flavour pcisf ..=20
$ devlink port function set <port> hw_addr 00:11:22:33:44:55 initialize fal=
se/true ...

The "initialize" option indicates whether a function should fully initializ=
e or not at driver level on the host side.
When initialize=3Dfalse, the device will spawn but not initialize until a u=
ser on the host initialize it using the existing devlink reload API on this=
 SF device.

For example, on host side, a user will be able to do,
$ devlink dev auxiliary/mlx5_core.sf2 resource/param set
$ devlink dev reload auxiliary/mlx5_core.sf.2
