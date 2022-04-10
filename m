Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98454FB097
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 00:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiDJWFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiDJWFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 18:05:42 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50067.outbound.protection.outlook.com [40.107.5.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B5821B
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 15:03:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7Pmm+aao/e8OiGgaGZ4fYWB0Airwcua/O/lOjJTpYhuryDjMoKOprb/DysjMsW9G57U3v62srE/PRR4QWJGb6cEQJrVrWSBAKfZbA2F6EL4CqFMS4x8U5ilOzK/xeL/RMocvSJnRggVJO7erjkIAhVrF9gNlwKXY7MtQSUi/FKsmYibODxi8+AzajDD8A4lK2JsDCMtZSQ9boLXlq5cFQq53YhwQZxgh4tTZKD3+2o2I4tFwA8zxb3rT/hKHRShwgs3PhiNC601kg8zImAHO8rFGKpoP8RjwgZ2tb4YuI5kvHfGCstW3bdaIs3ZB8H0zTxyHBhYAYNG2N/dwYuIrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzJ0c4f/KAyAkMTOPFNwe7Ah7PYkzMJ6nQfDyBlsCXQ=;
 b=oDc0IuLFo7Nh8IjjCjh/k3L+FNTtuf5kK88EoFnjHdVnRuVtv0ZVj8Eulo+MxvdmYKjrN5EgDM0sV+SD89do5TZM+2gL9hFIXNE57TOePUlIBD6SuuNSqO4e9qRrysgpmB4Y6LLDLBVoaJJAvtlS05tSTZDbR3k4oqLFxqECpild5PYbY+G3XnfEPYXIJU1TzlH7Ne7Za6OqiMrcHJd4wIBsFgLn7sI3JHLQYBPhYPg5/OD7gDMK0qjU/iXVh8YqIx/I2xV/jDB6dSUMGJmFzIBl6KiJ8AU36VmtB/7r4DtLV0IcNZvWLBk6ZEGFFWFawdWW3LiTFzj4rjhKvhMucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzJ0c4f/KAyAkMTOPFNwe7Ah7PYkzMJ6nQfDyBlsCXQ=;
 b=ojuV4mhXpOGhihAzGX+idR9rRQTsscQmac/2D5KLWhCEdnr1ux6CF54EEHBD48qKj5cJS/5jLUHEFvJAIRECc1kQifxCkHvWdZI0fp9RNL4pJDNZd8Wu2AEIRNWLkNWGkH/o1l/z/hRpsHyqUe7RK+CRZHvRCDpFkPH001aP4zY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sun, 10 Apr
 2022 22:03:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.028; Sun, 10 Apr 2022
 22:03:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Topic: [PATCH net-next 0/6] Disable host flooding for DSA ports under a
 bridge
Thread-Index: AQHYS4PpJFoPHwGopUSskoKVo9n1g6zn/hgAgAAQgICAAWSWgIAAQ2IA
Date:   Sun, 10 Apr 2022 22:03:25 +0000
Message-ID: <20220410220324.4c3l3idubwi3w6if@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com> <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com>
In-Reply-To: <8735ikizq2.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91e40c99-5311-444b-58ba-08da1b3deff6
x-ms-traffictypediagnostic: PAXPR04MB9304:EE_
x-microsoft-antispam-prvs: <PAXPR04MB93044F9728D78C47BD16D0F3E0EB9@PAXPR04MB9304.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B82HsA5LTF2beqsI62QwcC3x83YKdnE0qtgjcxxSfGbAI7TqRTgkEuIDuYVeBfVJev/rdwYHRYYIyaIdoHJnoexXdHoLwETp4Kuewn351m+IqP3fqFwsvZmdHaafOPaNGIfAgDxa8w1R9CdiJPnLkOXx6Te20sfDOwHkFfX8aA0QPmIXZPQZ8kW1KxEAkVoVg59VL2G0NlbDWt1/K0raG60ivhhNQpqFhTggXXh6yNS8dblkkJHjl9FRT1tObc8F6YvfRo9hwMyFNKU2aZEfG0Wlx4x0i8ng/Vzt0IzLuH9w6QOHW3mc3XWNdQumQw0WB7q4p6UP8TkpUp82JeEDEkaTFW4MYHdRXw4CbFKAVZcfV7T2z3bDGtD7gdwOl9OHgoo9SSUboEKHAojzmRPNhNUG3os5lPibZsMRPX4pv9sNE4zIcur4PdAH+i61LGMDRkjAF8zBueuFhnYWdHyUVNhAfbQqlgxUo8FUUvMkHTxrIYF6SSB3oO2/ewasJb/NJu9LgjW7LBMS3/aTPV/kpheKXBUf3rKgvfTPzEWYDNpKszS/f6fCZT2LuZapyaX6iP5mLb52YMIotD+b4SMnH/uqRc4MNzUG+oWe/Uwhsxtu6hgMEUc8Vbrtk0rVPBpkfjirLJT8OahVmDFQIkBjGSAOSSZfI7XATZgbwwKwqoeaQdt3GPof9zH1E84YzepxMzpDrdvq4gfwjc02eJAul2fIoyfZW3RZkgCdy0mV6/aZk77U/R9EqYwGzcHzowDj/XWIRHJvJ31/oRPUXHN5pB/PXcSprLSiesswl7NLjpI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(53546011)(4326008)(6486002)(966005)(8676002)(5660300002)(83380400001)(38070700005)(7416002)(6512007)(30864003)(2906002)(66574015)(26005)(71200400001)(1076003)(186003)(44832011)(86362001)(8936002)(508600001)(9686003)(38100700002)(33716001)(91956017)(122000001)(54906003)(64756008)(76116006)(6916009)(66476007)(66946007)(66556008)(66446008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0ljrFQzB0/AoNmURxYh3QbLaB1YnCn8WHnFe/QR6vkAxMHAtT2b/zFnohOR?=
 =?us-ascii?Q?EpE1TKVwkITsULy6IrqzWo3/CxpOuFWK2VN3CALb9gtydtNVlreqsSlElWeT?=
 =?us-ascii?Q?5KJKUlxeuiXKqO+1Sksu+dbQ+dDM/QqtxgGj3QjWSS/TsRx10y6IipUhkyp7?=
 =?us-ascii?Q?ErUh1+KmItn2JnnkHE3XrpSKgMDEThNO0DvGKbjrSaOcDRwgEPr/E+PpiBkW?=
 =?us-ascii?Q?CYUQ18lWxsgbuRO3lInWaCg1rxmT+jdbHZWp8opuxls+8ODxnDrj7IqJZ7qP?=
 =?us-ascii?Q?eeN8KEguOFG2XUD2rm6Cy0vUOu1HP329Adf1PajquNjVXBhZJ9EPILDEx70S?=
 =?us-ascii?Q?umZPesLsB6Q9RqtbEMowUCJIZyXNXuDkYJAS8YPmsYmhuYrTnSlqwyFpbY25?=
 =?us-ascii?Q?zzQuIH2hd5tCAbhWjzqHXkS8+6wUAw9bQDdbAGWkMaTcl1sFTnyMCcxtpq9N?=
 =?us-ascii?Q?kEwykXDPTiuuIQGvFoNNfwGye0aMkYCCQF8H4ghMtLKkBWrjMjcGcKaKdJtU?=
 =?us-ascii?Q?o5/l+i+2HCnWOPOmQZl5OGPH29uwfKYqH7cigEcNpQYoqu5/rgG2m7QFxBAI?=
 =?us-ascii?Q?WNKTOguCl1ype0ukqNppNwjsL4w/svXMAhMl23FXzO8h57r1Trt/tomHaEgz?=
 =?us-ascii?Q?gsKv73KFfXt/jNA93fcIPPR4R6qatQMaNSZHPR+0wusc/hC5FrvZgoPX/j4j?=
 =?us-ascii?Q?I9k0NZPnHFIsgnF2oHcgGywzTbupWnRNneA5YgNKBUY9pfCr6d0nXBYpX2lm?=
 =?us-ascii?Q?ZTrr8v3kEOBGQ66mHP8r4BClFjH8BcLWmKhlhuxKk4v6v1WgrjnzwEkUjDO0?=
 =?us-ascii?Q?iqA+aRuHIO7SjyOAiOaZunSKLiJ3j8Ehu4fXqCXz0JtSC5JgzWKFYG6DSMOQ?=
 =?us-ascii?Q?1R/3a6uGz7PAjrCJV3wdbvL131WHMlglrZxqCRwtvoJVzPK3srOcNb1pUrsd?=
 =?us-ascii?Q?VnJMZeFU89GUiVQgeEwQOukdnIc0ZzrszvQGhpYupR0urEj5VR7mMgzGV9vd?=
 =?us-ascii?Q?g3j1A9XObXlZjhuKmnzphPsR1LVOz2XC36IW2FEpeoWCf91n6IPOox677q76?=
 =?us-ascii?Q?uDqnmj2blp+jqSoxg6w/DllZI8nymFNZb55tE6WDXggh1DB2yR3AefcFPvMg?=
 =?us-ascii?Q?yQSCLjrisZ5L3ZHuLfdtgUIHCbONpDfwZ78f0tID/K4aIH/v4vu6yvFlt1Kr?=
 =?us-ascii?Q?u+G32zaOf8FrDuZXTUUpSyF2CpcClYggOYxtLydi6mYo8CZwCKDVXH1qrqYt?=
 =?us-ascii?Q?acOreBOrGMaUdFY+zUJ1F9C5NwXD8xNfGu8NTRFLocCJfw/CGt0TFZTr55D7?=
 =?us-ascii?Q?1nvTtvbyYBgkdz7VmTAtbkdrA6Yxui1dXDTxQCcfnwISvy/sqkWYV8XgGuYG?=
 =?us-ascii?Q?reNlyprQ9dANcX60xx6ueLYdq/pIOFmxSC6TsuYZSdjiuLrb9iVSKmBwC62l?=
 =?us-ascii?Q?lgC650xUqtQjdnnpKBKghdr30wWQQIh07s5uFUFYf7MdhedatKFjAYpGq7lu?=
 =?us-ascii?Q?45mlyLpimOg/DrBEzJ0ZlsmNKHSjA8Riykeb7gjeauRqXMcxZSwvDEP4cOB5?=
 =?us-ascii?Q?pOuKaYfYAz7d6eKSX4WGroA3frXbZzzoYcFcoRjs3EmDak3/RANwVbBY8YGH?=
 =?us-ascii?Q?KpBESDpXnX1+qVoZDz3sUPYTdLQmPt6xGkJt+1e/jfHGoyrm/28UWWacX7JC?=
 =?us-ascii?Q?Susfky9udhImTpy2YBrAIPX90DGG9Uqi4E+yEfBVsFlJCe0yPZ9U1j5D7wsn?=
 =?us-ascii?Q?fFMNAHT43jo1za/V6weWf5DaLmeZFvM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A818D85D742EF3478C27F0DC2D64040D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e40c99-5311-444b-58ba-08da1b3deff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2022 22:03:25.8107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SczSkAYt/RDFwL8rP9pK1N7IZluQTe9xjq/PWZSOjI5eIzavSS3wnqgsZxSZe+m3bGaQMNjcvYmS10fpELTwNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 08:02:13PM +0200, Tobias Waldekranz wrote:
> On Sat, Apr 09, 2022 at 20:45, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > Hi Tobias,
> >
> > On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
> >> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp.co=
m> wrote:
> >> > For this patch series to make more sense, it should be reviewed from=
 the
> >> > last patch to the first. Changes were made in the order that they we=
re
> >> > just to preserve patch-with-patch functionality.
> >> >
> >> > A little while ago, some DSA switch drivers gained support for
> >> > IFF_UNICAST_FLT, a mechanism through which they are notified of the
> >> > MAC addresses required for local standalone termination.
> >> > A bit longer ago, DSA also gained support for offloading BR_FDB_LOCA=
L
> >> > bridge FDB entries, which are the MAC addresses required for local
> >> > termination when under a bridge.
> >> >
> >> > So we have come one step closer to removing the CPU from the list of
> >> > destinations for packets with unknown MAC DA.What remains is to chec=
k
> >> > whether any software L2 forwarding is enabled, and that is accomplis=
hed
> >> > by monitoring the neighbor bridge ports that DSA switches have.
> >> >
> >> > With these changes, DSA drivers that fulfill the requirements for
> >> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filter=
ing()
> >> > will keep flooding towards the CPU disabled for as long as no port i=
s
> >> > promiscuous. The bridge won't attempt to make its ports promiscuous
> >> > anymore either if said ports are offloaded by switchdev (this series
> >> > changes that behavior). Instead, DSA will fall back by its own will =
to
> >> > promiscuous mode on bridge ports when the bridge itself becomes
> >> > promiscuous, or a foreign interface is detected under the same bridg=
e.
> >>=20
> >> Hi Vladimir,
> >>=20
> >> Great stuff! I've added Joachim to Cc. He has been working on a series
> >> to add support for configuring the equivalent of BR_FLOOD,
> >> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allowing
> >> the user to specify how local_rcv is managed in br_handle_frame_finish=
.
> >>=20
> >> For switchdev drivers, being able to query whether a bridge will ingre=
ss
> >> unknown unicast to the host or not seems like the missing piece that
> >> makes this bullet proof. I.e. if you have...
> >>=20
> >> - No foreign interfaces
> >> - No promisc
> >> _and_
> >> - No BR_FLOOD on the bridge itself
> >>=20
> >> ..._then_ you can safely disable unicast flooding towards the CPU
> >> port. The same would hold for multicast and BR_MCAST_FLOOD of course.
> >>=20
> >> Not sure how close Joachim is to publishing his work. But I just thoug=
ht
> >> you two should know about the other one's work :)
> >
> > I haven't seen Joachim's work and I sure hope he can clarify.
>=20
> If you want to get a feel for it, it is available here (the branch name
> is just where he started out I think :))
>=20
> https://github.com/westermo/linux/tree/bridge-always-flood-unknown-mcast
>=20
> > It seems
> > like there is some overlap that I don't currently know what to make of.
> > The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress settings,
> > so I'm not sure how to interpret them when applied to the bridge device
> > itself.
>=20
> They are egress settings, yes. But from the view of the forwarding
> mechanism in the bridge, I would argue that the host interface is (or at
> least should be) as much an egress port as any of the lower devices.
>=20
> - It can be the target of an FDB entry
> - It can be a member of an MDB entry
>=20
> I.e. it can be chosen as a _destination_ =3D> egress. This is analogous t=
o
> the CPU port, which from the ASICs point of view is an egress port, but
> from a system POV it is receiving frames.
>=20
> > On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
> > bridge device as the knob that decides whether the software bridge want=
s
> > to ingress unknown MAC DA packets seems the more appropriate thing to d=
o.
>=20
> Maybe. I think it depends on how exact we want to be in our
> classification. Fundementally, I think the problem is that a bridge
> deals with one thing that other netdevs do not:
>=20
>   Whether the destination in known/registered or not.
>=20
> A NIC's unicast/multicast filters are not quite the same thing, because
> a they only deal with a single endpoint. I.e. if an address isn't in a
> NIC's list of known DA's, then it is "not mine". But in a bridge
> scenario, although it is not associated with the host (i.e. "not mine"),
> it can still be "known" (i.e. associated with some lower port).
>=20
> AFAIK, promisc means "receive all the things!", whereas BR_FLOOD would
> just select the subset of frames for which the destination is unknown.
>=20
> Likewise for multicast, IFF_ALLMULTI means "receive _all_ multicast" -
> it does not discriminate between registered and unregistered
> flows. BR_MCAST_FLOOD OTOH would only target unregistered flows.
>=20
> Here is my understanding of how the two solutions would differ in the
> types of flows that they would affect:
>=20
>                     .--------------------.-----------------.
>                     |       IFF_*        |    BR_*FLOOD    |
> .-------------------|---------.----------|-----.-----.-----|
> | Type              | Promisc | Allmulti | BC  | UC  | MC  |
> |-------------------|---------|----------|-----|-----|-----|
> | Broadcast         | Yes     | No       | Yes | No  | No  |
> | Unknown unicast   | Yes     | No       | No  | Yes | No  |
> | Unknown multicast | Yes     | Yes      | No  | No  | Yes |
> | Known unicast     | Yes     | No       | No  | No  | No  |
                        ~~~
                        To what degree does IFF_PROMISC affect known
                        unicast traffic?

> | Known multicast   | Yes     | Yes      | No  | No  | No  |
> '-------------------'--------------------'-----------------'

So to summarize what you're trying to say. You see two planes back to back.

 +-------------------------------+
 |    User space, other uppers   |
 +-------------------------------+
 |   Termination plane governed  |
 |     by dev->uc and dev->mc    |
 |            +-----+            |
 |            | br0 |            |
 +------------+-----+------------+
 |            | br0 |            |
 |            +-----+            |
 |  Forwarding plane governed    |
 |        by FDB and MDB         |
 | +------+------+------+------+ |
 | | swp0 | swp1 | swp2 | swp3 | |
 +-+------+------+------+------+-+

For a packet to be locally received on the br0 interface, it needs to
pass the filters from both the forwarding plane and the termination
plane.

Considering a unicast packet:
- if a local/permanent entry exists in the FDB, it is known to the
  forwarding plane, and its destination is the bridge device seen as a
  bridge port
- if the FDB doesn't contain this MAC DA, it is unknown to the
  forwarding plane, but the bridge device is still a destination for it,
  since the bridge seen as a bridge port has a non-configurable BR_FLOOD
  port flag which allows unknown unicast to exit the forwarding plane
  towards the termination plane implicitly on
- if the MAC DA exists in the RX filter of the bridge device
  (dev->dev_addr or dev->uc), the packet is known to the termination
  plane, so it is not filtered out.
- if the MAC DA doesn't exist in the RX filter, the packet is filtered
  out, unless the RX filter is disabled via IFF_PROMISC, case in which
  it is still accepted

Considering a multicast packet, things are mostly the same, except for
the fact that having a local/permanent MDB entry towards the bridge
device does not necessarily 'steal' it from the forwarding plane as it
does in case of unicast, since multicast traffic can have multiple
destinations which don't exclude each other.

Needless to say that what we have today is a very limited piece of the
bigger puzzle you've presented above, and perhaps does not even behave
the same as the larger puzzle would, restricted to the same operating
conditions as the current code.

Here are some practical questions so I can make sure I understand the
model you're proposing.

1. You or Joachim add support for BR_FLOOD on the bridge device itself.
   The bridge device is promiscuous, and a packet with a MAC DA unknown
   to the forwarding plane is received. Will this packet be seen in
   tcpdump or not? I assume not, because it never even reached the RX
   filtering lists of the bridge device, it didn't exit the forwarding
   plane.

2. Somebody comes later and adds support for IFF_ALLMULTI. This means,
   the RX filtering for unknown multicast can be toggled on or off.
   Be there a bridge with mcast_router enabled. Should the bridge device
   receive unknown multicast traffic or not, when IFF_ALLMULTI isn't
   enabled? Right now, I think IFF_ALLMULTI isn't necessary.

3. The bridge device does not implement IFF_UNICAST_FLT today, so any
   addition to the bridge_dev->uc list will turn on bridge_dev->flags &
   IFF_PROMISC. Do you see this as a problem on the RX filtering side of
   things, or from a system administration PoV, would you just like to
   disable BR_FLOOD on the forwarding side of the bridge device and call
   it a day, expect the applications to just continue working?

4. Let's say we implement IFF_UNICAST_FLT for the bridge device.
   How do we do it? Add one more lookup in br_handle_frame_finish()
   which didn't exist before, to search for this MAC DA in bridge_dev->uc?

5. Should the implementation of IFF_UNICAST_FLT influence the forwarding
   plane in any way? Think of a user space application emitting a
   PACKET_MR_UNICAST request to ensure it sees the packets with the MAC
   DA it needs. Should said application have awareness of the fact that
   the interface it's speaking to is a bridge device? If not, three
   things may happen. The admin (you) has turned off BR_FLOOD towards
   the bridge device, effectively cutting it off from the (unknown to
   the forwarding plane) packets it wants to see. Or the admin hasn't
   turned off BR_FLOOD, but the MAC DA, while present in the RX
   filtering lists, is still absent from the FDB, so while it is
   received locally by the application, is also flooded to all other
   bridge ports. Or the kernel may automatically add a BR_FDB_LOCAL entry,
   considering that it knows that if there's a destination for this
   MAC DA in this broadcast domain, for certain there isn't more than
   one, so it could just as well guide the forwarding plane towards it.
   Or you may choose completely the other side, "hey, the bridge device
   really is that special, and user space should put up with it and know
   it has to configure both its forwarding and termination plane before
   things work in a reasonable manner on it". But if this is the path
   you choose, what about the uppers a bridge may have, like a VLAN with
   a MAC address different from the bridge's? Should the 8021q driver
   also be aware of the fact that dev_uc_add() may not be sufficient
   when applied to the bridge as a real_dev?

6. For a switchdev driver like DSA, what condition do you propose it
   should monitor for deciding whether to enable flooding towards the
   host? IFF_PROMISC, BR_FLOOD towards the bridge, or both? You may say
   "hey, switchdev offloads just the forwarding plane, I don't really
   care if the bridge software path is going to accept the packet or
   not". Or you may say that unicast flooding is to be enabled if
   IFF_PROMISC || BR_FLOOD, and multicast flooding if IFF_PROMISC ||
   IFF_ALLMULTI || BR_MCAST_FLOOD, and broadcast flooding if
   BR_BCAST_FLOOD. Now take into consideration the additional checks for
   foreign interfaces. Does this complexity scale to the number of
   switchdev drivers we have? If not, can we do something about it?=
