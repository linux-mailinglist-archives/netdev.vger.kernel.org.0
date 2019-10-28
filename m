Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013B8E7AF7
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391177AbfJ1VHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:07:06 -0400
Received: from mail-eopbgr690126.outbound.protection.outlook.com ([40.107.69.126]:40093
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390260AbfJ1VHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 17:07:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXAIvhDmJMc3oGABXiFPdY3P6Tgz8PfxXPxg+ALbxBBIJ7TIuft9BupIX4hIPjOJ+PrDl3MLwS+4PnfKLvIj0rLxC6btTBu/GpUfuharbQEv5yLxzMmtqb8UmT0gZMOHXH15Y0HpfvYHHD3Kf/sq04EiaZk/4DvmpI90Vwq8YuF/yqfwdJ4ODLecPNJItmn3GsfH2Vlh97u2SViSDgda3cIg3Z18rgWDZXEiZ+yeAXvD6FnWGGVwuFzKvkNczzRVrDV+E5iOlMm5EcW4SFJEIifrblulZfFaU9r6xZ4NnVNZarS7LrlWWBdaYq0tRiuHtP2oh5Y6ALVSrRSYYIoOKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu/WBYk6iHDxjDjFlbiieOrrFMHBcVANvZq8rQv20f4=;
 b=btKYUWPKh3akNjcHAvLKRCiDSAx/DMIttSxkrEWEh9kBIljMqWQgYcALDdLlyyMPgUeILqbKLH126zPtnLBQWUsGy6fZ+utZcG6rg6EdVcMEWCcNAU249lkwepRU8YdBhnFr2gzE85HcSswnDfhc1Mtc7gte2trcCNoBCRpClN7NrOfr6V7AJZvpPxMCKYEEwexvp8PisxQtYHN0OXsITD6m1zOEfOfQSg5WkOo/0Ud0lanNVpES8v+9tkvqFBOsQc9EH7QS9jTa51GjtSMVvrhAwHO5skBjj+D+S/UCi6cdwGItt9CDsJJMU25YoyRPko/ZddLHWF27sYW1fDhyKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zu/WBYk6iHDxjDjFlbiieOrrFMHBcVANvZq8rQv20f4=;
 b=TJJNxgMC0XR7vcRCrHS5ZjIukarIQpLttENieyOLK6IOYQO/HvbB9Q5u92PWPaWUP1oMJx/N+XuUn0upvcQoG/50DAiZkprH4gkgbA65zUXYXmBGrPxIuUBOG7K1eT1FFy7GIAnO63ygr+xvEmoc9YpZ6qtdnO6btFwBz3hKtpc=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1404.namprd21.prod.outlook.com (20.180.22.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.8; Mon, 28 Oct 2019 21:07:02 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::756e:8d3f:e463:3bf7%3]) with mapi id 15.20.2408.016; Mon, 28 Oct 2019
 21:07:02 +0000
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
Subject: [PATCH net-next, 2/4] hv_netvsc: Fix error handling in
 netvsc_attach()
Thread-Topic: [PATCH net-next, 2/4] hv_netvsc: Fix error handling in
 netvsc_attach()
Thread-Index: AQHVjdOloR6XUhgHdkmYgWUWbZAKOw==
Date:   Mon, 28 Oct 2019 21:07:02 +0000
Message-ID: <1572296801-4789-3-git-send-email-haiyangz@microsoft.com>
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
x-ms-office365-filtering-correlation-id: 81938abf-192d-4c48-81fe-08d75beac7a5
x-ms-traffictypediagnostic: DM6PR21MB1404:|DM6PR21MB1404:|DM6PR21MB1404:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB14043A7B184EF96A3B74F7EEAC660@DM6PR21MB1404.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(189003)(6512007)(446003)(36756003)(54906003)(50226002)(486006)(22452003)(2616005)(476003)(305945005)(14454004)(478600001)(2501003)(6392003)(66066001)(7846003)(66476007)(66446008)(64756008)(66556008)(66946007)(10290500003)(6436002)(386003)(10090500001)(102836004)(7736002)(99286004)(11346002)(76176011)(52116002)(5660300002)(14444005)(186003)(26005)(6506007)(256004)(5024004)(8936002)(81156014)(81166006)(6116002)(6486002)(3846002)(4326008)(8676002)(2201001)(316002)(110136005)(25786009)(2906002)(4720700003)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1404;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VIcAzIrAC1xXzKSTbeRDTpmESAe1xHgqKSLh4tj4diReB19gz4aoX7uh7dvWo7fnLIzedhyMuyWijZn5dsiPc70aAjHk7zcUYbtRKF4vKMUT8oFCdzu+VhHloSd0wkr23sA0XnLw3prRj5L4J7P8gYNDN73DetL3AhLz4g+RQ5RILkayMz4L99CzfHY5ijS8IH528O2flPD7ro4E/UEBD3NY45u5hZIpS/0e/sKv7ee19sw3SBUUNQTpOzPkHaXRudDuxfMX4Qd1nJdVy4S0jPrjPOVq2JT2pCmf3zmXMvoYr/mifyjwpGkLwENi/raOZK/F0UIeXARJ+9VvSjRXGw4MwunROTvxdt7hkyGZS6XhPRUHzWXg7R70zscuIL9OctqbQBCHsmUWBwKRMH/97h0gmrtSAVuDi2Cao9AhLszpys4ZBGfC9FOi4J9K9WfB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81938abf-192d-4c48-81fe-08d75beac7a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 21:07:02.8121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xBZb0afAPqK0hg0UGNAYcpFSdDz9ZbwF/UQj916u8Be4hTxcFWz7YRw1zq17o4cJQuNbOvkjnQWX73cRR34kgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1404
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

