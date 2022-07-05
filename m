Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CD25676D2
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiGEStM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiGEStK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:49:10 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7CB1659C;
        Tue,  5 Jul 2022 11:49:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDIsz+5ivEX2Uybw38sbnpwlQFBYtMNx8TS3jTVb99/Qe0vGam59Ts7JuyZFeEpI6iBwqUjeOmhTQPnOlLWEx1DNDpnKGIU2xHTIAXAMZ4PG6rpgt9SJ9wYNAM9DTnHowiIP0on7FAYpEIl64JnES2Z84B34y+IMILApHC/4ZZoO3CWbxN+Y3E7c5l6YLxUPMHfosiSXOfuSOjvsNTk86od+tweim9lGKFR7DU9aHSLYLwysRdgzrVxrCoz4Q0wB9+SROMIFN1jVVGyGel7UQkPkJ+PIe8CE3dh9WGwyyg6z4sbxynFsrp7c24k5zUgX7OrEgayXg9JEDY22J+LlIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLpVA6jPuMWN9NwCL+y9GifFEFabKoobyIBH65e0iFM=;
 b=JvRnLZxlaXixV8gSxRdHzIyMdOYCuxxpT6ogOR6C2MYoky9uHOs8prAokDfheD7x133iS22nomkC15F8m5YdvpCUeh5PtdzttZHOqDIJjzCCxLbwpy+jr+49gAIpCsX9xhaclHe74sK+Mso5lf5wLTgeETx+VMa4+WRw83X3xU0lZvMJYL33+n159CDgRE0uDICuDJe16NVCbh9hUfkWTz/q+kg9pvNqXBqmrl0alMidmQfPuOa3q20+XVHLfveY/9xeC08++zI4qTw+HLd3/+WibG1T5534IXRa5ys5ydzh121gFpwlfzTubOwh043wSufKNi1Y9mjUoy4cuqbtzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLpVA6jPuMWN9NwCL+y9GifFEFabKoobyIBH65e0iFM=;
 b=xTbDiO/fNJ6EaafgrQXWn9ixMbIrltDMk5PYSW9s/MVFlVmrypEpOMqQs69tyEvDSzMItAlYJUqB7RxCWZJSryy8qPknSOGZ+XEtLNOAbFSm6A5TPyTMmmstXVQI7Q3IpH44zSgjH0nhSMtF2PrpxYAInwrKwAcisOgTcvMpQYo=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by CH2PR12MB4182.namprd12.prod.outlook.com (2603:10b6:610:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 18:49:07 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::f462:ef4:aa7:9a94]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::f462:ef4:aa7:9a94%8]) with mapi id 15.20.5395.022; Tue, 5 Jul 2022
 18:49:07 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "saravanak@google.com" <saravanak@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Topic: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Index: AQHYjLtb1TFGTzmc5Uq+BMzIcSbNRq1pPD4AgAbloJA=
Date:   Tue, 5 Jul 2022 18:49:06 +0000
Message-ID: <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch>
In-Reply-To: <Yr66xEMB/ORr0Xcp@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a0c9a89-da38-4789-279e-08da5eb70a35
x-ms-traffictypediagnostic: CH2PR12MB4182:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SiE6NeYy//XepWFVgeYqE8/qq+7fpD+XZyFoGmoJOtRnxRbsrS3NwWM3F+ag7xxmVZP+YZRDHVVvnoMx72jr467buXNLiKqBLBVeymwaEyPF2NF+7Z3oE3vYtSTpOjJo+UB6EaWtcCNGpk2CkjhpByu1PgR8kJvmt0AnD9jIfjTt8OoOh7b04SrEqMAuArdsjJHUWFDixf+FPu4tXbypE00hyPfk+DXJ6AafQWhmly9c+xshcf4tstlIKvLNENvVsL9jjfVP868PYnWLSObCuLewk5k/Cq7HHbwptf6+IUVNZpTCBlH2cIZlCXmsp5PKjaohinssCQA6zdc+RLfhWEsXFIThN4jrSo+vF5cTbgm78lxj5S43kr2kmP9AK2Fhdb4e701vdaNJI5XOmmIw1KaMAFFNaxncISgNRDzpTDNvnDRnyjy17Ub7m37ll3ws9HtNktYBF6Mu+/zLPyQAAMLTWtkvqsLhdqIveX3x8fkGHH+aFmc9Ld2ENdONytPlJZl9aFCmxalt2m30xrNeFZDGDWpPxViFv9OJXBViJZw3NXR9bmEkJTERTwTHdSQiEEHocUGlijdGkVSqf8HLD0LkKEC5HK/mTXOjl7l/QAfngKUoQetfZSDpaDneX8NB1yDa0c8wdR9TX/Kpse5CITisG9048pkQEwz1abMHKR/TzkDjY8xI5bGgLrxdqeD/yV43kO02huYLaww5Uqy8+SIeEznQ4sUj4noag1IGFz6c/Uon3tnR01N5tA724PXY9fE6Uf7nqcsLnkktFXqcRFMKGLYDpBeuq2IKRTEXuB4i3fAK2hNqAGml2iyjeRXa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(52536014)(8936002)(7416002)(5660300002)(54906003)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(86362001)(41300700001)(6916009)(316002)(71200400001)(186003)(38070700005)(9686003)(7696005)(6506007)(2906002)(53546011)(122000001)(38100700002)(55016003)(33656002)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CFeUpQ2HpgdtywdlMs4s73+INm92TliAyrUyCr+weYZcC0tlqO4cHMR2XWDK?=
 =?us-ascii?Q?ZFrEa6yDGJRr+Ufp2i3OvwlqafHPfrwwMstxYCmodwvslKxwW/Ahq+EASv1x?=
 =?us-ascii?Q?3Cjm3ZD72Ctz9ysj9R6uSZsZUadKB9sj/neYm61JRLZNANE8s+WYZvTxEGqj?=
 =?us-ascii?Q?gIBuzjyVmwX1ANp/F4/09JocXAHA0rJR7CxUz2oeIG8YHclh05B4xMilS4V/?=
 =?us-ascii?Q?sckZplYNc8W7owwZfZMZVdvr2TIQdh5TWVbe8Z34B+SSaCN9b45HhMbMNPUR?=
 =?us-ascii?Q?RFCtQauOo23FsJWIB2e8j88+sJp+NeAlo2TiKE+rwIZv1aRY0tGrQMQppmqv?=
 =?us-ascii?Q?zKUmRstyPIHLJm6VF7/GWKqVy59c4/NRUrAAUzQaeaVYDbFAWDhmBTuxZkcs?=
 =?us-ascii?Q?FryjF3WVLCy/CnhQKC264SGjoYf4GDdWrPujUZvHKYrRZmb0wRHw1Xl15NsU?=
 =?us-ascii?Q?N/8V2oYnfh7E4v6APcx9YTtCfOwpsjLzJZbaYbSmIDIClFSMLJiyrxd4ULQI?=
 =?us-ascii?Q?7hsde8AR7ElBoBvQjRs1pjHomjcL1IUko2i8Tnkr8JD+c01qE0xOHL7b4M4k?=
 =?us-ascii?Q?oN/L4KG1es63wYc5Xh6UX/AD03imGkdzmfj59B/bF0WqdVCLEgSFWRscQWbt?=
 =?us-ascii?Q?mqCKP6xesbz4dsmTK/JKveeXynEHWiRfYFyQ9WLPjOoZelE6wCuHvJAEmQHb?=
 =?us-ascii?Q?cUFIQZpkKI6eHSFfFmjbgLxYr/pkjH0tZEDyiIGpZLFTaD6R1+MRSnbFgEkC?=
 =?us-ascii?Q?DC0rfn/JZ2R66i9hGGGUwQ45S2B6NZsMv+Azztxr3FyR7DNZmmX4aTe+I7uM?=
 =?us-ascii?Q?bwJl8tl/n6PsqvGDsN7N7Hx7uuov8YeCC1EArM+oLiGbTIstHArNoWCjGbFJ?=
 =?us-ascii?Q?agXexEWVVIqYAcrnQHjFLmCQS5MGmLy8WdrK7Bpof4HYCDkrmVtBeHOwJQMH?=
 =?us-ascii?Q?1WyYeLH4pSTp0QA1ULeotRnczb/FcEt+GemmA2YqOMEgOURTIrzT8I6e7v5Q?=
 =?us-ascii?Q?papyv+hZ9ytt5sGhS1RH9Aw9krVCzn65+TleUngqje+gK+BSoPmuqEum5CRx?=
 =?us-ascii?Q?u1Egw0blSEXN1JOzN5AsrIqqHC2LxldpiLbyqePjxYdSrGHdoBG3kHj6ASon?=
 =?us-ascii?Q?GOBYqrWDuqOWQgDIYyeJKLffht2Yr2k2CGD1HCRfpav2kclzbBJdHkxzWwpP?=
 =?us-ascii?Q?cUjsJSHEYjdHhwI0Yr+XFQ19TFFp8/WMc+avpQOnV/kqPYv02JiaQJMT2Gw8?=
 =?us-ascii?Q?XnedxXtDIUGHpuqnfevx4gWrqbPiPXKNRLgaGHIhUT36H7B33WFxjgo4J4UP?=
 =?us-ascii?Q?6yiqGjPTqksKW28XQfB561vLk+e4JbnEU9dJMM8jdexwJZRtFP8394xJc92B?=
 =?us-ascii?Q?RnxXJe3Gh5jntkuGBWk70xfYs9u+k+/dlPg2tfOAPycoXXzBFE2oTqbnxbnM?=
 =?us-ascii?Q?xvICCy1cZg78tL2y0Ku9894h7RRauGb6sqN/U301ecLWGjxXDo1LWjrqtJCQ?=
 =?us-ascii?Q?BNxRopIu/di7WIy/CS3GleXz9vsZlbRyJfAfkKnBAiTRr1SpJ0dfunpMCFkq?=
 =?us-ascii?Q?7iEFwbmQ9JDqhX5k161diaY+8PbRFNC1XxCgQkJ67yEr70Fmbd7TmNbM+2km?=
 =?us-ascii?Q?mFUSedqQcQeHg91AjXwJqPA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0c9a89-da38-4789-279e-08da5eb70a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 18:49:06.9315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3p5JMt14Qdk73exhvfp5z4wKqXUUVASRTXvZAx7tSRjf7aHi1DEvMaP18tYdCYG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, July 1, 2022 2:44 PM
> To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> Cc: nicolas.ferre@microchip.com; claudiu.beznea@microchip.com;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; hkallweit1@gmail.com; linux@armlinux.org.uk;
> gregkh@linuxfoundation.org; rafael@kernel.org; saravanak@google.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; git (AMD-Xilinx)
> <git@amd.com>
> Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make
> MDIO producer ethernet node to probe first
>=20
> On Fri, Jul 01, 2022 at 01:25:06AM +0530, Radhey Shyam Pandey wrote:
> > In shared MDIO suspend/resume usecase for ex. with MDIO producer
> > (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> > constraint that ethernet interface(ff0c0000) MDIO bus producer has to
> > be resumed before the consumer ethernet interface(ff0b0000).
> >
> > However above constraint is not met when GEM0(ff0b0000) is resumed firs=
t.
> > There is phy_error on GEM0 and interface becomes non-functional on
> resume.
> >
> > suspend:
> > [ 46.477795] macb ff0c0000.ethernet eth1: Link is Down [ 46.483058]
> > macb ff0c0000.ethernet: gem-ptp-timer ptp clock unregistered.
> > [ 46.490097] macb ff0b0000.ethernet eth0: Link is Down [ 46.495298]
> > macb ff0b0000.ethernet: gem-ptp-timer ptp clock unregistered.
> >
> > resume:
> > [ 46.633840] macb ff0b0000.ethernet eth0: configuring for phy/sgmii
> > link mode macb_mdio_read -> pm_runtime_get_sync(GEM1) it return -
> EACCES error.
> >
> > The suspend/resume is dependent on probe order so to fix this
> > dependency ensure that MDIO producer ethernet node is always probed
> > first followed by MDIO consumer ethernet node.
> >
> > During MDIO registration find out if MDIO bus is shared and check if
> > MDIO producer platform node(traverse by 'phy-handle' property) is
> > bound. If not bound then defer the MDIO consumer ethernet node probe.
> > Doing it ensures that in suspend/resume MDIO producer is resumed
> > followed by MDIO consumer ethernet node.
>=20
> I don't think there is anything specific to MACB here. There are Freescal=
e
> boards which have an MDIO bus shared by two interfaces etc.
>=20
> Please try to solve this in a generic way, not specific to one MAC and MD=
IO
> combination.

Thanks for the review.  I want to get your thoughts on the outline of
the generic solution. Is the current approach fine and we can extend it
for all shared MDIO use cases/ or do we see any limitations?
=20
a) Figure out if the MDIO bus is shared.  (new binding or reuse existing)
b) If the MDIO bus is shared based on DT property then figure out if the=20
MDIO producer platform device is probed. If not, defer MDIO consumer
MDIO bus registration.

>=20
>      Andrew
