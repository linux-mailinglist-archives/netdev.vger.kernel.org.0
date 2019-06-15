Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85ECF47159
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 19:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfFORBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 13:01:20 -0400
Received: from mail-eopbgr1310105.outbound.protection.outlook.com ([40.107.131.105]:6160
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbfFORBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 13:01:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=bRwioeCdWaAtA1ogvrz3ZwDdfRQe2bhp/c7+oNpOa/CcsZBTPpfymltDNuuNT3Z5X720MIslzmlG+RjIlclu2f239eW8PwW4KZJJVDOfFe2RAKPbfDdkLdbOlY4XDaonkxgBE6o+5Vxo9tKgKHYdWetUjsCLmUpANjhZkw1kq48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03LjLAPea0kYxmqRnORh0WWNxRMJcDAl60Gw1Yx9s28=;
 b=R6gmYyFzUIUuv22Mrh65sTLWkBlqmd/kvuOjt3FbXMrMl33C+1OghtaV9p6iL/OTicAHVYZ99j4zQcVIefzJtOOlaRg1JuOw2ZO0ilkKFH4+OfhOuiNfJn+VvIYP0rH8VGUahCF1SmrjQaK0IebG5W0Mv4B7orc1jc6igUuRKR4=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03LjLAPea0kYxmqRnORh0WWNxRMJcDAl60Gw1Yx9s28=;
 b=JrOggcou4nsSCerOo+PxQluhGpFDKVHvyPoIg3vRS9aBFjypsyf5y/maXhrbbyJWc9AezwwHidc0x7P8tNC77CziEihPXwBSnXBIQ1YGABZMfYvQG3YNHYNNxFEMAswjda4oAMnMhXykOzXU/w3VMALJON4Ea7DK4GT1kmHlnsI=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0124.APCP153.PROD.OUTLOOK.COM (10.170.188.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.0; Sat, 15 Jun 2019 17:01:10 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%4]) with mapi id 15.20.2008.007; Sat, 15 Jun 2019
 17:01:10 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
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
Thread-Index: AQHVIyAf1+XRZykcRS6vcxcYhC9DaaacCm+ggAAUrpCAADEXgIAAn55A
Date:   Sat, 15 Jun 2019 17:01:08 +0000
Message-ID: <PU1P153MB016954EEE4FB5463A61E4292BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <MW2PR2101MB11164C6EEAA5C511B395EF3AC0EC0@MW2PR2101MB1116.namprd21.prod.outlook.com>
 <20190614.191456.407433636343988177.davem@davemloft.net>
 <PU1P153MB0169BACDA500F94910849770BFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169810F29C473D44C090F6ABFE90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <MW2PR2101MB111678811A8761515B669A47C0E90@MW2PR2101MB1116.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB111678811A8761515B669A47C0E90@MW2PR2101MB1116.namprd21.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 05200501-83b6-409f-7fc4-08d6f1b310c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0124;
x-ms-traffictypediagnostic: PU1P153MB0124:
x-microsoft-antispam-prvs: <PU1P153MB0124EFED770D3D2F831BA9CABFE90@PU1P153MB0124.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(39860400002)(376002)(366004)(189003)(199004)(11346002)(7736002)(446003)(86362001)(33656002)(486006)(305945005)(476003)(68736007)(186003)(81156014)(8676002)(81166006)(8936002)(1511001)(8990500004)(46003)(10090500001)(22452003)(316002)(110136005)(54906003)(53546011)(99286004)(76176011)(6506007)(7696005)(102836004)(4326008)(14454004)(55016002)(25786009)(6436002)(6246003)(9686003)(53936002)(10290500003)(478600001)(256004)(229853002)(71190400001)(73956011)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(4744005)(5660300002)(52536014)(71200400001)(76116006)(6116002)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0124;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EjZ+sypi9arab96unF9Gmsr7959HCLPdMK+XUTtvo4WFnqZclA9hKG+u75f5ieNINkAl+HQbzi3V9wNbO0p5VHnOJ4Lmo5WSzd2ai69tkmNBDeQhhpvBUwP34gpgr0ZCSmBMtt98rYaYI1jAGjh0mU5ieoZ/x3MGpE7QE1cbPPrdIA2RQx0pD6QLft8UK7vRgL7sNYEYit3w6K4j/cl5VSRt5w3QMaBAGHTXEsQ2ZeXVrh6EY814xZJRANOQwQo/CKVxgfhyq+rZAZmToXbVS4r/3Wmj05Hyk9a0geJKgEZISQdi8Y9e/rNNzUvZ7TeA+1xl0Rae/1t3ve6pX3OeszDEWwuFag1D3ZmTuzDaEgY3Odvfd8u0J+x4zKKPDRUaMVahauH4xhqEqz75TKWtsOFt6lxbG6+S35GEKngR1Ps=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05200501-83b6-409f-7fc4-08d6f1b310c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 17:01:08.7184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Saturday, June 15, 2019 12:23 AM
> To: Dexuan Cui <decui@microsoft.com>; David Miller <davem@davemloft.net>
> > ...
> > It looks a simple inline assembly code can confuse gcc. I'm not sure if=
 I should
> > report a bug for gcc...
> >
> > I posted a patch to suppress these bogus warnings just now. The Subject=
 is:
> >
> > [PATCH net] hv_sock: Suppress bogus "may be used uninitialized" warning=
s

David, as I described, these warnings are spurious and can be safely ignore=
d.

Please consider not applying my two-line patch to avoid merge conflict
with Sunil's another patch in net-next.git.=20

> Yes, these warnings are not specific to this patch. And, additionally the=
se
> should already addressed in the commit ...
> I was trying to avoid making the same changes here to avoid merge
> conflicts when 'net-next' merges with 'net' next.

Yeah, I agree.

Thanks,
-- Dexuan
