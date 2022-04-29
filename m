Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6818A5147B5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358033AbiD2LEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358032AbiD2LEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:04:01 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150044.outbound.protection.outlook.com [40.107.15.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC022B714A
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB1/EzMVHaWwa6PYKR5WUI4Ljjp5ZXDOGfAC8Z2REhb99PDliAoirssjXnQB2KJfSYZnLnx5h1xFAKzDeOcdckYijRTXHG/T233pjJlqdi0C+Kbh1ivpLL1PE/cxyLCBmcJqVCNpr9ollS+4gDJg4XKTDP59mchAPRvFM1z6E7t8l2qxTAs3tKBkpoRFvR33LGmfeY1+MI3qtx8Vi+FsLOPOwWcLnjud38QvyEBY4yRTtNVv+25U9TgsHW1LVdcujaViAHfu0Z9mwnWpKn3X9KfS26+wjiZtjQZhYEMC2PsCUBt6PUrJ90wxafXD8/n0XqJh1gEsZyTen9eQtfOKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2HRiS8m9LmwMVKeHkSrnIotC95vuv8Fvq90IvIwKoU=;
 b=AcaEUd65etep45Y2IEIm2Et8RQSQuF1sp0VfFIs0yct3JfnW67GvpOa9Pdn6kdu+PA7wQ4kW38cSE3l2DA36nW8BCVTgwi35G/ec0xLyxePegMNI26LveI/oalv33ZFzBSx7zDv1yONfQIYgXX0rmMNHjSBT5uuWwxHl/y1urt3fDoOu2q8fz6VIRnNsNvSwYlo4ZUYf6c+BHmCSY/QQQsCJDqr8YqSFivmXRiH2NWYvlDmUEnYXcyKTBnMQfDH2XMv6eZvsFhxOD0zzqG+1yl8DjIsT2KmgZ+nBlUvGsy6e/EjZSn6ns2p+B6xrZEGVS+3cectxfabNaYzJxUzHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2HRiS8m9LmwMVKeHkSrnIotC95vuv8Fvq90IvIwKoU=;
 b=aZmRYCdXCFR5jafnW1X4WLTLxvS4jax0UQu2OsWmqo0QSSqQOyKQzYFbemw+NwE7SSwX8NNe/In/iXuwO5otp9NHvLlRZW5Lr4YtrcxggA6SqcGtm3Kz4eMsMHP2M3aPNOW8mSo3iG6f4OLhrSSMYz0+BdSZWj+GL12EvJZR7fg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9194.eurprd04.prod.outlook.com (2603:10a6:10:2f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Fri, 29 Apr
 2022 11:00:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 11:00:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Topic: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Thread-Index: AQHYW0GuNYRSTEqn4026FUjTTdPmD60Gb0AAgAA0E4CAAApPgIAADJIA
Date:   Fri, 29 Apr 2022 11:00:39 +0000
Message-ID: <20220429110038.6jv76qeyjjxborez@skbuf>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt> <20220429093845.tyzwcwppsgbjbw2s@skbuf>
 <87h76ci4ac.fsf@kurt>
In-Reply-To: <87h76ci4ac.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 120c8f08-c355-48b7-a6c7-08da29cf7f83
x-ms-traffictypediagnostic: DU2PR04MB9194:EE_
x-microsoft-antispam-prvs: <DU2PR04MB9194536CF0C61253107D6206E0FC9@DU2PR04MB9194.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WyBbIDXaUbD2eK9YXbPi8LnbM5yWO7YsskmD+bylxoFv3+0Ps1bsX23fneIbi0U0bOwS7uvHoPuu8DK4K0j3LNuMCm7eG2P6w7RB51yTbEoyzbeRixzs3UeSgCmhvrmku5V+rtHszgW11M+6fwJtD3xGOqrklB8x+XkbNAx4tkxMZQLIQ20K2B3cRqsLEFj7NZTa9Ms2YoX15BLhwPET4y4Y37rM3QlEwJT8LabYxuHWZ6hIGc++WF5mVS5cZUImmkTE4tMyjIzt9AITNS61eF9g8UuxubTHrmcfc7d5kzcPMeb234R1R2ug+CKNyCb5oTUZFtGMS4iyFlX/3HaiTRtECrqzW9vyVU3SnG0+s0AiKicYQoi2yBiJcaFvQtFrFZT78uakwokr3vydWBQbSngoscmPrfuDyI4BYpEcCkny/wfwfcxNAEiMTvtes2qD5qubomxWvc3qfyOZVDwoRa1qBrIDambdCa6bstILpE1oZO9aSPPK7SGUSEj6RaIkHQJ6wLRpaMEIJ7mimEOGSjAOodhKcOq1wuS5nkqhDxVlU5hA5jDpprl9O1Ebey+iCTcUb8hjeRwCS/7F6QToW6lrDO5EpEkmy9hz3zLDDAyE4h5yNZTQIxwKGd75Klg4B+1ibRzOZ6nf7L5UtxLyWGSA+b4gTdyOgo+NpAa8/BLlWKUrrslaFqJ14dstMKuVP31TBl8SCGGCGOZPlL/1XpE0FnazTCUcmUBPRpwfBIFy+3ZELVHlf1m2603mVBnmVle6gt+AsAv+prR7g76vmcM65p2ovYAjXwzA7Wqa1ys=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(8676002)(66556008)(186003)(66446008)(66476007)(76116006)(83380400001)(91956017)(9686003)(6512007)(86362001)(26005)(6506007)(508600001)(122000001)(66946007)(64756008)(33716001)(44832011)(2906002)(966005)(6486002)(6916009)(1076003)(54906003)(8936002)(71200400001)(38070700005)(7416002)(38100700002)(5660300002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MVwBhnkcFdCBvdwTZPg5eaAlAjrfFKI/hjnm7/7QskUVMV9Vsr0p+wtX8ENI?=
 =?us-ascii?Q?lCsGEA3jQiw5tpDwjd/TRA4At7oSm9yxADFaBOVRVwQ6matb2BR613SYZAIf?=
 =?us-ascii?Q?StPBvsRsN0WzBAiMy3p4AeTlbeQxLQI9MdJfLmlPr7jYYVvtZYQPpKoheCO6?=
 =?us-ascii?Q?OETjhSckkuN/EZKJOo6qoAej/cYk9fq2tv7/mXdmBn7/z2BSOu4GAfy2BYaq?=
 =?us-ascii?Q?uIiGktUgTxOYdChWs+WJZyEeLMV6zpebC5jBjF60oxChknlSW34irr8kHcxF?=
 =?us-ascii?Q?trAJEgzS6RP+j2qSDHNWhwIhmRhXrv+r82QJs8P0Ba9gGWzcU6zzqy3Ggq+Z?=
 =?us-ascii?Q?7Eb+SuOEtKgb7BWW8Lz8z3Fw/bZSJBSzt31kAzc2zjNrBTDpAomE3oMw/a+C?=
 =?us-ascii?Q?MgC1o+eu/GthDPjIvph+sp361eJHVRMJmoiXi2n4wi2iE6nYwJUiKDxWl231?=
 =?us-ascii?Q?llRwU3rdBq8pHP5kZzkTQU4IjFpgarbew+D3y33Zih8q/X3bjzgIItkHCGnu?=
 =?us-ascii?Q?iaCLUAEarxM2H5wAEHw7OKKjtbVgdu+wvk4A2Xnce6Xaevd7AXXWJeRZd7oc?=
 =?us-ascii?Q?TtwfJ4B5L5I/TiQ7rtLWLM7LzGRcG6jPdEjZLYCJRH/6VWjxDqfkgtPGlxDH?=
 =?us-ascii?Q?FRyjsiED35F37c/xp48Y28tyR9ru8QLdCYi3YxAFo51ovZuubpQ0UnXXy50e?=
 =?us-ascii?Q?pONplBV/sxrzZ7OcLFhSUi7x0EfaOV6XXoBhDDsjQzXeXveglN2eo8uMurbn?=
 =?us-ascii?Q?JDU3horFnYCrnN2fyFAnAEnQ+NB8MA1yyNiW+d2xifo4mjQQ+/E4pDkyvAWk?=
 =?us-ascii?Q?pQN5Q1vTx2RIYb3wfHvoRwBD17om23+ZsBCR6fe8DLrMmm7URJZNX3FewLjL?=
 =?us-ascii?Q?ZjnFpfpuubh6hp+PedIpSCEvSkQBlF6StitIK1+gVVhCk1/4Fx9wfWV7yDO3?=
 =?us-ascii?Q?bvlAppdv8Pomm4YeJkqmVMKTwsarqQ7K7gAs6IytaIIdxvXkn0AyFqzL3ez8?=
 =?us-ascii?Q?9VU2vEg71gpp3dpaUwCCG9+1tF3BOg+AJauX3CG2pycIZOSkn9hcvvff9y3f?=
 =?us-ascii?Q?n2OhTDHyIWi/+Gk0WAsRSWbV3HtT9i2P+ck9Baw4jsfZDhyYR4YrlHTB5ZeM?=
 =?us-ascii?Q?HVBhDaMIL9QvwDpwOwZ+sxTpQ1m9polO3kxexJYSH+ATkZsasHfh9cQAQ2Ea?=
 =?us-ascii?Q?SsSTUeufvmgy9FKqg0UqcoC6IyFNmm+uR3jMOLc1QmYz65wd5xb4pypNu1nc?=
 =?us-ascii?Q?qwW9kindnZv72kzhKLYqf/m1OiMqiExEDaT+xoB3Tl4NUzaJX+DlRdfbeQPU?=
 =?us-ascii?Q?lRAlrtuBE9C7NGiCy2inoNe5BPDvP0LG/mJ3H9XUa3gy0OrDyBplxMEuP1re?=
 =?us-ascii?Q?QQJQe3wvnwDvZVGb/QMvzpaJ4SMywdhRUdxTsQCJ3YYyWBtb/w5AjzdIMjZq?=
 =?us-ascii?Q?yAC02h6hxgeYFa/N9WGHyuqNfbw3uPwMHavtzN4yagtV/NRwPJRVzPCy4MyQ?=
 =?us-ascii?Q?VVM/s/nmi6Guv/+CsvoVvHFKrOAJRIL5DrLnDcQZw9CjmxF0U+FTTaJjU6Wu?=
 =?us-ascii?Q?mSFYLOnKYT0YDHZ8vYJpkg3oivgWO8aEgmyfz8VkSdC9RrbhxAszrVaT49si?=
 =?us-ascii?Q?AdbMBqhCpF/EKvs1hiwHGq+ie5V1OTNFoAGuzhtG1zckqCnhZcTZFVxd48PB?=
 =?us-ascii?Q?KC+EDgPtpisOk3kJ6YrKPfZk+jij57mEwFM84nphr9KqyZe/LKX82OV+cDmX?=
 =?us-ascii?Q?QJgLvvdF1m1uDTvAQfRdYNwqb8D/+iU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2E9B8C0D57DB941B8436DEE0E913E68@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120c8f08-c355-48b7-a6c7-08da29cf7f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 11:00:40.0493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdgoFTpYmaKWU/Ysk9q3Om1F97OELCOgLMloCW9ZFeUUIxPE+g2KxvWmhUtnDcQDov1HR6wpU+QELmhanmXYHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9194
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 12:15:39PM +0200, Kurt Kanzenbach wrote:
> On Fri Apr 29 2022, Vladimir Oltean wrote:
> > Hi Kurt,
> >
> > Thanks for reviewing.
> >
> > On Fri, Apr 29, 2022 at 08:32:22AM +0200, Kurt Kanzenbach wrote:
> >> Hi Vladimir,
> >>=20
> >> On Thu Apr 28 2022, Vladimir Oltean wrote:
> >> > The Felix VSC9959 switch in NXP LS1028A supports the tc-gate action
> >> > which enforced time-based access control per stream. A stream as see=
n by
> >> > this switch is identified by {MAC DA, VID}.
> >> >
> >> > We use the standard forwarding selftest topology with 2 host interfa=
ces
> >> > and 2 switch interfaces. The host ports must require timestamping no=
n-IP
> >> > packets and supporting tc-etf offload, for isochron to work. The
> >> > isochron program monitors network sync status (ptp4l, phc2sys) and
> >> > deterministically transmits packets to the switch such that the tc-g=
ate
> >> > action either (a) always accepts them based on its schedule, or
> >> > (b) always drops them.
> >> >
> >> > I tried to keep as much of the logic that isn't specific to the NXP
> >> > LS1028A in a new tsn_lib.sh, for future reuse. This covers
> >> > synchronization using ptp4l and phc2sys, and isochron.
> >>=20
> >> For running this selftest `isochron` tool is required. That's neither
> >> packaged on Linux distributions or available in the kernel source. I
> >> guess, it has to be built from your Github account/repository?
> >
> > This is slightly inconvenient, yes. But for this selftest in particular=
,
> > a more specialized setup is required anyway, as it only runs on an NXP
> > LS1028A based board. So I guess it's only the smaller of several
> > inconveniences?
>=20
> The thing is, you already moved common parts to a library. So, future
> TSN selftests for other devices, switches, NIC(s) may come around and reu=
se
> isochron.

Right, it's hard to figure out what's common when the sample size is 1 :-/
So you're saying I should do what I did with mausezahn in the main lib.sh, =
i.e.

REQUIRE_MZ=3D${REQUIRE_MZ:=3Dyes}

if [[ "$REQUIRE_MZ" =3D "yes" ]]; then
	require_command $MZ
fi

?

> > A few years ago when I decided to work on isochron, I searched for an
> > application for detailed network latency testing and I couldn't find
> > one. I don't think the situation has improved a lot since then.
>=20
> It didn't :/.

Part of the reason might be that not a lot of people care about TSN testing=
?
In my experience it's pretty damn hard to build a Linux-based network
connected system that sends/receives data with a cycle time of 100 us or
lower.

And automatically ensuring that the system is prepared to handle that
workload when running a selftest (like this) is... well, I gave up.
If you have some suggestions on more RT-related sanity checks that can
be added to tsn_lib.sh I'd be glad to add them.

> > If isochron is useful for a larger audience, I can look into what I
> > can do about distribution. It's license-compatible with the kernel,
> > but it's a large-ish program to just toss into
> > tools/testing/selftests/, plus I still commit rather frequently to it,
> > and I'd probably annoy the crap out of everyone if I move its
> > development to netdev@vger.kernel.org.
>=20
> I agree. Nevertheless, having a standardized tool for this kind latency
> testing would be nice. For instance, cyclictest is also not part of the
> kernel, but packaged for all major Linux distributions.

Right, the thing is that I'm giving myself the liberty to still make
backwards-incompatible changes to isochron until it reaches v1.0 (right
now it's at v0.7 + 14 patches, so v0.8 should be coming rather soon).
I don't really want to submit unstable software for inclusion in a
distro (plus I don't know what distros would be interested in TSN
testing, see above).
And isochron itself needs to become more stable by gathering more users,
being integrated in scripts such as selftests, catering to more varied
requirements.
So it's a bit of a chicken and egg situation.

> >> > +# Tunables
> >> > +UTC_TAI_OFFSET=3D37
> >>=20
> >> Why do you need the UTC to TAI offset? isochron could just use CLOCK_T=
AI
> >> as clockid for the task scheduling.
> >
> > isochron indeed works in CLOCK_TAI (this is done so that all timestamps
> > are chronologically ordered when everything is synchronized).
> >
> > However, not all the input it has to work with is in CLOCK_TAI. For
> > example, software PTP timestamps are collected by the kernel using
> > __net_timestamp() -> ktime_get_real(), and that is in CLOCK_REALTIME
> > domain. So user space converts the CLOCK_REALTIME timestamps to
> > CLOCK_TAI by factoring in the UTC-to-TAI offset.
> >
> > I am not in love with specifying this offset via a tunable script value
> > either. The isochron program has the ability to detect the kernel's TAI
> > offset and run with that, but sadly, phc2sys in non-automatic mode want=
s
> > the "-O" argument to be supplied externally. So regardless, I have to
> > come up with an offset to give to phc2sys which it will apply when
> > disciplining the PHC. So I figured why not just supply 37, the current
> > value.
>=20
> OK, makes sense. I just wondering whether there's a better solution to
> specifying that 37.

Essentially, we could work with whatever the system is configured for,
but the system is probably not configured for anything (see
https://www.mail-archive.com/linuxptp-users@lists.sourceforge.net/msg02463.=
html)

The problem is that phc2sys wants a -O option. We could query the kernel
from the script itself to figure out the current TAI offset, just to
provide it to phc2sys. That offset would probably be 0 (but it could
also be 37 on a well configured system).

The thing is that isochron, when not told via command line what the UTC
offset is, proceeds to ask around what the UTC offset is, and tries to
settle on the most plausible value. It queries the kernel (sees 0), and
queries ptp4l, and that will report 37 (this is configurable via
"utc_offset" in default.cfg). So isochron says, "oh, hey, half the
system thinks the UTC offset is 37, and half the system has no idea.
Let me just update the kernel's UTC offset to 37 so that we all agree".

And that is fine too, and it makes CLOCK_TAI timers work properly, but
we've just told phc2sys to operate with a -O option of 0... If phc2sys
ran in automatic mode, I think that wouldn't have been a problem either,
because it queries ptp4l for the UTC offset as well. But it won't,
because we want to establish a fixed direction for synchronization
(CLOCK_REALTIME -> the master PHC).

> >> > +	isochron rcv \
> >> > +		--interface ${if_name} \
> >> > +		--sched-priority 98 \
> >> > +		--sched-rr \
> >>=20
> >> Why SCHED_RR?
> >
> > Because it's not SCHED_OTHER? Why not SCHED_RR?
>=20
> I was more thinking of SCHED_FIFO. RR performs round robin with a fixed
> time slice (100ms). Is that what you want?
>=20
> Thanks,
> Kurt

I don't think I'm necessarily going to hit that condition, as isochron
will periodically go to sleep much sooner than once every 100 ms.
Nonetheless I can update this option to --sched-fifo.

I'm going to wait at least until 24 hours after v1 before resubmitting
v2 with some changes, so if there is any other feedback please let me know.

Thanks!=
