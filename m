Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6D3E9F1D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJ3PcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:32:17 -0400
Received: from mail-eopbgr770107.outbound.protection.outlook.com ([40.107.77.107]:37446
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727356AbfJ3PcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:32:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7rY27M9kkM42i+APQBywF+by8fMb+77J2eJ2u5oyU68Thca9q9oC1EOqkBYrBHcAVYYjl3bvTsehRcJ/KquzR0WpsVawseeX99Lb7o8aLpdTMnZyW3sbvroECVimWihL57i77Ez+XNBKYDYGs60qvENE0Z4KHMpx4ihqAXWFIBT9f13z7M5ufT41rHQS2e+J2q7N2DFeYQHIem34geMJn/78miYy8Mh3eAW6xYhiRyLaLONVJu3HPfccTZVHrL68VKGxyUZcOK75ss8Z/U5oHMQwq/6kzgFTorS6q5CEGxlF39U5x7UASz30qaNUIV4hpJY4Sj1W85FLHxrP7n47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu/WBYk6iHDxjDjFlbiieOrrFMHBcVANvZq8rQv20f4=;
 b=YKqEGVzarcsRLdJJEhzS3ZXRXzPNeNo0IvBAruQiwxqPZG+iypxk0fNYrTXxlaZn2ZkgZn7r8mH3mPl9cONJmTg7eWj/gbVoJoLydWA0Yhc+yGNKws8h5OnBYcUsySabuCgBf6xCpW4yw6XtNFJGmRhwemqUTQnNiwn/N9VSi11BaTYN0XDRKuuGAeO5vUwZ3R8vscQgvO5tJsV6LjcjdAuNCtKjpmyrmz7uqiobC/DrLv2A+f/uwd0JvsPM/R38+cQFgAtJ+JZYy+o7f6qt2AxSpo75mQfxqwz0zh/xhjG29WZMeBO9pvd30ODPPsARKT08Pot1bKlACOBZBlDk+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu/WBYk6iHDxjDjFlbiieOrrFMHBcVANvZq8rQv20f4=;
 b=SFaro0Ph0eLRvDAFbNmY/5EnuYjELj/C5GkdAGjuz0RTqUUFWWsJIzXmWAAEQHd0m7vjq1oQSuNQAO9zvXle+WneDjm5wMsC4RqyMNyK+MOZ3uR+42K8tGPN0UBaBn8RZdC33i8SHcpinqb5yRyTgUghAbkd5caoQMGVbaxH/Xg=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1323.namprd21.prod.outlook.com (20.179.53.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.9; Wed, 30 Oct 2019 15:32:13 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 15:32:13 +0000
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
Subject: [PATCH net, 2/2] hv_netvsc: Fix error handling in netvsc_attach()
Thread-Topic: [PATCH net, 2/2] hv_netvsc: Fix error handling in
 netvsc_attach()
Thread-Index: AQHVjzczuqsG+5QrCUWDw911uTLagA==
Date:   Wed, 30 Oct 2019 15:32:13 +0000
Message-ID: <1572449471-5219-3-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 0197f6b9-e245-4dd2-03ea-08d75d4e5659
x-ms-traffictypediagnostic: DM6PR21MB1323:|DM6PR21MB1323:|DM6PR21MB1323:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1323A373CDBFB58BCFCE8407AC600@DM6PR21MB1323.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(366004)(396003)(346002)(189003)(199004)(5660300002)(2906002)(4720700003)(54906003)(110136005)(71190400001)(71200400001)(25786009)(10290500003)(8936002)(22452003)(2501003)(478600001)(6512007)(52116002)(4326008)(6436002)(7846003)(6392003)(8676002)(81156014)(6486002)(81166006)(10090500001)(486006)(476003)(66446008)(14444005)(256004)(305945005)(2616005)(7736002)(5024004)(50226002)(186003)(66946007)(26005)(64756008)(66556008)(66476007)(6506007)(386003)(102836004)(76176011)(2201001)(99286004)(3846002)(316002)(446003)(6116002)(11346002)(66066001)(14454004)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1323;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWFCJzcEdcBGTSloI1df3qs0MeSjYxkluZa07UPw5b16u9SDjTY2tVFq7bt1YtoZ8A8ntC+NTJut4XrkTKA5Z6CvGObUPgz6PCV1tFSaoKUNwvKtAs2oKshEJ9Y4WNh55TUTY3oQKaZoEbDeo2neBu83oypkEfF1s4bMdHDFDbCs9pNjK7qB2BVp6J8epVws3GUVe6jRz3gtqW1HxwEyUvUQIUWtjHlZcw/77fbO0FQ/kg6lk7vTqugrDTiW7jvvXYTU1kWJYUO27S9rHJPpTk33iUTVE3ledGdzOWvoXh4MATealEPeQJMmozJs3KVfgLsWe5h/CATallzUGZAjRtfeyF50zohBioRH1jvAs5ItXU9+moH7oWb48Ag84GkSvwdaKm1LwwBVRtNFrOamVRr5a2ryMblNJ/eND9phtV0xMO8pit1KriSRgzys3eQx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0197f6b9-e245-4dd2-03ea-08d75d4e5659
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:32:13.6239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WliqyzkC1zF2GEzUWqvXmyfLrIIh3Oy2yrIo4F+bl9L0pmRk2jwwGTNW0j6LbR2xmurG64lDe+hItFHCnQ1xbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1323
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rndis_filter_open() fails, we need to remove the rndis device created
in earlier steps, before returning an error code. Otherwise, the retry of
netvsc_attach() from its callers will fail and hang.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 734e411..a14fc8e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -982,7 +982,7 @@ static int netvsc_attach(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		ret =3D rndis_filter_open(nvdev);
 		if (ret)
-			return ret;
+			goto err;
=20
 		rdev =3D nvdev->extension;
 		if (!rdev->link_state)
@@ -990,6 +990,13 @@ static int netvsc_attach(struct net_device *ndev,
 	}
=20
 	return 0;
+
+err:
+	netif_device_detach(ndev);
+
+	rndis_filter_device_remove(hdev, nvdev);
+
+	return ret;
 }
=20
 static int netvsc_set_channels(struct net_device *net,
--=20
1.8.3.1

