Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3576F441A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbfKHKAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:00:48 -0500
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:29575
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730005AbfKHKAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 05:00:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1ie9IEP16tTLjZKjc3a8WCaS1CmPbiTYA+dJHvv6y/ucGJ+GtiY9QvSNFR+ldt0cYR0op+MH9wUxl0+Ew/IokHC1KT/RaG6TUe5+zjnTl5I7/4Vc99Wang5DNDN0YU5Vl4oTcK1xRK1VeX06Z+e7YT6Nmqpmkref1lyzIM1TmPizfohhM4g8F/qwpWkCLt8eXa9ZGh4Uxu/PF6Lxvjo5ZqBXeLIMw3bORFTy0TL8ae21FZuPcmCrMh5L0MnPCJu3xW7LL3hsPadSsjxyAy7EUB9/f02SK7MNvZybVTm05Ngv12XdVBHo4jQu22dKFeHYNOxkDe5gs1Cub+44A+M8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL9CPbDDgnIF6Bg/Rs+PInzYjVn0IoSAwFsGBNsT7SQ=;
 b=JxanZBcnH8BKKLsrXC71SOFswVC626/9jI3g7TN7vNNEybjDX1VUyIByk3WfA5v4gfe1k+wfxX20kUh4WbQ7CumJJcDghLdiL5cFKWIhyKJCm97+P2oiGSP1EsZsgoRyt7ITrqXbnDOO8g8BG5qvhfLHoUBfDxwQe8bDAEN2Bhub54o0JhVsezgCuRXNipbtcjX24T/R24tUB+Cjjxxe3gR10F18/hJ8U1SB7ejCgGdWQ2uHb5aftEto+BKb7jSErcoCWe/CB2KO82Ul4FMQ7JNZ3vrflnZxfzAylWU+yNlgAwBlULN/XoybwG0C2QEjFjYJ/tiZvtVMtFig4ijOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL9CPbDDgnIF6Bg/Rs+PInzYjVn0IoSAwFsGBNsT7SQ=;
 b=q3MFrorCM7so20ZhKtNoIG0RK/y8nIE39ExLarywVU/bK/GrhRfKUkw4xtOzYwbNjmxZMjefcbyI8mCJHue8r82IPSMJXJZKAymyTEc+yphh35GWvpkaeLlABQOApPxjVpO8kFAXHW5yFBM+PGiLTjTU1nCfaU80vCYBaMgBs8k=
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB6000.eurprd07.prod.outlook.com (20.178.123.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.16; Fri, 8 Nov 2019 10:00:44 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826%5]) with mapi id 15.20.2451.013; Fri, 8 Nov 2019
 10:00:44 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        "David S . Miller " <davem@davemloft.net>,
        Jarod Wilson <jarod@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] net: ethernet: octeon_mgmt: Account for second possible
 VLAN header
Thread-Topic: [PATCH v2] net: ethernet: octeon_mgmt: Account for second
 possible VLAN header
Thread-Index: AQHVlhtivsuLIS3ni0atqvgrcCJLyA==
Date:   Fri, 8 Nov 2019 10:00:44 +0000
Message-ID: <20191108100024.126857-1-alexander.sverdlin@nokia.com>
In-Reply-To: <20191107.151409.1123596566825003561.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.181]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1PR05CA0245.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::21) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2f036b5-2136-43c7-8a44-08d764328506
x-ms-traffictypediagnostic: VI1PR07MB6000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR07MB60009331B8DF3CDC7A980330887B0@VI1PR07MB6000.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(376002)(396003)(346002)(54534003)(199004)(189003)(6506007)(102836004)(71190400001)(71200400001)(386003)(15650500001)(52116002)(14444005)(7736002)(256004)(305945005)(478600001)(6916009)(36756003)(50226002)(8676002)(1730700003)(81166006)(8936002)(81156014)(6116002)(25786009)(6512007)(3846002)(99286004)(2906002)(14454004)(5640700003)(316002)(66446008)(86362001)(66066001)(54906003)(2501003)(66946007)(6436002)(6486002)(1076003)(26005)(186003)(11346002)(64756008)(2351001)(2616005)(476003)(486006)(66476007)(66556008)(5660300002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB6000;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pKamgxqV+ynLKB5VvT3xGc6w9XFtTyyjEgy7IDfsyVxdM2AqOniaqzPXm4DewSfjZl5RWAqv9lzbJ/HIpcVsa0jonQJQ50T4BojzZYirHi+onbaPJUaEcc4XT9C38DRsFvnHt9eQFdwhrjWJiR8wfw0+mDEwbsp29+sflcYGyE/vxMS0oN9bsTxaEctlvAPFH1fVT8SWR4bf8tJEU+tAdfhsSGy9KJXhYPX/RqUGCM8t41K8NyWO9os1qa6MYYWIK0p6tQNOSWWrXw9PZzQHC/ZxIlsXHE6Jf0U0yfR7zI5w9K/4MqENk8JkJvIux1nMhXG6qcLUOcLxnxGDt8MWbRvkwhrtqevt+ecD6+1Kpc+cuUt2J5VXralNKlHqzozYH2EX6j8adfKiRJnKofEB7h83PZuRof8qiyygQzrNYbTSckPIdIT8eoMjSjpXcEB6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f036b5-2136-43c7-8a44-08d764328506
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 10:00:44.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WaBCFgqskQRZsJoqyM5bIMlq1ao4g2eDVXWCdmBMUdEyjwWGT9iGZZ96JFjneTCSVacE7BhBJX0Wq6p92+SNLU+xvJY971d8682XAHpBG1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Octeon's input ring-buffer entry has 14 bits-wide size field, so to account
for second possible VLAN header max_mtu must be further reduced.

Fixes: 109cc16526c6d ("ethernet/cavium: use core min/max MTU checking")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
Changelog:
v2: Added "Fixes:" tag, Cc'ed stable

 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net=
/ethernet/cavium/octeon/octeon_mgmt.c
index 0e5de88..cdd7e5d 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1499,7 +1499,7 @@ static int octeon_mgmt_probe(struct platform_device *=
pdev)
 	netdev->ethtool_ops =3D &octeon_mgmt_ethtool_ops;
=20
 	netdev->min_mtu =3D 64 - OCTEON_MGMT_RX_HEADROOM;
-	netdev->max_mtu =3D 16383 - OCTEON_MGMT_RX_HEADROOM;
+	netdev->max_mtu =3D 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
=20
 	mac =3D of_get_mac_address(pdev->dev.of_node);
=20
--=20
2.4.6

