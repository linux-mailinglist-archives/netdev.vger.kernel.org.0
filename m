Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273A945018
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFMXgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:36:02 -0400
Received: from mail-eopbgr1300123.outbound.protection.outlook.com ([40.107.130.123]:37321
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfFMXgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=tdIKXBL6dSOw2YEXeeucdsA+RL/KHX6S3k0ZQxXwA5lC5d6TZBXMqaVn3O9jKDLqjYIQvISoAMyBXW/0Z0LVSk2Foe2UWaSMWhPlZJapcFeJ9WyOsC/58KG613KJhr6euvYkcCu1ZFwQyUf5Vxb8ChnJLO3epwK9QeT7a4fRnDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSjTmiYEtto6t8rXpcplD6OVdR1LgDnRMNjgGnLbQHg=;
 b=LuyWBzen1kclnKR1Q3zi6oR/xNVMFO/4kdiN8lZx5YeBSmz2NYqVpWgY/4clN6rGFkeLMWIXXS+TUJTXUSGw4xqC1ZQ5G3dXormnNoKbgmD3D0EoZE2W0wafxhimp8ksEcHD64wLQY/sN1Kop3NGpAXZ77SMetb86kcjt5ljBTY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSjTmiYEtto6t8rXpcplD6OVdR1LgDnRMNjgGnLbQHg=;
 b=PRF9P8SozpFXRunWQtel7/DzrMD3d+JeCFFUH4Dp7q5Ijw0B1/sz+Ap6D8LXNIgaeVCVfCtBa2IQkFRk05pW/DsubpuUfP5v1o8N2Gw3CaItjV5OiJmZSMzTGvsZO6ahKKmMh+cdrOagDakVWBRVfTVgH8spIvBXeQztfKwCGHU=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0107.APCP153.PROD.OUTLOOK.COM (10.170.188.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.0; Thu, 13 Jun 2019 23:35:54 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%4]) with mapi id 15.20.2008.007; Thu, 13 Jun 2019
 23:35:54 +0000
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
Subject: RE: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Topic: [PATCH net] hvsock: fix epollout hang from race condition
Thread-Index: AdUhY/kd1+XRZykcRS6vcxcYhC9DaQA3F6qQ
Date:   Thu, 13 Jun 2019 23:35:53 +0000
Message-ID: <PU1P153MB016994A9A0C4C3D1306B8FE4BFEF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-13T23:35:51.8575032Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=50c95844-09f0-4178-8ae3-887c91853fa5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:51e0:dd5e:82b6:a386]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e44b62cc-a6de-48bb-0d54-08d6f057e0bf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0107;
x-ms-traffictypediagnostic: PU1P153MB0107:
x-microsoft-antispam-prvs: <PU1P153MB0107F5C7074A7A064C0484FBBFEF0@PU1P153MB0107.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(136003)(346002)(396003)(189003)(199004)(51914003)(4326008)(55016002)(8676002)(186003)(46003)(74316002)(7736002)(8936002)(5660300002)(81156014)(486006)(76176011)(25786009)(66556008)(81166006)(66476007)(2906002)(64756008)(66946007)(6636002)(478600001)(10290500003)(52536014)(446003)(11346002)(14454004)(73956011)(305945005)(33656002)(71200400001)(1511001)(316002)(6506007)(476003)(66446008)(22452003)(86362001)(4744005)(10090500001)(76116006)(54906003)(9686003)(14444005)(256004)(6436002)(110136005)(6116002)(68736007)(6246003)(53936002)(102836004)(8990500004)(229853002)(99286004)(7696005)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0107;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vZBc9eSyhLatgwvFhnmHyXcCVWvpCnMlUFNwXxB74JEV6jgO0AadUugLD9D+H86yys/WTgZTQsVuUlzjSjMgnRH1+98QzR4AgzN+oTpDlhiGgBmZlDaYDhs6bDFOzjO+/y34bQOdVQ0f271xQkqohA0MxW944b1SgPID6hLrx4Idw0rBMTVcJUfhzSYP1SeDMG2YRBQ9NPX8y/bQWGZ3rjc+n+o3u4FIpGiXSWGS3Tv1TgdGXHVmLl8OAX+Il3o566jHpq36QDQfYxVnNBz2YI8JUDaVbdlYe7AnqXNHo/hhRKbMpwExDwO2YtBBqii276JWFzK0enkK17DxjQYa8zKxM4FzW4AthAdFq7TC6umb9aBcwMTXpAYbiO9YwmIwLwrFuFOHjF2Ina7P1M64QPDryCbKwe9676SksYu5Cx0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44b62cc-a6de-48bb-0d54-08d6f057e0bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 23:35:53.8994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Wednesday, June 12, 2019 2:19 PM
>  ...
> The fix is to set the pending size to the default size and never change i=
t.
> This way the host will always notify the guest whenever the writable spac=
e
> is bigger than the pending size. The host is already optimized to *only*
> notify the guest when the pending size threshold boundary is crossed and
> not everytime.
>=20
> This change also reduces the cpu usage somewhat since
> hv_stream_has_space()
> is in the hotpath of send:
> vsock_stream_sendmsg()->hv_stream_has_space()
> Earlier hv_stream_has_space was setting/clearing the pending size on ever=
y
> call.
>=20
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Hi Sunil, thanks for the fix! It looks good.

Reviewed-by: Dexuan Cui <decui@microsoft.com>

