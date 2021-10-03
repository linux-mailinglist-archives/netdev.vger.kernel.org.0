Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C9420402
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhJCVJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 17:09:15 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:15374
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231484AbhJCVJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 17:09:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcKjRJ/JXPP6KxmGHwRloKb1cC2XWQjQMTwbKgSAWwGgkj0S1rHlBKtBEIgQdL5P+IwzPxL6elBJb3bj02bgiRKNyPXl3hLPeJ6aIS/tV3NcD83SOBmA0WcZOpaarv9utWbomNQIE4K6SfkS8Ig0Wgkz4sJujEGkrEPav57LcVJ+Vmx180Nbxk9Up9Y/4HC1cUOTrlKy8jsAQHH2eqesXcrUiHJuPWEBNhje4AElaNBfpnDsHi13400ndn7CpGmZVjBhM79LF4uYCqtylOw3knSZ7FIK88WOky1muHZnNf2qceuVh6stgB9QLAvBgXNROZQFvVMhKflZtqltuV8/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThGxTVdur0prdxuBD50+e15CEqyoNjRvsm9nQ3SZEKc=;
 b=FTV7nUfLxkYS5NMkW7y1KbRA+PsXYiF0LWpNex5r9rz0nljRHE+7zjiqFSFvcSDmYmhzGW7Y0EML54WA5stNaGgxIH00d5aHmhBl6pYz6p3WizfY1P+AX2LKvlDRWWU4/Rn0/VXNpgGJFPWS1jCeTy2BMRjbHuG6LfwuHQWrvzjRlfd2/Cck1z96jbU3VL8+3RuVrKfKRaXpquyhhyS3P6RLjRpXwfRBvJt2PKt9k+mIZ2LlRPsV/Eh3ERDgCzn589IRMGlNmJckgAhsHLBGRpTVf6x/lPuJ4L7k/UcTwT0uiX3OzCWn2K+kSdYyT12WHy7W40K6ghyREkiu7q7NIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThGxTVdur0prdxuBD50+e15CEqyoNjRvsm9nQ3SZEKc=;
 b=Cf7HI0e/MDyMv3VQGqULcV1RKLcWgWpoPFq5ISEMa5/snAoVmjeLZ2xAfqmnupbP9+aqcyMCMBZaXSjk+YJtF/+nkedIp+njs9JJrqo9WjdIB1BPWxrmk87c0gSujyissxfcz3PpYodHZsXT/xWxdBqmLY5LLLYvqbVfhAVHLWA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Sun, 3 Oct
 2021 21:07:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Sun, 3 Oct 2021
 21:07:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] dsa: tag_dsa: Fix mask for trunked packets
Thread-Topic: [PATCH net] dsa: tag_dsa: Fix mask for trunked packets
Thread-Index: AQHXuG58gcBKZ6Yc8EOaSL5Ea6OiNavBxHYA
Date:   Sun, 3 Oct 2021 21:07:24 +0000
Message-ID: <20211003210724.72ns3bi775swppox@skbuf>
References: <20211003155053.2241209-1-andrew@lunn.ch>
In-Reply-To: <20211003155053.2241209-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d606194c-151f-4a01-67bb-08d986b1cca5
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB4816AA25F6D84BD905B17AA7E0AD9@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Qp5IYQ/beeztsy9JodqZH5Ky38P5/GgPJEVnLqCPEkvUdYk9Zt+8BD5mQ9YyDfp36T2sydvAdIOZGggusCa48/BDbET0i6GbE/RcE9PaULxxHvO8xNxOSRIJ9eluZDFC9vkkW7ePSQ+nYz/FTNOuAsAguwZHA3tCGWpMhgVONPtCSy+6V3hM2sBue/L9pBJVFdUaMVSUH+6Qf4RW5ZpJfI+ZgRjnLerV+gmUeK5Uijtp2o9yzLPKMOFh+tv6iFL5ihKvtCuIhghH3OcvHuuYndkwVT2h7ca9bkOMTATIDwPAsLkqCDE96BpKsv3Sps/qi0PPpgGHP5QMeDAEB/XGVFwIXHUjpIC/6OhM++aVSv2bVGEU2Zb5z9KNwCCQNA/Vs6Ppy1yO7PFFYjTb2ujSIXVTB+ACg0MkbmW1s/bjwy2OMy87tX/SnjrbsSSPL00wnSB1qfbCJ7yiifsarXZnkQD0eAGH49TbJUClftC+QLZAEAiRN8a1aerprSP/ilqVw/Vmzl3j2FaFlYq3xRSbMDGJ721kJLw8f1utWFZzHgwG0hjxHKb69iBQUbHtw5NOoBb+OITJT7qXqPlb1DA6LY0nLgOMH7ecrwXtgZhbIdB4RWUFuqGUhc0Eqn860fgmFBWkHMfM25V0CYtIyVCmSjOYQOIPzcCguowN4P6Q8DsNsKiufzKbM/ZMqLL3p45y1MbRG67aMkcTtnENYbqFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(38070700005)(4326008)(54906003)(5660300002)(8676002)(186003)(6486002)(71200400001)(8936002)(2906002)(6916009)(86362001)(33716001)(1076003)(508600001)(38100700002)(44832011)(6512007)(66446008)(122000001)(66556008)(64756008)(6506007)(9686003)(4744005)(91956017)(66946007)(76116006)(66476007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uF8ucD6QNJ7vjPc/zhFQD2rIHNBrgua47JG89Lf916Yy+tpA36W6wqTa0r6a?=
 =?us-ascii?Q?ncftmE++uJjirnB2jxc5imF43mWp+6sejl4IEMWndaA1uVOU0kjGAFu8ml0n?=
 =?us-ascii?Q?UO8IFzkgD1KQNtfnUN7/7S0L+ppP4bv+o0dnOF4rX/3Z2Fc2jNbWJoCKjjYj?=
 =?us-ascii?Q?adoGM3/svGUxGibss45YX2RCwvqbPoSFKXbCBvQkkGrjzlb/YSgua82NUdNS?=
 =?us-ascii?Q?g4qH7DeByuZpobIyfTdhy1BrcsRVcD2ORQuChzs9upV84WM9mADSC8O7sfG/?=
 =?us-ascii?Q?4M9Iq3XJGnFh6DZga/shKuZdMwOxvlLjqWtnbszAiO+NThQrDJcJXAeXtcfO?=
 =?us-ascii?Q?LZlK3XxVYqJnZWKppzkqL0kMM8jineLO/r5DAyT1CGa4sw/xAwwPcUMG9rdA?=
 =?us-ascii?Q?+NyjsmWF8z6yTifIKhgWZGs3XFbFqWhL34b5cDPbVAVwFr4MGp6QoiB09mTq?=
 =?us-ascii?Q?ME0eWSQgSvFYcQPbVmZ34VG2FCCaRBtUkvwjNwn0x/bW64CLQBPqsEeeh5Zd?=
 =?us-ascii?Q?NEEZapnmvlvLo9vBqvRzGFZiUjuUgfbo5b99qI2sGbLL4idtjkn/eD2Cmbyj?=
 =?us-ascii?Q?IvLBv3vhlBTD+FcxpHlnNCDoWP8Coo+K7HC4hgYpubp1E+4/j4L6CvPVhiSw?=
 =?us-ascii?Q?sPty7e7CI7AqDBC9VJNfMDw0E402WB7MA0MFd2H9pGSHDQImSJU50+11CHYQ?=
 =?us-ascii?Q?UEtPLTS2Ns5Iv0zpk+Z7hRB19IZMDu766y6wkXltyzEZci4RGtZlgEcGKAvs?=
 =?us-ascii?Q?1FhtxGQQQBIEWdtm8xI8yUq6XqqFYzl5vBOgvFs3vft7IkTGZ6v9m6xYiBFL?=
 =?us-ascii?Q?/mhigi23XecexEC+OVzhH/nsL70+OZq0wWXX+UKEeWpsyPY4Vh77lPCiPWW5?=
 =?us-ascii?Q?OtcFTnhLFflv9EqvugLVc0ZsR/hjXSW/a8FWDmjnFkHgD3kXesiDpKVM2ztU?=
 =?us-ascii?Q?IckUUWK7l60VrCKxIQjN76CurXMj1UIclXef3geuQu13OaaJjS/2um6A+ATI?=
 =?us-ascii?Q?WW/87cfyzz7TwGaK5pwD1azxugljEqJahnKf0YcGi1IdlO6ojHanQuaWWJj8?=
 =?us-ascii?Q?fIoSNuPPp/c+LLH5p6eA7jJe6FKRWrVYYuzEcLjsuotbOmewApjOGd18cANu?=
 =?us-ascii?Q?iwBkeazDpsy+dWorPipLA45fR2tagUM17KgQ6VDcw79UC0xFkRf8NITmqVyI?=
 =?us-ascii?Q?PEWnEyPWY86ZR87hUfjXYiHwcysmPw9UgzKOin0N6PttPpzsF7rtzVt70SK6?=
 =?us-ascii?Q?D3yduHNmFAyw3dovB3gaUtdUdRti5heEJBe6Zv4jghjcqUXmbi3gvxIpTA1h?=
 =?us-ascii?Q?AorgNXL92E9jF61iNBDhH4y8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C87A3B429B68F94B9AA19ABDE393FA6A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d606194c-151f-4a01-67bb-08d986b1cca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 21:07:24.9631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7gVtCPWRwf2T+LTJ9oSOSWvqM4JnCMbawVezX0lk/3pkGWMYSbpvUo/2VJ90IIWYu8PyO3U+E3ilZ5/f/QxvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 03, 2021 at 05:50:53PM +0200, Andrew Lunn wrote:
> A packet received on a trunk will have bit 2 set in Forward DSA tagged
> frame. Bit 1 can be either 0 or 1 and is otherwise undefined and bit 0
> indicates the frame CFI. Masking with 7 thus results in frames as
> being identified as being from a trunk when in fact they are not. Fix
> the mask to just look at bit 2.
>=20
> Fixes: 5b60dadb71db ("net: dsa: tag_dsa: Support reception of packets fro=
m LAG devices")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

At least this appears correct on 88E6096/97, but I would expect it to be
true for the entire family.

Would like to hear Tobias' feedback too, though.=
