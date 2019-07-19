Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAD6EA41
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfGSRdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:33:55 -0400
Received: from mail-eopbgr720112.outbound.protection.outlook.com ([40.107.72.112]:31709
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727850AbfGSRdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 13:33:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZORznNMZmwiWsMe/Ff7TZ2c38m9autV9X7T+N4L/NN0/xTK+Wfg3C/DXHsu5P9LHaRM6/TMWo+6nb+kQayaaCtZb+uOkg85nxPYhcIdqJ0PY8k/kp4SLrIcN5htb7RUGy6TPgDLOHyvUq5pXrhILoU0RSVgZptqB4OPFhf099qQHivL9chH182bA5WsqEr8vqt5GjjJejOYN0WBMD5BOYiNgJwh7afalJfR04J3taR9PKQH7efQwXbY3eIQIYPOnaN551re5R0XO7VTYKmMWtSpfdNUE2TUYalEkcX67GYbf8WlB9V2q47Uhis/9GskV0jDPvNsgAtkuIXqsyvGSiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISBpmTld/0RI0g5vNVgx3TACni6otPCXp2fENFWSXB8=;
 b=EWhdWkjym1ruTW6iixpiazFZwOyCdiguk87asO3ThrrkmQGBhor259gC5M5DiiD6tu7s+Huu+o71USgOZ16HIuA9rbob8YqYOILclKEr8mw8fYhoEhJsBLkZj2CuMJ9WjHL5T1baO4WBGJhr5a5Mm20eW1SfmBQImcHc7KCRhPBMa0OFHEVodJ6ie5XYGg9fj1tAG23/NidLH2lCKspJ4CdcCtlzSM8ClSVPtfWEgL2MVd/cieOscCrCgHd4IHnpNF5eGO1yu7uznvr2OScbHPbdCco3/n80MxYZNgQwOcX5VGJ1m1yMlhnJcUUJm4oE6TEUPQcbapE6qdV6dDtmfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISBpmTld/0RI0g5vNVgx3TACni6otPCXp2fENFWSXB8=;
 b=HNjhuoaoJcnJorCilzeOOU1rWli4tJTyMiWcKb0mVCkycHf3wLq2Vw0n4qmUhrn+caH7iMS4Q65tQxnSetnqTZPVhogqa/6oSpeD1Aae276Nia8nK0aUVrEhw8Sr7TgzopUjyO4Q8U+nxafztPT8J3nnED+eSxPpmxga1EeAdFM=
Received: from DM6PR21MB1242.namprd21.prod.outlook.com (20.179.50.86) by
 DM6PR21MB1290.namprd21.prod.outlook.com (20.179.52.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.1; Fri, 19 Jul 2019 17:33:52 +0000
Received: from DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::6055:de8a:48c1:4271]) by DM6PR21MB1242.namprd21.prod.outlook.com
 ([fe80::6055:de8a:48c1:4271%6]) with mapi id 15.20.2115.005; Fri, 19 Jul 2019
 17:33:51 +0000
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
Subject: [PATCH net] hv_netvsc: Fix extra rcu_read_unlock in
 netvsc_recv_callback()
Thread-Topic: [PATCH net] hv_netvsc: Fix extra rcu_read_unlock in
 netvsc_recv_callback()
Thread-Index: AQHVPlghcMnY7sIqPkOgR8UytHrZ6g==
Date:   Fri, 19 Jul 2019 17:33:51 +0000
Message-ID: <1563557581-17669-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0013.namprd10.prod.outlook.com
 (2603:10b6:301:2a::26) To DM6PR21MB1242.namprd21.prod.outlook.com
 (2603:10b6:5:169::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 2
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbcef387-5553-463d-e35a-08d70c6f43cc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1290;
x-ms-traffictypediagnostic: DM6PR21MB1290:|DM6PR21MB1290:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1290C5ECD01E498BDF4098F7ACCB0@DM6PR21MB1290.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(2616005)(50226002)(8936002)(6116002)(305945005)(81156014)(81166006)(3846002)(7736002)(66066001)(68736007)(476003)(5660300002)(25786009)(6436002)(7846003)(6486002)(36756003)(6392003)(2201001)(2906002)(4720700003)(478600001)(4326008)(53936002)(10290500003)(52116002)(6512007)(4744005)(110136005)(8676002)(102836004)(6506007)(386003)(71200400001)(71190400001)(26005)(66946007)(66476007)(66446008)(64756008)(66556008)(54906003)(14454004)(14444005)(10090500001)(256004)(99286004)(2501003)(316002)(186003)(486006)(22452003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1290;H:DM6PR21MB1242.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MDjGXvmaq6LXYCwutbSN0svDG9lMNK3ExYsntiRp9bribR9O03+4vSIIB5H6l5FFgRy3LUrUuS9KIHLBaSBueKxLQnc3wQ7lvVoYabXzOZwv1nO8QrcqEF2+58YXKC8XgYMazLt5kBceSscyWmR9A61cxA6dTUPHStZC/IhzTdKazCJG+2PEc2OnXc3gkMf8aowcB561UX2PwP9wp26vWCTIICT6iF7uJwuz1CLr9ArTmk+pMr8yGaHCxMdqz7jnuEFAO7FqpPjeUU7ru76ZIZv/8Gg6etUP9p4bk75uNXdcwe9vXyh0oSx2woFdSefDB8URJIvwnGVP1PDbONWktwFLZKiuxMTQoj90+EVOcZJSqRqMar4rFc7kkUCT5uTf8zOeiSoBrv52F9oz+a8WvpCV7rFwq2rneGsPsPtUl6U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcef387-5553-463d-e35a-08d70c6f43cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 17:33:51.8286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lkmlhyz@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1290
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an extra rcu_read_unlock left in netvsc_recv_callback(),
after a previous patch that removes RCU from this function.
This patch removes the extra RCU unlock.

Fixes: 345ac08990b8 ("hv_netvsc: pass netvsc_device to receive callback")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index afdcc56..3544e19 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -836,7 +836,6 @@ int netvsc_recv_callback(struct net_device *net,
=20
 	if (unlikely(!skb)) {
 		++net_device_ctx->eth_stats.rx_no_memory;
-		rcu_read_unlock();
 		return NVSP_STAT_FAIL;
 	}
=20
--=20
1.8.3.1

