Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 859E9E7B0C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391160AbfJ1VHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:07:04 -0400
Received: from mail-eopbgr690114.outbound.protection.outlook.com ([40.107.69.114]:46142
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727689AbfJ1VHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:07:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/Tp2xrfiJrLfPm0qtc/Pyz2MUwhtb+8SF5F7Jh3wLXxUsMJBp0NgNeZ42X40YJNNcfgl68dG/LmAW8EN2EN2zzlX5lwcBMKgt0Hgqwvg1QIyHFdRGw03cFw9mhZ/mJdgxiJztyBP1FaZ6rypj1af1Q56QiLekR98YtUKz8tlpPMY/bRM6fTmKivuH7tfIEGFizGw+3cF86d6488fk1TJQIRzVswtHWMy/4xgZ8ukuCmmUxPqRmTQhZEZKir9Iv7rHW+7lRd7FjISq9Qu6yeKpTNM0e/bxzfzq/ipgi+a1dPvc62GHdJy5oJ7UYThCDugZ519y/Teh07T3xbZFTdYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hev7w3w9cjL2lfPvS3vqONu1MIvPnz/3BL3sv8hG4Y=;
 b=Fv6fMm3SW9apAcgnSOoVY/VDKNoIvV5KxMwV5TZNv2g22zKvca3XDbN2QVSQ2OlYzmMwEMsT1ij8Vwv/dWMnq6PMI+vEvpU+vFwBzxUf0oUTwB1mE9Yan4Y0hMLPZOF/gO3qPdzZgjBj9nRvjmkYqH+b1jjoOgxlAhJi5qjZ2yw+STh2GCQNKrdIVJljZEnOO1m/hTzPIZn85XLKVb18WyU84sOUvEo7Nzxb0d5RzuQOGmG35K9VfzxUMkxvPQxa5C9BU8Ds4vOdmvio/ZKo0YzgP8bQkzmoU4Ao5GKJQf/G3woOIO+Ct487lcu9Ub7ZCq14ImWGdin2GVC1Zd9fgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hev7w3w9cjL2lfPvS3vqONu1MIvPnz/3BL3sv8hG4Y=;
 b=LAKtQVm6sjztOniGN+vD4k6ND6NUpL+as+6UYYDVSI+bT3lrX4jui7FdxGukkacvAEmq5YJzuA6l7SxLfmoIBK+DcvRGZrQtc24AWkrP4iU+GXfZmRmyZaqNFQlqEw0Y3ac23va5qmqwYaAMHNSNcVap042eR0uDPUOE8oyqkqI=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1404.namprd21.prod.outlook.com (20.180.22.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:07:00 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:07:00 +0000
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
Subject: [PATCH net-next, 1/4] hv_netvsc: Fix error handling in
 netvsc_set_features()
Thread-Topic: [PATCH net-next, 1/4] hv_netvsc: Fix error handling in
 netvsc_set_features()
Thread-Index: AQHVjdOjYlIhZIotN0y++mx45ndm5A==
Date:   Mon, 28 Oct 2019 21:07:00 +0000
Message-ID: <1572296801-4789-2-git-send-email-haiyangz@microsoft.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:102:1::44) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dff32482-79dd-4a36-7cbd-08d75beac642
x-ms-traffictypediagnostic: DM6PR21MB1404:|DM6PR21MB1404:|DM6PR21MB1404:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14048E7E296802D280E712F6AC660@DM6PR21MB1404.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(6512007)(446003)(4744005)(36756003)(54906003)(50226002)(486006)(22452003)(2616005)(476003)(305945005)(14454004)(478600001)(2501003)(6392003)(66066001)(7846003)(66476007)(66446008)(64756008)(66556008)(66946007)(10290500003)(6436002)(386003)(10090500001)(102836004)(7736002)(99286004)(11346002)(76176011)(52116002)(5660300002)(14444005)(186003)(26005)(6506007)(256004)(8936002)(81156014)(81166006)(6116002)(6486002)(3846002)(4326008)(8676002)(2201001)(316002)(110136005)(25786009)(2906002)(4720700003)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1404;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 150dfI15io5Iip/mixFvqsCLuDRsOmAXa8QxxfKBzo6bNGGE9HG6JD+Wjo/+XpIXBOfgLLNiJP85Jwjjl2kPxHEqMc3nrJHMn8Y/0SSS+okppB3l4hZ2/aTq9reRMVj4ZTTMlB7ApqZDJqWR+z9IOjgkjd+ZbT+C88AHMsl42d5zYwXw7n8nLoghF4BdIGayhwLvLlUpQ6MTfFAxUGR5nQbN3U6s92KivB1fIZ5mWZtYFXiFMCsk8cN/phaQc3070BAO5vkFUwIm6S2pr3QI0FOLWINrr6X5SqGXyqXRQvQHqlbrMl3F59851AlHpKp5cgypTyN/7kqDqOw/U4ySVDrISoVSB3rVYEqe5yIdYPI7BSRm4da/ceScCWtAqNWrUiuaxmi+iNVu7GixZf2e8ox/a5rVqr5L+fOLSfWLr0GP/04OEzAKeqRBS6AzPsLG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff32482-79dd-4a36-7cbd-08d75beac642
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:07:00.5603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YxgnShzQfIC8LSjQIt/C6S9TXTev3oe1GA3JdL73gPYzjMvIjyOv4nt4iWj7Vmd8UAxbTePN33/BsdWxrbsysA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1404
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

