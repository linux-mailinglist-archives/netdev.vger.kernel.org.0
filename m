Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A766E41C5FE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344355AbhI2Nsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:48:36 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:47122
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344359AbhI2Nsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:48:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7CMuPPhudrKG42bzfH+GB6TlJTxdUmLkGrVyKiB3h/yeTQ78Fr7gy2i6/t6+P2hE/vEiDzU4Uv+fWoXO1H3rEFOIPhb+eRRWOZ9k3kbs/5N7+exEugr49P1K34IOdpjPmZ/Vhq3ZN3DsoTXphJNIJS1T8KtS0SLlKAmCMMfkdv/6QBsD9wcx3cK6vfMiB8IgEg23PZqqAacPN19yTYz928pdrl0GZ7/rq39EeFLSEqod4SEG+crNWH3d9qihBoe6sxvjTs8lX4e9hCFQGl0U+SyKh/ZQDQqOrwgIJNOgCZNyo4vIKBimYOk33ED+iYG1zaqJWO8uHIl/iqIC4beTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=V1XmirgrOSG9zjWgfeKj5xUFnjz6cQiB4U+Bc1fZpc4=;
 b=RRvcfmFq7sMzxgu+CNCjpBprn882uXXb/yhEtlAlktjSaHDZVFdDPPPlZhvHyqL+imkTkeNW+45wdRbvsWOeJLC80RD1HqBe4izgVUOwERuphLTX38/gQpimKTM5FoW/F8MTpgiLJxNXCvtO1/SS5i4eIOYXI+nsgMNTl/SAMabLABEWn+jqSa006v52Q2EOVd9SsctNYa2YfHo+dDjr7vFpBtDAh5nZLY6cwjo+596ac1Ibv0Oh0QNUVvPiDTkwcAClSFE2SjkNcW4KpWPFrIQBGzl1Q8jv+tNo+9auCtdkahmhevPo09+s6QYu28x/b0WnGxhpMvsLaKiaBGOnlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1XmirgrOSG9zjWgfeKj5xUFnjz6cQiB4U+Bc1fZpc4=;
 b=KQr/cgauaLYCZ7tp6DKzj4Qaq+x+hI7+p3iuzHDKdv8IQFb7c6QanjIQGmm/Nma1nM7dnMkNZLFtzcLoMgbc/1x+EuDPtQdY3nN4Ck5ruayHg6AX+VKUbHYW/P/6nmIByNnr0ePhszc4d02764KfXiBUWvbItvwLHs30UWgilbE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 13:46:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 13:46:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1 0/5] Devlink reload and missed notifications
 fix
Thread-Topic: [PATCH net-next v1 0/5] Devlink reload and missed notifications
 fix
Thread-Index: AQHXtSmnzeYCAA/7lEWpi1Kvh7cE5au7BLAAgAAB1YA=
Date:   Wed, 29 Sep 2021 13:46:38 +0000
Message-ID: <20210929134637.4wlbd5ehbgc55cuo@skbuf>
References: <cover.1632916329.git.leonro@nvidia.com>
 <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210929064004.3172946e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3d5af6b-578c-4d32-6008-08d9834f8fbb
x-ms-traffictypediagnostic: VI1PR0402MB3407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3407A6AA7CC2BF25D00528F1E0A99@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: erLOUqfR55I2fUoT9CHt2JqBo5vJjOwZ8VeGZZK+NaONvvGSNzfIGSoBw0ucytuXPPuoG9trZqWpbR1EsTf50GpGFFUDJ+dn9PJv5Wun8UpA8wHMsiSREjsccy/g7UeG4UJ1QebPndsIkZphKHphJVu2MK16T2x8+pFs+IYtBFdEQLBNZ/5C75kS2tlPD3VTy0ylXPte/9/jMVUIFI6DYng1vsJr+UM3Ok/7Vh2KLtjZyFtN+kXcRihbnju6OCbytLX6cxG5lV1X/JKY8gwJqSgzFqfG+ltWo3thEojyh2WQlda8j3Sqon5NMjhrC2otRxR6zpRpkV7Y0XsV0FsUJy3IpStM4p2F1+1DKyuspZpADQKiiBTQQcboKc6gIPcnxEycEvHk/H5oebOlJgzzRjrf6VYaLPVlR32ee69CnAKA++aqW5wavvtYfN6jZjMsnJdA74ZO+8O48Gp+4SYesXnRIsihYPwbrOJi8q9OVZxP2dQ2CrwsfmVz0RkKBEBE3Db1Y2Y/qmxj8I19eswI78BNJbctpakYsmwRrfX0gPlSjLIqqaFfVQ9erua+rFxPhqG2a3T7+YfYr86FOgIihMTPj0NiL4YoH5BGCBKkb+YpZmeHtkw1StTASsfLpch3IYzIyNJvdg7XNOG4NCxbjer/YPRYLlr7RJRVrrsEHfiY9lbPlwqQdgK15Hb8HjGs4BX3A98pdpTvRRJ/oGgjPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(54906003)(26005)(122000001)(4326008)(15650500001)(38100700002)(71200400001)(76116006)(6512007)(38070700005)(6486002)(8936002)(2906002)(64756008)(66556008)(66476007)(91956017)(66446008)(6506007)(8676002)(316002)(44832011)(66946007)(5660300002)(86362001)(83380400001)(7406005)(7366002)(9686003)(7416002)(33716001)(186003)(508600001)(1076003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1rTGdkzSXAUKcbgQJGuNfH2lTN0m2mhzrkQ0TR/YEQkl6S8XmS2CQNbFiNIq?=
 =?us-ascii?Q?WigOEwNlyv/8dSNEmqPymVKw2HbYE3jFOMQa38yFlU3Q5p90PYybJtKj7/ai?=
 =?us-ascii?Q?dCJBFxKPap3vzf1HpnuZxa81Wu6ziz8P08oP8ZnvjoaBiFoMy3/MNspbTewy?=
 =?us-ascii?Q?2bKqMP9a1nl28eAAZPp0mH6T5OHzWfS5gBsUnTAX5paDHj3DzLQ1L1nZPRDC?=
 =?us-ascii?Q?zfvo6qZJ/EwpG8E6o6w4muxmUCV5wqtzgX0U8ZOVjspuHM9okMa84iDNmlPA?=
 =?us-ascii?Q?/IUG9Vwtcltpj4dJdZyPnHF1ve9SgA0trNV7HTsmzW4Ko68WcGStI30YOVgY?=
 =?us-ascii?Q?IqMRTQyYqyobUZ2VrV14cu47AiG+uzyYJI/epW4CC9yi9bZfPQpty/z9st24?=
 =?us-ascii?Q?gNGrkVW4qmcOBNNAmUBmOKbK0zaKBGliqBcaa50oOezaQK1aNdbWF5EE1kIP?=
 =?us-ascii?Q?SENuexBOHjpuwITiA7RmMX4KSoLNwRotOhys8eyqiRXm5kEnikrOPEx0YOM/?=
 =?us-ascii?Q?WjUD9G7bNEPrJbL6zfQ6Dt+z/j5xkchJ9IIgpfTRQglcWLHkSEXvgne7iUnr?=
 =?us-ascii?Q?V+R+5s9FUcHGfkR4BkhCPifcNZJlwY3PR/0e4eV1rmmOBv+Wh/aAUf91pGE0?=
 =?us-ascii?Q?tDHNgPtLXNGqeQc9mTDIo1+WzOOocfdQ0ffPrciVzpMK8gOjFX6XGelXiO6I?=
 =?us-ascii?Q?UIBb4gNINVJlyUNmdZt2i0dDi6Dlw2mVB1XVDpuZxbuwggpMnBAXKZApfUmI?=
 =?us-ascii?Q?ikDONDAJ7l+Q4PGleAj3BsUyD3V/fPK0gt7/2Puz6GLSunWoOzyxdK2AyJBy?=
 =?us-ascii?Q?6ijXcDsFOJvf4ckjpuo+6Nb0vQccouCJw42I3wDjhE5TfAtVUfp5IjM0bJhM?=
 =?us-ascii?Q?igqg1GPm41d9Y9DMp1V4fbVjyTWNZL6AYj5wt7wrSb6tpKVIW+R467ZbJ1F/?=
 =?us-ascii?Q?lP7lE2D3b2QwWrLXVvFg0XVkvd3uIWmJBv6HzzYo3DC2kZQaCsYB0qSo8FIn?=
 =?us-ascii?Q?1OsP8AN/tJD0lyhjWTEF1hIUNHOiK6jCigC8MCUyWWyRzSVFTdMpdf2HlSXg?=
 =?us-ascii?Q?uQNmBRT1BiK3uwX2HAJ62LAxIWVIRhXNjNMg4BjzBvNdl3C+mcPXQtIZ4tyL?=
 =?us-ascii?Q?4qqpEihff2tNomBlC3GkRfbsLuMzLgX0Ox8f/4+ZxiPxofM8HcrvmPBms7qV?=
 =?us-ascii?Q?MI7zC9h+e4XaNJoDi2e6BKbabxzoSbxbpame/N47t8ZnOFayY2z228jyw26N?=
 =?us-ascii?Q?LSauSTvDVR70I1dQ5EJMCisQm+1n7I2YS2ngsGJPWNsmq7Z9gYzwbN5iI7zU?=
 =?us-ascii?Q?jmRQmES0+p1ouIHi+4f4geGUiOm1PVtkPUn5g1AJrZuvzA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <06867A5915F0EF4D959157776A11D02D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d5af6b-578c-4d32-6008-08d9834f8fbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 13:46:38.5643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3uHaOH/HIMiCzwWZvcn+Zia/azTUVQdXMb4r9zybIbo69qDBkMZEqEIZsTzJj9UuLqPSvoGMlyxTRnhDb9rfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 06:40:04AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 15:00:41 +0300 Leon Romanovsky wrote:
> > This series starts from the fixing the bug introduced by implementing
> > devlink delayed notifications logic, where I missed some of the
> > notifications functions.
> >
> > The rest series provides a way to dynamically set devlink ops that is
> > needed for mlx5 multiport device and starts cleanup by removing
> > not-needed logic.
> >
> > In the next series, we will delete various publish API, drop general
> > lock, annotate the code and rework logic around devlink->lock.
> >
> > All this is possible because driver initialization is separated from th=
e
> > user input now.
>
> Swapping ops is a nasty hack in my book.
>
> And all that to avoid having two op structures in one driver.
> Or to avoid having counters which are always 0?
>
> Sorry, at the very least you need better explanation for this.

Leon, while the discussion about this unfolds, can you please repost
patch 1 separately? :)
Thanks.=
