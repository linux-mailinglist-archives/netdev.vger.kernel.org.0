Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EC64B4DC4
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiBNLNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:13:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350215AbiBNLMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:12:43 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ED8AC072
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:42:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNGjpPMO2ZFa95OFUgIDN4ESppO+boy/XHmF13gV6gMiu25F0MWMahjLm+D0ybVHGsLMkTfOXOznTFWn85cZAzTQL/Jh84DpmwmNw3UznxpqX1BU3CKLJVXM6DT17wWbPAmGUqDFIlUZr2kdbB6+vetY9ldr/peh3noXatEAsozdDzzcAlA4n4QRSkdnuIQ+XNoaOyo9fhTu8xIlUy4fAGEBbw5nz5Q5sFw1/P7C0P5K3zqrZYk7xszJjca/gEHyVAaHCLFO9i453+xpLxJGkWWRlBuXfgk5BjvDtO1CtC27g/yz4SdvN3uZb6AzKN/uvhgIMEFJzw9c7BEaHedr5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qLXo5JIpskujQu/eDbA92l6Uq31DDoVhIvka/5d4tE=;
 b=bHW9QAYWNmE7OLqGQMGSEOnQtXhxBE1pN7RD1mL2xZ4LIlloahgA96clbFe/UFBp6ElfgUjeZjbm/dGVcQgjar8PQFe0+EaTSsc33d4LcQ1XO4a5Q1POmlawsE5C0Ic1iU3wal7ROInYdLmFbGBDu61w+H8DTwZzBq4R7nQfwdFswBMltDO2z/sNbr4i0R9jWGxZQza2SCVLynoyyhGaexBKMuinFi1uwS6iWgU2AOsCggW1bqzyYRDUb2Ws/v26Z2X+B7/Ai3hkxILp7ApuZu8zkAvZOKLkw2JPN2x0PQmUfGpTjda1RYHaHbFHc6IS0GlfCKLAEca3vE7laLygMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qLXo5JIpskujQu/eDbA92l6Uq31DDoVhIvka/5d4tE=;
 b=kE1H5EqHx7foaEV7p7rB3mXExYygScajrOOdtD5o/zbdASQlmL+x6a29umr1rbvuoIBMdIIbnNjJY6TFUIrQ9hOFft/GqQE8oKBCuNak92SnZnKJRnA1YfvtljKrijDRgRTbemmMQnm5D0uLNk+WmVJtGaWYhs8u7MfhrXYoeT8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8408.eurprd04.prod.outlook.com (2603:10a6:102:1c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 10:42:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 10:42:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Topic: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Index: AQHYHfxXQePXs1M3lEOTgYyrlnmZbayR2mIAgAATBoCAANrDAIAADtgAgAACXYCAAAW4gIAABAGA
Date:   Mon, 14 Feb 2022 10:42:18 +0000
Message-ID: <20220214104217.5asztbbep4utqllh@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
 <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
 <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
In-Reply-To: <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66658f23-926f-4435-6030-08d9efa6ac2f
x-ms-traffictypediagnostic: PAXPR04MB8408:EE_
x-microsoft-antispam-prvs: <PAXPR04MB8408D9E8AA17C2CC925409C9E0339@PAXPR04MB8408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ptkyztSOxdtZSN8+rMPfwC6Oq7zKO3Nfpm7W4vnkMGv6oe/7wu1MbAez4BabZ11d+g1t4vUPlhaLbT/6Lga4pVwb6T2TcC3vejyjWi7hQIaWQfiW+U6wID1JGQGVOm15aUkECo9f1kyaR5ratnpa69rlNJS66bgYjINLkM5vZkzTyZhq6G0c2JuxvkoLfzgLMk7Fsq14ftTByN/jinZ8DFERZEpHv/SIkqgecon9mii7yLO2mneeFzwq9aSHeNbk07yzNxpvjlOJiIvMH+oFkQaM0QZl8Tpmr70+x3jxB7ECWH6bO629jgrQ9Nl5wfh3EMJKUeLPl38mLXHJs2jGsVJf5DbJRox9PCRrsvcGrL8hbc5ANf8LC2IytTEGlEk4/ja2ZK35V4idBYv8yTok5M96BYytS/0A0ytVpTMZ9/lUr8Exu+MqZhAweINPiPyaP7ePUjV3VVJ43jGHPduXjPMBuZp2ogR5jAjxtw6/9WvK+DCkTZgcGZGyfcUM//wkocEuYzgbht9Ac+vYjSNEpoi9PIZDnLoG03E5LQ8uBCfSTC5/4s7DPpUBNGNADxzMRiODBpammStVcpCxjmeoGNaxEGXYoXoswT0I3Kmq1bnVkm7M5bbOWXtNM9I/8+pKeVq53ca8JVjmxVA0Hhmh9QVtf5TqQQ2OsM+KklyQpsp8IYY1IyeUpX8e2Ku5NW9EPUbvsFhOUIG+veniqVnoYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(9686003)(508600001)(6512007)(6916009)(122000001)(38100700002)(53546011)(44832011)(7416002)(6506007)(38070700005)(76116006)(86362001)(91956017)(316002)(6486002)(1076003)(186003)(26005)(5660300002)(4326008)(71200400001)(83380400001)(8936002)(66446008)(64756008)(66476007)(66946007)(54906003)(2906002)(33716001)(8676002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rnYhGaB1EQfx+ndhvP+zmk037IQMUAxuAUiJC3hqedMQ2LW5fwZnzjcmkqmv?=
 =?us-ascii?Q?j/bEG3PFz+mobslku4RQu45Fwy72wFssdqg1uqx2YT4sgtl/kKfWxurS8sNM?=
 =?us-ascii?Q?rCCZU9cRHLqsgfwLi5L7Fxz58J0hpjSjNjkWCwEJevLWbAOdVkJqPR4dQ1MT?=
 =?us-ascii?Q?gnFDggfaQtXGwAj/1fRx2gZtDl6xaplXmE/k6Fi7aIjTD28GwxMOiScQCByq?=
 =?us-ascii?Q?+M8Mqd+N9jEesJvdwW0oQcaeSXmk+DYN6cLBbtvQMcW3nOfN+aOXeTQbLrQB?=
 =?us-ascii?Q?oGP5Iw2B37Du0Pob90p0cygeJlCw5GefT7DDEEePQO24yBC7j3FXU8kKULlr?=
 =?us-ascii?Q?R3lqLv427yKQn2UHo5V8JBKdu3XN2sIhyKiwn801fRkco9ioyq8eezSVZrl7?=
 =?us-ascii?Q?c9sc7VMY3SheRplCLzy5++aIq/+c/tHqSAKWyn0r1ipISamP6ba//IZL3S/E?=
 =?us-ascii?Q?zkeOmHpjCr3zdTMwoiSvZKmAMm/xh1cgYr04QmMPQyutXLrsA+E7jf8YSe0r?=
 =?us-ascii?Q?/4IjpOQcSlPU+sR3Sn0tbjeSwlq+ma7KtjiRFcaXQV7hvhx+yPKJfZmywHzw?=
 =?us-ascii?Q?YVoadZFufm4tGJODHTxYm7FcsRbMMeWeoHdI/bJLsST4rp6SkV1Y4eCS4RgH?=
 =?us-ascii?Q?9Y6T7pWkZyCdpGrH737k31nUysWtRu17kAMdN1uPooxOT6kn4pjTWfpTbw4q?=
 =?us-ascii?Q?fPVOSq90/orlQ+MKoldbFT+09D+UtzMpzRSD16f3mTzDrVnWCYLoMbaB7mFv?=
 =?us-ascii?Q?ohtCjFuHdUEJ6QM8Gz7mVw2rEg2Gq+GJbTigetHblU+BVPNmStCBYlUzrdfD?=
 =?us-ascii?Q?yIgRjB6t3Q5INGUFkeuQ4rBeREx8UuhP9rIW0dSTP6EfwsXmOUHTO7kbZaK/?=
 =?us-ascii?Q?DidQRZg0/o8jSA+b699xXz/jqzQu6gchZCvNisuXlPqUnuis6k0rSUN6tvBI?=
 =?us-ascii?Q?aRunRDTycgrldzNVTjJHHuwq/uEZ1SmVgxecEXaqOJe6rtO7S4tl5aiwDV70?=
 =?us-ascii?Q?9BKmKF522KNrLAseOKj0kAuyb8YhOr1guHZ+tgR2fz1rUy4GOBy/KgtO63XO?=
 =?us-ascii?Q?ELIih2CuHIpRw6yBggmv5wGOIkoDvM5RJc5CmzKkv8DdzxCIq/5ey62sQLuV?=
 =?us-ascii?Q?fuqDWCvxU4Lyt7v5b+gwJxMuxioIgF3modkCOIu+RPi15FmdXP34GMknHDHx?=
 =?us-ascii?Q?/lLODoP/dSmOlEHsYuDRqpIueVkxbldUucEAVXHMgu0O7uHuQ+N7w9NByuKj?=
 =?us-ascii?Q?fFI0I3fbBKUvzcPw6CwYARCL4k57Lyuo/Z9XbV+fWnS0UImXiZSHaiZv7aaS?=
 =?us-ascii?Q?RlM5QUh39zYNFu2IGkms7IqopwOURkpHiiLVDlz/wJAUNA+SLa43q6X8awwO?=
 =?us-ascii?Q?2lg5v7EGK1/ONMrkILfDAj87/SzUX4MhW41xOZljowe+7EZ65Y+7C6TO9B5F?=
 =?us-ascii?Q?tZ3bj/xuDe94GIYmIzi6Z4ZxrS1uhcLY9SG0q+amPNiEqEUU520vnV98tOc3?=
 =?us-ascii?Q?Yh54kPIysjCuVoUYbYLqvffl0OKCtLrhHTMGLwC3IzXg3fBo7XyYP7TeV0ce?=
 =?us-ascii?Q?Q5xk+CKaLYcdC1gQCsMx6K6XWwI/9D60SFEba2DFkLZ86k+I6NtlDBjdVUYc?=
 =?us-ascii?Q?XXeWoO9c3Gur3hIjgWGYKmg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB92FA074A5A5B4D84B60C3181B9C26E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66658f23-926f-4435-6030-08d9efa6ac2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 10:42:18.0937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v5dJCTiKx0sd3sTKv+4VaNWqWkuNTjqZ4w2oNfkPkvtHpzf8iitKYs/LWlZVTBjn0g9o6NMPs6vjxfCcUmEoww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8408
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 12:27:57PM +0200, Nikolay Aleksandrov wrote:
> On 14/02/2022 12:07, Vladimir Oltean wrote:
> > On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
> >> Sounds good to me as well. I assume it means patches #1 and #2 will be
> >> changed to make use of this flag and patch #3 will be dropped?
> >=20
> > Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
> > their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event when
> > really nothing has changed (flags =3D=3D old_flags, no brentry was crea=
ted).
> >=20
>=20
> I don't think that's needed, a two-line change like
> "vlan_already_exists =3D=3D true && old_flags =3D=3D flags then do nothin=
g"
> would do the trick in DSA for all drivers and avoid the churn of these pa=
tches.
> It will also keep the order of the events consistent with (most of) the r=
est
> of the bridge. I'd prefer the simpler change which avoids config reverts =
than
> these two patches.

I understand you prefer the simpler change which avoids reverting the
struct net_bridge_vlan on error, but "vlan_already_exists =3D=3D true &&
old_flags =3D=3D flags then do nothing" is not possible in DSA, because DSA
does not know "old_flags" unless we also pass that via
struct switchdev_obj_port_vlan. If we do that, I don't have much of an
objection, but it still seems cleaner to me if the bridge didn't notify
switchdev at all when it has nothing to say.

Or where do you mean to place the two-line change?=
