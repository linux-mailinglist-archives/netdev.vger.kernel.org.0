Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0BBE9F18
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfJ3PcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:32:09 -0400
Received: from mail-eopbgr770097.outbound.protection.outlook.com ([40.107.77.97]:47697
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727201AbfJ3PcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:32:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDxWWPAa6Gz0BZHtCdV0EvB6R8tGaEUiXM/otwMPFjCMs++SSeRJMJUOFO1tV167JAAGLzwyU2oP/+IuVcxKogIjO1wwGZU7aFPv5TL45xDNGepdDDUwWzeRVef00iRWdNJ8FZZJr30fhFIKFmEoHspJIStYWzWrTITTpKvFwDfC3VkYlstBfCW9kue7ptkCCZ2Wd/FFd/nhO2k/n/JnEZqkwxMQ8uSDSZV8UdbYL6VBFY7DzKwWzeqcTgXU8bdn0xoX1wffXOeOBg/TaLF2WXTEJ1v1BoRkkkrTbn8/MfHM8n84fMfFVlkbrxQqHk3vQYecgbFWkiV7YxuvdMfO3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RH+IFTFh1MtdP5mb8WuXy3H4/zp96T9vHC2n7oOu/+E=;
 b=CnMGIHBpaA2xnGDEU1P4g1F+N44wSGHEmVj1TwwksqxqDpMBeG/XrqOpmQRJ00isFJMApRDqFmipYyVQy0VlXyt+RTtygL4Djgn9ltDsMbGCGzOLBRUrKvUDvmmF7SzmLp8+++Mz2sfMg69v4M7A9u2+YD3PWSIo06DemNvtY0xS7GH7a/GfN4i4lyqYDdEqRg8suRO194Jr73wnY3PnbB7sM4Himq+8k9Ch4TrJK7eI15u0PGuk34FHVZLikR8lTz0xuioMtr6C8v75YWnyLFLptUPN5ZCoh+Rjl1AgKM6gIbZPe4LXLBinuUtfhu64UC0odrgQCPU0prpxeq5RxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RH+IFTFh1MtdP5mb8WuXy3H4/zp96T9vHC2n7oOu/+E=;
 b=IDQuvb5U5PeOW7lufHr9X41OtWO8Mf2A+P/WiLN5OkTS8o9an5IGhF3qPRxCXRfzLM79eS6qd2/72eMLvtsq8qRtWDp7GvBl+fHFlnA5aHjwCXn+K/fBEgw9JB/Pm9d2qoRQqQhpgt+zy2XY7oyk393ZJaY4XNr0uePJFbSYs1Q=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1323.namprd21.prod.outlook.com (20.179.53.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.9; Wed, 30 Oct 2019 15:32:06 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 15:32:06 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net, 0/2] hv_netvsc: fix error handling in
 netvsc_attach/set_features
Thread-Topic: [PATCH net, 0/2] hv_netvsc: fix error handling in
 netvsc_attach/set_features
Thread-Index: AQHVjzcvjnsDJtWSIUabk6TBDOaP1w==
Date:   Wed, 30 Oct 2019 15:32:05 +0000
Message-ID: <1572449471-5219-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13)
 To DM6PR21MB1242.namprd21.prod.outlook.com (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 453eb235-655c-49d4-2cce-08d75d4e51c3
x-ms-traffictypediagnostic: DM6PR21MB1323:|DM6PR21MB1323:|DM6PR21MB1323:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB132391983D7D82151B32DA88AC600@DM6PR21MB1323.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(366004)(396003)(346002)(189003)(199004)(5660300002)(2906002)(4720700003)(54906003)(110136005)(71190400001)(71200400001)(25786009)(10290500003)(8936002)(22452003)(2501003)(478600001)(6512007)(52116002)(4326008)(6436002)(7846003)(6392003)(8676002)(81156014)(6486002)(81166006)(10090500001)(486006)(476003)(66446008)(256004)(305945005)(2616005)(7736002)(5024004)(50226002)(186003)(66946007)(26005)(64756008)(66556008)(66476007)(6506007)(386003)(102836004)(2201001)(99286004)(3846002)(316002)(6116002)(66066001)(14454004)(4744005)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1323;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ZA3lF1VaMNluhrreh5jJroqa+vn7whiliEDetj7YQNjhJp+Keb/O7T8VLlxHrJ/S29mP6QaTkACN6rhxQkwG0mCnGO8kWmWf0MwHxKuOU38gcn2qwzFLVXi7/Z2vF7IurITQwoxFFdN93kvV+6oX7moPWgn/Ohva0nBUG9RiqPP5eVnjOCerNrcagBjo8LUcCT5EWM1iCqqrnv4eGwyytXAM/asZxmY9THUVKgiVUzDzhV7UeULOKIqifJL6hFTbmtS6a7Z3BnnV/hh9ssRIXhsQki+DiYx+e92k5+93jl9jV2o9odNHVAug5qevww+OMuFclMQGceGGyvA2/3J1C1yrg51AqmEXD8hHMeZY4FivP9cmDQXRJnvzV6u6ZWiFW7uGwrVCDZ8EB1KbCBsyqMI0U5s/GASvkjRFBHxwGttvn2y8xW5E2lQSPursiXS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453eb235-655c-49d4-2cce-08d75d4e51c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:32:06.0200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PbRgHlcc9EyR+72ffM/FdW3BdruFUrGvmtx1gY+WpE6omR0oBhYlD64usjarz0vIwW4rJQIK8HCgvyHngeGzZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1323
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling code path in these functions are not correct.
This patch set fixes them.

Haiyang Zhang (2):
  hv_netvsc: Fix error handling in netvsc_set_features()
  hv_netvsc: Fix error handling in netvsc_attach()

 drivers/net/hyperv/netvsc_drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--=20
1.8.3.1

