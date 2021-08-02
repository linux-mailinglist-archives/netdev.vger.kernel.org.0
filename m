Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE36B3DDDCA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhHBQf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:35:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230139AbhHBQf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:35:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172GUNSS007186;
        Mon, 2 Aug 2021 09:35:42 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a6265332r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 09:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKu1CYunTkf7+pkp3M976vKa58lRB8HA9jR1s4f1DJVYSOjdJT7Tmh0YcE8gBYV7HD7mA8HFbuPY7/he0sDErH9pgv2nod7rtZBGO6pS5FyhDnPWuQ89Ov0ZqKNTd8ddcpFdGwm5vb1HUJL6OV1IRXoGG+z3hhpqkf3wjjSGImgCTCOwVXLnuC3rEWhXPMhdErnzkT2henw3P5Y9fzNuMVaLWkcCCSNgHeC9Zkkkh95PrvXek7q/eWiF32+hFvI8/YL7JLa3A/rRmZTm1apw8b/jPoN9Us5glsKlJRe0dVsbbhpMXGBwOkrKZZhRuUMMlOLIo8fRWChMaEakZi5t2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aqn/GgO4sjqodFwoIqRzBPmLwSWUto1BpH6b/fe8NME=;
 b=OO9YYU2616bl8OXBqleelvc7MAcIt0VRF7QW7CdydJsnbnTlxg1P+lo8uO9w+hxR9HUte5toaxDDeCkhO1TkXbYpzFbn5IcyEC+xVGzzUgUZWfRe2CyTNHkG9QItFAyJl2teLHWbpCC6gpH5QoIs/33dIeROjeukYp6J8GvwoE5qsfpsx1MF/ObmynyCPn/dS9MkROrsrnjWmsTV50uWOez+qqzG2Nbx7qOZz3HIlA5B8tyEa99qPVqukCF6f4zOgEYT0sLs2ZU4luA29c6BiPiAJ6fu0l6qo551Eo853HoHIBEP2qPLUyrwWzN6lQJ3XVb9ViDI9DGNw1oEGMYBMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aqn/GgO4sjqodFwoIqRzBPmLwSWUto1BpH6b/fe8NME=;
 b=pQD++wgZD4xS6Wi/TaPICZV36/nMIaWjfu4JWHphQOhDeOjgGjeJD5jHnS4c25ipd/0ExF1KOBC4lEuGBa77J6U5BuZia04IdAeUFiBK48a1pxhdPswoWPupm10CIaKpjOTp0kPkqDGXgNlPfthxqgVze8Mrk87mMIkl1B/F2HE=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB3064.namprd18.prod.outlook.com (2603:10b6:a03:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 16:35:40 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 16:35:40 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: Re: [PATCH 42/64] net: qede: Use memset_after() for counters
Thread-Topic: [PATCH 42/64] net: qede: Use memset_after() for counters
Thread-Index: AdeHu2WnTRdoaKwFSqaAMCIXmimw8Q==
Date:   Mon, 2 Aug 2021 16:35:39 +0000
Message-ID: <SJ0PR18MB3882AB903407280EB87DFF5FCCEF9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84e4bf04-176d-4a11-a847-08d955d39087
x-ms-traffictypediagnostic: BYAPR18MB3064:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB3064A6F0307B253297413C61CCEF9@BYAPR18MB3064.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1zOZggx0KKdCkGkvPxFUwoiriex9E5a+Cwn6R0ed5hilD/gsN2i9C3dfhnleTawIMOkPLItqATHYfmMamlDC5keJndVm0DEFc/zak+6ctgQswwY7uBpJqiTqYwaq8TkzARjikZPCOJ9zDe0idEQrb1/RQZCPZyPNhdIhnGozzBazHYpXVarnbwSkhlHkiFdmk4xyUYKgjJNm1GpnIAcdJj2NQsTqeAfNkNbP6r5MXrHrqBy5nd0d7pYlvWNk25GNqj7pWdtrFdCnYyER2KTWmPhRvnDLWbHADLJ4cfQEbnuC+tufTziywbidBWmY8mOzAt6ofZK656Eld5pO2RsDE10PKwtb6YGUsT5RtQxKoWXWiyy/SLmHH2eCMH3gLzdECSQc6vVaeJQBqs1MEBDqf4+PRUolgVsftzTT3MdCPYyiOqDiifSOTcMc8j5EA6u5EX9d07MBj0p2p8ocv5Ku6bBKLryHuzHHoEfFiaY0DmZwUdhhZyYPCvmjgzH3cF0dfHkhRPR3+FODgE44HKBgYQ8aLni4IzMtJQBbnkl8peUb8q26RFqbGQ3XsbWBZaQDNcNU37ntn0m8uuJ76R9m0w8GNK1QoqZlsiDpon+Y8BYXSZEbjtlFE5MOvJ2c7D+RP0VxoWtva29N9Min69xXgh7PgWg9PH3mTPn7fM39DzLlqEw/uvSg0kTldscoyW9xZXqteYZ2Jdr19HFmTWkcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(26005)(8676002)(8936002)(186003)(66446008)(64756008)(66556008)(66946007)(66476007)(6506007)(5660300002)(2906002)(52536014)(38070700005)(9686003)(316002)(7696005)(54906003)(38100700002)(122000001)(55016002)(478600001)(4326008)(76116006)(6916009)(107886003)(86362001)(83380400001)(71200400001)(7416002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0aGPhJtrEbsiGt50IbhEOw44CngPsjfqoA2FpWc88KXgacu96/Ti+zkGTXwu?=
 =?us-ascii?Q?oyAO1aHeW2l8299+xy0TuStZ9uXLP5quDTmVT4jHlgJaaceaJSjsPSayvOaX?=
 =?us-ascii?Q?/mIfPkZxQ4YkogVI0aZ49xeRFs6LtTg9a9binCEODPVJZsRtMfbs0tm9QWqf?=
 =?us-ascii?Q?IuYXGjFduw89ErHt14KcFkLdQdgbpPPKchM+gru9LkS8cfVo6QJQWr3WGaw0?=
 =?us-ascii?Q?S+qwPaxSc5TuhG87ZMRbpR5xOQp70mUJYzfWhzPqsMvFYbLQ1gXcQ52dmlV0?=
 =?us-ascii?Q?mfoqbSXOraVHLUZKxsCyCR+PBshaVfocZldRTy2kqCX5vCXa+08bgP43/cnF?=
 =?us-ascii?Q?Em0QiO1W+otbj6T9NY3h5dNOL1DCojNCAMeA3JvWHXVOjStVcsTEYrIcRQ8F?=
 =?us-ascii?Q?w85fYHf0vHENrUh8bdRxShEKe5pPqiB8UjvrR9sxpL/kr1s4QvWSq7Dl4zSm?=
 =?us-ascii?Q?C97rnA3d0SuI4A8nGsQRZ6l6RnTJPitvtkmJQbwcVJdzrVGQsJOiIBLmWB0J?=
 =?us-ascii?Q?N9czFcyHjj4ioO9fwd1jGZMsZPMXNNzfI6eVFC3YVdeyPJFMd2JPDmi1+wle?=
 =?us-ascii?Q?m1kvTLcyN5ZKHu/yadWP5CB7WZyjlmcT8MbZekapmPXExhmcWsyNLPxU4+Z6?=
 =?us-ascii?Q?pDqMEnUPDtmgVGd3YlL2oBEC6+emVjufhLw47iPiLE+ihBLvTGsJnfgiYEv4?=
 =?us-ascii?Q?88hL9MfJW3bfnP5f67Ac0vrlfaJlGNiSaF9XwWNWRH9crmvuN4qp6YOANb2D?=
 =?us-ascii?Q?Gabbi5lzEoTW/UIuRob14zdfLj+RejZRJ7mBK2Dys/rDg6MtY6+d9r2lXAc3?=
 =?us-ascii?Q?mujNkDSc4E8pqeXvnUvG2ptbLz5H9SlM1krW70VNbhC6pYC12SOLzdZP8WMJ?=
 =?us-ascii?Q?XknpYGmhVk8ZpiAE5nlSKN9svaUfLmvtOrbL9fh4ATAQw6ghHXjfItE31KFv?=
 =?us-ascii?Q?EL0gwV5g2qG7+PwegYegp9qgaDOb9BCCUPYQcn1OuQ3ZRDAqcLvYqYDXJ101?=
 =?us-ascii?Q?LaaMI6hWJxQDfGT5O7vg8bBj0oet3yinEeqpp3+h9naFc5/4Jzs3B9wxaxzd?=
 =?us-ascii?Q?EQk5EqVYC0bihbq4OSmfJFWtl0in4BIerfCQug9pmyu6f/7jC4hnPtWh67z1?=
 =?us-ascii?Q?T+BuN3DPkS40vKMdQqFoF0SASHC1QibhrDMAClfJQiqHqDSyn+K7H5W5P1fE?=
 =?us-ascii?Q?5GY1ZA7J7SfQmGOxdkppJ+yBKo1RUgAlenFiuXhWxWyEmTp+vo521T8KOCmN?=
 =?us-ascii?Q?m7Mm0A1UJdda0UHEvzYpqZjfRQl1ZVIhLzaP506AX+J/zaiNXlZuaNQXfEl3?=
 =?us-ascii?Q?pfA/qmJ7mVhEOZHZJU5kYxQN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e4bf04-176d-4a11-a847-08d955d39087
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 16:35:39.9870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UySO1HYRFB5385NWKQM8f4ddgP+fe/cT2PwmeTem7EtVvOADGIf5EU2cnh34qgpNuxixoNQd5H0ugPhHMj1SkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3064
X-Proofpoint-ORIG-GUID: 5FxVOV93Oc6wFh5q-ZaL3krJVytn8HZK
X-Proofpoint-GUID: 5FxVOV93Oc6wFh5q-ZaL3krJVytn8HZK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-02_07:2021-08-02,2021-08-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 07:23:00PM +0300, Kees Cook wrote:
> On Mon, Aug 02, 2021 at 02:29:28PM +0000, Shai Malin wrote:
> > On Tue, Jul 31, 2021 at 07:07:00PM -0300, Kees Cook wrote:
> > > On Tue, Jul 27, 2021 at 01:58:33PM -0700, Kees Cook wrote:
> > > > In preparation for FORTIFY_SOURCE performing compile-time and run-t=
ime
> > > > field bounds checking for memset(), avoid intentionally writing acr=
oss
> > > > neighboring fields.
> > > >
> > > > Use memset_after() so memset() doesn't get confused about writing
> > > > beyond the destination member that is intended to be the starting p=
oint
> > > > of zeroing through the end of the struct.
> > > >
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > > The old code seems to be doing the wrong thing: starting from not t=
he
> > > > first member, but sized for the whole struct. Which is correct?
> > >
> > > Quick ping on this question.
> > >
> > > The old code seems to be doing the wrong thing: it starts from the se=
cond
> > > member and writes beyond int_info, clobbering qede_lock:
> >
> > Thanks for highlighting the problem, but actually, the memset is redund=
ant.
> > We will remove it so the change will not be needed.
> >
> > >
> > > struct qede_dev {
> > >         ...
> > >         struct qed_int_info             int_info;
> > >
> > >         /* Smaller private variant of the RTNL lock */
> > >         struct mutex                    qede_lock;
> > >         ...
> > >
> > >
> > > struct qed_int_info {
> > >         struct msix_entry       *msix;
> > >         u8                      msix_cnt;
> > >
> > >         /* This should be updated by the protocol driver */
> > >         u8                      used_cnt;
> > > };
> > >
> > > Should this also clear the "msix" member, or should this not write
> > > beyond int_info? This patch does the latter.
> >
> > It should clear only the msix_cnt, no need to clear the entire
> > qed_int_info structure.
>=20
> Should used_cnt be cleared too? It is currently. Better yet, what patch
> do you suggest I replace this proposed one with? :)

In qede_sync_free_irqs(), just after:
  edev->int_info.used_cnt =3D 0;
Please add:
  edev->int_info.msix_cnt =3D 0;

Thanks!

>=20
> Thanks for looking at this!
>=20
> -Kees
>=20
> --
> Kees Cook
