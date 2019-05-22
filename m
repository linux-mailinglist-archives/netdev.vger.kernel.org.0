Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1A4272FF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfEVXbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:31:52 -0400
Received: from mail-eopbgr1300124.outbound.protection.outlook.com ([40.107.130.124]:63660
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbfEVXbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 19:31:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=M7v8LeIr95AHFJBqyTbP4JBDLw7dqj65lAwIKaqeyAPmpso3VUz30K6AAEkXR+/+Pw+SwgKSDhqxheHU+5VVLpwfzufKEX1kOnKKJsBY9GaLk+byptkCt0eHthOumod+R5k00CQbuolBzRnJmx3/uoOYhmXxQBf1/+/aCpuYPw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiJKAVXxVy5gDyY2F5z+qKOfPRII1FfBsEs3X3qSrHE=;
 b=uQn5d+f/irFiJzM9jcyItmczidFObAFg9SBwsgTjQ4Osf6hY82cSoGIIwi40nUSAe3o5QPESasnWUixDEqHk3Phw7FfV1DixQ3P+yvKL04cT+ol1pVAVwEbSv89BQlRqrd2im7dYcR6v+81DOhRs4/Kx9iOywdT5FMBCu0SLSpU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiJKAVXxVy5gDyY2F5z+qKOfPRII1FfBsEs3X3qSrHE=;
 b=Tddqb2NLAPwNfvO2tWIZ5vLDmsS9ZWPWLzCt/Bif/Q4isK80PrMIdKEZRlDLMGwjtPcMhEhv8zRuXMAldeh36WcJQnnd0hZtnnN1xvxG/Zzjl8fiV6pWMOXDjulFftlcEbRXytIksI7wL0PN20NuKx8sg29mYYC44GzwyaOfAag=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0170.APCP153.PROD.OUTLOOK.COM (10.170.189.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.6; Wed, 22 May 2019 23:31:45 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d896:4219:e493:b04%3]) with mapi id 15.20.1943.007; Wed, 22 May 2019
 23:31:45 +0000
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
Subject: RE: [PATCH net-next] hv_sock: perf: loop in send() to maximize
 bandwidth
Thread-Topic: [PATCH net-next] hv_sock: perf: loop in send() to maximize
 bandwidth
Thread-Index: AdUQ82kcrZ0lH8wWQ6mgUr9BJIMYLQAAwLXA
Date:   Wed, 22 May 2019 23:31:44 +0000
Message-ID: <PU1P153MB016970E96C1FCE1B42FBFB6CBF000@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB0465FA591662A8B580AEF7D9C0000@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB0465FA591662A8B580AEF7D9C0000@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-22T23:31:42.5201528Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4553db3f-2df2-4389-a7a5-bc8944e9569f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:f13e:15cc:fc47:db6b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3ade817-4dad-4c96-37c5-08d6df0da72f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0170;
x-ms-traffictypediagnostic: PU1P153MB0170:
x-microsoft-antispam-prvs: <PU1P153MB0170EE149E05F98FCC6AAD2BBF000@PU1P153MB0170.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(366004)(346002)(136003)(199004)(189003)(54906003)(8990500004)(110136005)(10090500001)(478600001)(6636002)(186003)(74316002)(52536014)(5660300002)(305945005)(7736002)(55016002)(476003)(86362001)(446003)(11346002)(46003)(99286004)(14454004)(4326008)(8936002)(1511001)(86612001)(33656002)(4744005)(486006)(316002)(76116006)(81166006)(81156014)(66946007)(68736007)(66446008)(8676002)(73956011)(2906002)(64756008)(10290500003)(66556008)(66476007)(6436002)(9686003)(6246003)(229853002)(6116002)(7696005)(76176011)(71190400001)(22452003)(25786009)(6506007)(71200400001)(53936002)(256004)(102836004)(14963001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0170;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vwzCU7d+XfM/pZMGzXJKDHt9e4ZffG1+DN72eZDOjBSV/D6cKnqLmtVJt0QmY3jJuH4zhDCUF3QIhc1+cY/Ob6n4g1LrTYXegQnW8gwtHd5ky0DV2fkxDgDGMVi7ZeZDuCPcCc4mFIuP41/lmmNPCuwfFOy7Hs5xN2+ELjkzrrK49y6xoqj9tPIqavll7LOB8ViekZ/MHvrjfggjgq2shG8D3bN+3GGRtSuqooHuCnvX2foH0q1125aCpfLcsZvrzffhn+cMrNy8evpc1nktwQQK0H09iL2Da624SAr1i1VcJ3xkksbXIyrZoHZI30VY5qojPuwgoQCSpftxV3ULDdb2dyH3dL5rYKXLhDbO+VrUuzQ+uL1XYlSDS8b1xtqKlATDLcE+mNjhVR4+zXkr8eXpni2DwnFZp6Cx6NqF6H0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ade817-4dad-4c96-37c5-08d6df0da72f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 23:31:44.7165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Sunil Muthuswamy
>=20
> Currently, the hv_sock send() iterates once over the buffer, puts data in=
to
> the VMBUS channel and returns. It doesn't maximize on the case when there
> is a simultaneous reader draining data from the channel. In such a case,
> the send() can maximize the bandwidth (and consequently minimize the cpu
> cycles) by iterating until the channel is found to be full.
=20
Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good. Thanks, Sunil!

Thanks,
-- Dexuan
