Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF5272B2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfEVXHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:07:06 -0400
Received: from mail-eopbgr1320120.outbound.protection.outlook.com ([40.107.132.120]:28592
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726553AbfEVXHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 19:07:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=H/NJATreM3Kj7pqN1Zm9z/iUCepe6fppNm00Aiv5G1NevI9h9pkerJM+dS5aUK7SYAKExl5za1Rjbj/le10XsPhKoAVbXRtuqrfBFEsX/rpwTK2VEnYxjRlxKYR3nuPZt+b8QcCAmmeZFdPj+GUsH2fDm3uUKavvJ1dRMw1EpiU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ohhHm/ag12nqxVYbgVhKCgv0n0DKG2fNfSyB4WZ1BM=;
 b=b2LUUC6Q0bB2NXLgF45sE1CVW5V2BrHDNcJF1mGx2ERRrZg1hyI+IVf9JTLRY9pULs+nEaMVlkSMrKDQYkXQzlNcmw+X4pf695yJ6YtSCYhb4B08bTzpyruI25QZS24a6Ph1xxFee+6/lGB3A+BsgqXP4xLeLAAGOH9b1UVC0Vc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ohhHm/ag12nqxVYbgVhKCgv0n0DKG2fNfSyB4WZ1BM=;
 b=kRlowZprFxQec7guKFgG7ai7r5cHDbLBW8P2kUhMRasZLOjPFj7TErqU5dOiiLBSZPPyBv2ZnhjePys+eqfQ4JAk5ZlauiM4VtXswHyzGVRz823+gU540HYx5jqxIvWmfh3aHDZ89lkFfe9sSb59NEDLtHhkj85oSjELjFPufjE=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0186.APCP153.PROD.OUTLOOK.COM (10.170.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.6; Wed, 22 May 2019 23:06:57 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%3]) with mapi id 15.20.1943.007; Wed, 22 May 2019
 23:06:57 +0000
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
Subject: RE: [PATCH net-next] hv_sock: perf: Allow the socket buffer size
 options to influence the actual socket buffers
Thread-Topic: [PATCH net-next] hv_sock: perf: Allow the socket buffer size
 options to influence the actual socket buffers
Thread-Index: AdUQ8PsjFNIw2dWyQTKbqbtYd11NLgAATdkA
Date:   Wed, 22 May 2019 23:06:57 +0000
Message-ID: <PU1P153MB016989C5FDF71E7CB1EC6BB9BF000@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB04652168EAE5D6D7D39BD4AAC0000@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-22T23:06:55.7008782Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=15a9214a-c30a-44ca-afda-bbf5be6c9efe;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:f13e:15cc:fc47:db6b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b7f5b1-15f9-4157-92c6-08d6df0a30a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0186;
x-ms-traffictypediagnostic: PU1P153MB0186:
x-microsoft-antispam-prvs: <PU1P153MB01865DA2E239B3B0C300102BBF000@PU1P153MB0186.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(46003)(53936002)(486006)(476003)(11346002)(446003)(99286004)(76176011)(76116006)(66556008)(6436002)(52536014)(33656002)(7696005)(66476007)(66946007)(14454004)(73956011)(64756008)(66446008)(102836004)(229853002)(4326008)(22452003)(6506007)(6246003)(71190400001)(186003)(316002)(25786009)(71200400001)(10290500003)(1511001)(5660300002)(256004)(478600001)(68736007)(6116002)(8990500004)(10090500001)(110136005)(54906003)(4744005)(8936002)(86362001)(9686003)(55016002)(81156014)(74316002)(6636002)(2906002)(81166006)(7736002)(8676002)(305945005)(86612001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0186;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L7cVqxRX0Sb4+iO1VjGPKpOgfKuJpcIIxq35jdGwUOHnT0xV/Ysm080rzooLWFEcq8FZ+1pAKhlsXsU5eSm+Qce5l1fcK5Y/0A4HZPYWNGm8bO6dvIsVC506g81qCxMaOcUuoeUgk4hH0qAd2rH2nzzgPKrSyj5KWDbufDRG+mSZXSx39BbkTmfPSF2i4A3aUufy2x6aKsR2m3KUcqK9MynfgSx1xjHFNxp+UdUfIz6Rzq1aAkzc3PniwFH3M1+J8HB2fzwo8LmSp58MlIHp0Yw2+sILQMb7gjGm0bktc3T5v4YUtHPwoaKZuCiXLb0diX00YHE1H6/u1hfo4JPGDmGi5Lr6XkmyQ2w/1OFbc7hd23MwOc8qIr/C+OjlD9nn884qvFIvXM9GerxG1BoKS2pyBKtN6C7pg6ltlyarLi4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b7f5b1-15f9-4157-92c6-08d6df0a30a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 23:06:57.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Wednesday, May 22, 2019 3:56 PM
> ...
> Currently, the hv_sock buffer size is static and can't scale to the
> bandwidth requirements of the application. This change allows the
> applications to influence the socket buffer sizes using the SO_SNDBUF and
> the SO_RCVBUF socket options.
>  ...
>=20
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good. Thanks, Sunil!

Thanks,
-- Dexuan
