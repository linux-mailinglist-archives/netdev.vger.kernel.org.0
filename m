Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C653B457D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhFYO0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 10:26:51 -0400
Received: from mail-eopbgr1400091.outbound.protection.outlook.com ([40.107.140.91]:35450
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229573AbhFYO0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 10:26:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5jRApj70VE2Gjz2brDDMzc3D44fTa+k03ubJI28+9GzUxWwChx6a+/KM5Et4hE04j7qnhybe0y6m3pozUAvKKP2/dhGTv390ts/gkKNvU3g+Fgf067e7/D22rOegH9fYFSAIBIirpbdPdvh7RjJHAq+Z0/mDrKQtKRVq/fjHnbaRJM59S6JnMx/hd7rONHlrmFSUjxhLpDd72RUXjFZ7bMre86hVZPb8SDVYQOTYx2AgNCnaEyX3W8SU2RtGhE7ujDUiIKU/Ir5bcgZf4cigX/ZGTTrfZgKF9ByKAy+Dbp7bskHJm36R1QeShbnVabscGIEgJFoLehFfusLDg+bJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/SEv4CUJiSIMalJ5QtB1YgScicb8dQk1PbJrik9TV4=;
 b=aExLK5lT4PbEBBvjQ2yqrWK28EhoVgB4kMWQcgmI4zI4KDMzogyo665d86nbNuFkWo1c62qzp9GlNhXLPPsVA7NkqXh3NVE1JuetaS/UWYb13Kc5oeZFgomF98iIKnt+j6eOuGnf2GIPXJgwW47SDaaylu/9zo+v51rpkfqIqmoxg3Qa2M04ikzeBdrtnpNQgbdUgXiAln1WdQSMPVG7XybHAfej23EJD4IsTVDBfXqalg/HZxbX8gPuIeNe/PL3rpuB9HDFZk2NRVImfHRKATescMfLKtLDHIUk9EKa/njX8ugfHkA18iX2s+3K0UoDek1XlwuvE+JRLeXyIXclWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/SEv4CUJiSIMalJ5QtB1YgScicb8dQk1PbJrik9TV4=;
 b=Gaffhvi4FFgL7PKgr9x4g0dTzNZrP/qqmKR+9/0atHxcuqcd85xS/o6kM3hSNGEpa7RLHcgS3aLkd5B//h5JHAmXSE4aQvoEUOWp2G03EN7daWytH4Vg7jmB6+AE9Hs0IoMJP4ZI6j98pDL5j2FjsX4k+N4HmJ78C8ZoKSpKzmU=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSAPR01MB4643.jpnprd01.prod.outlook.com (2603:1096:604:36::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.22; Fri, 25 Jun
 2021 14:24:25 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b%8]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 14:24:24 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Topic: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Thread-Index: AQHXaD6QH3kS+d8DxUyFpooG2wAFo6sihNkAgAC1sPCAAB6rgIABcPxg
Date:   Fri, 25 Jun 2021 14:24:24 +0000
Message-ID: <OS3PR01MB6593FC9D6C4C6FE67205DC69BA069@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <20210624034026.GA6853@hoboy.vegasvil.org>
 <OS3PR01MB6593D3DCF7CE756E260548B3BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210624162029.GE15473@hoboy.vegasvil.org>
In-Reply-To: <20210624162029.GE15473@hoboy.vegasvil.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da8765a0-3011-42e6-0f23-08d937e4eee7
x-ms-traffictypediagnostic: OSAPR01MB4643:
x-microsoft-antispam-prvs: <OSAPR01MB464368A71C444A59EA315854BA069@OSAPR01MB4643.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8h5nmk7HYfQqvrMGs5Vwf7Vvte6MbemsyEvO/O8v/ijA1VYifmPOu97sgq43CrbznRiNWTB5AMHt23hA43I733qLP5WfI/ereL03lqRONbjL0XK6Z/ZjPKRhzwNcPehdndp1SVrNt6CeKjjwVDuOLM3sEgOiFzNsc5YJEOCKUjIOf1Yypyx2jEcGNMv8fwHLO4C5186HDAMNyM5qewHywZ2U1zLqGaSAjr37GUxUPX7pULrqdFj8Y25qrwdM3ICEGtsujox1Cz/3M037/OoQ+UPU1qsn5CAQCQ2S8mD3NzXFYDSq5PKt3Gy2nFi5m+MkZPpFw5lULUVcBIgN0XGPWRyFRDcC92mRPdCYMR5xNL48PcXkDkdO29C5/j9pipKs8QfD4ZgX2hC19gP4762j4+TrguSTET0lY6YC6ByMeFZ92DPJgCOgf5qz1XcbP/quaVS/DNUtplFPjsnpZTuLcexlJHcZImvkYfl+V+/2uSZEqd/dqhre1eR8ytbTW9wR4CZqqv1IWt9UtLdFYXJ77zvbLWGY3/FQ8joVINEnLITKhsJU/RK4HOrEdtlwCHBCYAaZ5cBQczgW+HX0i9YOKJ2PICTzPvwDR1fU01+Kzv65V6QyGCmhBqN8WvGm1NXsGtxyRIOJIUbwqzgO//k4lQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(9686003)(66446008)(7696005)(186003)(55016002)(8936002)(2906002)(66556008)(122000001)(6506007)(71200400001)(53546011)(8676002)(6916009)(86362001)(66476007)(478600001)(26005)(66946007)(33656002)(64756008)(38100700002)(5660300002)(83380400001)(4326008)(316002)(76116006)(54906003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m6DGvow6CDRw+Wdb6023ZUWzYGDLffLySzEAX66jUoReSindcmxyh28YLXO7?=
 =?us-ascii?Q?jof9U0q2XbdGL/aZaTzNpbAEzx2I0C8yrE09+odkqbAJAq6XCYsrDfge5LmD?=
 =?us-ascii?Q?gVGMx4Tt4+AOpbRT2ZenpojFVP+lSRztMQvnXCz4HeILJVmxESOMyhmzBFgV?=
 =?us-ascii?Q?6eWaEFdW8UIvSMpi73n/rTSt3/bM39DOi+AnTk+MeCd5FKVY5LGDNwoVmTK9?=
 =?us-ascii?Q?GWOuEk4hc28pbpOBTmIDPwqX6P0x9jmQ1xycKOiDP157LIU241MFDv6TcFO/?=
 =?us-ascii?Q?hlo5Dw8GXyenHVfbOx0fLQwiknvPajW7TTA5A1X62+rxnrnDsBx7odKtavKE?=
 =?us-ascii?Q?glpLB7CCqScjW9VZY0o16IrHmtCRb6O/sC7OaVxEOVwHxxfS5P3KpUqC02xo?=
 =?us-ascii?Q?7dMx5d5wvwxX0paN6KcxSY0+agyb/9I/zXEKWRhVh44LKAoGEjMuUx2LxiiL?=
 =?us-ascii?Q?viKWR6Plti4V4MD6jjUe5KoAOYlp7me6ccvlTAZHcmEHvK2KqBsBi8yaB62n?=
 =?us-ascii?Q?/o9+W6gZN+4mE36lXYll0/p5xNSSw6Gd//SC1XHIYdsTJsJz7klXW9nfwaK9?=
 =?us-ascii?Q?igvUu062acVVAlR6OKuTeoK5ldb33g4P96GJ1szQ0y03kfKt//ADv2WjQL8N?=
 =?us-ascii?Q?7tLTphhl4Cq9dWyXa9NfZZzsldUEkJvH+DfOqqwOESg7A6CsxP+dQYUHEvwk?=
 =?us-ascii?Q?o4LQX/1SyeZSl7JJyJYCMj/Ii2OQIn7as+BwOnWntZwwTvyCeNDbauBfhtDn?=
 =?us-ascii?Q?XpnoPirl74k0GnlVS3WKxPpCHgAS7QC0Z8U+T4k9SQiss1Cv+6zdxa6T2MWy?=
 =?us-ascii?Q?RQ1gi2lZl/Y9F4FtedUhXd4dIl1BQvek8x8gZ+2VCJxPkBotXmUxtKl743nN?=
 =?us-ascii?Q?HJr0BNSynRQcYP1OOut3FUWJjBxfZRj3xhNJlGYDRJ2OFURwpS5HjaqMO7ep?=
 =?us-ascii?Q?OJjFvYFphG/dwkEWjuBymvzvjgL3vbiUsdWa6fe95Ie8Y9P7a1vZ745HeW7/?=
 =?us-ascii?Q?SqFfFLnZpDiBggBCiJYkJhPXzOlg8qVSVof8CvqXcE81N2pKCTwL/eFEXbiS?=
 =?us-ascii?Q?/14dbl1c6SwG0etJ1kdbAW2qvEvxucBnSgLDOo7u1cnkWEpmoywtm83tQOsP?=
 =?us-ascii?Q?1V/Jh/3Y4GmwMkXVqrAb93gG9JgkVimLRHOz1ZZtDCOo6iYopkm/pe+y71Wa?=
 =?us-ascii?Q?lQHZRunCn5TQG8XQOAY+ToerWFI5Ugu9Fi1PosyyObv+cVt9MI4/XSGXMJfw?=
 =?us-ascii?Q?HjcwvqoQ3E/Z73ryClGEvoiB/xz0UJGDmMZnd1zXxpOPhOsgMt1gMUZVa7PS?=
 =?us-ascii?Q?fkerF0LcrKWhwG31Qqcn2Ij0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8765a0-3011-42e6-0f23-08d937e4eee7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 14:24:24.8502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fF3TarwX74+xG1rs30wK/7+K67NoZOiDUgIaD0NQnNztH86fZXouQr/Evni1MmGxnvxrZwdkB6xR9Cb6KtLITQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4643
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard

How would you suggest to implement the change that make the new driver beha=
vior optional?
There is no additional parameter in adjtime to let me do that.

Thanks

Min

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: June 24, 2021 12:20 PM
> To: Min Li <min.li.xe@renesas.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net 1/2] ptp: idt82p33: optimize idt82p33_adjtime
>=20
> On Thu, Jun 24, 2021 at 02:38:46PM +0000, Min Li wrote:
> > I have tested this change with ptp4l for by setting step_window to 48
> > (assuming 16 packets per second) for both 8265.2/8275.1 and they
> performed well.
>=20
> Both of these patches assume that user space has a special configuration
> that works together with the non-standard driver behavior.
>=20
> For this reason, I suggest making the new driver behavior optional, with =
the
> default being the origin version that "just works".  In that way, the
> admin/user can choose the special configuration on purpose, and the
> default performance will not be degraded.
>=20
> Thanks,
> Richard
