Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA182288F
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfESTaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 15:30:21 -0400
Received: from mail-eopbgr1310107.outbound.protection.outlook.com ([40.107.131.107]:62692
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730089AbfESTaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 15:30:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=U1t0u+EC7M+OSYMqf1lMLt9KhoaEKMncDrkBcUWuFmi1lYxRAmuH3703MIzfemwOBF+LZ5b/3Vo8/oZh7K4trwwEA5+vskyUFKexllnAvLu0xfQCjsTc1Y0uQ9ug5Z+O8Gw6gPfniycBQ/IHcFNIYD576TQWzdRgHllYBue4d+o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PghB8prHtC/tjrsSnGeBezbsQB9C839XjpWe12zynQ=;
 b=BvCx/Inv8i+W0dKHdCKz7mZFpStKxLSqFidTueg+9hjwmyhSwG10K6z85EW5Cpy4VdneDTxCraUdVkxduLe3QHWu+pktLzBC6i5x0LzXZ+qsCOUB4b5A5UPUsWNz03UtKb1CymqIPXXw0TLjuodzH4hdYznJFTB6FQs3Iw1OXQM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PghB8prHtC/tjrsSnGeBezbsQB9C839XjpWe12zynQ=;
 b=PpBA4OWoLudCUo6fuycI0ceTrW390MjtBY5s52KKxVVnfgChnRzgYBRl0/Tfloo/ot7rDtk3NJtvZdIhv2PUaV75DXXEFw73Hg9X7pupzfaicEpeEevkmHmn1wq3h1pKxO9QH22M3wTw3Mlw98xEK4cAMHg0/enmx+WaXERlqvs=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0155.APCP153.PROD.OUTLOOK.COM (10.170.189.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.6; Sun, 19 May 2019 19:30:07 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.013; Sun, 19 May 2019
 19:30:07 +0000
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
Subject: RE: [PATCH] hv_sock: perf: loop in send() to maximize bandwidth
Thread-Topic: [PATCH] hv_sock: perf: loop in send() to maximize bandwidth
Thread-Index: AdUMVBbujvPfmRv4TlunnQ+yORJc9QCJOjfg
Date:   Sun, 19 May 2019 19:30:07 +0000
Message-ID: <PU1P153MB01696CC308B2F8ECE044A611BF050@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB046557834D46216464A6BA08C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB046557834D46216464A6BA08C00B0@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-19T19:30:03.8722494Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ac7a1640-bd65-4523-9ec8-0983034fa22d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:e8e0:2e52:7999:fc95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bcbfd9b-f3b1-4171-f889-08d6dc9066a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0155;
x-ms-traffictypediagnostic: PU1P153MB0155:
x-microsoft-antispam-prvs: <PU1P153MB015583D2EE4008AD80678A74BF050@PU1P153MB0155.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00429279BA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39850400004)(366004)(136003)(199004)(189003)(5660300002)(486006)(53936002)(86612001)(9686003)(6436002)(54906003)(110136005)(81156014)(81166006)(8676002)(316002)(22452003)(256004)(186003)(55016002)(11346002)(25786009)(71190400001)(6116002)(10290500003)(71200400001)(478600001)(476003)(6636002)(6246003)(4744005)(74316002)(14454004)(2906002)(86362001)(229853002)(8990500004)(4326008)(46003)(33656002)(446003)(10090500001)(7696005)(76176011)(73956011)(76116006)(66446008)(64756008)(66556008)(66476007)(8936002)(102836004)(1511001)(68736007)(99286004)(52536014)(66946007)(7736002)(305945005)(6506007)(14963001);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0155;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EHSZXUo+45dgKC/EwG5Wi3/VCSR1YNl1on2E05wmzNj87Y9Q/w4241hFr2Gkhu/BKdK8hzoQUH3l0YeU4XE0DiBOl265TBTKaGgeXGPIYzyL5u3BR9e0W5P9nI6EaSk5Ee4koUSGOgj4ZCm+xLyLo/QxQznegOddx/JAePJGol5ODzLFap4uLQlLKkK0fAptIe2YXMcPQ0qVOFv2Wbk0+403BFb004DJN+CdNTBEgsDFD8cmWjw6Oxt5973HedQD93Os9p2pZWT5H31CjVQQGVV4Yj/v5FNC1ghBqB/7u8CvmsVGJP3VRhPYeVKFG6zicLO0+2ZoHXH3I4Lgt1Z4TDQBGnZVgoZrZi2FY5xcLr4UYSKvYrr7qrCpQjQqjxhaVdKJ6tYZi/Ah25zHn/VrVwjOBu57URg/eFCJ0nBz2uY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bcbfd9b-f3b1-4171-f889-08d6dc9066a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2019 19:30:07.1069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Thursday, May 16, 2019 7:05 PM
> Currently, the hv_sock send() iterates once over the buffer, puts data in=
to
> the VMBUS channel and returns. It doesn't maximize on the case when there
> is a simultaneous reader draining data from the channel. In such a case,
> the send() can maximize the bandwidth (and consequently minimize the cpu
> cycles) by iterating until the channel is found to be full.
>  ...
> Observation:
> 1. The avg throughput doesn't really change much with this change for thi=
s
> scenario. This is most probably because the bottleneck on throughput is
> somewhere else.
> 2. The average system (or kernel) cpu time goes down by 10%+ with this
> change, for the same amount of data transfer.
>=20
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

The patch looks good. Thanks, Sunil!

Thanks,
-- Dexuan
