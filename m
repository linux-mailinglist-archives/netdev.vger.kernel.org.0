Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E33F48CDA
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfFQSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:47:12 -0400
Received: from mail-eopbgr760091.outbound.protection.outlook.com ([40.107.76.91]:3687
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbfFQSrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 14:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=dmiNxrXXn0BdDQNvqqurGNfVYVjCHJQbWH4E710+FHJBOSTY+GBh+44W+GeA+Wrgya5aZjLSyh0LbWnCTey/bKrqR/jzLZkNNSG4jfsqMVmUXmDxDrTW+9L9atSLavQU6Zpt+lAQrt1Uc7rEuqyjC5u2JPyYjgTBn2FWquC/8xY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFKC25shXYrQn1Zb+aiqUiGWjF6sjLeR8ccIU8ad7B0=;
 b=JTrkk45flZJSB5buKtHXmWB/0e4X2sFYwQWYrQgMAacIUXOJj6X6C79z1WH5Es08LK8q3UUNFVUKVqIkyaXWLfnzgHxcuz+Dxht0Qbg0rrxtgENFUOxsYoSXXh64VrblaN2xLaHIfPMeq5KQdC41XAabMr7zqe3tMR1ZK7CI254=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFKC25shXYrQn1Zb+aiqUiGWjF6sjLeR8ccIU8ad7B0=;
 b=UWwN4JHuuPuCbHHgaUqhh4oRei+v1jMwDhXlb/z16xGhX9Q7JB/FRq4mcD2n/R6KZI8N866xLcaLYGthElXJwM6LtUQg3xWhaeNPtAwPEupCaXZEYV4B/2J3xcwUR13XzwCoQT2XKitx9L1hEDbBemSrsmtCmtMrtm+WoyZe+K8=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB1066.namprd21.prod.outlook.com (2603:10b6:302:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.3; Mon, 17 Jun
 2019 18:47:08 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.007; Mon, 17 Jun 2019
 18:47:08 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Topic: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Index: AdUhY/kd1+XRZykcRS6vcxcYhC9DaQBvCbgAAAJcZAAAVwongAAsXmzA
Date:   Mon, 17 Jun 2019 18:47:08 +0000
Message-ID: <MW2PR2101MB111697FDA0BEDA81237FECB3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
        <20190614.191456.407433636343988177.davem@davemloft.net>
        <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190616.135445.822152500838073831.davem@davemloft.net>
In-Reply-To: <20190616.135445.822152500838073831.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:8d7e:cb94:2f88:ec90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba657bec-d31d-49f8-aaa5-08d6f3543391
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR2101MB1066;
x-ms-traffictypediagnostic: MW2PR2101MB1066:
x-microsoft-antispam-prvs: <MW2PR2101MB10664099FD6AA6F4E50CDFB9C0EB0@MW2PR2101MB1066.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(366004)(396003)(39860400002)(13464003)(189003)(199004)(7696005)(81166006)(7736002)(8936002)(229853002)(76176011)(6506007)(53546011)(102836004)(81156014)(6436002)(8676002)(99286004)(52396003)(55016002)(74316002)(305945005)(9686003)(186003)(2906002)(76116006)(53936002)(86362001)(33656002)(4326008)(52536014)(1511001)(6246003)(66446008)(64756008)(66556008)(66476007)(66946007)(25786009)(8990500004)(446003)(11346002)(73956011)(10090500001)(316002)(22452003)(46003)(68736007)(10290500003)(478600001)(54906003)(110136005)(71200400001)(71190400001)(5660300002)(256004)(14444005)(14454004)(486006)(476003)(6636002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1066;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SBywSH2KhgdrlUaQrEgFsUHw7IwrKE4HPBOmpxZgRksG1bZH5R/FY7YURMSevygX4QNhowbiBsnisbG5d0dGiuRGhU76kwnkotTgRS/fJQgGdgLxCkHom+Nj67okhF0M6FyjPgO0YSTixyRxaPJcKcTtUBdWAWYRMM8gcJq6eDzHbexR6JRUHhCF6nFX6N/M9k1+o/XiCUllLezUSefkgiNzeuAqMvDUB3zKd03tNYEFRrKqiDvYMw0UbeFlcbfsjtUIBpu5AUEvrXaQYkxVKOssPohE2haIMLiZZu8PlAjn6WsjMqMfz5gY4LMnn6zJl/UFn37388fQbjvZYpCMH5IolshjjZvUgxlP01XllVYVOVzaZ7ogKVxVvqARfbdAMeP673evcGfo0UrWJ6J1YRpX0ATLGiEx/uLO8Xolzrk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba657bec-d31d-49f8-aaa5-08d6f3543391
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 18:47:08.6061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-owner@vger.kernel.=
org> On Behalf Of David Miller
> Sent: Sunday, June 16, 2019 1:55 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: Sunil Muthuswamy <sunilmut@microsoft.com>; KY Srinivasan <kys@microso=
ft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; sashal@kernel.org; Michael Ke=
lley <mikelley@microsoft.com>;
> netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vger.k=
ernel.org
> Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
>=20
> From: Dexuan Cui <decui@microsoft.com>
> Date: Sat, 15 Jun 2019 03:22:32 +0000
>=20
> > These warnings are not introduced by this patch from Sunil.
> >
> > I'm not sure why I didn't notice these warnings before.
> > Probably my gcc version is not new eought?
> >
> > Actually these warnings are bogus, as I checked the related functions,
> > which may confuse the compiler's static analysis.
> >
> > I'm going to make a patch to initialize the pointers to NULL to suppres=
s
> > the warnings. My patch will be based on the latest's net.git + this pat=
ch
> > from Sunil.
>=20
> Sunil should then resubmit his patch against something that has the
> warning suppression patch applied.

David, Dexuan's patch to suppress the warnings seems to be applied now
to the 'net' branch. Can we please get this patch applied as well?
