Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1E520E78
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfEPSLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:11:13 -0400
Received: from mail-eopbgr720098.outbound.protection.outlook.com ([40.107.72.98]:4828
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbfEPSLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 14:11:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=ibJ5yhdwtV2KUyyB8S52jtfblMZu1PbDk7xjgefu3Sh7XJZ5xeoXf8bX7Kz0gwydG/1aiRuXTst/xamBjLok/ZAbLXUwKm94YBiihhbkcEU6IaHDVmXDeZDN1XjLR28F7M+58r/3VGLAUhEUU0MTqsXI1mTFPicz7VhpizV17Pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=235WYInt/hkuvurpaJ0Kn+kk9n/ER0C7tzfqDA88wmc=;
 b=USOaQoi3KOaGCJUD4Kh3wU7AFGk2tM2JviDdpQPmBnQY/5+FlT8az+H4BDNY7uA4NKtaT6qBD4ucZVu/VJYMk5vGrZFRNdzqGjcfzQGWjH4+AbH8lxyWd+WcmT4t89B25jsRxxWq/mSviCmAQFkpP3sUsgZQxA3opcPfhRAxOYA=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=235WYInt/hkuvurpaJ0Kn+kk9n/ER0C7tzfqDA88wmc=;
 b=Q2gQB+O9ImKw1pxcReUwlkuSAqMVmRW9EKQjTY29E8t+OekGXBEb52QIqL9AVt/WE8IinOEB9qUt82igm6tVqSqnhTmxkjjEzWwZZusH6d78cSlVXBGKrvxb+BloRHZD932owPQ+0Dn4+K65Eysh2aFuozlqokX6Fofrx6vwSQk=
Received: from BN6PR21MB0465.namprd21.prod.outlook.com (2603:10b6:404:b2::15)
 by BN6PR21MB0851.namprd21.prod.outlook.com (2603:10b6:404:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.5; Thu, 16 May
 2019 18:11:09 +0000
Received: from BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168]) by BN6PR21MB0465.namprd21.prod.outlook.com
 ([fe80::6cf3:89fb:af21:b168%12]) with mapi id 15.20.1922.002; Thu, 16 May
 2019 18:11:09 +0000
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
Subject: RE: [PATCH v2] hv_sock: Add support for delayed close
Thread-Topic: [PATCH v2] hv_sock: Add support for delayed close
Thread-Index: AdUKtaBXG33lHE0AQU2ynJ9GbZ74UwA3pTOgAB0ubQAAAckR0A==
Date:   Thu, 16 May 2019 18:11:09 +0000
Message-ID: <BN6PR21MB0465373CC2D240A47BED9717C00A0@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
 <PU1P153MB01698261307593C5D58AAF4FBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB01693DB2206CD639AF356DBDBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01693DB2206CD639AF356DBDBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:8:56d:b927:3a9:15b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27a777a6-94e6-4696-f290-08d6da29df71
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN6PR21MB0851;
x-ms-traffictypediagnostic: BN6PR21MB0851:
x-microsoft-antispam-prvs: <BN6PR21MB08516A017C78F21D80C571E1C00A0@BN6PR21MB0851.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(346002)(136003)(396003)(199004)(189003)(13464003)(6506007)(76176011)(102836004)(53546011)(256004)(14444005)(186003)(316002)(8676002)(46003)(1511001)(8990500004)(74316002)(8936002)(81166006)(14454004)(81156014)(25786009)(33656002)(6436002)(2906002)(478600001)(55016002)(10290500003)(68736007)(52396003)(9686003)(7696005)(22452003)(71190400001)(71200400001)(99286004)(229853002)(7736002)(86362001)(86612001)(5660300002)(6636002)(6116002)(6246003)(52536014)(53936002)(305945005)(4326008)(476003)(11346002)(73956011)(76116006)(446003)(66476007)(66556008)(66946007)(10090500001)(64756008)(66446008)(54906003)(110136005)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR21MB0851;H:BN6PR21MB0465.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ydu2BkkSC3FJZWkGVGaYnPj16EbFsWihL3LAiBW3xmOaR+tHEmSGzbsHzW0vWTi+opPv9S+SsHmrGOF7Wtn6ySsqff7N6WoUiiHbawgYbhyAp59DoM125xeLFi4XMQr2BwoP85YdvvW+Z0+AP1y+GtKw/mCFsnq4oSXLuUF+Gm7UjOSgTBFmewDjiqTQr90NTkRXG1PQgJk3Qt5HlvcM0W3ipv982wwhcMvMcF6XujQjr3BLPyZaU1OLabjvfJgLlpHRVo9DtTPPxZ/ewRqePWdfsSGBSD5APLTX6o9sPdyhEkphb8HxYP8VnBYYbwIR2eSQQBbKK9wfIZODrmtNyfonM+Pc3myN/TP88+VKrv01leopFSfKS8lv3yn0i/zRcV5lA8Oo7vIN7C8McPvdDzp2PZXCUtQ9Vo0GMZxYrNk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a777a6-94e6-4696-f290-08d6da29df71
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 18:11:09.3772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Thursday, May 16, 2019 10:17 AM
> To: Sunil Muthuswamy <sunilmut@microsoft.com>; KY Srinivasan <kys@microso=
ft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> Stephen Hemminger <sthemmin@microsoft.com>; Sasha Levin <sashal@kernel.or=
g>; David S. Miller <davem@davemloft.net>;
> Michael Kelley <mikelley@microsoft.com>
> Cc: netdev@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-kernel@vg=
er.kernel.org
> Subject: RE: [PATCH v2] hv_sock: Add support for delayed close
>=20
> > From: linux-hyperv-owner@vger.kernel.org
> > <linux-hyperv-owner@vger.kernel.org> On Behalf Of Dexuan Cui
> > Sent: Wednesday, May 15, 2019 9:34 PM
> > ...
>=20
> Hi Sunil,
> To make it clear, your patch itself is good, and I was just talking about
> the next change we're going to make. Once we make the next change,
> IMO we need a further patch to schedule hvs_close_timeout() to the new
> single-threaded workqueue rather than the global "system_wq".
>=20
Thanks for your review. Can you add a 'signed-off' from your side to the pa=
tch.
> > Next, we're going to remove the "channel->rescind" check in
> > vmbus_hvsock_device_unregister() -- when doing that, IMO we need to
> > fix a potential race revealed by the schedule_delayed_work() in this
> > patch:
> >
> > When hvs_close_timeout() finishes, the "sk" struct has been freed, but
> > vmbus_onoffer_rescind() -> channel->chn_rescind_callback(), i.e.
> > hvs_close_connection(), may be still running and referencing the "chan"
> > and "sk" structs (), which should no longer be referenced when
> > hvs_close_timeout() finishes, i.e. "get_per_channel_state(chan)" is no
> > longer safe. The problem is: currently there is no sync mechanism
> > between vmbus_onoffer_rescind() and hvs_close_timeout().
> >
> > The race is a real issue only after we remove the "channel->rescind"
> > in vmbus_hvsock_device_unregister().
>=20
> A correction: IMO the race is real even for the current code, i.e. withou=
t
> your patch: in vmbus_onoffer_rescind(), between we set channel->rescind
> and we call channel->chn_rescind_callback(), the channel may have been
> freed by vmbus_hvsock_device_unregister().
>=20
> This race window is small and I guess that's why we never noticed it.
>=20
> > I guess we need to introduce a new single-threaded workqueue in the
> > vmbus driver, and offload both vmbus_onoffer_rescind() and
> > hvs_close_timeout() onto the new workqueue.
>=20
Something is a miss if the guest has to wait for the host to close the chan=
nel
prior to cleaning it up from it's side. That's waste of resources, doesn't =
matter
if you do it in a system thread, dedicated pool or anyway else. I think the=
 right
way to deal with this is to unregister the rescind callback routine, wait f=
or any
running rescind callback routine to finish and then drop the last reference=
 to
the socket, which should lead to all the cleanup. I understand that some of=
 the
facility of unregistering the rescind callback might not exist today.

> Thanks,
> -- Dexuan

