Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3641CD0F
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfENQde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 12:33:34 -0400
Received: from mail-eopbgr710116.outbound.protection.outlook.com ([40.107.71.116]:30064
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfENQde (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 12:33:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=n6yu42hNqY9kJZH2RkFdvXpq3zTNXwlFD8bVCI0ADlVC79rj/X8r95deFBF77hHuwLo7eS+1/47Tap2yT04R52sDrqvTeVJK9EOZrERweV/ABYn1V1O5R/Z1Xl4WPvz5cRFtZWlifx9uVEjliWxR8anKQugL4OrH5jKkvhPNav4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiH8zCCzbu4NQwIEpbSEw7d2wyZvBG2xJrmVaiko/Ck=;
 b=Ur5RLhFvzmUx+5syU5JVBlFc0F3pn4lU9gYJ4WI6PJyTMALrnS/Ji3ryYohpqYg9mGi4AEGQgHSckQe9d1t/QYJ1dccTdrltp6qE5thMt+gpGL7LhZJpPVb+jpcf795PodhMyD0ciY1ZpIZAYY2RIkIAtvcIhAF7+w6PGAGdn+I=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiH8zCCzbu4NQwIEpbSEw7d2wyZvBG2xJrmVaiko/Ck=;
 b=MUmY58H/NaX+/DvkTZPna/UqSHsfwPCwMkbgQrvexwOctFX/7h6hl6j+pwrr1f/ANUk7X//jQsLO5kPI+aXgzq0PJ8vFVVF6LUfToYk4JrtVavWGowUZDO3arb1Q9fBxcJ3XqfuTdA0PACtpSe3cauJA22Ga+0DD1M8fUX/+UTU=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0147.namprd21.prod.outlook.com (2603:10b6:404:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.1; Tue, 14 May
 2019 16:33:31 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Tue, 14 May
 2019 16:33:31 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Topic: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Index: AdUF8eO/rXjnGSU+Q+iHOcDDYgexQQAuARSAAPIX9VA=
Date:   Tue, 14 May 2019 16:33:31 +0000
Message-ID: <BN6PR21MB0465DAEFE2237970A511699FC0080@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
 <20190509.135809.630741953977432246.davem@davemloft.net>
In-Reply-To: <20190509.135809.630741953977432246.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:f8d4:c8e7:5ebf:2c16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a9d6478-4b6d-4253-e4ad-08d6d889e6f7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0147;
x-ms-traffictypediagnostic: BN6PR21MB0147:
x-microsoft-antispam-prvs: <BN6PR21MB0147B2F2FC98AF053F34DC8DC0080@BN6PR21MB0147.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(366004)(136003)(346002)(39860400002)(396003)(13464003)(199004)(189003)(81166006)(7696005)(256004)(14444005)(186003)(8936002)(76176011)(6916009)(71200400001)(102836004)(71190400001)(6506007)(7736002)(6116002)(81156014)(53546011)(478600001)(305945005)(6246003)(99286004)(316002)(10290500003)(22452003)(229853002)(68736007)(25786009)(4326008)(6436002)(66476007)(66556008)(14454004)(76116006)(64756008)(73956011)(66446008)(476003)(66946007)(33656002)(52396003)(8676002)(46003)(486006)(53936002)(54906003)(2906002)(4744005)(9686003)(86612001)(86362001)(8990500004)(10090500001)(52536014)(446003)(11346002)(55016002)(74316002)(5660300002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0147;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P5yz1nNo17AmGTD4FuYhN03+3Kla7K5eZDMqNwKbgaZarBgcHpio6mXg6pzDJZum7QU/RoBwep8nzCgVzC0pMz/exmFUkkTNPLgoVaPA874v75qfKn/Mi7YCHm61GD84cKFJ09eJhlvCzLU8S0ce3348X2qPfzuP0cQb5DI7ajije4LmHkPmdaT2w5AMx5DzdqLz+uCmSLM/7s/jdZ77Rm1jMfuRlD96gA0e4MsgJyqEwiISzbSCrCcDEXukhmqe9Vah4H9MQQzCLtJfz340QboBEOSlNSdUZqfshn+wvDCmLeOFM9w7QbcTwXuPIjGG8ulHmPczJ17eq08H/i3Pr0uFOomUyfd/9H9ANwVdgBGWQ6aFc3s3yivd/FcKHpp0qu2nQKMDF7Nxs2kIbYVvPbYbkR8kIjTZPhY7h+Tp12o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9d6478-4b6d-4253-e4ad-08d6d889e6f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 16:33:31.3896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-owner@vger.kernel.=
org> On Behalf Of David Miller
> Sent: Thursday, May 9, 2019 1:58 PM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; Dexuan Cui <decui@microsoft.=
com>; Michael Kelley <mikelley@microsoft.com>;
> netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vger.k=
ernel.org
> Subject: Re: [PATCH] hv_sock: Fix data loss upon socket close
>=20
> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Date: Wed, 8 May 2019 23:10:35 +0000
>=20
> > +static inline void hvs_shutdown_lock_held(struct hvsock *hvs, int mode=
)
>=20
> Please do not use the inline keyword in foo.c files, let the compiler dec=
ide.
>=20
Thanks, will fix in the next version.
> Also, longer term thing, I notice that vsock_remove_socket() is very
> inefficient locking-wise.  It takes the table lock to do the placement
> test, and takes it again to do the removal.  Might even be racy.
Agreed. The check & remove should be done as an atomic operation.
This can be taken up as a separate patch.
