Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9887364C4D1
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiLNIPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiLNIPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:15:31 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2110.outbound.protection.outlook.com [40.107.114.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B0B257;
        Wed, 14 Dec 2022 00:15:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV6w46/n5vxXZYE4L2QbAna7ngAgOgu8pz947S3BheV3/FuDttEZSM36gqVVMU4HLcyJkKQpiFMhkOUE5XJIs8rgBpH8b8cj+aoehjooQfDaNFjNeoDCXW8RIlR9TNC5O89WcDlmwRMGHrCfw79twCF5X9W9qeq65+In2tVC2CuJ4ICYk1wI/FCZucysLnTbUXF2nSQVWAWmdMAGi3y3uPpFyH630yT6HDOEC0aSvt5iMtEtmba8iQMc0SPSwoQXuPtxn+mr5NvCTm9jaK5Oj0q3BMUb3KRSpdCbemuBGE0gLax5JmhRxqtaCy23T01tiP1XJCgUJBiJCVqN6Co3kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMhlpsoF8nQrGp0W9aPBf6S1hHSAtbdiLjOT5AMooxQ=;
 b=cBQ/Zn9JZ3NlHOelcm3UNI9ONBKqHrOiGcMphhgYBa/AV9Lmh5DQr2viG/Xi5pTRhFJWMjtxy3ktSCFCVR+68l7Mb7CCI6Oo26LEt0KB6CVWetI5iGJz4jw+LBe7wUhhUNj+2Kyjqk1HfmUAHBDyLcxEXW5PeFkeuPzJctf6Act1DN3D8mQ2JDgwgzyCQqclc2HqrV3qXwBepKnUbatrJh3jZuBR8SCndyRbG9NrNTcAkg9YuGcY/FXSsqAkW3PaDS5i0MfkOsqCgEzqktIf0/CASU3tW/Kcwv6LcnLQCDDf8waA881Fcu5Vyiaz9GmwpYP3+jXo5VC6wPHyaxRPtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMhlpsoF8nQrGp0W9aPBf6S1hHSAtbdiLjOT5AMooxQ=;
 b=K7q+b0CJQKYdit22ddy2ix2FyX08pN72wG3wA0Cu9vutXedOqV8MikJVVJl2I4KKMEEpTS1FJ0CKGCU1KP/6MpYxsScjVqNz/0j4wnSN9pJHwo6AQ3SYrzSzeaVqxQBJ3PT3BI8hzAhtJiUWdwkoBEapBBTv+0pWZyshT1/vYJU=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB6066.jpnprd01.prod.outlook.com (2603:1096:604:ca::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 08:15:28 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::69ad:8673:1ba1:d7]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::69ad:8673:1ba1:d7%3]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 08:15:28 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Masaru Nagai <masaru.nagai.vx@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Thread-Topic: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Thread-Index: AQHZDtmipYXx67GR80mASzVGjQ8KR65s97CAgAANglCAAAS2gIAAAINw
Date:   Wed, 14 Dec 2022 08:15:27 +0000
Message-ID: <OS0PR01MB59227BDF7D849406D618F83286E09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
 <Y5l2Ix2W8yPLycIB@unreal>
 <OS0PR01MB5922BB03158ED90DD2B82DBE86E09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <Y5mFa2CgDcm2k6fh@unreal>
In-Reply-To: <Y5mFa2CgDcm2k6fh@unreal>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS0PR01MB6066:EE_
x-ms-office365-filtering-correlation-id: 7ecfcfe4-bfb6-4659-cfbc-08daddab5c1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vCZzoSuGVUuSelGC/6kPc4KeK1TWuWtBrRBf7Wt5DbapDPPSwR5MSLrd2O/gjTmuDOJqvolXEMcNHJAC9GUH0AK7z7H8OIZoGvH+meIf6SkgJ63SnU+4wPsqcV3TWePq9AbLacVLWGTdaxIdU7CAOCdFhYwM4nNNNNatNxz6cHh1bxxjJYKumkxr3eIPwCXobriuWwQIa7bzfKs9Sg1XJKUiEZ/fK0Ccv5ACfD6oY5WqvukJoIO4YikroJ4aW6dOG0JMXJxS+JPOT1aSvYl5LLeyfClr5qiTzToOoWxExsukPg/H5c2bCnoID9/zo3/1UYO3aqZRlyb585MHpKNm90eT8clxXiir8O3+sW8jBNjHwVxA6FDCNulGxrRFGrD4B0aQ04snrmPo/NC+QNiCGblwAnrG6JTU8lRo9ELGqsQDFcKknAN+fDWNv6JJXrbpeTzhQ4x5unUeksypwFIldSdW+AJULp0gLAQRAHAPwqcA9AVjndqFHo07qX9eJktBLYGx0XsXEKhTDi12hsuyYPYIK/Rxa8/H12ILoQJeb9eq6feXOXKuhFjwhE1dXS2DvUpmLirya6q3f3Vj76XLLy9oUSkIGaFri4T7teXYgLJ7VV8dZzstdmhd35V9pnSgoSZlPxGqMLsTbZc7dD4NzGAk405rWCqTrzBHwlCkbiIiK57h6+0ZPkXx1CeN1CYS1BPiNqNgOPtkVKVDL6GBUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199015)(7696005)(6506007)(9686003)(71200400001)(186003)(26005)(122000001)(15650500001)(2906002)(478600001)(54906003)(6916009)(316002)(38100700002)(8676002)(64756008)(66446008)(66476007)(4326008)(66556008)(76116006)(66946007)(52536014)(8936002)(38070700005)(41300700001)(83380400001)(7416002)(5660300002)(86362001)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AX9Amsn5LAdgcfDxWtEUBXTav+PQSOmqKH8qpFE+mm8IkFcp9vDrlju3bx2u?=
 =?us-ascii?Q?wejdqef6TK74H0mgpw0iHiAFEjVWNbBsvB4Gz2E7SsMPoqM3hndvcEVaPCso?=
 =?us-ascii?Q?9QmpttNTsxzr2qh7Nd7iDrjA9/nRnTnLXd1Vw23tsHw2Hfh6dFWLJ1IntX72?=
 =?us-ascii?Q?f2MTrLjbC7e3CFiYPxcZKBtbyYVtNrc7VPY80aUd7ZgGUcuCE3FPgE5/NMO6?=
 =?us-ascii?Q?LS3Y9tMjYn15VpXvtZz37U7qXe4gBsnnivTC+MhXaGEq0tEP05YoKJagVsCM?=
 =?us-ascii?Q?RFuw9z/ouBEg2AcH9rzss9sWHMiVzB9WZzNEw+cG6Ld3F8c0ESlsMhV9N+3v?=
 =?us-ascii?Q?XwXvJq81TPGLxnv9P5DvlBkkdfcJSgG1APKJOCHm9yr15rv91WAQpY5rAEza?=
 =?us-ascii?Q?HaBs8CpPjrCZ8L08evRiayThRHRJwfmuJHn0h7B82/BszehpjOfhunCVRApa?=
 =?us-ascii?Q?Xgql1Cf12o/y8lnY6adgN5Xyhl1zMx4D2NKsNIEYt8nEkaoxSpH4zWcUikvg?=
 =?us-ascii?Q?KQwViyKF/RQjB+63hySTVcg4++sGKiDSA/QEnd4Y9aCDXboANHWhqg5R214g?=
 =?us-ascii?Q?yQdtsWCrZkckLSeGdDBD8yaB8ctHRD60sY88WL8mgNwcE1Khtp9oZ1mo0acd?=
 =?us-ascii?Q?bMnpnGFNlk0MEtVFlKDYnMnRoXtmH68/TtmoRMGTlSo5f75vHYWPj8umCLi1?=
 =?us-ascii?Q?86T3pPuUSUa1xHP6EpE5gzkT9dLysZFsY6w+wCMVhcI7iqqw02FljGVWE1tR?=
 =?us-ascii?Q?fHVwxjFd54J2vYvBKxtS0DbodYCNGokw7b9Y/61AMDv9zl3l5iXCP05WKmDj?=
 =?us-ascii?Q?a6OrAqj32mH7LbzAEui4ZXXEFQ6HrIgYxS0VJlvC9RVWEViwcq7rYhBIZD4Q?=
 =?us-ascii?Q?EUXS5mc9EWwaxJhB4E3ztVL5vqqAau/J8Cwp0jBiV4bpDMIjFKJ+v/4xeyDZ?=
 =?us-ascii?Q?SK8Svbrq947LMx9vIZUwGw3TCa341wNqgiVr3BANkRMddSVWOS/Sy3etBaOm?=
 =?us-ascii?Q?BdsH/4L8dIBMpb0kH5/tmNfOmm9yvaAwIv6FIcXIUln+hNBc1a5jgOZWI2M5?=
 =?us-ascii?Q?joK09AMNGdgv41L4k5YG3KMo+9SPdvOuVp7a+3zv27+CBN1Tc3NVVVLDaxLf?=
 =?us-ascii?Q?YDwymMDcmaHdrhamc4n/pWJRc6sLE9domubQb3I6O6XhA2oPwgVONNvZU/3b?=
 =?us-ascii?Q?2VEWpTBqSWFf7AfKBCUez8nqAOCJmCCHymXHQv4HUPKfK/804QbNjJXyzJkK?=
 =?us-ascii?Q?W8b6KNGzXGxUWpo+TO0aMzN2WaM9J4Lfb1vrhcGEo2kglfPcvVMQkfd6ft0w?=
 =?us-ascii?Q?W9NBpQEEFi/pRzVrai4ykcEbat9ggiHq0BeFseX2TNWBRkaLSZeFfzmsqovJ?=
 =?us-ascii?Q?kLJsiK330aUfacf0zNLvh7tiP0bNVAhTlQXlIwpBR6DSZFK+UWMRLktJ8Mc/?=
 =?us-ascii?Q?4lAwTwxtlgPJC2IQrf9q/TuiJkCYK7gVL4IORze0lSh70jHaxQAg4uJDjYRL?=
 =?us-ascii?Q?Pd4rw5SirLubimWldbmWEVAFsLPqAZEtn/iv7diAwjOYjUmSNtjzClWrUogi?=
 =?us-ascii?Q?dpHGb/PQbtnSHaDmuqOzh6jyE4+pILvVfYedft4+boHzLhsy7bTxcESL/Gs2?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecfcfe4-bfb6-4659-cfbc-08daddab5c1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 08:15:28.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6NMSTD/ygJJknRHfvibDyXOSPHLLUsWoUwludhi7igKjsyrjCPCsohAT+dDdv5xh413B2ktjhkYKUu2j7c+o1Eg/JoP0jNFk1wJ1IGPGo5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB6066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to confi=
g
> mode" message during unbind
>=20
> On Wed, Dec 14, 2022 at 08:07:55AM +0000, Biju Das wrote:
> > Hi Leon Romanovsky,
> >
> > Thanks for the feedback.
> >
> > > Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to
> > > config mode" message during unbind
> > >
> > > On Tue, Dec 13, 2022 at 09:59:38AM +0000, Biju Das wrote:
> > > > This patch fixes the error "ravb 11c20000.ethernet eth0: failed to
> > > > switch device to config mode" during unbind.
> > > >
> > > > We are doing register access after pm_runtime_put_sync().
> > > >
> > > > We usually do cleanup in reverse order of init. Currently in
> > > > remove(), the "pm_runtime_put_sync" is not in reverse order.
> > > >
> > > > Probe
> > > > 	reset_control_deassert(rstc);
> > > > 	pm_runtime_enable(&pdev->dev);
> > > > 	pm_runtime_get_sync(&pdev->dev);
> > > >
> > > > remove
> > > > 	pm_runtime_put_sync(&pdev->dev);
> > > > 	unregister_netdev(ndev);
> > > > 	..
> > > > 	ravb_mdio_release(priv);
> > > > 	pm_runtime_disable(&pdev->dev);
> > > >
> > > > Consider the call to unregister_netdev()
> > > > unregister_netdev->unregister_netdevice_queue->rollback_registered
> > > > _man y that calls the below functions which access the registers
> > > > after
> > > > pm_runtime_put_sync()
> > > >  1) ravb_get_stats
> > > >  2) ravb_close
> > > >
> > > > Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
> > >
> > > I don't know how you came to this fixes line, but the more correct
> > > one is
> > > c156633f1353 ("Renesas Ethernet AVB driver proper")
> >
> > I got the details from [1]. The file name is renamed immediately after
> c156633f1353.
> >
> > So from Stable backporting point I feel [1] is better.
>=20
> No, you should use correct tag from the beginning, @stable will figure it=
.

OK will send v2 with PATCH net and correct fixes tag.

Cheers,
Biju
