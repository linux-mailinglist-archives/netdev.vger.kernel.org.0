Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEEA7E3A2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388859AbfHAT5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:15 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:25762
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388797AbfHAT5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWljMrIZAp/sVK9X8UVBFdejqjU52iOmNclwlF7FcODUASAuiI64wsZUjFD9+UJJLiDt9mGMxAnNIT2cPS/ewstMz2UV9rBN6muPKixO48B9J1ZQcmrCIXv3P7Jx7ikeL7Ss8Lu1ITUuGLuUTL9wSCGkAHjRresg3kfGeARvBVxZk94wR3F87Qt0XRlcDw5MFzev8+KiXfE3oEQObuk49hwKeksT4W+JxQdravVLKLAVzASBdz3ALyYpw4YVF3yeFOS8+NFiuBmlK1LQdQ7SoNavzoefjd0hA9LUpGPXAdh/Nc6KI2XtbnnyfEQJ59CDpBU+FpZV1g+8FzLqQzMJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqmYuAlbg55vKhtRPWnuRFwUQ+Zu62z2DGwIRmq5Y/0=;
 b=IgnB73d2uoMxTFW1XdJ5kmP56bXnBnxkumc8RTSYJb4I2iwUCgKXa0QBlV0ZRcoCb2wosO56Tm0oaTjAkSbdNQTbSIOZ93kAuPVYq7rmc0dISvE89hEDs+jcX69OnnpcBG3hVAeWmBCB9/sjxPnZ7AhEkTj1Haqswq9QI7KpXvYTwns6/A9BBXh49Z4vFQh7PyWjx4HGG8jeESUSXTmchONTFC9Hb/JgXR++gWo9OXL1CH8ubdYxFuV8j+nRelNpNsVwJ5ja5rGbMQd37qa+Asvb+yOdAjo2Ie4EhAMf9WDdJq9yQq80GR9pHd6inRdi1uB2ztDwbO93UZGvKnXgaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqmYuAlbg55vKhtRPWnuRFwUQ+Zu62z2DGwIRmq5Y/0=;
 b=mRvs0uDb+XPzp4x1oROTj/UA7sM5Bqf68D01bZuF9OzalEM/od0vtfigJLFZ1IfzF+3Qm98Zd8d4urNcYkTNwNawC9vcJA8TG3EV81+rS/jhuSJUAd/NzCkadiHjaWhPcYI8+LpgGMs2PJB9Fs09dZ2nBg9e8sqj6+mYpnPWMyc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Topic: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Index: AQHVSKNDPnW5aHKn80u4pfZRmdQ1/A==
Date:   Thu, 1 Aug 2019 19:56:52 +0000
Message-ID: <20190801195620.26180-2-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 449c85ca-22a1-41e5-0cc1-08d716ba6594
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759E3485F12D115EACC96C2BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lHvPoIVww+X4752KprXdQC+pQUNN4dvHVq69zYQ+J17ABvx4HHGiqFTtSVJLEJCdyqG4r3K27EANQtFTjQnJzkFFVB4VH3spYt5Jxa1yFjkSbzQyTnSCpo0DTE9GUcpaqUaQdCAONrfSEdAU2mTti22JigG7ASSeyK7OJUoR5/ZAtsO7tVemOP9S6iu5VTzAerhsFcl+CWIEeKXsJX6sF80TmjBsfcml81FcuXeJZIODIsJKFM7cyY6BrHuZ4v6jrG89iqOP4UwrozV144X00UKGmCTRNbaB9v8PlRct3cXsTNNnxheoFAaX02zGF6bloFi6T0bHkZH8rIjEFAE/iau5IoG2xbdYxrzXDP0jGJSkHU6CyVcf6kODTZQT18UxiBfDKzM+gYzVp05fobX9d9B4nEkNazLARLa3ljqTZ3k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449c85ca-22a1-41e5-0cc1-08d716ba6594
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:52.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Use the scheduling elements to implement ingress rate limiter on an
eswitch ports ingress traffic. Since the ingress of eswitch port is the
egress of VF port, we control eswitch ingress by controlling VF egress.

Configuration is done using the ports' representor net devices.

Please note that burst size configuration is not supported by devices
ConnectX-5 and earlier generations.

Configuration examples:
tc:
tc filter add dev enp59s0f0_0 root protocol ip matchall action police rate =
1mbit burst 20k

ovs:
ovs-vsctl set interface eth0 ingress_policing_rate=3D1000

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  19 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 100 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   7 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  16 +++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 6 files changed, 145 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 6edf0aeb1e26..bf6f4835457e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1156,6 +1156,23 @@ mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *pri=
v,
 	}
 }
=20
+static
+int mlx5e_rep_setup_tc_cls_matchall(struct mlx5e_priv *priv,
+				    struct tc_cls_matchall_offload *ma)
+{
+	switch (ma->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return mlx5e_tc_configure_matchall(priv, ma);
+	case TC_CLSMATCHALL_DESTROY:
+		return mlx5e_tc_delete_matchall(priv, ma);
+	case TC_CLSMATCHALL_STATS:
+		mlx5e_tc_stats_matchall(priv, ma);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 				 void *cb_priv)
 {
@@ -1165,6 +1182,8 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type t=
ype, void *type_data,
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, flags);
+	case TC_SETUP_CLSMATCHALL:
+		return mlx5e_rep_setup_tc_cls_matchall(priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 10fafd5fa17b..43eeebe9c8d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -88,6 +88,7 @@ struct mlx5e_rep_priv {
 	struct mlx5_flow_handle *vport_rx_rule;
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
+	struct rtnl_link_stats64 prev_vf_vport_stats;
 	struct devlink_port dl_port;
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index f3ed028d5017..dc5fc3350b65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3638,6 +3638,106 @@ int mlx5e_stats_flower(struct net_device *dev, stru=
ct mlx5e_priv *priv,
 	return err;
 }
=20
+static int apply_police_params(struct mlx5e_priv *priv, u32 rate,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
+	struct mlx5_eswitch *esw;
+	u16 vport_num;
+	u32 rate_mbps;
+	int err;
+
+	esw =3D priv->mdev->priv.eswitch;
+	/* rate is given in bytes/sec.
+	 * First convert to bits/sec and then round to the nearest mbit/secs.
+	 * mbit means million bits.
+	 * Moreover, if rate is non zero we choose to configure to a minimum of
+	 * 1 mbit/sec.
+	 */
+	rate_mbps =3D rate ? max_t(u32, (rate * 8 + 500000) / 1000000, 1) : 0;
+	vport_num =3D rpriv->rep->vport;
+
+	err =3D mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "failed applying action to hardware");
+
+	return err;
+}
+
+static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
+					struct flow_action *flow_action,
+					struct netlink_ext_ack *extack)
+{
+	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
+	const struct flow_action_entry *act;
+	int err;
+	int i;
+
+	if (!flow_action_has_entries(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "matchall called with no action");
+		return -EINVAL;
+	}
+
+	if (!flow_offload_has_one_action(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "matchall policing support only a single acti=
on");
+		return -EOPNOTSUPP;
+	}
+
+	flow_action_for_each(i, act, flow_action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			err =3D apply_police_params(priv, act->police.rate_bytes_ps, extack);
+			if (err)
+				return err;
+
+			rpriv->prev_vf_vport_stats =3D priv->stats.vf_vport;
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "mlx5 supports only police action for matcha=
ll");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
+				struct tc_cls_matchall_offload *ma)
+{
+	struct netlink_ext_ack *extack =3D ma->common.extack;
+	int prio =3D TC_H_MAJ(ma->common.prio) >> 16;
+
+	if (prio !=3D 1) {
+		NL_SET_ERR_MSG_MOD(extack, "only priority 1 is supported");
+		return -EINVAL;
+	}
+
+	return scan_tc_matchall_fdb_actions(priv, &ma->rule->action, extack);
+}
+
+int mlx5e_tc_delete_matchall(struct mlx5e_priv *priv,
+			     struct tc_cls_matchall_offload *ma)
+{
+	struct netlink_ext_ack *extack =3D ma->common.extack;
+
+	return apply_police_params(priv, 0, extack);
+}
+
+void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
+			     struct tc_cls_matchall_offload *ma)
+{
+	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
+	struct rtnl_link_stats64 cur_stats;
+	u64 dbytes;
+	u64 dpkts;
+
+	cur_stats =3D priv->stats.vf_vport;
+	dpkts =3D cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
+	dbytes =3D cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
+	rpriv->prev_vf_vport_stats =3D cur_stats;
+	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies);
+}
+
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 					      struct mlx5e_priv *peer_priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index 1cb66bf76997..20f045e96c92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -63,6 +63,13 @@ int mlx5e_delete_flower(struct net_device *dev, struct m=
lx5e_priv *priv,
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f, unsigned long flags);
=20
+int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
+				struct tc_cls_matchall_offload *f);
+int mlx5e_tc_delete_matchall(struct mlx5e_priv *priv,
+			     struct tc_cls_matchall_offload *f);
+void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
+			     struct tc_cls_matchall_offload *ma);
+
 struct mlx5e_encap_entry;
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			      struct mlx5e_encap_entry *e);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index f4ace5f8e884..5fbebee7254d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1585,6 +1585,22 @@ static int esw_vport_qos_config(struct mlx5_eswitch =
*esw,
 	return 0;
 }
=20
+int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
+			       u32 rate_mbps)
+{
+	u32 ctx[MLX5_ST_SZ_DW(scheduling_context)] =3D {};
+	struct mlx5_vport *vport;
+
+	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
+
+	return mlx5_modify_scheduling_element_cmd(esw->dev,
+						  SCHEDULING_HIERARCHY_E_SWITCH,
+						  ctx,
+						  vport->qos.esw_tsar_ix,
+						  MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW);
+}
+
 static void node_guid_gen_from_mac(u64 *node_guid, u8 mac[ETH_ALEN])
 {
 	((u8 *)node_guid)[7] =3D mac[0];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 4a03fdadb47e..804912e38dee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -261,6 +261,8 @@ void esw_vport_disable_ingress_acl(struct mlx5_eswitch =
*esw,
 				   struct mlx5_vport *vport);
 void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 					       struct mlx5_vport *vport);
+int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
+			       u32 rate_mbps);
=20
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
--=20
2.21.0

