Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C732914E7
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439719AbgJQWRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:17:43 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:2729
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438724AbgJQWRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 18:17:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYUAq++NRT7ytI2kjIzs5zRb/2AzRecv2n9oiecfjZyYnmHNjWtxo7RcfK4UjvXUfHVPDqQXnQr3T5e/hsPboXt31HdY+tme5bbzBwIqzARLhhWmEFyFPfAHW6lkTWdlT1m/+FPyJ+6yW1PnYl4/t0+wm/1V0AVcZsIviC29lbhWhjz/jAvsblF8quisek7InnVqNhcA4QovgrH/SNXZkfKXwoP08jldVZCOEoItzXJvLlBqdFxSMPeq4aPazQfOYfnrXphXXDXYVkitJoKk/FdqjzY96surLFq4dULO5+Lq+qmYy/QCpMfVlZMm3wKjkHRZhE5mtMzTwq4W2PWIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwuCyNGGdZSMe7eNu/1uW3gI29ug0+UHlcV/mpg7SAk=;
 b=IArfNeBESbTbdGi8WutNnCLfvcrgXWKoY4SMGq8nc4w/AUsqSfTtJOLzpWpb3i4HzEf6tHuN4sYdI/pZSnNfZz5XTeRIfHUYMN/x+Y5+R0w2Cpa9zcfs8MroQ48hJS/GRJE3uWLaSlIa8zrH2p0XSH20Zjb1T9tgetat3hSA2yELlv1RnMjsXDUDzjpBu3m3GHRh1JfXbAY24t/iKg31OtVuxHZNSAdqPYdumsSbZe7iLjipwyms7dbot097LadExSAAvKvr0MYTH/+J3XfseEnXJ6Zrl/VRDRiem5PGPTMkkH0Og9IKxug9W9Ip0dyn+GRsqaR/+QBdos4rQscdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwuCyNGGdZSMe7eNu/1uW3gI29ug0+UHlcV/mpg7SAk=;
 b=iBtzs37AwZyq9ZMuaG/ncBqcuctApUYZ8Wus9/sqWRYb5LnTXthaoJ5ebbpoClLm6c2JIs/6Y2XlFYgGBs+ogPKLXB1DvB32adpilJXJbVPhKgUnB2jzG7q/kalX4XZQY/YVgOfug8kOPkH3OTNJH6PcflWAcdkKEhMUSG8R3co=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 22:17:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 22:17:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Topic: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
Thread-Index: AQHWpM2WRVElJamqkEeHVtfDsj9ayamcWGgAgAADBACAAAGbAA==
Date:   Sat, 17 Oct 2020 22:17:37 +0000
Message-ID: <20201017221736.hjehr64y7nwc2ru6@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
In-Reply-To: <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6dffdec-50b2-4875-d907-08d872ea74a9
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB5501288457B81BC3B1A68180E0000@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dIeathzTl2AfkrqVeI0ULgahzzQtv7ZL3dDM5RXa5NWjfDoU0SOcNfdueYXaqnO3Aw2FkJcTaGwwavY9AcSNXnMGaB8AKfqZaDWIoLfUxa+MqZ704UyWECUtoRS+A8AUWy4IsS2A8Cmygi8JT/GwIm12EIJK2hxClvb0zfeyc9tVWetIvVjxRxn4FDU41DFdy5zK590/1WqxcnKCcPfEXQJGtsoPBTnDaGeWl1nFPAnOfNEiyGXEqhe7A+3Eq4Cy03k/dEZfb/1ua5sHjNiLW3i0VdHAn7Psxkfgz/cpM0omrG5sK9+2HsPCNJPdyCYuli0DdyuMlCzTvsl9Hw9Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(376002)(346002)(396003)(39850400004)(66446008)(6486002)(76116006)(64756008)(66476007)(2906002)(91956017)(5660300002)(66946007)(6512007)(478600001)(186003)(44832011)(66556008)(6916009)(4326008)(26005)(1076003)(8936002)(6506007)(83380400001)(9686003)(8676002)(86362001)(316002)(71200400001)(33716001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Pcf91V7F5EMc9BiRQ3g3rjdxIXQe8YKi71EaBHaWNOtitKjD8+GIyPGNEpykhJaKVJ7TeOpbH4qmzMQF3DlV5iCvRmTZ8QbehsUc4DmSNfrdCkHy0tAazlo3wqXAQ/gbEaQjjvsfW4R/DmxvdoQAmn2xg51PoASZnZCVVtOrxu0XgfziAuVAdFXV1sSRkyzm5AJvyZe4tZTJIb+2iRDcRP9Hq793JE8SzHh6ARNUqiihfNZ1L7bb5tI8Xx6rKozs8fRnZLDEUe3Xqo0ec80e+zLajK7xuaeN6iCwF3ZKRQcFYLTQisdXYb/+CVGZDD1miDGdOTgUsPTfB9yVbskcTmHfDVRBagA+f+Dd0PcFGP53H+Wf7up69D3GzO3CUM52YiLSU7UmPRxSEJYSnpc0nyh3CPubD4O9mD6jhSs8/0iZeDN8JHsfV5NS4/iuAi4eIpfEF2eBGNmuMMM7W3lKkTYyEfcPc8SgeCi34S5eHmS+RadKiZVNidVkkqTG6sOgnE3ZMK8WwLEjJOpWDwK7yMnPR8LxN51YBnT62ZjkLmUauYLNbGmAX/sgC5Ro2NNWHQ8ScdTH/wJzX1H3OSVQ+k20ElCq4BHxOINPPLdV0w0Vo1fFs0O1AvLSHMgPho584P2Y/d3B3ZkiF3NyOdZ99Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DF3A6C237A3754193B962A7409865EC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6dffdec-50b2-4875-d907-08d872ea74a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 22:17:37.6438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hBQhirVZVPT4U1RXJgWQw3Bxn7hAmex2w7XcRt2ZbDu9vWciE/3e2met0+Up6D1T0ozJpTcpvPdIh/Poel6ROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 03:11:52PM -0700, Florian Fainelli wrote:
> > 	slave_dev->needed_headroom +=3D master->needed_headroom;
> > 	slave_dev->needed_tailroom +=3D master->needed_tailroom;
>=20
> Not positive you need that because you may be account for more head or ta=
il
> room than necessary.
>=20
> For instance with tag_brcm.c and systemport.c we need 4 bytes of head roo=
m
> for the Broadcom tag and an additional 8 bytes for pushing the transmit
> status block descriptor in front of the Ethernet frame about to be
> transmitted. These additional 8 bytes are a requirement of the DSA master
> here and exist regardless of DSA being used, but we should not be
> propagating them to the DSA slave.

And that's exactly what I'm trying to do here, do you see any problem
with it? Basically I'm telling the network stack to allocate skbs with
large enough headroom and tailroom so that reallocations will not be
necessary for its entire TX journey. Not in DSA and not in the
systemport either. That's the exact reason why the VLAN driver does this
too, as far as I understand. Doing this trick also has the benefit that
it works with stacked DSA devices too. The real master has a headroom
of, say, 16 bytes, the first-level switch has 16 bytes, and the
second-level switch has 16 more bytes. So when you inject an skb into
the second-level switch (the one with the user ports that applications
will use), the skb will be reallocated only once, with a new headroom of
16 * 3 bytes, instead of potentially 3 times (incrementally, first for
16, then for 32, then for 48). Am I missing something?=
