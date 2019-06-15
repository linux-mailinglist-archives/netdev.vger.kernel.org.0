Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F6946EB7
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFOHXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 03:23:33 -0400
Received: from mail-eopbgr750124.outbound.protection.outlook.com ([40.107.75.124]:14718
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbfFOHXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 03:23:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=i06LbdBSVox+wjziFZFjoNW+aWI8f1HmAWJBPd4oyLiWLdBeEHXm02zSYaYfxqHIVLr85FvgvwQs4hyuCDG3GcX54gWRMtGOEhCzFBnF81naJ80H/ixlG4GffkYmuA9w5ILWnlTgOVpOAtLzeJ+SAiH/x0JWAcnMySyCY8qJe60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kA3zSugUnzuTsVAN/90ZlWxV2CXr5trvTClPydmXB4=;
 b=irHw4rvFliQlZs5i61a3F/FmtJB3NUckTI/D3MJl0uQQrw4xhnNQHFp30jP7sDyU7acVgPJfUNbWUu5Jfd1nEa1fAQQY+NfU+lpL9VeFa44aWVu5O+n6CBIAfpcwYSqHCVYK6mYahPq0s3vjyBU36THxTDAW8spbbhDuwG/xONk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kA3zSugUnzuTsVAN/90ZlWxV2CXr5trvTClPydmXB4=;
 b=MvayYrpQoE2nbkZXHij4hgLviM1/MsWJwGspyg4e+aHt+nGADgQVt1jf2cFqxh3d6VAHYHQkoyGZux9NBIfvDZ15oMJFitJ8/VxgcGHzcuGgiujCNTNt5pk3ACZhqcvBHMS94QT6KgdpmclUvwk7UrOeK5KvtUu/iXD+hmRXrE4=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB0985.namprd21.prod.outlook.com (2603:10b6:302:4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.4; Sat, 15 Jun
 2019 07:23:29 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.002; Sat, 15 Jun 2019
 07:23:29 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        David Miller <davem@davemloft.net>
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
Thread-Index: AdUhY/kd1+XRZykcRS6vcxcYhC9DaQBvCbgAAAJcZAAAA4dPAAAEw2pg
Date:   Sat, 15 Jun 2019 07:23:29 +0000
Message-ID: <MW2PR2101MB111678811A8761515B669A47C0E90@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
 <20190614.191456.407433636343988177.davem@davemloft.net>
 <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169810F29C473D44C090F6ABFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169810F29C473D44C090F6ABFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:24b4:540:3de4:fc8f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93dd8923-327e-41a6-72ee-08d6f1625d49
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MW2PR2101MB0985;
x-ms-traffictypediagnostic: MW2PR2101MB0985:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MW2PR2101MB0985EAAB88A2CA3A550AAE71C0E90@MW2PR2101MB0985.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(366004)(136003)(13464003)(189003)(199004)(305945005)(10290500003)(64756008)(99286004)(229853002)(478600001)(6506007)(76176011)(53546011)(966005)(52536014)(25786009)(6246003)(66556008)(71190400001)(71200400001)(66446008)(2906002)(66476007)(8676002)(4326008)(6116002)(81166006)(81156014)(8936002)(74316002)(86362001)(7736002)(33656002)(55016002)(6306002)(14454004)(446003)(9686003)(11346002)(66574012)(186003)(73956011)(66946007)(14444005)(256004)(76116006)(110136005)(53936002)(1511001)(7696005)(54906003)(10090500001)(102836004)(22452003)(46003)(52396003)(8990500004)(476003)(316002)(6436002)(5660300002)(486006)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0985;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KcMPcc32TsXdKqXfIQxYTJXy0PasIAhomOCxiSKFaLQx8hJZzSlh3aylEFVWs+nq3/u04eBAqUjXhns6ab+WC3sLFVRMfwp0FUY/fd2XwRSME8BDIICZIRPRvVc+K5kZNuEv4bRH66KBqUd33oh+HZdEMYUnB07vn1wqDL7f0Afe+Pe4dOr93Ap1RkSb36bDzNFeQupYhGUib5KWqbn+xkY5yC4vXUP3gWr8RQY1DEWauceLFWjc91ae19xlXvNwAxPBlpbAX5BAwJJ4T/DtCVi73Wm3sgNzqbtEyuX6S/PoICagp+y0x25LT72bguSKLO0SvGLJZqscBbPNCUgBdtTDR612DmyNWm/N9hEk3LSO5W3/9JzRqACByE/VNX79n0eNY4c7yoHR6n1n9MgemWbIu4dIYWUFgsb3rCcuTSY=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93dd8923-327e-41a6-72ee-08d6f1625d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 07:23:29.2098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0985
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, June 14, 2019 10:04 PM
> To: David Miller <davem@davemloft.net>; Sunil Muthuswamy <sunilmut@micros=
oft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.=
com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley <mikelley@mic=
rosoft.com>; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
>=20
> > From: linux-hyperv-owner@vger.kernel.org
> > <linux-hyperv-owner@vger.kernel.org> On Behalf Of Dexuan Cui
> > Sent: Friday, June 14, 2019 8:23 PM
> > To: David Miller <davem@davemloft.net>; Sunil Muthuswamy
> > <sunilmut@microsoft.com>
> > Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley
> > <mikelley@microsoft.com>; netdev@vger.kernel.org;
> > linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
> >
> > > From: linux-hyperv-owner@vger.kernel.org
> > > <linux-hyperv-owner@vger.kernel.org> On Behalf Of David Miller
> > > Sent: Friday, June 14, 2019 7:15 PM
> > > To: Sunil Muthuswamy <sunilmut@microsoft.com>
> > >
> > > This adds lots of new warnings:
> > >
> > > net/vmw_vsock/hyperv_transport.c: In function =A1hvs_probe=A2:
> > > net/vmw_vsock/hyperv_transport.c:205:20: warning: =A1vnew=A2 may be u=
sed
> > > uninitialized in this function [-Wmaybe-uninitialized]
> > >    remote->svm_port =3D host_ephemeral_port++;
> > >    ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> > > net/vmw_vsock/hyperv_transport.c:332:21: note: =A1vnew=A2 was declare=
d
> > here
> > >   struct vsock_sock *vnew;
> > >                      ^~~~
> > > net/vmw_vsock/hyperv_transport.c:406:22: warning: =A1hvs_new=A2 may b=
e
> > > used uninitialized in this function [-Wmaybe-uninitialized]
> > >    hvs_new->vm_srv_id =3D *if_type;
> > >    ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
> > > net/vmw_vsock/hyperv_transport.c:333:23: note: =A1hvs_new=A2 was decl=
ared
> > > here
> > >   struct hvsock *hvs, *hvs_new;
> > >                        ^~~~~~~
> >
> > Hi David,
> > These warnings are not introduced by this patch from Sunil.
>=20
> Well, technically speaking, the warnings are caused by Suni's patch, but =
I think it should
> be a bug of gcc (I'm using "gcc (Ubuntu 8.2.0-12ubuntu1) 8.2.0"). As you =
can see, the
> line numbers given by gcc, i.e. line 205, line 406, are not related to th=
e warnings.
>=20
> Actually, the same warnings can repro with the below one-line patch on th=
is commit of
> today's net.git:
>     9a33629ba6b2 ("hv_netvsc: Set probe mode to sync")
>=20
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -403,6 +403,7 @@ static void hvs_open_connection(struct vmbus_channel =
*chan)
>=20
>         set_per_channel_state(chan, conn_from_host ? new : sk);
>         vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
> +       asm ("nop");
>=20
>         if (conn_from_host) {
>                 new->sk_state =3D TCP_ESTABLISHED;
>=20
> It looks a simple inline assembly code can confuse gcc. I'm not sure if I=
 should
> report a bug for gcc...
>=20
> I posted a patch to suppress these bogus warnings just now. The Subject i=
s:
>=20
> [PATCH net] hv_sock: Suppress bogus "may be used uninitialized" warnings
>=20
> Thanks,
> -- Dexuan

Yes, these warnings are not specific to this patch. And, additionally these
should already addressed in the commit=20
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?=
id=3Dac383f58f3c98de37fa67452acc5bd677396e9f3
I was trying to avoid making the same changes here to avoid merge
conflicts when 'net-next' merges with 'net' next.
