Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED915AF13B
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiIFQzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiIFQyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:54:47 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2080.outbound.protection.outlook.com [40.107.105.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2620C8B2D4
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:41:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6mOhcSFnsrSHKRhCMVwEZRpyDx692QSsyKmObngWrfvFpnjOIE8a2CUNBKO6cP6VcY/n56diVR7y0VgfBcLcpAEDSk3ucuCH2UyM2/H8fcCDLdy036D/yOBTHQ1zNEDhJP7W3fhJkWqz1xaYKiW2N3F/0STNvGVsYPHIDaHrWje5oOblfiBqMqfb0xJ04VgXgOVwGi1UfzVJX7AYwx2mFwk1WxS54CtLRI3zLb3W2+1lYuTuON6X+s8HMOm8x0slUQhKxHRfkJW8fRwrccXYWuxjGuD037j6a6z97RFiNr+2HrDhPH5jx7j3m3pzvX5ujWjEaFD2bfGa1vxTBzQ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49QkfDyEhk1FRcai9k5rFkdiG8qiIkMeMPOBeOc3siQ=;
 b=Gv8dOPqu4MUMW4x7pxovM0PawcfPF1PIJzBl1sIaYTiiLqub+6D9Yg+tsxnCvR+JcH2mvWodZSSeHQN4xPAmr1CTNdRd/x5MpyricqpgFAvH9SZ5GEpLgRbyRLQO6it0N42ivrZFIAdiZ1Uteig1K0ymf6Sb7ny0tzBSL3CWfeX+m87Kp2XJ6uRW/PEjN5j1nNRsqWTaOG7L8aWe/QDE03oy9qOv9bAyjPYxF0WgD/YO1rZaeX8Ib7W8RN2q9za3ZDMpE/jYyy9llvy9PtbXqnaL/Mb1JTkhyFMaywnW+0dv1fTe1mJOxY9Bx+cMyEIhKRTZYixLjtS70F59+k/TfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49QkfDyEhk1FRcai9k5rFkdiG8qiIkMeMPOBeOc3siQ=;
 b=jCxqxL3XPhnm4yUL5qgD94KFFoEupUgYEixrkYpRjjCuc8MhabkaTS3NzsbK/MmVVniCHlU8DVvzHoA/8Lf5Ww5NjVQ49vBn+jSN3XnlLkroV5dvVzJGLzJ02yi9PpD7DkOaxc1sjvhL7v66fw6f41PagBwWhPL8bUaVM1agKzc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6266.eurprd04.prod.outlook.com (2603:10a6:10:ce::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:41:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Tue, 6 Sep 2022
 16:41:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Topic: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Index: AQHYwJCiMb7bHcv8sUSdQE+5fVlfzq3Sia2AgAAUKYA=
Date:   Tue, 6 Sep 2022 16:41:17 +0000
Message-ID: <20220906164117.7eiirl4gm6bho2ko@skbuf>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
In-Reply-To: <20220906082907.5c1f8398@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 817134df-fef3-4ba3-e792-08da90269f0a
x-ms-traffictypediagnostic: DBBPR04MB6266:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kkIhk+eUpahO4uq1t2d88N3sU0DVmMP8Jnag3Fveyqheb47HyRient2Pfspvo/sklyi+HJt0+CL1fJdRrj5T+USVhupbF5+eahRSjhRGxWnYa2Sr5YRRdUEbRhLjWnMRam0kjCTknqLMVttgY+GlxjKZPx/QNg5FFQD7eD84zCjaFWF9UEHmG+KFCXkjWKacj9NUceUqtnmHGX8SRp170hALopkS0zgisuiFp8XxVwwoG1UsAWQuavp5LqHGaAszmIZcvUGT7juwOwwfhyePQ12xAHnsQioCNqD42EP51wo4X7miTDICcF5TLFENtfAoOAyr8bVTiHRrxCGR3ux3JSjyXdVqC/x3alhzak8Ya/uualr4mMYzTu2SNgzf536cbeqHZSxU3W4dyzn5BBXSA4U3ubxrBbzIFfWtAK47+C26m3A69OnBXWlcROiBmByPYoSHPoXLN+3Z+qmDw31xC5ORSHAh4KVUnxa00ivl1R0i/zPN8L2CSper43diwRp0vDzlhDZKVVHDIjA1MGTYp3awR/+thnWZ284tG/P91yPC3i6dmQ19GjHx0ymJO9FTvpyZltDctWRUxNKcS4tIban+YK4H0XsYZ5szX2ClWAs72cbLVkOIv+54KQlOkjFQz46mwKGIuSMc3EfsZhxv4LU5J8O1pgd6OZmlpWQacdfmTvo8I+ew7X4+nTcNWwdEQsMxW90CxwDZ+Px9sXhNXVs/mfKkCW/N7Np6hVJYhrIc5zwUXu1fslMtqpDRJvtQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(6486002)(38100700002)(1076003)(186003)(478600001)(6506007)(41300700001)(86362001)(122000001)(9686003)(6512007)(38070700005)(71200400001)(26005)(6916009)(54906003)(33716001)(316002)(8936002)(2906002)(4326008)(66476007)(8676002)(66946007)(64756008)(66446008)(76116006)(66556008)(44832011)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wb+ClfJ2nuzZVj/2rVF/WooFu78m8em7GbewupVta35PNT2Ep67hON11Kolu?=
 =?us-ascii?Q?NhPg15ZHnMWBxTC5PO+mQYmcKFnrs9oyR13MaoC3ENyDh/56XaGrvLq3Dv35?=
 =?us-ascii?Q?+ZoKqD4NfQaGufPr5qbG7DZtpDIe4e9lfZNOD9UbcjsctLXpxXIw/i44n2Tl?=
 =?us-ascii?Q?o4V1qIL6i6tdAfdlfWMw1aCMDsZKneRqKuTo8+6IGvm4cIwMkL061v7rvf1L?=
 =?us-ascii?Q?WqgY6EoPAPb+I4ss8HATq/ZcvG6I5hX2cmTcPnMBd0GbwHgEKjqBXSTYGaa/?=
 =?us-ascii?Q?fHZyl/677Dq2Gdq/xXnfT6WxL0okwvogJy7Ak5tHvEhLt8fnHkRu64CWRIyE?=
 =?us-ascii?Q?31TuNXo/Kbw17H+Gi88Y2pthyCfxmt0VGC7qYcagdPgVG8CfNKhdhn/JFUii?=
 =?us-ascii?Q?uXuqBaGbPjiDdPiXgrcsxwW4cuOBgrYdCYXzgl+kaEazaeEgzbgi+8LuRXgO?=
 =?us-ascii?Q?6AgXMTVw1yHDKkn8MP1+Ov20nbFYDc+O4V5TIILvDuFMlWKIJ/QSDpULQGa5?=
 =?us-ascii?Q?e1zNCN4BCKMuuHQnMn/JCYQNBTfjvVKxOlWVam/4gXhaT0EyBOSAgo2zY2zc?=
 =?us-ascii?Q?uuCUqiQ0n/Ki69DnceO2YxIbZrx1N9RvbXloVuS1PblOZgxvBSMioEsVAxnz?=
 =?us-ascii?Q?26jV5WxorqVXqekseGNhjpiBeHzrKxZgx/e5neNN26r21zpi48y2T8pFvtTc?=
 =?us-ascii?Q?WVdocpqWareAmNAxvqPkWbjUqTV7N0cDZfvHzcBDmvTRRU+5nu+vrQph2ZXE?=
 =?us-ascii?Q?4KQq4Tgim5FThxuUueIz2woRoqiJDZsTe5XcSofmvkw2kYY5k18ZqWrVKE4u?=
 =?us-ascii?Q?3I4eRsDGQxBAq882eFaO+EHMH1ONKVcmdsa/Hjk4ImIa8jdaYN1J2hLrUTt6?=
 =?us-ascii?Q?ri4UxKvO9KhFamJAQ7ktmwE0jILMskNIG0J7L6oONfdXkeOtL22ct1IIP3Mo?=
 =?us-ascii?Q?yC4ZdIYBGoswBEAAgco4seX7ycEwE/zEpZawMcNU8egx+STaLygaqfsi4GDG?=
 =?us-ascii?Q?bvlE/CQ0AV7+w32WmO+7TNcGvS2kEHv5hEeSHbJI1rwC2K67GGUaz9qljPPd?=
 =?us-ascii?Q?3YNUzfrAHBP/tK8JAWUSqEVG4f7YF8MeCV8H3tLizjnCyi6K3cT/HfT96MBa?=
 =?us-ascii?Q?oh4vOjz3vpj1DtY/cdA2qhf/6optGH0RuYyDEg1m0hPmcTANHBarfJ5nw52W?=
 =?us-ascii?Q?OnNGxg1LJ2n+YUKfcUq+sccNN0IiQN0iiueypRr13oS9sUBH4XzvsXLuHDoD?=
 =?us-ascii?Q?NvHqHXynxFybIuzDsyBDiLIj0vk7wYE1ChSnNfy5+c0iFeUlFOQLhkFLuWU7?=
 =?us-ascii?Q?bSHImpwPTbXk3+PADzJBm3NMSQBKoC9Hr39fl4ZQdAdNC9Isptji5kakYfn4?=
 =?us-ascii?Q?huumpZFL9QzGIWLrsxN4fY7nShQJso6geG65bI8LejIcArHvofDZcU5XXbUt?=
 =?us-ascii?Q?RPZRb9nhUY4lJV7Ee2sEmClLeMAIGUmYt+5i5BexmBkf+HYiUAeFBpk0zvwy?=
 =?us-ascii?Q?WJbP/H6uHB4S7uQY0OAkYUW2+njgYzvfG720Ze4Y5Hc6bDMbq6Pw6vPlKPea?=
 =?us-ascii?Q?/h+E2J4w5/1GJjjZa5n70o4zItC7SgggFGlO2O9s0Q40q+cszbgh+S60jLoF?=
 =?us-ascii?Q?tA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4088D74B96BDC040B3650E2ADFAAD808@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817134df-fef3-4ba3-e792-08da90269f0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 16:41:17.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0CNldl25eHVcLEwb/Y+l9AMglGqSI1I1N3YTvc/pDkD7hsmwEZLoCXrc9PqX1C7EaNPOZiZZBclKgEJfvqAxrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6266
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:29:07AM -0700, Stephen Hemminger wrote:
> On Sun,  4 Sep 2022 22:00:25 +0300
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> > Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
> > export reads/writes to IFLA_DSA_MASTER.
> >=20
> > Examples:
> >=20
> > $ ip link set swp0 type dsa master eth1
> >=20
> > $ ip -d link show dev swp0
> >     (...)
> >     dsa master eth0
> >=20
> > $ ip -d -j link show swp0
> > [
> > 	{
> > 		"link": "eth1",
> > 		"linkinfo": {
> > 			"info_kind": "dsa",
> > 			"info_data": {
> > 				"master": "eth1"
> > 			}
> > 		},
> > 	}
> > ]
> >=20
> > Note that by construction and as shown in the example, the IFLA_LINK
> > reported by a DSA user port is identical to what is reported through
> > IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
> > meaning to make it writable would clash with other users of IFLA_LINK
> > (vlan etc) for which writing this property does not make sense.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
>=20
> Using the term master is an unfortunate choice.
> Although it is common practice in Linux it is not part of any
> current standard and goes against the Linux Foundation non-inclusive
> naming policy.

Concretely, what is it that you propose?=
