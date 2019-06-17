Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8BE48EEB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFQT21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:28:27 -0400
Received: from mail-eopbgr780139.outbound.protection.outlook.com ([40.107.78.139]:54448
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbfFQT20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:28:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=ANxR3xDov/xIub1BTLnNc00bqpbMfLig6kOn36xmKyXi8jKRhQIEbcXA9dtEQEvohy63sRCfVzZ1XjBsua8SbBiw07RHqkImif1V4nJ2Kn6YmPlHvKJwLKWieMqFRL5JKEPm5q8gDpY9TVpWjX5R/nGNhBI6WdpBNtjbjjy4osA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgAptR3DM0iiC7slJUXaX+ofdmaisgM/VUpTuRkaEiA=;
 b=d1KGLpXSc1CpufEZBb1XsNchNZdpEG8dpIqaX1UR2IF7/ozYXFjKuMRyvIjMwOKJGVwVw5514qBIkzPi8o484Qw+GQDBvqq20en0ter0Bqtm7WkNGWWqJQoXvkeWkMhi72Y2/x1eid1OhPVfz/Cw//Uatz6pq7bCMLoY2+c4DPQ=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgAptR3DM0iiC7slJUXaX+ofdmaisgM/VUpTuRkaEiA=;
 b=Vg1bqXLbJnS2yqHNDfuCUNEp1xmPZB+rVIZijyhjEVBOErOwpfzMk2O9p22sRpqAF4m3pRs7GJZDRFYCyHLPQxlGK5Dv2ozl+b9Y7zzETHAsnMDoGRu7e5MfNEZXSuRt2ksDr/nZTYn6Ym4lbEvG0+D9GNWyXzBOdKwFyF2XzE0=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB1114.namprd21.prod.outlook.com (2603:10b6:302:a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.2; Mon, 17 Jun
 2019 19:27:45 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.007; Mon, 17 Jun 2019
 19:27:45 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     David Miller <davem@davemloft.net>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Topic: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Index: AdUhY/kd1+XRZykcRS6vcxcYhC9DaQBvCbgAAAJcZAAAVwongAAsXmzAAAHItoAAAQ9BAA==
Date:   Mon, 17 Jun 2019 19:27:45 +0000
Message-ID: <MW2PR2101MB11168BA3D46BEC843D694E04C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
        <20190616.135445.822152500838073831.davem@davemloft.net>
        <MW2PR2101MB111697FDA0BEDA81237FECB3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
 <20190617.115615.91633577273679753.davem@davemloft.net>
In-Reply-To: <20190617.115615.91633577273679753.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:8d7e:cb94:2f88:ec90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4b566a5-79e4-4304-b42b-08d6f359dfc3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR2101MB1114;
x-ms-traffictypediagnostic: MW2PR2101MB1114:
x-microsoft-antispam-prvs: <MW2PR2101MB11143926C3BE9132F79F6ADFC0EB0@MW2PR2101MB1114.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(366004)(396003)(346002)(189003)(199004)(13464003)(8676002)(81156014)(81166006)(8936002)(316002)(22452003)(478600001)(305945005)(7736002)(10090500001)(68736007)(6116002)(99286004)(52396003)(7696005)(6916009)(8990500004)(54906003)(76176011)(53546011)(102836004)(10290500003)(6506007)(14454004)(66446008)(73956011)(66946007)(64756008)(66476007)(66556008)(6246003)(5660300002)(229853002)(52536014)(33656002)(4326008)(76116006)(53936002)(46003)(25786009)(2906002)(74316002)(71190400001)(71200400001)(86362001)(9686003)(55016002)(476003)(486006)(6436002)(446003)(11346002)(256004)(14444005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1114;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UIPb1xRk/01q2kXGlJ43B1UplM2CAZQG8eMElPKMkNTGyBaHyfV/ZxExK05hRpAG9wCiasj/9Jt6A/s233u73MX+McICbahIemlcMTuKOAnmC7RDVhfssZReG3jvsfsRVPF8OosHRfSBr3qY7GklUHHWujYkoDS6K2ewwa0OyPdbIOBONiVpX7ektB0pcjTewTBAltEuhNtU9V82zLQ3syGRDDPw4ZbTpVPI0V3nn8JL9H2Mzru6cNaNqVKWzbTQCA0+tt48yFv7aYthOWtNDv+PtD8W05R+HKVoQF7YcHBBH6QVdtY1bgParRK8U+AszyiIyq1aSh/+Uqiwg/rtKpFtOTyqvpplquLdqKbObo2MQxINeDdymRXizxChWqFdhqkQ73IYbHi8Nix0E3VGWeK1XyezicXCnztYdUUMkq4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b566a5-79e4-4304-b42b-08d6f359dfc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:27:45.0458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, June 17, 2019 11:56 AM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>
> Cc: Dexuan Cui <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; =
Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley <mi=
kelley@microsoft.com>; netdev@vger.kernel.org;
> linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
>=20
> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Date: Mon, 17 Jun 2019 18:47:08 +0000
>=20
> >
> >
> >> -----Original Message-----
> >> From: linux-hyperv-owner@vger.kernel.org <linux-hyperv-owner@vger.kern=
el.org> On Behalf Of David Miller
> >> Sent: Sunday, June 16, 2019 1:55 PM
> >> To: Dexuan Cui <decui@microsoft.com>
> >> Cc: Sunil Muthuswamy <sunilmut@microsoft.com>; KY Srinivasan <kys@micr=
osoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>;
> >> Stephen Hemminger <sthemmin@microsoft.com>; sashal@kernel.org; Michael=
 Kelley <mikelley@microsoft.com>;
> >> netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vge=
r.kernel.org
> >> Subject: Re: [PATCH net] hvsock: fix epollout hang from race condition
> >>
> >> From: Dexuan Cui <decui@microsoft.com>
> >> Date: Sat, 15 Jun 2019 03:22:32 +0000
> >>
> >> > These warnings are not introduced by this patch from Sunil.
> >> >
> >> > I'm not sure why I didn't notice these warnings before.
> >> > Probably my gcc version is not new eought?
> >> >
> >> > Actually these warnings are bogus, as I checked the related function=
s,
> >> > which may confuse the compiler's static analysis.
> >> >
> >> > I'm going to make a patch to initialize the pointers to NULL to supp=
ress
> >> > the warnings. My patch will be based on the latest's net.git + this =
patch
> >> > from Sunil.
> >>
> >> Sunil should then resubmit his patch against something that has the
> >> warning suppression patch applied.
> >
> > David, Dexuan's patch to suppress the warnings seems to be applied now
> > to the 'net' branch. Can we please get this patch applied as well?
>=20
> I don't know how else to say "Suni should then resubmit his patch"
>=20
> Please just resubmit it!

The patch does not change at all. So, I was hoping we could reapply it. But=
, I have
resubmitted the patch. Thanks.
