Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6891146E6A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 07:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfFOFDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 01:03:46 -0400
Received: from mail-eopbgr1320111.outbound.protection.outlook.com ([40.107.132.111]:5536
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfFOFDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 01:03:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=J+WARC1wYFVgIUn6CtS1wAzuG0C7eKvX+2Fxx/8tBt650Z3IENhkmV/pwNeQXBP/qNmTmd6w1ChHTE9ewA8S2DrM2FTx1h8q1duvwu97vFyjqKtvsWYZqCwfNE0dFwrkiphd7VfJXVN1eoUi66cD76gQSlZFWNizMks1pQUiboo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8as5v4yKg2Worx+Hx1uaKpf+hGMXMAS6628OMHdHjo=;
 b=WpMPvERS4U/6bOW9CIgyCuOt/piaC2NgUfmxk2JPRMS1eW4dwNA4dR+EW3nid54JGeaHLmTMsRfui0My6eqn/Ja3bAN+EQvloXMu0DS3f7t7QHzWomNWBJ4MuGXS284e0qT9F1OZguIFMkmUZN8VbT9TtKEkAnlSkwlJ6UVkyLY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8as5v4yKg2Worx+Hx1uaKpf+hGMXMAS6628OMHdHjo=;
 b=bGApvSQhwEc1IWzp7CDLR9O5gM5oN4THGC1tL7eu0SmB+OAkUunWC+aJF5zgZ/yL2SVqG9b7RKnXLgfol05ijNXR6DBnuzH9xq6CaweAe7nzIBVjS5mHA80Pym3ep29qrVh95+8q7WglJV5IhrZ7+0OBBLfnGE9u6fzMKrRd1KY=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0122.APCP153.PROD.OUTLOOK.COM (10.170.188.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.1; Sat, 15 Jun 2019 05:03:39 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%4]) with mapi id 15.20.2008.007; Sat, 15 Jun 2019
 05:03:39 +0000
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
Thread-Index: AQHVIyAf1+XRZykcRS6vcxcYhC9DaaacCm+ggAAUrpA=
Date:   Sat, 15 Jun 2019 05:03:34 +0000
Message-ID: <PU1P153MB0169810F29C473D44C090F6ABFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
 <20190614.191456.407433636343988177.davem@davemloft.net>
 <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
x-ms-office365-filtering-correlation-id: 35750204-0dfa-4066-81ba-08d6f14ed46f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0122;
x-ms-traffictypediagnostic: PU1P153MB0122:
x-microsoft-antispam-prvs: <PU1P153MB0122C4245467FCF80290F5B0BFE90@PU1P153MB0122.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(68736007)(46003)(186003)(10090500001)(1511001)(8936002)(6116002)(8676002)(486006)(476003)(5660300002)(52536014)(11346002)(66574012)(256004)(446003)(86362001)(73956011)(71200400001)(66556008)(6666004)(14444005)(64756008)(76116006)(66946007)(66446008)(71190400001)(66476007)(14454004)(6636002)(110136005)(74316002)(22452003)(8990500004)(54906003)(4326008)(99286004)(33656002)(2940100002)(6246003)(102836004)(6436002)(55016002)(316002)(9686003)(25786009)(53936002)(305945005)(81166006)(81156014)(7736002)(229853002)(76176011)(53546011)(2906002)(10290500003)(7696005)(6506007)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0122;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hZm6I05SiBSDnWtKHhzEjsoetGMRcctAMeJEahzYR+/pjjQebTuvU8RQeRm+O2VWTSSU9Ugd7EGfqf9TJBvjOvaOmrG0YkkVahAGISjbHSfrZrmMpZy01gQDFCycipjZPo4i7VOrTfehPFMbzudG2wKD4Trk36yeAqctw09m3ugsFYTqWIc4gQFjHHqCss5M7nfE4ZIecAsNz30QzCc9ncZvdUC4fLxsIZM3Yr+VMo0FpZ+VQJtwY9QghodEIpB2K8lCxzbHd8ZUetZPTWjGzvuAT6gNuUroQyXrVqIq11NByHv3Cy4gtraE8Y60Ta+1T7o8R5NndRfROYaxfZZb5tBxCBVN0nGkep7sevc+Gc/ZBGX3NustaZi4OpBhCA6/l6kScMdMdzyoGRmpeo9xCxpIDsDpXsQaegv2mqOjD6s=
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35750204-0dfa-4066-81ba-08d6f14ed46f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 05:03:34.9389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Dexuan Cui
> Sent: Friday, June 14, 2019 8:23 PM
> To: David Miller <davem@davemloft.net>; Sunil Muthuswamy
> <sunilmut@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; Michael Kelley
> <mikelley@microsoft.com>; netdev@vger.kernel.org;
> linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
>=20
> > From: linux-hyperv-owner@vger.kernel.org
> > <linux-hyperv-owner@vger.kernel.org> On Behalf Of David Miller
> > Sent: Friday, June 14, 2019 7:15 PM
> > To: Sunil Muthuswamy <sunilmut@microsoft.com>
> >
> > This adds lots of new warnings:
> >
> > net/vmw_vsock/hyperv_transport.c: In function =A1hvs_probe=A2:
> > net/vmw_vsock/hyperv_transport.c:205:20: warning: =A1vnew=A2 may be use=
d
> > uninitialized in this function [-Wmaybe-uninitialized]
> >    remote->svm_port =3D host_ephemeral_port++;
> >    ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> > net/vmw_vsock/hyperv_transport.c:332:21: note: =A1vnew=A2 was declared
> here
> >   struct vsock_sock *vnew;
> >                      ^~~~
> > net/vmw_vsock/hyperv_transport.c:406:22: warning: =A1hvs_new=A2 may be
> > used uninitialized in this function [-Wmaybe-uninitialized]
> >    hvs_new->vm_srv_id =3D *if_type;
> >    ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~
> > net/vmw_vsock/hyperv_transport.c:333:23: note: =A1hvs_new=A2 was declar=
ed
> > here
> >   struct hvsock *hvs, *hvs_new;
> >                        ^~~~~~~
>=20
> Hi David,
> These warnings are not introduced by this patch from Sunil.

Well, technically speaking, the warnings are caused by Suni's patch, but I =
think it should
be a bug of gcc (I'm using "gcc (Ubuntu 8.2.0-12ubuntu1) 8.2.0"). As you ca=
n see, the
line numbers given by gcc, i.e. line 205, line 406, are not related to the =
warnings.

Actually, the same warnings can repro with the below one-line patch on this=
 commit of
today's net.git:
    9a33629ba6b2 ("hv_netvsc: Set probe mode to sync")

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -403,6 +403,7 @@ static void hvs_open_connection(struct vmbus_channel *c=
han)

        set_per_channel_state(chan, conn_from_host ? new : sk);
        vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
+       asm ("nop");

        if (conn_from_host) {
                new->sk_state =3D TCP_ESTABLISHED;

It looks a simple inline assembly code can confuse gcc. I'm not sure if I s=
hould
report a bug for gcc...

I posted a patch to suppress these bogus warnings just now. The Subject is:

[PATCH net] hv_sock: Suppress bogus "may be used uninitialized" warnings

Thanks,
-- Dexuan
