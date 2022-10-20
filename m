Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE26054F9
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiJTBY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiJTBYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:24:55 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2071d.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::71d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FB61CFC7D;
        Wed, 19 Oct 2022 18:24:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7QMpOUjKYhfpYsiyk3SwadU35gMciKGvPATyzJ1PD1ksU7U0gjfrUy1/UClK44EUadQESUzmI/PFwYeLoY8kCbOBMxswvT+1TUb3HOxPnnlehpWidJMJf2a/duCG7CcX1qdxMbzUJh9fWoHtz8NRlCkOT1/F3wsJ+rVhpbw4c5jIcEpXgcZzZo/eLgfR0MmgdTWqZQjB/OUhJ4pGN8wj297Mqx87oTa/UmN9CmgVvn3HZzm53bWjc1cCtdQF4E7+b2sClkakcn9i9/Vike3Ber5ikNlXWQ3hH1ydlj7X8hlaoDqn640VTj9cvaczsfKwJ2G8v7eHOdaTU6LnKRCnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaTmoaZUYSElEX0oPtLzND/zThr5YE6w1M16heXm2rw=;
 b=NdEV2TbTb7SgiAMZmNyQl0a0fN5cvPxtzenNUldwnWkokutNllHkRThnhi+OI6sXhL8s5LVCF4+IB2Hoi01Ks97XRWJkM5oLaHa9gTpwYPHxbjDooWsSrnC8du1suuiYkiwN0krNVyuFl9+wWCc7+jfYi8AvtCAwxZ9ZCtaQyeGspLzOWipGF6XKzEzBcqZNQoV+nhMndwixky2MevLjZibKS0DOC2zZ8QTstYDdAD3F2gTEHEv++9QIAscMZZehSvYcvH0LGIiDzN46Sqh5uLm3TibgSMPrMgWZeEQlBKToOb0xfhALEgkICYR4KCRCfBVbBwAtUNyanybL8NXttQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaTmoaZUYSElEX0oPtLzND/zThr5YE6w1M16heXm2rw=;
 b=W2TF73ilcyuuo0TVkVRz4jWiJX8G/yOyJXz83aGyaI/SKMPTVlkIpp6yhpA9jlbW/0iiaCxeQgElkAtF/zxlCRAj0l0Oyvk3BMas34ICjKIk6XltN5dCatCswwR0xNQ+73Kz8OJQ8YPXAKbJ6DuvCFIIO8k3J8aDfkIreahaZnI=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY1PR01MB10800.jpnprd01.prod.outlook.com
 (2603:1096:400:324::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 01:20:18 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 01:20:18 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Thread-Topic: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Thread-Index: AQHY45fxzGX2A/ma5EGv/JYGm3jrC64ViGcAgAAPSYCAAOTRoA==
Date:   Thu, 20 Oct 2022 01:20:18 +0000
Message-ID: <TYBPR01MB53419E6A48AC3DD02EE9A940D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019124442.4ab488b2@dellmb> <Y0/h7ecTLYkhOTCw@shell.armlinux.org.uk>
In-Reply-To: <Y0/h7ecTLYkhOTCw@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY1PR01MB10800:EE_
x-ms-office365-filtering-correlation-id: 259b16d3-8e45-4c4a-66c6-08dab2394053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /gnNazg2vBPRRoFiTeJVIEKSOx7ajnMXuHV98BXWrpPFkF9mKVPf6+nn0RBS5sOMurLM0DI6Sx1ZfpGWPRalIAH7jO8GcfDohXVRQmF4hdh0jcY38dZFQuZcdHuyY2c9P+Uc95L3qpqCWG2ckYjWtpIg7oZjCsbr/ZkC16RaWWTWEAuDYETR/Wf2cfmeYM5SF4LPyTdLDzGjbGwTfcpLPNwXXc9mMYD+IW4JVyge0jjaT+pI7qKFriGrgi9s/GfK3h4awO/9TGw6mgdz7G7c0RiAijak9z3WaWtB4Ycn64YBxe85csf2WBfBTeFXHm9uQUUhAiG4O6tyrt2iA3OgWzpiLRlz1Z5g5By8mp9/TrLU04G1ibCD64wXc3SEBFYHGTXZMZqiFwKUwOs4pFx+y5XD73d8GeMwF1neaiGLGuuE0gjogk9vzila2OtCE96K2BF/COjKff0pk6AfugsrdsxH1qNmaSn3ixWNS7hFHPrnOWtSOrGig0EdcS36NSUyAVNEOUYcCfhJLfwHHnUn1QCv1m72lYX2U+FqwMNXM4aRMyqbw2s/fKBjNoYobmsLZos7IsLWgtV19eWyquWXsgGqUvvD/p9Nev4pEt9Xkwy8+KUFn3sQtt/mOQQ97LTKW9kJvo329sonQzeUTci+HP0FrBDnkr0dcZfrUCfmC6HrfgA8B5Pmu7Ru1yDKod9bOVFEflRkrCmVfzlurUdTNjLTqJlCH4GIOxQyEZc9q9UIWOxN+FMT5VW+2lP/2Q5Yxo7qZs8+z2y+yVdA/H507Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(33656002)(86362001)(38100700002)(38070700005)(122000001)(2906002)(4001150100001)(7696005)(55016003)(7416002)(5660300002)(9686003)(186003)(6506007)(83380400001)(66574015)(6916009)(66446008)(71200400001)(478600001)(316002)(54906003)(8676002)(76116006)(66556008)(66946007)(41300700001)(66476007)(4326008)(8936002)(52536014)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?urFGe+fuVajTHNIAbPlxVpGAIpXTdrCPkzu8J+sPJiehXfjj1M1OAnZ6nl?=
 =?iso-8859-1?Q?0FmlQ3LUJ7+Fs0fwnm5lk3PGKAUVe/3aFFYqIEownNvxQ1rtON4BAav4k7?=
 =?iso-8859-1?Q?cdfCTDu/WI0ph5PsBJe44BRozGIEAmSEoa1wuSI0vbu5u1uDuSKrEFdR1I?=
 =?iso-8859-1?Q?tOoIMrG8dcTWsDjS0aMKiejycRFnbUaTCO2hiOtE3v4nDIAZELRFHdw2NF?=
 =?iso-8859-1?Q?Kb09BYCIsGVSvHvhygrLOVPojnDe5ZRptw2OFp4rnTSxa0toSHvOanUBfb?=
 =?iso-8859-1?Q?XE0frZ5fAGkCiISLMkG8yt0qqTi3y+ItvSjW3yUKxnmJ6VXDlp32JDm+iS?=
 =?iso-8859-1?Q?wb6NIEblDJabm5cOOwdYIbBc0juzXsusRG0nOypYcOQzwWoGAk1OBWh6BZ?=
 =?iso-8859-1?Q?7Sz2wQxenZ1NUVFM5EnuBxkWiiaylgfpSwzjJfGzT4upQpVgq5DcS9tu0L?=
 =?iso-8859-1?Q?Flwp6kTQWMQxC9EUYVMt+eQ/LCpFjspVr+IBpC4sovFkweHRDOZtKV4xl1?=
 =?iso-8859-1?Q?gsDjhJ1vv8iEglJNoszYKHPF5mRTeE+UVcTXNjQnANREpOytHCbalqXGlE?=
 =?iso-8859-1?Q?7TcY5VvWuipgv4TOsKbxKu9JWp2SlerZN+j+lmBNbBQJCVwOhY9Mgwaj39?=
 =?iso-8859-1?Q?mDULRDlVA4TcBNwKht6e3XShqFc7KOzfTITsyg2zeyE39FjQqb0oE623Kl?=
 =?iso-8859-1?Q?mNDRqn+7Z0L20C0rRHc6xH5p0DmwsvjaMqstHS/n+Q7AUUd78xIthILY3z?=
 =?iso-8859-1?Q?wnkKptpP+HkWHk1fMUiPsRvt2x8J4b+pWfLA5xqAAAUQMjFHZeukjdfo5D?=
 =?iso-8859-1?Q?ElRe4SmGxFYBT+VAC2o637ljWIoDUS2cSAEFJMqQfg/i8YwJg7XsTiQ3a7?=
 =?iso-8859-1?Q?tyiB4edekFT7SInboCMMSR20smUU50OfRUQOcx86rT4ceBV1rU3bp8rge2?=
 =?iso-8859-1?Q?s3+cwCVrwZTHCIwfCxbYURI/e2CTU5zOTf3IB2dhEAfY4SMfRIwRnRT6Xa?=
 =?iso-8859-1?Q?I2YrSm2xqmoDmqJL4OWPEiNlO20lkfwokBxtn6PuI6IWiTk0OGfGZkoJKK?=
 =?iso-8859-1?Q?bhBFZ+2qV+vLL/rTPK+mCqpStuUUojg4PrmoSSXFkXb+9lbZdRh5BylBYh?=
 =?iso-8859-1?Q?PRg2unYS9anSyVxXVR/qLNkrgFLS54NekF1pmpA8VBSoEcryG2JNt5P1gM?=
 =?iso-8859-1?Q?pjaGueSWfXajH5tNDQVTkcmxOaKFdzhH2Ie8yHGT+unlU7wrtS9z65gpX5?=
 =?iso-8859-1?Q?yzZ7PALtrgEt/NNC7nsjkPXeuQnkufT2xVE5Dtr6LpZ6qKam0/1tYaF0Gr?=
 =?iso-8859-1?Q?ibCoGU4BxAQuLZ8vfxHUjAiKjAR9HHGrHw6qnpmWOhLQBTL5OMioVK0KVp?=
 =?iso-8859-1?Q?mjbwvgzrD1EZkNV5zBW86jKyujoD2HUKOOQmhxPjgCZhxR0Tf4I03zZxXl?=
 =?iso-8859-1?Q?uEcSo5iA/EfRFJzKgDSynnUExgAeWcQye2IPnhMX3eNug0HV6cFWuQR9wx?=
 =?iso-8859-1?Q?krD0O45EhTyexAKXqTGp/AMwNlbdieJr2poRVbfxeCCyQUKpC8CUswVT0V?=
 =?iso-8859-1?Q?EHyrNiXJNzUrHYSC7EtWbiQZ7Vvz5QmfzsJXuI4UeNtAIrsRPCApE19Ykl?=
 =?iso-8859-1?Q?8xAlXJe6kalWVLG25hqufzRRprnFqh7hlh2X3UIAsl2zRopZAmH8P0iE5m?=
 =?iso-8859-1?Q?U9ZO4+YO3Ouew3G85m1SA70HBj0SqPpANNjzEmQrYMcj14pTdIarjg/wV1?=
 =?iso-8859-1?Q?gb1w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259b16d3-8e45-4c4a-66c6-08dab2394053
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 01:20:18.8265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHZg2L9RrstyB1Ezcv2Stjb927Y9dDF5RATbviE81sCqKko0pjQC9WhS5z0u1iC9LGOvpOU07EMQM+ez6jwjFs+iXuFaRNVyMWQHa7SxIYUS+CYYUE0ZOkV/ey64UhEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB10800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

> From: Russell King, Sent: Wednesday, October 19, 2022 8:39 PM
>=20
> On Wed, Oct 19, 2022 at 12:44:42PM +0200, Marek Beh=FAn wrote:
> > On Wed, 19 Oct 2022 17:50:49 +0900
> > Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> >
> > > R-Car S4-8 environment board requires to change the host interface
> > > as SGMII and the host speed as 1000 Mbps because the strap pin was
> > > other mode, but the SoC/board cannot work on that mode. Also, after
> > > the SoC initialized the SERDES once, we cannot re-initialized it
> > > because the initialized procedure seems all black magic...
> >
> > Can you tell us which exact mode is configured by the strapping pins?
> > Isn't it sufficient to just set the MACTYPE to SGMII, without
> > configuring speed?
>=20
> (To Yoshihiro Shimoda)
>=20
> Please note that I don't seem to have the patches to review - and as
> maintainer of the driver, I therefore NAK this series until I can
> review it.
>=20
> I'm guessing the reason I don't have them is:
>=20
> 2022-10-19 09:51:17 H=3Drelmlor1.renesas.com (relmlie5.idc.renesas.com) [=
210.160.252.171]:58218 I=3D[78.32.30.218]:25 F=3D<>
> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
> 2022-10-19 09:51:17 H=3Drelmlor2.renesas.com (relmlie6.idc.renesas.com) [=
210.160.252.172]:24399 I=3D[78.32.30.218]:25 F=3D<>
> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
> 2022-10-19 09:51:18 H=3Drelmlor1.renesas.com (relmlie5.idc.renesas.com) [=
210.160.252.171]:58218 I=3D[78.32.30.218]:25 F=3D<>
> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
> 2022-10-19 09:51:19 H=3Drelmlor1.renesas.com (relmlie5.idc.renesas.com) [=
210.160.252.171]:58218 I=3D[78.32.30.218]:25 F=3D<>
> rejected RCPT <linux@armlinux.org.uk>: Faked bounce
>=20
> Why are you sending patches using the NULL envelope sender - this is a
> common trick used by spammers and scammers to get their messages
> through. Please don't.

I'm sorry about this. I'll stop such sending patches.

Best regards,
Yoshihiro Shimoda

> (In case anyone questions this - as all my email is sent from encoded
> envelope from addresses rather than my published addresses, bounces
> do still work.)
>=20
> Thanks.

