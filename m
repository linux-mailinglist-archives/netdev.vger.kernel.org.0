Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03120EF9
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfEPSzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:55:09 -0400
Received: from mail-eopbgr1320104.outbound.protection.outlook.com ([40.107.132.104]:32297
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbfEPSzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 14:55:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=CFsboXkBgBitCJ8P3FdE3ikVsQ/uemwkmuzq7aBvpT1HwwMJ/usp1W0QZhY0vnTp4ZHU5ySg4pca9CciDlfpYv9RjJK88K2lHC16qgcsrMA/0JUcknFUsVWtMUF2C20HK1dhSlOmdPpOBM0xIJ2tCplpJJrvR++L1sGQzPm7y18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxjljpgCaNDutUcwdgOWDtCKlZoIkXm7xeUNJScBoY8=;
 b=In6hb15N+4d41tEt6cJBcbbdlEaEj5744k5HznmyTooMJyXcfwo3N4RqhbWfi978gYQvLsbl4o2jrFFjP8Mnu19085Gpbq8bBs7A1O/KqN/daQw/TGBNlUHKwMCWzNhCXTlC+en/zwdvapuyk+QxDjEbSOzKEifg9U/MR/TLpjo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxjljpgCaNDutUcwdgOWDtCKlZoIkXm7xeUNJScBoY8=;
 b=Woonaah4FnEon8NMxeLTEZbNHu0l0LRH8LKCjoemrFn8UPbheRJ5hqZivZ7KEioeREQOvFhv+GlL4NnanMFhSl75kEr5XFBpwZQtWFYeWaR/drzHCoagyZG9uvw0x5KH1RA3gSBSEtRd2Oft+07oAc9p4sKHFnuvXnj7ucGggYQ=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0121.APCP153.PROD.OUTLOOK.COM (10.170.188.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.4; Thu, 16 May 2019 18:55:01 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Thu, 16 May 2019
 18:55:01 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] hv_sock: Add support for delayed close
Thread-Topic: [PATCH v2] hv_sock: Add support for delayed close
Thread-Index: AdUKtaBXG33lHE0AQU2ynJ9GbZ74UwA3pTOgAB0ubQAAAckR0AABMrQg
Date:   Thu, 16 May 2019 18:55:00 +0000
Message-ID: <PU1P153MB0169E046B258196B6D58C156BF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
 <PU1P153MB01698261307593C5D58AAF4FBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB01693DB2206CD639AF356DBDBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <BN6PR21MB0465373CC2D240A47BED9717C00A0@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB0465373CC2D240A47BED9717C00A0@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-16T04:34:19.9899242Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a52563af-82a7-4a5f-aed5-227da8f0af23;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:e49c:a88d:95f1:67ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f30606e-7269-4deb-663c-08d6da30000a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0121;
x-ms-traffictypediagnostic: PU1P153MB0121:
x-microsoft-antispam-prvs: <PU1P153MB0121F82644587B06B4AEBF7BBF0A0@PU1P153MB0121.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(396003)(39860400002)(199004)(189003)(54906003)(99286004)(476003)(110136005)(8676002)(8936002)(7696005)(81156014)(81166006)(305945005)(76176011)(10090500001)(74316002)(55016002)(9686003)(486006)(7736002)(46003)(256004)(14444005)(11346002)(229853002)(76116006)(446003)(5660300002)(8990500004)(53936002)(25786009)(6246003)(6436002)(102836004)(186003)(52536014)(2906002)(66476007)(10290500003)(66946007)(14454004)(73956011)(68736007)(33656002)(316002)(478600001)(6506007)(86612001)(66556008)(66446008)(64756008)(71200400001)(71190400001)(4326008)(1511001)(6636002)(6116002)(86362001)(22452003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0121;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VqW0koqLKmAHim4U3yp3hD0EoNCfL5pcJ+ojO/VSsjizhGhCiPNWu637gtnRlTK05YK9xraUN9qVc5sHprPGWgCaprVRJmMjFRAHcvIKxVuBAOUAjkgfYl+Ukz7UnxN6AXT56exrFnUf9fUhKSiE1oGnfohN9g6KSD0l1tDYmI8kxlWKnQYp/U+XebQa5fAhxVwWx272cDBiq3zC69JJKQsk9jwhVI/37oLeskbn8ecemxr8HN0lgliR61vA+9Co08MvnJEVwPrY7viIX8NtXszRaM5OI8lhC+3s/ffHHM3afCslsiJKmAdImZwMEtIY2TU0irPsJrHy3rdcc1VlKB8oBMiiXtmKAG/sIWtTLWX3lcn5MGN8mDiD4ItFUqaGo29lYKyDLbGfcRSUHJ8XwqVkHb/3L90yPO0swb3u2T8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f30606e-7269-4deb-663c-08d6da30000a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 18:55:00.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Thursday, May 16, 2019 11:11 AM
> > Hi Sunil,
> > To make it clear, your patch itself is good, and I was just talking abo=
ut
> > the next change we're going to make. Once we make the next change,
> > IMO we need a further patch to schedule hvs_close_timeout() to the new
> > single-threaded workqueue rather than the global "system_wq".
> >
> Thanks for your review. Can you add a 'signed-off' from your side to the =
patch.

I have provided my Reviewed-by. I guess this should be enough. Of course,
David makes the final call. It would be great if the maintaners of the Hype=
r-V
drivers listed in the "To:" could provide their Signed-off-by.

> > > Next, we're going to remove the "channel->rescind" check in
> > > vmbus_hvsock_device_unregister() -- when doing that, IMO we need to
> > > fix a potential race revealed by the schedule_delayed_work() in this
> > > patch:
> > >
> > > When hvs_close_timeout() finishes, the "sk" struct has been freed, bu=
t
> > > vmbus_onoffer_rescind() -> channel->chn_rescind_callback(), i.e.
> > > hvs_close_connection(), may be still running and referencing the "cha=
n"
> > > and "sk" structs (), which should no longer be referenced when
> > > hvs_close_timeout() finishes, i.e. "get_per_channel_state(chan)" is n=
o
> > > longer safe. The problem is: currently there is no sync mechanism
> > > between vmbus_onoffer_rescind() and hvs_close_timeout().
> > >
> > > The race is a real issue only after we remove the "channel->rescind"
> > > in vmbus_hvsock_device_unregister().
> >
> > A correction: IMO the race is real even for the current code, i.e. with=
out
> > your patch: in vmbus_onoffer_rescind(), between we set channel->rescind
> > and we call channel->chn_rescind_callback(), the channel may have been
> > freed by vmbus_hvsock_device_unregister().
> >
> > This race window is small and I guess that's why we never noticed it.
> >
> > > I guess we need to introduce a new single-threaded workqueue in the
> > > vmbus driver, and offload both vmbus_onoffer_rescind() and
> > > hvs_close_timeout() onto the new workqueue.
> >
> Something is a miss if the guest has to wait for the host to close the ch=
annel
> prior to cleaning it up from it's side. That's waste of resources, doesn'=
t matter

I agree.=20

> if you do it in a system thread, dedicated pool or anyway else. I think t=
he right
> way to deal with this is to unregister the rescind callback routine, wait=
 for any
> running rescind callback routine to finish and then drop the last referen=
ce to
> the socket, which should lead to all the cleanup. I understand that some =
of the
> facility of unregistering the rescind callback might not exist today.

Considering the concurrency, I'm not sure if it's easy or possible to safel=
y
unregister the chn_rescind_callback. My hunch is: doing that may be more
difficult than adding a new single-thread workqueue.

Thanks,
-- Dexuan

