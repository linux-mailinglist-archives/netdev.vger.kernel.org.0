Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2518120DC4
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfEPRQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:16:45 -0400
Received: from mail-eopbgr1320094.outbound.protection.outlook.com ([40.107.132.94]:36690
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726578AbfEPRQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 13:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=dTXynS4C7t6AzNtTCYdIX9JS2qW0uJaqV4HfG6ij1/xTVKx3dNZzuoTt78RV5kOxlgAauqwvHMgOKPLCkzttADThXDBvnhqQbEzTR1zGRh/Vf+fYiIiT4g12kNGyjnlBXBQtCdvWY8d83eGNp2D5xCn3V0vIn9OGAA0cQAXJho8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlvleVwL/PkxyXeqGxFMjgmuDx9G4jJSjxN+URBf1/E=;
 b=cjibX3d07fZm8zfLmHnd987U0IH4Amq9GJCmIQS78pzk2XMsAYxHoxCcHLEZ4pmL2ZaVp8BbqoNwIrrjMEFouymvh4kv64vnlYYDOcngPprVPjACzmqBih7e8iXNjqzAIemOkWIkKh7IZho273Vkb26eMofQTCAdtUSrbI0zVTo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JlvleVwL/PkxyXeqGxFMjgmuDx9G4jJSjxN+URBf1/E=;
 b=KNGxdyGdtR5TIDu+jqapajqjJIENcZAL8NZRFpAC/CfqxO6KDD6DCjH1QG7tRpcagRGYPyYgJLqHUurZ3jgLBPwgPSlcAkNzP4gVcL63b61cl52BhsVUTtZVjTu9tvFB2vR3J9zOD2KPSyZ2F9RlR85pzHfK2/3aEEJUybHkf7A=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0138.APCP153.PROD.OUTLOOK.COM (10.170.188.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.4; Thu, 16 May 2019 17:16:38 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Thu, 16 May 2019
 17:16:38 +0000
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
Thread-Index: AdUKtaBXG33lHE0AQU2ynJ9GbZ74UwA3pTOgAB0ubQA=
Date:   Thu, 16 May 2019 17:16:37 +0000
Message-ID: <PU1P153MB01693DB2206CD639AF356DBDBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB0465043C08E519774EE73E99C0090@BN6PR21MB0465.namprd21.prod.outlook.com>
 <PU1P153MB01698261307593C5D58AAF4FBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01698261307593C5D58AAF4FBF0A0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
x-ms-office365-filtering-correlation-id: a1c6e5aa-7702-436c-15da-08d6da22417d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0138;
x-ms-traffictypediagnostic: PU1P153MB0138:
x-microsoft-antispam-prvs: <PU1P153MB0138FE878ABA1CA15D92C613BF0A0@PU1P153MB0138.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(186003)(99286004)(486006)(1511001)(102836004)(74316002)(46003)(54906003)(229853002)(256004)(11346002)(316002)(110136005)(22452003)(6436002)(8990500004)(33656002)(14444005)(476003)(446003)(2940100002)(7736002)(478600001)(52536014)(81156014)(68736007)(305945005)(81166006)(5660300002)(8936002)(8676002)(10290500003)(6636002)(2906002)(6116002)(66446008)(73956011)(66476007)(66556008)(64756008)(76116006)(4326008)(9686003)(86612001)(86362001)(6246003)(71190400001)(71200400001)(53936002)(66946007)(6506007)(14454004)(55016002)(25786009)(76176011)(7696005)(10090500001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0138;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b+Rxn/rcFA584RGkYnU4XQfQABVYHFdZFqfiaJSyKHvrqKFlSPSQrbMy58Yf5rXjCiLO/W9xCPBxAg/0OhmfB/SAD3ER+G+viSlFB2/Vdrcsnx7wYEClrTF9WOEOaGUhgMoefOBvFKjIOd0XnEwXDDARglTrNONYGSpXBqnYx5h9E2m2GiQjuwJHSZn/R72aMEBZP4okXCEjmliggArQM7s2CsnbipmnrguI1nAM1NOlC8dl3vurBsKtMN+b/rH7gS+wrWzmmvx8CJpr8xbWcijJ41JySit5QV96mZ5BEhmBAloDdj9t7uzFUPc6KAiTYpZqNjnyoxiL41MiIQ3P5OTXPhO9R9XN5rDn8FS3pomD7MAImQ6WSWJ2His1g83mFWl7u5C++kumtdnebIv+ZzJvOlaXxTdpgXSTVnV81nk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c6e5aa-7702-436c-15da-08d6da22417d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 17:16:37.7736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Dexuan Cui
> Sent: Wednesday, May 15, 2019 9:34 PM
> ...

Hi Sunil,
To make it clear, your patch itself is good, and I was just talking about
the next change we're going to make. Once we make the next change,
IMO we need a further patch to schedule hvs_close_timeout() to the new
single-threaded workqueue rather than the global "system_wq".

> Next, we're going to remove the "channel->rescind" check in
> vmbus_hvsock_device_unregister() -- when doing that, IMO we need to
> fix a potential race revealed by the schedule_delayed_work() in this
> patch:
>=20
> When hvs_close_timeout() finishes, the "sk" struct has been freed, but
> vmbus_onoffer_rescind() -> channel->chn_rescind_callback(), i.e.
> hvs_close_connection(), may be still running and referencing the "chan"
> and "sk" structs (), which should no longer be referenced when
> hvs_close_timeout() finishes, i.e. "get_per_channel_state(chan)" is no
> longer safe. The problem is: currently there is no sync mechanism
> between vmbus_onoffer_rescind() and hvs_close_timeout().
>=20
> The race is a real issue only after we remove the "channel->rescind"
> in vmbus_hvsock_device_unregister().

A correction: IMO the race is real even for the current code, i.e. without
your patch: in vmbus_onoffer_rescind(), between we set channel->rescind
and we call channel->chn_rescind_callback(), the channel may have been
freed by vmbus_hvsock_device_unregister().

This race window is small and I guess that's why we never noticed it.

> I guess we need to introduce a new single-threaded workqueue in the
> vmbus driver, and offload both vmbus_onoffer_rescind() and
> hvs_close_timeout() onto the new workqueue.
=20
Thanks,
-- Dexuan

