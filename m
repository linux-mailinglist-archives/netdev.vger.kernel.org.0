Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B411E9F1C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfJ3PcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:32:14 -0400
Received: from mail-eopbgr770111.outbound.protection.outlook.com ([40.107.77.111]:56743
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727297AbfJ3PcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:32:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilZQPTy/ppTy4wI+cn682bkT20oeLKOggSgx/fVq9eQDD8U+4+sDfKnL4kTHjJDjwyUFzev+SVCyqlwOMGSXNyFDFIwovbzgf5RSfpVgJ8C2FWe0CwlkoVwlF2soZjws6hbECA0aD9evoejq76KrbKLT2nAcd8Qi2Qwg8wtPHnKkcc/sh5vy6i6wPduXOBqSVg55rHT/7wluoXVkU+ewIiuS2C6hpgF6MPrncXRPNn8MiG2T63k4XMYRKE7ckJWpKBlLKR66GhCS6WrzTwdaCLMd5oCKL/QDKi5HbQQF+BZBBN9b2AZzhJBRGWtzn0MPvlRY3B2Nmbkdk8ZRE4wO1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hev7w3w9cjL2lfPvS3vqONu1MIvPnz/3BL3sv8hG4Y=;
 b=fP9aYJnlF75nMwXmC0VfIVQt8zcxovvj+XzraA87uQqoOG1JFYCUr69WfxO5S7eI5oa7zNbI+QqsazA7Dksdn5LW6+38CU3qt7cW34qMVCT1zYIke3wzj8Q8t7fWLBSE3ASVXb1ZNpscztjAGOPCLVC5xtMA9feNeV6tWy1MIrxk926lJN5wrXfuR77ZCVqJxAA20j8DbXFdVo/b7/hpqfbtvuRvdKX21ZU7k+z9r8QzRSviDFYNnf8XA3aa0Ak9/rG3BgJKqRRMryjeZr26ud15RxyMrrF8VTLbhU11eZeORZSLp2jW5xLVmx1Zf1nP/c5Knj1pO92IIvk8BkrgPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hev7w3w9cjL2lfPvS3vqONu1MIvPnz/3BL3sv8hG4Y=;
 b=d9DgUU8qYe6d3N12RfBlg89dymZpK1VlzIFHj293oZ8b1eQpo31xKs9Tqfh1J2Cgn0qnORJJ+P2+o+606WHWgfk+VXlkojBznvLL9cS41PHUKVnolQUn4DoMu6NdHKFaV32syLiwjYQCRIrBDjPgCJKvbZ2Vo0/a0xB8rjv0QPE=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1323.namprd21.prod.outlook.com (20.179.53.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.9; Wed, 30 Oct 2019 15:32:11 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 15:32:11 +0000
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
Subject: [PATCH net, 1/2] hv_netvsc: Fix error handling in
 netvsc_set_features()
Thread-Topic: [PATCH net, 1/2] hv_netvsc: Fix error handling in
 netvsc_set_features()
Thread-Index: AQHVjzcyK/HK/BI/q0K1iD1yxR2O0g==
Date:   Wed, 30 Oct 2019 15:32:11 +0000
Message-ID: <1572449471-5219-2-git-send-email-haiyangz@microsoft.com>
References: <1572449471-5219-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1572449471-5219-1-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 7f4435ce-7fbc-40e6-4288-08d75d4e54d6
x-ms-traffictypediagnostic: DM6PR21MB1323:|DM6PR21MB1323:|DM6PR21MB1323:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1323DE2271360E97550FE27AAC600@DM6PR21MB1323.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(366004)(396003)(346002)(189003)(199004)(5660300002)(2906002)(4720700003)(54906003)(110136005)(71190400001)(71200400001)(25786009)(10290500003)(8936002)(22452003)(2501003)(478600001)(6512007)(52116002)(4326008)(6436002)(7846003)(6392003)(8676002)(81156014)(6486002)(81166006)(10090500001)(486006)(476003)(66446008)(14444005)(256004)(305945005)(2616005)(7736002)(50226002)(186003)(66946007)(26005)(64756008)(66556008)(66476007)(6506007)(386003)(102836004)(76176011)(2201001)(99286004)(3846002)(316002)(446003)(6116002)(11346002)(66066001)(14454004)(4744005)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1323;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: smTdayxDFC0ZOBxnQRRPQES3b0/pGuuzWE8bdIoFBIQ+Rb0EVtVtU6cFmGKV+9ZYSej18A0m6uvQsCSwgaJzbikX4uHyNFyNtErYl9R9IYBpXpLbh8TOxYqYjZhPQlkD/5ZTH7zcouJgEA2eqMVUideyjhbWOXvBH9MRywMtEn5OM3DnvR40ZqL/Psis6gQ6kJsXzeB9ztrlJBp7zIli7dOl3VUpDK7ISXKULz/k5/f1SgyHMP14lVmA/9okqDAMcQv67po3yLOiCnbb6+tWzOtf//pmnw7BTuL/DrZMyW9Xy3BuR60hOddSDUEGq+Ql9SBJ279SDOhsDD0EtWqsV1+tqew2lgs3hWByMjtPNixoXKl0OP8svK8i00jovOh4El4hVndi7VpkirnebT8VvRc/dH1nHk+CDl9TwEfecrqlGEOkcgPx2JErT8WZQHUK
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4435ce-7fbc-40e6-4288-08d75d4e54d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:32:11.1672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9LcDnnwv/ilIgnt9GEKc0WnqzF4L+DeOz0kQyYgdmXfEG7Oe/OCg3X+M1Os6Zc3vjMIb/XTQocsgw0wxixqxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1323
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an error is returned by rndis_filter_set_offload_params(), we should
still assign the unaffected features to ndev->features. Otherwise, these
features will be missing.

Fixes: d6792a5a0747 ("hv_netvsc: Add handler for LRO setting change")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 39dddcd..734e411 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1807,8 +1807,10 @@ static int netvsc_set_features(struct net_device *nd=
ev,
=20
 	ret =3D rndis_filter_set_offload_params(ndev, nvdev, &offloads);
=20
-	if (ret)
+	if (ret) {
 		features ^=3D NETIF_F_LRO;
+		ndev->features =3D features;
+	}
=20
 syncvf:
 	if (!vf_netdev)
--=20
1.8.3.1

