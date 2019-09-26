Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557DDBEDD4
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfIZIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:50:55 -0400
Received: from mail-eopbgr20136.outbound.protection.outlook.com ([40.107.2.136]:40672
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728138AbfIZIuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:50:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg4S9HMETM9aYEgLIzaWpebCRsexab/6mTtPRfuuSUAjEyQqCe3MXQMVlrOckVjvDoho1C+GfERQ+MJUQ+axD693rrcZlYiAnBP3xxDnttKvcIiDFlB25hiOX4DZStE7JTdWaXAYDFzzW183iQHD8+r0+CY5uHN3m8El7eiqMStxOc2RjMsmtooT3GkR0MKhrCQQsHgvYQVP/aVVJVWjoqfE8MBDM3NvvLb9Bt+rC1jX/egjAQfnSTkoIZyVfh1HvgZFxqEKGNs3+8Y/6gerLR5gvb9hQW6B9nt0lG0+7HGUHMz5s7lOOnKGBZlEgzNpygiM/A+v9v/eDwCB1Fk5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjgjRvBII55wK0heY11+LtK3tTjCxkN9i6QBHWCKhV8=;
 b=j6jIq3/b51xbXVNxOMV6Mx8pvpN0Hbb67yoExWlMoQGR/6HdukZgrhCrAttZ16vB6oEC/8Aga1rXBCDHqWFRXyv+PKERLYyJ6fomz27RBxp8527pAtqroywvMdWrORtb1ZTaQ8GqZ9KzbfZVk75e4s2NCzOigDrwxLV2Xtmx8Dkx2GAwsRv+adVbCez78L78bpg9AFnCiPU7NJelGq4sFDfEhubi4hrZtEIA50X8FbUMdwq+jJ3wzGMaAZPkI1hHWkhr6Ftg947+6/jNshOydwloFRoR3TebJSjGwuo/yr2rZFoYqn6ndcuuUaWkOpX+EHG53AEDHBW8c8o4GYymaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjgjRvBII55wK0heY11+LtK3tTjCxkN9i6QBHWCKhV8=;
 b=dvIb6VXs6VdfDmZY29T49qP05jj/rS9Ty82CcFa8vp2lMmq7VkL1PwEchHrNnQ1EEvwfcabDRalrUje/IC9DxyfROeuHTp6QGhDfqjHG6ue1FJt8I4XYzZYIr87MYNM6f3vMQ3tmNBCvEVM8kynllpoDRTGhS+JBcatNO+DBQdU=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2144.eurprd07.prod.outlook.com (10.169.137.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Thu, 26 Sep 2019 08:50:51 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.017; Thu, 26 Sep 2019
 08:50:51 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] can: C_CAN: add bus recovery events
Thread-Topic: [PATCH 2/2] can: C_CAN: add bus recovery events
Thread-Index: AQHVdEd/zjaw3kBMJka/V+TNHW0MWQ==
Date:   Thu, 26 Sep 2019 08:50:51 +0000
Message-ID: <20190926085005.24805-3-jhofstee@victronenergy.com>
References: <20190926085005.24805-1-jhofstee@victronenergy.com>
In-Reply-To: <20190926085005.24805-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [213.126.8.10]
x-clientproxiedby: AM4PR08CA0074.eurprd08.prod.outlook.com
 (2603:10a6:205:2::45) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fbff855-7b8d-4f17-0341-08d7425ea222
x-ms-traffictypediagnostic: VI1PR0701MB2144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB21445409C22EC328559AD074C0860@VI1PR0701MB2144.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:138;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(199004)(189003)(446003)(14444005)(50226002)(99286004)(76176011)(8676002)(81166006)(81156014)(52116002)(2906002)(14454004)(186003)(8936002)(478600001)(6512007)(5640700003)(6486002)(6436002)(66066001)(2351001)(102836004)(26005)(25786009)(1076003)(4326008)(2616005)(386003)(6506007)(486006)(86362001)(54906003)(316002)(2501003)(5660300002)(305945005)(11346002)(71200400001)(7736002)(71190400001)(3846002)(66476007)(6916009)(66556008)(64756008)(66446008)(66946007)(476003)(256004)(36756003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2144;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t1A1fU3IwAdPWdIjJsW2/3yBLpH3lLVHA3kuIBxLoXNc+nODNKJwlM6jbMkVSGeNCC+1Q3JINUlhGtoC50oCQ6x+qfkMEHVFQomYHL2AmQGS8zVfrszCXJmMa3+shCh7vDmNbeV6o3TL19rTFg/HOAhIehDJw69a+48Ncs33jaS11sHTF4KvZhm5VhO5gHbgZ4/ccDE+8PK1nrIOb+VNtNrL6M/qxRo3n3qk+jXoTrQDIMpxpnjuY9j0WxNCJC+iQo+cRjaE6nRDBKtyRjdQPKMx/Vruhoq9ey2LrlhVGwP2jrTXqlLzvjuC4CGg47geBas8X/tqT+fB5SSmDPCrb0T0SD64fcCbtALc4oOGvTstTiZXVCAuntMutRQTI9MQ+o08e/SgjD8zIwL1Ih4c2r7ufAEmk/1crH5V80/XKpA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbff855-7b8d-4f17-0341-08d7425ea222
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 08:50:51.3120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NV+qaWnoCx4/XgQdwkGcN9d5EakyNb+hKEyjBS1rCaWTF5oJYXnZ9ThAz/IGgiKGSwgQoPfD9xUAiLOl4fc/teuYl3xFK2VNpiJziuMQ688=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the state is update when the error counters increase and decrease,
there is no event when the bus recovers and the error counters decrease
again. So add that event as well.

Change the state going downward to be ERROR_PASSIVE -> ERROR_WARNING ->
ERROR_ACTIVE instead of directly to ERROR_ACTIVE again.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/c_can/c_can.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 502a181d02e7..5cfaab18e10b 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -912,6 +912,9 @@ static int c_can_handle_state_change(struct net_device =
*dev,
 	struct can_berr_counter bec;
=20
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		priv->can.can_stats.error_warning++;
@@ -942,6 +945,13 @@ static int c_can_handle_state_change(struct net_device=
 *dev,
 				ERR_CNT_RP_SHIFT;
=20
 	switch (error_type) {
+	case C_CAN_NO_ERROR:
+		/* error warning state */
+		cf->can_id |=3D CAN_ERR_CRTL;
+		cf->data[1] =3D CAN_ERR_CRTL_ACTIVE;
+		cf->data[6] =3D bec.txerr;
+		cf->data[7] =3D bec.rxerr;
+		break;
 	case C_CAN_ERROR_WARNING:
 		/* error warning state */
 		cf->can_id |=3D CAN_ERR_CRTL;
@@ -1080,11 +1090,17 @@ static int c_can_poll(struct napi_struct *napi, int=
 quota)
 	/* handle bus recovery events */
 	if ((!(curr & STATUS_BOFF)) && (last & STATUS_BOFF)) {
 		netdev_dbg(dev, "left bus off state\n");
-		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_ERROR_PASSIVE);
 	}
+
 	if ((!(curr & STATUS_EPASS)) && (last & STATUS_EPASS)) {
 		netdev_dbg(dev, "left error passive state\n");
-		priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_ERROR_WARNING);
+	}
+
+	if ((!(curr & STATUS_EWARN)) && (last & STATUS_EWARN)) {
+		netdev_dbg(dev, "left error warning state\n");
+		work_done +=3D c_can_handle_state_change(dev, C_CAN_NO_ERROR);
 	}
=20
 	/* handle lec errors on the bus */
--=20
2.17.1

