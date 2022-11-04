Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E7E61972A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiKDNLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKDNLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:11:10 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80088.outbound.protection.outlook.com [40.107.8.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2807E2ED71
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:11:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fa35QmtLdUnRG4r5XFyAXZxB/CUyTp8rWzaaruF4g8FHuSEjnkLjYtxnJT5QLJgXD5r9IvTjSeYySYKzyIRoKNWMjjY+mrIWA3NipaB6KEDVmTnioNUdmVKUIcJEvjW1xihFWwky6nf55IzFuvCZbo/XBjH2rRBcuf1M5IsiNW9W1erA2eVRKP0KEIcMoCmIT3ZO5zkdZp4f1DdhA8vHsWZ1FIvnEk/xO3oTBBk1xtJSdBgLa93VIHf9eqM5BTgLsmwbok0jbi684AWwN/SqecO7DUWIf4HrOXeu0GhyE4mIWJfaXHCju2Fom3T0ihOhAJpXE/PqDAuf5COO2rSOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LT1/+dZKzYfztIxqlQ1kLxlfG7NwIKOnBvdUFXrDWo=;
 b=dAJ4rAgtf5rqSbqAO4gOvP9j6UMhe8Yz2utPAtu9zrEahSizFWop2VEy1c+xj0aHS7ENS0ULuq8pJdxLXXDdZ1UzHDEnqhjsqmK2r0KvWOIWLoh6hMKRcj8npp/j2cE/9p3r9CyXCnFtVelFVFjJhsNULREt4bM4b44nQBzicXHh9oBCgM3yxQ7HvFfXQk38EtFgK0ePl7Z+gZEBlxxK73agb5o6F9nAcS52Kv31r1R6tCOrN2yto4HCeyn5ptxHFBROteZijhyxWJ7KAt9g0/KwnVC5KUbOrrJS6MSwLkjEaYFlb302zmCprl5OHOqwqkRPCfR7k6uttY0SMuALjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LT1/+dZKzYfztIxqlQ1kLxlfG7NwIKOnBvdUFXrDWo=;
 b=hzX5/x9zGgJ6g1ddKyZG3VzAQSWAheTr3qtLViLKpauAzRh1rZDBiVTD4wrySUYg3BCuQQTu8p4VRZOOvS1RGH7J4IyXhhCLEHlDBKJiKY8a27jdLcftakuG8HOTq3Hj0lZ50l//BGy6YcC+Mq7V5TiLL7V8vheuXO+u/s4UsZA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8545.eurprd04.prod.outlook.com (2603:10a6:20b:420::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 13:11:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 13:11:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@kapio-technology.com" <netdev@kapio-technology.com>
CC:     Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB)
 support
Thread-Topic: [PATCH net-next 1/2] bridge: Add MAC Authentication Bypass (MAB)
 support
Thread-Index: AQHY7inCrbPCJEIs3UaHPF1x4C21m64uo0yAgAAeKQA=
Date:   Fri, 4 Nov 2022 13:11:05 +0000
Message-ID: <20221104131104.4qvnx5rarvsyrpe4@skbuf>
References: <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
 <20221101193922.2125323-2-idosch@nvidia.com>
 <20221103231838.fp5nh5g3kv7cz2d2@skbuf>
 <ce9f4095b216187c1dd5c14cdf4ae9cc@kapio-technology.com>
In-Reply-To: <ce9f4095b216187c1dd5c14cdf4ae9cc@kapio-technology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8545:EE_
x-ms-office365-filtering-correlation-id: 721de0bf-962e-439c-3aff-08dabe66080e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iWUtgbOhckPxauX5bSKY6poFE7VoksGEnOYn2jDkmLwNAKFJi50uZCyewhzwpwwd1oOPd6OkvrmO5d+i9FVsWhnnGwQFe10awJKNlDlzLAOI/mzwXLDkIN2dxPMFL+R5HPLtPC9JeRgJX0VCCiEJBmLWJJTn7/AWxbqkj0tDxf9j1ahoKwH6FpD/EFixH2sNfqMVpTXxgztxf5yJYaokKohFXiWDPQ8gXY+JY+Uz4G9OqF1VB75Vnxrxl6tt0EiqkNtw0kNWsP+yy1Nxp5B6UEGH9q3Wj4Hr7jDhXj49Dl7yzarCfB268YJiccSKr8NnIocRxolR2tZp6W43Bpg4Z9qLBgAtj16nX0i5iDCJDHLcgQQD8kRHoNS50028t9h2ZcfdtTtzDTb83jYs3fXMYudX0SKWc2Jf5zCvtFuToT8p1pl742zLpt4FXLpj+6p7OJs9jfey2aIDs3W2qRURPturUk08eY5ESP4NR/gy435/G/eS4fOmYid7pzG4VIjZ+4ib1NinB65bqQ/y4RTCv4BQFPFDgaWRuTXRy1Yt+1qkVh5FLn7SLkvHy39EkFytDgPLp2mK5d0uXRs3UDEBik7cP9BkWJeTXVbvnsDbuOQYjlw2XH1jemLVTu2Jj1OXHoOYdBF3CYj1nr4PeUPEF7Hvmjn+dmCkfcCPQyyaNR9ykqqAlqATaqnPsNcYVcXkwZo4aZkbfDVeBcHJsN/j+8tA3zM7+IkM+waivL7E0yA6shP02oX0dsw8ZCKj2e/z4Fb4Zo71Us9h1IzArcyYrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(186003)(6506007)(53546011)(1076003)(7416002)(9686003)(66556008)(66446008)(64756008)(316002)(76116006)(66476007)(4326008)(54906003)(41300700001)(8676002)(26005)(6916009)(91956017)(66946007)(83380400001)(6512007)(5660300002)(86362001)(38070700005)(44832011)(71200400001)(2906002)(478600001)(122000001)(8936002)(6486002)(33716001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X+B72ezccF/adu50Vd0nTfa7XniQWVcKECf+i4Iz/yeaESmbsrpyqJyuEeeP?=
 =?us-ascii?Q?XKPhAL2tN6r9vKfr6RI78qixzxVIUUS2kEk+NJF4e0Wu9g98/03pH7dqxl36?=
 =?us-ascii?Q?OC1oD/6FbISFG/QKHx7H7HfkpJTX3B/XLf+2/DSu+8xzlBtNcKkws5VbMUD/?=
 =?us-ascii?Q?528rXt7PEO9Q4o34H6eLE6RciN5Ei+H4jxwUTkZPYp5id5/k3Kb7esx5iS6p?=
 =?us-ascii?Q?320YIrzPSIp8YeM6iuNM8NdDI4CczlloB7Yu+eWIlPm2xy0LGH3GNgQGPGsO?=
 =?us-ascii?Q?3qKXWWQ1RMRPwoR5ULIk2vvY30x89aOLe6La4oU0cBroymC4CQg458EK0qua?=
 =?us-ascii?Q?REq6y7JSYkonCjm69xq1t3qmIVyZAJ86CNywFBvKJxFVvgdFk+XQVUgDxHZu?=
 =?us-ascii?Q?TbJ/XhJMH4jfjsdxC1QCHyqTFMkXQp4kTvu62EjdRCrl8CIrb7penKd/uuWJ?=
 =?us-ascii?Q?zT/u6db0/6sV6478vD8a3Qk5T27ahOSQUIJHuzR0MhXVqeD7+U4quwaYB0VZ?=
 =?us-ascii?Q?lYIx6fPjJY7Pdu3H6TLQSarfvtrzo6+mrvZHtMe5H47ULAGVOW4WCDx7axQv?=
 =?us-ascii?Q?pS9fGh1Bqe7kIuzIDmFN34xvu0hOvxfTVWQNUx/iiiY2gaQ7ZC94epowp0Cg?=
 =?us-ascii?Q?djuxmvhkz7U84eaY+RNTQn+FDUfUv/6tMo7FV6Spk6cVrFTh/JkLLKv8f9iM?=
 =?us-ascii?Q?cfEIXGmq47Uj+Db3M1zpLdvXM4lx60TCRMUa1HxjQohjABZHz8H6OZgZQ1xe?=
 =?us-ascii?Q?jCqcHOGxvmJKowGyNJjc26Becr7YrMdn1MFvcv3xUAMds7LBVfx9f/hmEBTo?=
 =?us-ascii?Q?jnv6xJymIf8OE02D8XqvktQvNjKXTGeTqBgrmVeub5vt6chzK9d4amJOUKaf?=
 =?us-ascii?Q?YhXZkqqtnHzbVllW+mQPvZrsz/yNq1TXgc4FpPwXx0kWzANb1IU1H0WRpJ4j?=
 =?us-ascii?Q?o4rz0qa/69MfilmoswSykNG47rGOKDcpF7b5FQ2xjoZ+mqwqqJDi6hNcmV63?=
 =?us-ascii?Q?TEooJadQDUp6paQ6Q8RRFtVi5Zp2VBul04zRNpor/0heHiZpvNpps1xKinGn?=
 =?us-ascii?Q?anxwmnzYkIOpzPKB3PGyOpLki3d2gktN3iDTS+RTN4O+oJvf/sxuwXdVeWlw?=
 =?us-ascii?Q?d/P2EuxCxeduT3DEzkhE50CXWs2Qoek7lSNI+DbVSy352cy+hoMl6PTf5mFh?=
 =?us-ascii?Q?F1/lv5X1Hrro4UhRIFjq+zV5QaF5t4PI8H3/RYkPKVPZc6b6DoD2/mzS83t2?=
 =?us-ascii?Q?i4c9ToCqMkX1ZWlj+nWvWj/elp7eiTZHyFDwknCv3WCg9RT2O53ntpzi6XrU?=
 =?us-ascii?Q?rLacmHS5FwG85bnALErFi2cYaIeozRUcCec7ZLjfaUrmzmxn5dXEIkIsvJwu?=
 =?us-ascii?Q?ABELsvAoKLWKNxyjxyavirMTo+XuDnjRnxe1gcthwpETIM6FOj0uqMrhTArQ?=
 =?us-ascii?Q?KmNWcesPs5bu9W3eHjqv96QlcrUyTWSk1CsdrLO+phSm7Xxrl+pgKnZmIvlF?=
 =?us-ascii?Q?5L2HWtOhI5UwcIlb92TASbs6oUtfA9GNIiCjhiY7N8wub8hhERPmNGEMlPc8?=
 =?us-ascii?Q?48cZzHTSB5I6qPND35KxAqXEWgpi0FX1Tl4XofKTbIBmPgbnu+GddO8e31/w?=
 =?us-ascii?Q?Bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEEEE89226DE2F4DB60A9CF020EB9A10@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 721de0bf-962e-439c-3aff-08dabe66080e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 13:11:05.6813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mfi9XI7H2rnU4U1MfJyBFxPg0GL2w1AG8/hP98KOSTyz8YxnIOTtUWTOr6PYdbMioFurT43rGKStEOmQ1rt1JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8545
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 12:23:07PM +0100, netdev@kapio-technology.com wrote=
:
> On 2022-11-04 00:18, Vladimir Oltean wrote:
> > > 3. Forwarding: Locked FDB entries forward traffic like regular entrie=
s.
> > >    If user space detects an unauthorized MAC behind a locked port and
> > >    wishes to prevent traffic with this MAC DA from reaching the host,=
 it
> > >    can do so using tc or a different mechanism.
> >=20
> > In other words, a user space MAB daemon has a lot of extra work to do.
> > I'm willing to bet it's going to cut 90% of those corners ;) anyway...
>=20
> I would like to know your (Vladimir) take on the approach of the
> implementation for the mv88e6xxx that I have made and which will also be
> the basis for how the WesterMo hostapd fork will be afaik...
>=20
> Is it in general a good idea to use TC filters for specific MACs instead
> of having the driver installing blocking entries, which I know the Marvel=
l
> XCat switchcore will also have (switchcore installed blockig entries)?

Well, the mv88e6xxx driver does not offload tc filters in general, so
let's keep that in mind.

Achieving the behavior of not forwarding traffic to a BR_FDB_LOCKED
entry can be done in a variety of ways using tc. Simplest would be to
put an "action drop" filter on the egress chain of the port where the
BR_FDB_LOCKED entry is located. Although that's probably least amenable
to offloading. I think "action drop" is more popular as an offload
action on ingress chains, which means you'd either have to (a) put an
"action drop" on the ingress chain of every other bridge port, or
(b) create a shared tc block and put all bridge ports in that. The
problem with (b) is that it doesn't play all that well with bridge ports
belonging to different hardware blocks.

All in all, I think the yet-to-be-introduced 'blackhole' FDB flag makes
the most sense for this behavior. Its scope is the entire bridge
forwarding domain by definition (no need to attach it as filter to the
egress or ingress block of one/multiple bridge ports), and it's also
easily offloadable.

I think it could make a lot of sense for the MAB daemon to do one of 2
things: replace the BR_FDB_LOCKED entry with a static/dynamic FDB entry
if it's going to authorize it, or with a blackhole entry on br0 if it's
going to deny it. So you wouldn't have to manually add the blackhole
entry from the mv88e6xxx driver; user space would do it.=
