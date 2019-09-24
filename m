Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1841BD207
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441700AbfIXSqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:46:14 -0400
Received: from mail-eopbgr150119.outbound.protection.outlook.com ([40.107.15.119]:15758
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390679AbfIXSqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 14:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Drn+H4A5GxLcA50EKrRk8b+azW1U6Dq5fKXKXXemTuTK4uFji71hNhQ533Oga8j/9DaZRmM2zdQtNuEdAA1kX2VqWlwa0AeqZouaqJctmJnhGz9h5a2dgqOM5x9uXk/ztNq3FoVzDOF0KeHSxXdJ7VbI/Dt5GCsFCXg1KTpysoMj+X9OSLqlMZPbX/TJX13YGBeboJJ+lHiW869Aq/zGURYJdKXFV84ajLcs5xLC1hbnNDPikG2oU3dB/QHB9kxjN+k7i+x5Jck+3+HpwJHdgz24kOrGsn+7k7UbLXSmL7GfgMZg0L1O74IkwQppTtQNZyNp8Z1305KAhD+ByAuVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwY8tezXNIVLNywwqGqSH8eJ5zyugT1xZKwWhbi9z+0=;
 b=AaTV/yVKSJPUkTCxSOSCVwytl5tAc4ru56YujdB+Fkt+bGDNCL8qZUKYXGo2HYjdGdBo/3R2Dq23qSSimmGSv2FpW0zZpbkh/Ea7JUdZoFnSzIMFGu0U2YJ4MCfjXZgY6yGRPH1VhPheJN5Acap0CWd5LsNvDiUMf/vf6Ukl7cekwcjTdc0wT/LpuE70OAKmiEZeB3Q5P8pm1rgVZf00V/Sbw1eETJBZIJrhjnaCGUxrGc5SdslapJS4orgLZ0W44aOOeVQswyupJtZ7vWJDB1pUgb9N6ZMiX5AAJEZ6KSaM7o4Kc0cx0Z02gb9tqz8puXkwbp+ioVsabC+eCdCUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwY8tezXNIVLNywwqGqSH8eJ5zyugT1xZKwWhbi9z+0=;
 b=jtwqo5fF0l4l/2ODZ1+upcbR+Pdpi1MGMHwyH1Fl9qybgrMx7u9qUrmioGS6t5urasKqOhKZ5rgZ2RS/fVkygNhDY70d2ElJebEi+MlZfleUviA0b19rsytU250NR69nC6dDfGhyETAfPGYygZwLfvJLmXr6zuFcz/xbD1+hkMo=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2847.eurprd07.prod.outlook.com (10.173.70.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.15; Tue, 24 Sep 2019 18:46:00 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.013; Tue, 24 Sep 2019
 18:46:00 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] can: ti_hecc: add fifo underflow error reporting
Thread-Topic: [PATCH 5/7] can: ti_hecc: add fifo underflow error reporting
Thread-Index: AQHVcwhPovCmzM3DHUeCYFwBxYMOjA==
Date:   Tue, 24 Sep 2019 18:46:00 +0000
Message-ID: <20190924184437.10607-6-jhofstee@victronenergy.com>
References: <20190924184437.10607-1-jhofstee@victronenergy.com>
In-Reply-To: <20190924184437.10607-1-jhofstee@victronenergy.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:1c01:3bc5:4e00:c415:8ca2:43df:451e]
x-clientproxiedby: AM0PR01CA0139.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::44) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f987fa35-938e-4425-93b0-08d7411f718b
x-ms-traffictypediagnostic: VI1PR0701MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0701MB28476BAB609474E90C4216D1C0840@VI1PR0701MB2847.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(39850400004)(346002)(136003)(396003)(189003)(199004)(81156014)(86362001)(2906002)(2351001)(14454004)(305945005)(478600001)(8676002)(2501003)(36756003)(7736002)(6116002)(25786009)(8936002)(50226002)(81166006)(46003)(76176011)(11346002)(66476007)(6506007)(6916009)(446003)(102836004)(186003)(2616005)(1076003)(6486002)(66946007)(64756008)(486006)(476003)(66556008)(66446008)(5660300002)(54906003)(71200400001)(71190400001)(14444005)(5640700003)(6436002)(52116002)(386003)(4326008)(256004)(316002)(99286004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2847;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6DXx/grWZX9KomIVAOiIn8TPomlHspOQ3zow/5NFedldfiEJTv2/7r4xA/B/wA5aRUa6vGWXXrtYPjsrAN9yBFbxpiqJgt2ncSKmk8Bbt82qc2/r4pl2+P7VasbMNC6uIZt50ams3Jdl5qnAyz0LXjadzn4HQupc38f7fHwrIupFwAgY1lVrB5pdUR11VTUndXf8QXI6IDqCHakxH/t83154cZh2NnCAja3jXwYrY3hnPMSaZMpSQRZHez/rbEf2J2D32lHvlB/ggfKso8YxmyJAKSC8s6NLLB/F4kLlbx7mHSAoxyugFWjmzBUAHASu6l/D6z1ksDb7NK5XttDgvymZ3PodUyB2x6kQDJs5Zg8YYQbmkBCsU9/NF8r0o1F48h97PCKqySOQNZeTvcSKx+JXCSbMTTFeimJoaeHL7xg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f987fa35-938e-4425-93b0-08d7411f718b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 18:46:00.3077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ertFOhHpUz9qa5OfeFcLtG/rPXCkh2PrhBC2AbUkpq6fzH/qoQl8KEHwgoqCPYdG/vRceIucalg4Z3RQDkU7b30av2HmEnO1cYoqWMiN7x4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2847
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the rx fifo overflows the ti_hecc would silently drop them since
the overwrite protection is enabled for all mailboxes. So disable it
for the lowest priority mailbox and increment the rx_fifo_errors when
receive message lost is set. Drop the message itself in that case,
since it might be partially updated.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/ti_hecc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 35c82289f2a3..4206ad5cb666 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -82,7 +82,7 @@ MODULE_VERSION(HECC_MODULE_VERSION);
 #define HECC_CANTA		0x10	/* Transmission acknowledge */
 #define HECC_CANAA		0x14	/* Abort acknowledge */
 #define HECC_CANRMP		0x18	/* Receive message pending */
-#define HECC_CANRML		0x1C	/* Remote message lost */
+#define HECC_CANRML		0x1C	/* Receive message lost */
 #define HECC_CANRFP		0x20	/* Remote frame pending */
 #define HECC_CANGAM		0x24	/* SECC only:Global acceptance mask */
 #define HECC_CANMC		0x28	/* Master control */
@@ -385,8 +385,17 @@ static void ti_hecc_start(struct net_device *ndev)
 	/* Enable tx interrupts */
 	hecc_set_bit(priv, HECC_CANMIM, BIT(HECC_MAX_TX_MBOX) - 1);
=20
-	/* Prevent message over-write & Enable interrupts */
-	hecc_write(priv, HECC_CANOPC, HECC_SET_REG);
+	/* Prevent message over-write to create a rx fifo, but not for the
+	 * lowest priority mailbox, since that allows detecting overflows
+	 * instead of the hardware silently dropping the messages. The lowest
+	 * rx mailbox is one above the tx ones, hence its mbxno is the number
+	 * of tx mailboxes.
+	 */
+	mbxno =3D HECC_MAX_TX_MBOX;
+	mbx_mask =3D ~BIT(mbxno);
+	hecc_write(priv, HECC_CANOPC, mbx_mask);
+
+	/* Enable interrupts */
 	if (priv->use_hecc1int) {
 		hecc_write(priv, HECC_CANMIL, HECC_SET_REG);
 		hecc_write(priv, HECC_CANGIM, HECC_CANGIM_DEF_MASK |
@@ -531,6 +540,7 @@ static unsigned int ti_hecc_mailbox_read(struct can_rx_=
offload *offload,
 {
 	struct ti_hecc_priv *priv =3D rx_offload_to_priv(offload);
 	u32 data, mbx_mask;
+	int lost;
=20
 	mbx_mask =3D BIT(mbxno);
 	data =3D hecc_read_mbx(priv, mbxno, HECC_CANMID);
@@ -552,9 +562,12 @@ static unsigned int ti_hecc_mailbox_read(struct can_rx=
_offload *offload,
 	}
=20
 	*timestamp =3D hecc_read_stamp(priv, mbxno);
+	lost =3D hecc_read(priv, HECC_CANRML) & mbx_mask;
+	if (unlikely(lost))
+		priv->offload.dev->stats.rx_fifo_errors++;
 	hecc_write(priv, HECC_CANRMP, mbx_mask);
=20
-	return 1;
+	return !lost;
 }
=20
 static int ti_hecc_error(struct net_device *ndev, int int_status,
--=20
2.17.1

