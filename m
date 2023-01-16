Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FFE66CF71
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjAPTTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjAPTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:19:32 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B812B63A;
        Mon, 16 Jan 2023 11:19:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfySI6ab8HQvTLrR9o8sVKsJZjuOjyKUr9hF/CIQ6MnhV76oErH9IS/TbBy2drPucA7/gHeggNDoDBOTTz9VKfMk/GGz5HqgHtoQ8Hkf1zMnZnAH57yVziAbOvEuk63NGl4BBL7gDSrNK8fLkIT1GYCgBOIricjm6spFAQH0YfEGNXh7kZkxq5kEeYMjywF/iuNp1SGVmvNuksA6GkVuk6Ns9gPeQf2zLgb7lVhJ975jDo4dCMU6R/UQzWeOtHT6HTVsfs5Mou0SaFHQLv9EJQOeU2qRr080/i0Gcc5ioHbrhYHxfCoLleX05KXy61NiCyZllZyiiomEkImIAuasyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIWuEzuBR/sKsUqtXkN9X/Dre6yJbGMUvWROl97qdEU=;
 b=RY18YCiMwg3FMmOOjJAfMicSSXIZOIFpoabPQPCD+C8W5Ok80QoHvxmab6YQeNKeCQ9HrcAFfJkSCGzWlhFveg6G8mb+JoJbR3AB+PQcubWXsv3zJhkW2tGvgvXhnQ4lNwiNCPPbvypsaWOYx2Xpdao5WBgFtThpfQ25zUlS/ifcRrFHorr5HaZTUpD38HorpWtnEycb1YvzECqpmJCxB8csyHsKl2CTCncCsdnwfZNpZDJH+8UwMYLgRfUimWXmpP4l8+hop05Y0xubqbL6oJjGcNy2OB2CWOonQZymWSRhclmmc/v0eJTgm9QqpevU5UOH/3JhNodUlX7oQHxqCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIWuEzuBR/sKsUqtXkN9X/Dre6yJbGMUvWROl97qdEU=;
 b=P39CLYes91XKzyjzJo4d9/LitjovRonfFBMkEdrQZfIFsIQk+KM7wHr+s6uEj3Ch8Lf3R6/3zp1YrIjOZIgGOCH35V+k4M0L+ColF3Qv6TZc6P1asLvduqwATsdxwXky2/9wqly7etwFMBR4brD7jAsp2O61LrOVExnvKFtcxWX9e6Zs1oJDXwmCvNoRbZgDYarkrwlOLVXeMm9iiBXtUxQhs8sz65AQ4pKrMyWP0k+uEmNXVzeawakEXltecBVp5egTNwyvtpCo8loYg71R5j9ePvZrckpq0ojcrRPozO272uemIJdj/SJ304jthiUkLY8cESEJaC9DScTD3cDuOw==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by PAWPR08MB9711.eurprd08.prod.outlook.com (2603:10a6:102:2ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 19:19:28 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 19:19:28 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
CC:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Topic: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Index: AQHZKSmr1PIgZgy/I0G8u4g9Yr5d7K6gBiKAgAAHoYCAAJo0AIAAw9cD
Date:   Mon, 16 Jan 2023 19:19:28 +0000
Message-ID: <AM6PR08MB4376E34F5E143E2676271043FFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <5899558.lOV4Wx5bFT@steina-w>
In-Reply-To: <5899558.lOV4Wx5bFT@steina-w>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|PAWPR08MB9711:EE_
x-ms-office365-filtering-correlation-id: 41e94324-0805-4186-1821-08daf7f69648
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ifgzVqtMjPjmHpTuo5Hycx03l9ItWFwqh2kOYfBkWxS++o2DLw4A/HrEbOrDa5V407YFRvBp28NZLl16jHBBYew/aS54TuKT9uES0ab6zWR90jpu/cUw3QwVev/IZ3cGTdfv0fFd+Lg0OWM9DC1Dmfk8paXtv25AscAaKQC2XCAr4NH4BSseDqW53g8C+Nv6WlwYubs24dlY/2H1NhOtCtaW2CFpRjTsH8G9PLMJ71xdDh5Lj6DfyIqvKnwOzPqfKZ6/GvygRzgR4cBnFmsoLXiHhshpHAnAH7gQaP++lCgkeq/8fYnlwSXv040pQ/SaWmlNL+9I2zLpxsr/UTYwjAXx2Gp2mp7bGacBR6RdksCUEkbcsPue9/POMLeYptw8BcEx4ffqiF7wLGUz7QtCXByMULPy0C8wjMYDKa6ZqVuLDqxUdvstVTwTLenRymLpPVWsxLv7XMJm1tSZxOxytpzoD9SgNhGW/48MooI680VM4DnJeb0JwgXtUy63tIoq7Hn0xc2w9yApDoWMFuSSceA2+P4rS822iFtzeY2XJqPbq6lNrileZJA38qg4PACq/CZ1Zf3Lj42klJuDYmIAkexzaaNpqHHLdvBaX0CKGqcwTIlLFc5hoJ7l+XIDmEe7siJ2Qv8ZI5GAHue/GTDrfvm5vzAoxfGYR+HBuIo/AXYMHgILQvAhbOq4uo1qOZObLWyI9oQJHPsxK27JMLiyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39840400004)(396003)(376002)(136003)(346002)(451199015)(2906002)(86362001)(122000001)(38100700002)(55016003)(33656002)(54906003)(110136005)(7696005)(71200400001)(316002)(38070700005)(76116006)(66476007)(8676002)(64756008)(41300700001)(91956017)(4326008)(66556008)(66446008)(5660300002)(7416002)(107886003)(6506007)(66946007)(52536014)(53546011)(186003)(8936002)(83380400001)(26005)(478600001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?G8JAsMmCLcpwjDxNIgW1G33FCoq2l3RDUezomujhKA7aFFt7QrnuAdWJ+w?=
 =?iso-8859-1?Q?k7RyaweMukr5O6pWCX08UOMxWU5L8hZvm35Vvgiz1jbFpel3QHCxM1ETyc?=
 =?iso-8859-1?Q?1Z4rVhPYHzRyFTI8ouOdc0+XJBO2/MaBpIIXxwDztKQGgmocHLufyoffjE?=
 =?iso-8859-1?Q?WOoWBNJ9LrGAtdH72/4YrBiwutkA+tc4nsJDI6mv5zX9bARnHrADhKmyGt?=
 =?iso-8859-1?Q?CdYlLjLq+/8YehZFAQK2OiS/hutQM6gl5MILv3IpitUTXZv4IuMOLZbtbo?=
 =?iso-8859-1?Q?fXz8p2GvTgXLgh1LvfQ0PZh2GOXm04uYcQm1+A7kGNVtQ4albO3WY2qIQj?=
 =?iso-8859-1?Q?cbEZij9xfQjEcsCJe27mkj8juxdSxvo6+PotdS/wUVR4fQKyCEO8bxYd/V?=
 =?iso-8859-1?Q?1aFREbExoYn6T2hAcwreuAhz2jiWmKoZk4RrfPGGCTZonGH809doxUH+dc?=
 =?iso-8859-1?Q?KNsxeo4FQz1ZehFuHXJ6BLmojqOsUILcVDKDJvAE5EkXmVNm5/rqb+k7bg?=
 =?iso-8859-1?Q?XGrFfkRHdgrx5qhvkmctWUDYD61kd1AjosmNEWhVMt3Lpr/TwaWMiFdjCS?=
 =?iso-8859-1?Q?Cr8Fmbm/8Gfx7hwn+ikEUP5T+3gTk/brubBdsP0n+U5V3r/kRxB4/dx4Xe?=
 =?iso-8859-1?Q?Y8It72stvafa4tRX+H71vLVZbE2gLOZPz7EgNztzDvxUowjFbuc56SxPrL?=
 =?iso-8859-1?Q?pgzDoe7RvzlLkgwBABUNfsqPfQNfu9/mDyYXK8zoFgQYDwSFvb6H0oeO+p?=
 =?iso-8859-1?Q?XBgftMxtV3q/eewGzVHHW5G1ZGg7qQn1Rkq8pb2riSued8DDVamxUY5GOn?=
 =?iso-8859-1?Q?/g9xLY+n0UW63Pj+2GFBneALPcKNo+067cs7mCbL/tjQ12UI6kcoJnmPtM?=
 =?iso-8859-1?Q?qL3oBpmt/+g8J28Uj9qPhggo4Ip1ef+3scWhwirOiv4veG87+o/Qbe+BWc?=
 =?iso-8859-1?Q?/l2wDkEYyP/5kxwQA54KVxvzJFbbNOdTc2SDVu0qor5F7IGaw7+mxen+D8?=
 =?iso-8859-1?Q?8Euq5xKPhHeenIAJ4LwHHDnT98Pp5MLlZXsiRdyyXX/RqEb5X7iKkxLs+2?=
 =?iso-8859-1?Q?9kNgnwxkzcUo/ADBIuIy/DHYPSAu6sef+RRV1AVZFXUllpGN5MdMOGBiyP?=
 =?iso-8859-1?Q?ju9V8/dEYCbQ2Hbm+sUlID/8UFRJi2PeDHbUVt0x8snBYu2/R3+2wmeybf?=
 =?iso-8859-1?Q?8Jvyf2GQ7QMPsDBfZeKODVFeR8TmeYHfBM2qglgzRimrFA45/aL0bP3EvW?=
 =?iso-8859-1?Q?kDe33OrD6Dn956SCXij13+XsXGafrWFb4vClzLBvBWBRB2ixZkeBid28JZ?=
 =?iso-8859-1?Q?FVD21QWds0aLedTTuciXMRMZs/w3ZDcZ+jnWsGzE5kRPmu6lrbN/ZQ9Ly1?=
 =?iso-8859-1?Q?P2NiniLCU21pZ4H+W7i7glzaNo3l8gvy8n8ckCt/5SAkScrxSPJ2QhYJb4?=
 =?iso-8859-1?Q?7EQxW8PjRJlyF6cow7H3pM6Ux/RuOSfPvPXVTb560lGKiC0jW9hzTXcnD5?=
 =?iso-8859-1?Q?fhEz65eJhKXG1zC/UOPP58vktdASTe81pQcWLUhWDxs+mkX/D1G7q6i3FI?=
 =?iso-8859-1?Q?AUJm85+cjheqmYABKr7HlvDIbnkty5D7+D+08y1iE6nmQh1guWmnNjCNbB?=
 =?iso-8859-1?Q?stvxIavHkcwwP+W8W2MjTETev/AIZ5HY/H?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e94324-0805-4186-1821-08daf7f69648
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 19:19:28.1356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BIddw7PfRKK7ma3jGHmjiZ0fqWOBOEe05Me/sGDqkWy6vICygMStWtEZxw2VgnqfMuhhemM3w15b6Lmc/1IT/bGpBssCETq67GZkS2tmsGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9711
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 8:35 AM Alexander Stein <alexander.stein@ew.tq-grou=
p.com> wrote:=0A=
> Hi,=0A=
>=0A=
> Am Sonntag, 15. Januar 2023, 23:23:51 CET schrieb Pierluigi Passaro:=0A=
> > On Sun, Jan 15, 2023 at 10:56 PM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > > On Sun, Jan 15, 2023 at 10:38:04PM +0100, Pierluigi Passaro wrote:=0A=
> > > > For dual fec interfaces, external phys can only be configured by fe=
c0.=0A=
> > > > When the function of_mdiobus_register return -EPROBE_DEFER, the dri=
ver=0A=
> > > > is lately called to manage fec1, which wrongly register its mii_bus=
 as=0A=
> > > > fec0_mii_bus.=0A=
> > > > When fec0 retry the probe, the previous assignement prevent the MDI=
O bus=0A=
> > > > registration.=0A=
> > > > Use a static boolean to trace the orginal MDIO bus deferred probe a=
nd=0A=
> > > > prevent further registrations until the fec0 registration completed=
=0A=
> > > > succesfully.=0A=
> > >=0A=
> > > The real problem here seems to be that fep->dev_id is not=0A=
> > > deterministic. I think a better fix would be to make the mdio bus nam=
e=0A=
> > > deterministic. Use pdev->id instead of fep->dev_id + 1. That is what=
=0A=
> > > most mdiobus drivers use.=0A=
> >=0A=
> > Actually, the sequence is deterministic, fec0 and then fec1,=0A=
> > but sometimes the GPIO of fec0 is not yet available.=0A=
>=0A=
> Not in every case though. On i.MX6UL has the following memory map for FEC=
:=0A=
> * FEC2: 0x020b4000=0A=
> * FEC1: 0x02188000=0A=
>=0A=
> Which essentially means that fec2 will be probed first.=0A=
>=0A=
This is actually the expected behaviour, by FEC0 I refer to the 1st instanc=
e of=0A=
FEC, no matter the alias used for it: apologizing for the misleading notati=
on.=0A=
For iMX6UL, when both the FEC are present, the MDIO is owned by=0A=
fec@0x020b4000,=A0which is the 1st instance of FEC.=0A=
>=0A=
> > The EPROBE_DEFER does not prevent the second instance from being probed=
.=0A=
> > This is the origin of the problem.=0A=
>=0A=
> Is this the actual cause? There is also a problem in the case above if th=
e=0A=
> MDIO controlling interface (fec2) is not probed first, e.g. using fec1 fo=
r=0A=
> MDIO access. But then again there is i.MX6ULG1 which only has fec1=0A=
> interface...=0A=
>=0A=
I'm not familiar with iMX6ULG1, but I would expect that its device tree dis=
ables=0A=
one of the 2 fec: this patch is relevant only for dual FEC configuration.=
=0A=
>=0A=
> Best regards,=0A=
> Alexander=
