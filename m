Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB47346E03
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfFODWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:22:41 -0400
Received: from mail-eopbgr1300123.outbound.protection.outlook.com ([40.107.130.123]:24704
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfFODWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 23:22:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=gwsy3WASoF6iR6tS6z5zwuvlaF8qTdNgJbClLnKVloIDwaRxdnmBS9xxI1VIcdaQUz2VcfuBSMuiCJv4v8agY6TBFFlYhK44fY5LY7QgqmA13s/4VgjIgzry3t5rOWixOfxHkE+C2vJu9rIYA0MfjCZUpl/AJWYjB6ZntTjN5TU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2AXyhJVVGhFzvVBmILv4vK9BxFH/Dy6rx/v7G5oOWk=;
 b=eGY07Ck4ouVLvHDm/5HDPJEzXHckgkZhGJWhG9+1rnuIZqNKPBwK1m26VpT149jn6d1cFC7pmkUlRZJQl5/GNZWy/N3TQxTFRnCEdvixrcOoJpJNh44U1nU8DLxUpRfkh2dOitEx7OHe2g3PcsU7UEaZ6rMeLqfSbpDo/A41wwA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2AXyhJVVGhFzvVBmILv4vK9BxFH/Dy6rx/v7G5oOWk=;
 b=hr1+PF+PBtvpX9luSPSY1OQEe2mWm1rKJLtBkA+rU6fxSVEigshOasZesXsWWYHMagYtm1TBGyyB3iu2zDbnMFS/Fct4rsfzg2LtecicjRV31mEK7kHBCM5Vq470vawCKV2Tw8YEKtJup0mH3yI8kXgySv3VG+4XsLPLG8HIobo=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0170.APCP153.PROD.OUTLOOK.COM (10.170.189.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.0; Sat, 15 Jun 2019 03:22:32 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%4]) with mapi id 15.20.2008.007; Sat, 15 Jun 2019
 03:22:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     David Miller <davem@davemloft.net>,
        Sunil Muthuswamy <sunilmut@microsoft.com>
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
Thread-Index: AQHVIyAf1+XRZykcRS6vcxcYhC9DaaacCm+g
Date:   Sat, 15 Jun 2019 03:22:32 +0000
Message-ID: <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
 <20190614.191456.407433636343988177.davem@davemloft.net>
In-Reply-To: <20190614.191456.407433636343988177.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-15T03:22:30.1109385Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5a22ec33-d84a-451d-b0f2-0c7166ab82c0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:3526:f0c3:b438:bf24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69941d72-7002-4100-c0c4-08d6f140b488
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0170;
x-ms-traffictypediagnostic: PU1P153MB0170:
x-microsoft-antispam-prvs: <PU1P153MB01701222672E50AF18679331BFE90@PU1P153MB0170.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(39830400003)(376002)(136003)(199004)(189003)(10090500001)(229853002)(8936002)(6116002)(4326008)(52536014)(446003)(6246003)(2906002)(10290500003)(14444005)(256004)(71190400001)(14454004)(86362001)(476003)(6636002)(99286004)(7696005)(6506007)(71200400001)(81166006)(110136005)(486006)(76176011)(22452003)(55016002)(11346002)(316002)(53546011)(1511001)(81156014)(102836004)(186003)(54906003)(46003)(9686003)(73956011)(66946007)(76116006)(66446008)(66476007)(33656002)(8676002)(5660300002)(478600001)(66556008)(25786009)(74316002)(53936002)(7736002)(66574012)(6436002)(68736007)(64756008)(305945005)(8990500004);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0170;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rWfEb6SykSagv/37FLhh2DFctVWTWcykXJNlCcjGGSo1lqeGHrvmHDFTImkiGXkHDBKwroh9Ezp0rKWF/XdtOOXuOx9i62Z98yD5fweUybWq9bWONX/3TWc6ylh9J2ER5O8bFu1qdUoBouFd3XTTXf/7LJYwuBTcjWZvZVvl+bmF7oTQLNPAaLS9PxKUZhib9jm3SGW0HYgeZ4bNG1YLElTUOyMnHSKZzKWIqJkjzA9h8pgvTuyoBo4PPvc58YzB/lpb4lXdo2MqLoBrUEA/PI3RAPG2aE01DmnaajDP2uvrbLSSSjX87tKwu7pVOu61mgWe0pLziScfaMKygAk20RtbHR3bRaJjvY5cMyFK2MbII+qujBMjW4/4o4lITKoBHqmlbBF0IIvh/MYADIpjic3cK7SkJBz7PWM0CTEF/LQ=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69941d72-7002-4100-c0c4-08d6f140b488
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 03:22:32.4698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of David Miller
> Sent: Friday, June 14, 2019 7:15 PM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>
>=20
> This adds lots of new warnings:
>=20
> net/vmw_vsock/hyperv_transport.c: In function =A1hvs_probe=A2:
> net/vmw_vsock/hyperv_transport.c:205:20: warning: =A1vnew=A2 may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>    remote->svm_port =3D host_ephemeral_port++;
>    ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> net/vmw_vsock/hyperv_transport.c:332:21: note: =A1vnew=A2 was declared he=
re
>   struct vsock_sock *vnew;
>                      ^~~~
> net/vmw_vsock/hyperv_transport.c:406:22: warning: =A1hvs_new=A2 may be
> used uninitialized in this function [-Wmaybe-uninitialized]
>    hvs_new->vm_srv_id =3D *if_type;
>    ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
> net/vmw_vsock/hyperv_transport.c:333:23: note: =A1hvs_new=A2 was declared
> here
>   struct hvsock *hvs, *hvs_new;
>                        ^~~~~~~

Hi David,
These warnings are not introduced by this patch from Sunil.

I'm not sure why I didn't notice these warnings before. =20
Probably my gcc version is not new eought?=20

Actually these warnings are bogus, as I checked the related functions,
which may confuse the compiler's static analysis.

I'm going to make a patch to initialize the pointers to NULL to suppress
the warnings. My patch will be based on the latest's net.git + this patch
from Sunil.

Thanks,
-- Dexuan
