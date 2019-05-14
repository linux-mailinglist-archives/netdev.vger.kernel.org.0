Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1AB1D0BD
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 22:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfENUlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 16:41:02 -0400
Received: from mail-eopbgr710127.outbound.protection.outlook.com ([40.107.71.127]:38081
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726427AbfENUlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 16:41:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=e3yTtx1m9lmrdPm2vpX8EjWSKxNvWYiM5R0iU6xwcqR1i5i+cYWUOmVCirWA9dnj/ZCo31WUXTG1LsqbSJ8ATF3QTnzgoJ9LZZRvvkRicWUtWo4TpGm8rSyKNUKfN5bTRSvku6oTWCdt54Nz6soNhyZj/LMI2Xe4TojbcP9AaqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktm+AyAanBsqJAn6sFhK8h7nLrTj1wrX74sH5J9F+A0=;
 b=ektMR5Cc/r3RS7LIEMJPKGdW0udKc8iCzJA/IG3uqgOrRGhXZ3E5Mhz4z2iSEr01KOBppwXy71UdIVnE+/4DNpicd7lNCO53EqUEObLDFUVQdONdEAaad0SwH0t7Bclui7pGA0zpMYZgqCR+IWzROzMsMS9hNRjye8lgIneG5BU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktm+AyAanBsqJAn6sFhK8h7nLrTj1wrX74sH5J9F+A0=;
 b=BJE4E+RCrWwpIASukUa4fNhZXsnCL12x+Gg4TVA4udssCf2VIRZeOd9w4iELI0WftZdIEy/Fe+Y+qDezZglpui3tcWmYlFynslYRFL4mpGsYycvZcfRCTRhVKOkrzzxnB9Q9qaqQlihOnDDzg+7MUZpxp5pzH6qFNdQ1fsqhD1U=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0770.namprd21.prod.outlook.com (2603:10b6:404:9c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.1; Tue, 14 May
 2019 20:40:56 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Tue, 14 May
 2019 20:40:56 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Topic: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Index: AdUF8eO/rXjnGSU+Q+iHOcDDYgexQQBncSCgAL9DJeA=
Date:   Tue, 14 May 2019 20:40:56 +0000
Message-ID: <BN6PR21MB0465E3E8C3C386D21647A237C0080@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
 <PU1P153MB01695C88469F32B9ECC7657EBF0D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01695C88469F32B9ECC7657EBF0D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-11T03:56:45.2460723Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cd20b9e0-8a1f-4bd1-b9b3-e337b3c76db0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:7:f8d4:c8e7:5ebf:2c16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9da5b2e9-170c-43e2-2de1-08d6d8ac776f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0770;
x-ms-traffictypediagnostic: BN6PR21MB0770:
x-microsoft-antispam-prvs: <BN6PR21MB0770A30598D6506470D5C158C0080@BN6PR21MB0770.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(51914003)(13464003)(486006)(53936002)(54906003)(11346002)(14454004)(6636002)(66556008)(110136005)(446003)(86612001)(66446008)(46003)(8676002)(52396003)(33656002)(66946007)(64756008)(73956011)(76116006)(476003)(52536014)(8990500004)(86362001)(10090500001)(74316002)(5660300002)(55016002)(66476007)(9686003)(2906002)(6436002)(71190400001)(102836004)(71200400001)(256004)(14444005)(81166006)(7696005)(76176011)(8936002)(1511001)(229853002)(6246003)(99286004)(10290500003)(316002)(305945005)(478600001)(25786009)(68736007)(4326008)(22452003)(6506007)(53546011)(7736002)(186003)(6116002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0770;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E13WaE1Y0uau1s7yrE82sCZlHr4Vzu8LTFRyDB4GRCwHXozXa4bZEgIjXi2X+ndOIXz6FjHfz+4LH27+OlQdX61V5/5UnczMAI1WsAeC8FraZ9vYc8mSL6wLC1lNuI3y8aFMtjYc7VbWPMw+OZydTjxNjVDXWQATWe3v/SODpGM4dRNTZ3bHZMI1o89bUCXN3J54PmuWhCrLvMmHjduxrK/AwaDQSQ4dBSKcpCffFXbuxdfHTvpqQNvLWazuUjVCzo9N9A6mtxTPOO6xitcvFkJesbHBlse+E14SscBkXNGKOcVQF8d4bgXFAjuTHyBcsmTeMH2v7SiSuY6LmjqGkMne6AGQUwKf93YT8R9D2rIUxcMrNQdWFaF0xnDFUquDAqm0U5ZeEYq7cO20mQR0mRZl+Ip+P0SW7oTQz+Qky/o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da5b2e9-170c-43e2-2de1-08d6d8ac776f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 20:40:56.7151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, May 10, 2019 8:57 PM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>; KY Srinivasan <kys@microso=
ft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; Sasha Levin <sashal@kernel.or=
g>; David S. Miller <davem@davemloft.net>;
> Michael Kelley <mikelley@microsoft.com>
> Cc: netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vg=
er.kernel.org
> Subject: RE: [PATCH] hv_sock: Fix data loss upon socket close
>=20
> > From: Sunil Muthuswamy <sunilmut@microsoft.com>
> > Sent: Wednesday, May 8, 2019 4:11 PM
> >
> > Currently, when a hvsock socket is closed, the socket is shutdown and
> > immediately a RST is sent. There is no wait for the FIN packet to arriv=
e
> > from the other end. This can lead to data loss since the connection is
> > terminated abruptly. This can manifest easily in cases of a fast guest
> > hvsock writer and a much slower host hvsock reader. Essentially hvsock =
is
> > not following the proper STREAM(TCP) closing handshake mechanism.
>=20
> Hi Sunil,
> It looks to me the above description is inaccurate.
>=20
> In the upstream Linux kernel, closing a hv_sock file descriptor may hang
> in vmbus_hvsock_device_unregister() -> msleep(), until the host side of
> the connection is closed. This is bad and should be fixed, but I don't th=
ink
> the current code can cause data loss: when Linux calls hvs_destruct() ->
> vmbus_hvsock_device_unregister() -> vmbus_device_unregister() -> ...
> -> vmbus_close() to close the channel, Linux knows the host app has
> already called close(), and normally that means the host app has
> received all the data from the connection.
>=20
> BTW, technically speaking, in hv_sock there is no RST packet, while there
> is indeed a payload_len=3D=3D0 packet, which is similar to TCP FIN.
>=20
> I think by saying "a RST is sent" you mean Linux VM closes the channel.
>=20
> > The fix involves adding support for the delayed close of hvsock, which =
is
> > in-line with other socket providers such as virtio.
>=20
> With this "delayed close" patch, Linux's close() won't hang until the hos=
t
> also closes the connection. This is good!
>=20
The next version of the patch will only focus on implementing the delayed
(or background) close logic. I will update the title and the description of=
 the
next version patch to more accurately reflect the change.=20
> > While closing, the
> > socket waits for a constant timeout, for the FIN packet to arrive from =
the
> > other end. On timeout, it will terminate the connection (i.e a RST).
>=20
> As I mentioned above, I suppose the "RST" means Linux closes the channel.
>=20
> When Linux closes a connection, the FIN packet is written into the shared
> guest-to-host channel ringbuffer immediately, so the host is able to see =
it
> immediately, but the real question is: what if the host kernel and/or hos=
t app
> can not (timely) receive the data from the ringbuffer, inclding the FIN?
>=20
> Does the host kernel guarantee it *always* timely fetches/caches all the
> data from a connection, even if the host app has not accept()'d the
> conection, or the host app is reading from the connection too slowly?
>=20
> If the host doesn't guarantee that, then even with this patch there is st=
ill
> a chance Linux can time out, and close the channel before the host
> finishes receiving all the data.
>=20
TCP protocol does not guarantee that all the data gets delivered, especiall=
y
during close. The applications are required to mitigate this by using a
combination of shutdown() and subsequent read() on both client and server
side.
> I'm curious how Windows guest implements the "async close"?
> Does Windows guest also use the same timeout strategy here? If yes,
> what's the timeout value used?
>=20
Windows also implements the delayed close logic in a similar fashion. You c=
an
lookup the MSDN article on 'graceful shutdown'.
> > diff --git a/net/vmw_vsock/hyperv_transport.c
> > b/net/vmw_vsock/hyperv_transport.c
> > index a827547..62b986d 100644
>=20
> Sorry, I need more time to review the rest of patch. Will try to reply AS=
AP.
>=20
> > -static int hvs_update_recv_data(struct hvsock *hvs)
> > +static int hvs_update_recv_data(struct vsock_sock *vsk)
> >  {
> >  	struct hvs_recv_buf *recv_buf;
> >  	u32 payload_len;
> > +	struct hvsock *hvs =3D vsk->trans;
> >
> >  	recv_buf =3D (struct hvs_recv_buf *)(hvs->recv_desc + 1);
> >  	payload_len =3D recv_buf->hdr.data_size;
> > @@ -543,8 +591,12 @@ static int hvs_update_recv_data(struct hvsock *hvs=
)
> >  	if (payload_len > HVS_MTU_SIZE)
> >  		return -EIO;
> >
> > -	if (payload_len =3D=3D 0)
> > +	/* Peer shutdown */
> > +	if (payload_len =3D=3D 0) {
> > +		struct sock *sk =3D sk_vsock(vsk);
> >  		hvs->vsk->peer_shutdown |=3D SEND_SHUTDOWN;
> > +		sk->sk_state_change(sk);
> > +	}
>=20
> Can you please explain why we need to call this sk->sk_state_change()?
>=20
> When we call hvs_update_recv_data(), we hold the lock_sock(sk) lock, and =
we
> know there is at least one byte to read. Since we hold the lock, the othe=
r
> code paths, which normally are also requried to acquire the lock before
> checking vsk->peer_shutdown, can not race with us.
>=20
This was to wakeup any waiters on socket state change. Since the updated
patch now only focuses on adding the delayed close logic, I will remove thi=
s in
the next version.
Thanks for the review so far.
> Thanks,
> -- Dexuan
