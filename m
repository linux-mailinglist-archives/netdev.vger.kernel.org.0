Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09967E7D0F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbfJ1XgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:36:05 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731790AbfJ1XgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEnoN/AZS93Krm2wwq6hRqT/Mv6ZmMCei7WovaKitf+E7BFAMv5pdYER69n+MehhLYw0FMX2ZHsBbweMUAuphKA2e0GS6pt8ZyN1pfIVl8zKE8d3ypN1Qc4U16fERfqmyUeBHa05THNhO4GmL6I8PB3fhcnKB+x0ijoJqDyKZBTBqg9Min5A3R37M5zqOmVGI9ruO27PKFmvF5IkEH8F75B0r+dMWO6ot6qgTqbZCDwCGYo0pJpeRXMEsbzBYsE+b9ye2zzHYrFgLKr1m3pVo6LTf0j+jex5pxIshB+AA/sGl4illp17EmvMR36h79Ej8nwdYR1g50qHeo7BVSJjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIpfFwzxnKHJu5eUJWr+ULwQqlHet1GL+Y5UIhaY9Fk=;
 b=bCnuaaH6Nh1vEOET8jWFKdVjfrn9hhXJWWxoA3xOq529gPbTQ8H8tRP99p7XqC6lte8QHN84ym9/LcdSHPSab3uLuSqoEjr52je2sXjapdYxNEjd7DsG9vNnUK3EIe8TYM2JW30ceHZK/7Kprb6FOZH2tWvmwIhbksj0QQYKxEb0Dckruq0XZMvq7r3DYaJTAgr/RHmAjQu6CD9XkUmQpuubvMi/h3WwcEQUJOlXsrQY+LmtV/VzwFnqm6tDpWJqm8cQ9kHSfQ14z0Z7I7ED+dGCfisZYFACmhpzrpbBNnkCPdiUNB1KlnDZQqT3nOd7O/xUF1cRasanNBEX5HovBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIpfFwzxnKHJu5eUJWr+ULwQqlHet1GL+Y5UIhaY9Fk=;
 b=XCQ4LjsAwEA/tmoIUVVb0POTlhVz6k78dcJ2lTEAd1mUccCVXbzUNbIE5IdHUnoLVKWImCkv8hvA9EU7t/6fHt1b3zz42SvM+mnpwBdnSk+O118iTS/3nyjaCbdwkrrkpiGGqVPCrUO+u1gKb7lqP/WfYNaGF6ZoN0ncClcCPlQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 09/18] net/mlx5: Tide up state_lock and vport
 enabled flag usage
Thread-Topic: [PATCH mlx5-next 09/18] net/mlx5: Tide up state_lock and vport
 enabled flag usage
Thread-Index: AQHVjehYKMUy+1ZZHUKdh6qclK6I8Q==
Date:   Mon, 28 Oct 2019 23:35:13 +0000
Message-ID: <20191028233440.5564-10-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c724b08-87b0-4527-8caf-08d75bff7afd
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448E79C8070CBDE086B60A1BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eDPrkZjKLp68HDqiDxxGTCWy5W49dhr9qcWdpeKdXLQGOjeCavMLkJo4v3dnUVOIDw0Y2sfcE9/dHmU8w3MANRt1I1IMlr/9kPiF9KTmRXRNPt3hOHLyD+tEmX3J1omJQ+3mGpdmKAk1YrfwQ8wg9QoOo6hEVzaZpnQ1Bnvn8y3IkFPYDb5PD5jaXwttUt0iPVQ0E3bAM7kJj4XQWF3zBXpbVyRbS8KHC7N64qWcA3+ni2DZ1p2mWY4vPPklngBWmrEKmX1tGK6J6n0sLQf1mRZODSwcLMg4umMmH35al06eJrlSHVjiuKm3fULUm4E7g/aMmSAAwcWGXnazDiludvHj8++spQB4k5yJiFrhHMYAyGbJkUJi9KbrgoYPMrLeUHfp7xYvn3Sbt79QOKn9qciUoffdhCRK+uLYNEjqISrn1d12o4qiLoFMJQ1q4I3A
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c724b08-87b0-4527-8caf-08d75bff7afd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:13.6078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KJHU0IZbqavm5kNLBsVPeAO7MsyOP+8b8rYP7ZnHWYd6j8p0e1b8qXi3EP4vGihAWEnV+bzro3Uf6JIZBQIutw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When eswitch is disabled, vport event handler is unregistered.
This unregistration already synchronizes with running EQ event handler
in below code flow.

mlx5_eswitch_disable()
  mlx5_eswitch_event_handlers_unregister()
    mlx5_eq_notifier_unregister()
      atomic_notifier_chain_unregister()
        synchronize_rcu()

notifier_callchain
  eswitch_vport_event()
    queue_work()

Additionally vport->enabled flag is set under state_lock during
esw_enable_vport() but is not read under state_lock in
(a) esw_disable_vport() and (b) under atomic context
eswitch_vport_event().

It is also necessary to synchronize with already scheduled vport event.
This is already achieved using below sequence.

mlx5_eswitch_event_handlers_unregister()
  [..]
  flush_workqueue()

Hence,
(a) Remove vport->enabled check in eswitch_vport_event() which
doesn't make any sense.
(b) Remove redundant flush_workqueue() on every vport disable.
(c) Keep esw_disable_vport() symmetric with esw_enable_vport() for
state_lock.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 0dd5e5d5ea35..f15ffb8f5cac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1750,18 +1750,16 @@ static void esw_disable_vport(struct mlx5_eswitch *=
esw,
 {
 	u16 vport_num =3D vport->vport;
=20
+	mutex_lock(&esw->state_lock);
 	if (!vport->enabled)
-		return;
+		goto done;
=20
 	esw_debug(esw->dev, "Disabling vport(%d)\n", vport_num);
 	/* Mark this vport as disabled to discard new events */
 	vport->enabled =3D false;
=20
-	/* Wait for current already scheduled events to complete */
-	flush_workqueue(esw->work_queue);
 	/* Disable events from this vport */
 	arm_vport_context_events_cmd(esw->dev, vport->vport, 0);
-	mutex_lock(&esw->state_lock);
 	/* We don't assume VFs will cleanup after themselves.
 	 * Calling vport change handler while vport is disabled will cleanup
 	 * the vport resources.
@@ -1780,6 +1778,8 @@ static void esw_disable_vport(struct mlx5_eswitch *es=
w,
 		esw_legacy_vport_destroy_drop_counters(vport);
 	}
 	esw->enabled_vports--;
+
+done:
 	mutex_unlock(&esw->state_lock);
 }
=20
@@ -1793,12 +1793,8 @@ static int eswitch_vport_event(struct notifier_block=
 *nb,
=20
 	vport_num =3D be16_to_cpu(eqe->data.vport_change.vport_num);
 	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return NOTIFY_OK;
-
-	if (vport->enabled)
+	if (!IS_ERR(vport))
 		queue_work(esw->work_queue, &vport->vport_change_handler);
-
 	return NOTIFY_OK;
 }
=20
--=20
2.21.0

