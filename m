Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C217132F20
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgAGTO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:28 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728770AbgAGTO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9iGHaISGIbI26VzZLKruA+mtnDMEAZWIKRpBbRNndIAQQAlKll3wS2P8vz0MyzRDIBLBKL7YeQwlUxAovc9A0cP94N0WTnLnLtC3+TQRKA3VD3o5tAx7+WdsSgGAXiZEd/g4joFXNsX+VKuDWb7cXzwvWkPhxFIrXTQmcz+pex0gsOR7MUGoVewh7EGvqTIhXnUa0DXYfDSCxWDnxO+rXCdxsl2N5cfgdxE9J3RRDcQC7d1Be5IR0fJuAEY9krto58ZB46+7nnNO9DtlsT1nvgpNqC4bsROo83M/O1tuq2xFkgVgks87eH5QVD/eUKx2Q99PbfH022+gB1CAUPxJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B91BeKX20nvVM5HGa/mx5U/yX6HLdmc0TFL9QZBhRoA=;
 b=mKsPXP7CiNCOQ8cJDAQCRbrdhTfu/dYNOp9x6v2DPgNzebWAOKTBy6qCDOv94Q7zAl6TbpGf4Mr9x2La+v7bcaQDOpSH6uC4gHKSjLmmI2DWY7ASasndkA3xLMCiC2o9xuubUXAEsfP8mjjhJf9OwpDAR41reogdY1t9mfGez2cSDWN47CLwZZ3qY4pqXUIyVCj4kCtBgnM8sSwSA8ks2T2Ragv1Vw+vPTZqE3Mabbberm8XWPfInbykncpKtbl7mFnvtYGSrTFffnqsKL4tFvvFZli5lKbJ5xulBwGnuEusZa+ZxXsLiuOxft4xpVs6aZaaaR7lL83h9coHedG3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B91BeKX20nvVM5HGa/mx5U/yX6HLdmc0TFL9QZBhRoA=;
 b=Aj3GnOElVXzagPgKdPmfneT1lGGg5obP80oCR/VqzLEQEXed7c1dtjzP1h3sLifrw4peu6uCozsMwqQKvxHvYk7npCHXz8GUtx5jb0s1qPSEDCWXHhwtdY3YJAYqqJtaSFdTIPfF2WiglbcHcR3qG64ZvPhGIxaOgk/AnTc0fbA=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:18 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:18 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/13] net/mlx5: DR, Create FTE entry in the FW from
 SW-steering
Thread-Topic: [net-next 08/13] net/mlx5: DR, Create FTE entry in the FW from
 SW-steering
Thread-Index: AQHVxY6o0W+R2dEPP0SUep3p2EQ7qw==
Date:   Tue, 7 Jan 2020 19:14:18 +0000
Message-ID: <20200107191335.12272-9-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b995c6a8-52a2-4e58-4578-08d793a5cb22
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411673A6F63E8E28DA2D1DBBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fR2wp6XCV6rTx5PgrVng3Z25KffRKDYFHfdwUfmB5EBEay3a5RJ6EUPae91p48vCcDTX8307G2O26ba5TdYZusDEgVLOfDgZc/CEo9VF88bdJjorIvkWZvOqkUwV/dFIQL0i4ZGpuqIlCkE6fLz/fgcDFjbpIk/N/pAfbszsIFO6MyT4z9GGfYHKIWbiO1McajB0b3Lg0ebEI4UCRmt0LS3uZlkPgFkZsXAn26gADGXS7eVEIl96qLqBrMh9PIlyWbe7TKF+bxovqYOTfyocUNzG/YU+ucPRoW9DWbdg/6nF4dmvfKkMQTNs4yw3FA8dvZ+4PtPU5inBInhpB2Cp1R/V//YAr8NF9saFHVhG7d1VokGqJa85j/4a3xddkDOQ0JndBIjP9JyYrvGlZ8D6RdwTlLnwUTmOe02w3sxqCKyouqO/tk8Y7OCOIRejcYNGg4SfL7N4oRX2Ko0cVrNG88+6Kb0AJ5iBj7QWM49b+OrDZDtVFhlTan1mqfaWdLKQB0wRrxxHZbjkxC3sUOltc5fV28470ZVA2x8+xPhtTkQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b995c6a8-52a2-4e58-4578-08d793a5cb22
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:18.5221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C7yQIAl7Zrr6d1OEyt3jcESOgen2cnnhvORoafN0OE9auGQsN55anYuYFV80PD/JCWBhG8lmP7qiF3w9n12NZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Implement the FW command to setup a FTE (Flow Table Entry) into the FW
managed flow tables.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 205 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  37 ++++
 2 files changed, 242 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index ec35b297dcab..461b39376daf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -479,3 +479,208 @@ int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, =
u8 vhca_port_num,
=20
 	return 0;
 }
+
+static int mlx5dr_cmd_set_extended_dest(struct mlx5_core_dev *dev,
+					struct mlx5dr_cmd_fte_info *fte,
+					bool *extended_dest)
+{
+	int fw_log_max_fdb_encap_uplink =3D MLX5_CAP_ESW(dev, log_max_fdb_encap_u=
plink);
+	int num_fwd_destinations =3D 0;
+	int num_encap =3D 0;
+	int i;
+
+	*extended_dest =3D false;
+	if (!(fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
+		return 0;
+	for (i =3D 0; i < fte->dests_size; i++) {
+		if (fte->dest_arr[i].type =3D=3D MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+			continue;
+		if (fte->dest_arr[i].type =3D=3D MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		    fte->dest_arr[i].vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
+			num_encap++;
+		num_fwd_destinations++;
+	}
+
+	if (num_fwd_destinations > 1 && num_encap > 0)
+		*extended_dest =3D true;
+
+	if (*extended_dest && !fw_log_max_fdb_encap_uplink) {
+		mlx5_core_warn(dev, "FW does not support extended destination");
+		return -EOPNOTSUPP;
+	}
+	if (num_encap > (1 << fw_log_max_fdb_encap_uplink)) {
+		mlx5_core_warn(dev, "FW does not support more than %d encaps",
+			       1 << fw_log_max_fdb_encap_uplink);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
+		       int opmod, int modify_mask,
+		       struct mlx5dr_cmd_ft_info *ft,
+		       u32 group_id,
+		       struct mlx5dr_cmd_fte_info *fte)
+{
+	u32 out[MLX5_ST_SZ_DW(set_fte_out)] =3D {};
+	void *in_flow_context, *vlan;
+	bool extended_dest =3D false;
+	void *in_match_value;
+	unsigned int inlen;
+	int dst_cnt_size;
+	void *in_dests;
+	u32 *in;
+	int err;
+	int i;
+
+	if (mlx5dr_cmd_set_extended_dest(dev, fte, &extended_dest))
+		return -EOPNOTSUPP;
+
+	if (!extended_dest)
+		dst_cnt_size =3D MLX5_ST_SZ_BYTES(dest_format_struct);
+	else
+		dst_cnt_size =3D MLX5_ST_SZ_BYTES(extended_dest_format);
+
+	inlen =3D MLX5_ST_SZ_BYTES(set_fte_in) + fte->dests_size * dst_cnt_size;
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(set_fte_in, in, opcode, MLX5_CMD_OP_SET_FLOW_TABLE_ENTRY);
+	MLX5_SET(set_fte_in, in, op_mod, opmod);
+	MLX5_SET(set_fte_in, in, modify_enable_mask, modify_mask);
+	MLX5_SET(set_fte_in, in, table_type, ft->type);
+	MLX5_SET(set_fte_in, in, table_id, ft->id);
+	MLX5_SET(set_fte_in, in, flow_index, fte->index);
+	if (ft->vport) {
+		MLX5_SET(set_fte_in, in, vport_number, ft->vport);
+		MLX5_SET(set_fte_in, in, other_vport, 1);
+	}
+
+	in_flow_context =3D MLX5_ADDR_OF(set_fte_in, in, flow_context);
+	MLX5_SET(flow_context, in_flow_context, group_id, group_id);
+
+	MLX5_SET(flow_context, in_flow_context, flow_tag,
+		 fte->flow_context.flow_tag);
+	MLX5_SET(flow_context, in_flow_context, flow_source,
+		 fte->flow_context.flow_source);
+
+	MLX5_SET(flow_context, in_flow_context, extended_destination,
+		 extended_dest);
+	if (extended_dest) {
+		u32 action;
+
+		action =3D fte->action.action &
+			~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		MLX5_SET(flow_context, in_flow_context, action, action);
+	} else {
+		MLX5_SET(flow_context, in_flow_context, action,
+			 fte->action.action);
+		if (fte->action.pkt_reformat)
+			MLX5_SET(flow_context, in_flow_context, packet_reformat_id,
+				 fte->action.pkt_reformat->id);
+	}
+	if (fte->action.modify_hdr)
+		MLX5_SET(flow_context, in_flow_context, modify_header_id,
+			 fte->action.modify_hdr->id);
+
+	vlan =3D MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan);
+
+	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan[0].ethtype);
+	MLX5_SET(vlan, vlan, vid, fte->action.vlan[0].vid);
+	MLX5_SET(vlan, vlan, prio, fte->action.vlan[0].prio);
+
+	vlan =3D MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan_2);
+
+	MLX5_SET(vlan, vlan, ethtype, fte->action.vlan[1].ethtype);
+	MLX5_SET(vlan, vlan, vid, fte->action.vlan[1].vid);
+	MLX5_SET(vlan, vlan, prio, fte->action.vlan[1].prio);
+
+	in_match_value =3D MLX5_ADDR_OF(flow_context, in_flow_context,
+				      match_value);
+	memcpy(in_match_value, fte->val, sizeof(u32) * MLX5_ST_SZ_DW_MATCH_PARAM)=
;
+
+	in_dests =3D MLX5_ADDR_OF(flow_context, in_flow_context, destination);
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+		int list_size =3D 0;
+
+		for (i =3D 0; i < fte->dests_size; i++) {
+			unsigned int id, type =3D fte->dest_arr[i].type;
+
+			if (type =3D=3D MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
+
+			switch (type) {
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
+				id =3D fte->dest_arr[i].ft_num;
+				type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
+				id =3D fte->dest_arr[i].ft_id;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
+				id =3D fte->dest_arr[i].vport.num;
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_eswitch_owner_vhca_id_valid,
+					 !!(fte->dest_arr[i].vport.flags &
+					    MLX5_FLOW_DEST_VPORT_VHCA_ID));
+				MLX5_SET(dest_format_struct, in_dests,
+					 destination_eswitch_owner_vhca_id,
+					 fte->dest_arr[i].vport.vhca_id);
+				if (extended_dest && (fte->dest_arr[i].vport.flags &
+						    MLX5_FLOW_DEST_VPORT_REFORMAT_ID)) {
+					MLX5_SET(dest_format_struct, in_dests,
+						 packet_reformat,
+						 !!(fte->dest_arr[i].vport.flags &
+						    MLX5_FLOW_DEST_VPORT_REFORMAT_ID));
+					MLX5_SET(extended_dest_format, in_dests,
+						 packet_reformat_id,
+						 fte->dest_arr[i].vport.reformat_id);
+				}
+				break;
+			default:
+				id =3D fte->dest_arr[i].tir_num;
+			}
+
+			MLX5_SET(dest_format_struct, in_dests, destination_type,
+				 type);
+			MLX5_SET(dest_format_struct, in_dests, destination_id, id);
+			in_dests +=3D dst_cnt_size;
+			list_size++;
+		}
+
+		MLX5_SET(flow_context, in_flow_context, destination_list_size,
+			 list_size);
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		int max_list_size =3D BIT(MLX5_CAP_FLOWTABLE_TYPE(dev,
+					log_max_flow_counter,
+					ft->type));
+		int list_size =3D 0;
+
+		for (i =3D 0; i < fte->dests_size; i++) {
+			if (fte->dest_arr[i].type !=3D
+			    MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+				continue;
+
+			MLX5_SET(flow_counter_list, in_dests, flow_counter_id,
+				 fte->dest_arr[i].counter_id);
+			in_dests +=3D dst_cnt_size;
+			list_size++;
+		}
+		if (list_size > max_list_size) {
+			err =3D -EINVAL;
+			goto err_out;
+		}
+
+		MLX5_SET(flow_context, in_flow_context, flow_counter_list_size,
+			 list_size);
+	}
+
+	err =3D mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+err_out:
+	kvfree(in);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index bc82b76cf04e..09ac9aadad1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1057,6 +1057,43 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5d=
r_domain *dmn,
 int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 				struct mlx5dr_action *action);
=20
+struct mlx5dr_cmd_ft_info {
+	u32 id;
+	u16 vport;
+	enum fs_flow_table_type type;
+};
+
+struct mlx5dr_cmd_flow_destination_hw_info {
+	enum mlx5_flow_destination_type type;
+	union {
+		u32 tir_num;
+		u32 ft_num;
+		u32 ft_id;
+		u32 counter_id;
+		struct {
+			u16 num;
+			u16 vhca_id;
+			u32 reformat_id;
+			u8 flags;
+		} vport;
+	};
+};
+
+struct mlx5dr_cmd_fte_info {
+	u32 dests_size;
+	u32 index;
+	struct mlx5_flow_context flow_context;
+	u32 *val;
+	struct mlx5_flow_act action;
+	struct mlx5dr_cmd_flow_destination_hw_info *dest_arr;
+};
+
+int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
+		       int opmod, int modify_mask,
+		       struct mlx5dr_cmd_ft_info *ft,
+		       u32 group_id,
+		       struct mlx5dr_cmd_fte_info *fte);
+
 struct mlx5dr_fw_recalc_cs_ft {
 	u64 rx_icm_addr;
 	u32 table_id;
--=20
2.24.1

