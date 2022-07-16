Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9234C576E2F
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiGPNaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 09:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiGPNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 09:30:14 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F85218B1D
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 06:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uhf5tKartYfNsq0XRtuYKRkL3Z9WRt0EuXkICxxiSRQlRANSlKcgI2X6EjTGc04B3OqrqlReCzBs9zsBndWvQZwqzxKrsqQilr/Pb8ahRw1u+wxTX16cccCUE/wwk6tz47VZKC5hv3U9ToR6vXRIxcV8rxO2iyWNoGZWob/HMtO9RH7rb9UJYu842Ws92owpikB4BIF6d5nUGEoxbWS2cLgHTj5sK6JgcyqCawtIha8N1BBk5rWR+6q39ecLPmMROc/2gZ+A1fHOTwRLzR+9rWto70b1sKg9Q++IA0zs9nilIxKvZgpk0Cu5k6eCd16b2B4YGOKxeA/9lZ/sbuYFFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2a0drTptlZZ4V2ZG4fDkgbv1XEW1HWIkIoRsxwbL0k=;
 b=fIe8QUeZiDBtPlsZMnzXpEUNM2RfVk5sm9dRJM+YjLlxzL4UGdP4X58NZnTTaAR8xfaFGg9X9bXsTyYKRHlfCdIxOx7wkGe0jxUcFDki2ORyFrhJCc+kkhT85Bfc6boeQbVV+QOQ3/1sy8SwbIsg7AVPVF/Bmvhfq8wLkkx2a2DaoyyXROXA9tB1yr+mF7GGpExp3K7apcsofEt14zoqdxeEGDl9dw6vPCzwdYEoFBUZAw9njyaZi2f+qwDh1OeCV/ufKcBtzSY3+luVB0NZuCKLsdP6Z5MYv9xQ50UM31Bai6piAnFd/AJ/6DVVidAYBh0GSh1AsmUT5fYh+wLMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2a0drTptlZZ4V2ZG4fDkgbv1XEW1HWIkIoRsxwbL0k=;
 b=Zd6tMRqcdWWJStlX/S1PIH3mYRRFKFJjJtmR+jLa/uxH4iX2tZ+y5/q/s1aD0o+FN926oZXl3hRV4ms/x03uYoiZ6wpVjmbHmMg+FifAkZD/RSWZYbxohLNrd01UGiW/LRi9Bexc6Y4UjnbJdWBsnkaHY4bYeW5JUoKsRpexngA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6170.eurprd04.prod.outlook.com (2603:10a6:10:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 13:30:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 13:30:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by updating
 trans_start manually
Thread-Topic: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Thread-Index: AQHYmKJbDVvU92lcVkqDHlTGpm7yu62AHOkAgAAD6oCAAAF5gIAAAb0AgAAIHwCAANLpgA==
Date:   Sat, 16 Jul 2022 13:30:10 +0000
Message-ID: <20220716133009.eaqthcfyz4bcbjbd@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
 <20220715170042.4e6e2a32@kernel.org> <20220716001443.aooyf5kpbpfjzqgn@skbuf>
 <20220715171959.22e118d7@kernel.org> <20220716002612.rd6ir65njzc2g3cc@skbuf>
 <20220715175516.6770c863@kernel.org>
In-Reply-To: <20220715175516.6770c863@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac3adf83-7330-4f95-729a-08da672f4e62
x-ms-traffictypediagnostic: DBBPR04MB6170:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: up29K/j7mjpQmFl5gGyChyq+ZWXsgMjUPUnG1PUXTPeTLyT3kn2WsVjafY2MBfv5AvqmoA8cfx/TMxyz/Zng6i0pNeeqlZCY3e9p1CkJP4vONCa6d9dwxwfKVmhyb2Sh5j2wzX/ADhMa5eo20iV6+4hpGpT8sqagnoDGB7u+Kc5WNa/dXGfkIw6nLB06zmZOZqUPFuoB8MgoVvAOsJi9vgX68Y+rI52SgLYoyKexXczBureOFbHmlcgqswYbG5v5Z0By3MrjjCmOPBho6EYgkRAI3GiIBdlqFxaq2SdQ/Yu2tEK5mNhkKbDsKzDSDpekMygQ4IHKpFu/f9FlZe1KpxtQHFjy58S3uMYCtg6wUMfmtoivWBbqF14t3jJHm/OsTO2spK7qj60fLFg44YEbGEzoLm+UeiOPFjIBBgya5L1l7qwM9KuXKiwCLr3HkrK3ylQ+DROA7aHSK8sCaaxs+hjmoVi7ue0DOw3szj1wfm8la3C1PF3oWe3ucJuDuqub+dSJOjZrfqjKsDIsSZVGWU+ciMbIONIU1D8ImD2tUsIBkqOpiwYx+ADxIpzKiy1UGM7EEM4kmzOdqYtZfEzn9MptH7JdPBC9/vYDNBuJBOIlA8GkWk3/X2/LA3f+8ka5RzzyOv4wNXGYQtaSSlgs1tVmjNESLDFP3/GI7Vf4vor/DBB/4r2LM6wvSLG8A5kjQsaYrYPiwn7QGKt7hpys6eSqaiwUUPZK92y+SYKxhGswZi0G4NIPekzvUfrA/XTRpvBpg+SBabq9tR/iJWbKHX/+WPM26TWccAuRT91kLOLLYED32r6TQmQfShA7EsBw/Y0W5Sw41IzvpnTAltFXJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(9686003)(6506007)(26005)(86362001)(6512007)(1076003)(122000001)(186003)(38100700002)(38070700005)(44832011)(2906002)(8936002)(7416002)(33716001)(5660300002)(6916009)(8676002)(71200400001)(54906003)(4326008)(966005)(41300700001)(6486002)(478600001)(64756008)(66476007)(66446008)(66556008)(66946007)(91956017)(76116006)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tmbivUiueiYmUX+AFUnsdYDR45vogXRJ0YiksQEiKrlFF1fc7uPoHC0UvpP/?=
 =?us-ascii?Q?+qT39zBoU8YXiH9tiGJ1WlyQVoto5NbtlWhqynXWJWpesOiD6FIZmE6mxuH7?=
 =?us-ascii?Q?hpTjdSn46tRR05JLnYd0U92gZiGTTfS16TvNqMGYy5IN+E2v5hg1YY4xIKYO?=
 =?us-ascii?Q?NvRXpP12GqXwlBaJwsQzg6+AzO8uafug/5XANP53HTWs6oE7yVUP//9Qhe/6?=
 =?us-ascii?Q?TDT8D3NWjOjvj3+aELA7Zun4imsDhiv19bRNLOXIyqUkqDqDBMqAiYzcgUaQ?=
 =?us-ascii?Q?2RTBQV1TLrYPc9zZ2sqQgH8EcFhHiRHtj4kF53GPfFFiPj1HWBAI0spDuUv/?=
 =?us-ascii?Q?9Z7KdAfnJ47WRQvd54kq/P/US+l5s1JjAuunaenM+IxVWXTf4k/Ton1MgF9V?=
 =?us-ascii?Q?jOlBv7LiEVNbjnyIMnDIeVy4vzyICehS0qVJixZ9aeHCY2YfqCYA1JJTTQUB?=
 =?us-ascii?Q?eP4f0sD13DGS6h0yoQGGBsdvOR9EKpZ0lX3v4asJ0hDNOWltE4MNioduBr+l?=
 =?us-ascii?Q?TT6R5fWl8RJRTrZVPvRs48ZWtf9t+mwanCJOhxblhfL6+bG25ZzrPmUzwSE5?=
 =?us-ascii?Q?bRcTwN0qJgtd1Thix/AfZ0uIPCERSdZa2twOATr+GPxNxwWp7oIKfNbinqFv?=
 =?us-ascii?Q?m6iFuNaSdXmf4zkx9tHmA0cDKbmTIfIrtAsDbzm8YeVpEqxG6wc2M7Ef+pI3?=
 =?us-ascii?Q?8sDhlMMJLnhoSky95GsML8WgwdnKocCb7Z+U5+cQvYryvSVUiZ0AEY41z5mA?=
 =?us-ascii?Q?lwZMfyQVDwPQ2Tc5n2UcDbmyAp6S/hL/O7yr9DqrfZZwWOT534Zz0x3wPXm1?=
 =?us-ascii?Q?FnRMCvKZ1jekwhj2ZtSHrThgmWbQRX6YY7IDDWiSQ7PbUgr09/ctkikVMX+A?=
 =?us-ascii?Q?7+prJE8AVlfPf/wxYfh0hf0bZvN71COAh+E/zTkRoSIHareVfDsa6qSVN5hk?=
 =?us-ascii?Q?0ogRypxUNi+a8HiMAD20Wv5CAk2k6aNZiOxwaOkJH2MLXjxd16flJml0/4ZC?=
 =?us-ascii?Q?xz/uY3tsiGYh+J9a0I60JZ2zuRvHIm7aK5PIylN3WLhwKXyG9XdBZ73SyyiL?=
 =?us-ascii?Q?MzOGpSgK44+1XsnP5UAiaNk6/fFPZqSkYnF94UCIwrMoTJ5+GN+DDjcQNZNB?=
 =?us-ascii?Q?G62EDYPpD4V8NmTf0i6pbL3EOWmIEekyF0swH82ZsoUKYPUrn4aSWAFWgqYx?=
 =?us-ascii?Q?ujawAq3okQnEiqTjW2L3O/rn37s4JZyT0uu8z3z/XrZCELkNonEAjabymniV?=
 =?us-ascii?Q?HwIFVkmIW7TCtnt1QL9wu3o15bl0cqtDDibDllgu6S69I2S1ZRfesmRXtFkB?=
 =?us-ascii?Q?LxlmKOzFmbuPi/pY0WM16xwZ2aHT0fREpfexddoBWnZ1JgdHY/vjs2ZxiMgd?=
 =?us-ascii?Q?Q/IrstE3Rp+DqguQoDdc4W3NMwQLWbsqwPdpMq33ZDNtvrIx/ys/7Dn4dXTY?=
 =?us-ascii?Q?D3rBo4chE4zGWzj3MhgiwdclqGIc2RdA7NvjcYtTTE3jgBKvo76jeoAqiXTG?=
 =?us-ascii?Q?KAYIAgISFihO4+qmKlQ0H/ycLcDWZ32+0dK5LrYB0+k6uk519DZTZgIehrDs?=
 =?us-ascii?Q?/hFwH8rqTT+w0Q2OPiQzK9h3ssrft21+Et82c3g6JDsAqMedQyc6GPN52/z8?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <011B0E7378D16D4795DF105F34829D15@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3adf83-7330-4f95-729a-08da672f4e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2022 13:30:10.2232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VWiA+k10p6VL2I60Tbz0P2Bj3aKb0xOh2AWotNFMmprwSqYmLKdmCZBxJ6LnQmM/nUcwjp4fpKBttbRhFlpKUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6170
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:55:16PM -0700, Jakub Kicinski wrote:
> On Sat, 16 Jul 2022 00:26:13 +0000 Vladimir Oltean wrote:
> > > Make bonding not depend on a field which is only valid for HW devices
> > > which use the Tx watchdog. Let me find the thread...
> > > https://lore.kernel.org/all/20220621213823.51c51326@kernel.org/ =20
> >=20
> > That won't work in the general case with dsa_slave_get_stats64(), which
> > may take the stats from hardware (delayed) or from dev_get_tstats64().
>=20
> Ah, that's annoying.
>=20
> > Also, not to mention that ARP monitoring used to work before the commit
> > I blamed, this is a punctual fix for a regression.
>=20
> trans_start is for the watchdog. This is the third patch pointlessly=20
> messing with trans_start while the bug is in bonding. It's trying to
> piggy back on semantics which are not universally true.
>=20
> Fix bonding please.

I would need some assistance from Jay or other people more familiar with
bonding to do that. I'm not exactly clear which packets the bonding
driver wants to check they have been transmitted in the last interval:
ARP packets? any packets? With DSA and switchdev drivers in general,
they have an offloaded forwarding path as well, so expect that what you
get through ndo_get_stats64 may also report packets which egressed a
physical port but weren't originated by the network stack.
I simply don't know what is a viable substitute for dev_trans_start()
because I don't understand very well what it intends to capture.=
